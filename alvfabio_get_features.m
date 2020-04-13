function [features] = get_features(clean_data,fs)
    %
    % get_features_release.m
    %
    % Instructions: Write a function to calculate features.
    %               Please create 4 OR MORE different features for each channel.
    %               Some of these features can be of the same type (for example, 
    %               power in different frequency bands, etc) but you should
    %               have at least 2 different types of features as well
    %               (Such as frequency dependent, signal morphology, etc.)
    %               Feel free to use features you have seen before in this
    %               class, features that have been used in the literature
    %               for similar problems, or design your own!
    %
    % Input:    clean_data: (samples x channels)
    %           fs:         sampling frequency
    %
    % Output:   features:   (1 x (channels*features))
    % 
%% Your code here (8 points)
% Line-Length
u=size(clean_data);
u=u(1);
features=zeros(u,4);
for i= 1:u
    LLFn= @(x) sum(abs(diff(x)));
    features(i,1)=LLFn(clean_data(i,:));
    PTP= @(x) abs(max(x)-min(x));
    features(i,2)=PTP(clean_data(i,:));
    v=ones(1,length(clean_data(i,:)));
    P1=sum(conv(clean_data(i,:),v));
    features(i,3)=P1;
    features(i,4)=mean(mean(abs(spectrogram(clean_data(i,:)))));
end

