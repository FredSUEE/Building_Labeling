function out=getpatchhist_demo(j,rx,ptidx,ptbin)
len=length(ptidx);
pht=[];
for k=1:len
    plabel=ptidx{k}{j};
    tmp=hist(plabel(rx),ptbin{j});
    pht=[pht,tmp];
end
out=pht/sum(pht);

