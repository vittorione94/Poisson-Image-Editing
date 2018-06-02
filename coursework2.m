clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.

% for poisson image editing
baseFileName1 = './images/eye.jpg';
baseFileName2 = './images/hand.jpg';
% for local illumination changes
% baseFileName1 = './images/orange_test.jpg';
% baseFileName2 = './images/orange_test.jpg';
% for texture flattening
% baseFileName1 = './images/face.jpg';
% baseFileName2 = './images/face.jpg';


sourceImage = imread(baseFileName1);
sourceImage = imresize(sourceImage,[400 400]);
% Get the dimensions of the image.
[rows1, columns1, numberOfColorBands1] = size(sourceImage);
% Display the original image on the left hand side.
subplot(1, 3, 1);
imshow(sourceImage);
axis on;
caption = sprintf('Source image, %s', baseFileName1);
title(caption,'Interpreter', 'none');
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Give a name to the title bar.
set(gcf,'name','Demo by ImageAnalyst','numbertitle','off')

% Display a second image of the same size beside it on the right.
% Get the full filename, with path prepended.
targetImage = imread(baseFileName2);
targetImage = imresize(targetImage,[400 400]);
% Get the dimensions of the image.
[rows2, columns2, numberOfColorBands2] = size(sourceImage);
% Get the full filename, with path prepended.
fullFileName =  baseFileName2;
subplot(1, 3, 2);
imshow(targetImage);
axis on; % Show distances with tick marks.
caption = sprintf('Target image, %s, original', baseFileName2);
title(caption,'Interpreter', 'none');

% Ask user to draw freehand mask.
subplot(1, 3, 1);
mask = roipoly(); % Actual line of code to do the drawing.
% Create a binary image ("mask") from the ROI object.
%mask = hFH.createMask();
%xy = hFH.getPosition;
%mask = hFH;
offset = catchKeyPress(mask, targetImage);
disp(offset(1:2));

[target_mask]= circshift(mask,offset(1:2));
 
%blended_image = poissonImageEditing(sourceImage,targetImage, mask, target_mask );
%blended_image = poissonImageEditing_MixingGradients(sourceImage,targetImage, mask, target_mask,offset(1:2) );
%blended_image = localIlluminationChange( sourceImage, mask);
%blended_image = flattening( sourceImage, mask);
blended_image = poissonImageEditing_solvingForZero(sourceImage,targetImage, mask, target_mask );


% Display new image.
subplot(1, 3, 3); % Switch active axes to right hand axes.
imshow(blended_image);
axis on;
caption = sprintf('Target image, %s, after paste', baseFileName2);
title(caption,'Interpreter', 'none');