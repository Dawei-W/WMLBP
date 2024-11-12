close all
clear all 
clc

load('mapping.mat');
rootpic = 'E:\data\kth_tips-orgin\KTH_TIPS\';
Total_Num = 810;
Image_ID = linspace(1,Total_Num,Total_Num);
CLASS_info = dir(rootpic);
for i=1:10
    filename=fullfile(rootpic,CLASS_info(i+2).name);
    Img_info{i} = dir(filename);
end

uper = 1;
lower = 0;
A = lower+(uper-lower).*rand([1 1]);  %产生随机的a
B = 255;
R1 = 1;
R2 = 2;
R3 = 3;
P = 8;
maxsmc1 = 0;
maxsmc2 = 0;
maxsmc3 = 0;
maxsmcth = 0;
% patternMappingriu2 = getmappingold(P,'riu2');
for nn = 1:1
    for n=1:length(A)
        trainIDs=[];
        trainClassIDs =[];
        testIDs=[];
        testClassIDs =[];
        a=1;b=81;
        Train_Num = 40;
        Test_Num  = 81 - Train_Num;
        %%产生一次随机训练数据
        
        for ii =1:10
            x = randsample(a:b,Train_Num);
            x =sort(x,'ascend');
            trainIDs = [trainIDs,x];
            a=a+81;b=b+81;
            
            TrainClass_Num = ones(1,Train_Num)*ii;
            trainClassIDs = [trainClassIDs,TrainClass_Num];
            TestClass_Num = ones(1,Test_Num)*ii;
            testClassIDs = [testClassIDs,TestClass_Num];
        end
        testIDs = setdiff(Image_ID,trainIDs);
        
        %%特征提取
        y=0;
        z=0;
        for i=1:10
            tic
            filename=fullfile(rootpic,CLASS_info(i+2).name);
            for j=1:81
                z=z+1;
                y=y+1;
                Image_name = fullfile(filename,Img_info{i}(j+2).name);
                disp([ 'nn = ' num2str(nn) ','  ' n =' num2str(n)  ',' 'i =' num2str(y) '.... '  Image_name ])
                img = im2double(imread(Image_name));
                img = abs((img-mean(img(:)))/std(img(:))*20+128); % image normalization, to remove global intensity
                if any(testIDs == y)  %%
%                     Gray = -sqrt(img) + B;
                     Gray = imnoise(Gray,'gaussian',0,0.001);
                else
                    Gray = img;
                end
                [row,col]=size(Gray);                
                if rem(row,2^3)~=0
                    Gray = imresize(Gray,[row+(8-rem(row,2^3)) col],'bicubic');
%                     tianchong = zeros(1,col);
%                     Gray = [Gray;tianchong];
                end
                [row1,col1]=size(Gray);
                if rem(col1,2^3)~=0
                    Gray = imresize(Gray,[row1 col1+(8-rem(col1,2^3))],'bicubic');
%                     tianchong = zeros(row1,1);
%                     Gray = [Gray,tianchong];
                end
            [cA,cH,cV,cD]=swt2(Gray,3,'coif3');
            cA1 = cA(:,:,1);
            cA2 = cA(:,:,2);
            cA3 = cA(:,:,3);
            cA1 = cA1(1:row,1:col);
            cA2 = cA2(1:row,1:col);
            cA3 = cA3(1:row,1:col);
            
%             thre1 = MTH(cA1,1);
%             thre2 = MTH(cA1,2);
            thre3 = MTH(Gray,3);
%             thre4 = MTH(cA1,4);
%             thre5 = MTH(cA1,5);
%             thre6 = MTH(cA1,6);
%             thre7 = MTH(cA1,7);
%             thre11 = MTH(cA2,1);
%             thre22 = MTH(cA2,2);
%             thre33 = MTH(cA2,3);
%             thre44 = MTH(cA2,4);
%             thre55 = MTH(cA2,5);
%             thre66 = MTH(cA2,6);
%             thre77 = MTH(cA2,7);
%             thre111 = MTH(cA3,1);
%             thre222 = MTH(cA3,2);
            thre333 = MTH(cA3,3);
%             thre444 = MTH(cA3,4);
%             thre555 = MTH(cA3,5);
%             thre666 = MTH(cA3,6);
%             thre777 = MTH(cA3,7);

         %%imshow(uint8(wcodemat(cA(:,:,3),256)))%显示图片
            CLBP_SMCH1 = testfangfa(Gray,R1,8,mapping1,thre3);
            CLBP_SMCH2 = testfangfa(Gray,R2,16,mapping2,thre3);
            CLBP_SMCH3 = testfangfa(Gray,R3,24,mapping3,thre3);
            
            CLBP_SMCH11 = testfangfa(cA3,R1,8,mapping1,thre333);
            CLBP_SMCH22 = testfangfa(cA3,R2,16,mapping2,thre333);
            CLBP_SMCH33 = testfangfa(cA3,R3,24,mapping3,thre333);
            
            
            CLBP_SMCH4 = [CLBP_SMCH1,CLBP_SMCH11];
            CLBP_SMCH44 = [CLBP_SMCH2,CLBP_SMCH22];
            CLBP_SMCH444 = [CLBP_SMCH3,CLBP_SMCH33];
            

% 
            hists1(z,:) = CLBP_SMCH4;
            hists2(z,:) = CLBP_SMCH44;
            hists3(z,:) = CLBP_SMCH444;
            hists4(z,:) = [CLBP_SMCH4,CLBP_SMCH44,CLBP_SMCH444];

%             hists1(z,:) = CLBP_SMCH1;
%             hists2(z,:) = CLBP_SMCH2;
%             hists3(z,:) = CLBP_SMCH3;
%             hists4(z,:) = [CLBP_SMCH1,CLBP_SMCH2,CLBP_SMCH3];

            end

        end
        t = toc;
        disp(['读取样本运行时间为 ' num2str(t) ' 秒'])
        disp(['平均每个样本运行时间为 ' num2str(t/Total_Num) ' 秒'])
        tic
        
        SMC_CP1 = Classifyflk(hists1,trainIDs,trainClassIDs,testIDs,testClassIDs); %
        SMC_CP2 = Classifyflk(hists2,trainIDs,trainClassIDs,testIDs,testClassIDs); %
        SMC_CP3 = Classifyflk(hists3,trainIDs,trainClassIDs,testIDs,testClassIDs); %
        SMC_CPth = Classifyflk(hists4,trainIDs,trainClassIDs,testIDs,testClassIDs);
        if maxsmc1<SMC_CP1
            maxsmc1 = SMC_CP1;
        end
        if maxsmc2<SMC_CP2
            maxsmc2 = SMC_CP2;
        end
        if maxsmc3<SMC_CP3
            maxsmc3 = SMC_CP3;
        end
        if maxsmcth<SMC_CPth
            maxsmcth = SMC_CPth;
        end
        Sum1(n,:) =  SMC_CP1;
        Sum2(n,:) =  SMC_CP2;
        Sum3(n,:) =  SMC_CP3;
        Sum4(n,:) =  SMC_CPth;
        t1 = toc;
        disp(['样本分类计算时间为 ' num2str(t1) ' 秒'])

    end
    CountSum1(nn,:)=Sum1;
    CountSum2(nn,:)=Sum2;
    CountSum3(nn,:)=Sum3;
    CountSum4(nn,:)=Sum4;
    aver1(nn,:) = mean(Sum1);
    aver2(nn,:) = mean(Sum2);
    aver3(nn,:) = mean(Sum3);
    aver4(nn,:) = mean(Sum4);
end

% save KTH-TIPS_Linear_gv