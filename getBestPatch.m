function result = getBestPatch(src, overlap, overlapMask, patchSize)
    [src_h, src_w, src_c] = size(src);
    nb_candidates = (src_h-patchSize+1) * (src_w-patchSize+1);
    
    overlap = sum(overlap, 3)/3 .* overlapMask;
    src_gray = sum(src, 3)/3;
    srcsq = src_gray .* src_gray;

    
    ssd_tab = sum(sum((overlap.*overlap).*overlapMask)) ...
            - 2*filter2(overlap.*overlapMask, src_gray, 'valid') ...
            + filter2(overlapMask, src_gray.*src_gray, 'valid');

    val = min(ssd_tab(:));
    [i, j] = find(ssd_tab==val);
    %if the min is 0 we want the second min to compute our error tolerance
    if val < 0.01
        ssd_tab(i, j) = 100000;
        val = min(ssd_tab(:));
        ssd_tab(i, j) = 0;
        [i, j] = find(ssd_tab==val);
    end
    searchVal = 1.1 * val;
    cand_idx = ssd_tab <= searchVal;
    nb_c = nnz(cand_idx);
    
    %we select some candidates and pick one randomly
    candidates = ssd_tab(cand_idx);
    picked = candidates(randi([1 nb_c]));
    [i, j] = find(ssd_tab==picked);
    result = getImagePatch(src, [i j], patchSize);
    end