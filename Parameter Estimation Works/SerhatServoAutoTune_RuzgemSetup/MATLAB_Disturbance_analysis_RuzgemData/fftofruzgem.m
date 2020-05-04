%%
signal =(ScopeData.signals(2).values);
N = length(signal);
fs = 1000; % 1000 samples per second
fnyquist = fs/2; %Nyquist frequency

%fax_bins = [0 : N-1]; %N is the number of samples in the signal
%plot(fax_bins, abs(fft(signal)))
%xlabel('Frequency (Bins)')
%ylabel('Magnitude');
%title('Double-sided Magnitude spectrum (bins)');
%axis tight

%X_mags = abs(fft(signal));
%fax_bins = [0 : N-1]; %frequency axis in bins
%N_2 = ceil(N/2);
%plot(fax_bins(1:N_2), X_mags(1:N_2))
%xlabel('Frequency (Bins)')
%ylabel('Magnitude');
%title('Single-sided Magnitude spectrum (bins)');
%axis tight

X_mags = abs(fft(signal));
bin_vals = [0 : N-1];
fax_Hz = bin_vals*fs/(N);
N_2 = ceil(N/2);
plot(fax_Hz(1:N_2), X_mags(1:N_2))
xlabel('Frequency (Hz)')
ylabel('Magnitude');
title('Single-sided Magnitude spectrum (Hertz)');
axis tight

%%
fax_norm = (bin_vals*fs/N)/fnyquist; % same as bin_vals/(N/2)
plot(fax_norm(1:N_2), X_mags(1:N_2))
xlabel({'Frequency (Normalised to Nyquist Frequency. ' ...
    '1=Nyquist frequency)'})
ylabel('Magnitude');
title('Single-sided Magnitude spectrum (Normalised to Nyquist)');
axis tight

%%




%%
x=fft(ScopeData.signals(1).values);
plot(abs(x));
box on;
grid on;
%%
x=fft(ScopeData.signals(2).values);
plot(abs(x));
box on;
grid on;
%%
x=fft(ScopeData.signals(3).values);
plot(abs(x));
box on;
grid on;
%%
x=fft(ScopeData.signals(4).values);
plot(abs(x));
box on;
grid on;
%%
x=fft(ScopeData.signals(5).values);
plot(abs(x));
box on;
grid on;
%%
x=fft(ScopeData.signals(6).values);
plot(abs(x));
box on;
grid on;
