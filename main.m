clear all;
%read in two images
image1=imread('/Users/jingzheng/Downloads/image mosaic/DanaHallWay/1.JPG');
image2=imread('/Users/jingzheng/Downloads/image mosaic/DanaHallWay/2.JPG');

%grayscale and get size of image
img1=rgb2gray(image1);
img2=rgb2gray(image2);
[h1,w1]=size(img1);
[h2,w2]=size(img2);

%compute harris corner and R function
[x1,y1,R1]=harris(img1);
[x2,y2,R2]=harris(img2);
figure;
imshow(image1);
hold on;
plot(x1,y1,'r.');
figure;
imshow(image2);
hold on;
plot(x2,y2,'r.');

%find image patch and squeeze it into vector so patches ncorners*64 matrix
[loc1,patch1]=imagePatches(img1,x1,y1);
[loc2,patch2]=imagePatches(img2,x2,y2);

%compute NCC
[ncc,pairs]=ncc(patch1,patch2);

%show the relation of two image's corners that have large NCC
nofpoints=size(pairs,1);
loc11=[(loc1(pairs(:,1),:))';ones(1,nofpoints)];
loc22=[(loc2(pairs(:,2),:))';ones(1,nofpoints)];
linkpoints(image1,image2,loc11,loc22);

%RANSAC to fit homography
inliers=ransac(loc11, loc22, nofpoints, 14);
matcher1=loc11(:,inliers);
matcher2=loc22(:,inliers);
linkpoints(image1,image2,matcher1,matcher2);
H=getHomography(matcher1,matcher2,size(matcher1,2));

%determine the size of output image
[Height,Width,tf_x1,tf_y1,tf_x2, tf_y2]=getNewSize(H,h1,w1,h2,w2);



newImage = zeros(Height, Width, 3);
for i = 1:Height
    for j = 1:Width
        coordinates=[i-tf_x2+1; j-tf_y2+1; 1];
        new_coor=H\coordinates;
        r=fix(new_coor(1)/new_coor(3));
        c=fix(new_coor(2)/new_coor(3));
        if (r>=1 && r<=h1 && c>=1 && c<=w1)
                newImage(i,j,:)=image1(r,c,:);
        else
            continue;
        end
    end
end
% BLEND IMAGE BY CROSS DISSOLVE
[newImage] = blend(newImage, image2, tf_x2, tf_y2, h2, w2);
% DISPLAY IMAGE MOSIAC
figure;
imshow(uint8(newImage));







