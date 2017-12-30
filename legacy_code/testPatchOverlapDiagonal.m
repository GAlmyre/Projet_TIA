clf();
PATCH_SIZE = 20;
HALF_OVERLAP = 10;
OVERLAP = 2*HALF_OVERLAP;
src = im2double(imread('./data/textures/texture1.jpg'));
[src_h, src_w, src_c] = size(src);

dst_h = 2*PATCH_SIZE+OVERLAP;
dst_w = 2*PATCH_SIZE+OVERLAP;
dst_c = src_c;
dst = zeros(dst_h, dst_w, dst_c);

%imagesc(src);
%imagesc(dst);

ri = randi([1, src_h-(2*PATCH_SIZE+OVERLAP)+1]);
rj = randi([1, src_w-(2*PATCH_SIZE+OVERLAP)+1]);
patchA = getImagePatch(src, [ri, rj], 2*PATCH_SIZE+OVERLAP);
patchA(OVERLAP+PATCH_SIZE+1:2*PATCH_SIZE+OVERLAP,OVERLAP+PATCH_SIZE+1:2*PATCH_SIZE+OVERLAP,:) = zeros(PATCH_SIZE,PATCH_SIZE,3);

ri = randi([1, src_h-(PATCH_SIZE+OVERLAP)+1]);
rj = randi([1, src_w-(PATCH_SIZE+OVERLAP)+1]);
patchB = getImagePatch(src, [ri, rj], PATCH_SIZE+OVERLAP);
start = PATCH_SIZE+1
overlapA = patchA(start:2*PATCH_SIZE+OVERLAP,start:2*PATCH_SIZE+OVERLAP,:);

res = patchOverlapDiagonal(overlapA, patchB, PATCH_SIZE+OVERLAP, OVERLAP);

% subplot(2,2,1)
% imagesc(topPath);
% subplot(2,2,2)
% imagesc(leftPath);
% subplot(2,2,3)
% imagesc(patchMask);
% subplot(2,2,4)
% imagesc(res);

% subplot(2,3,1);
% imagesc(overlapTopA);
% subplot(2,3,2);
% imagesc(overlapTopB);
% subplot(2,3,3);
% imagesc(topPath);
% subplot(2,3,4);
% imagesc(overlapLeftA);
% subplot(2,3,5);
% imagesc(overlapLeftB);
% subplot(2,3,6);
% imagesc(leftPath);


% patchHV = patchOverlapHorizontal(overlapLeftA, patchB, PATCH_SIZE+OVERLAP, OVERLAP);
% patchHV = patchOverlapVertical(overlapTopA, patchHV, PATCH_SIZE+OVERLAP, OVERLAP);
% 
% patchVH = patchOverlapVertical(overlapTopA, patchB, PATCH_SIZE+OVERLAP, OVERLAP);
% patchVH = patchOverlapHorizontal(overlapLeftA, patchVH, PATCH_SIZE+OVERLAP, OVERLAP);


% subplot(3,1,1);
% imagesc(patchHV);
% 
% subplot(3,1,2);
% imagesc(patchVH);
% 
subplot(3,1,3);
imagesc(res);

% resHV = patchA;
% resHV(PATCH_SIZE+1:2*PATCH_SIZE+OVERLAP,PATCH_SIZE+1:2*PATCH_SIZE+OVERLAP,:) = patchHV;
% 
% resVH = patchA;
% resVH(PATCH_SIZE+1:2*PATCH_SIZE+OVERLAP,PATCH_SIZE+1:2*PATCH_SIZE+OVERLAP,:) = patchVH;
% 
% subplot(2,2,1)
% imagesc(patchA);
% subplot(2,2,2);
% imagesc(patchB);
% subplot(2,2,3)
% imagesc(resHV);
% subplot(2,2,4)
% imagesc(resVH);
%subplot(2,1,2)
%imagesc(dst);