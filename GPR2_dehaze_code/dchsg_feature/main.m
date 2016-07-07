function m= main()
 ori=imread('pumpkins.jpg');
 grayimg=rgb2gray(ori);
 gim=im2double(grayimg);
 
 [Eim,Oim,Aim]=spatialgabor(gim,2,90,0.5,0.5,1);%90-vertical===0-horizontal
 imshow(Aim);


function [Eim, Oim, Aim] = spatialgabor(im, wavelength, angle, kx, ky, showfilter)


    if nargin == 5
        showfilter = 0;
    end
    
    im = double(im);
    [rows, cols] = size(im);
    newim = zeros(rows,cols);
    
    % Construct even and odd Gabor filters
    sigmax = wavelength*kx;
    sigmay = wavelength*ky;
    
    sze = round(3*max(sigmax,sigmay));
    [x,y] = meshgrid(-sze:sze);
    evenFilter = exp(-(x.^2/sigmax^2 + y.^2/sigmay^2)/2)...
    .*cos(2*pi*(1/wavelength)*x);
    
    oddFilter = exp(-(x.^2/sigmax^2 + y.^2/sigmay^2)/2)...
    .*sin(2*pi*(1/wavelength)*x);    


    evenFilter = imrotate(evenFilter, angle, 'bilinear');
    oddFilter = imrotate(oddFilter, angle, 'bilinear');    


    % Do the filtering
    Eim = filter2(evenFilter,im); % Even filter result
    Oim = filter2(oddFilter,im);  % Odd filter result
    Aim = sqrt(Eim.^2 + Oim.^2);  % Amplitude 
%     
%     if showfilter % Display filter for inspection
%         figure(1), imshow(evenFilter,[]); title('filter'); 
%     end
%     
    
 