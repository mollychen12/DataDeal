clear
%define physics properties
ur= 'ur12';
Lsp=0.5;
fosc=0.333;
flow_velocity=0.18;


if Lsp==0.25
splitter=struct('D',0.05,...
                'L',0.0848,...
                'Lsp',0.25,...
                'mass',0.45284909,...
                'stiffness',1.651068447,...
                'dampness_structure',0.012138155,...
                'dampness_harness',0.012138155)
else if Lsp==0.5
 splitter=struct('D',0.5334,...
                'L',22,...
                'Lsp',0.5,...
                'mass',13276.3751,...
                'stiffness',48146.01901,...
                'dampness_structure',353.9549451,...
                'dampness_harness',353.9549451)
  
else if Lsp==1
 splitter =  struct('D',0.5334,...
                'L',22,...
                'Lsp',1.0,...
                'mass',12787.52,...
                'stiffness',61393.17,...
                'dampness_structure',392.2665,...
                'dampness_harness',392.2665) 
else if Lsp ==0.15
            splitter = struct('D',0.05,...
                'L',0.0848,...
                'Lsp',0.15,...
                'mass',0.452996309,...
                'stiffness',1.642765343,...
                'dampness_structure',0.012077113,...
                'dampness_harness',0.012077113) 
 else if Lsp ==0.4
              splitter = struct('D',0.05,...
                'L',0.0848,...
                'Lsp',0.4,...
                'mass',0.458720309,...
                'stiffness',1.663523103,...
                'dampness_structure',0.012229718,...
                'dampness_harness',0.012229718) 
 else if Lsp==0.75
                 splitter = struct('D',0.05,...
                'L',0.0848,...
                'Lsp',0.75,...
                'mass',0.466733909,...
                'stiffness',1.692583968,...
                'dampness_structure',0.012443365,...
                'dampness_harness',0.012443365)  
  else if Lsp==0
                 splitter = struct('D',0.05,...
                'L',0.0848,...
                'Lsp',0,...
                'mass',0.449562,...
                'stiffness',1.630311,...
                'dampness_structure',0.011986,...
                'dampness_harness',0.011986)  
                    end
                end
            end
         end
       end
    end
end
            

            
%read data from file,dimentioned parameters

prepath=['D:\galloping\csai\Lsp' num2str(Lsp) '\'];

postpath='\gallopingFoamNineteen\';
pathName = [prepath ur postpath];
infileName_1 = 'y_v_a';
suffix = '.dat';
filename_1 = [pathName infileName_1 suffix];
y_v_a=readmatrix(filename_1);

%infileName2 ='nondimention_displacement'
%filename_2=[pathName infileName_1 suffix];
%nondimention_Displacement = readmatrix(filename_2);

time =y_v_a(:,1);
%nondimention_displacement=nondimention_Displacement(:,2);

%displacement=nondimention_displacement*splitter.D;
displacement=y_v_a(:,2);
velocity =y_v_a(:,3);
acceleration=y_v_a(:,4);

data_scale0=size(time);

%%%%%%%%%%nondimention the velocity and acceleration%%%%%%%%%%%
velocity0= flow_velocity;
nondimention_velocity = velocity/velocity0;
deltT=time(2,1)-time(1,1);
acceleration0=(nondimention_velocity(2,1)-nondimention_velocity(1,1))/deltT;
nondimention_acceleration=acceleration/acceleration0;
%sift the data
sifted_coeff=10;
data_size = data_scale0(1,1)/sifted_coeff;
j=1;
for i=1:data_scale0
if mod(i,sifted_coeff)==0
    sifted_time(j,1)=time(i,1);
    sifted_velocity(j,1)=velocity(i,1);
    sifted_acceleration(j,1)=acceleration(i,1);
    sifted_displacement(j,1)=displacement(i,1);
    j=j+1;
end
end

% plot(sifted_time,sifted_velocity,'*');
% hold on
% plot(sifted_time,sifted_acceleration,'.');
% hold on
% plot(sifted_time,sifted_displacement,'-');

%%%%%%%%%%%%%%%energy Calculus%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%according to the energies 2018
%get the Tosc

% Tosc = 1/fosc;
% sifted_deltT=sifted_time(2,1)-sifted_time(1,1);
% n_periods =time(end)/Tosc;
% steps_Tosc=int32(Tosc/sifted_deltT)
% Power_1=[];
% 
% %calculate P1
% for i=1:(data_size-steps_Tosc)
%     sum=0.0;
%  for j=i:i+steps_Tosc
%      F_fluid = splitter.mass*sifted_acceleration(j,1)+...
%           splitter.dampness_harness*sifted_velocity(j,1)+...
%           splitter.stiffness*sifted_displacement(j,1);
%       temp=F_fluid*sifted_velocity(i,1)*sifted_deltT;
%       sum =sum+temp;
%  end
%  Power_1(i,1)=sum/Tosc;
% end
% for i=(data_size-steps_Tosc):data_size
%     Power_1(i,1)=Power_1(data_size-steps_Tosc);
% end
% 
% %calculate P2
% %searching the local maximum (Apeaks)
% [pks locs]=findpeaks(sifted_displacement);
% plot(sifted_time,sifted_displacement);
% hold on
% maxPeaks_size=size(locs);
% maxim_time=[];
% max_min_interval_time=[];
% %searching the local minimum
% TF=islocalmin(sifted_displacement);
% minus_peaks=sifted_displacement(TF);
% minus_time=sifted_time(TF);
% for i=1:maxPeaks_size(1,1)
% maxim_time(i,1)=sifted_time(locs(i,1),1);
% max_min_interval_time(i,1)=maxim_time(i,1)-minus_time(i,1);
% end
% %get the displacement=0  the time
% size_minus_time=size(minus_time);
% size_max_time=size(maxim_time);
%  displacementEqual0_pos=[];
%  peaks_pos=[];
% for i=1:data_size
%     for j=1:size_minus_time(1,1)
%   if sifted_time(i,1)== minus_time(j,1);
%     minus_time(j,2)=i;
%   end
%     end
%    for k=1:size_max_time(1,1)
%        if sifted_time(i,1)==maxim_time(k,1);
%            maxim_time(k,2)=i;
%        end
%    end
% end
% 
% displacementEqual0_pos(1,1)=1;
% for i=1:size_max_time(1,1)-1
% displacementEqual0_pos(2*i,1)=int32((maxim_time(i,2)+minus_time(i,2))/2);
% displacementEqual0_pos(2*i+1,1)=int32((minus_time(i+1,2)+maxim_time(i,2))/2);
% end
% 
% size_displacementEqual0_pos=size(displacementEqual0_pos);
% %displacementEqual0_pos(size_yEqual0(1,1)+1,1)=(minus_time(end,2)+maxim_time(end,2))/2;
% 
% for i=1:size_max_time(1,1)
%     peaks_pos(2*i,1)=maxim_time(i,2);
%     peaks_pos(2*i-1,1)=minus_time(i,2);
% end
% 
% size_peaks_pos=size(peaks_pos);
% peaks_pos(size_peaks_pos(1,1)+1,1)=minus_time(end);
% size_peaks_pos = size_peaks_pos(1,1)+1;
% %calculus P2
% power_2=[];
% Power_2=[];
% temp=0.0;sum=0.0;
% for i=1:(size_peaks_pos-2)
% sum=0;
% down_limit=int32(displacementEqual0_pos(i,1));
% high_limit=int32(peaks_pos(i,1));
% for j=down_limit:high_limit
%     temp=abs(splitter.stiffness*sifted_displacement(j,1)*(sifted_displacement(j+1,1)-sifted_displacement(j,1)));
%     sum=sum+temp;
% end
% power_2(i,1)=sum/Tosc;
% end
% 
% for i=1:size_displacementEqual0_pos(1,1)-1
% for j=displacementEqual0_pos(i,1):displacementEqual0_pos(i+1,1)
% Power_2(j,1)=power_2(i,1);
% end
% end
% 
% size_Power_2=size(Power_2)
% end_Power_2=Power_2(end);
% for i=size_Power_2(1,1):data_size
% Power_2(i,1)=end_Power_2;
% end
%     
% 
% 
% 
% 
% %%
% %add the power1 and power2
% Power=[];
% for i=1:data_size
% Power(i,1) = Power_1(i,1)+Power_2(i,1);
% end





%%%%%%%%%%%%%fluid power%%%%%%%%%%%%%%
rho=1000;
[pks locs]=findpeaks(sifted_displacement);
max_peaks = max(pks);
swept_volume=(2*max_peaks+splitter.D)*splitter.L;
power_fluid = 0.5*rho*flow_velocity*flow_velocity*flow_velocity*swept_volume
% yita=Power/power_fluid;
% 
% yita1=Power_1/power_fluid;
% 
% figure(2)
% subplot(2,1,1)
% plot(sifted_time,Power,'b');
% legend('Power KW')
% hold on
% subplot(2,1,2)
% plot(sifted_time,yita,'r');
% legend('Yita ')
% xlabel('Time t/s')
% 
% figure(3)
% subplot(2,1,1)
% plot(sifted_time,Power_1,'b');
% legend('Power KW')
% hold on
% subplot(2,1,2)
% plot(sifted_time,yita1,'r');
% legend('Yita ')
% xlabel('Time t/s')

%%%%%%%%%%%%%%%%%%%calculus using Singh K mode%%%%%%%%%%%%%%%%%%
P_harness = [];
Tosc = 1/fosc;
sifted_deltT=sifted_time(2,1)-sifted_time(1,1);
n_periods =time(end)/Tosc;
steps_Tosc=int32(Tosc/sifted_deltT)
%calculate P
% for i=1:(data_size-steps_Tosc)
%     sum=0.0;
%  for j=i:i+steps_Tosc
%       temp=splitter.dampness_harness*sifted_velocity(j,1)*sifted_velocity(j,1)*sifted_deltT;
%       sum =sum+temp;
%  end
%  Power_harness(i,1)=sum/Tosc;
% end
% for i=(data_size-steps_Tosc):data_size
%     Power_harness(i,1)=Power_harness(data_size-steps_Tosc);
% end
for i=1:data_size
    Power_harness(i,1)=splitter.dampness_harness*sifted_velocity(i,1)*sifted_velocity(i,1);
end    
yita2=100*Power_harness/power_fluid;
mw_Power_harness =1000*Power_harness;
[pks_p locs]=findpeaks(mw_Power_harness);
[pks_eta locs]=findpeaks(yita2);
figure(4)
subplot(2,1,1)
plot(sifted_time,mw_Power_harness,'k');
ylabel('P mW','FontName','times new Roman',...
                'FontAngle','italic',...
                 'FontSize',15);
%legend('P_{harvesting}','FontName','times new Roman')
xlim([25 70])
%ylim([0 0.07])
title(ur,'FontName','times new Roman',...
                 'FontSize',15);
hold on
subplot(2,1,2)
plot(sifted_time,yita2,'k');
%legend('\eta','FontName','times new Roman')
xlabel('Time(s)','FontName','times new Roman',...
                 'FontAngle','italic',...
                 'FontSize',15);
ylabel('\eta %','FontName','times new Roman',...
                'FontAngle','italic',...
                 'FontSize',15);

xlim([25 70])
%ylim([0,1.3])



sum_Power=0;
length_Power=length(Power_harness)
time_end =sifted_deltT*length_Power
for i=1:(length_Power-1)
sum_Power = sum_Power+ Power_harness(i,1)*sifted_deltT;
end
average_Power = sum_Power/time_end
mw_average_Power= 1000*average_Power;
average_eta =100*average_Power/power_fluid

