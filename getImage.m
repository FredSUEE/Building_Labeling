function [pic_new] = getImage
 clc,close all ,clear all;
 [filename,pathname]=uigetfile({'*.bmp;*.jpg;*.png;*.jpeg','(*.bmp,*.jpg,*.png,*.jpeg)';'*.*', 'AllFiles(*.*)'},'Pickanimage'); 
 if isequal(filename,0)||isequal(pathname,0)
 return;
 end
 fpath=[pathname filename];
 pic=imread(fpath);
 pic0=pic;
 figure(1);
 
%%
%crop image
 while(1)
    clf(figure(1));imshow(pic);
    pic_little=imrect;
    position= floor(wait(pic_little));
    button1=questdlg('Rechoose?','Confirmation','Y','N','N');
    if strcmp(button1 ,'N')
       break;
    end
 end
 hold on;
 %Get coordinates of rectangle ABCD
 A_x=position(1);  
 A_y=position(2);
 C_x=position(1)+position(3);
 C_y=position(2)+position(4);
 B_x=C_x;
 B_y=A_y;
 D_x=A_x;
 D_y=C_y;
 plot(A_x,A_y,'s','color','r');
 plot(C_x,C_y,'s','color','r');
 rectangle('Position',[A_x,A_y,position(3),position(4)],'edgeColor','r','LineWidth',2);  
 pic_new=pic(A_y:C_y,A_x:C_x,:); 