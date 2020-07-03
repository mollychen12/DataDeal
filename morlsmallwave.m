%�ο���ַ
%http://blog.sina.com.cn/s/blog_6dc9b68f0102vssb.html
%http://blog.sina.com.cn/s/blog_681912f90102vq6v.html
%**********************************************
%��������ʱƵͼ
%*********************************************
clc
clear all
close all
format long%�޸���ʾ����
[filename,pathname]=uigetfile({'*.txt';'*.xls'},'selectfile','MultiSelect','ON');%���������Ӱ���ļ���ȡ����
cd(pathname)
if ~iscell(filename) %�����ļ� ��ʱfilename����cell����
end
 a=[];
a=importdata(fullfile(pathname,filename));%���浥��txt�ļ�  �����ɽṹ������  ������ʽ�������
wave=a.data;
y=wave(:,2)-1;
t=wave(:,1);
subplot(3,1,1);
plot(t,y);
title('λ��')
xlabel('ʱ��')
ylabel('����')

xlim([t(1) t(end)]);
wavename='morl';
totalscal= length(t);
Fs=1/(t(2)-t(1));
Fc=centfrq(wavename); % С��������Ƶ��
c=2*Fc*totalscal;
scals=c./(1:totalscal);%С���任�߶�
f=scal2frq(scals,wavename,1/Fs); % ���߶�ת��ΪƵ��
cw2=cwt(y,scals,wavename); % ������С��ϵ��
[X,Y] = meshgrid(t,f);%��ͼ
subplot(3,1,2);
mesh(X,Y,abs(cw2));%��ͼ
shading interp
colormap(jet)
view(0,90)
title('ʱƵͼ')
xlabel('ʱ��')
ylabel('Ƶ��')
xlim([t(1) t(end)])
set(gca,'ylim',[0,max(max(Y))])
%set(gca,'YScale','log')
subplot(3,1,3)
[C,h]=contour(t,f,cw2,8,'color','k');%���ֵ��ͼ
%clabel(C,h); %�ӱ�ֵ
xlim([t(1) t(end)])
set(gca,'ylim',[0,max(max(Y))])