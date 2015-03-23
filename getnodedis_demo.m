function [w21,w12]=getnodedis_demo(pnd,cnd,Rnode,par,argv)
if (strcmp(argv,'color') && strcmp(par.dis,'ka2dis'))
        cncv=Rnode{cnd(1),cnd(2)}{cnd(3)}.chis;
        pncv=Rnode{pnd(1),pnd(2)}{pnd(3)}.chis;
        cig=par.ccov;
        th=par.cth;          
        dis=Ka2distance_demo(cncv,pncv);
        dis=exp(-dis/cig);  
        
elseif (strcmp(argv,'patch')  && strcmp(par.dis,'ka2dis'))
        cncv=Rnode{cnd(1),cnd(2)}{cnd(3)}.phis;
        pncv=Rnode{pnd(1),pnd(2)}{pnd(3)}.phis;
        cig=par.pcov;
        th=par.pth;   
        dis=Ka2distance_demo(cncv,pncv);
        dis=exp(-dis/cig);  
elseif (strcmp(argv,'shape')  && strcmp(par.dis,'ka2dis'))
    %cncv=Rnode{cnd(1),cnd(2)}{cnd(3)}.shis;
    pcncd=Rnode{cnd(1),cnd(2)}{cnd(3)}.parent;
    pcncv=Rnode{cnd(1),cnd(2)-1}{pcncd}.shis;
    pncv=Rnode{pnd(1),pnd(2)}{pnd(3)}.shis;
    cnca=Rnode{cnd(1),cnd(2)-1}{pcncd}.slen;
    pnca=Rnode{pnd(1),pnd(2)}{pnd(3)}.slen;
    disa=max(pnca,cnca)/min(cnca,pnca)-1;
    cig=par.scov;
    th=par.sth;   
    dis=Ka2distance_demo(pcncv,pncv);
    dis=exp(-dis/cig)*exp(-disa/par.slcov);
elseif  strcmp(par.dis,'Eudis')
    cncv=Rnode{cnd(1),cnd(2)}{cnd(3)}.vcolor;
    pncv=Rnode{pnd(1),pnd(2)}{pnd(3)}.vcolor;
    dis=sqrt(sum((cncv-pncv).^2));
    cig=par.ccov;
    th=par.cth;                    
    dis=exp(-dis/cig);
end
if dis<th
    w21=0;
else
    w21=dis;
end
w12=w21;
