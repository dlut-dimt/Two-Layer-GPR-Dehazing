% load a binary raw image file (default = 128x128)
% ex: A = loadimg('image_name',[width heigth]);

function data = loadimg(fn,sz)
if nargin == 1
	SZ = [128 128];
end;
fid = fopen(fn,'r');
SZ = [sz sz];
data = fread(fid,SZ,'uchar')';
fclose(fid);