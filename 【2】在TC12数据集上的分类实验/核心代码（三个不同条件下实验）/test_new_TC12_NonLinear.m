clc;
clear all;
close all;
load('mapping.mat');
rootpic = 'E:\data\Outex-TC-00012';

%ѵ��������
LBPhist = [];
Train_NUM   = 480;    %   000000.ras-000479.ras
tl84_NUM    = 4320;   %   000480.ras-004799.ras
horizon_NUM = 4320;   %   004800.ras-009119.ras
Total_Num   = 9120;

trainTxt_t184 = sprintf('%s000\\train.txt', rootpic);  %t184 ѵ����
testTxt_tl84 = sprintf('%s000\\test.txt', rootpic);  %tl84 ���Լ�
trainTxt_horizon = sprintf('%s001\\train.txt', rootpic); %horizon ѵ����
testTxt_horizon = sprintf('%s001\\test.txt', rootpic);   %horizon ���Լ�

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
    for i =1:Total_Num
        filename = sprintf('%s\\images\\%06d.ras', rootpic, i-1);
        display([num2str(n) '.... '  filename ])
        img = im2double(imread(filename));
        img = (img-mean(img(:)))/std(img(:))*20+128;
        if any((testIDs_tl84 == i)|(testIDs_horizon == i))
            Gray = -sqrt(img) + b;
%             Gray = -a(n).*((img)) + b;
        else
            Gray = img;
        end
        [cA,cH,cV,cD]=swt2(Gray,3,'haar');
             cA1 = cA(:,:,1);
            cA2 = cA(:,:,2);
            cA3 = cA(:,:,3);
            
            thre1 = MTH(cA1,1);
%             thre2 = MTH(cA1,2);
%             thre3 = MTH(cA1,3);
%             thre4 = MTH(cA1,4);
%             thre5 = MTH(cA1,5);
%             thre6 = MTH(cA1,6);
%             thre7 = MTH(cA1,7);
            thre11 = MTH(cA2,1);
%             thre22 = MTH(cA2,2);
%             thre33 = MTH(cA2,3);
%             thre44 = MTH(cA2,4);
%             thre55 = MTH(cA2,5);
%             thre66 = MTH(cA2,6);
%             thre77 = MTH(cA2,7);

         %%imshow(uint8(wcodemat(cA(:,:,3),256)))%��ʾͼƬ
            CLBP_SMCH1 = testfangfa(cA1,R1,8,mapping1,thre1);
            CLBP_SMCH2 = testfangfa(cA1,R2,16,mapping2,thre1);
            CLBP_SMCH3 = testfangfa(cA1,R3,24,mapping3,thre1);
            
            CLBP_SMCH11 = testfangfa(cA2,R1,8,mapping1,thre11);
            CLBP_SMCH22 = testfangfa(cA2,R2,16,mapping2,thre11);
            CLBP_SMCH33 = testfangfa(cA2,R3,24,mapping3,thre11);
            
            
            CLBP_SMCH4 = [CLBP_SMCH1,CLBP_SMCH11];
            CLBP_SMCH44 = [CLBP_SMCH2,CLBP_SMCH22];
            CLBP_SMCH444 = [CLBP_SMCH3,CLBP_SMCH33];
            
            hists1(i,:) = CLBP_SMCH4;
            hists2(i,:) = CLBP_SMCH44;
            hists3(i,:) = CLBP_SMCH444;
            hists4(i,:) = [CLBP_SMCH4,CLBP_SMCH44,CLBP_SMCH444];
%             
%             hists1(i,:) = CLBP_SMCH1;
%             hists2(i,:) = CLBP_SMCH2;
%             hists3(i,:) = CLBP_SMCH3;
%             hists4(i,:) = [CLBP_SMCH1,CLBP_SMCH2,CLBP_SMCH3];
    end

    disp(['the elapsed time ' num2str(toc/Total_Num) ' hours'])
    
        
    hists4 = [hists1,hists2,hists3];
        
    %ѵ������
    CP_t184_1 = Classifyflk(hists1,trainIDs_t184,trainClassIDs_t184,testIDs_tl84,testClassIDs_tl84); %
    CP_t184_2 = Classifyflk(hists2,trainIDs_t184,trainClassIDs_t184,testIDs_tl84,testClassIDs_tl84); %
    CP_t184_3 = Classifyflk(hists3,trainIDs_t184,trainClassIDs_t184,testIDs_tl84,testClassIDs_tl84); %
    CP_t184_th = Classifyflk(hists4,trainIDs_t184,trainClassIDs_t184,testIDs_tl84,testClassIDs_tl84);
    
    
    CP1_horizon = Classifyflk(hists1,trainIDs_horizon,trainClassIDs_horizon,testIDs_horizon,testClassIDs_horizon); %
    CP2_horizon = Classifyflk(hists2,trainIDs_horizon,trainClassIDs_horizon,testIDs_horizon,testClassIDs_horizon); %
    CP3_horizon = Classifyflk(hists3,trainIDs_horizon,trainClassIDs_horizon,testIDs_horizon,testClassIDs_horizon); %
    CP4_horizon = Classifyflk(hists4,trainIDs_horizon,trainClassIDs_horizon,testIDs_horizon,testClassIDs_horizon); %
    
    
end


