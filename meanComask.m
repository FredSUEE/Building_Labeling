% Compute mean of multiple MISMs, to get the final MISM for each image
a = cell(size(Comask,1),1);
for i = 1:size(Comask,1)
    if i == 1
        [h,w] = size(Comask{i,2});
    else
        [h,w] = size(Comask{i,1});
    end
    a{i} = zeros(h,w);
    for j = 1:size(Comask,2)
        if isempty(Comask{i,j})
            Comask{i,j} = zeros(h,w);
        end
            a{i} = a{i} + Comask{i,j};
    end
    a{i} = a{i} / (size(Comask,1) - 1);
    subplot(1,size(Comask,1),i);
    imshow(uint8(a{i}));
end
save mask.mat a
        