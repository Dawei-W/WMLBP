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
            %��ͨͼ��
%                 Gray = imread(filename);
%                 Gray = im2double(Gray);
%                 Gray = (Gray-mean(Gray(:)))/std(Gray(:))*20+128;
            disp([ '��' num2str(n) '��,  ','��' num2str(i) '��ͼ'])
            %�Ҷȷ�ת���ͼ��
            img = imread(filename);
            img = im2double(img);
            img = (img-mean(img(:)))/std(img(:))*20+128; % image normalization, to remove global intensity
%             Gray = img;
            if any(testIDs == i)
                %����
%                 Gray = -a(n).*((img)) + b;
                %������
%                   Gray = -sqrt(img) + b;
                  Gray = imnoise(Gray,'gaussian',0,0.001);
            else
                Gray = img;
            end
            
            [cA,cH,cV,cD]=swt2(Gray,3,'haar');
            cA1 = cA(:,:,1);
            cA2 = cA(:,:,2);
            cA3 = cA(:,:,3);
            

            thre3 = MTH(cA1,3);

            CLBP_SMCH1 = testfangfa(cA2,R1,8,mapping1,thre3);
            CLBP_SMCH2 = testfangfa(cA2,R2,16,mapping2,thre3);
            CLBP_SMCH3 = testfangfa(cA2,R3,24,mapping3,thre3);
            


            hists1(i,:) = CLBP_SMCH1;
            hists2(i,:) = CLBP_SMCH2;
            hists3(i,:) = CLBP_SMCH3;
            hists4(i,:) = [CLBP_SMCH1,CLBP_SMCH2,CLBP_SMCH3];
            
        end
        t  = toc;
        disp(['��ȡ��������ʱ��Ϊ ' num2str(t) ' ��'])
        disp(['ƽ��ÿ����������ʱ��Ϊ ' num2str(t/picNum) ' ��'])
        
        SMC_CP1=Classifyflk(hists1,trainIDs,trainClassIDs,testIDs,testClassIDs);
        SMC_CP2=Classifyflk(hists2,trainIDs,trainClassIDs,testIDs,testClassIDs);
        SMC_CP3=Classifyflk(hists3,trainIDs,trainClassIDs,testIDs,testClassIDs);
        SMC_CPth=Classifyflk(hists4,trainIDs,trainClassIDs,testIDs,testClassIDs);

        
    end

