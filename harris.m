function [x,y,R]=harris(image)
%compute Harris corner
%input: image
%output: x,y:coordinates of corner
%        R: Harris R function  

g=fspecial('gaussian',[7 7],1);

%blur image with gaussian kernel
I=double(image);
I=imfilter(I,g);

%sobel operators
sobel=fspecial('sobel');
Ix=imfilter(I,sobel,'replicate','same');
Iy=imfilter(I,sobel','replicate','same');

%apply window function(gaussian)
Ix2=imfilter(Ix.^2, g, 'same'); 
Iy2=imfilter(Iy.^2, g, 'same');
Ixy=imfilter(Ix.*Iy, g, 'same');

%compute R
[height,width]=size(I);
R=zeros(height,width);
for i=1:height
    for j=1:width
        M=[Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)];
        R(i,j)=det(M)-0.05*(trace(M))^2;
    end
end

%non-maximum suppression
localmax=ordfilt2(R,5^2,true(5)); 
R=R.*(and(R==localmax, R>0));


[x,y]=find(R);
end