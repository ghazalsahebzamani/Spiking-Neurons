clc
clear
close all
load('C:\Users\NMB\AppData\Local\Temp\Rar$DRa0.441\Data.mat')
m1=He(1,1920000:3839999);
t1=0:1/32000:60;
t1=t1(:,1:1920000);
figure();
plot(t1,m1);
size(He);
N  = 10;   % Order
Fc = 300;  % Cutoff Frequency
Fs = 32000; 
h  = fdesign.lowpass('N,F3dB', N, Fc, Fs);
lp = design(h, 'butter');
lff1=filter(lp,m1);

bp = designfilt('bandpassiir','FilterOrder',20, ...
'HalfPowerFrequency1',300,'HalfPowerFrequency2',6000, ...
'SampleRate',32000);
ap1=filtfilt(bp,m1);
figure();
plot(t1,ap1);
figure();
plot(t1,lff1);
m2=He(1,1920001:11520000);
t2=0:1/32000:300;
t2=t2(1,1:9600000);
ap2=filtfilt(bp,m2);
ap2_abs=abs(ap2);
noise=median(ap2_abs)/0.6745;
th=5*noise;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:9600000
    if ap2(1,i)<th
    ap2(1,i)=0;
    else
     ap2(1,i)=1;
        end
end
figure();
plot(t2,ap2);
[pks,locs]=findpeaks(ap2);
s=zeros(size(locs,2),64);
for i=2:1:size(locs,2)
    
    s(i,:)=ap2(1,locs(1,i)-20:locs(1,i)+43);

end
rng('default');  % For reproducibility
eva = evalclusters(s,'kmeans','CalinskiHarabasz','KList',[1:11]);
% % %by runing the code we find that the best number of custers is 2.
[coeff,score]=pca(s,'NumComponents',2);
[id_c,clstr]=kmeans(s,2);
figure;
plot(score(id_c==1,1),score(id_c==1,2),'r.','MarkerSize',12);
hold on
plot(score(id_c==2,1),score(id_c==2,2),'b.','MarkerSize',12);



legend('Cluster 1','Cluster 2',...
       'Location','NW')
title 'Cluster Assignments'
hold off