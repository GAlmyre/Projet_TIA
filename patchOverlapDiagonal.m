function result = patchOverlapDiagonal(overlapA, patchB, PATCH_SIZE, OVERLAP)
    
    %we retrieve the top and left part of overlapA
    overlapTopA = overlapA(1:OVERLAP, :,:);
    overlapLeftA = overlapA(:,1:OVERLAP,:);   
    
    %we retrieve the top and left part of patchB
    overlapTopB = patchB(1:OVERLAP, :,:);
    overlapLeftB = patchB(:,1:OVERLAP,:);    

    %we compute top and left min cuts
    topPath = calcMinCutHorizontal(overlapTopA, overlapTopB);
    leftPath = calcMinCutVertical(overlapLeftA, overlapLeftB);

    %we combine these two cuts
    patchPath = zeros(PATCH_SIZE,PATCH_SIZE);
    patchPath(1:OVERLAP, :,:) = patchPath(1:OVERLAP, :,:) + topPath;
    patchPath(:, 1:OVERLAP,:) = patchPath(:,1:OVERLAP,:) + leftPath;

    %we use imfill to fill the central part of the patch and we substract
    %the cuts we found before
    %that way we get a mask where ones are pixels we take from patchB and
    %zeros are pixels we take from overlapA
    patchMask = imfill(logical(patchPath), [PATCH_SIZE*PATCH_SIZE]) - logical(patchPath);
    
    %we apply a gaussian filter to smooth the edge between the two regions
    %of the mask
    patchMask = imgaussfilt(patchMask, 0.5);
    
    %we combine overlapA and patchB according to the mask
    result = patchMask .* patchB + (1-patchMask) .* overlapA;