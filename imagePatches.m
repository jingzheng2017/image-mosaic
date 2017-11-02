function [loc,patch] = imagePatches(image,x,y)
%compute image patches centered at corners and coordinates of corners
%input:image
%      x,y:coordinates of corners

%output:patch and loc

% the corners detected
s=5;
step = (s-1)/2;
loc = [x,y];

% remove points close to boundary
loc = loc(loc(:,1)>2 & loc(:,1)<size(image,1)-1 & loc(:,2)>2 & loc(:,2)<size(image,2)-1, :);
n = size(loc,1);

% squeenze image patches into long vectors
patch = zeros(n,s*s);

for m = 1:n
    xmin = loc(m,2)-step;
    ymin = loc(m,1)-step; 
    crop = imcrop(image, [xmin ymin s-1 s-1]);
    patch(m,:) = crop(:);    
end

for m = 1:n
    patch(m,:) = (patch(m,:) - mean2(patch(m,:))) ./ std2(patch(m,:));  
end

end
