clc
clear all
close all
format long%�޸���ʾ����
path(path,'C:\Users\Administrator\Desktop\����β\����β���ߵ�������');%����Ӻ�������·��
addpath(genpath('C:\Users\Administrator\Desktop\����β\����β���ߵ�������'))
[filename,pathname]=uigetfile({'*.txt'},'selectfile','MultiSelect','ON');%���������Ӱ���ļ���ȡ����
cd(pathname)
if ~iscell(filename) %�����ļ� ��ʱfilename����cell����
 a=[];
a=importdata(fullfile(pathname,filename));%���浥��txt�ļ�  �����ɽṹ������  ������ʽ�������  a.textdata{1}(1,:)
 %a.textdata{1}   a.textdata
 b={};%Ԫ������ ������ʽb{2}(1,2)
 if isstruct(a)
  b{1,1}=cellstr(filename);%�����ļ��� b{1,1}{1,i}Ϊ��i���ļ���  ע��cell��ת��Ϊchar
  b{1,2}=a.data;
 else
   b{1,1}=cellstr(filename);%�����ļ��� b{1,1}{1,i}Ϊ��i���ļ���  ע��cell��ת��Ϊchar  ��ʱԪ�ز���cell ����cellstr
  b{1,2}=a;
 end
else %����ļ�
    b={};%Ԫ������ ������ʽb{2}(1,2)
    b{1}=filename;%�����ļ��� b{1,1}{1,i}Ϊ��i���ļ���  ע��cell��ת��Ϊchar
    for i=1:length(filename)
        b{1,i+1}=importdata(fullfile(pathname,char(filename{1,i})));%������txt�ļ�  bΪ1*n cell
    end
end
%���ڶ�ȡ��������txt�ļ�
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
% ����С���任
wavename='cmor3-3';%cmor3-3
totalscal=length(t)/2;
Fc=centfrq(wavename); % С��������Ƶ��
c=2*Fc*totalscal;
scals=c./(1:totalscal);
f=scal2frq(scals,wavename,1/fs); % ���߶�ת��ΪƵ��
coefs=cwt(s,scals,wavename); % ������С��ϵ��
figure
imagesc(t,f,abs(coefs));
set(gca,'YDir','normal')
colorbar;
shading interp
colormap(jet)
xlabel('ʱ�� t/s');
ylabel('Ƶ�� f/Hz');
set(gca,'ylim',[0,1])
title('С��ʱƵͼ')
