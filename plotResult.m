function plotResult(src, patch, result)
    clf();
    subplot(3,1,1);
    imagesc(src);
    title('Src Image');
    subplot(3,1,2);
    imagesc(patch);
    title('Patch');
    subplot(3,1,3);
    imagesc(result);
    title('Result');