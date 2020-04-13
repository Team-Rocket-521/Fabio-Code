%% Final project part 1
% Prepared by John Bernabei and Brittany Scheid

% One of the oldest paradigms of BCI research is motor planning: predicting
% the movement of a limb using recordings from an ensemble of cells involved
% in motor control (usually in primary motor cortex, often called M1).

% This final project involves predicting finger flexion using intracranial EEG (ECoG) in three human
% subjects. The data and problem framing come from the 4th BCI Competition. For the details of the
% problem, experimental protocol, data, and evaluation, please see the original 4th BCI Competition
% documentation (included as separate document). The remainder of the current document discusses
% other aspects of the project relevant to BE521.


%% Start the necessary ieeg.org sessions (0 points)
% Not necessary 
load('final_proj_part1_data.mat')
%% Extract dataglove and ECoG data 
% Dataglove should be (samples x 5) array 
% ECoG should be (samples x channels) array
% Split data into a train and test set (use at least 50% for training)
in=.7*length(train_dg{1});
 traindg1=train_dg{1}(1:in,:)';
 traindg2=train_dg{2}(1:in,:)';
 traindg3=train_dg{3}(1:in,:)';
 testdg1=train_dg{1}(in+1:end,:)';
 testdg2=train_dg{2}(in+1:end,:)';
 testdg3=train_dg{3}(in+1:end,:)';
 trainecog1=train_ecog{1}(1:in,:)';
 trainecog2=train_ecog{2}(1:in,:)';
 trainecog3=train_ecog{3}(1:in,:)';
 testecog1=train_ecog{1}(in+1:end,:)';
 testecog2=train_ecog{2}(in+1:end,:)';
 testecog3=train_ecog{3}(in+1:end,:)';
 min(size(train_ecog{1}))
 min(size(train_ecog{2}))
 min(size(train_ecog{3}))
 Fs=1000;
%% Get Features
% run getWindowedFeats_release function
features1=getWindowedFeats(trainecog1,Fs,100,50);
features2=getWindowedFeats(trainecog2,Fs,100,50);
features3=getWindowedFeats(trainecog3,Fs,100,50);
%% Create R matrix
% run create_R_matrix
R1=create_R_matrix(features1,3,4);
R2=create_R_matrix(features2,3,4);
R3=create_R_matrix(features3,3,4);
%% Train classifiers (8 points)

% Classifier 1: Get angle predictions using optimal linear decoding. That is, 
% calculate the linear filter (i.e. the weights matrix) as defined by 
% Equation 1 for all 5 finger angles.
Y1=downsample(traindg1',50);
Y1=Y1';
Y1(:,1)=[];
Y2=downsample(traindg2',50);
Y2=Y2';
Y2(:,1)=[];
Y3=downsample(traindg3',50);
Y3=Y3';
Y3(:,1)=[];


f1=((R1'*R1)^(-1))*(R1'*Y1');
f2=((R2'*R2)^(-1))*(R2'*Y2');
f3=((R3'*R3)^(-1))*(R3'*Y3');
Yn1=R1*f1;
Yn2=R2*f2;
Yn3=R3*f3;


% Try at least 1 other type of machine learning algorithm, you may choose
% to loop through the fingers and train a separate classifier for angles 
% corresponding to each finger
trainF1=(features1-mean(features1))./std(features1);
trainF2=(features2-mean(features2))./std(features2);
trainF3=(features3-mean(features3))./std(features3);

Mdl1_1=fitcknn(trainF1,Y1(1,:),'Distance','minkowski','NSMethod','exhaustive');
Mdl1_2=fitcknn(trainF1,Y1(2,:),'Distance','minkowski','NSMethod','exhaustive');
Mdl1_3=fitcknn(trainF1,Y1(3,:),'Distance','minkowski','NSMethod','exhaustive');
Mdl1_4=fitcknn(trainF1,Y1(4,:),'Distance','minkowski','NSMethod','exhaustive');
Mdl1_5=fitcknn(trainF1,Y1(5,:),'Distance','minkowski','NSMethod','exhaustive');

Mdl2_1=fitcknn(trainF2,Y2(1,:),'Distance','minkowski','NSMethod','exhaustive');
Mdl2_2=fitcknn(trainF2,Y2(2,:),'Distance','minkowski','NSMethod','exhaustive');
Mdl2_3=fitcknn(trainF2,Y2(3,:),'Distance','minkowski','NSMethod','exhaustive');
Mdl2_4=fitcknn(trainF2,Y2(4,:),'Distance','minkowski','NSMethod','exhaustive');
Mdl2_5=fitcknn(trainF2,Y2(5,:),'Distance','minkowski','NSMethod','exhaustive');

Mdl3_1=fitcknn(trainF3,Y3(1,:),'Distance','minkowski','NSMethod','exhaustive');
Mdl3_2=fitcknn(trainF3,Y3(2,:),'Distance','minkowski','NSMethod','exhaustive');
Mdl3_3=fitcknn(trainF3,Y3(3,:),'Distance','minkowski','NSMethod','exhaustive');
Mdl3_4=fitcknn(trainF3,Y3(4,:),'Distance','minkowski','NSMethod','exhaustive');
Mdl3_5=fitcknn(trainF3,Y3(5,:),'Distance','minkowski','NSMethod','exhaustive');

MLpredict1=zeros(5,1799);
MLpredict2=zeros(5,1799);
MLpredict3=zeros(5,1799);

MLpredict1(1,:)=predict(Mdl1_1,features1n);
MLpredict1(2,:)=predict(Mdl1_2,features1n);
MLpredict1(3,:)=predict(Mdl1_3,features1n);
MLpredict1(4,:)=predict(Mdl1_4,features1n);
MLpredict1(5,:)=predict(Mdl1_5,features1n);

MLpredict2(1,:)=predict(Mdl2_1,features2n);
MLpredict2(2,:)=predict(Mdl2_2,features2n);
MLpredict2(3,:)=predict(Mdl2_3,features2n);
MLpredict2(4,:)=predict(Mdl2_4,features2n);
MLpredict2(5,:)=predict(Mdl2_5,features2n);

MLpredict3(1,:)=predict(Mdl3_1,features3n);
MLpredict3(2,:)=predict(Mdl3_2,features3n);
MLpredict3(3,:)=predict(Mdl3_3,features3n);
MLpredict3(4,:)=predict(Mdl3_4,features3n);
MLpredict3(5,:)=predict(Mdl3_5,features3n);

%% Correlate data to get test accuracy and make figures (2 point)

% Calculate accuracy by correlating predicted and actual angles for each
% finger separately. Hint: You will want to use zohinterp to ensure both 
% vectors are the same length.

Y4=downsample(testdg1',50);
Y4=Y4';
Y4(:,1)=[];
Y5=downsample(testdg2',50);
Y5=Y5';
Y5(:,1)=[];
Y6=downsample(testdg3',50);
Y6=Y6';
Y6(:,1)=[];

F1_1=corr(Y4(1,:)',Yn1(:,1));
F1_2=corr(Y4(2,:)',Yn1(:,2));
F1_3=corr(Y4(3,:)',Yn1(:,3));
F1_4=corr(Y4(4,:)',Yn1(:,4));
F1_5=corr(Y4(5,:)',Yn1(:,5));

F2_1=corr(Y5(1,:)',Yn2(:,1));
F2_2=corr(Y5(2,:)',Yn2(:,2));
F2_3=corr(Y5(3,:)',Yn2(:,3));
F2_4=corr(Y5(4,:)',Yn2(:,4));
F2_5=corr(Y5(5,:)',Yn2(:,5));

F3_1=corr(Y6(1,:)',Yn3(:,1));
F3_2=corr(Y6(2,:)',Yn3(:,2));
F3_3=corr(Y6(3,:)',Yn3(:,3));
F3_4=corr(Y6(4,:)',Yn3(:,4));
F3_5=corr(Y6(5,:)',Yn3(:,5));

P1_linear=[F1_1,F1_2,F1_3,F1_4,F1_5];
P2_linear=[F2_1,F2_2,F2_3,F2_4,F2_5];
P3_linear=[F3_1,F3_2,F3_3,F3_4,F3_5];

for i=1:5
    
    P1_knn(i)=corr(MLpredict1(i,:)',Y4(i,:)');
    P2_knn(i)=corr(MLpredict2(i,:)',Y5(i,:)');
    P3_knn(i)=corr(MLpredict3(i,:)',Y6(i,:)');
end