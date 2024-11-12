% function DemoCodesOutex
% This demo codes shows the basic operations of CLBP
clear
% images and labels folder
% please download Outex Database from http://www.outex.oulu.fi, then
% extract Outex_TC_00010 to the "rootpic" folder
load('mapping.mat');
rootpic = 'E:\data\Outex-TC-00010\';
% picture number of the database480
picNum = 4320;
trainTxt = sprintf('%s000\\train.txt', rootpic);
testTxt = sprintf('%s000\\test.txt', rootpic);
[trainIDs, trainClassIDs] = ReadOutexTxt(trainTxt);
[testIDs, testClassIDs] = ReadOutexTxt(testTxt);
uper = 1;
lower = 0;
a = lower+(uper-lower).*rand([1 1]);
b = 255;

R1=1;
R2=2;
R3=3;
P=8;

% patternMappingriu2 = getmappingold(P,'riu2');
% patternMappingriu2_2 = getmappingold(16,'riu2');
% patternMappingriu2_3 = getmappingold(24,'riu2');
tic

    for n=1:length(a)
        for i=1:picNum
            filename = sprintf('%s\\images\\%06d.bmp', rootpic, i-1);
            %普通图像
%                 Gray = imread(filename);
%                 Gray = im2double(Gray);
%                 Gray = (Gray-mean(Gray(:)))/std(Gray(:))*20+128;
            disp([ '第' num2str(n) '次,  ','第' num2str(i) '张图'])
            %灰度反转后的图像
            img = imread(filename);
            img = im2double(img);
            img = (img-mean(img(:)))/std(img(:))*20+128; % image normalization, to remove global intensity
            if any(testIDs == i)
                %线性
                Gray = -a(n).*((img)) + b;
                %非线性
%                             Gray = -sqrt(img) + b;
            else
                Gray = img;
            end
            
            [cA,cH,cV,cD]=swt2(Gray,3,'haar');
            cA1 = cA(:,:,1);
            cA2 = cA(:,:,2);
            thre3 = MTH(cA1,3);
            thre33 = MTH(cA2,3);


         %%imshow(uint8(wcodemat(cA(:,:,3),256)))%显示图片
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
        t1  = toc;
%         disp(['读取样本运行时间为 ' num2str(t) ' 秒'])
%         disp(['平均每个样本运行时间为 ' num2str(t/picNum) ' 秒'])
        linSMC_CP1=Classifyflk(hists1,trainIDs,trainClassIDs,testIDs,testClassIDs);
        linSMC_CP2=Classifyflk(hists2,trainIDs,trainClassIDs,testIDs,testClassIDs);
        linSMC_CP3=Classifyflk(hists3,trainIDs,trainClassIDs,testIDs,testClassIDs);
        linSMC_CPth=Classifyflk(hists4,trainIDs,trainClassIDs,testIDs,testClassIDs);

    end

    
 tic
 for n=1:length(a)
        for i=1:picNum
            filename = sprintf('%s\\images\\%06d.bmp', rootpic, i-1);
            %普通图像
%                 Gray = imread(filename);
%                 Gray = im2double(Gray);
%                 Gray = (Gray-mean(Gray(:)))/std(Gray(:))*20+128;
            disp([ '第' num2str(n) '次,  ','第' num2str(i) '张图']);
            %灰度反转后的图像
            img = imread(filename);
            img = im2double(img);
            img = (img-mean(img(:)))/std(img(:))*20+128; % image normalization, to remove global intensity
            if any(testIDs == i)
                %线性
%                 Gray = -a(n).*((img)) + b;
                %非线性
                            Gray = -sqrt(img) + b;
            else
                Gray = img;
            end
            
            [cA,cH,cV,cD]=swt2(Gray,3,'haar');
            cA1 = cA(:,:,1);
            cA2 = cA(:,:,2);
            thre3 = MTH(cA1,3);
            thre33 = MTH(cA2,3);


         %%imshow(uint8(wcodemat(cA(:,:,3),256)))%显示图片
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
        t2  = toc;
%         disp(['读取样本运行时间为 ' num2str(t) ' 秒'])
%         disp(['平均每个样本运行时间为 ' num2str(t/picNum) ' 秒'])
        nolinSMC_CP1=Classifyflk(hists1,trainIDs,trainClassIDs,testIDs,testClassIDs);
        nolinSMC_CP2=Classifyflk(hists2,trainIDs,trainClassIDs,testIDs,testClassIDs);
        nolinSMC_CP3=Classifyflk(hists3,trainIDs,trainClassIDs,testIDs,testClassIDs);
        nolinSMC_CPth=Classifyflk(hists4,trainIDs,trainClassIDs,testIDs,testClassIDs);

    end