%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Title: Image Shape Detection                                        %%%
%%% Author: Madura Senadeera                                            %%%
%%% Last Update: 27/10/2018                                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc;

dataUsed = 30; % percentage of fourier descriptors used
constant= 0.25; % threshold for difference value (smaller values for 7's that have been identified)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Template Image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = imread('template.bmp'); % importing singular image of 7
tGS = rgb2gray(t)<100; % converting to grayscale

tBd = findBoundary(tGS,8,'cw'); % running find boundary function to identify points

figure(1);
title1=sprintf('Template Image');
imshow(t),title(title1);
hold on; % hold onto image then use for-loop to display identified shape

tBdPoints = tBd{1}; % only one number boundary identified so only a 1x1 cell
tX = tBdPoints(:,2); % storing point values into coordinates
tY = tBdPoints(:,1);
noPts = length(tX);

plot(tX, tY,'r','LineWidth',2);
hold off;

tCoords = [tX tY]; % storing into array with X and Y
tComplex = complex(tX,tY);  % converting these positions into complex form
tCoefficient = fft(tComplex); % computing fourier descriptors by applying fourier transform

tMagnitude = abs(tCoefficient); % getting absolute value to ignore phasor value (rotation) 
tMagnitude(1)=0; % DC location value forced to zero and not required
tScale = abs(tMagnitude(2)); % scale value 
tReduced = tMagnitude(2:dataUsed); % gather first 11 points to reconstruct image
tDescp = tReduced/tScale; % to become scale invariant


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Original Image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = imread('full_image.bmp');
iGS = rgb2gray(i)<80;%threshold value for the original image to increase clarify of image


iBd = findBoundary(iGS,8,'cw'); % running find boundary function to identify points

figure(2);
title1=sprintf('Original Image');
imshow(i),title(title1); % hold onto image then use for-loop to display identified shapes

hold on;

%%% initialise for-loop to index through all identified letters + numbers
for k=1:length(iBd)
    
    iX = iBd{k}(:,2);
    iY = iBd{k}(:,1);
    
    iCoords = [iX iY];
    iComplex = complex(iX,iY); % converting these positions into complex form
    iCoefficient = fft(iComplex); % computing fourier descriptors by applying fourier transform
    
    iMagnitude = abs(iCoefficient); % getting absolute value to ignore phasor value (rotation invariant) 
    iMagnitude(1)=0; % DC location value forced to zero and not required now the point is zero making 
                     % the outline start from the centre at 0
    iScale = abs(iMagnitude(2)); % scale value 
    iReduced = iMagnitude(2:dataUsed); % decrease the size of the data set to be equivalent to that of the template
    iDescp = iReduced/iScale; % to become scale invariant
    % iDescp is the invariant Fourier Descriptors
    
    % Applying SAD
    valueSAD = sum(abs(iDescp-tDescp));
    
    % assumed that a '7' is identified with the smallest SAD value
    if valueSAD <= constant    % condition statement, constant is a random variable used to identify the max value 
                               % to allow all 7's to be identified
        
        plot(iX, iY,'r','LineWidth',2);
        
    end
    
end

    
  
