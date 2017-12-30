function res = calcMinCutVertical(overlapA, overlapB)

    overlap_error = (sum(overlapA,3)-sum(overlapB,3)).^2;
    [e_h, e_w] = size(overlap_error);


    %on calcule l'erreur cumulée de haut en bas
    cumul_error = zeros(e_h, e_w);
    cumul_error(1, :) = overlap_error(1, :);
    for i=2:e_h
        for j=1:e_w
            prev_min = min(cumul_error(i-1, max(1,j-1):min(e_w,j+1))); 
            cumul_error(i,j) = overlap_error(i,j) + prev_min;         
        end
    end

    path = zeros(e_h, e_w);
    %on cherche le chemin ayant la plus faible erreur cumulée de bas en haut
    [min_val, ind] = min(cumul_error(e_h,:));
    j = ind;
    path(i,j) = 1;

    for i=e_h-1:-1:1
        bound_min = max(1, j-1);
        bound_max = min(e_w, j+1);
        [min_val, ind] = min(cumul_error(i, bound_min:bound_max));
        j = ind + bound_min -1;
        path(i, j) = 1;
    end
    
    res = path;