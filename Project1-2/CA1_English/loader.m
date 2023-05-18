clc;           
clear;        
close all;  

directory=dir('Map Set');
st={directory.name};
name=st(3:end);
len=length(name);

TRAIN=cell(2,len);
for i=1:len
   TRAIN(1,i)={imread(['Map Set','\',cell2mat(name(i))])};
   temp=cell2mat(name(i));
   TRAIN(2,i)={temp(1)};
end

save('TRAININGSET.mat','TRAIN');
clear;