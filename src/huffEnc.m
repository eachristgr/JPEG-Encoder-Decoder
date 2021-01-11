%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 1 - JPEG Library
%% 1.5.1 Funtion huffEnc
function huffStream = huffEnc(runSymbols) %huffStream = [encodedDC, encodedACs]
%% Tables Initializations
global DCtable;
global ACtable;

%% Encode
encodedDC = '';
encodedAC = '';
for i = 1:size(runSymbols, 1)
    % DC
    if i == 1
        DC = runSymbols(i, 2);
        DCcat = '';
        DCval = '';
        if DC == 0
            DCcat = DCtable(1);
            encodedDC = DCcat;
        else
            % Negative ?
            negativeDC = 0;
            if DC < 0
                DC = -DC;
                negativeDC = 1;
            end
            % Category
            if DC <= 1
                DClen = 1; 
            elseif DC <= 3
                DClen= 2;
            elseif DC <= 7
                DClen = 3;
            elseif DC <= 15
                DClen = 4;
            elseif DC <= 31
                DClen = 5;
            elseif DC <= 63
                DClen = 6;
            elseif DC <= 127
                DClen = 7;
            elseif DC <= 255
                DClen = 8;
            elseif DC <= 511
                DClen= 9;
            elseif DC <= 1023
                DClen = 10;
            elseif DC <= 2047
                DClen = 11;
            end
            DCcat = DCtable(DClen + 1);
            % Binary Value
            binaryVal = de2bi(DC);
            for i = 1:length(binaryVal)
                if binaryVal(i) == 1
                    DCval = [DCval, '1'];
                else
                    DCval = [DCval, '0'];
                end
            end
            % If negative
            if negativeDC == 1
                for k = 1 : length(DCval)
                    if DCval(k) == '0'
                        DCval(k) = '1';
                    else
                        DCval(k) = '0';
                    end
                end
            end           
            % MSB -> LSB
            DCval = DCval(end:-1:1);
            encodedDC = strcat(DCcat, DCval);
        end
    % AC
    else
        AC = runSymbols(i, 2);
        ACcat = '';
        ACval = '';
        if AC == 0
            % ZRL
            if runSymbols(i, 1) == 15
                ACcat = ACtable(16, 1);
                ACval = '0';
                ACcatval = strcat(ACcat, ACval);
                encodedAC = strcat(encodedAC, ACcatval);
            end
            % EOB
            if runSymbols(i, 1) == 0
                ACcat = ACtable(1, 1);
                encodedAC = strcat(encodedAC, ACcat);
            end
        else
            % Negative ?
            negativeAC = 0;
            if AC < 0
                AC = -AC;
                negativeAC = 1;
            end
            % Category
            if AC <= 1
                AClen = 1;
            elseif AC <=3
                AClen = 2;
            elseif AC <=7
                AClen = 3;
            elseif AC <=15
                AClen = 4;
            elseif AC <=31
                AClen = 5;
            elseif AC <=63
                AClen = 6;
            elseif AC <=127
                AClen = 7;
            elseif AC <=255
                AClen = 8;
            elseif AC <=511
                AClen = 9;
            elseif AC <=1023
                AClen = 10;
            end
            ACcat = ACtable(runSymbols(i, 1) + 1, AClen + 1);
            % Binary Value
            binaryVal = de2bi(AC);
            for i = 1:length(binaryVal)
                if binaryVal(i) == 1
                    ACval = [ACval, '1'];
                else
                    ACval = [ACval, '0'];
                end
            end
            % If negative
            if negativeAC == 1
                for k = 1 : length(ACval)
                    if ACval(k) == '0'
                        ACval(k) = '1';
                    else
                        ACval(k) = '0';
                    end
                end
            end
            % MSB -> LSB
            ACval = ACval(end:-1:1);
            ACcatval = strcat(ACcat, ACval);
            encodedAC = strcat(encodedAC, ACcatval);
        end
    end
end

huffStream = strcat(encodedDC, encodedAC);

end 

            