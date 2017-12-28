function result = patchOverlapHorizontal(overlapA, patchB, PATCH_SIZE, PATCH_OVERLAP)
    
    overlapB = patchB(:, 1:PATCH_OVERLAP, :);
    
    overlap_error = (sum(overlapA,3)-sum(overlapB,3)).^2;
    [e_h, e_w] = size(overlap_error);


    %on calcule l'erreur cumulée de haut en bas
    cumul_error = zeros(e_h, e_w);
    cumul_error(1, :) = overlap_error(1, :);
    for i=2:e_h
        for j=1:e_w
            prev_min = min(cumul_error(i-1, max(1,j-1):min(e_w,j+1))); 
            cumul_error(i,j) = overlap_error(i,j) + prev_min;         
        end
    end

    path = zeros(e_h, e_w);
    %on cherche le chemin ayant la plus faible erreur cumulée de bas en haut
    [min_val, ind] = min(cumul_error(e_h,:));
    j = ind;
    path(i,j) = 1;

    for i=e_h-1:-1:1
        bound_min = max(1, j-1);
        bound_max = min(e_w, j+1);
        [min_val, ind] = min(cumul_error(i, bound_min:bound_max));
        j = ind + bound_min -1;
        path(i, j) = 1;
    end

    [hp, wp] = size(path);
    s = hp*wp;
    %on construit le masque de gauche en faisant un imfill sur toute la
    %première colonne et en lui soustrayant le path
    LeftMask = bsxfun(@minus,...
                      imfill(logical(path), transpose([1:hp])), ...
                      path);
    %on construit le masque de droite en faisant un imfill sur toute la
    %dernière colonne et en lui soustrayant le path
    RightMask = bsxfun(@minus,...
                       imfill(logical(path), transpose([s-hp+1:s])), ...
                       path);

    %on utilise LeftMask, RightMask et path pour extraire la partie gauche de
    %l'overlap à partir de patchA, la partie droite à partir de patchB et le
    %path (au milieu) est la moyenne des pixels des deux patchs
    overlapLeft = bsxfun(@times, overlapA, cast(LeftMask, 'like', overlapA));
    overlapRight = bsxfun(@times, overlapB, cast(RightMask, 'like', overlapB));
    overlapMiddle = bsxfun(@plus,...
                           0.5 * bsxfun(@times, overlapA, cast(path, 'like', overlapA)),...
                           0.5 * bsxfun(@times, overlapB, cast(path, 'like', overlapA)));
    overlap = bsxfun(@plus, overlapLeft, overlapRight);
    overlap = bsxfun(@plus, overlap, overlapMiddle);
    result = zeros(PATCH_SIZE, PATCH_SIZE, 3);
    [h, w, c] = size(result);
    %on copie dans résult les zones qui ne sont pas dans l'overlap
    result(:,PATCH_OVERLAP+1:PATCH_SIZE,:) = patchB(:,PATCH_OVERLAP+1:PATCH_SIZE,:);
    result(:, 1:PATCH_OVERLAP, :) = overlap;
    
