function res = calcMinCutHorizontal(overlapA, overlapB)
    overlap_error = (sum(overlapA,3)-sum(overlapB,3)).^2;
    [e_h, e_w] = size(overlap_error);


    %on calcule l'erreur cumulée de gauche en droite
    cumul_error = zeros(e_h, e_w);
    cumul_error(:, 1) = overlap_error(:, 1);
    for j=2:e_w
        for i=1:e_h
            prev_min = min(cumul_error(max(1,i-1):min(e_h,i+1), j-1));
            cumul_error(i,j) = overlap_error(i,j) + prev_min;         
        end
    end
    
    path = zeros(e_h, e_w);
    %on cherche le chemin ayant la plus faible erreur cumulée de bas en haut
    [min_val, ind] = min(cumul_error(:,e_w));
    i = ind;
    path(i,e_w) = 1;

    for j=e_w-1:-1:1
        bound_min = max(1, i-1);
        bound_max = min(e_h, i+1);
        [min_val, ind] = min(cumul_error(bound_min:bound_max, j));
        i = ind + bound_min -1;
        path(i, j) = 1;
    end
    
    res = path;