clc
close all
clc
src=uigetdir('choose the dir');%选择工作目录
cd(src);%切换工作目录
path(path,'C:\Users\Administeator\Desktop\风洞实验第一篇\hotchu');%添加子函数调用路径 
path=src;
listing=dir(path);%返回一个结构数组，包含了文件夹directory_name下的子文件夹和子文件的一些信息，要注意的是第1个数组元素和第2个数组元素分别是’.’和’..’，表示当前目录和上层目录。
files={};%定义一个cell
for i=1:length(listing)
    f=listing(i);%f同样为一个结构体
    if ~strcmp(f.name,'.') &&~strcmp(f.name,'..')%strcmp比较字符串是否相等函数  isequl用于比较数组是否相等
        if f.isdir
            files=[files;fullfile(fullfile(path,f.name))];%fullfill构成地址字符串  用分号实现换行从而循环
        else
            files=[files;fullfile(path,f.name)];%若无下一层文件夹则isdir 为0
        end
    end
end
%得到子文件目录  
for i=1:length(files)
  
   cd(char(files(i)));%cell转化为char  切换工作目录到每个子文件夹下
   temp=ls('*.txt');
   %统计结果
   fid=fopen('频率极值统计结果.txt','w');
  
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


