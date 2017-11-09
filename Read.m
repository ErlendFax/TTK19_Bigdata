s = load('2017-05-29T10-53-03 MEA 2 Stimulator 4 (100-110s).mat')
%%
T = s.data';

%T = struct2table(s)
%%
coeff = pca(T);
%%

[x,labels] = getLabel(5);

pcaTimeSeries(T,labels);

x1 = getLabelIndex('65')
x2 = getLabelIndex('67')
x3 = getLabelIndex('66')

[theta,w,cw,ssqdif,yres] = plsr(T(:,x1), T(:,x3),1, 1, 2); %[0:x1,x2:end]