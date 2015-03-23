function W=BuildWmatrix_demo(Iset,Rnode,GNode,par,argv,argm)
%% compute W 
NDnum=size(GNode,1);
W=-ones(NDnum,NDnum);
for j=1:NDnum-1
    g1=GNode(j,:);
    for k=j+1:NDnum
        g2=GNode(k,:);
        if g1(1)==g2(1)
            [w12,w21]=ImgDis_Intra_demo(g1,g2,Iset,Rnode,par,argv,argm);
            W(j,k)=w12;
            W(k,j)=w21;
        else
            [w12,w21]=ImgDis_Inter_demo(g1,g2,Iset,Rnode,par,argv,argm);
            W(j,k)=w12;
            W(k,j)=w21;
        end
    end
end
W(find(W==-1))=0;