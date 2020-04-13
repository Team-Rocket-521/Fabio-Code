function [all_feats]=getWindowedFeats_release(raw_data, fs, window_length, window_overlap)
    %
    % getWindowedFeats_release.m
    %
    % Instructions: Write a function which processes data through the steps
    %               of filtering, feature calculation, creation of R matrix
    %               and returns features.
    %
    %               Points will be awarded for completing each step
    %               appropriately (note that if one of the functions you call
    %               within this script returns a bad output you won't be double
    %               penalized)
    %
    %               Note that you will need to run the filter_data and
    %               get_features functions within this script. We also 
    %               recommend applying the create_R_matrix function here
    %               too.
    %
    % Inputs:   raw_data:       The raw data for all patients
    %           fs:             The raw sampling frequency
    %           window_length:  The length of window
    %           window_overlap: The overlap in window
    %
    % Output:   all_feats:      All calculated features
    %
%% Your code here (3 points)

% First, filter the raw data

y=filter_data(raw_data);

% Then, loop through sliding windows
WL=window_length/1000*fs; 
WO=window_overlap/1000*fs;
times=(length(y)/WO)-1;
u=size(y);
u=u(1);
X=zeros(u,4,times);
F=zeros(times,u*4);
for w=1:u
    for i=1:times
        data=y(w,(WO*(i-1)+1):(WO*(i-1)+WL));
        % Within loop calculate feature for each segment (call get_features)
        X(w,:,i)=get_features(data,1000);
    end
% Finally, return feature matrix

end
for i=1:times
    row=reshape(X(:,:,i),[1,u*4]);
    F(i,:)=row;
end
[all_feats]=F;

    