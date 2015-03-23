function [w12,w21]=ImgDis_Inter_demo(g1,g2,Iset,Rnode,par,argv,argm)
if strcmp(argm,'alltree')
    if  (g2(2)-g1(2)==1) %g1(2)==rn-1  && g2(2)==rn)
        pnd=g1; %parent node
        cnd=g2; %child node
        [w12,w21]=getnodedis_demo(pnd,cnd,Rnode,par,argv);        
    elseif (g1(2)-g2(2)==1) %g1(2)==rn  && g2(2)==rn-1)
        pnd=g2; %parent node
        cnd=g1; %child node
        [w21,w12]=getnodedis_demo(pnd,cnd,Rnode,par,argv);        
    else
        if (g1(2)==g2(2) && g1(2)>par.lev && strcmp(par.samelevel,'same'))
           [w21,w12]=getnodedis_demo(g1,g2,Rnode,par,argv);
        else
           w12=0;
           w21=0;
        end
    end
elseif strcmp(argm,'onetree')
    rn=size(Rnode,2);
    if  (g1(2)==rn-1  && g2(2)==rn)
        pnd=g1; %parent node
        cnd=g2; %child node
        [w12,w21]=getnodedis_demo(pnd,cnd,Rnode,par,argv);        
    elseif (g1(2)==rn  && g2(2)==rn-1)
        pnd=g2; %parent node
        cnd=g1; %child node
        [w21,w12]=getnodedis_demo(pnd,cnd,Rnode,par,argv);        
    else
        if (g1(2)==g2(2) && g1(2)>par.lev && strcmp(par.samelevel,'same'))
           [w21,w12]=getnodedis_demo(g1,g2,Rnode,par,argv);
        else
           w12=0;
           w21=0;
        end
        
    end    
end

