function plotResult(src, result)
    clf();
    subplot(1,2,1);
    imagesc(src);
    %subplot(3,1,2);
    %imagesc(patch);
    %title('Patch');
    subplot(1,2,2);
    imagesc(result);