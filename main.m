% This Script models a NOx removal by SCR unit. The reactor is modelled as
% a plug flow reactor, where the volume corresponds to the volume of the
% wall of the monolith honeycomb

% Before beginning make sure the workspace and command-line is clear.
clear
clc
%% Load ToolBox & Data
addpath('jsonlab');
% Load the data from the function
flueGasData = initialFlueGasFlow();
[shomateVars, Hf298] = shomateLoader([{'NO'},{'N2'},{'NH3'},{'H2O'},{'O2'},{'CO2'}]);


%% Size the Reactor
[corrConcNO, conversionNO, conversionNH3, kNO, kNH3] = reactorAsPFR(flueGasData,shomateVars, Hf298, 16, 620, 0.85,1);

%% Run Menu to Select Option
fprintf('SCR Reactor Modeller\n');
fprintf('Select option:\n');
fprintf('(1) Plot Graphs\n');
fprintf('(2) Optimise Conditions\n');
fprintf('(3) Model Single Reactor Configuration\n');
answer = input('1/2/3: ');

if answer == 1
    % Plot Graphs
    plotter();
elseif answer == 2
    % Optimise Conditions
    fprintf('Enter the following as ranges: \n');
    vols = input('Volume of Reactor (m^3): ');
    temps = input('Inlet Temperature (K): ');
    ammoniaRatio = input('Ammonia:NOx Ratio: ');
    seek(vols, temps, ammoniaRatio);
else
    % Model a single reactor
    vol = input('Volume of Reactor (m^3): ');
    T = input('Inlet Temperature (K): ');
    NOxToAmmoniaRatio = input('Ammonia:NOx Ratio: ');
    NOXpercent = input('NOx Ratio: ');
    [corrConcNO, conversionNO, conversionNH3, kNO, kNH3] = reactorAsPFR(flueGasData,shomateVars, Hf298, vol, T, NOxToAmmoniaRatio, NOXpercent)
end



