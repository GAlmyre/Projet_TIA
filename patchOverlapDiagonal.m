function result = patchOverlapDiagonal(overlapA, patchB, PATCH_SIZE, OVERLAP)
    
    overlapTopA = overlapA(1:OVERLAP, :,:);
    overlapLeftA = overlapA(:,1:OVERLAP,:);   
    

    overlapTopB = patchB(1:OVERLAP, :,:);
    overlapLeftB = patchB(:,1:OVERLAP,:);    

    topPath = calcMinCutHorizontal(overlapTopA, overlapTopB);
    leftPath = calcMinCutVertical(overlapLeftA, overlapLeftB);

    patchPath = zeros(PATCH_SIZE,PATCH_SIZE);
    patchPath(1:OVERLAP, :,:) = patchPath(1:OVERLAP, :,:) + topPath;
    patchPath(:, 1:OVERLAP,:) = patchPath(:,1:OVERLAP,:) + leftPath;

    patchMask = imfill(logical(patchPath), [PATCH_SIZE*PATCH_SIZE]) - logical(patchPath);

    %subplot(3,1,1);
    %imagesc(patchMask);
    
    test = imgaussfilt(patchMask, 0.5);
    
    %subplot(3,1,2);
    %imagesc(test);
    %colorbar;
    result = test .* patchB + (1-test) .* overlapA;
    %result = patchMask .* patchB + ~patchMask .* overlapA;