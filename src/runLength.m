%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 1 - JPEG Library
%% 1.4.1 Funtion runLength
function runSymbols = runLength(qBlock, DCpred)
%% Initialize ZZ table
rows = size(qBlock, 1);
cols = size(qBlock, 2);
ZZ = zeros(rows * cols, 1);

%% ZZ Algorithm
index = reshape(1:numel(qBlock), size(qBlock));
index = fliplr(spdiags(fliplr(index)));
index(:,1:2:end) = flipud(index(:,1:2:end));
index(index == 0) = [];
ZZ = qBlock(index);

%% ZZ(1) = DIFF = qBlock(1,1) - DCpred
ZZ(1) = ZZ(1) - DCpred;

%% DC (-2047, 2047)
if ZZ(1) > 2047
    ZZ(1) = 2047;
end
if ZZ(1) < -2047
    ZZ(1) = -2047;
end

%% AC (-1023, 1023)
for i = 2:length(ZZ)
    if ZZ(i) > 1023
        ZZ(i) = 1023;
    end
    if ZZ(i) < -1023
        ZZ(i) = -1023;
    end    
end

%% runSymbols
runSymbols = zeros(1,2);
count = 1;
zerosL = 0;
for i = 1:length(ZZ)
    if i == 1
        runSymbols(count, 1) = 0;
        runSymbols(count, 2) = ZZ(i);
        count = count + 1;
    else
        if ZZ(i) == 0
            zerosL = zerosL + 1;
            if zerosL == 16 % ZRL
                runSymbols(count, 1) = 0;
                runSymbols(count, 2) = 0;
                zerosL = 0;
                count = count + 1;
            end
            if i == length(ZZ) % EOB
                runSymbols(count, 1) = 0;
                runSymbols(count, 2) = 0;
                zerosL = 0;
            end
        else
            runSymbols(count, 1) = zerosL;
            runSymbols(count, 2) = ZZ(i);
            zerosL = 0;
            count = count + 1;
        end
    end
end

%% Remove (15, 0) before EOB
flag = 0;
idx = size(runSymbols, 1);
lastNoneZeroAC = 1;
while ((flag == 0) & (idx >= 2))
    
    if runSymbols(idx, 2) ~= 0 
        flag = 1;
        lastNoneZeroAC = idx;
    else
        idx = idx - 1;
    end
    
end 

if lastNoneZeroAC ~= size(runSymbols, 1)
    runSymbols = runSymbols(1:lastNoneZeroAC+1, :);
    runSymbols(lastNoneZeroAC+1, :) = 0;
end
    

end
