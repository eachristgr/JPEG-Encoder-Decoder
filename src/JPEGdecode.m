%% Emmanouil Christos 8804
% Multimedia Project 2019 - 2020
% Part 2 - JPEG Intergration
% 2.1.2 Funtion JPEGdecode
function imgRec = JPEGdecode(JPEGenc)
%% Tables Initializations
qTableL = JPEGenc{1}.qTableL;
qTableC = JPEGenc{1}.qTableC;
DCL = join(erase(string(JPEGenc{1}.DCL), "'"), '', 3);
DCC = join(erase(string(JPEGenc{1}.DCC), "'"), '', 3);
ACL = join(erase(string(JPEGenc{1}.ACL), "'"), '', 3);
ACC = join(erase(string(JPEGenc{1}.ACC), "'"), '', 3);
%DCL = JPEGenc{1}.DCL;
%DCC = JPEGenc{1}.DCC;
%ACL = JPEGenc{1}.ACL;
%ACC = JPEGenc{1}.ACC;

global DCtable; 
global ACtable;

%% subimg - qScale
subimg = [4 4 4];
qScale = 1;

%% Initialize Y, Cb, Cr
imgY = '';
imgCb = '';
imgCr = '';

%% Extract from Cell - iHuffman - iZigZag - Dequantization - iDCT
DCpredY = 0;
DCpredCb = 0;
DCpredCr = 0;
for i = 2:length(JPEGenc)
    if JPEGenc{i}.blkType == "Y"
        % iHuffman
        DCtable = DCL;
        ACtable = ACL;
        runSymbolsY = huffDec(JPEGenc{i}.huffStream);
        % iZigZag
        qBlockY = irunLength(runSymbolsY, DCpredY);
        DCpredY = runSymbolsY(1, 2);
        % Dequantization
        dctBlockY = dequantizeJPEG(qBlockY, qTableL, qScale);
        % iDCT
        blockY = iBlockDCT(dctBlockY);
        % Add to imgY
        colY = JPEGenc{i}.indHor;
        rowY = JPEGenc{i}.indVer;
        imgY(rowY:rowY+8-1, colY:colY+8-1) = blockY;
    elseif JPEGenc{i}.blkType == "Cb"
        % iHuffman
        DCtable = DCC;
        ACtable = ACC;
        runSymbolsCb = huffDec(JPEGenc{i}.huffStream);
        % iZigZag
        qBlockCb = irunLength(runSymbolsCb, DCpredCb);
        DCpredCb = runSymbolsCb(1, 2);
        % Dequantization
        dctBlockCb = dequantizeJPEG(qBlockCb, qTableC, qScale);
        % iDCT
        blockCb = iBlockDCT(dctBlockCb);
        % Add to imgCb
        colCb = JPEGenc{i}.indHor;
        rowCb = JPEGenc{i}.indVer;
        imgCb(rowCb:rowCb+8-1, colCb:colCb+8-1) = blockCb;
    elseif JPEGenc{i}.blkType == "Cr"
        % iHuffman
        DCtable = DCC;
        ACtable = ACC;
        runSymbolsCr = huffDec(JPEGenc{i}.huffStream);
        % iZigZag
        qBlockCr = irunLength(runSymbolsCr, DCpredCr);
        DCpredCr = runSymbolsCr(1, 2);
        % Dequantization
        dctBlockCr = dequantizeJPEG(qBlockCr, qTableC, qScale);
        % iDCT
        blockCr = iBlockDCT(dctBlockCr);
        % Add to imgCb
        colCr = JPEGenc{i}.indHor;
        rowCr = JPEGenc{i}.indVer;
        imgCr(rowCr:rowCr+8-1, colCr:colCr+8-1) = blockCr;
    end
end

%% Convert to RGB
imgRec = convert2rgb(imgY, imgCr, imgCb, subimg);

end
