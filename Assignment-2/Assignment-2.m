%I have implemented HIGH-QUALITY LINEAR INTERPOLATION using the modified implementation of bilinier interpolation as mentioned in the paper - 
%Malvar, H.S., L. He, and R. Cutler, High quality linear interpolation for demosaicing of Bayer-patterned color images. ICASPP, Volume 34, Issue 11, pp. 2274-2282, May 2004. 
%I have also implemented Biliniear Interpolation (Averaging method as mentioned in the medium article that was provided)

i = imread('mandi.tif'); % Reading the Image (provided)
I = im2double(i); 

%Defining the linear filters as mentioned in the paper. 
%There are eight different filters for interpolating the different color components at different location
%I have created these filters looking at FIGURE - 2 given in the original
%paper provided

%Another paper that I used to create the logic for High Quality Demosacing - A commentary of the
%original paper - available at --> https://www.ipol.im/pub/art/2011/g_mhcd/article.pdf

Filter_1 = [0, 0, -1, 0, 0; 0, 0, 2, 0, 0; -1, 2, 4, 2, -1; 0, 0, 2, 0, 0; 0, 0, -1, 0, 0] / 8;
Filter_2 = [0, 0, -1, 0, 0; 0, 0, 2, 0, 0; -1, 2, 4, 2, -1; 0, 0, 2, 0, 0; 0, 0, -1, 0, 0] / 8;
Filter_3 = [0, 0, 1/2, 0, 0; 0, -1, 0, -1, 0; -1, 4, 5, 4, -1; 0, -1, 0, -1, 0; 0, 0, 1/2, 0, 0] / 8;
Filter_4 = [0, 0, -1, 0, 0; 0, -1, 4, -1, 0; 1/2, 0, 5, 0, 1/2; 0, -1, 4, -1, 0; 0, 0, -1, 0, 0] / 8;
Filter_5 = [0, 0, -3/2, 0, 0; 0, 2, 0, 2, 0; -3/2, 0, 6, 0, -3/2; 0, 2, 0, 2, 0; 0, 0, -3/2, 0, 0] / 8;
Filter_6 = [0, 0, 1/2, 0, 0; 0, -1, 0, -1, 0; -1, 4, 5, 4, -1; 0, -1, 0, -1, 0; 0, 0, 1/2, 0, 0] / 8;
Filter_7 = [0, 0, -1, 0, 0; 0, -1, 4, -1, 0; 1/2, 0, 5, 0, 1/2; 0, -1, 4, -1, 0; 0, 0, -1, 0, 0] / 8;
Filter_8 = [0, 0, -3/2, 0, 0; 0, 2, 0, 2, 0; -3/2, 0, 6, 0, -3/2; 0, 2, 0, 2, 0; 0, 0, -3/2, 0, 0] / 8;

[H, W] = size(I); %Getting image size 

%I have created two seperate output images for a better comparison of both
%methods 1) High Quaity Linear Interpolation 2)Bilinier Interpolation
High_Quality = zeros(H, W, 3); %This is our output image for High Quality Linear Interpolation
Bilinier = zeros(H, W, 3); %This is our output image for Biliniear Interpolation

for u = 3 : H-2
    for v = 3 : W-2

        if mod(u, 2) == 0 && mod(v, 2) == 0 %Red located
            High_Quality(u, v, 1) =  I(u, v); %Red  - updating High Quality Output
            Bilinier(u, v, 1) =  I(u, v); %updating Biliniear Output for red

            %Here I am simply extracting a 5x5 matrix with u,v as the
            %starting point and then multiplying it element wise with my
            %respective filter and then calculating the sum - basically
            %doing convolution here - I am applying the filter defined
            %above to the neighbourhood of pixels

            High_Quality(u, v, 2) = sum(sum(I(u-2:u+2, v-2:v+2) .* Filter_1)); %Green - updating High Quality Output
            
            %For Bilinier, I have simply averged the neighbours -- Took
            %help from the Medium article that was provided to us to find
            %the exact neighbours locations

            Bilinier(u, v, 2) = (I(u+1, v) + I(u-1, v) + I(u, v+1) + I(u, v-1)) / 4; %updating Biliniear Output for green
            High_Quality(u, v,3) = sum(sum(I(u-2:u+2, v-2:v+2) .* Filter_8)); %Blue - updating High Quality Output
            Bilinier(u, v, 3) = (I(u+1, v+1) + I(u+1, v-1) + I(u-1, v+1) + I(u-1, v-1)) / 4;%updating Biliniear Output for blue

        elseif mod(u + v, 2) == 1 %Green located 
            High_Quality(u, v, 2) =  I(u, v); %Green - updating High Quality Output
            Bilinier(u, v, 2) =  I(u, v);%updating Biliniear Output for green
            if mod(u, 2) == 0  %blue above n below
                High_Quality(u, v, 1) = sum(sum(I(u-2:u+2, v-2:v+2) .* Filter_3)); %Red - updating High Quality Output
                Bilinier(u, v, 1) = (I(u, v+1) + I(u, v-1)) / 2; %updating Biliniear Output for red
                High_Quality(u, v, 3) = sum(sum(I(u-2:u+2, v-2:v+2) .* Filter_7)); %Blue - updating High Quality Output
                Bilinier(u, v, 3) = (I(u+1, v) + I(u-1, v)) / 2;%updating Biliniear Output for blue
            else  %red above n below
                High_Quality(u, v, 1) = sum(sum(I(u-2:u+2, v-2:v+2) .* Filter_4)); %Red - updating High Quality Output
                Bilinier(u, v, 1) = (I(u+1, v) + I(u-1, v)) / 2;%updating Biliniear Output for red
                High_Quality(u, v, 3) = sum(sum(I(u-2:u+2, v-2:v+2) .* Filter_6)); %Blue - updating High Quality Output
                Bilinier(u, v, 3) = (I(u, v+1) + I(u, v-1)) / 2; %updating Biliniear Output for blue
            end

        else %Blue located 
            High_Quality(u, v, 3) =  I(u, v); %Blue - updating High Quality Output
            Bilinier(u, v, 3) =  I(u, v); %updating Biliniear Output for blue
            High_Quality(u, v,2) = sum(sum(I(u-2:u+2, v-2:v+2) .* Filter_2)); %Green - updating High Quality Output
            Bilinier(u, v, 2) = (I(u+1, v) + I(u-1, v) + I(u, v+1) + I(u, v-1)) / 4; %updating Biliniear Output for green
            High_Quality(u, v,1) = sum(sum(I(u-2:u+2, v-2:v+2) .* Filter_5)); %Red - updating High Quality Output
            Bilinier(u, v, 1) = (I(u+1, v+1) + I(u+1, v-1) + I(u-1, v+1) + I(u-1, v-1)) / 4; %updating Biliniear Output for red
        end
    end
end


figure; %Creating a figure window to display my outputs
subplot(2, 4, 1);
imshow(I);%Displaying the original input image
title('Original Image'); 
subplot(2, 4, 2);
imshow(High_Quality);%Displaying the output high quality domasaiced image
title('High Quality Demosaiced Image - As per the paper');
subplot(2, 4, 3);
imshow(Bilinier);%Displaying the output bilinierly domasaiced image
title('Bilinier Demosaiced Image');
subplot(2, 4, 4);
imshow(demosaic(i,'bggr')) %Dispaying the output of Matlab's built in function for comparison
title('MATLABs Built-In Demosaic Func');
subplot(2, 4, 5);
imshow(imsubtract(uint8(High_Quality * 255),demosaic(i,'bggr')));
title('Subtraction Results - Matlabs builtin - High Quality');
subplot(2, 4, 6);
imshow(imsubtract(uint8(Bilinier * 255),demosaic(i,'bggr')));
title('Matlabs builtin - Bilinier');




