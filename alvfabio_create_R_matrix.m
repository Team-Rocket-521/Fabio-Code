function [R]=create_R_matrix(features, N_wind,numfeats)
    %
    % get_features_release.m
    %
    % Instructions: Write a function to calculate R matrix.             
    %
    % Input:    features:   (samples x (channels*features))
    %           N_wind:     Number of windows to use
    %
    % Output:   R:          (samples x (N_wind*channels*features))
    % 
%% Your code here (5 points)
Y=N_wind-1;
M=length(features);

q=min(size(features))/numfeats;
features=[features(1:Y,:);features];
R1=ones(M,1);
I=0;
R2=zeros(M,q*numfeats*N_wind);
features(1,1:4:12);

[R]=[R1,R2];
T=[];
for i=1:M
    T=[];
    for ii=1:q
        for iii=1:N_wind
            T=[T,features(iii+(i-1),ii:q:end)];
        end
    end
    R2(i,:)=T;
end
[R]=[R1,R2];
end