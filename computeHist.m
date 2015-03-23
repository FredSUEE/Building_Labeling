% Compute color and texture histogram
k = dir('.\building_dataset\');
num_bldg = length(k)-3; % # buildings
currentDr = cd;
thresh = [55 30 40 70 70 30 80 50 130 80 40 17 60 90 10 60 90 60 60 50 50 50 120 30 40 60 30 10 130 90];
colorHist = zeros(5*num_bldg,256);

textureHist = zeros(5*num_bldg,8);

for j=1:num_bldg %building i
    if (k(j+3).isdir)
        dirName = k(j+3).name;
        % Get building directory
        dirBldgName = strcat('.\building_dataset\',dirName);
        cd(dirBldgName);
        load mask.mat
        
        for i = 1 : 5
            path = strcat(dirName, '_', num2str(i),'.jpg');
            im = imread(path);
            for channel = 1 : 3
                temp = im(:, :, channel);
                temp(find(a{i} < thresh(j))) = 0;
                im(:, :, channel) = temp;
            end
            colorHist((j-1)*5+i,:) = colorhist(im);
            textureHist((j-1)*5+i,:) = texturehist(im);
        end
    end
    cd(currentDr);
end
save Hist.mat colorHist textureHist
