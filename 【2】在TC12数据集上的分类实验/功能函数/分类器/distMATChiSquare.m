%  distMATChiSquare computes the dissimilarity between training samples and a test sample
%  DV = distMATChiSquare(train, test) returns the distance vector between training samples and a test sample. 
%  The input "train" is a n*d matrix, and each row of it represent one
%  training sample. The "test" is a 1*d vector.   

%  Examples
%  --------
%       I1=imread('rice1.png');
%       I2=imread('rice2.png');
%       I3=imread('rice3.png');
%       mapping=getmapping(8,'u2'); 
%       M(1,:)=LBPV(I1,1,8,mapping); % LBPV histogram in (8,1) neighborhood using uniform patterns
%       M(2,:)=LBPV(I2,1,8,mapping); 
%       S=LBPV(I3,1,8,mapping); 
%       DV = distMATChiSquare(M,S);

function DV = distMATChiSquare(trains, test)
% Version 1.0
% Authors: Zhenhua Guo, Lei Zhang and David Zhang
% Copyright @ Biometrics Research Centre, the Hong Kong Polytechnic University

function DV = distMATChiSquare(trains, test)
% 版本 1.0
% 作者: Zhenhua Guo, Lei Zhang 和 David Zhang
% 版权 @ 香港理工大学 生物特征研究中心

% 获取训练数据矩阵的维度
[train_row, train_col] = size(trains);  % train_row为训练数据的行数（样本数），train_col为训练数据的列数（特征数）
[test_row, test_col] = size(test);      % test_row为测试数据的行数（样本数），test_col为测试数据的列数（特征数）

% 将测试数据扩展为与训练数据矩阵大小相同的矩阵
% 通过repmat函数将测试样本复制train_row次，形成一个与训练数据行数相同的矩阵
testExtend = repmat(test, train_row, 1); 

% 计算训练数据与扩展的测试数据之间的差值
subMatrix = trains - testExtend;   % 每个训练样本与测试样本之间的差值

% 对差值进行平方
subMatrix2 = subMatrix .^ 2;   % 对差值矩阵的每个元素进行平方

% 计算训练数据与扩展的测试数据之间的元素和
addMatrix = trains + testExtend;  % 训练样本与测试样本的和矩阵

% 将元素和为0的位置替换为1，避免除零错误
% 找到元素和为零的位置
idxZero = find(addMatrix == 0); 
% 将这些位置的值设为1
addMatrix(idxZero) = 1;

% 计算Chi-Square距离
DistMat = subMatrix2 ./ addMatrix;  % 计算每个特征的Chi-Square距离

% 对每个样本的Chi-Square距离进行求和，得到每个训练样本与测试样本的总距离
DV = sum(DistMat, 2);  % 对每行（即每个训练样本与测试样本的距离）进行求和，得到DV

end
