function mymax=sunffttransfer(x,timestep,s)%x ʱ������   s legend   xΪ������
fs=1/timestep;%����Ƶ��
L=length(x);
y = fft(x,L)/L*2;
mag=abs(y);
f = (0:L-1)*fs/L;%Ƶ��
% Plot single-sided amplitude spectrum.
figure
plot(f(1:L/2),mag(1:L/2))
tempsave=[];
tempsave=[f(1:L/2)',mag(1:L/2)'];
save([s 'Ƶ��ͼ','.txt'],'tempsave','-ascii')
xlabel('Ƶ�� (Hz)')
ylabel('��ֵ')
axis([0.01 100 0 1.5*max(mag(3:L/2))])
legend(s)
%pause(1)
saveas(gcf,[s 'Ƶ��ͼ','.emf'])
legend(s)
tempf=[f(10:fix(L/2))',mag(10:fix(L/2))'];%ȥ��0ƵӰ�� fix����ȡ��
[m,n]=max(tempf(:,2));
mymax=tempf(n,1);%���Ƶ��
end



