clear
%read data from file
ur='ur8'
flow_velocity=0.12;
%natural frequency
fn=0.3;   
prepath='D:\VIV2\resultGalloping\L=0.25D\';
postpath='\gallopingFoamNineteen\postProcessing\probes_3d\0\';
%postpath2='\gallopingFoamSixteen\'
pathName = [prepath ur postpath];
%pathName = [prepath ur postpath2];
infileName = 'U';
%infileName ='nondimention_displacement';
suffix = '.dat';

filename = [pathName infileName suffix];
%filename=[pathName infileName_2 suffix];

U_file=readmatrix(filename,'Delimiter',{'(',')',' ',' '},...
                           'NumHeaderLines',7 ,...
                           'TrimNonNumeric',true,...
                           'ConsecutiveDelimitersRule','join');
time = U_file(:,2);
U=U_file(:,4);
nondimention_U = U/flow_velocity;
data_scale0=size(time);


%sift the data
sifted_coeff=500;
data_size = data_scale0(1,1)/sifted_coeff;
j=1;
for i=1:data_scale0
if mod(i,sifted_coeff)==0
    sifted_time(j,1)=time(i,1);
    sifted_U(j,1)=nondimention_U(i,1);
    j=j+1;
end
end
figure(1)
plot(time,U,'k');
ylabel('U','FontName','times new Roman',...
                'FontAngle','italic',...
                'FontSize',15);
xlabel('Time(s)','FontName','times new Roman',...
                 'FontAngle','italic',...
                 'FontSize',15);           
xlim([30 70]);

%%%%%%%%%%%%%%%%%%%%%%%%wavelet analysis%%%%%%%%%%%%%%%%%%%%%%
%using the 2016 function
wavename='cmor3-3';
% figure(2)
% cwt(sifted_displacement,wavename)
% caxis([0 1])

deltT=sifted_time(2,1)-sifted_time(1,1);
Fs=1/deltT;

% [wt,fvs,coi] = cwt(sifted_displacement,wavename,Fs);
% figure(3)
% pcolor(sifted_time,fvs,abs(wt));shading interp
% colorbar
% axis([0 550 0 0.1])
% caxis([0 1])
%%%%using the 2006 function
wavename='cmor3-3'
Fc=centfrq(wavename); 
totalscal = data_size;
c=2*Fc*totalscal;
scals=c./(1:totalscal);
f=scal2frq(scals,wavename,1/Fs);
cw2=cwt(sifted_U,scals,wavename); 
[X,Y] = meshgrid(sifted_time,f);

%%%%%%%%%%%%%%%%%plot wavelet%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
Y=Y/fn;
surf(X,Y,abs(cw2));
shading interp
colormap(jet)
view(0,90)
%xlim([sifted_time(1) sifted_time(end)])
xlim([30 70])
set(gca,'ylim',[0,6])
caxis([0 1.3]);
c=colorbar;
c.Label.String = 'Magnitude';
xlabel('Time(s)','FontName','times new Roman',...
                 'FontAngle','italic',...
                 'FontSize',15);
ylabel('fvs/fn','FontName','times new Roman',...
                'FontAngle','italic',...
                 'FontSize',15);

%title(ur,'FontName','times new Roman',...
%                 'FontSize',15);
% figure(5)
% [C,h]=contour(sifted_time,f,cw2,8,'color','k');
% colorbar;
% xlim([sifted_time(1) sifted_time(end)])
% set(gca,'ylim',[0,1])


