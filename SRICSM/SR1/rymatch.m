% num = match(image1, image2)
%
% This function reads two images, finds their SIFT features, and
%   displays lines connecting the matched keypoints.  A match is accepted
%   only if its distance is less than distRatio times the distance to the
%   second closest match.
% It returns the number of matches displayed.
%
% Example: match('scene.pgm','book.pgm');

function  [c,num]= rymatch(des1, des2,distRatio)

% Find SIFT keypoints for each image
% [im1, des1, loc1] = ysift(gray1);
% [im2, des2, loc2] = ysift(gray2);

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
 
%a=[];
%b=[];
% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
match=zeros(1,size(des1,1));
a=match;b=match;
for i = 1 : size(des1,1)%第一幅图片的行数
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products；des1(i,:)第i行128列；des2t有128行，有（第二幅图的行数）列。
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results vals最短欧式距离，indx指数，最短欧式距离所在的列数
   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
       a(i)=i;
       match(i) = indx(1);
       b(i)=match(i);
   else
      %match(i) = 0;
   end
end
a(a==0)=[];b(b==0)=[];
c=[a;b];
%num = sum(match > 0);
num=length(a);

% Create a new image showing the two images side by side.
% im3 = yappendimages(im1,im2);

% Show a figure with lines joining the accepted matches.
% figure('Position', [100 100 size(im3,2) size(im3,1)]);
% colormap('gray');
% imagesc(im3);
% hold on;
% cols1 = size(im1,2);
% for i = 1: size(des1,1)
%   if (ymatch(i) > 0)
%     line([loc1(i,2) loc2(ymatch(i),2)+cols1], ...
%          [loc1(i,1) loc2(ymatch(i),1)], 'Color', 'c');
%   end
% end
% hold off;





