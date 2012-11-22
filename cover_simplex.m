function alpha = cover_simplex(dim, grid, remainder)
alpha = cell(0);
if(dim == 1)
    alpha{1} = remainder;
    return;
else
    for delta = grid
        if(delta <= remainder+eps)
            cover_dm = cover_simplex(dim-1, grid, (10 *(remainder - delta)) / 10);
            for i = 1 : length(cover_dm)
                alpha{end+1} = [delta cover_dm{i}];
            end
        end
    end
end