%PARAMETER : (U1,U2max,U3,para(Tmp(C) for liquid state, Torr for gas),atom type, interval of U2, precision)
filename1 = flow(0,24,1.8,140,"hg",0.4,4);
plotter([filename1],"hg")

% %filename2 = flow(0,86,8,12.5,"neon",0.3,6);
%plotter([".\data\sample.csv"],"Ne")
