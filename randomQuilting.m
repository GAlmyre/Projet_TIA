PATCH_SIZE = 20;
PATCH_OVERLAP = 10;
OFFSET = PATCH_SIZE - PATCH_OVERLAP

%OFFSET = 16;
%PATCH_OVERLAP = 4;
%PATCH_SIZE = OFFSET+PATCH_OVERLAP;
src = im2double(imread('./data/textures/texture1.jpg'));
[src_h, src_w, src_c] = size(src);

dst_h = src_h;
dst_w = src_w;
dst_c = src_c;
dst = zeros(dst_h, dst_w, dst_c);

%imagesc(src);
%imagesc(dst);

ri = randi([1, src_h-PATCH_SIZE+1]);
rj = randi([1, src_w-PATCH_SIZE+1]);

patch = getImagePatch(src, [ri, rj], PATCH_SIZE);
%patch = 0.5 * ones(PATCH_SIZE, PATCH_SIZE, 3);
plotResult(src, patch, dst);

%nbb_i = floor(dst_h/OFFSET);
%nbb_j = floor(dst_w/OFFSET);

nbb_i = floor((dst_h-PATCH_SIZE)/OFFSET)+1;
nbb_j = floor((dst_w-PATCH_SIZE)/OFFSET)+1;

for i=0:nbb_i-1
    for j=0:nbb_j-1
        %We select a new patch
        ri = randi([1, src_h-PATCH_SIZE+1]);
        rj = randi([1, src_w-PATCH_SIZE+1]);

        patch = getImagePatch(src, [ri, rj], PATCH_SIZE);

        %we compute where we have to copy the patch
        start_i = i*OFFSET+1;
        start_j = j*OFFSET+1;
        end_i = start_i + PATCH_SIZE - 1;
        end_j = start_j + PATCH_SIZE -1;
        
        %we compute overlaping with already existing patches
        if i ~= 0 && j ~= 0%overlap en haut et à gauche
            overlapTop = dst(start_i:start_i+PATCH_OVERLAP-1, start_j:end_j,:);
            overlapLeft = dst(start_i:end_i, start_j:start_j+PATCH_OVERLAP-1,:);
            patch = patchOverlapHorizontal(overlapLeft, patch, PATCH_SIZE, PATCH_OVERLAP);
            patch = patchOverlapVertical(overlapTop, patch, PATCH_SIZE, PATCH_OVERLAP);
        elseif j ~= 0%overlap à gauche
            overlapLeft = dst(start_i:end_i, start_j:start_j+PATCH_OVERLAP-1,:);
            patch = patchOverlapHorizontal(overlapLeft, patch, PATCH_SIZE, PATCH_OVERLAP);
        elseif i ~= 0%overlap en haut
            overlapTop = dst(start_i:start_i+PATCH_OVERLAP-1, start_j:end_j,:);
            patch = patchOverlapVertical(overlapTop, patch, PATCH_SIZE, PATCH_OVERLAP);
        end
        
        dst(start_i:end_i,...
            start_j:end_j,...
            :) = patch;
        plotResult(src, patch, dst);
        pause(0.5)
    end
end

plotResult(src, patch, dst);