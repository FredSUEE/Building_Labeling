function [sout1,sout2]=do_simrank_demo(Iset,Rnode,GNode,par,argv,argm)
st=clock;
fprintf('Building W matrix computation...');
W=BuildWmatrix_demo(Iset,Rnode,GNode,par,argv,argm);
W=sparse(W);
fprintf(' took %.2f minutes\n',etime(clock,st)/60);
%%
st=clock;
fprintf('Run simrank computation...');
[sout1,sout2]=GetSimRank_demo(W,par.lev,GNode,par,argm);
fprintf(' took %.2f minutes\n',etime(clock,st)/60);
