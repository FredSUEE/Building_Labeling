function [n1,n2,n3,n4,sum]=wavelet(ECG,n,wfilter)
I=rgb2gray(ECG);                 
nb=size(I,1)
colormap(pink(nb));
[c,s]=wavedec2(I,n,wfilter);
LL1=appcoef2(c,s,wfilter,1);
LH1=detcoef2('h',c,s,1);
LV1=detcoef2('v',c,s,1);
LD1=detcoef2('d',c,s,1);
cod_LL1=wcodemat(LL1,nb);           %Approximate component
cod_LH1=wcodemat(LH1,nb);           %Horizontal detail component
cod_LV1=wcodemat(LV1,nb);           %Vertical detail component
cod_LD1=wcodemat(LD1,nb);           %Diagonal detail component
subplot(3,2,1);imshow(I,[]);
title('Original Image');
subplot(3,2,3);imshow(cod_LL1,[]);
title('Approximate component');
subplot(3,2,4);imshow(cod_LH1,[]);
title('Horizontal detail');
subplot(3,2,5);imshow(cod_LV1,[]);
title('Vertical detail');
subplot(3,2,6);imshow(cod_LD1,[]);
title('Diagonal detail');
axis('square');
rgb1=mat2gray(imcrop(cod_LL1,[0 0 19 19]));  %Decompose image evenly into 4 parts 
rgb2=mat2gray(imcrop(cod_LL1,[20 0 38 19]));
rgb3=mat2gray(imcrop(cod_LL1,[0 20 19 38]));
rgb4=mat2gray(imcrop(cod_LL1,[20 20 38 38]));
figure;
subplot(2,2,1);subimage(rgb1);
subplot(2,2,2);subimage(rgb2);
subplot(2,2,3);subimage(rgb3);
subplot(2,2,4);subimage(rgb4);
axis('square');
n1=abs(eig(rgb1));       %Get eigenvalues
n2=abs(eig(rgb2));                     
n3=abs(eig(rgb3)); 
n4=abs(eig(rgb4)); 
sum=(n1+n2+n3+n4)/4;