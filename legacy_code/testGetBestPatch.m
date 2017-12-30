PATCH_SIZE = 10;
HALF_OVERLAP = 3;
OVERLAP = 2*HALF_OVERLAP;

src = im2double(imread('./data/textures/texture1.jpg'));

%src = src(1:10, 1:10, :);

[src_h, src_w, src_c] = size(src);


dst_h = src_h+OVERLAP;
dst_w = src_w+OVERLAP;
dst_c = src_c;
dst = zeros(dst_h, dst_w, dst_c);

ri = randi([1, src_h-(PATCH_SIZE+OVERLAP)+1]);
rj = randi([1, src_w-(PATCH_SIZE+OVERLAP)+1]);
overlap = getImagePatch(src, [ri, rj], PATCH_SIZE+OVERLAP);
overlapMask = ones(PATCH_SIZE+OVERLAP, PATCH_SIZE+OVERLAP);

overlapMask(HALF_OVERLAP+1:PATCH_SIZE+OVERLAP, HALF_OVERLAP+1:PATCH_SIZE+OVERLAP) = zeros(PATCH_SIZE+HALF_OVERLAP, PATCH_SIZE+HALF_OVERLAP);
overlap = overlap .* overlapMask;

patch = getBestPatch(src, overlap, overlapMask, PATCH_SIZE+OVERLAP);

clf();
subplot(2,2,1);
imagesc(overlap);
subplot(2,2,2);
imagesc(overlapMask);
subplot(2,2,3);
imagesc(patch);
