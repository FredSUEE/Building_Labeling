k = dir('.\building_dataset\');
num_bldg = length(k)-3; % # buildings
currentDr = cd;
for j=1:num_bldg %building i
    if (k(j+3).isdir)
        dirName = k(j+3).name;
        % Get building directory
        dirBldgName = strcat('.\building_dataset\',dirName);
        cd(dirBldgName);
        load mask.mat
        
        im = cell(5,1);
        for i = 1 : 5
            path = strcat(dirName, '_', num2str(i),'.jpg');
            im{i} = imread(path);
            for channel = 1 : 3
                temp = im{i}(:, :, channel);
                temp(find(a{i} < 20)) = 0;
                im{i}(:, :, channel) = temp;
            end
        end
    end
    save im.mat im
    cd(currentDr);
end

