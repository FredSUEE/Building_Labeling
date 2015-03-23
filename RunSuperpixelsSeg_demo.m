function Imsp=RunSuperpixelsSeg_demo(Rnum,Iset,listOfImages,spar)

for j=1:length(listOfImages)
    [x,y,z]=size(Iset{j});
    %=============================================
    %Code to compute superpixels. by Greg Mori http://www.cs.sfu.ca/~mori/research/superpixels
    %step 1: Spmk{1}=Sp;
    %step 2: Using Sp to compute Fine scale superpixels Spp{i} using clusterLocations
    %step 3: Spmk{1+i}=Spp{i} 
    %repeat steps 2-3 to build Pyramid Decomposition
    Spmk=dosuperpixels(Iset{j},Rnum,spar);
    %=============================================
    for k=1:length(Rnum)
        if Rnum(k)==1
            Imsp{j,k}.sp=ones(x,y);
            Imsp{j,k}.num=1;
            Imsp{j,k}.size=[x,y];
        else
            Imsp{j,k}.sp=Spmk{k};
            Imsp{j,k}.num=max(max(Imsp{j,k}.sp));
            Imsp{j,k}.size=[x,y];
        end
    end
end

