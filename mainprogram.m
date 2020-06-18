close all
clear all
format long%修改显示长度
[filename,pathname]=uigetfile({'*.txt'},'selectfile','MultiSelect','ON');%鼠标点击次序不影响文件读取次序
cd(pathname)
if ~iscell(filename) %单个文件 此时filename不是cell类型
a=importdata(fullfile(pathname,filename));%储存单个txt文件  可生成结构体数据  调用形式多样灵活  a.textdata{1}(1,:)
 %a.textdata{1}   a.textdata
else 
    b={};%元胞数组 调用形式b{2}(1,2)
    b{1}=filename;%储存文件名
    for i=1:length(filename)
        b{i+1}=importdata(fullfile(pathname,char(filename{1,i})));%储存多个txt文件      
    end
end
%for i=1:length(filename)
 %bb=b{1};
%save([ '选择文件名','.txt'],'bb','-ascii')

%用于读取单个或多个txt文件
fn=8.87;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D=0.05;
vel=load('Velocity.txt');
U=fn*D;
x=vel(:,1)/U;%约化速度具体值 约化速度个数代表文件个数
space=5;%指定相邻约化速度间隔行数0
tempx=zeros(1,(length(x)+1)*space);%约化速度
for i=space:space:length(tempx)-space
    tempx(i)=x(i/space);
end%赋约化速度值
tempx(length(tempx))=x(length(x))+1;%最后一位无实际意义

tempx(1:space)=linspace(2,tempx(space),space);
for i=space:space:length(tempx)-space
   tempx(i:i+space)=linspace(tempx(i),tempx(i+space),space+1);
end

x=tempx;%约化速度
stopx1=20;
stopx2=5000;%截取数据段长度
y=b{1,2}(stopx1:stopx2,1)/8.87;%5-1400是数据长度  y代表频率值  10.42固有频率%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
prompt1='输入最小间隔\n';%
tempp1=input(prompt1);
prompt2='输入最小高度\n';%
tempp2=input(prompt2);
[maxv,maxl]=findpeaks(tempb(:,2),'minpeakdistance',tempp1,'minpeakheight',tempp2);
for ii=1:length(maxl)
    scatter(tempb(maxl(ii),1),maxv(ii),'*k')%极值点位置及值
    hold on
end
control1=input('是否继续优化？y/n\n','s');
end
%tempb(:,2)=0;%幅值全部归零
tempb(:,2)=0.1*tempb(:,2);%全部缩小0.1
for ii=1:length(maxl)
tempb(maxl(ii),2)=maxv(ii);%极大值还原
zzz=15;
tempb(maxl(ii)-zzz:maxl(ii)+zzz,2)=interp1(maxl(ii)-zzz:15:maxl(ii)+zzz,tempb(maxl(ii)-zzz:15:maxl(ii)+zzz,2),maxl(ii)-zzz:1:maxl(ii)+zzz,'spline');
%for iii=1:zzz%zzz复制次数
   % tempb(maxl(ii)-iii,2)=(zzz-iii)/zzz*maxv(ii);
   % tempb(maxl(ii)+iii,2)=(zzz-iii)/zzz*maxv(ii);
%end
%同一列左右幅值，辅助显示
end
tempb(:,2)=tempb(:,2)/max(tempb(:,2));%归一化
figure 
plot(tempb(:,1),tempb(:,2))
Z(:,j)=tempb(:,2);
%Z(:,j+1)=0.5*tempb(:,2);
%Z(:,j-1)=0.5*tempb(:,2);%前后复制
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
%load MyColormaps;%这里load时要添加的是mat格式的文件名称
%$colormap(mymap);%这里调用的colormap为代表MyColormaps.mat的mymap变量
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
%mymap = get(gcf,'Colormap');%gcf是get current figure的缩写
%save('MyColormaps','mymap');%把mymap变量保存为MyColormaps.mat，位置在matlab当前目录
%shading interp;
% xlabel('\it{f_0/f_n}')