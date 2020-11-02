% PMSM parameters
Rs = 7.1; %Stator resistance
Ld = 30e-3; %d-axis inductance
Lq = 30e-3; %q-axis inductance
phi_pm = 0.2; %Permanent magnet flux
polePairs = 3; %Pole pairs
J = 5.8e-4; %Inertia
B = 0.002; %Viscous coefficient
Wbase = 1000*pi/30; %Base speed
Wmax = 5000*pi/30; %Max. speed
Prated = 2000; %Rated power
Trated = 3; %Rated torque
% Controller parameters
Vdc = 400;
% Current PI parameters
Fs = 10e3; %Inverter's Switching frequency 10[kHz]
alpha_i = 2*pi*Fs/10; %Parameter used for Kp & Ki
Kpc_d = alpha_i*Ld; %Prop.constant of d-axis current reg.
Kic_d = alpha_i*Rs; %Int. constant of d-axis current reg.
Kpc_q = alpha_i*Lq; %Prop. constant of q-axis current reg.
Kic_q = alpha_i*Rs; %Int. constant of q-axis current reg.
% Speed PI parameters
alpha_w = alpha_i/10; %Parameter used for Kp & Ki
Kpw = alpha_w*J; %Prop. constant of speed reg.
Kiw = alpha_w*B; %Int. constant of speed reg.
Tmax = 5; %Max torque
Ts = 1/Fs; %Inverter's Switching period
Tss = Ts/10; % Simulation sampling time
Tsc = Ts ; % Current Loop Sampling Time
Tssp = Ts*10; % Speed Loop Sampling Time


