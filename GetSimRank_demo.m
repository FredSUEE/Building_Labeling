function [sout1,sout2]=GetSimRank_demo(W,lev,GNode,par,argm)
%%
if strcmp(argm,'alltree')
    n1=find(GNode(:,1)==1 & GNode(:,2)==lev);
    n2=find(GNode(:,1)==2 & GNode(:,2)==lev);

    for j=1:length(n1)
        nd1=n1(j);
        nd1max(j)=simrank_demo(W,nd1,nd1,par);
    end

    for k=1:length(n2)
        nd2=n2(k);
        nd2max(k)=simrank_demo(W,nd2,nd2,par);
    end

    for j=1:length(n1)
        fprintf('This is the %d th iteration in %d \n',j,length(n1));
        nd1=n1(j);
        tmp=0;
        for k=1:length(n2)
            nd2=n2(k);
            tmpp=simrank_demo(W,nd1,nd2,par);
            tmp(k)=tmpp/max(nd1max(j),nd2max(k));
        end
        temp(j,:)=tmp;
    end
    [mv1,md1]=max(temp');
    %mv1=mv1./nd1max;
    [mv2,md2]=max(temp);
    %mv2=mv2./nd2max;

    sout1=[n1,n2(md1),mv1'];
    sout2=[n2,n1(md2),mv2'];
    smatrix=temp;    
elseif strcmp(argm,'onetree')
    n1=find(GNode(:,1)==1 & GNode(:,2)==lev);
    n2=find(GNode(:,1)==2 & GNode(:,2)==lev);

    for j=1:length(n1)
        nd1=n1(j);
        nd1max(j)=simrank2(W,nd1,nd1,par);
    end

    for k=1:length(n2)
        nd2=n2(k);
        nd2max(k)=simrank2(W,nd2,nd2,par);
    end

    for j=1:length(n1)
        fprintf('This is the %d th iteration in %d \n',j,length(n1));
        nd1=n1(j);
        tmp=0;
        for k=1:length(n2)
            nd2=n2(k);
            tmp(k)=simrank2(W,nd1,nd2,par);
        end
        temp(j,:)=tmp;
    end
    [mv1,md1]=max(temp');
    mv1=mv1./nd1max;
    [mv2,md2]=max(temp);
    mv2=mv2./nd2max;

    sout1=[n1,n2(md1),mv1'];
    sout2=[n2,n1(md2),mv2'];
    smatrix=temp;    
end



