function res = getImagePatch(im, pos, patch_size)
    res = im(pos(1):pos(1)+patch_size-1,...
             pos(2):pos(2)+patch_size-1,...
             :);
