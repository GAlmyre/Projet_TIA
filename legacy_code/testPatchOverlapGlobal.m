clf();
PATCH_SIZE = 16;
HALF_OVERLAP = 6;
OVERLAP = 2*HALF_OVERLAP;

src = im2double(imread('./data/textures/texture1.jpg'));
[src_h, src_w, src_c] = size(src);

dst_h = PATCH_SIZE+OVERLAP;
dst_w = PATCH_SIZE+OVERLAP;
dst_c = src_c;
dst = zeros(dst_h, dst_w, dst_c);

%imagesc(src);
%imagesc(dst);

ri = randi([1, src_h-(PATCH_SIZE+OVERLAP)+1]);
rj = randi([1, src_w-(PATCH_SIZE+OVERLAP)+1]);
overlap = getImagePatch(src, [ri, rj], PATCH_SIZE+OVERLAP);
overlapMask = ones(PATCH_SIZE+OVERLAP, PATCH_SIZE+OVERLAP);
overlapMask(HALF_OVERLAP+1:PATCH_SIZE+OVERLAP, HALF_OVERLAP+1:PATCH_SIZE+HALF_OVERLAP) = zeros(PATCH_SIZE+HALF_OVERLAP, PATCH_SIZE);
overlap = overlap .* overlapMask;

ri = randi([1, src_h-(PATCH_SIZE+OVERLAP)+1]);
rj = randi([1, src_w-(PATCH_SIZE+OVERLAP)+1]);
patchB = getImagePatch(src, [ri, rj], PATCH_SIZE+OVERLAP);

%result = patchOverlapGlobal(overlap, overlapMask, patchB, PATCH_SIZE, OVERLAP); 

%dst(:,1:PATCH_SIZE,:) = patchA;
%dst(:,OFFSET+1:OFFSET+PATCH_SIZE,:) = new_patchB;

subplot(2,2,1)
imagesc(overlap);
subplot(2,2,2);
imagesc(patchB);
subplot(2,1,2)
imagesc(dst);