clf();
PATCH_SIZE = 20;
PATCH_HALF_OVERLAP = 5;
PATCH_OVERLAP = PATCH_HALF_OVERLAP*2;
src = im2double(imread('./data/textures/texture1.jpg'));
[src_h, src_w, src_c] = size(src);

dst_h = PATCH_SIZE+PATCH_OVERLAP;
dst_w = 2*PATCH_SIZE+PATCH_OVERLAP;
dst_c = src_c;
dst = zeros(dst_h, dst_w, dst_c);

%imagesc(src);
%imagesc(dst);

ri = randi([1, src_h-(PATCH_SIZE+PATCH_OVERLAP)+1]);
rj = randi([1, src_w-(PATCH_SIZE+PATCH_OVERLAP)+1]);
patchA = getImagePatch(src, [ri, rj], PATCH_SIZE+PATCH_OVERLAP);

ri = randi([1, src_h-(PATCH_SIZE+PATCH_OVERLAP)+1]);
rj = randi([1, src_w-(PATCH_SIZE+PATCH_OVERLAP)+1]);
patchB = getImagePatch(src, [ri, rj], PATCH_SIZE+PATCH_OVERLAP);


overlapA = zeros([PATCH_SIZE+PATCH_OVERLAP PATCH_SIZE+PATCH_OVERLAP 3]);
overlapA(:, 1:PATCH_OVERLAP, :) = patchA(:, PATCH_SIZE+1:PATCH_SIZE+PATCH_OVERLAP,:);

new_patchB = patchOverlapHorizontal(overlapA, patchB, PATCH_SIZE+PATCH_OVERLAP, PATCH_OVERLAP);

dst(:,1:PATCH_SIZE+PATCH_OVERLAP,:) = patchA;
dst(:,PATCH_SIZE+1:2*PATCH_SIZE+PATCH_OVERLAP,:) = new_patchB;

subplot(2,2,1)
%imagesc(patchA);
subplot(2,2,2);
imagesc(patchB);
subplot(2,1,2)
imagesc(dst);