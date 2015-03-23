function [matches, scores, points] = sift_match(im1, siftFeature)
% input: RGB images 1 and 2
% output: matches: matches 
%         scores: the squared Euclidean distance between the matches
%         matches: points of matches

Ia = single(rgb2gray(im1));
% Ib = single(rgb2gray(im2));
[fa, da] = vl_dsift(Ia, 'Step', 5);
% [fb, db] = vl_dsift(Ib, 'Step', 5);

% only keep those points in co-saliency region
fa_new = [];
da_new = [];
points_in_a = round(fa(1:2, :));
for i = 1 : size(points_in_a, 2)
    if (Ia(points_in_a(2,i), points_in_a(1,i)) > 0)
        fa_new = [fa_new, fa(:, i)]; 
        da_new = [da_new, da(:, i)];
    end
end
% fb_new = [];
% db_new = [];
% points_in_b = round(fb(1:2, :));
% for i = 1 : size(points_in_b, 2)
%     if (Ib(points_in_b(2,i), points_in_b(1,i)) > 0)
%         fb_new = [fb_new, fb(:, i)]; 
%         db_new = [db_new, db(:, i)];
%     end
% end

fa = fa_new;
% fb = fb_new;
da = da_new;
% db = db_new;
[matches, scores] = vl_ubcmatch(da, siftFeature, 1.3); % here is the threshold
points = size(matches,2);

end

