%  �������ܣ�����������ϵͳ��չKalman�˲�����
%  ״̬������X(k+1)=0.5X(k)+2.5X(k)/(1+X(k)^2)+8cos(1.2k) +w(k)
%  �۲ⷽ�̣�Z��k��=X(k)^2/20 +v(k)
function EKF_for_One_Div_UnLine_System
T=50;%��ʱ��
Q=0.1;%Q��ֵ�ı䣬�۲첻ͬQֵʱ�˲����
R=1;%��������
%������������
w=sqrt(Q)*randn(1,T);
%�����۲�����
v=sqrt(R)*randn(1,T);
%״̬����
x=zeros(1,T);
x(1)=0.1;
y=zeros(1,T);
y(1)=x(1)^2/20+v(1);
for k=2:T
    x(k)=0.5*x(k-1)+2.5*x(k-1)/(1+x(k-1)^2)+8*cos(1.2*k)+w(k-1);
    y(k)=x(k)^2/20+v(k);
end
%EKF�˲��㷨
Xekf=zeros(1,T);
Xekf(1)=x(1);
Yekf=zeros(1,T);
Yekf(1)=y(1);
P0=eye(1);
for k=2:T
    %״̬Ԥ��
    Xn=0.5*Xekf(k-1)+2.5*Xekf(k-1)/(1+Xekf(k-1)^2)+8*cos(1.2*k);
    %�۲�Ԥ��
    Zn=Xn^2/20;
    %��״̬����F
    F=0.5+2.5 *(1-Xn^2)/(1+Xn^2)^2;
    %��۲����
    H=Xn/10;
    %Э����Ԥ��
    P=F*P0*F'+Q;
    %�󿨶�������     
    K=P*H'*inv(H*P*H'+R);
    %״̬����
    Xekf(k)=Xn+K*(y(k)-Zn);
    %Э���������
    P0=(eye(1)-K*H)*P;
end
%������
Xstd=zeros(1,T);
for k=1:T
    Xstd(k)=abs( Xekf(k)-x(k) );
end
%��ͼ
figure
hold on;box on;
plot(x,'-ko','MarkerFace','g');
plot(Xekf,'-ks','MarkerFace','b');
%������
figure
hold on;box on;
plot(Xstd,'-ko','MarkerFace','g');