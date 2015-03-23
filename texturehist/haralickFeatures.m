function [ feats ] = haralickFeatures( param , n_greylevels)
%HARALICKFEATURES actually 13 features in one.
% if none of these actually are of use, at least the co-occurrence matrices
% should be handy for some other feature(s)
%
%
% based on Miyamoto, Meryman Jr. (2005);
%   "Fast Calculation of Haralick Texture Features"

if ~isfield(param, 'grey')
   param.grey = rgb2gray(param.rgb); 
end
if ~exist('n_greylevels', 'var')
    n_greylevels = 32;
end

feats_sep = zeros(13,4);

% first, calculate the grey-level co-occurrence matrices

% pre-allocate matrices
p_0 = graycomatrix(param.grey);
p_45 = graycomatrix(param.grey, 'Offset', [-1 1]);
p_90 = graycomatrix(param.grey, 'Offset', [-1 0]);
p_135 = graycomatrix(param.grey, 'Offset', [-1 -1]);


% calculate properties of the matrices

R_0 = sum(sum(p_0));
R_45 = sum(sum(p_45));
R_90 = sum(sum(p_90));
R_135 = sum(sum(p_135));

smallp_0 = p_0 / R_0;
smallp_45 = p_45 / R_45;
smallp_90 = p_90 / R_90;
smallp_135 = p_135 / R_135;

smallpx_0 = sum(smallp_0, 2);
smallpx_45 = sum(smallp_45, 2);
smallpx_90 = sum(smallp_90, 2);
smallpx_135 = sum(smallp_135, 2);

mux_0 = mean(smallpx_0);
mux_45 = mean(smallpx_45);
mux_90 = mean(smallpx_90);
mux_135 = mean(smallpx_135);
stdevx_0 = std(smallpx_0);
stdevx_45 = std(smallpx_45);
stdevx_90 = std(smallpx_90);
stdevx_135 = std(smallpx_135);

smallpy_0 = sum(smallp_0, 1);
smallpy_45 = sum(smallp_45, 1);
smallpy_90 = sum(smallp_90, 1);
smallpy_135 = sum(smallp_135, 1);

muy_0 = mean(smallpy_0);
muy_45 = mean(smallpy_45);
muy_90 = mean(smallpy_90);
muy_135 = mean(smallpy_135);
stdevy_0 = std(smallpy_0);
stdevy_45 = std(smallpy_45);
stdevy_90 = std(smallpy_90);
stdevy_135 = std(smallpy_135);

smallp_xply_0 = zeros(n_greylevels*2, 1);
smallp_xply_45 = zeros(n_greylevels*2, 1);
smallp_xply_90 = zeros(n_greylevels*2, 1);
smallp_xply_135 = zeros(n_greylevels*2, 1);
for k = 2 : n_greylevels * 2
   for i = 1 : n_greylevels
      if i >= k; break; end
      if (k-i) > size(smallp_0, 2) ; break; end
      smallp_xply_0(k) = smallp_xply_0(k) + smallp_0(i, k-i);
      smallp_xply_45(k) = smallp_xply_45(k) + smallp_45(i, k-i);
      smallp_xply_90(k) = smallp_xply_90(k) + smallp_90(i, k-i);
      smallp_xply_135(k) = smallp_xply_135(k) + smallp_135(i, k-i);
   end
end

smallp_xmny_0 = zeros(n_greylevels-1, 1);
smallp_xmny_45 = zeros(n_greylevels-1, 1);
smallp_xmny_90 = zeros(n_greylevels-1, 1);
smallp_xmny_135 = zeros(n_greylevels-1, 1);
for k = 1 : n_greylevels - 1
    for i = 1 : n_greylevels
        if i == k; continue; end
        % |i - j| = (k-1)
        % i - j = k-1 V j - i = k-1
        if i < k
            j = i + k - 1;
        else
            j = i - k + 1;
        end
        if j > 256; continue; end
        if i > size(smallp_0, 1); continue; end
        if j > size(smallp_0, 2); continue; end
        smallp_xmny_0(k) = smallp_xmny_0(k) + smallp_0(i, j);
        smallp_xmny_45(k) = smallp_xmny_45(k) + smallp_45(i, j);
        smallp_xmny_90(k) = smallp_xmny_90(k) + smallp_90(i, j);
        smallp_xmny_135(k) = smallp_xmny_135(k) + smallp_135(i, j);
    end
end

HXY1_0 = 0; HXY1_45 = 0; HXY1_90 = 0; HXY1_135 = 0;
HXY2_0 = 0; HXY2_45 = 0; HXY2_90 = 0; HXY2_135 = 0;

for i = 1 : n_greylevels
    for j = 1 : n_greylevels
        if j <= numel(smallpx_0) && i <= numel(smallpx_0)
            lgxy_0 = log(smallpx_0(i) * smallpy_0(j) + eps); if isinf(lgxy_0); lgxy_0 = 0; end
            lgxy_45 = log(smallpx_45(i) * smallpy_45(j) + eps); if isinf(lgxy_45); lgxy_45 = 0; end
            lgxy_90 = log(smallpx_90(i) * smallpy_90(j) + eps); if isinf(lgxy_90); lgxy_90 = 0; end
            lgxy_135 = log(smallpx_135(i) * smallpy_135(j) + eps); if isinf(lgxy_135); lgxy_135 = 0; end
            
            HXY2_0 = HXY2_0 - smallpx_0(i) * smallpy_0(j) * lgxy_0;
            HXY2_45 = HXY2_45 - smallpx_45(i) * smallpy_45(j) * lgxy_45;
            HXY2_90 = HXY2_90 - smallpx_90(i) * smallpy_90(j) * lgxy_90;
            HXY2_135 = HXY2_135 - smallpx_135(i) * smallpy_135(j) * lgxy_135;
            
            if j <= size(smallp_0, 2)
                HXY1_0 = HXY1_0 - smallp_0(i,j) * lgxy_0;
                HXY1_45 = HXY1_45 - smallp_45(i,j) * lgxy_45;
                HXY1_90 = HXY1_90 - smallp_90(i,j) * lgxy_90;
                HXY1_135 = HXY1_135 - smallp_135(i,j) * lgxy_135;
            end
        end
    end
end

mu_0 = mean(mean(smallp_0));
mu_45 = mean(mean(smallp_45));
mu_90 = mean(mean(smallp_90));
mu_135 = mean(mean(smallp_135));

% now come the features.

%1,3,4,5,9
for i = 1 : size(smallp_0, 1)%n_greylevels
    for j = i : size(smallp_0,2)%n_greylevels
        
        feats_sep(1,1) = feats_sep(1,1) + 2*smallp_0(i,j)^2;
        feats_sep(1,2) = feats_sep(1,2) + 2*smallp_45(i,j)^2;
        feats_sep(1,3) = feats_sep(1,3) + 2*smallp_90(i,j)^2;
        feats_sep(1,4) = feats_sep(1,4) + 2*smallp_135(i,j)^2;
        
        feats_sep(3,1) = feats_sep(3,1) + 2* i*j * smallp_0(i,j);
        feats_sep(3,2) = feats_sep(3,2) + 2* i*j * smallp_45(i,j);
        feats_sep(3,3) = feats_sep(3,3) + 2* i*j * smallp_90(i,j);
        feats_sep(3,4) = feats_sep(3,4) + 2* i*j * smallp_135(i,j);
        
        feats_sep(4,1) = feats_sep(4,1) + 2* ((i - mu_0)^2) * smallp_0(i,j);
        feats_sep(4,2) = feats_sep(4,2) + 2* ((i - mu_45)^2) * smallp_45(i,j);
        feats_sep(4,3) = feats_sep(4,3) + 2* ((i - mu_90)^2) * smallp_90(i,j);
        feats_sep(4,4) = feats_sep(4,4) + 2* ((i - mu_135)^2) * smallp_135(i,j);
        
        c = 2* (1 / (1 + (i - j)^2));
        feats_sep(5,1) = feats_sep(5,1) + c * smallp_0(i,j);
        feats_sep(5,2) = feats_sep(5,2) + c * smallp_45(i,j);
        feats_sep(5,3) = feats_sep(5,3) + c * smallp_90(i,j);
        feats_sep(5,4) = feats_sep(5,4) + c * smallp_135(i,j);
        
        feats_sep(9,1) = feats_sep(9,1) - 2* smallp_0(i,j) * log(smallp_0(i,j) + eps);
        feats_sep(9,2) = feats_sep(9,2) - 2* smallp_45(i,j) * log(smallp_45(i,j) + eps);
        feats_sep(9,3) = feats_sep(9,3) - 2* smallp_90(i,j) * log(smallp_90(i,j) + eps);
        feats_sep(9,4) = feats_sep(9,4) - 2* smallp_135(i,j) * log(smallp_135(i,j) + eps);
        
    end
end

feats_sep(3,1) = (feats_sep(3,1) - mux_0*muy_0) / (stdevx_0 * stdevy_0);
feats_sep(3,2) = (feats_sep(3,2) - mux_45*muy_45) / (stdevx_45 * stdevy_45);
feats_sep(3,3) = (feats_sep(3,3) - mux_90*muy_90) / (stdevx_90 * stdevy_90);
feats_sep(3,4) = (feats_sep(3,4) - mux_135*muy_135) / (stdevx_135 * stdevy_135);

%2,11
for k = 1 : numel(smallp_xmny_0)
    feats_sep(2,1) = feats_sep(2,1) + k^2 * smallp_xmny_0(k);
    feats_sep(2,2) = feats_sep(2,2) + k^2 * smallp_xmny_45(k);
    feats_sep(2,3) = feats_sep(2,3) + k^2 * smallp_xmny_90(k);
    feats_sep(2,4) = feats_sep(2,4) + k^2 * smallp_xmny_135(k);
    
    feats_sep(11,1) = feats_sep(11,1) - smallp_xmny_0(k) * log(smallp_xmny_0(k) + eps);
    feats_sep(11,2) = feats_sep(11,2) - smallp_xmny_45(k) * log(smallp_xmny_45(k) + eps);
    feats_sep(11,3) = feats_sep(11,3) - smallp_xmny_90(k) * log(smallp_xmny_90(k) + eps);
    feats_sep(11,4) = feats_sep(11,4) - smallp_xmny_135(k) * log(smallp_xmny_135(k) + eps);
end

%6,8
for i = 2 : n_greylevels*2
    feats_sep(6,1) = feats_sep(6,1) + i * smallp_xply_0(i);
    feats_sep(6,2) = feats_sep(6,2) + i * smallp_xply_45(i);
    feats_sep(6,3) = feats_sep(6,3) + i * smallp_xply_90(i);
    feats_sep(6,4) = feats_sep(6,4) + i * smallp_xply_135(i);
    
    feats_sep(8,1) = feats_sep(8,1) - smallp_xply_0(i) * log(smallp_xply_0(i) + eps);
    feats_sep(8,2) = feats_sep(8,2) - smallp_xply_45(i) * log(smallp_xply_45(i) + eps);
    feats_sep(8,3) = feats_sep(8,3) - smallp_xply_90(i) * log(smallp_xply_90(i) + eps);
    feats_sep(8,4) = feats_sep(8,4) - smallp_xply_135(i) * log(smallp_xply_135(i) + eps);
end

%7
for i = 2 : n_greylevels*2
    feats_sep(7,1) = feats_sep(7,1) + ((i - feats_sep(8,1))^2) * smallp_xply_0(i);
    feats_sep(7,2) = feats_sep(7,2) + ((i - feats_sep(8,2))^2) * smallp_xply_45(i);
    feats_sep(7,3) = feats_sep(7,3) + ((i - feats_sep(8,3))^2) * smallp_xply_90(i);
    feats_sep(7,4) = feats_sep(7,4) + ((i - feats_sep(8,4))^2) * smallp_xply_135(i);
end

%10
feats_sep(10,1) = var(smallp_xmny_0);
feats_sep(10,2) = var(smallp_xmny_45);
feats_sep(10,3) = var(smallp_xmny_90);
feats_sep(10,4) = var(smallp_xmny_135);

%12
HX_0 = entropy(smallpx_0);
HX_45 = entropy(smallpx_45);
HX_90 = entropy(smallpx_90);
HX_135 = entropy(smallpx_135);
HY_0 = entropy(smallpy_0);
HY_45 = entropy(smallpy_45);
HY_90 = entropy(smallpy_90);
HY_135 = entropy(smallpy_135);

feats_sep(12,1) = (feats_sep(9,1) - HXY1_0) / max([HX_0 HY_0]);
feats_sep(12,2) = (feats_sep(9,2) - HXY1_45) / max([HX_45 HY_45]);
feats_sep(12,3) = (feats_sep(9,3) - HXY1_90) / max([HX_90 HY_90]);
feats_sep(12,4) = (feats_sep(9,4) - HXY1_135) / max([HX_135 HY_135]);

%13
feats_sep(13,1) = sqrt(1 - exp(-2 * (HXY2_0 - feats_sep(9,1))));
feats_sep(13,2) = sqrt(1 - exp(-2 * (HXY2_45 - feats_sep(9,2))));
feats_sep(13,3) = sqrt(1 - exp(-2 * (HXY2_90 - feats_sep(9,3))));
feats_sep(13,4) = sqrt(1 - exp(-2 * (HXY2_135 - feats_sep(9,4))));



feats = mean(feats_sep, 2);
