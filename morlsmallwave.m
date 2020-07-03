%参考网址
%http://blog.sina.com.cn/s/blog_6dc9b68f0102vssb.html
%http://blog.sina.com.cn/s/blog_681912f90102vq6v.html
%**********************************************
%波浪序列时频图
%*********************************************
clc
clear all
close all
format long%修改显示长度
[filename,pathname]=uigetfile({'*.txt';'*.xls'},'selectfile','MultiSelect','ON');%鼠标点击次序不影响文件读取次序
cd(pathname)
if ~iscell(filename) %单个文件 此时filename不是cell类型
end
 a=[];
a=importdata(fullfile(pathname,filename));%储存单个txt文件  可生成结构体数据  调用形式多样灵活
wave=a.data;
y=wave(:,2)-1;
t=wave(:,1);
subplot(3,1,1);
plot(t,y);
title('位移')
xlabel('时间')
ylabel('波高')

xlim([t(1) t(end)]);
wavename='morl';
totalscal= length(t);
Fs=1/(t(2)-t(1));
Fc=centfrq(wavename); % 小波的中心频率
c=2*Fc*totalscal;
scals=c./(1:totalscal);%小波变换尺度
f=scal2frq(scals,wavename,1/Fs); % 将尺度转换为频率
cw2=cwt(y,scals,wavename); % 求连续小波系数
[X,Y] = meshgrid(t,f);%绘图
subplot(3,1,2);
mesh(X,Y,abs(cw2));%绘图
shading interp
colormap(jet)
view(0,90)
title('时频图')
xlabel('时间')
ylabel('频率')
xlim([t(1) t(end)])
set(gca,'ylim',[0,max(max(Y))])
%set(gca,'YScale','log')
subplot(3,1,3)
[C,h]=contour(t,f,cw2,8,'color','k');%求等值线图
%clabel(C,h); %加标值
xlim([t(1) t(end)])
set(gca,'ylim',[0,max(max(Y))])