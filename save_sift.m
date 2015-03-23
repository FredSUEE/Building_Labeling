k = dir('.\building_dataset\');
num_bldg = length(k)-3; % # buildings
currentDr = cd;
siftFeature = cell(5*num_bldg,1);
for i=4:length(k) %loop for each building folder
    if (k(i).isdir)
        dirBldgName = strcat('.\building_dataset\',k(i).name);
        cd(dirBldgName);
        load im.mat
        
        for j = 1:5
            im_train = im{j};
            I = single(rgb2gray(im_train));
            [f, d] = vl_dsift(I, 'Step', 5);
            % only keep those points in co-saliency region
            f_new = [];
            d_new = [];
            points_in = round(f(1:2, :));
            for m = 1 : size(points_in, 2)
                if (I(points_in(2,m), points_in(1,m)) > 0)
                    f_new = [f_new, f(:, m)]; 
                    d_new = [d_new, d(:, m)];
                end
            end
            f = f_new;
            d = d_new;
            siftFeature{(i-4)*5+j} = d;
        end
        cd(currentDr);
    end
end
save siftFeature.mat siftFeature