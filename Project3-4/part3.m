clc;           
clear;        
close all; 

%Part 3,1:
str = 'signal';
measureCorrectness(str, 0.01);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for bitRate=1:3
    encoded = coding_amp(str, bitRate);
    fs = 100;
    ts = 1/fs;
    tstart = 0;
    tend = length(encoded) /fs;
    t1 = tstart:ts:tend-ts;
    subplot(3,1,bitRate);
    plot(t1, encoded);
    decoded = decoding_amp(encoded, bitRate);
    disp(['BitRate = ', num2str(bitRate), ' | Origianl Text = ', str ,' | Decoded Text = ', num2str(decoded)]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
finalDecodedSignal=cell(3,3);
for bitRate=1:3
    encoded = coding_amp(str, bitRate);
    fs = 100;
    ts = 1/fs;
    tstart = 0;
    tend = length(encoded) /fs;
    t = tstart:ts:tend-ts;
    N = length(t);
    f = -fs/2:fs/N:fs/2-fs/N;
    plot(t, encoded);
    std = 0.1;
    encodedWithoutNoise = encoded;
    isWrong = false;
    while true
        if isWrong
            break;
        end
        finalDecodedSignal{1, bitRate} = encoded;
        finalDecodedSignal{2, bitRate} = std;
        for counter=1:50
            normal_noise = std*randn(1, length(t));
            encoded = encodedWithoutNoise + normal_noise;
            decoded = decoding_amp(encoded, bitRate);
            if ~strcmp(str, decoded)
                isWrong = true;
                break
            end
            finalDecodedSignal{1, bitRate} = encoded;
            finalDecodedSignal{2, bitRate} = std;
            finalDecodedSignal{3, bitRate} = decoded;
        end
        std = std + 0.05;
    end
end

for bitRate=1:3
    subplot(3,1,bitRate);
    fs = 100;
    ts = 1/fs;
    tstart = 0;
    tend = length(finalDecodedSignal{1, bitRate}) /fs;
    t = tstart:ts:tend-ts;
    plot(t, finalDecodedSignal{1, bitRate});
    title(['BitRate = ', num2str(bitRate) ,' | Noise = ', num2str(finalDecodedSignal{2, bitRate})]);
    disp(['BitRate = ', num2str(bitRate), ' | Encoded Text = ', num2str(finalDecodedSignal{3, bitRate})])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function measureCorrectness(originalStr, std)
    Mapset= cell(2, 32);
    letters = 'a':'z';
    letters = [letters, ' ', '.', ',', '!', ';', '"'];
    for i=1:32
       Mapset{1, i} = letters(i);
       Mapset{2, i} = dec2bin(i -1, 5);
    end
    binaryOriginalStr = [];
    for i=1:length(originalStr)
        for j=1:32
            if originalStr(i) == Mapset{1, j}
                binaryOriginalStr = [binaryOriginalStr, Mapset{2, j}];
            end
        end
    end
    correctnessPercentageSignal=cell(4,3);
    fs = 100;
    ts = 1/fs;
    tstart = 0;
    for bitRate=1:3
        encodedWithoutNoise = coding_amp(originalStr, bitRate);
        tend = length(encodedWithoutNoise) /fs;
        t = tstart:ts:tend-ts;
        iterationCount = 100;
        correctBitPercentage = zeros(1,iterationCount);
        for counter=1:iterationCount
            normal_noise = std*randn(1, length(t));
            encoded = encodedWithoutNoise + normal_noise;
            decodedStr = decoding_amp(encoded, bitRate);
            binaryDecodedStr = [];
            for i=1:length(decodedStr)
                for j=1:32
                    if decodedStr(i) == Mapset{1, j}
                        binaryDecodedStr = [binaryDecodedStr, Mapset{2, j}];
                    end
                end
            end
            correctCount = 0;
            startIndex = 1;
            tokenCount = floor(length(binaryDecodedStr)/bitRate);
            for i=1:tokenCount
                endIndex = startIndex + bitRate - 1;
                decodedPart = extractBetween(binaryDecodedStr, startIndex, endIndex);
                originalPart = extractBetween(binaryOriginalStr, startIndex, endIndex);
                if strcmp(decodedPart , originalPart)
                    correctCount = correctCount + 1;
                end
                startIndex = startIndex + bitRate;
            end
            correctBitPercentage(counter) = (correctCount / tokenCount) * 100;
        end
        
        correctnessPercentageSignal{1, bitRate} = encoded;
        correctnessPercentageSignal{2, bitRate} = std;
        correctnessPercentageSignal{3, bitRate} = decodedStr;
        correctnessPercentageSignal{4, bitRate} = sum(correctBitPercentage)/iterationCount;
    end

    for bitRate=1:3
        subplot(3,1,bitRate);
        fs = 100;
        ts = 1/fs;
        tstart = 0;
        tend = length(correctnessPercentageSignal{1, bitRate}) /fs;
        t = tstart:ts:tend-ts;
        plot(t, correctnessPercentageSignal{1, bitRate});
        title(['BitRate = ', num2str(bitRate) ,'  Noise = ', num2str(correctnessPercentageSignal{2, bitRate}), '  CorrectPercentage = ', num2str(correctnessPercentageSignal{4, bitRate}), '%']);
        disp(['Std = ', num2str(correctnessPercentageSignal{2, bitRate}) ,' BitRate = ', num2str(bitRate) ,' CorrectPercentage = ', num2str(correctnessPercentageSignal{4, bitRate}), '%'])
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = coding_amp(str, speed)
    Mapset= cell(2, 32);
    letters = 'a':'z';
    letters = [letters, ' ', '.', ',', '!', ';', '"'];
    for i=1:32
       Mapset{1, i} = letters(i);
       Mapset{2, i} = dec2bin(i -1, 5);
    end
    binaryStr = [];
    for i=1:length(str)
        for j=1:32
            if str(i) == Mapset{1, j}
                binaryStr = [binaryStr, Mapset{2, j}];
            end
        end
    end
    currentLength = length(str) *5;
    modSpeed = mod (currentLength, speed);
    while speed < 5 && modSpeed ~= 0
        binaryStr = [binaryStr, dec2bin(0,1)];
        currentLength = currentLength + 1;
       modSpeed = mod (currentLength, speed);
    end
    tstart = 0;
    tend = 1;
    fs = 100;
    ts = 1/fs;
    binaryNums = strings([1, 2^speed]);
    signals = cell(1, 2^speed);
    ratio = 1;
    for i=1:2^speed
        binaryNums(i) = dec2bin(i - 1, speed);
        t = tstart:ts:tend-ts;
        if i == 1
            signals{1,i} = zeros(1,100);
        else
            signals{1,i} = (ratio / (2^speed - 1)) * sin(2*pi*t);
            ratio = ratio + 1;
        end
        tstart = tend;
        tend = tend + 1;
    end

    tokenCount = floor(length(binaryStr)/speed);
    result = [];
    startIndex = 1;
    for i=1:tokenCount
        endIndex = startIndex + speed - 1;
        part = extractBetween(binaryStr, startIndex, endIndex);
        for j=1:2^speed
            if binaryNums(j) == part
                result = [result, signals{1,j}];
            end
        end
       startIndex = startIndex + speed;  
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result = decoding_amp(codedStr, speed)
    Mapset= cell(2, 32);
    letters = 'a':'z';
    letters = [letters, ' ', '.', ',', '!', ';', '"'];
    for i=1:32
       Mapset{1, i} = letters(i);
       Mapset{2, i} = dec2bin(i -1, 5);
    end
    tstart = 0;
    tend = 1;
    fs = 100;
    ts = 1/fs;
    startIndex = 1;
    tokenCount = floor(length(codedStr)/fs);
    decodedSignal = cell(1, 2^speed);
    binaryNums = strings([1, 2^speed]);
    binString = strings([1, tokenCount]);
    for i=1:2^speed
        binaryNums(i) = dec2bin(i - 1, speed);
    end

    for i=1:tokenCount
        endIndex = i * fs;
        decodedSignal{1, i} = codedStr(startIndex:endIndex);
        startIndex = endIndex + 1;
        t = tstart:ts:tend-ts;
        sinFunc = interp1(t, decodedSignal{1, i}, t);
        Y = 2 * sin(2*pi*t);
        plot(sinFunc)
        newY = sinFunc .* Y;
        corrPart = 0.01* trapz(newY);
        ratio = 1;
        for k=1:2^speed
             dif = ((ratio-1) / (2^speed - 1));
            corrDif = corrPart - dif;
            if corrDif < 0
                corrDif = dif - corrPart;
            end
            if corrDif <= 1 / (2* (2^speed -1))
                binString(i) = binaryNums(k);
            end
            ratio = ratio + 1;
        end
        tstart = tend;
        tend = tend + 1;
    end
    
    finalString = strjoin(binString);
    finalString = strrep(finalString,' ','');
    i = 0;
    counter=1;
    finalOutput = [];
    while (i + 5) <= (strlength(finalString))
        part = extractBetween(finalString,i+1,i+5);
        for j=1:length(Mapset)
            if part == Mapset{2, j}
                finalOutput(counter) = Mapset{1,j};
                counter = counter + 1;
                break;
            end
        end
        i = i + 5;
    end
    result = char(finalOutput);
end