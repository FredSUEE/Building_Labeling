function mask=getmask(sout,Img,Rnode,GNode)

[x,y,z]=size(Img);
mask=zeros(x,y);
rn=size(sout,1);
for i=1:rn
    d1=sout(i,1);
    gd1=GNode(d1,:);
    px=Rnode{gd1(1),gd1(2)}{gd1(3)}.pset;
    mask(px)=sout(i,3);
end
