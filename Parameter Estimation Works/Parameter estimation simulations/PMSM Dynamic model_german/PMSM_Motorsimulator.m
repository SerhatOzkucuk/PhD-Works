clear all;
clc;
close all;

%=======Maschinenspezifikationen=============

Rs=1.2;           %Statorstrangwiederstand [Ohm]  1.2
L_q=12.5e-3;      %Induktivität der d-Axe [mH]  12.5e-3
L_d=5.7e-3;       %Induktivität der q-Axe [mH]   5.7e-3
Phi_pm=175e-3;    % Wb-turns Magnetischer FLuss des PM (Alternativ: 0,175 0,123 wb)
Zp=2;             %Anzahl Polpaare 2

B=0;              %Viskose Dämpfung [Ns/m]  0
T_Load=10;          %Lastdrehmoment  [Nm]   10
J=0.0001584;        %Rotorträgheit  [kgm^2]   1.58e-4


%=======Stromwerte===================
U=230;          %Spannungsamplite [V] 230-1530
f=60;             %Spannungsfrequenz [Hz]  50-60




% === Simulation starten ===
  sim('PMSM_Motor');

    
%====Postprocessing=======================================  
a= figure(1); hold on;
set(a, 'Position', [300, 40, 900, 900]);
groesse=11;

subplot(4,1,1);
hp=plot(w_m.time, [w_m.data, w_e.data]); grid on; hold on;

NameArray = {'LineStyle'};
ValueArray = {'-','--'}';

set(hp,NameArray,ValueArray);

set(gca,'FontSize',groesse);

xlabel('Time (s)'); ylabel('Drehzahl w_{m}  (rpm)','FontSize',groesse);
xlim([0 1]); ylim([0 4000]); grid on;hold on;
h_legend=legend('w_m [rpm]', 'w_e [rpm]'); set(h_legend, 'FontSize',groesse);
%h_legend=legend('Current iA [A], Current iA_k [A]'); set(h_legend, 'FontSize',groesse);



subplot(4,1,2);
hp=plot(Te.time,Te.data); grid on;

NameArray = {'LineStyle'};
ValueArray = {'-'}';
set(hp,NameArray,ValueArray);

xlabel('Time (s)'); ylabel('Drehmoment T_{e} (Nm)','FontSize',groesse);
xlim([0 1]); ylim([-30 30]);

subplot(4,1,3);
hp=plot(u_dq.time,u_dq.data); grid on;
%axis ([0.15 01504 -10 150]);

NameArray = {'LineStyle'};
ValueArray = {'-','-.'}';
set(hp,NameArray,ValueArray);

xlabel('Time (s)'); ylabel('DQ Spannung u_{dq} (V)','FontSize',groesse);
xlim([0 0.25]); ylim([-250 250]);
h_legend=legend('u_d [V]', 'u_q [V]'); set(h_legend, 'FontSize',groesse);


subplot(4,1,4);
hp=plot(i_dq.time,i_dq.data); grid on;
%axis ([0.15 01504 -10 150]);

NameArray = {'LineStyle'};
ValueArray = {'-','--'}';
set(hp,NameArray,ValueArray);

xlabel('Time (s)'); ylabel('DQ Strom i_{dq} (A)','FontSize',groesse);
h_legend=legend('i_d [A]', 'i_q [A]'); set(h_legend, 'FontSize',groesse);
xlim([0 0.25]); ylim([-100 100]);


a= figure(2); hold on;
set(a, 'Position', [300, 40, 900, 900]);

subplot(1,1,1);
hp=plot(i_uvw.time, i_uvw.data); grid on; hold on;

set(hp,'LineStyle','-','Linewidth',2);

xlabel('Time (s)'); ylabel('Ströme uvw (A)','FontSize',groesse);
h_legend=legend('i_u [A]', 'i_v [A]', 'i_w [A]'); set(h_legend, 'FontSize',groesse);
xlim([0 0.25]); ylim([-150 150]);



disp('====> Simulation komplett');





%{
Rs=1.2;  %Ohm
Rc=416;  %Ohm

L_q=12.5e-3; %mH
L_d=5.7e-3; %mH
lambda_pm=123e-3; %mWeber/turns
P=2; %Anzahl Pole

U=230;  %Spannungsamplite
f=60;    %Frequenz

B=0;           %Viskose Reibung
T_L=0;        %Lastdrehmoment
T_d=0;         %
J=0.0001584;   %Rotorträgheit

%}

%{
subplot(3,1,3);
hp=plot(w_r.time,w_r.data); grid on;
%axis ([0.15 01504 -10 150]);
set(hp,'LineStyle','-','LineWidth',2);
set(gca,'FontSize',groesse);

xlabel('Time (s)'); ylabel('Drehzahl w_r (rad/s)','FontSize',groesse);
xlim([0 1]); ylim([-600 600]);

%}

