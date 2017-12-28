function result = patchOverlapVertical(overlapA, patchB, PATCH_SIZE, PATCH_OVERLAP)
    
    overlapB = patchB(1:PATCH_OVERLAP, :, :);
    
    overlap_error = (sum(overlapA,3)-sum(overlapB,3)).^2;
    [e_h, e_w] = size(overlap_error);


    %on calcule l'erreur cumulée de gauche en droite
    cumul_error = zeros(e_h, e_w);
    cumul_error(:, 1) = overlap_error(:, 1);
    for j=2:e_w
        for i=1:e_h
            prev_min = min(cumul_error(max(1,i-1):min(e_h,i+1), j-1));
            cumul_error(i,j) = overlap_error(i,j) + prev_min;         
        end
    end
    
    path = zeros(e_h, e_w);
    %on cherche le chemin ayant la plus faible erreur cumulée de bas en haut
    [min_val, ind] = min(cumul_error(:,e_w));
    i = ind;
    path(i,e_w) = 1;

    for j=e_w-1:-1:1
        bound_min = max(1, i-1);
        bound_max = min(e_h, i+1);
        [min_val, ind] = min(cumul_error(bound_min:bound_max, j));
        i = ind + bound_min -1;
        path(i, j) = 1;
    end

    [hp, wp] = size(path);
    s = hp*wp;
    %on construit le masque du dessus en faisant un imfill sur toute la
    %première ligne et en lui soustrayant le path
    TopMask = bsxfun(@minus,...
                      imfill(logical(path), transpose([1:hp:wp*hp])), ...
                      path);
    %on construit le masque de droite en faisant un imfill sur toute la
    %dernière colonne et en lui soustrayant le path
    BottomMask = bsxfun(@minus,...
                       imfill(logical(path), transpose([hp:hp:s])), ...
                       path);

    %on utilise LeftMask, RightMask et path pour extraire la partie gauche de
    %l'overlap à partir de patchA, la partie droite à partir de patchB et le
    %path (au milieu) est la moyenne des pixels des deux patchs
    overlapTop = bsxfun(@times, overlapA, cast(TopMask, 'like', overlapA));
    overlapBottom = bsxfun(@times, overlapB, cast(BottomMask, 'like', overlapB));
    overlapMiddle = bsxfun(@plus,...
                           0.5 * bsxfun(@times, overlapA, cast(path, 'like', overlapA)),...
                           0.5 * bsxfun(@times, overlapB, cast(path, 'like', overlapA)));
    overlap = bsxfun(@plus, overlapTop, overlapBottom);
    overlap = bsxfun(@plus, overlap, overlapMiddle);
    result = zeros(PATCH_SIZE, PATCH_SIZE, 3);
    [h, w, c] = size(result);
    %on copie dans résult les zones qui ne sont pas dans l'overlap
    result(PATCH_OVERLAP+1:PATCH_SIZE, :, :) = patchB(PATCH_OVERLAP+1:PATCH_SIZE,:,:);
    result(1:PATCH_OVERLAP, :, :) = overlap;
    %clf();
    %subplot(2,2,1);
    %imagesc(cumul_error);
    %subplot(2,2,2);
    %imagesc(path);
    %subplot(2,2,3);
    %imagesc(TopMask);
    %subplot(2,2,4);
    %imagesc(BottomMask);