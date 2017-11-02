function [inliers] = ransac(loc11, loc22, nofsample, threshold)
% 4-point RANSAC fitting
% Input:
% loc11 - match points from image A, a matrix of 3xN, the third row is 1
% loc22 - match points from image B, a matrix of 3xN, the third row is 1
% thd - distance threshold
% npoints - number of samples
% 
%output:
%inliers

ninlier = 0;
fpoints = 4; %number of fitting points
for i=1:2000
rd = randi([1 nofsample],1,fpoints);
pR = loc11(:,rd);
pD = loc22(:,rd);
h = getHomography(pR,pD,size(pR,2));
rref_P = h*loc11;
rref_P(1,:) = rref_P(1,:)./rref_P(3,:);
rref_P(2,:) = rref_P(2,:)./rref_P(3,:);
error = (rref_P(1,:) - loc22(1,:)).^2 + (rref_P(2,:) - loc22(2,:)).^2;
n = nnz(error<threshold);
if(n >= nofsample*.95)
hh=h;
inliers = find(error<threshold);
pause();
break;
elseif(n>ninlier)
ninlier = n;
hh=h;
inliers = find(error<threshold);
end 
end
end