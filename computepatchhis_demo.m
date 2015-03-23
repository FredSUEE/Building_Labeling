function [out,pbin]=computepatchhis_demo(Iset,psize,par)
step=(psize-1)/2;
pvec=[];
Imnum=length(Iset);
for j=1:Imnum
    IRGB=Iset{j};
    Irgb=double(IRGB);
    [Ix,Iy,Iz]=size(Irgb);
    Irgbp=padarray(Irgb,[step step],'replicate');
    ptmp=[];
    for k=1:psize
        for i=1:psize
            temp_r=Irgbp(i:i+Ix-1,k:k+Iy-1,1);
            temp_g=Irgbp(i:i+Ix-1,k:k+Iy-1,2);
            temp_b=Irgbp(i:i+Ix-1,k:k+Iy-1,3);
            ptmp=[ptmp,temp_r(:),temp_g(:),temp_b(:)];
        end
    end
    pvec=[pvec;ptmp];
end

%Call kmeans clustering
des=pvec;
codebook_size=par.pcodebook;
cluster_maxnum=par.pclusternum;
randid=floor(size(des,1)*rand(1,codebook_size))'+1;
randcen=des(randid,:);
[cenv,cenl] = do_kmeans(des', codebook_size, cluster_maxnum,randcen');
cenl=cenl+1;
cenv=cenv';

len=size(Iset{1},1)*size(Iset{1},2);
out{1}=cenl(1:len);
out{2}=cenl(len+1:end);
pbin=1:codebook_size;