function ImSp=dosuperpixels(Img,Nset,spar)
% Get superpixels

I = im2double(Img);

addpath('.\superpixels\BerkeleySegCode\Detectors');
addpath('.\superpixels\BerkeleySegCode\Gradients');
addpath('.\superpixels\BerkeleySegCode\Util');
addpath('.\superpixels\BerkeleySegCode\Textons');
addpath('.\superpixels\BerkeleySegCode\Filters');
addpath('.\superpixels\BerkeleySegCode\Benchmark');
addpath('.\superpixels\BerkeleySegCode\CSA++');
addpath('.\superpixels\BerkeleySegCode\Dataset');
addpath('.\superpixels\BerkeleySegCode\include');
addpath('.\superpixels\yu_imncut');
addpath('.\superpixels');


N = size(I,1);
M = size(I,2);

% Number of superpixels coarse/fine.
N_sp=Nset(1);
% Number of eigenvectors.
N_ev=spar.ev;


% ncut parameters for superpixel computation
diag_length = sqrt(N*N + M*M);
par = imncut_sp;
par.int=0;
par.pb_ic=1;
par.sig_pb_ic=0.05;
par.sig_p=ceil(diag_length/50);
par.verbose=0;
par.nb_r=ceil(diag_length/60);
par.rep = -0.005;  % stability?  or proximity?
par.sample_rate=0.2;
par.nv = N_ev;
par.sp = N_sp;

% Intervening contour using mfm-pb
fprintf('running PB\n');
[emag,ephase] = pbWrapper(I,par.pb_timing);
emag = pbThicken(emag);
par.pb_emag = emag;
par.pb_ephase = ephase;
clear emag ephase;

st=clock;
fprintf('Ncutting...');
[Sp,Seg] = imncut_sp(I,par);
fprintf(' took %.2f minutes\n',etime(clock,st)/60);


ImSp{1}=Sp;
Spc=Sp;
for j=1:length(Nset)-1
    st=clock;
    fprintf('Fine scale superpixel computation...');
    Spp= clusterLocations(Spc,ceil(N*M/Nset(j+1)));
    fprintf(' took %.2f minutes\n',etime(clock,st)/60);
    ImSp{j+1}=Spp;
    Spc=Spp;
   
end



