function [ output_args ] = reactorDimentions( input_args )
%REACTORDIMENTIONS Summary of this function goes here
%   Detailed explanation goes here


%% Block Properties
% The block of catalyst is square

cellsPerSide = 40;
lengthPerSide = 0.15;
lengthOfCellSide = 0.003;
wallThickness = 0.0007;
blockLength = 1;

totalLengthOfCellSide = lengthOfCellSide+wallThickness;
totalCellLength = totalLengthOfCellSide*cellsPerSide-wallThickness;
externalWallThickness = (lengthPerSide*totalCellLength)/2;

emptyAreaOfBlock = cellsPerSide*cellsPerSide*(lengthOfCellSide^2);

totalAreaOfBlock = lengthPerSide^2;

catalystAreaPerBlock = totalAreaOfBlock-emptyAreaOfBlock;
catalystVolumePerBlock = catalystAreaPerBlock*blockLength;

%% Requirements

catalystVolumeRequired = 16; %m3

catalystBlocksRequired = catalystVolumeRequired/catalystVolumePerBlock;

%% Oversize the reactor

acBlockReq = ceil(catalystBlocksRequired);
layerDes = 3;
blockReqPerLayer = acBlockReq/layerDes;
% Assume layer is a square
elementsPerSideOfLayer = sqrt(blockReqPerLayer);
acElementsPerSideOfLayer = ceil(elementsPerSideOfLayer);

layerDimention = acElementsPerSideOfLayer*lengthPerSide



end

