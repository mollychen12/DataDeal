close all
clear all
format long%�޸���ʾ����
[filename,pathname]=uigetfile({'*.txt'},'selectfile','MultiSelect','ON');%���������Ӱ���ļ���ȡ����
cd(pathname)
if ~iscell(filename) %�����ļ� ��ʱfilename����cell����
a=importdata(fullfile(pathname,filename));%���浥��txt�ļ�  �����ɽṹ������  ������ʽ�������  a.textdata{1}(1,:)
 %a.textdata{1}   a.textdata
else 
    b={};%Ԫ������ ������ʽb{2}(1,2)
    b{1}=filename;%�����ļ���
    for i=1:length(filename)
        b{i+1}=importdata(fullfile(pathname,char(filename{1,i})));%������txt�ļ�      
    end
end
%for i=1:length(filename)
 %bb=b{1};
%save([ 'ѡ���ļ���','.txt'],'bb','-ascii')

%���ڶ�ȡ��������txt�ļ�
fn=8.87;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D=0.05;
vel=load('Velocity.txt');
U=fn*D;
x=vel(:,1)/U;%Լ���ٶȾ���ֵ Լ���ٶȸ��������ļ�����
space=5;%ָ������Լ���ٶȼ������0
tempx=zeros(1,(length(x)+1)*space);%Լ���ٶ�
for i=space:space:length(tempx)-space
    tempx(i)=x(i/space);
end%��Լ���ٶ�ֵ
tempx(length(tempx))=x(length(x))+1;%���һλ��ʵ������

tempx(1:space)=linspace(2,tempx(space),space);
for i=space:space:length(tempx)-space
   tempx(i:i+space)=linspace(tempx(i),tempx(i+space),space+1);
end

x=tempx;%Լ���ٶ�
stopx1=20;
stopx2=5000;%��ȡ���ݶγ���
y=b{1,2}(stopx1:stopx2,1)/8.87;%5-1400�����ݳ���  y����Ƶ��ֵ  10.42����Ƶ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[X,Y]=meshgrid(x,y);
j=space;
Z=zeros(length(y),length(x));
for i=1:(length(b)-1)

plot(b{1,i+1}(stopx1:stopx2,1)/8.87,b{1,i+1}(stopx1:stopx2,2))%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(gca,'XTick',0:1:20);
hold on
tempb=[];
tempb=[b{1,i+1}(stopx1:stopx2,1)/8.87,b{1,i+1}(stopx1:stopx2,2)];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
control1='y';
while(control1=='y'||control1=='Y')
prompt1='������С���\n';%
tempp1=input(prompt1);
prompt2='������С�߶�\n';%
tempp2=input(prompt2);
[maxv,maxl]=findpeaks(tempb(:,2),'minpeakdistance',tempp1,'minpeakheight',tempp2);
for ii=1:length(maxl)
    scatter(tempb(maxl(ii),1),maxv(ii),'*k')%��ֵ��λ�ü�ֵ
    hold on
end
control1=input('�Ƿ�����Ż���y/n\n','s');
end
%tempb(:,2)=0;%��ֵȫ������
tempb(:,2)=0.1*tempb(:,2);%ȫ����С0.1
for ii=1:length(maxl)
tempb(maxl(ii),2)=maxv(ii);%����ֵ��ԭ
zzz=15;
tempb(maxl(ii)-zzz:maxl(ii)+zzz,2)=interp1(maxl(ii)-zzz:15:maxl(ii)+zzz,tempb(maxl(ii)-zzz:15:maxl(ii)+zzz,2),maxl(ii)-zzz:1:maxl(ii)+zzz,'spline');
%for iii=1:zzz%zzz���ƴ���
   % tempb(maxl(ii)-iii,2)=(zzz-iii)/zzz*maxv(ii);
   % tempb(maxl(ii)+iii,2)=(zzz-iii)/zzz*maxv(ii);
%end
%ͬһ�����ҷ�ֵ��������ʾ
end
tempb(:,2)=tempb(:,2)/max(tempb(:,2));%��һ��
figure 
plot(tempb(:,1),tempb(:,2))
Z(:,j)=tempb(:,2);
%Z(:,j+1)=0.5*tempb(:,2);
%Z(:,j-1)=0.5*tempb(:,2);%ǰ����
%Z(:,j+2)=0.4*tempb(:,2);
%Z(:,j-2)=0.4*tempb(:,2);
j=j+space;
end
[n1,n2]=size(Z);
%for j=1:1:n1
  %Z(1,1:1:space)=interp1(1:space:space,Z(1,1:space:space),1:1:space,'pchip');
%end
for j=1:1:n1  
  %Z(j,1:1:5)=interp1(1:space-1:5,Z(j,1:space-1:5),1:1:5,'pchip');
  for i=space:space:n2-space
  Z(j,i:1:i+space)=interp1(i:space:i+space,Z(j,i:space:i+space),i:1:i+space,'pchip');
 end
end
save('tempdata','X','Y','Z')
close all
surf(X,Y,Z,Z,'edgecolor','None','LineWidth',0.01);
xlabel('\it{U_r}');
ylabel('\it{f_0/f_n}')
zlabel('PSD');
xlim([0 max(x)])
ylim([0 7])
zlim([0 1])
h=colorbar;
set(get(h,'title'),'string','PSD');
colormap jet
set(get(h,'title'),'string','PSD');
shading interp
%load MyColormaps;%����loadʱҪ��ӵ���mat��ʽ���ļ�����
%$colormap(mymap);%������õ�colormapΪ����MyColormaps.mat��mymap����
%colorbar;
%view(2),colorbar;
%shading interp
%figure
%surf(X,Y,Z,Z,'LineWidth',0.5);
%shading interp
%xlabel('\it{U_r}');
%ylabel('\it{f_0/f_n}')
%zlabel('PSD');
%xlim([0 max(x)])
%ylim([0 5])
%zlim([0 1])
%h=colorbar;
%colormap jet
%set(get(h,'title'),'string','PSD');
%mymap = get(gcf,'Colormap');%gcf��get current figure����д
%save('MyColormaps','mymap');%��mymap��������ΪMyColormaps.mat��λ����matlab��ǰĿ¼
%shading interp;
% xlabel('\it{f_0/f_n}')