function test()
win_size=10;

I0=imread('01.jpg');
darkc=dark_channel(I0,win_size);
lmaxc=local_max_contrast(I0,win_size);
lmaxs=local_max_saturation(I0,win_size);
hsvmap=rgb2hsv(I0);
hsv_h=hsvmap(:,:,1);
figure;
subplot(1,4,1);
imshow(darkc);
subplot(1,4,2);
imshow(lmaxc);
subplot(1,4,3);
imshow(lmaxs);
subplot(1,4,4);
imshow(hsv_h);

I0=imread('02.bmp');
darkc=dark_channel(I0,win_size);
lmaxc=local_max_contrast(I0,win_size);
lmaxs=local_max_saturation(I0,win_size);
hsvmap=rgb2hsv(I0);
hsv_h=hsvmap(:,:,1);
figure;
subplot(1,4,1);
imshow(darkc);
subplot(1,4,2);
imshow(lmaxc);
subplot(1,4,3);
imshow(lmaxs);
subplot(1,4,4);
imshow(hsv_h);

I0=imread('03.jpg');
darkc=dark_channel(I0,win_size);
lmaxc=local_max_contrast(I0,win_size);
lmaxs=local_max_saturation(I0,win_size);
hsvmap=rgb2hsv(I0);
hsv_h=hsvmap(:,:,1);
figure;
subplot(1,4,1);
imshow(darkc);
subplot(1,4,2);
imshow(lmaxc);
subplot(1,4,3);
imshow(lmaxs);
subplot(1,4,4);
imshow(hsv_h);


