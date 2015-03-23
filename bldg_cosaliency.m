k = dir('.\building_dataset\');
for i=4:length(k) %loop for each building folder
    if (k(i).isdir)
        dirName = k(i).name;
        % Get building directory
        dirBldgName = strcat('.\building_dataset\',dirName);
        % Compute Cosaliency Map
        [Comask] = Cosaliency_demo(dirBldgName);
    end
end