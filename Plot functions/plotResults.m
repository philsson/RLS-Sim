%%
close all; clear all; clc;


global textSize;
global textSize_offset_y;
global lineSize;
global xScale;

global Ref;
global Evo;
global Manual;


textSize = 8;
textSize_offset_y = 2;
lineSize = 1;
xScale = 0.025;

Ref = [0.863 0.686 0.219];
Evo = [0.0745 0.4156 0.6196];
Manual = 'r';

%%
plotEvaluation1();

%%
plotEvaluation2();