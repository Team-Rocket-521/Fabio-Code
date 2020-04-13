function clean_data = filter_data_release(raw_eeg)
    %
    % filter_data_release.m
    %
    % Instructions: Write a filter function to clean underlying data.
    %               The filter type and parameters are up to you.
    %               Points will be awarded for reasonable filter type,
    %               parameters, and correct application. Please note there 
    %               are many acceptable answers, but make sure you aren't 
    %               throwing out crucial data or adversely distorting the 
    %               underlying data!
    %
    % Input:    raw_eeg (samples x channels)
    %
    % Output:   clean_data (samples x channels)
    % 
%% Your code here (2 points) 
u=min(size(raw_eeg));
Fs = 1000;  % Sampling Frequency
Fstop1 = .1;             % First Stopband Frequency
Fpass1 = .2;             % First Passband Frequency
Fpass2 = 5;               % Second Passband Frequency
Fstop2 = 7;              % Second Stopband Frequency
Dstop1 = 0.31622776602;   % First Stopband Attenuation
Dpass  = 0.057501127785;  % Passband Ripple
Dstop2 = 0.31622776602;   % Second Stopband Attenuation
dens   = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fstop1 Fpass1 Fpass2 Fstop2]/(Fs/2), [0 1 ...
                          0], [Dstop1 Dpass Dstop2]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);
clean_data=zeros(u,length(raw_eeg));
for i=1:u
    clean_data(i,:)=filter(Hd,raw_eeg(i,:));
end

