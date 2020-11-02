%% Servo driveline transmission and fault math model
t=0:1:360;       %time
t_0=100;            %time of fault
tetha_m=0:1:360;    %motor gear position angle
r_m=2;              %motor radius
tetha_l=0:1/5:360/5;     %load gear position angle
r_l=10;              %load radius   

subplot(2,1,1);
plot(tetha_m);

subplot(2,1,2);
plot(tetha_l);

%tetha_m*r_m=tetha_l*r_l

%%

%fault model functions u(t)+beta*dirac(t)
beta=0.5;             %fault indicator
u=heaviside(t);
d=(t==t_0);

y=u+(beta*d);

plot(t,y);

%%

out=y.*tetha_m*r_m;  %fault on the motor gear position

plot(out);


