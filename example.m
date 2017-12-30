%% texture synthesis
profile clear
profile on

global DISPLAY;
DISPLAY = true;

src = im2double(imread('./data/textures/mur1.jpg'));
[src_h src_w src_c] = size(src);
scale = [2 2];
target_size = round([scale(1)*src_h scale(2)*src_w]);
patch_size = 80;

dst = textureSynthesis(src, patch_size, target_size);

profile viewer
%% texture transfert
% bill and rice
profile clear
profile on

global DISPLAY;
DISPLAY = true;

src = im2double(imread('./data/textures/rice.jpg'));
[src_h src_w src_c] = size(src);
src = imresize(src, 1, 'bilinear');

dst = im2double(imread('./data/textures/bill.jpg'));
dst = imresize(dst, 2.5, 'bilinear');
[dst_h dst_w dst_c] = size(dst);

dst_map = rgb2gray(dst);
src_map = rgb2gray(src);

patch_size = 20;
alpha = 0.6
dst = textureTransfert(src, src_map, dst_map, patch_size, alpha);

%profile viewer

%%
profile clear
profile on

global DISPLAY;
DISPLAY = true;

src = im2double(imread('./data/textures/mur1.jpg'));
[src_h src_w src_c] = size(src);
src = imresize(src, 0.5, 'bilinear');

dst = im2double(imread('./data/textures/antoijne1.png'));
dst = imresize(dst, 2, 'bilinear');
[dst_h dst_w dst_c] = size(dst);

dst_map = rgb2gray(dst);
src_map = histeq(rgb2gray(src), imhist(dst_map));

kernel = -1*ones(3);
kernel(2,2) = 17;
test = edge(dst_map, 'canny');

test = imdilate(test, strel('diamond', 3));

patch_size = 20;
size(dst)

alpha = 0.6;

dst = textureTransfert(src, src_map, dst_map, patch_size, alpha);

size(dst)
%profile viewer