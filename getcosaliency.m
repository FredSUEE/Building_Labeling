function mask=getcosaliency(cmap,pmap,Img,argv,beta)
cmap=cmap-min(min(cmap));
cmx=max(max(cmap));
if cmx~=0
    cmap=cmap/cmx;
end
pmap=pmap-min(min(pmap));
pmx=max(max(pmap));
if pmx~=0
    pmap=pmap/pmx;
end

gsm=0.5*cmap+0.5*pmap;
mask=beta.gsm*gsm;
mask=mask-min(min(mask));
mask=255*mask/max(max(mask));
