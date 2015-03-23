im_test = getImage;
bldgNameList = cell(30,1);
k = dir('.\building_dataset\');
currentDr = cd;
matchNum = [];
load siftFeature.mat
load bldgName.mat
for i=1:150 %loop for each training image
    
    [matches, scores, points] = sift_match(im_test, siftFeature{i});
    matchNum = [matchNum;points];
    
end
[value,index]=sort(matchNum,'descend');
idx = index(1:10);
label = ceil(idx/5);
scoreRule = [15 12 10 8 6 5 4 3 2 1];
score = zeros(30,1);
for i=1:length(label)
    score(label(i)) = score(label(i)) + scoreRule(i);
end
[maxScore, bldgIdx] = max(score);
bldgResult = bldgNameList{bldgIdx}
figure(1);
xlabel(strcat('Label:',bldgResult),'Color','r','FontSize',12,'FontWeight','bold','BackgroundColor',[1,1,1]);