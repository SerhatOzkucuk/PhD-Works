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
PWM_frequency 	= 10e3;    %Hz          // converter s/w freq
T_pwm           = 1/PWM_frequency;  %s  // PWM switching time period
%% Set Sample Times
Ts.info = 'Sampling times %sec';
Ts.pwm          	= T_pwm;        %sec        // simulation time step for controller
Ts.simulink     = T_pwm/2;      %sec        // simulation time step for model simulation
Ts.motor        = T_pwm/2;      %Sec        // Simulation sample time
Ts.inverter     = T_pwm/2;      %sec        // simulation time step for average value inverter
Ts.speed        = 10*Ts.pwm;        %Sec        // Sample time for speed controller
%% Siemens 0.75 kW
pmsm.p      = 4;                %           // Pole Pairs for the motor
pmsm.Rs     = 4.2;             %Ohm        // Stator Resistor
pmsm.Ld     = 6e-3;           %H          // D-axis inductance value
pmsm.Lq     = 6e-3;           %H          // Q-axis inductance value
pmsm.J      = 0.897e-4;%Kg-m2      // Inertia in SI units
pmsm.B      = 2e-5;%Kg-m2/s    // Friction Co-efficient
pmsm.Kt     = 0.46;            %Nm/A       // Torque constant
pmsm.N_max  = 5000*pi/30;             %rad/s        // Max speed
pmsm.N_base = 3000*pi/30;
pmsm.FluxPM     = 0.0767; %PM flux computed from Ke
pmsm.PositionOffset = 0.1712;	%PU position// Position Offset
pmsm.QEPSlits       = 2500;
%% Inverter Parameters
inverter.V_dc          = 410;       				%V      // DC Link Voltage of the Inverter
inverter.I_max         = 12;  %Amps   // Max current that can be measured by 3.0V ADC
inverter.MaxADCCnt     = 4096;     				%Counts // ADC Counts Max Value
inverter.CtSensAOffset = 0.5522*inverter.MaxADCCnt;        			%Counts // ADC Offset for phase-A 
inverter.CtSensBOffset = 0.5528*inverter.MaxADCCnt;        			%Counts // ADC Offset for phase-B
inverter.ADCGain       = 1;                     %       // ADC Gain factor scaled by SPI
inverter.EnableLogic   = 1;    					% 		//Active high for DRV8305 enable pin (EN_GATE)
inverter.invertingAmp  = 1;
%% MCU
Target.CPU_frequency        = 200e6;    %(Hz)   // Clock frequency
Target.PWM_frequency        = PWM_frequency;   %// PWM frequency
Target.PWM_Counter_Period   = round(Target.CPU_frequency/Target.PWM_frequency/2);
%% Controller Parameters
PI_params.alpha_i = 2*pi*PWM_frequency/10;
PI_params.alpha_w = PI_params.alpha_i/10;
PI_params.Kp_speed = PI_params.alpha_w * pmsm.J;
PI_params.Ki_speed = PI_params.alpha_w * pmsm.B;
PI_params.Kp_current = PI_params.alpha_i * pmsm.Ld;
PI_params.Ki_current = PI_params.alpha_i * pmsm.Rs;
PI_params.delay_Currents    = int32(Ts.pwm/Ts.simulink);
PI_params.delay_Position    = int32(Ts.pwm/Ts.simulink);
PI_params.delay_Speed       = int32(Ts.speed/Ts.simulink);
PI_params.delay_Speed1      = (0.02 + 0.5*Ts.pwm)/Ts.speed;