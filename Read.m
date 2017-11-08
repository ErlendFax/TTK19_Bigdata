s = load('2017-05-29T10-53-03 MEA 2 Stimulator 4 (100-110s).mat')
%%
T = s.data';

%T = struct2table(s)
%%
coeff = pca(T);
%%

[~,labels] = getLabel(5);

pcaTimeSeries(T,labels);

[theta,w,cw,ssqdif,yres] = plsr(coeff(:,[0:getLabelIndex(65),getLabelIndex(67):end]), coeff(:,getLabelIndex(66)),1, 2, 2)