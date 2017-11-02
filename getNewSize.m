function [Height,Width,tf_x1,tf_y1,tf_x2, tf_y2] = getNewSize(homography,h1,w1,h2,w2)
% Calculate the size of new mosaic
% Input:
% homography - homography matrix
% h1 - height of image1 that needs to be warped
% w1 - width of image1 that needs to be warped
% h2 - height of the unwarped image2
% w2 - width of the unwarped image2 
% Output:
% H - height of the new image
% W - width of the new image
% tf_x1 - x coordate of lefttop corner of new image1
% tf_y1 - y coordate of lefttop corner of new image1
% tf_x2 - x coordate of lefttop corner of unwarped image2
% tf_y2 - y coordate of lefttop corner of unwarped image2

% CREATE MESH-GRID FOR THE WARPED IMAGE1
[X,Y]=meshgrid(1:h1,1:w1);
M=ones(3,h1*w1);
M(1,:)=reshape(X,1,h1*w1);
M(2,:)=reshape(Y,1,h1*w1);

% determine the four corner of new big image
newM=homography*M;
top=fix(min(1,min(newM(1,:)./newM(3,:))));
bottom=fix(max(h2,max(newM(1,:)./newM(3,:))));
left=fix(min(1,min(newM(2,:)./newM(3,:)))); %negative
right=fix(max(w2,max(newM(2,:)./newM(3,:))));

Height=bottom-top+1;
Width=right-left+1;

tf_x2=2-top;
tf_y2=2-left;

tf_x1=max(1,fix(min(newM(1,:)./newM(3,:))));
tf_y1=1;
end