close all,clear all clc

% load('mapping.mat')
load('mapping.mat');
rootpic = 'E:\data\CUReT\';

Total_Num = 5612;
Image_ID = linspace(1,Total_Num,Total_Num);
CLASS_info = dir(rootpic);
for i=1:61
    filename=fullfile(rootpic,CLASS_info(i+2).name);
    Img_info{i} = dir(filename);
end

hists = [];
uper = 1;
lower =0;
A = lower+(uper-lower).*rand([1 1]);
B = 255;
r = 123;
R1 = 1;
R2 = 2;
R3 = 3;
P=8
linmaxsmc1 = 0;
linmaxsmc2 = 0;
linmaxsmc3 = 0;
linmaxsmcth = 0;
nolinmaxsmc1 = 0;
nolinmaxsmc2 = 0;
nolinmaxsmc3 = 0;
nolinmaxsmcth = 0;

Sum = 0;
% patternMappingriu2 = getmappingold(P,'riu2');
for n=1:length(A)
    %%产生一次随机训练数据
    trainIDs=[];  
    trainClassIDs =[];
    testIDs=[];
    testClassIDs =[];
    a=1;b=92;
    Train_Num = 46;
    Test_Num  = 92 - Train_Num;
    for i =1:61
        x = randsample(a:b,Train_Num);
        x =sort(x,'ascend');
        trainIDs = [trainIDs,x];
        a=a+92;
        b=b+92;
        TrainClass_Index = ones(1,Train_Num)*i;
        trainClassIDs = [trainClassIDs,TrainClass_Index];
        TestClass_Index = ones(1,Test_Num)*i;
        testClassIDs = [testClassIDs,TestClass_Index];
    end
    testIDs = setdiff(Image_ID,trainIDs);
    
    %%特征提取
    y=0;
    z=0;
    for i=1:61
        tic
        filename=fullfile(rootpic,CLASS_info(i+2).name);
        for j=1:92
            z=z+1;
            y=y+1;
            Image_name = fullfile(filename,Img_info{i}(j+2).name);
%             display([ 'r =' num2str(r) ',' ' n =' num2str(n)  ',' 'i =' num2str(y) '.... '  Image_name ])
            img = double(imread(Image_name));
            img = (img-mean(img(:)))/std(img(:))*20+128; % image normalization, to remove global intensity
%             Gray = img;
            if any(testIDs == y)  %%
                Gray = -A(n).*(img) + B;
            else
                Gray = img;
            end
            [row,col]=size(Gray);                
                if rem(row,2)~=0
                    Gray = imresize(Gray,[row+1 col],'bicubic');
%                     tianchong = zeros(1,col);
%                     Gray = [Gray;tianchong];
                end
                [row1,col1]=size(Gray);
                if rem(col1,2)~=0
                    Gray = imresize(Gray,[row1 col1+1],'bicubic');
%                     tianchong = zeros(row1,1);
%                     Gray = [Gray,tianchong];
                end
                [cA,cH,cV,cD]=swt2(Gray,3,'haar');
            cA1 = cA(:,:,1);
            cA2 = cA(:,:,2);
%             cA3 = cA(:,:,3);
            cA1 = cA1(1:row,1:col);
            cA2 = cA2(1:row,1:col);
%             cA3 = cA3(1:row,1:col);
            
            thre3 = MTH(cA1,3);
            thre33 = MTH(cA2,3);


         %%imshow(uint8(wcodemat(cA(:,:,3),256)))%显示图片
            CLBP_SMCH1 = testfangfa(cA1,R1,8,mapping1,thre3);
            CLBP_SMCH2 = testfangfa(cA1,R2,16,mapping2,thre3);
            CLBP_SMCH3 = testfangfa(cA1,R3,24,mapping3,thre3);
%             
            CLBP_SMCH11 = testfangfa(cA2,R1,8,mapping1,thre33);
            CLBP_SMCH22 = testfangfa(cA2,R2,16,mapping2,thre33);
            CLBP_SMCH33 = testfangfa(cA2,R3,24,mapping3,thre33);
            
            
            CLBP_SMCH4 = [CLBP_SMCH1,CLBP_SMCH11];
            CLBP_SMCH44 = [CLBP_SMCH2,CLBP_SMCH22];
            CLBP_SMCH444 = [CLBP_SMCH3,CLBP_SMCH33];
        
% 
            hists1(z,:) = CLBP_SMCH4;
            hists2(z,:) = CLBP_SMCH44;
            hists3(z,:) = CLBP_SMCH444;
            hists4(z,:) = [CLBP_SMCH4,CLBP_SMCH44,CLBP_SMCH444];

            end

        end
        t1 = toc;
%         disp(['读取样本运行时间为 ' num2str(t) ' 秒'])
%         disp(['平均每个样本运行时间为 ' num2str(t/Total_Num) ' 秒'])
%         tic
        
        SMC_CP1 = Classifyflk(hists1,trainIDs,trainClassIDs,testIDs,testClassIDs); %
        SMC_CP2 = Classifyflk(hists2,trainIDs,trainClassIDs,testIDs,testClassIDs); %
        SMC_CP3 = Classifyflk(hists3,trainIDs,trainClassIDs,testIDs,testClassIDs); %
        SMC_CPth = Classifyflk(hists4,trainIDs,trainClassIDs,testIDs,testClassIDs);
        if linmaxsmc1<SMC_CP1
            linmaxsmc1 = SMC_CP1;
%             info=[A(n),n,i,j];
        end
        if linmaxsmc2<SMC_CP2
            linmaxsmc2 = SMC_CP2;
%             info2=[A(n),n,i,j];
        end
        if linmaxsmc3<SMC_CP3
            linmaxsmc3 = SMC_CP3;
%             info3=[A(n),n,i,j];
        end
        if linmaxsmcth<SMC_CPth
            linmaxsmcth = SMC_CPth;
%             infoth=[A(n),n,i,j];
        end
end


for n=1:length(A)
    %%产生一次随机训练数据
    trainIDs=[];  
    trainClassIDs =[];
    testIDs=[];
    testClassIDs =[];
    a=1;b=92;
    Train_Num = 46;
    Test_Num  = 92 - Train_Num;
    for i =1:61
        x = randsample(a:b,Train_Num);
        x =sort(x,'ascend');
        trainIDs = [trainIDs,x];
        a=a+92;
        b=b+92;
        TrainClass_Index = ones(1,Train_Num)*i;
        trainClassIDs = [trainClassIDs,TrainClass_Index];
        TestClass_Index = ones(1,Test_Num)*i;
        testClassIDs = [testClassIDs,TestClass_Index];
    end
    testIDs = setdiff(Image_ID,trainIDs);
    
    %%特征提取
    y=0;
    z=0;
    for i=1:61
        tic
        filename=fullfile(rootpic,CLASS_info(i+2).name);
        for j=1:92
            z=z+1;
            y=y+1;
            Image_name = fullfile(filename,Img_info{i}(j+2).name);
%             display([ 'r =' num2str(r) ',' ' n =' num2str(n)  ',' 'i =' num2str(y) '.... '  Image_name ])
            img = double(imread(Image_name));
            img = (img-mean(img(:)))/std(img(:))*20+128; % image normalization, to remove global intensity
%             Gray = img;
            if any(testIDs == y)  %%
                Gray = -sqrt(img) + B;
            else
                Gray = img;
            end
            [row,col]=size(Gray);                
                if rem(row,2)~=0
                    Gray = imresize(Gray,[row+1 col],'bicubic');
%                     tianchong = zeros(1,col);
%                     Gray = [Gray;tianchong];
                end
                [row1,col1]=size(Gray);
                if rem(col1,2)~=0
                    Gray = imresize(Gray,[row1 col1+1],'bicubic');
%                     tianchong = zeros(row1,1);
%                     Gray = [Gray,tianchong];
                end
                [cA,cH,cV,cD]=swt2(Gray,3,'haar');
            cA1 = cA(:,:,1);
            cA2 = cA(:,:,2);
%             cA3 = cA(:,:,3);
            cA1 = cA1(1:row,1:col);
            cA2 = cA2(1:row,1:col);
%             cA3 = cA3(1:row,1:col);
            
            thre3 = MTH(cA1,3);
            thre33 = MTH(cA2,3);


         %%imshow(uint8(wcodemat(cA(:,:,3),256)))%显示图片
            CLBP_SMCH1 = testfangfa(cA1,R1,8,mapping1,thre3);
            CLBP_SMCH2 = testfangfa(cA1,R2,16,mapping2,thre3);
            CLBP_SMCH3 = testfangfa(cA1,R3,24,mapping3,thre3);
%             
            CLBP_SMCH11 = testfangfa(cA2,R1,8,mapping1,thre33);
            CLBP_SMCH22 = testfangfa(cA2,R2,16,mapping2,thre33);
            CLBP_SMCH33 = testfangfa(cA2,R3,24,mapping3,thre33);
            
            
            CLBP_SMCH4 = [CLBP_SMCH1,CLBP_SMCH11];
            CLBP_SMCH44 = [CLBP_SMCH2,CLBP_SMCH22];
            CLBP_SMCH444 = [CLBP_SMCH3,CLBP_SMCH33];
        
% 
            hists1(z,:) = CLBP_SMCH4;
            hists2(z,:) = CLBP_SMCH44;
            hists3(z,:) = CLBP_SMCH444;
            hists4(z,:) = [CLBP_SMCH4,CLBP_SMCH44,CLBP_SMCH444];

            end

        end
        t2 = toc;
%         disp(['读取样本运行时间为 ' num2str(t) ' 秒'])
%         disp(['平均每个样本运行时间为 ' num2str(t/Total_Num) ' 秒'])
%         tic
        
        SMC_CP1 = Classifyflk(hists1,trainIDs,trainClassIDs,testIDs,testClassIDs); %
        SMC_CP2 = Classifyflk(hists2,trainIDs,trainClassIDs,testIDs,testClassIDs); %
        SMC_CP3 = Classifyflk(hists3,trainIDs,trainClassIDs,testIDs,testClassIDs); %
        SMC_CPth = Classifyflk(hists4,trainIDs,trainClassIDs,testIDs,testClassIDs);
        if nolinmaxsmc1<SMC_CP1
            nolinmaxsmc1 = SMC_CP1;
%             info=[A(n),n,i,j];
        end
        if nolinmaxsmc2<SMC_CP2
            nolinmaxsmc2 = SMC_CP2;
%             info2=[A(n),n,i,j];
        end
        if nolinmaxsmc3<SMC_CP3
            nolinmaxsmc3 = SMC_CP3;
%             info3=[A(n),n,i,j];
        end
        if nolinmaxsmcth<SMC_CPth
            nolinmaxsmcth = SMC_CPth;
%             infoth=[A(n),n,i,j];
        end
end