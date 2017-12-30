function [result, ssd_tab] = getBestPatch(src, overlap, src_map, overlap_dst_map, alpha, overlapMask, patchSize)
    [src_h, src_w, src_c] = size(src);
    nb_candidates = (src_h-patchSize+1) * (src_w-patchSize+1);
    candidates = ones(nb_candidates, 3);
    candidate_id = 1;
    overlap = overlap .* overlapMask;
    ssd_tab = zeros(src_h-patchSize+1, src_w-patchSize+1);
    for i=1:src_h-patchSize+1
        for j=1:src_w-patchSize+1
        patch = getImagePatch(src, [i, j], patchSize);
        map_patch = getImagePatch(src_map, [i, j], patchSize);
        ssd_tab(i,j) = alpha * ssd(patch.*overlapMask, overlap) ...
                     + (1 - alpha) * ssd(map_patch, overlap_dst_map);
        candidates(candidate_id, :) = [ssd_tab(i,j),...%ssd(patch.*overlapMask, overlap),...
                                       i, j];
        candidate_id = candidate_id+1;
        end
    end
    candidates;
    [minVal, minInd] = min(candidates(:, 1));
    if minVal == 0
        candidates(minInd,1) = 1000;
        [minVal, minInd] = min(candidates(:, 1)) 
    end
    searchVal = 1.1 * minVal;
    cand_idx = candidates(:,1) <= searchVal;
    nb_c = nnz(cand_idx)
    new_candidates = candidates(cand_idx, :)
    result = getImagePatch(src, new_candidates(randi([1, nb_c]), 2:3), patchSize);
end