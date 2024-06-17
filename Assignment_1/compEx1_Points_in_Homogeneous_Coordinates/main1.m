clc;

% Load
whos("-file", "compEx1.mat");
data = load("compEx1.mat", "x2D", "x3D");

input2D = data.x2D;             % 3D matrix
input3D = data.x3D;             % 4D matrix

% Flatten
output2D = pflat(input2D);      
output3D = pflat(input3D);

% Plot
figure;
plot_points_2D(output2D)        % plot x,y with z = 1 => (x,y,1)

figure;
plot_points_3D(output3D)        % plot x,y,z with w = 1 => (x,y,z,1)
