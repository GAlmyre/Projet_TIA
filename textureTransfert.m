function result = textureTransfert(src, src_map, dst_map, nb_it, PATCH_SIZE)
    global DISPLAY;
    
    HALF_OVERLAP = max(1,floor(PATCH_SIZE/6));
    OVERLAP = 2*HALF_OVERLAP;
    
    [src_h, src_w, src_c] = size(src);
    
    [dstm_h, dstm_w, dstm_c] = size(dst_map);
    
    %nbb = ceil([dstm_h dstm_w]/PATCH_SIZE);
    nbb = floor([dstm_h dstm_w]/PATCH_SIZE) - 1;
    
    dst_size = [nbb * PATCH_SIZE + OVERLAP, src_c];
    
    dst = zeros(dst_size);

    mask = zeros(dst_size(1:2));
    
    %padding
    
    

    if DISPLAY == true
        plotResult(src, dst);
    end
    for i=0:nbb(1)-1
        for j=0:nbb(2)-1
            %we compute where we have to copy the patch
            start_i = i*PATCH_SIZE+1;
            start_j = j*PATCH_SIZE+1;
            end_i = start_i + PATCH_SIZE+OVERLAP-1;
            end_j = start_j + PATCH_SIZE+OVERLAP-1;



            %We select a new patch
            if i==0 && j == 0%first patch is selected randomly
                ri = randi([1, src_h-(PATCH_SIZE+OVERLAP)+1]);
                rj = randi([1, src_w-(PATCH_SIZE+OVERLAP)+1]);

                patch = getImagePatch(src, [ri, rj], PATCH_SIZE+OVERLAP);
            else
                overlap = dst(start_i:end_i, start_j:end_j,:);
                overlapMask = mask(start_i:end_i, start_j:end_j);
                overlap_map = dst_map(start_i:end_i, start_j:end_j);
                %ri = randi([1, src_h-(PATCH_SIZE+OVERLAP)+1]);
                %rj = randi([1, src_w-(PATCH_SIZE+OVERLAP)+1]);

                %patch = getImagePatch(src, [ri, rj], PATCH_SIZE+OVERLAP);
                patch = getBestPatchConv2(src, overlap, src_map, overlap_map, 0.6, overlapMask, PATCH_SIZE+OVERLAP);
            end


            %we compute overlaping with already existing patches
             if i ~= 0 && j ~= 0%overlap en haut et à gauche
                overlapTop = dst(start_i:start_i+OVERLAP-1, start_j:end_j,:);
                overlapLeft = dst(start_i:end_i, start_j:start_j+OVERLAP-1,:);
                %patch = patchOverlapHorizontal(overlapLeft, patch, PATCH_SIZE+OVERLAP, OVERLAP);
                %patch = patchOverlapVertical(overlapTop, patch, PATCH_SIZE+OVERLAP, OVERLAP);
                overlap = dst(start_i:end_i, start_j:end_j,:);
                patch = patchOverlapDiagonal(overlap, patch, PATCH_SIZE+OVERLAP, OVERLAP);
            elseif j ~= 0%overlap à gauche
                overlapLeft = dst(start_i:end_i, start_j:start_j+OVERLAP-1,:);
                patch = patchOverlapHorizontal(overlapLeft, patch, PATCH_SIZE+OVERLAP, OVERLAP);
            elseif i ~= 0%overlap en haut
                overlapTop = dst(start_i:start_i+OVERLAP-1, start_j:end_j,:);
                patch = patchOverlapVertical(overlapTop, patch, PATCH_SIZE+OVERLAP, OVERLAP);

            end



            dst(start_i:end_i,...
                start_j:end_j,...
                :) = patch;
            mask(start_i:end_i,...
                start_j:end_j, :) = ones(PATCH_SIZE+OVERLAP, PATCH_SIZE+OVERLAP);

            

        end
        if DISPLAY == true
                plotResult(src, dst);
                drawnow
            end
    end
    result = dst;%(HALF_OVERLAP:HALF_OVERLAP+target_size(1)-1, ...
                 %HALF_OVERLAP:HALF_OVERLAP+target_size(2)-1, :);
    if DISPLAY == true
        plotResult(src, result);
    end
    %profile viewer
end