clc
close all;
clear;
load ALPHTRAININGSET;
load NUMTRAININGSET;
totalAphs=size(ALPHTRAIN,2);
totalNums=size(NUMTRAIN,2);



% SELECTING THE TEST DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
picture = imread('carPlaque.jpg');
figure
subplot(1,2,1)
imshow(picture)
picture=imresize(picture,[300 500]);
subplot(1,2,2)
imshow(picture)


%RGB2GRAY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
picture=rgb2gray(picture);
figure
subplot(1,2,1)
imshow(picture)

% THRESHOLDIG and CONVERSION TO A BINARY IMAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
threshold = graythresh(picture);
picture =~imbinarize(picture,threshold);
subplot(1,2,2)
imshow(picture)


% Removing the small objects and background
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
figure
picture = bwareaopen(picture,50); 
subplot(1,3,1)
imshow(picture)
background=bwareaopen(picture,5000);
subplot(1,3,2)
imshow(background)
picture2=picture-background;
subplot(1,3,3)
imshow(picture2)



% Labeling connected components
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
imshow(picture)
[L,Ne]=bwlabel(picture);
propied=regionprops(L,'BoundingBox');
hold on
for n=1:size(propied,1)
            rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',1)
       
   
end
hold off



% Decision Making
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
final_output=[];
t=[];
count = 0;
n = 1;
upY = 0;
previousXend = 0;
while n <= Ne
    if count == 8
        break;
    end
    [r,c] = find(L==n);
    if (max(r)-min(r))* (max(c)-min(c)) < 200 ||  max(r) < upY || min(c) < previousXend
        n = n + 1;
        continue;
    end
    if count == 2
        [rNext,cNext] = find(L==n+1);
        if min(cNext) < max(c) && max(cNext) < max(c)
            if min(rNext) > min(r)
                row = r;
            else
                row = rNext;
            end
            if max(rNext) > max(r)
                row2 = rNext;
            else
                row2 = r;
            end
            Y=picture2(min(row):max(row2),min(c):max(c));
            Y=imresize(Y,[42,24]);
            imshow(Y)
            pause(10)
            n = n + 1;
        else
            Y=picture2(min(r):max(r),min(c):max(c));
            imshow(Y)
            Y=imresize(Y,[42,24]);
            imshow(Y)
            pause(0.2)
        end
        total = totalAphs;
        TRAIN = ALPHTRAIN;
    else
        Y=picture2(min(r):max(r),min(c):max(c));
        total = totalNums;
        TRAIN = NUMTRAIN;
    end

    imshow(Y)
    Y=imresize(Y,[42,24]);
    imshow(Y)
    pause(0.2)

    ro=zeros(1,total);
    for k=1:total   
        ro(k)=corr2(TRAIN{1,k},Y);
    end
    [MAXRO,pos]=max(ro);
    if MAXRO>.45
        out=cell2mat(TRAIN(2,pos));       
        final_output=[final_output out];
        count = count + 1;
        previousXend = max(c);
        if count == 7
            upY = min(r);
        end
    end
    n = n + 1;
end



% Printing the plate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file = fopen('number_Plate.txt', 'wt');
fprintf(file,'%s\n',final_output);
fclose(file);
winopen('number_Plate.txt')