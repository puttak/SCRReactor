function [ actualVol, layerDimention, acElementsPerSideOfLayer ] = reactorDimentions( catalystVolumeRequired )
%REACTORDIMENTIONS calculates the dimentions of each layer given a total
%volume of catalyst required
%   Function should be supplied with the volume of catalyst desired to have
%   in m^3, and will return the actual volume of catalyst[m^3], number of
%   elements per side of layer, and the length of a side of a layer [m].


%% Block Properties
% The block of catalyst is square and 1m long
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

%Calculate the cross-sectional area of catalyst per block, and then the
%volume of catalyst per block.
catalystAreaPerBlock = totalAreaOfBlock-emptyAreaOfBlock;
catalystVolumePerBlock = catalystAreaPerBlock*blockLength;

%% Requirements
% The number of blocks required is given by the volume required divided by
% the volume of one block
catalystBlocksRequired = catalystVolumeRequired/catalystVolumePerBlock;

%% Oversize the reactor

% There has to be a whole number of blocks
acBlockReq = ceil(catalystBlocksRequired);

% It is normal practice to have 2/3 layers:
layerDes = 3;

% Calculate how many blocks are in each layer
blockReqPerLayer = acBlockReq/layerDes;

% Assume layer is a square in cross-secion
elementsPerSideOfLayer = sqrt(blockReqPerLayer);
acElementsPerSideOfLayer = ceil(elementsPerSideOfLayer);

% Calculate the dimention of each layer from the number of blocks
layerDimention = acElementsPerSideOfLayer*lengthPerSide;
% Reactor was oversized - calculate what the actual volume of catalyst
% present is
actualVol = (acElementsPerSideOfLayer^2)*3*catalystVolumePerBlock;

end
