[fn, fp] = uigetfile('*.*');

fid = fopen(fullfile(fp, fn), "r");
f = fread(fid, 'bit12=>double');

fs = 128;
time = (0:length(f)-1) / fs;

figure
plot(time(1:200), f(1:200));
