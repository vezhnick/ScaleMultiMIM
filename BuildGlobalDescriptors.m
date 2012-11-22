clear;
addpath D:\MATLAB\vlfeat-0.9.9\toolbox\ ;
addpath D:\MATLAB\phog\ ;
addpath D:\MATLAB\GIST\ ;
vl_setup();

in_dir = 'd:\MATLAB\im_parser\LabelMeDataSet\Images\';

suffix = 'Test';
load(['Index' suffix]);

ImagesDB = cell(1,length(Index));
k = 1;

for i = 1 : length(Index)
    
    name = [Index{i}.name '.jpg'];
    
    ImagesDB{k}.name = name;
    ImagesDB{k}.labels = Index{i}.labels;
    
    k = k + 1;
end

Nblocks = 4;
imageSize = 256;
orientationsPerScale = [8 8 4];
numberBlocks = 4;

% Precompute filter transfert functions (only need to do this one, unless image size is changes):
createGabor(orientationsPerScale, imageSize); % this shows the filters
G = createGabor(orientationsPerScale, imageSize);

GIST = zeros(500, 960);

%PHOG stuff
bin = 8;
angle = 360;
L=3;

load('PHOW_centers_color.mat');
load('PHOW_centers_gray.mat');
for i = 1 : length(ImagesDB)
    i
    
    %descr_idx = 1;
    
    file_name = ImagesDB{i}.name;
    img = imread([in_dir file_name]);
    
    h = size(img,1);
    w = size(img,2);
    % full image PHOW, color

    [frames, descr] = vl_phow(im2single(img), 'Color', true);
    I = vl_ikmeanspush(descr,PHOW_centers_color);
    total_H = vl_ikmeanshist(size(PHOW_centers_color,2),I);

    ImagesDB{i}.Features{2} = sparse(total_H / sum(total_H));
        
    % PHOW descriptor horyzontal, color
    total_H = [];
    
    for sub = 0 : 2
        from = sub * floor(h/3) + 1;
        to = (sub+1)*floor(h/3);
        [frames, descr] = vl_phow(im2single(img(from:to,:,:)), 'Color', true);
        I = vl_ikmeanspush(descr,PHOW_centers_color);
        H = vl_ikmeanshist(size(PHOW_centers_color,2),I);
        total_H = cat(1, total_H, H);
    end
    
    ImagesDB{i}.Features{3} = sparse(total_H / sum(total_H));
    
    % PHOW descriptor quadtree, color
    total_H = [];

    for sub_x = 0 : 1
        for sub_y = 0 : 1
            from_x = sub_x * floor(h/2) + 1;
            to_x = (sub_x+1)*floor(h/2);
            
            from_y = sub_y * floor(w/2) + 1;
            to_y = (sub_y+1)*floor(w/2);
            
            [frames, descr] = vl_phow(im2single(img(from_x:to_x,from_y:to_y,:)), 'Color', true);
            I = vl_ikmeanspush(descr,PHOW_centers_color);
            H = vl_ikmeanshist(size(PHOW_centers_color,2),I);
            total_H = cat(1, total_H, H);
        end
    end

    ImagesDB{i}.Features{4} = sparse(total_H / sum(total_H));
    
    total_H = [];

    for sub_x = 0 : 3
        for sub_y = 0 : 3
            from_x = sub_x * floor(h/4) + 1;
            to_x = (sub_x+1)*floor(h/4);
            
            from_y = sub_y * floor(w/4) + 1;
            to_y = (sub_y+1)*floor(w/4);
            
            [frames, descr] = vl_phow(im2single(img(from_x:to_x,from_y:to_y,:)), 'Color', true);
            I = vl_ikmeanspush(descr,PHOW_centers_color);
            H = vl_ikmeanshist(size(PHOW_centers_color,2),I);
            total_H = cat(1, total_H, H);
        end
    end

    ImagesDB{i}.Features{5} = sparse(total_H / sum(total_H));
    
    % full image PHOW, gray

    [frames, descr] = vl_phow(im2single(img), 'Color', false);
    I = vl_ikmeanspush(descr,PHOW_centers_gray);
    total_H = vl_ikmeanshist(size(PHOW_centers_gray,2),I);

    ImagesDB{i}.Features{6} = sparse(total_H / sum(total_H));
        
    % PHOW descriptor horyzontal, gray
    total_H = [];
    
    for sub = 0 : 2
        from = sub * floor(h/3) + 1;
        to = (sub+1)*floor(h/3);
        [frames, descr] = vl_phow(im2single(img(from:to,:,:)), 'Color', false);
        I = vl_ikmeanspush(descr,PHOW_centers_gray);
        H = vl_ikmeanshist(300,I);
        total_H = cat(1, total_H, H);
    end
    
    ImagesDB{i}.Features{7} = sparse(total_H / sum(total_H));
    
    % PHOW descriptor quadtree, gray
    total_H = [];

    for sub_x = 0 : 1
        for sub_y = 0 : 1
            from_x = sub_x * floor(h/2) + 1;
            to_x = (sub_x+1)*floor(h/2);
            
            from_y = sub_y * floor(w/2) + 1;
            to_y = (sub_y+1)*floor(w/2);
            
            [frames, descr] = vl_phow(im2single(img(from_x:to_x,from_y:to_y,:)), 'Color', false);
            I = vl_ikmeanspush(descr,PHOW_centers_gray);
            H = vl_ikmeanshist(300,I);
            total_H = cat(1, total_H, H);
        end
    end

    ImagesDB{i}.Features{8} = sparse(total_H / sum(total_H));
        
    total_H = [];

    for sub_x = 0 : 3
        for sub_y = 0 : 3
            from_x = sub_x * floor(h/4) + 1;
            to_x = (sub_x+1)*floor(h/4);
            
            from_y = sub_y * floor(w/4) + 1;
            to_y = (sub_y+1)*floor(w/4);
            
            [frames, descr] = vl_phow(im2single(img(from_x:to_x,from_y:to_y,:)), 'Color', false);
            I = vl_ikmeanspush(descr,PHOW_centers_gray);
            H = vl_ikmeanshist(size(PHOW_centers_gray,2),I);
            total_H = cat(1, total_H, H);
        end
    end

    ImagesDB{i}.Features{9} = sparse(total_H / sum(total_H));
    
    %colors
    
    %RGB
    for c = 1:3
        chanel = img(:,:,c);
        chanel = chanel(:);
        
        H = histc(chanel, 0:20:256);
        total_H = cat(1, total_H, H);
    end
    
    ImagesDB{i}.Features{10} = sparse(total_H / sum(total_H));
    
    %HSV
    hsv_img = rgb2hsv(img);
    for c = 1:3
        chanel = hsv_img(:,:,c);
        chanel = chanel(:);
        
        H = histc(chanel, 0:0.1:1);
        total_H = cat(1, total_H, H);
    end
    
    ImagesDB{i}.Features{11} = sparse(total_H / sum(total_H));
    
    %PHOG
    roi = [1;size(img,1);1;size(img,2)];
    p = anna_phog(im2double(img),bin,angle,L,roi);
    ImagesDB{i}.Features{12} = p;
    
    img = imresize(img, [imageSize imageSize]);
    output = prefilt(double(img), 4);
    g = gistGabor(output, numberBlocks, G);
    ImagesDB{i}.Features{1} = g;
    
end

save(['LabelMeGlobalFeat' suffix '.mat'], 'ImagesDB');
