clc
close all
clc
src=uigetdir('choose the dir');%ѡ����Ŀ¼
cd(src);%�л�����Ŀ¼
path(path,'C:\Users\Administeator\Desktop\�綴ʵ���һƪ\hotchu');%����Ӻ�������·�� 
path=src;
listing=dir(path);%����һ���ṹ���飬�������ļ���directory_name�µ����ļ��к����ļ���һЩ��Ϣ��Ҫע����ǵ�1������Ԫ�غ͵�2������Ԫ�طֱ��ǡ�.���͡�..������ʾ��ǰĿ¼���ϲ�Ŀ¼��
files={};%����һ��cell
for i=1:length(listing)
    f=listing(i);%fͬ��Ϊһ���ṹ��
    if ~strcmp(f.name,'.') &&~strcmp(f.name,'..')%strcmp�Ƚ��ַ����Ƿ���Ⱥ���  isequl���ڱȽ������Ƿ����
        if f.isdir
            files=[files;fullfile(fullfile(path,f.name))];%fullfill���ɵ�ַ�ַ���  �÷ֺ�ʵ�ֻ��дӶ�ѭ��
        else
            files=[files;fullfile(path,f.name)];%������һ���ļ�����isdir Ϊ0
        end
    end
end
%�õ����ļ�Ŀ¼  
for i=1:length(files)
  
   cd(char(files(i)));%cellת��Ϊchar  �л�����Ŀ¼��ÿ�����ļ�����
   temp=ls('*.txt');
   %ͳ�ƽ��
   fid=fopen('Ƶ�ʼ�ֵͳ�ƽ��.txt','w');
  
   for j=1:size(temp,1)
     close all
     temdata=[];
     temdata=importdata(char(temp(j,:)));
     figure
     plot(temdata.data(:,1),temdata.data(:,2))
     timestep=0.001;
     mymax=sunffttransfer(temdata.data(:,2)',timestep,char(temp(j,:)));
     fprintf(fid,'\r\n %8s \r\n',char(temp(j,:)))
     fprintf(fid,'%8.4f \r\n',mymax); 
   end
   fclose(fid);
end


