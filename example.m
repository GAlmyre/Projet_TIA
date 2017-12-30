%% texture synthesis
profile clear
profile on

global DISPLAY;
DISPLAY = false;

src = im2double(imread('./data/textures/mur1.jpg'));
[src_h src_w src_c] = size(src);
scale = [2 2];
target_size = round([scale(1)*src_h scale(2)*src_w]);
patch_size = 80;

dst = textureSynthesis(src, patch_size, target_size);

profile viewer
%% texture transfert
profile clear
profile on

global DISPLAY;
DISPLAY = true;

src = im2double(imread('./data/textures/mur1.jpg'));
[src_h src_w src_c] = size(src);

dst = im2double(imread('./data/textures/antoijne1.png'));
dst = imresize(dst, 5, 'bilinear');
[dst_h dst_w dst_c] = size(dst);

dst_map = rgb2gray(dst);
src_map = histeq(rgb2gray(src), imhist(dst_map));
%src_map = rgb2gray(src);


patch_size = 50;

dst = textureTransfert(src, src_map, dst_map, 1, patch_size);

%profile viewer
%%

src = im2double(imread('./data/textures/candy1.jpg'));
src = src(1:4, 1:6, :);
src = rand([4, 6, 3]);

p1 = [5 5];
p2 = [5 5];

test = padarray(src, p1, 'pre');
test = padarray(test, p2, 'post');

test2 = padarray(src, p1, 'symmetric', 'pre');
test2 = padarray(test2, p2, 'symmetric', 'post');

test2 = test2 - test;

subplot(1,2,1);
imagesc(src);
subplot(1,2,2);
imagesc(test2);