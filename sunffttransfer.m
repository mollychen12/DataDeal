function mymax=sunffttransfer(x,timestep,s)%x 时间序列   s legend   x为行向量
fs=1/timestep;%采样频率
L=length(x);
y = fft(x,L)/L*2;
mag=abs(y);
f = (0:L-1)*fs/L;%频率
% Plot single-sided amplitude spectrum.
figure
plot(f(1:L/2),mag(1:L/2))
tempsave=[];
tempsave=[f(1:L/2)',mag(1:L/2)'];
save([s '频谱图','.txt'],'tempsave','-ascii')
xlabel('频率 (Hz)')
ylabel('幅值')
axis([0.01 100 0 1.5*max(mag(3:L/2))])
legend(s)
%pause(1)
saveas(gcf,[s '频谱图','.emf'])
legend(s)
tempf=[f(10:fix(L/2))',mag(10:fix(L/2))'];%去除0频影响 fix向下取整
[m,n]=max(tempf(:,2));
mymax=tempf(n,1);%最大频率
end



