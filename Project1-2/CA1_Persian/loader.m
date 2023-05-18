clc;           
clear;        
close all;  


numDi=dir('numbers');
numSt={numDi.name};
numNam=numSt(3:end);
numLen=length(numNam);


NUMTRAIN=cell(2,numLen);
for i=1:numLen
   NUMTRAIN(1,i)={imread(['numbers','\',cell2mat(numNam(i))])};
   numTemp=cell2mat(numNam(i));
   NUMTRAIN(2,i)={numTemp(1)};
end

save('NUMTRAININGSET.mat','NUMTRAIN');

alphDi=dir('alphabets');
alphSt={alphDi.name};
alphNam=alphSt(3:end);
alphLen=length(alphNam);


ALPHTRAIN=cell(2,alphLen);
for i=1:alphLen
   ALPHTRAIN(1,i)={imread(['alphabets','\',cell2mat(alphNam(i))])};
   temp=cell2mat(alphNam(i));
   ALPHTRAIN(2,i)={temp(1)};
end

save('ALPHTRAININGSET.mat','ALPHTRAIN');

len=numLen + alphLen;


TRAIN=cell(2,len);
for i=1:numLen
   TRAIN(1,i)={imread(['numbers','\',cell2mat(numNam(i))])};
   temp=cell2mat(numNam(i));
   TRAIN(2,i)={temp(1)};
end
for i=numLen+1:len
   TRAIN(1,i)={imread(['alphabets','\',cell2mat(alphNam(i-numLen))])};
   temp=cell2mat(alphNam(i-numLen));
   TRAIN(2,i)={temp(1)};
end

save('TRAININGSET.mat','TRAIN');

clear;