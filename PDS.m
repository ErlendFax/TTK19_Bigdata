%% PDS of .mat files
clear;
[filename, pathname] = uigetfile('*.mat','Select .mat file to open');
%filename ='2017-05-29T10-53-03 MEA 2 Stimulator 4 (100-500s).mat';
%pathname ='/Users/Helge-Andre/Dropbox/NTNU/Prosjektoppgave/matlab/Dataset/TTK19/';
if isequal(filename,0) || isequal(pathname,0)
   disp('User pressed cancel')
else
   dataFile = load([pathname filename]);
   dataFile =dataFile.data';
   
end

%%
stimuliTime = 20; % 20, 80
interval = 6;
Fs = 10000;

startTime = (stimuliTime-interval/2) *Fs;
endTime = startTime + interval*Fs;
data = dataFile(startTime:endTime,:);
time = (0:(size(data,1)-1))./Fs;

%ref = data.data(15,:);
%%
lowpassData = lowpassFilter(4, 100,data );


%% 
signal63 = data(:,38)'; %63=38
signal66 = data(:,53)'; % 66=53
signal74 = data(:,44)'; % 74=44


%% 
sig63 = lowpassData(:,38)'; %63
sig66 = lowpassData(:,53)';
sig74 = lowpassData(:,44)';

%%
%signal = signal -ref;
figure
subplot(3,3,1)
plot(time,sig74./1000000)
y1=get(gca,'ylim');
hold on
plot([interval/2 interval/2],y1,'r--')
ylabel('Voltage [\muV]')
xlabel('Time [s]')

title('74')
subplot(3,3,2)
plot(time,sig63./1000000)
y1=get(gca,'ylim');
hold on
plot([interval/2 interval/2],y1,'r--')
xlabel('Time [s]')
title('63')

subplot(3,3,3)
plot(time,sig66./1000000)
y1=get(gca,'ylim');
hold on
plot([interval/2 interval/2],y1,'r--')
xlabel('Time [s]')
title('66')

%periodogram(signal,[],[],10000,'power');
%[Pref,fref] = periodogram(ref,[],[],10000,'power');
[P63,f63] = periodogram(sig63,[],[],10000,'power');
[P66,f66] = periodogram(sig66,[],[],10000,'power');
[P74,f74] = periodogram(sig74,[],[],10000,'power');
subplot(3,3,4)
plot(f74,P74,'k')
xlim([0 40])
grid
ylabel('Power')
xlabel('Frequency [Hz]')
title('Power Spectrum')

subplot(3,3,5)
plot(f63,P63,'k')
xlim([0 40])
xlabel('Frequency [Hz]')

subplot(3,3,6)
plot(f66,P66,'k')
xlabel('Frequency [Hz]')
xlim([0 40])

segmentLength = round(numel(sig74)/128); % Equivalent to setting segmentLength = [] in the next line
subplot(3,3,7)
spectrogram(sig74,segmentLength,[],[],10000,'yaxis')
ylim([0 1]);
subplot(3,3,8)
spectrogram(sig63,segmentLength,[],[],10000,'yaxis')
ylim([0 1]);
subplot(3,3,9)
spectrogram(sig66,segmentLength,[],[],10000,'yaxis')
ylim([0 1]);

%% Hilbert
[imf74,d74]=plot_hht(sig74,1/10000,0);
[imf63,d63]=plot_hht(sig63,1/10000,0);
[imf66,d66]=plot_hht(sig66,1/10000,0);
%%
z = 0;
for k = 1:length(imf74)
   z = z+hilbert(imf74{k});
   Hj74(:,k)=abs(hilbert(imf74{1,k}))';
end
%%
z = 0;
for k = 1:length(imf63)
   z = z+hilbert(imf74{k});
   Hj63(:,k)=abs(hilbert(imf63{1,k}))'.^2;
end
z = 0;
for k = 1:length(imf66)
   z = z+hilbert(imf66{k});
   Hj66(:,k)=abs(hilbert(imf66{1,k}))'.^2;
end
H74 = sum(Hj74,2);
H63 = sum(Hj63,2);
H66 = sum(Hj66,2);
figure;plot(H74)
figure;plot(H63)
figure;plot(H66)

%%
figure
[P74,f74] = periodogram(sig74,[],[],10000,'power');
[Px,fx] = periodogram(x,[],[],10000,'power');
plot(f74,P74)
hold on
plot(fx,Px,'r--')

%%
figure
spectrogram(sig74,segmentLength,[],[],10000,'yaxis')
figure
spectrogram(x,segmentLength,[],[],10000,'yaxis')

%% 
imfs = cell2mat(imf')';
freq = cell2mat(d')';
[A F] = mhs(a,freq,0,[],[]);

%%
j = 1;
wj = d{j};
ampl = a(:,j);
for w=1:100
    if ismember(wj,w)
        Hj(w,:) = ampl;
    else
        Hj(w,:)=zeros(length(ampl),1);
    end
end
