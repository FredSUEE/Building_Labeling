im = getImage;
im_chist = colorhist(im);
im_thist = texturehist(im);
load Hist.mat;
load bldgName.mat
k = dir('.\building_dataset\');
u = 0.5;
[dist,index]=sort(vl_alldist([colorHist u*textureHist]',[im_chist u*im_thist]'));
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
