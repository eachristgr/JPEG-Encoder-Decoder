%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 1 - JPEG Library
%% 1.5.2 Funtion huffDec
function runSymbols = huffDec(huffStream)
%% Tables Initializations
global DCtable;
global ACtable;

%% Convert String to Char Vector
huffStream = convertStringsToChars(huffStream);

%% Decoding
runSymbols = zeros(1,2);
huffL = length(huffStream);
count = 1;
startP = 1;
endP = 1;

while ((count <= 64) & ((startP <= huffL) & (endP <= huffL)))
    % DC
    if count == 1
        negativeDC = 0;
        DCcat = huffStream(startP:endP);
        if ismember(DCcat, DCtable)
            DClen = find(ismember(DCtable, DCcat));
            DClen = DClen - 1;
            if DClen == 0
                runSymbols(count, 1) = 0;
                runSymbols(count, 2) = 0;
                startP = endP + 1;
                endP = endP + 1;
                count = count + 1;
            else
                startP = endP + 1;
                endP = endP + DClen;
                DCval = huffStream(startP:endP);
                % Check if negative
                if DCval(1) == '0'
                    negativeDC = 1;
                    % DCbVal = DCbVal - 1
                    for k = 1 : length(DCval)
                        if DCval(k) == '0'
                            DCval(k) = '1';
                        else
                            DCval(k) = '0';
                        end
                    end
                end                
                val = bin2dec(DCval);
                if negativeDC == 1
                    val = -val;
                end
                runSymbols(count, 1) = 0;
                runSymbols(count, 2) = val;
                count = count + 1;
                startP = endP + 1;
                endP = endP + 1;
            end
        end
    % AC    
    else
        negativeAC = 0;
        ACcat = huffStream(startP:endP);
        if ismember(ACcat, ACtable)
            [zerosL, AClen] = find(ismember(ACtable, ACcat));
            zerosL = zerosL - 1;
            AClen = AClen - 1;
            if ((zerosL == 15) & (AClen == 0))
                runSymbols(count, 1) = 15;
                runSymbols(count, 2) = 0;
                count = count + 1;
                startP = endP + 2;
                endP = endP + 2;                
            elseif ((zerosL == 0) & (AClen == 0))
                runSymbols(count, 1) = 0;
                runSymbols(count, 2) = 0;
                startP = endP + 1;
                endP = endP + 1;
            else
                startP = endP + 1;
                endP = endP + AClen;
                ACval = huffStream(startP:endP);
                % Check if negative
                if ACval(1) == '0'
                    negativeAC = 1;
                    % DCbVal = DCbVal - 1
                    for k = 1 : length(ACval)
                        if ACval(k) == '0'
                            ACval(k) = '1';
                        else
                            ACval(k) = '0';
                        end
                    end
                end                
                val = bin2dec(ACval);
                if negativeAC == 1
                    val = -val;
                end
                runSymbols(count, 1) = zerosL;
                runSymbols(count, 2) = val;
                count = count + 1;
                startP = endP + 1;
                endP = endP + 1;
            end
        end
    end
    endP = endP + 1;
end

end
