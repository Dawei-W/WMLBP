clc;
clear all;
close all;

% load patternMappingriuU4_P8;
load('mapping.mat');
rootpic = 'E:\data\Outex-TC-00012-bmp\';

%—µ¡∑ºØªÆ∑÷
LBPhist = [];
Train_NUM   = 480;    %   000000.ras-000479.ras
tl84_NUM    = 4320;   %   000480.ras-004799.ras
horizon_NUM = 4320;   %   004800.ras-009119.ras
Total_Num   = 9120;


trainTxt_t184 = sprintf('%s000\\train.txt', rootpic);  %t184 —µ¡∑ºØ
testTxt_tl84 = sprintf('%s000\\test.txt', rootpic);  %tl84 ≤‚ ‘ºØ
trainTxt_horizon = sprintf('%s001\\train.txt', rootpic); %horizon —µ¡∑ºØ
testTxt_horizon = sprintf('%s001\\test.txt', rootpic);   %horizon ≤‚ ‘ºØ

[trainIDs_t184, trainClassIDs_t184] = ReadOutexTxt(trainTxt_t184); %inca
[trainIDs_horizon, trainClassIDs_horizon] = ReadOutexTxt(trainTxt_horizon);
[testIDs_tl84, testClassIDs_tl84] = ReadOutexTxt(testTxt_tl84);%tl84
[testIDs_horizon, testClassIDs_horizon] = ReadOutexTxt(testTxt_horizon);%horizon


uper = 1;
lower = 0;
a = lower+(uper-lower).*rand([1 1]);
b = 255;
R1 = 1;
R2 = 2;
R3 = 3;
P=8;
% patternMappingriu2 = getmappingold(P,'riu2');
for n=1:length(a)
    tic
    z=0;
    for i =1:Total_Num
        filename = sprintf('%s\\images\\%06d.ras', rootpic, i-1);
        disp([num2str(n) '.... '  filename ])
        img = im2double(imread(filename));
        img = (img-mean(img(:)))/std(img(:))*20+128;
        if any((testIDs_tl84 == i)|(testIDs_horizon == i))
            Gray = -a(n).*((img)) + b;
        else
            Gray = img;
        end
        [cA,cH,cV,cD]=swt2(Gray,3,'haar');
        cA1 = cA(:,:,1);
        cA2 = cA(:,:,2);
        
        
        thre3 = MTH(cA1,3);
        thre33 = MTH(cA2,3);
        
        
        %%imshow(uint8(wcodemat(cA(:,:,3),256)))%œ‘ æÕº∆¨
        CLBP_SMCH1 = testfangfa(cA1,R1,8,mapping1,thre3);
        CLBP_SMCH2 = testfangfa(cA1,R2,16,mapping2,thre3);
        CLBP_SMCH3 = testfangfa(cA1,R3,24,mapping3,thre3);
        
        CLBP_SMCH11 = testfangfa(cA2,R1,8,mapping1,thre33);
        CLBP_SMCH22 = testfangfa(cA2,R2,16,mapping2,thre33);
        CLBP_SMCH33 = testfangfa(cA2,R3,24,mapping3,thre33);
        
        
        CLBP_SMCH4 = [CLBP_SMCH1,CLBP_SMCH11];
        CLBP_SMCH44 = [CLBP_SMCH2,CLBP_SMCH22];
        CLBP_SMCH444 = [CLBP_SMCH3,CLBP_SMCH33];
        
        hists1(i,:) = CLBP_SMCH4;
        hists2(i,:) = CLBP_SMCH44;
        hists3(i,:) = CLBP_SMCH444;
        hists4(i,:) = [CLBP_SMCH4,CLBP_SMCH44,CLBP_SMCH444];
        
        
    end
    t1=toc;
    %     disp(['the elapsed time ' num2str(toc/Total_Num) ' hours'])
    %     hists4 = [hists1,hists2,hists3];
    %—µ¡∑∑÷¿‡
    linCP_t184_1 = Classifyflk(hists1,trainIDs_t184,trainClassIDs_t184,testIDs_tl84,testClassIDs_tl84); %
    linCP_t184_2 = Classifyflk(hists2,trainIDs_t184,trainClassIDs_t184,testIDs_tl84,testClassIDs_tl84); %
    linCP_t184_3 = Classifyflk(hists3,trainIDs_t184,trainClassIDs_t184,testIDs_tl84,testClassIDs_tl84); %
    linCP_t184_th = Classifyflk(hists4,trainIDs_t184,trainClassIDs_t184,testIDs_tl84,testClassIDs_tl84);
    
    
    linCP1_horizon = Classifyflk(hists1,trainIDs_horizon,trainClassIDs_horizon,testIDs_horizon,testClassIDs_horizon); %
    linCP2_horizon = Classifyflk(hists2,trainIDs_horizon,trainClassIDs_horizon,testIDs_horizon,testClassIDs_horizon); %
    linCP3_horizon = Classifyflk(hists3,trainIDs_horizon,trainClassIDs_horizon,testIDs_horizon,testClassIDs_horizon); %
    linCP4_horizon = Classifyflk(hists4,trainIDs_horizon,trainClassIDs_horizon,testIDs_horizon,testClassIDs_horizon); %
    
    
    
end

for n=1:length(a)
    tic
    z=0;
    for i =1:Total_Num
        filename = sprintf('%s\\images\\%06d.ras', rootpic, i-1);
        disp([num2str(n) '.... '  filename ])
        img = im2double(imread(filename));
        img = (img-mean(img(:)))/std(img(:))*20+128;
        if any((testIDs_tl84 == i)|(testIDs_horizon == i))
%             Gray = -a(n).*((img)) + b;
            Gray = -sqrt(img) + b;
        else
            Gray = img;
        end
        [cA,cH,cV,cD]=swt2(Gray,3,'haar');
        cA1 = cA(:,:,1);
        cA2 = cA(:,:,2);
        
        
        thre3 = MTH(cA1,3);
        thre33 = MTH(cA2,3);
        
        
        %%imshow(uint8(wcodemat(cA(:,:,3),256)))%œ‘ æÕº∆¨
        CLBP_SMCH1 = testfangfa(cA1,R1,8,mapping1,thre3);
        CLBP_SMCH2 = testfangfa(cA1,R2,16,mapping2,thre3);
        CLBP_SMCH3 = testfangfa(cA1,R3,24,mapping3,thre3);
        
        CLBP_SMCH11 = testfangfa(cA2,R1,8,mapping1,thre33);
        CLBP_SMCH22 = testfangfa(cA2,R2,16,mapping2,thre33);
        CLBP_SMCH33 = testfangfa(cA2,R3,24,mapping3,thre33);
        
        
        CLBP_SMCH4 = [CLBP_SMCH1,CLBP_SMCH11];
        CLBP_SMCH44 = [CLBP_SMCH2,CLBP_SMCH22];
        CLBP_SMCH444 = [CLBP_SMCH3,CLBP_SMCH33];
        
        hists1(i,:) = CLBP_SMCH4;
        hists2(i,:) = CLBP_SMCH44;
        hists3(i,:) = CLBP_SMCH444;
        hists4(i,:) = [CLBP_SMCH4,CLBP_SMCH44,CLBP_SMCH444];
        
        
    end
    t2=toc;
    %     disp(['the elapsed time ' num2str(toc/Total_Num) ' hours'])
    %     hists4 = [hists1,hists2,hists3];
    %—µ¡∑∑÷¿‡
    nolinCP_t184_1 = Classifyflk(hists1,trainIDs_t184,trainClassIDs_t184,testIDs_tl84,testClassIDs_tl84); %
    nolinCP_t184_2 = Classifyflk(hists2,trainIDs_t184,trainClassIDs_t184,testIDs_tl84,testClassIDs_tl84); %
    nolinCP_t184_3 = Classifyflk(hists3,trainIDs_t184,trainClassIDs_t184,testIDs_tl84,testClassIDs_tl84); %
    nolinCP_t184_th = Classifyflk(hists4,trainIDs_t184,trainClassIDs_t184,testIDs_tl84,testClassIDs_tl84);
    
    
    nolinCP1_horizon = Classifyflk(hists1,trainIDs_horizon,trainClassIDs_horizon,testIDs_horizon,testClassIDs_horizon); %
    nolinCP2_horizon = Classifyflk(hists2,trainIDs_horizon,trainClassIDs_horizon,testIDs_horizon,testClassIDs_horizon); %
    nolinCP3_horizon = Classifyflk(hists3,trainIDs_horizon,trainClassIDs_horizon,testIDs_horizon,testClassIDs_horizon); %
    nolinCP4_horizon = Classifyflk(hists4,trainIDs_horizon,trainClassIDs_horizon,testIDs_horizon,testClassIDs_horizon); %
    
    
    
end

