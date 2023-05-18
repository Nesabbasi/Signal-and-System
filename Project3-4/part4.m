clc;           
clear;        
close all; 

str = 'signal';


%part 4-3) , 4-4)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
measureCorrectness(str,0.01);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure("Name", "signalPlots")
for bitRate=1:3
    encoded = coding_amp(str, bitRate);
    fs = 100;
    ts = 1/fs;
    tstart = 0;
    tend = length(encoded) /fs;
    t = tstart:ts:tend-ts;
    subplot(3,1,bitRate);
    plot(t, encoded);
    title(['BitRate = ', num2str(bitRate)]);
    decoded = decoding_amp(encoded, bitRate);
    disp(['BitRate = ', num2str(bitRate), ' | Origianl Text = ', str ,' | Decoded Text = ', num2str(decoded)]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
finalDecodedSignal=cell(2,3);
for bitRate=1:3
    encoded = coding_amp(str, bitRate);
    fs = 100;
    ts = 1/fs;
    tstart = 0;
    tend = length(encoded) /fs;
    t = tstart:ts:tend-ts;
    N = length(t);
    f = -fs/2:fs/N:fs/2-fs/N;
    %plot(t, encoded);
    encodedWithoutNoise = encoded;
    std = 0.0;
    isWrong = false;
    while true
        if isWrong
            break;
        end
        finalDecodedSignal{1, bitRate} = encoded;
        finalDecodedSignal{2, bitRate} = std;
        for counter=1:100
            normal_noise = std*randn(1, length(t));
            encoded = encodedWithoutNoise + normal_noise;
            decoded = decoding_amp(encoded, bitRate);
            if ~strcmp(str, decoded)
                isWrong = true;
                break
            end
        end
        std = std + 0.02;
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
    title(['BitRate = ', num2str(bitRate) ,'  Noise = ', num2str(finalDecodedSignal{2, bitRate})]);
    disp(['BitRate = ', num2str(bitRate), ' | Noise = ', num2str(finalDecodedSignal{2, bitRate}) ,' | Variance = ', num2str(finalDecodedSignal{2, bitRate} ^2)]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    correctnessPercentageSignal=cell(4,6);
    fs = 100;
    ts = 1/fs;
    tstart = 0;
    for bitRate=1:6
        encodedWithoutNoise = coding_amp(originalStr, bitRate);
        tend = length(encodedWithoutNoise) /fs;
        t = tstart:ts:tend-ts;
        iterationCount = 10000;
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

    for bitRate=1:6
        subplot(6,1,bitRate);
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

    step = 50 / (2^speed);
    freq = (50 - (2^speed - 1) * step ) / 2; 
    for i=1:2^speed
        binaryNums(i) = dec2bin(i - 1, speed);
        t = tstart:ts:tend-ts;
        signals{1,i} = sin(2*pi*(floor(freq))*t);
        freq = freq + step;
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
                break;
            end
        end
       startIndex = startIndex + speed;  
    end

end
%%%%%%%%%%%%%%%%%%%

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
    allFreqs = zeros(1, 2^speed);
    step = 50 / (2^speed);
    freq = (50 - (2^speed - 1) * step ) / 2; 
    for i=1:2^speed
        binaryNums(i) = dec2bin(i - 1, speed);
        allFreqs(i) = freq;
        freq = freq + step;
    end
    allFreqs = floor(allFreqs);
    binString = strings([1, tokenCount]);
    
    for i=1:tokenCount
       if (speed == 5 && i == 5)
        a = 5;
       end
        endIndex = i * fs;
        decodedSignal{1, i} = codedStr(startIndex:endIndex);
        startIndex = endIndex + 1;
        t = tstart:ts:tend-ts;
        N = length(t);
        f = -fs/2:fs/N:fs/2-fs/N;
        x = interp1(t, decodedSignal{1, i}, t);
        xF = fft(x);
        xFshifted = abs(fftshift(xF));
        [~, indexAtMaxY] = max(xFshifted);
        peakFreq = f(indexAtMaxY(1));

        if peakFreq < 0
            peakFreq = -peakFreq;
        end
        if peakFreq == 50
            peakFreq = 0;
        end
        if (speed == 5 && i == 5)
                a = 4;
        end
        for k=1:2^speed
            threshold = step / 2;
            dif = peakFreq - allFreqs(k);
            if dif < 0
                dif = -dif;
            end
            if (dif <= threshold)
                binString(i) = binaryNums(k);
                break;
            end
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