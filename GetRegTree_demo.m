function [Rnode,GNode]=GetRegTree_demo(Rnum,Iset,Imsp,par)
Imnum=length(Iset);
cn=1;
for j=1:Imnum
    for k=1:length(Rnum)
        rn=Imsp{j,k}.num;
        for i=1:rn
           Rnode{j,k}{i}.parent=[];
           Rnode{j,k}{i}.child=[];
           GNode(cn,:)=[j,k,i];
           cn=cn+1;
        end
    end
end

%% color clustering
cvector=[];
for j=1:Imnum
    IRGB=Iset{j};
    [Cl,Ca,Cb]=rgb2lab(IRGB(:,:,1),IRGB(:,:,2),IRGB(:,:,3));
    Ycbr=double(rgb2ycbcr(IRGB));
    Img=double(Iset{j});
    r=Img(:,:,1)/255;
    g=Img(:,:,2)/255;
    b=Img(:,:,3)/255;
    Y=Ycbr(:,:,1)/255;
    Cb=Ycbr(:,:,2)/255;
    Cr=Ycbr(:,:,3)/255;
    rgb=[r(:),g(:),b(:)];
    Lab=[Cl(:)/100,(Ca(:)+110)/220,(Cb(:)+110)/220];
    ybr=[Y(:),Cb(:),Cr(:)];
    cvecc{j}=[rgb,Lab,ybr];
    cvector=[cvector;rgb,Lab,ybr];
end
%% compute color words
if strcmp(par.color,'colorhist')
    [clab,cbin]=getcwords_demo(cvecc,cvector,par);
end
%% compute patch words
if strcmp(par.patch,'patchhist')
    psize=par.psize;
    for j=1:length(psize)
        [ptidx{j},ptbin{j}]=computepatchhis_demo(Iset,psize(1),par);
    end
end

%%
for j=1:Imnum
    cvec=cvecc{j};
    for k=1:length(Rnum)
        rn=Imsp{j,k}.num;
        rmk=Imsp{j,k}.sp;
        if k==1
            rmk_1=zeros(size(rmk));
        else
            rmk_1=Imsp{j,k-1}.sp;
        end
        for i=1:rn
           rx=find(rmk==i);
           rx1=rx(max(1,floor(length(rx)/2)));
           Rnode{j,k}{i}.pset=rx;
           Rnode{j,k}{i}.vcolor=mean(cvec(rx,:));
           
           if strcmp(par.color,'colorhist')
               clabel=clab{j};
               ht=hist(clabel(rx),cbin);
               Rnode{j,k}{i}.chis=ht/sum(ht);
           end
           if strcmp(par.patch,'patchhist')
               Rnode{j,k}{i}.phis=getpatchhist_demo(j,rx,ptidx,ptbin);
           end
           Rnode{j,k}{i}.pnum=length(rx);
           Rnode{j,k}{i}.ind=i;
           Rnode{j,k}{i}.parent=rmk_1(rx1);
           Rnode{j,k}{i}.neighbor=getneighbor_demo(rmk,rx);
           if k>1
               Rnode{j,k-1}{rmk_1(rx1)}.child=[Rnode{j,k-1}{rmk_1(rx1)}.child,i];
           end
        end
    end
end


