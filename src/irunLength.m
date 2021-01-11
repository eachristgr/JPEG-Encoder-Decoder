%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 1 - JPEG Library
%% 1.4.2 Funtion irunLength
function qBlock = irunLength(runSymbols, DCpred)
%% ZZ
ZZ = zeros(1, 64);
count = 1;
for i = 1:size(runSymbols,1)
    if i == 1
        ZZ(count) = runSymbols(i, 2);
        count = count + 1;
    else
        if runSymbols(i, 1) == 0
            ZZ(count) = runSymbols(i, 2);
            count = count + 1;
        else
            ZZ(count:(count + runSymbols(i, 1) - 1)) = 0;
            count = count + runSymbols(i, 1);
            ZZ(count) = runSymbols(i, 2);
            count = count + 1;
        end
    end
end

%% ZZ(1,1) = DIFF + DCpred
ZZ(1) = ZZ(1) + DCpred;

%% Initialize qBlock 
qBlock = zeros(8);

%% Inverse ZZ Algorithm
A = [   1   2   6   7   15  16  28  29  ;
        3   5   8   14  17  27  30  43  ;
        4   9   13  18  26  31  42  44  ;
        10  12  19  25  32  41  45  54  ;
        11  20  24  33  40  46  53  55  ;
        21  23  34  39  47  52  56  61  ;
        22  35  38  48  51  57  60  62  ;
        36  37  49  50  58  59  63  64  ];

for i = 1:64
    qBlock(i) = ZZ(A(i));
end

end
