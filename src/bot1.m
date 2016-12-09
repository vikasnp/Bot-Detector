%% Train with given samples
given_labels = csvread('labels.csv');
symbols_in_data=[1,1.4142,2,2.2361,2.8284,3,3.1623,3.6056,4,4.1231,4.2426,4.4721,5,5.6569];
trans(1:25,1:25) = 1/25;
%trans=csvread('trans.csv');
%emis = rand(25,14); 
emis=csvread('emission.csv');
finalObsValues1 = csvread('series1.csv');
finalObsValues2 = csvread('series2.csv');
finalObsValues3 = csvread('series3.csv');
bot1Indexes=csvread('indexSeries1.csv');
bot2Indexes=csvread('indexSeries2.csv');
bot3Indexes=csvread('indexSeries3.csv');
 
%% Train on 200 samples to get initial estimates of Trans and Emis matrix
samples_values_bot1 = finalObsValues1(1:41,:);
samples_values_bot2 = finalObsValues2(1:85,:);
samples_values_bot3 = finalObsValues3(1:73,:);
[Trans_200_BOT1,Emis_200_BOT1] = hmmtrain(samples_values_bot1,trans,emis,'SYMBOLS',symbols_in_data,'Maxiterations',100,'Verbose',true);
[Trans_200_BOT2,Emis_200_BOT2] = hmmtrain(samples_values_bot2,trans,emis,'SYMBOLS',symbols_in_data,'Maxiterations',100,'Verbose',true);
[Trans_200_BOT3,Emis_200_BOT3] = hmmtrain(samples_values_bot3,trans,emis,'SYMBOLS',symbols_in_data,'Maxiterations',100,'Verbose',true);
Trans_200_BOT1(Trans_200_BOT1==0)=0.0001;
Trans_200_BOT2(Trans_200_BOT2==0)=0.0001;
Trans_200_BOT3(Trans_200_BOT3==0)=0.0001;
%% Train on full data set now.
 
[Trans_BOT1,Emis_BOT1] = hmmtrain(finalObsValues1,Trans_200_BOT1,Emis_200_BOT1,'SYMBOLS',symbols_in_data,'Maxiterations',100,'Verbose',true);
[Trans_BOT2,Emis_BOT2] = hmmtrain(finalObsValues2,Trans_200_BOT2,Emis_200_BOT2,'SYMBOLS',symbols_in_data,'Maxiterations',100,'Verbose',true);
[Trans_BOT3,Emis_BOT3] = hmmtrain(finalObsValues3,Trans_200_BOT3,Emis_200_BOT3,'SYMBOLS',symbols_in_data,'Maxiterations',100,'Verbose',true);
 
 
%% BOT 1 - DECODE
% Go through rows of bot1 and decode it.
result1 = zeros(size(finalObsValues1,1),1);
for p=1:size(finalObsValues1,1)
    d1=finalObsValues1(p,:);
    PSTATES = hmmdecode(d1,Trans_BOT1,Emis_BOT1,'SYMBOLS',symbols_in_data);
    [prob, label1] = max(PSTATES(:,100));
    result1(p,1)=label1;        
end
 
% Fetch bot1 labels from labels.csv
bot1_label=zeros(602,1);
for q=1:602
    if bot1Indexes(q)<201 % because we have only 200 labels
        bot1_label(q,1) = given_labels(bot1Indexes(q));
    end
end
 
% place it next to given labels sample.
res_bot1 = [bot1_label result1];
csvwrite('fin_bot1.csv',res_bot1);
 
%% BOT2
result2 = zeros(size(finalObsValues2,1),1);
for p=1:size(finalObsValues2,1)
    d2=finalObsValues2(p,:);
    PSTATES2 = hmmdecode(d2,Trans_BOT2,Emis_BOT2,'SYMBOLS',symbols_in_data);
    [prob, label2] = max(PSTATES2(:,100));
    result2(p,1)=label2;%result has the labels we computed
end
 
% Fetch bot2 labels from labels.csv
bot2_label=zeros(1214,1);
for q=1:1214
    if bot2Indexes(q)<201 % because we have only 200 labels
        bot2_label(q,1) = given_labels(bot2Indexes(q));
    end
end
 
%place it next to given labels sample.
res_bot2 = [bot2_label result2];
csvwrite('fin_bot2.csv',res_bot2);
 
 
 
%% BOT3
result3 = zeros(size(finalObsValues3,1),1);
for p=1:size(finalObsValues3,1)
    d3=finalObsValues3(p,:);
    PSTATES3 = hmmdecode(d3,Trans_BOT3,Emis_BOT3,'SYMBOLS',symbols_in_data);
    [prob, label3] = max(PSTATES3(:,100));
    result3(p,1)=label3;%result has the labels we computed
end
 
% Fetch bot3 labels from labels.csv
bot3_label=zeros(1184,1);
for q=1:1184
    if bot3Indexes(q)<201 % because we have only 200 labels
        bot3_label(q,1) = given_labels(bot3Indexes(q));
    end
end
 
% place it next to given labels sample.
res_bot3 = [bot3_label result3];
csvwrite('fin_bot3.csv',res_bot3);
 
 
%% Merging final results
a1 = [bot1Indexes result1];
a2 = [bot2Indexes result2];
a3 = [bot3Indexes result3];
final_result = zeros(3000,1);
for t=1:602
    final_result(a1(t,1))= a1(t,2);
end
for t=1:1214
    final_result(a2(t,1))= a2(t,2);
end
for t=1:1184
    final_result(a3(t,1))= a3(t,2);
end
 
csvwrite('final_result.csv',final_result);
m=1:3000;
to_upload = [transpose(m) final_result(1:3000)];
csvwrite('submission.csv',to_upload);
compare_200_samples = [given_labels to_upload(1:200,2)];
csvwrite('compare_200_samples.csv',compare_200_samples);
