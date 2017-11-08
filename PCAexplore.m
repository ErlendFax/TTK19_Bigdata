%% PCA explore

[filename, pathname] = uigetfile('*.mat','Select .mat file to open');
if isequal(filename,0) || isequal(pathname,0)
   disp('User pressed cancel')
else
   data = load([pathname filename]);
end


data = data.data;
[label,labels] = getLabel(43);
%data = bandpassFilter(2,8, 13,data );
%data = highpassFilter(2,5000*0.95,data);
data = data';
data(:,15)=[];
data(:,43)=[];
labels(15)=[];
labels(43)=[];


[coeff,score,latent,tsquared,explained,mu]=pcaTimeSeries(data,labels);