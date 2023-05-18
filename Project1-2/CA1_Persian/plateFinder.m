clc
close all;
clear;
load TRAININGSET;
total=size(TRAIN,2);


[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose an image');
s=[path,file];
picture2=imread(s);
figure
subplot(1,2,1)
imshow(picture2)
picture2=imresize(picture2,[300 500]);
imshow(picture2);

picture=rgb2gray(picture2);
figure
subplot(1,2,1)
imshow(picture)

% THRESHOLDIG and CONVERSION TO A BINARY IMAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
threshold = graythresh(picture);
picture =~imbinarize(picture,threshold);
subplot(1,2,2)
imshow(picture)



picture=imresize(picture,[300 500]);
picture = bwareaopen(picture,30); 
figure
imshow(picture)
[L,Ne]=bwlabel(picture);

figure
final_output=[];

count = 0;
valids = zeros(4, total);
for n=1:Ne
    [r,c] = find(L==n);
    Y=picture(min(r):max(r),min(c):max(c));
    imshow(Y)
    Y=imresize(Y,[42,24]);
    ro=zeros(1,total);
    for k=1:total 
        ro(k)=corr2(TRAIN{1,k},Y);
    end
    [MAXRO,pos]=max(ro);
    if MAXRO>.45
        valids(1, count + 1) = min(r);
        valids(2, count + 1) = max(r);
        valids(3, count + 1) = min(c);
        valids(4, count + 1) = max(c);
        out=cell2mat(TRAIN(2,pos));       
        final_output=[final_output out];
        count = count + 1;
    end
end

[~, iy1] = sort(valids(1,:));
minRowSorted = valids(:,iy1);
midIndex = fix((total - count + 1 + total)/ 2);
midMinRow = minRowSorted(1, midIndex);

[~, iy2] = sort(valids(2,:));
maxRowSorted = valids(:,iy2);
midMaxRow = maxRowSorted(2, midIndex);

midMinCol = valids(3, fix(( count + 1 )/ 2));

[~, ix] = sort(valids(4,:));
maxColSorted = valids(:,ix);
midMaxCol = maxColSorted(4, midIndex);


maxC = 0;
minC = 10000;
minR = 10000;
maxR = 0;
for n=1:count
    if abs(valids(1,n) - midMinRow) < 20 && abs(valids(2,n) - midMaxRow) < 20 && abs(valids(3,n) - midMinCol) < 200 &&  abs(valids(4,n) - midMaxCol) < 300
        minR = min(minR, valids(1, n));
        maxR = max(maxR, valids(2,n));
        minC = min(minC, valids(3,n));
        maxC = max(maxC, valids(4,n));
    end
end
imshow(picture2);

if count < 7
     X = imcrop(picture2, [minC-20, minR-20, maxC- minC+70, maxR-minR+40 ]);
else
    X = imcrop(picture2, [minC-20, minR-20, maxC- minC+40, maxR-minR+40 ]);
end
imshow(X);
imwrite(X, "carPlaque.jpg");