% Reading the input image -- change the input image accordingly for
% different images
myImage = imread('soldier.jpg');
% Conversion to frequency domain using FFT
% This code for conversion to frquency domain and displaying the frequency
% spectrum is taken from the weekly codes uploaded on lms
myF = fft2(myImage);
% Displaying the original image
imshow(myImage);
title('Original Image');
figure;
myShifted = fftshift(myF);
S = log(1 + abs(myShifted));
% Normalizing the values for visualization
minS = min(S(:));
maxS = max(S(:));
S = (S - minS) / (maxS - minS);
colormap(jet);
imshow(S, []);
title('Frequency Spectrum');
% This array will store the result we get when we'll use the imellipse
% which is a built-in matlab function and would return to us the minimum x
% value (coordinate), the minimum y value (coordinate) and the respective
% width and height
selectedPoints = [];
%Looping to get the points
while true
    % Getting the selected position on the frequency spectrum
    myPosEli = getPosition(imellipse());
    %Extracting the relevant things and storing them in vars
    xMin = myPosEli(1);
    myWidth = myPosEli(3);
    yMin = myPosEli(2);
    myHeight = myPosEli(4);
    %This is to get the center point of the selection - just done to
    %visualize things in a better way.
    x0 = myPosEli(1) + myPosEli(3) / 2;
    y0 = myPosEli(2) + myPosEli(4) / 2;
    % Store the selected points in the array we defined above
    selectedPoints = [selectedPoints; xMin, yMin, myWidth, myHeight];
    % This isthe code to mark the red center points (as you can see when
    % running the program). I took help from internet to mark these points.
    hold on;
    plot(x0, y0, 'ro', 'MarkerSize', 10, 'LineWidth', 3);
    hold off;
    % Asking the user if they want to select the next point or the selected
    % points are enough and they want to apply the filter
    choice = questdlg('Do you want to select more points?', 'Select Points', 'Yes', 'Apply Filter', 'No');
    if strcmp(choice, 'Apply Filter')
        break;
    end
end
% Getting the size of the frequency domain matrix
mySize = size(myF);
% Initializing the mask with ones
mask = ones(mySize(1), mySize(2));
% Creating a mask based on the selected points to implement our notch filter
for n = 1 : size(selectedPoints, 1)
    x0 = round(selectedPoints(n, 1) + selectedPoints(n, 3) / 2);
    y0 = round(selectedPoints(n, 2) + selectedPoints(n, 4) / 2);
    radius = min(round(selectedPoints(n, 3) / 2), round(selectedPoints(n, 4) / 2));
    [xx, yy] = meshgrid(1:mySize(2), 1:mySize(1));
    circle = (xx - x0).^2 + (yy - y0).^2 <= radius.^2;
    %Making our selecting region zero
    mask(circle) = 0;
end
% Displaying the notch filter mask as it was shown in the assignment
% document
imshow(mask, []);
title('Notch Filter');
%Applying the mask which is our notch filter to our image
filteredFreqDomain = myShifted .* mask;
% Inversing the FFT to obtain the filtered image in spatial domain
filteredImage = ifft2(ifftshift(filteredFreqDomain));
figure;
% Scaling the image for visualization
scaledImage = abs(filteredImage);
minValue = min(scaledImage(:));
maxValue = max(scaledImage(:));
scaledImage = 255 * (scaledImage - minValue) / (maxValue - minValue);
% Displaying the filtered image
imshow(uint8(scaledImage));
title('Image after Notch Reject Filter has been applied');
