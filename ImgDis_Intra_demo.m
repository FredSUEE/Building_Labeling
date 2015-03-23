function [w12,w21]=ImgDis_Intra_demo(g1,g2,Iset,Rnode,par,argv,argm)
if strcmp(argm,'alltree')
    x=g1(2)-g2(2);
    if abs(x)>1
        w12=0;
        w21=0;
    elseif abs(x)==1
        if x==1
            pnd=g2; %parent node
            cnd=g1; %child node
            [w21,w12]=getnodedis_demo(pnd,cnd,Rnode,par,argv);
        else
            pnd=g1; %parent node
            cnd=g2; %child node
            [w12,w21]=getnodedis_demo(pnd,cnd,Rnode,par,argv);
        end
    elseif x==0 % same Image, same Level, differnt region
        gnb1=Rnode{g1(1),g1(2)}{g1(3)}.neighbor;
        gr=find(gnb1.ind==g2(3));
        
        if isempty(gr)
            w12=0;
            w21=0;
        else
             [w21,w12]=getnodedis_demo(g1,g2,Rnode,par,argv);
        end
    end    
    
elseif strcmp(argm,'onetree')
    rn=size(Rnode,2);
    x=g1(2)-g2(2);
    if abs(x)>1
        w12=0;
        w21=0;
    elseif abs(x)==1
        if x==1
            pnd=g2; %parent node
            cnd=g1; %child node
            if cnd(2)==rn
                [w21,w12]=getnodedis_demo(pnd,cnd,Rnode,par,argv);
            else
                [w21,w12]=getnodeAreadis(pnd,cnd,Rnode);
            end
        else
            pnd=g1; %parent node
            cnd=g2; %child node
            if cnd(2)==rn
                [w12,w21]=getnodedis_demo(pnd,cnd,Rnode,par,argv);                
            else
                [w12,w21]=getnodeAreadis(pnd,cnd,Rnode);
            end
        end
    elseif x==0 % same Image, same Level, differnt region
        if (strcmp(par.samelevel,'same') && g1(2)>par.lev)
               [w21,w12]=getnodedis(g1,g2,Rnode,par,argv);
        else
           w12=0;
           w21=0;
        end
    end
end

