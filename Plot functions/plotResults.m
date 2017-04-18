%%
close all; clear all; clc;

global textSize;
global textSize_offset_y;
global lineSize;
global xScale;

global Ref;
global Evo;
global Manual;
global plot_z_axis;
global plot_x_axis;

global get_easy_files;

Ref = [0.863 0.686 0.219];
Evo = [0.0745 0.4156 0.6196];
Manual = 'r';

textSize = 8;
textSize_offset_y = 2;
lineSize = 1;
xScale = 0.025;

plot_z_axis = true;
plot_x_axis = false;

get_easy_files = true;

%%
plotEvaluation1();

%%
plotEvaluation2();

%%
plotEvaluation3();

%%
appendix_FOPDT_plotEvaluation1();

%%
appendix_FOPDT_plotEvaluation2();

%%
appendix_FOPDT_plotEvaluation3();

%%
appendix_IPD_plotEvaluation1();

%%
appendix_IPD_plotEvaluation2();

%%
appendix_IPD_plotEvaluation3();

%%
plotRLSdata();