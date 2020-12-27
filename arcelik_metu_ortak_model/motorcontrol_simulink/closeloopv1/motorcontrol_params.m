%% Create enumerated types
if exist('ControllerMode','class')~=8
    Simulink.defineIntEnumType('ControllerMode',...
        {'TorqueControl','SpeedControl','PositionControl'},[0;1;2])
end
if exist('ControlMode','class')~=8
    Simulink.defineIntEnumType('ControlMode',...
        {'Torque','Speed','Position'},[0;1;2])
end
if exist('TuneMode','class')~=8
    Simulink.defineIntEnumType('TuneMode',...
        {'TuneStep1','TuneStep2','TuneStep3','TuneOff'},[0;1;2;3])
end

%% Set data type for controller & code-gen
dataType = 'single';            % Floating point code-generation, Fixed point is not supported.
%% Set PWM Switching frequency
PWM_frequency 	= 20e3;    %Hz          // converter s/w freq
T_pwm           = 1/PWM_frequency;  %s  // PWM switching time period
%% Set Sample Times
Ts.info = 'Sampling times %sec';
Ts.pwm          	= T_pwm;        %sec        // simulation time step for controller
Ts.simulink     = T_pwm/2;      %sec        // simulation time step for model simulation
Ts.motor        = T_pwm/2;      %Sec        // Simulation sample time
Ts.inverter     = T_pwm/2;      %sec        // simulation time step for average value inverter
Ts.speed        = 10*Ts.pwm;        %Sec        // Sample time for speed controller
%% PMSM parameters
pmsm.model  = 'Teknic-2310P';%              // Manufacturer Model Number
pmsm.sn     = '003';         %           // Manufacturer Model Number
pmsm.p      = 4;                %           // Pole Pairs for the motor
pmsm.Rs     = 0.36;             %Ohm        // Stator Resistor
pmsm.Ld     = 0.2e-3;           %H          // D-axis inductance value
pmsm.Lq     = 0.2e-3;           %H          // Q-axis inductance value
pmsm.J      = 7.061551833333e-6;%Kg-m2      // Inertia in SI units
pmsm.B      = 2.636875217824e-6;%Kg-m2/s    // Friction Co-efficient
pmsm.Ke     = 4.64;             %Bemf Const	// Vline_peak/krpm
pmsm.Kt     = 0.274;            %Nm/A       // Torque constant
pmsm.I_rated= 7.1;              %A      	// Rated current (phase-peak)
pmsm.N_max  = 6000;             %rpm        // Max speed
pmsm.PositionOffset = 0.17;	%PU position// Position Offset
pmsm.QEPSlits       = 1000;     %           // QEP Encoder Slits
pmsm.FluxPM     = (pmsm.Ke)/(sqrt(3)*2*pi*1000*pmsm.p/60); %PM flux computed from Ke
pmsm.T_rated    = (3/2)*pmsm.p*pmsm.FluxPM*pmsm.I_rated;   %Get T_rated from I_rated
pmsm.N_base = 4107;
%% Inverter Parameters
inverter.V_dc          = 24;       				%V      // DC Link Voltage of the Inverter
%Note: inverter.I_max = 1.65V/(Rshunt*10V/V) for 3.3V ADC with offset of 1.65V
%This is modified to match 3V ADC with 1.65V offset value for %LaunchXL-F28379D
inverter.I_max         = 23.5714*((3-1.65)/1.65);  %Amps   // Max current that can be measured by 3.0V ADC
inverter.I_trip        = 10;       				%Amps   // Max current for trip
inverter.Rds_on        = 2e-3;     				%Ohms   // Rds ON for BoostXL-DRV8305
inverter.Rshunt        = 0.007;    				%Ohms   // Rshunt for BoostXL-DRV8305
inverter.MaxADCCnt     = 4095;     				%Counts // ADC Counts Max Value
inverter.CtSensAOffset = 2295;        			%Counts // ADC Offset for phase-A
inverter.CtSensBOffset = 2286;        			%Counts // ADC Offset for phase-B
inverter.ADCGain       = 1;                     %       // ADC Gain factor scaled by SPI
inverter.EnableLogic   = 1;    					% 		//Active high for DRV8305 enable pin (EN_GATE)
inverter.invertingAmp  = 1;
inverter.R_board        = inverter.Rds_on + inverter.Rshunt/3;  %Ohms
inverter.ADC_Correction = (3.0 - 1.5)/(3.0 - 1.65);     % ADC Gain correction for 3.0V ADC
inverter.I_max = (inverter.I_max*inverter.ADC_Correction)/inverter.ADCGain;

%% Controller Parameters
PI_params.alpha_i = 2*pi*PWM_frequency/10;
PI_params.alpha_w = PI_params.alpha_i/10;
PI_params.Kp_speed = PI_params.alpha_w * pmsm.J*6;
PI_params.Ki_speed = PI_params.alpha_w * pmsm.B*100;
PI_params.Kp_current = PI_params.alpha_i * pmsm.Ld;
PI_params.Ki_current = PI_params.alpha_i * pmsm.Rs;
PI_params.delay_Currents    = int32(Ts.pwm/Ts.simulink);
PI_params.delay_Position    = int32(Ts.pwm/Ts.simulink);
PI_params.delay_Speed       = int32(Ts.speed/Ts.simulink);
PI_params.delay_Speed1      = (0.02 + 0.5*Ts.pwm)/Ts.speed;

