% clear
% %read data from file
% ur='ur7'
% flow_velocity=0.105;
% %natural frequency
% fn=0.3;
% Lsp_filenames=["Lsp0_15","Lsp0_25","Lsp0_4","Lsp0_5",...
%                 "Lsp0_75","Lsp1"];
% 
% for Lsp=Lsp_filenames
%     
% prepath='D:\galloping\ur7_gallopingFoamNineteen\';
% postpath='\postProcessing\probes_3d\0\';
% pathName = [prepath convertStringsToChars(Lsp) postpath];
% infileName = 'U';
% suffix = '.dat';
% filename = [pathName infileName suffix];
% 
% U_file=readmatrix(filename,'Delimiter',{'(',')',' ',' '},...
%                            'NumHeaderLines',7 ,...
%                            'TrimNonNumeric',true,...
%                            'ConsecutiveDelimitersRule','join');
% time = U_file(:,2);
% U=U_file(:,4);
% nondimention_U = U/flow_velocity;
% data_scale0=size(time);
% 
% 
% %sift the data
% sifted_coeff=10;
% j=1;
% for i=1:data_scale0
% if mod(i,sifted_coeff)==0
%     sifted_time(j,1)=time(i,1);
%     sifted_U(j,1)=nondimention_U(i,1);
%     j=j+1;
% end
% end
% data_size=size(sifted_time);
% %%%%%%%%%%%%%%%%%%%%%%%
% L=data_size(1,1);
% T=sifted_time(2,1)-sifted_time(1,1);
% Fs=1/T;
% %%%%%%%%%%%%%%%%%%%%%%%%FFT analysis%%%%%%%%%%%%%%%%%%%%%%
% Y=fft(sifted_U);
% fvs= Fs*(0:(L/2))/L;
% fvs=fvs/fn;
% Y=abs(Y/L);
% Y1 = Y(1:L/2+1);
% Y2=[];
% for i=1:length(Y1)
%    Y2(i,1)=Y1(i,1)*Y1(i,1)*(1/L)*(1/Fs) ;
% end
% 
% Lsp_data=struct('fvs',fvs,...
%                 'Y',Y1,...
%                 'size',length(fvs))
% 
%  assignin('base',convertStringsToChars(Lsp),Lsp_data);
% end
% 
% bare_filename ='D:\galloping\ur7_gallopingFoamNineteen\cylinder\Cl.dat';
% Cl_file=readmatrix(bare_filename);
% time=Cl_file(:,1);
% Cl=Cl_file(:,2);
% nondimention_U = Cl_file(:,2);
% data_scale0=size(time);
% %sift the data
% sifted_coeff=10;
% j=1;
% for i=1:data_scale0
% if mod(i,sifted_coeff)==0
%     sifted_time(j,1)=time(i,1);
%     sifted_U(j,1)=nondimention_U(i,1);
%     j=j+1;
% end
% end
% data_size=size(sifted_time);
% %%%%%%%%%%%%%%%%%%%%%%%
% L=data_size(1,1);
% T=sifted_time(2,1)-sifted_time(1,1);
% Fs=1/T;
% %%%%%%%%%%%%%%%%%%%%%%%%FFT analysis%%%%%%%%%%%%%%%%%%%%%%
% Y=fft(sifted_U);
% fvs= Fs*(0:(L/2))/L;
% fvs=fvs/fn;
% Y=abs(Y/L);
% Y1 = Y(1:L/2+1);
% Y2=[];
% for i=1:length(Y1)
%    Y2(i,1)=Y1(i,1)*Y1(i,1)*(1/L)*(1/Fs) ;
% end
% Bare=struct('fvs',fvs,...
%                 'Y',Y1,...
%                 'size',length(fvs))
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lsp=[]
% for i=1:Bare.size
% Lsp(i,1)=0;
% end
% for i=1:Lsp0_15.size
% Lsp(i,2)=0.15;
% end
% for i=1:Lsp0_25.size
% Lsp(i,3)=0.25;
% end
% for i=1:Lsp0_4.size
% Lsp(i,4)=0.4;
% end
% for i=1:Lsp0_5.size
% Lsp(i,5)=0.5;
% end
% for i=1:Lsp0_75.size
% Lsp(i,6)=0.75;
% end
% for i=1:Lsp1.size
% Lsp(i,7)=1;
% end
plot3(Lsp(:,1),Bare.fvs,Bare.Y,...
      Lsp(:,2),Lsp0_15.fvs,Lsp0_15.Y,...
      Lsp(:,3),Lsp0_25.fvs,Lsp0_25.Y,...
      Lsp(:,4),Lsp0_4.fvs,Lsp0_4.Y,...
      Lsp(:,5),Lsp0_5.fvs,Lsp0_5.Y,...
      Lsp(:,6),Lsp0_75.fvs,Lsp0_75.Y,...
      Lsp(:,7),Lsp1.fvs,Lsp1.Y,'LineWidth',1);
view(40,10)
ylabel('fvs/fn','FontName','times new Roman',...
                  'FontAngle','italic',...
                  'FontSize',24);
xlabel('Lsp','FontName','times new Roman',...
                  'FontAngle','italic',...
                  'FontSize',24);
zlabel('Normalized amplitude(U)','FontName','times new Roman',...
                  'FontAngle','italic',...
                  'FontSize',24);
xlim([0 1.1])
ylim([0.1 5])
grid on
set(gca, 'GridAlpha', 0.5);
set(gca,'FontSize',16,'FontName','times new Roman'); 
%zlim([0 920])
% figure(1)
% surf(Lsp0_15.X,Lsp0_15.Y,abs(Lsp0_15.cw2));
% shading interp
% colormap(jet)
% 
% %xlim([sifted_time(1) sifted_time(end)])
% xlim([10 90])
% set(gca,'ylim',[0,6])
% %caxis([0 2]);
% c=colorbar;
% c.Label.String = 'Magnitude';
% xlabel('Time(s)','FontName','times new Roman',...
%                  'FontAngle','italic',...
%                  'FontSize',15);
% ylabel('fvs/fn','FontName','times new Roman',...
%                 'FontAngle','italic',...
%                  'FontSize',15);
% 
% title(ur,'FontName','times new Roman',...
%                  'FontSize',15);



