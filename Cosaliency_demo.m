function [Comask] = Cosaliency_demo(dirBldgName)
%% This code 
%%
% close all;
% clear all;
%% read image pairs
% dirBldgName=dir('.\coimg\*.jpg');
% dirBldgName2='.\\coimg\\%s';
% x = dirBldgName;
currentDir = cd; %current folder name
dirBldg = dir(strcat(dirBldgName,'\*.jpg'));
num_images = length(dirBldg);
Comask = cell(num_images, num_images);
Rnd = cell(num_images,1); %Rnode
imsp = cell(num_images,1);

%Iset{i}: the matrix of the ith image
%listOfImages{i}: properties of the ith images
% [Iset,listOfImages]=GetImagePair_demo(dirBldgName,dirBldgName2); 
for idx1 = 1:num_images-1
    for idx2 = idx1+1:num_images
        im1Name = dirBldg(idx1).name;
        im2Name = dirBldg(idx2).name;
        im1 = imread(im1Name);im2 = imread(im2Name);
        Iset = cell(2,1);listOfImages = [];
        Iset{1} = im1;Iset{2} = im2;
        listOfImages = [listOfImages;dirBldg(idx1);dirBldg(idx2)];
        
        %% local saliency
        %Isal=dolocalsaliency_demo(Iset);
        %% run superpixels
        % Rnum=[1,40,100,200];
        % spar.ev=40;
        Rnum=[1,20,50,100];
        spar.ev=20;
        Imsp=RunSuperpixelsSeg_demo(Rnum,Iset,listOfImages,spar);
        
%         save imsp.mat Imsp
        
        %%
        par.clnum=2;
        par.dis='ka2dis';
        par.model='alltree';
        par.lev=2;
        par.samelevel='same';
        
        par.color='colorhist';
        par.ccodebook=100;
        par.cclusternum=200;
        par.ccov=1;
        par.cth=0.4;
        
        par.patch='patchhist';
        par.pcodebook=100;
        par.pclusternum=200;
        par.psize=[3,5];
        par.pcov=1;
        par.pth=0.4;
        
        %beta.lsm=0.2;
        beta.gsm=1;
        
        fimg1=[];
        fimg2=[];
        % if strfind(listOfImages(1).name,'1.bmp')
        %     fimg1=strrep(listOfImages(1).name,'1.bmp','1');
        % elseif strfind(listOfImages(1).name,'1.png')
        %     fimg1=strrep(listOfImages(1).name,'1.png','1');
        if strfind(listOfImages(1).name,strcat(num2str(idx1),'.jpg'))
            fimg1=strrep(listOfImages(1).name,strcat(num2str(idx1),'.jpg'),num2str(idx1));
            % elseif strfind(listOfImages(1).name,'1.JPG')
            %     fimg1=strrep(listOfImages(1).name,'1.JPG','1');
        end
        if strfind(listOfImages(2).name,strcat(num2str(idx2),'.jpg'))
            fimg2=strrep(listOfImages(2).name,strcat(num2str(idx2),'.jpg'),num2str(idx2));
            % elseif strfind(listOfImages(1).name,'1.JPG')
            %     fimg1=strrep(listOfImages(1).name,'1.JPG','1');
        end
        % if strfind(listOfImages(2).name,'2.bmp')
        %     fimg2=strrep(listOfImages(2).name,'2.bmp','2');
        % elseif strfind(listOfImages(2).name,'2.png')
        %     fimg2=strrep(listOfImages(2).name,'2.png','2');
        % elseif strfind(listOfImages(2).name,'2.jpg')
        %     fimg2=strrep(listOfImages(2).name,'2.jpg','2');
        % elseif strfind(listOfImages(2).name,'2.JPG')
        %     fimg2=strrep(listOfImages(2).name,'2.JPG','2');
        % end
        
        if isempty(fimg1) | isempty(fimg2)
            error('No input file names.');
        end
        %%  Building Region-Tree
        st=clock;
        fprintf('Building Region-Tree computation...');
        [Rnode,GNode]=GetRegTree_demo(Rnum,Iset,Imsp,par);
        imsp{idx1} = Imsp{1,4}.sp;
        imsp{idx2} = Imsp{2,4}.sp;
        % save hist.mat Rnode
        fprintf(' took %.2f minutes\n',etime(clock,st)/60);
        Rnd{idx1} = Rnode{1,4};
        Rnd{idx2} = Rnode{2,4};
        
        %% Do simrank
        if strcmp(par.color,'colorhist')
            [c_sout1,c_sout2]=do_simrank_demo(Iset,Rnode,GNode,par,'color',par.model);
            cmask1=getmask_demo(c_sout1,Iset{1},Rnode,GNode);
            cmask2=getmask_demo(c_sout2,Iset{2},Rnode,GNode);
        end
        
        if strcmp(par.patch,'patchhist')
            [p_sout1,p_sout2]=do_simrank_demo(Iset,Rnode,GNode,par,'patch',par.model);
            pmask1=getmask_demo(p_sout1,Iset{1},Rnode,GNode);
            pmask2=getmask_demo(p_sout2,Iset{2},Rnode,GNode);
        end
        
        % total map
        Comask1=getcosaliency(cmask1,pmask1,Iset{1},fimg1,beta);
        Comask2=getcosaliency(cmask2,pmask2,Iset{2},fimg2,beta);
        
        %% write output co-saliency maps
        % fdir1=sprintf('.\\cosmap\\%s.bmp',fimg1);
        % fdir2=sprintf('.\\cosmap\\%s.bmp',fimg2);
        % imwrite(uint8(Comask1),fdir1,'bmp');
        % imwrite(uint8(Comask2),fdir2,'bmp');
        %%
        % subplot(1,2,1);
        % imshow(uint8(Comask1));
        % subplot(1,2,2);
        % imshow(uint8(Comask2));
        %save comask.mat Comask1 Comask2
        Comask{idx1,idx2} = Comask1;
        Comask{idx2,idx1} = Comask2;
        disp(strcat('running ',num2str(idx1),' ',num2str(idx2)));
    end
end
%%

%%Compute map for each image (linear combination of Comask in each row)
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

chist = cell(num_images,1);
phist = cell(num_images,1);
for i=1:num_images
    temp1 = cell2mat(Rnd{i});
    temp2 = [];
    temp3 = [];
    for j=1:size(temp1,2)
        temp2 = [temp2;temp1(j).chis];
        temp3 = [temp3;temp1(j).phis];
    end
    chist{i} = temp2;
    phist{i} = temp3;
end

cd(dirBldgName);
save Comask.mat Comask
save mask.mat a
save hist.mat chist phist
save imsp.mat imsp
cd(currentDir);
fclose all;

