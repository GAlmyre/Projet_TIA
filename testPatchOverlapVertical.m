clf();
PATCH_SIZE = 20;
PATCH_OVERLAP = 15;
OFFSET = PATCH_SIZE - PATCH_OVERLAP
src = im2double(imread('./data/textures/texture1.jpg'));
[src_h, src_w, src_c] = size(src);

dst_h = PATCH_SIZE+OFFSET;
dst_w = PATCH_SIZE;
dst_c = src_c;
dst = zeros(dst_h, dst_w, dst_c);

%imagesc(src);
%imagesc(dst);

ri = randi([1, src_h-PATCH_SIZE+1]);
rj = randi([1, src_w-PATCH_SIZE+1]);
patchA = getImagePatch(src, [ri, rj], PATCH_SIZE);

ri = randi([1, src_h-PATCH_SIZE+1]);
rj = randi([1, src_w-PATCH_SIZE+1]);
patchB = getImagePatch(src, [ri, rj], PATCH_SIZE);

overlapA = patchA(PATCH_SIZE-PATCH_OVERLAP+1:PATCH_SIZE,:,:);

new_patchB = patchOverlapVertical(overlapA, patchB, PATCH_SIZE, PATCH_OVERLAP);

dst(1:PATCH_SIZE,:,:) = patchA;
dst(OFFSET+1:OFFSET+PATCH_SIZE,:,:) = new_patchB;

subplot(2,2,1)
imagesc(patchA);
subplot(2,2,3);
imagesc(patchB);
subplot(1,2,2)
imagesc(dst);