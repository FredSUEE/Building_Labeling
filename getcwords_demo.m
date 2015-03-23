function [clab,cbin]=getcwords_demo(cvecc,cvector,par)
codebook_size=par.ccodebook;
cluster_maxnum=par.cclusternum;
des=cvector;
randid=floor(size(des,1)*rand(1,codebook_size))'+1;
randcen=des(randid,:);
[cenv,cenl] = do_kmeans(des', codebook_size, cluster_maxnum,randcen');
cenl=cenl+1;
%cenv=cenv';
clab{1}=cenl(1:size(cvecc{1},1));
clab{2}=cenl(size(cvecc{1},1)+1:length(cenl));
cbin=1:codebook_size;

