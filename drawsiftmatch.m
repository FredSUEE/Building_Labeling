% read image

% I1 = imread('1.jpg');
% I2 = imread('2.jpg');

% convert to single
im1 = im{3};
im2 = im{5};
% im2 = imread('2.jpg');
Ia = single(rgb2gray(im1));
Ib = single(rgb2gray(im2));
[fa, da] = vl_dsift(Ia, 'Step', 5);
[fb, db] = vl_dsift(Ib, 'Step', 5);

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
fb_new = [];
db_new = [];
points_in_b = round(fb(1:2, :));
for i = 1 : size(points_in_b, 2)
    if (Ib(points_in_b(2,i), points_in_b(1,i)) > 0)
        fb_new = [fb_new, fb(:, i)]; 
        db_new = [db_new, db(:, i)];
    end
end

fa = fa_new;
fb = fb_new;
da = da_new;
db = db_new;
[matches, scores] = vl_ubcmatch(da, db, 1.3); % here is the threshold

% plot the SIFT desciptors
num_plot = min(size(fa,2), size(fb,2)); 
figure(1);
imshow(im1);
hold on
plot(fa(1,:), fa(2,:), 'r*');
% perm = randperm(size(fa,2));
% sel = perm(1:num_plot);
% h1a = vl_plotframe(fa(:,sel));
% h2a = vl_plotframe(fa(:,sel));
% set(h1a,'color','k','linewidth',3);
% set(h2a,'color','y','linewidth',2);

figure(2);
imshow(im2);
hold on
plot(fb(1,:), fb(2,:), '*');
% perm = randperm(size(fb,2));
% sel = perm(1:num_plot);
% h1b = vl_plotframe(fb(:,sel));
% h2b = vl_plotframe(fb(:,sel));
% set(h1b,'color','k','linewidth',3);
% set(h2b,'color','y','linewidth',2);

%%%%%%%%%%%%%%%%
% Create a new image showing the two images side by side.
im3 = appendimages(im1,im2);

% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(im3,2) size(im3,1)]);
colormap('gray');
imagesc(im3);
hold on;

cols1 = size(im1,2);
for i = 1 : size(matches, 2)
     line([fa(1, matches(1, i)) fb(1, matches(2, i))+cols1], ...
         [fa(2, matches(1, i)) fb(2, matches(2, i))], 'Color', 'c');
end

fprintf('Found %d matches.\n', size(matches,2));