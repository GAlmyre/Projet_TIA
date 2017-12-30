PATCH_SIZE = 16;
HALF_OVERLAP = 5;
OVERLAP = 2*HALF_OVERLAP;

src = im2double(imread('./data/textures/radis.png'));
[src_h, src_w, src_c] = size(src);

dst_h = src_h+OVERLAP;
dst_w = src_w+OVERLAP;
dst_c = src_c;
dst = zeros(dst_h, dst_w, dst_c);

plotResult(src, patch, dst);

nbb_i = floor((dst_h-OVERLAP)/PATCH_SIZE);
nbb_j = floor((dst_w-OVERLAP)/PATCH_SIZE);

for i=0:nbb_i-1
    for j=0:nbb_j-1
        %We select a new patch
        ri = randi([1, src_h-(PATCH_SIZE+OVERLAP)+1]);
        rj = randi([1, src_w-(PATCH_SIZE+OVERLAP)+1]);

        patch = getImagePatch(src, [ri, rj], PATCH_SIZE+OVERLAP);

        %we compute where we have to copy the patch
        start_i = i*PATCH_SIZE+1;
        start_j = j*PATCH_SIZE+1;
        end_i = start_i + PATCH_SIZE+OVERLAP-1;
        end_j = start_j + PATCH_SIZE+OVERLAP-1;
        
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
        plotResult(src, patch, dst);
        pause(0.05)
    end
end
result = dst(HALF_OVERLAP:dst_h-HALF_OVERLAP, HALF_OVERLAP:dst_w-HALF_OVERLAP, :);
plotResult(src, patch, result);