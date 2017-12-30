function [result, ssd_tab] = getBestPatch(src, overlap, overlapMask, patchSize)
    [src_h, src_w, src_c] = size(src);
    nb_candidates = (src_h-patchSize+1) * (src_w-patchSize+1);
    candidates = ones(nb_candidates, 3);
    candidate_id = 1;
    overlap = sum(overlap, 3)/3 .* overlapMask;
    src_gray = sum(src, 3)/3;
    srcsq = src_gray .* src_gray;
    %(p1-p2)² == p1² - 2p1p2 + p2²
%     ssd_tab = conv2(srcsq, fliplr(flipud(overlapMask)), 'valid') ...
%             - 2*conv2(src_gray, fliplr(flipud(overlap.*overlapMask)), 'valid') ...
%             + sum(sum((overlap.*overlap).*overlapMask));
     %ssd_tab = conv2(src_gray.*src_gray, rot90(overlapMask,2), 'valid') ...
     %        - 2*conv2(src_gray, rot90(overlap.*overlapMask,2), 'valid') ...
     %        + sum(sum((overlap.*overlap).*overlapMask));
    ssd_tab = filter2(overlapMask, src_gray.*src_gray, 'valid') ...
            - 2*filter2(overlap.*overlapMask, src_gray, 'valid') ...
            + sum(sum((overlap.*overlap).*overlapMask));

    
    
    val = min(ssd_tab(:));
    [i, j] = find(ssd_tab==val);
    if val < 0.01
        ssd_tab(i, j) = 100000;
        val = min(ssd_tab(:));
        ssd_tab(i, j) = 0;
        [i, j] = find(ssd_tab==val);
    end
    searchVal = 1.1 * val;
    cand_idx = ssd_tab <= searchVal;
    nb_c = nnz(cand_idx);
    new_candidates = ssd_tab(cand_idx);
    picked = new_candidates(randi([1 nb_c]));
    [i, j] = find(ssd_tab==picked);
    result = getImagePatch(src, [i j], patchSize);
    end