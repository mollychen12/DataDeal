clc
clear all
close all
format long%修改显示长度
path(path,'C:\Users\Administrator\Desktop\仿鱼尾\仿鱼尾热线导出数据');%添加子函数调用路径
addpath(genpath('C:\Users\Administrator\Desktop\仿鱼尾\仿鱼尾热线导出数据'))
[filename,pathname]=uigetfile({'*.txt'},'selectfile','MultiSelect','ON');%鼠标点击次序不影响文件读取次序
cd(pathname)
if ~iscell(filename) %单个文件 此时filename不是cell类型
 a=[];
a=importdata(fullfile(pathname,filename));%储存单个txt文件  可生成结构体数据  调用形式多样灵活  a.textdata{1}(1,:)
 %a.textdata{1}   a.textdata
 b={};%元胞数组 调用形式b{2}(1,2)
 if isstruct(a)
  b{1,1}=cellstr(filename);%储存文件名 b{1,1}{1,i}为第i个文件名  注意cell需转化为char
  b{1,2}=a.data;
 else
   b{1,1}=cellstr(filename);%储存文件名 b{1,1}{1,i}为第i个文件名  注意cell需转化为char  此时元素不是cell 必须cellstr
  b{1,2}=a;
 end
else %多个文件
    b={};%元胞数组 调用形式b{2}(1,2)
    b{1}=filename;%储存文件名 b{1,1}{1,i}为第i个文件名  注意cell需转化为char
    for i=1:length(filename)
        b{1,i+1}=importdata(fullfile(pathname,char(filename{1,i})));%储存多个txt文件  b为1*n cell
    end
end
%用于读取单个或多个txt文件
%figure
%plot(b{2}(:,1),b{2}(:,2))
wave=b{2};
s=wave(:,2);
t=wave(:,1);
fs=1/(t(2)-t(1));
timestep=1/fs;
mymax=sunffttransfer(b{2}(:,2)',timestep,char(b{1}))
figure
plot(t, s)
% 连续小波变换
wavename='cmor3-3';%cmor3-3
totalscal=length(t)/2;
Fc=centfrq(wavename); % 小波的中心频率
c=2*Fc*totalscal;
scals=c./(1:totalscal);
f=scal2frq(scals,wavename,1/fs); % 将尺度转换为频率
coefs=cwt(s,scals,wavename); % 求连续小波系数
figure
imagesc(t,f,abs(coefs));
set(gca,'YDir','normal')
colorbar;
shading interp
colormap(jet)
xlabel('时间 t/s');
ylabel('频率 f/Hz');
set(gca,'ylim',[0,1])
title('小波时频图')
