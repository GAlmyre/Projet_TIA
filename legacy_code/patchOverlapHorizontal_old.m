function result = patchOverlapHorizontal(overlapA, patchB, PATCH_SIZE, PATCH_OVERLAP)
    
    overlapB = patchB(:, 1:PATCH_OVERLAP, :);
    
    path = calcMinCutVertical(overlapA, overlapB);
    [hp, wp] = size(path);
    %patch_path
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
    
