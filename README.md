# JPEG Encoder - Decoder

##### **Aristotle University of Thessaloniki - Electrical and Computer Engineering**

##### **Multimedia Systems and Virtual Reality**

This repository contains the assignment for the course of Multimedia Systems and Virtual Reality.

The purpose of the exercises was the implementation of a **JPEG Encoder - Decoder** for a static image in **MATLAB**.

Initially, the functions that implement the individual systems of an encoder and decoder were designed (JPEG Library) and then combined to compress - decompress a static image (JPEG Integration).

## JPEG Library

This section provides a brief description of the functions that implement the individual procedures of an encoder - decoder. The encoder and decoder contain functions that implement reverse procedures.

The set of procedures required are:

|       Encoder       |      Decoder      |
| :-----------------: | :---------------: |
| Conversion to YCbCr | Conversion to RGB |
|         DCT         |    Inverse DCT    |
|    Quantization     |  Dequantization   |
|   ZigZag Scanning   | ZigZag Inversion  |
|     RL Encoding     |    RL Decoding    |
|  Huffman Encoding   | Huffman Decoding  |

The corresponding functions are briefly listed below:

- ##### Conversion to YCbCr (Encoder Function)

src/convert2ycbcr.m

```matlab
function [imageY, imageCb, imageCr] = convert2ycbcr(imageRGB, subimg)
```

The actions this function performs are the resize of the imageRGB image to a multiple of 8, the RGB to YCbCr conversion and the downsampling of the image given by subimg.



- ##### Conversion to RGB (Decoder Function)

src/convert2rgb.m

```matlab
function imageRGB = convert2rgb(imageY, imageCr, imageCb, subimg)
```

The actions this function performs are to identify the downsampling, to reconstruct the lost information and finally to convert the YCbCr image to a RGB image.



- ##### Discrete Cosine Transform (Encoder Function)

src/blockDCT.m

```matlab
function dctBlock = blockDCT(block)
```

The input of this function is an 8x8 size block and after applying the DCT transform with the dct2 function of MATLAB, it produces the transformed block as the output.



- ##### Inverse Discrete Cosine Transform (Decoder Function)

src/iblockDCT.m

```matlab
function block = iBlockDCT(dctBlock)
```

The input of this function is a DCT transformed 8x8 size block and after applying the inverse DCT transform with the idct2 function of MATLAB, it produces the original block as the output.



- ##### Quantization (Encoder Function)

src/quantizeJPEG.m

```matlab
function qBlock = quantizeJPEG(dctBlock, qTable, qScale)
```

This function inputs are a DCT transformed 8x8 size block, a quantization table and an integer. This integer is multiplied  with the quantization table, the result divides the dctBlock and after a rounding the quantized block is given as an output.



- ##### Dequantization (Decoder Function)

src/dequantizeJPEG.m

```matlab
function dctBlock = dequantizeJPEG(qBlock, qTable, qScale)
```

This function inputs are a quantized 8x8 size block, a quantization table and an integer. This integer is multiplied  with the quantization table, the result is multiplied with the qBlock and the dequantized block is given as an output.



- ##### ZigZag Scanning & Run Length Encoding (Encoder Function)

src/runLength.m

```matlab
function runSymbols = runLength(qBlock, DCpred)
```

This function inputs are a quantized, DCT transformed, 8x8 block and the DC component of the previous block. First, the 8x8 block is transformed to a vector by a ZigZag Scanning algorithm and then this vector is used to make the output runSymbols array of 2 columns and R rows. The second column stores the non-zero number found in the one-dimensional array, while the first contains the number of zeros accessed until the non-zero number is found (there are some exceptions to this procedure).



- ##### Run Length Decoding & ZigZag Inversion (Decoder Function)

src/irunLength.m

```matlab
function qBlock = irunLength(runSymbols, DCpred)
```

This function inputs are a runSymbols array and the DC component of the previous block. First, runSymbols array is used to make a vector and then DCpred and an inverse ZigZag Scanning algorithm are used to create the quantized, DCT transformed, 8x8 block as output.



- ##### Huffman Encoding (Encoder Function)

src/huffEnc.m

```matlab
function huffStream = huffEnc(runSymbols)
```

This function input is a runSymbols array. This array is transformed, using a set of Huffman tables and a predetermined procedure, to a bit stream huffStream, this bits stream is the final coding of a  8x8 block.



- ##### Huffman Decoding (Decoder Function)

src/huffDec.m

```matlab
function runSymbols = huffDec(huffStream)
```

This function input is a huffStream. This bit stream is transformed, using a set of Huffman tables and a predetermined procedure, to a runSymbols array.



## JPEG Integration

Ιn order to create an early form of an JPEG encoder and decoder, a combination of the above functions must be achieved.

For this reason, a brief description of the corresponding functions that have been developed is given below:

- ##### JPEG Encoder

src/JPEGencode.m

```matlab
function JPEGenc = JPEGencode(img, subimg, qScale)
```

The above function inputs are an RGB image, the downsampling factor (subimg)  and the quantization factor (qScale). The output is a cell consists of structs that contain important information about the final quantization tables and the Huffman tables, the bit streams of every image's block, blocks coordinates and type.

So after initializing the appropriate tables and saving them in the first place of the JPEGenc cell, the main process of encoding an image follows. A brief description of the steps followed are:

1. Convert RGB image to YCbCr image with the **convert2ycbcr** function.
2. Choose the corresponding quantization and Huffman tables for luma (Y) and for each chroma (Cb, Cr) components.
3. Split each YCbCr image components to 8x8 blocks.
4. Create the transformed block of each block with the **blockDCT** function.
5. Create the quantized block of each transformed block with the **quantizeJPEG** function.
6. Create the runSymbols array of each quantized block with the **runLength** function.
7. Create the bit stream of each runSymbols array with the **huffEnc** function.
8. Save each block's bit streams and info in the JPEGenc cell.




- ##### JPEG Decoder

src/JPEGdecode.m

```matlab
function imgRec = JPEGdecode(JPEGenc)
```

The above function inputs is a JPEGenc cell and the output is an RGB image.

In general it is a reverse process from that of the encoder. So after initializing the appropriate tables and from the first place of the JPEGenc cell, the main process of decoding an image follows. A brief description of the steps followed are:

1. Define the type (luma, chroma) of each block, by it's information (blkType).
2. Choose the corresponding quantization and Huffman tables.
3. Decode each bit stream and create the corresponding runSymbols array with the **huffDec** function.
4. Create the quantized block of each runSymbols array with the **irunLength** function.
5. Create the transformed block of each quantized block with the **dequantizeJPEG** function.
6. Create the original block of each transformed block with the **iBlockDCT** function.
7. Place each block in the correct position of the image, by it's information (indHor, indVer).
8. Convert  YCbCr image to RGB image with the **convert2rgb** function.



## Additional Scripts 

In order to validate the operation of the functions implemented but also to examine the effects of some parameters on the quality of the reconstructed image and compression, some additional scripts were created:

- **Demo 1** - src/demo1.m - In order to demonstrate the correct use of convert2ycbcr, blockDCT, quantizeJPEG, dequantizeJPEG, iBlockDCT and convert2rgb.
- **qScale Influence** - src/qScaleInfluence.m - In order to observe the qScale influence in the quality of the reconstructed image and the number of the total bits in the final bitstream.
- **High Frequencies Influence** - src/HighFrequenciesInfluense.m - This script together with some changes in the quantizeJPEG function, were used in order to observe the influence of the higher frequencies in an image.
- **Demo 2** - src/demo2.m - In order to compute the entropy of the image in the spatial domain, the quantized DCT blocks and the runSymbols arrays.



## Conclusion

The files of the functions, the additional scripts, the quantization and Huffman tables described above can be found in the **scr** folder. 

The **report.pdf** contains more details about the functions and the additional scripts. In the same file the results obtained with the help of the additional scripts are presented in detail.
