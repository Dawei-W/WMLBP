%  ClassifyOnNN computes the classification accuracy
%  CP=ClassifyOnNN(DM,trainClassIDs,testClassIDs) returns the classification accuracy 
%  The input "DM" is a m*n distance matrix, m is the number of test samples, n is the number of training samples
%  'trainClassIDs' and 'testClassIDs' stores the class ID of training and
%  test samples

%  Examples
%  --------
%       I1=imread('rice1.png');
%       I2=imread('rice2.png');
%       I3=imread('rice3.png');
%       I4=imread('rice4.png');
%       mapping=getmapping(8,'u2'); 
%       M(1,:)=LBPV(I1,1,8,mapping); % LBPV histogram in (8,1) neighborhood using uniform patterns
%       M(2,:)=LBPV(I2,1,8,mapping); 
%       S(1,:)=LBPV(I3,1,8,mapping); 
%       S(2,:)=LBPV(I4,1,8,mapping); 
%       M = ConvertU2LBP(M,8); % convert u2 LBP or LBPV to meet the requirement of global matching scheme
%       S = ConvertU2LBP(S,8);
%       DM = distGMPDRN(M,S,8,2,3);
%       CP=ClassifyOnNN(DM,[1,1],[1,1]);

function CP = ClassifyOnNN(DM, trainClassIDs, testClassIDs)
% 版本 1.0
% 作者: Zhenhua Guo, Lei Zhang 和 David Zhang
% 版权 @ 香港理工大学 生物特征研究中心

% 检查输入参数的个数，确保至少有3个输入参数
if nargin < 3
    disp('输入参数不足。')
    return
end

% 初始化正确分类的数量
rightCount = 0;

% 遍历测试集中的每个样本
for i = 1:length(testClassIDs)
    % 计算该测试样本与训练样本之间的距离，找到最近邻的训练样本
    [distNew, index] = min(DM(i,:));   % 在DM矩阵中找到当前测试样本(i)与所有训练样本的最小距离，index为最近邻的训练样本的索引
    
    % 判断最近邻的训练样本是否与当前测试样本属于相同类别
    if trainClassIDs(index) == testClassIDs(i)  % 如果训练集中的最近邻样本类别与当前测试样本类别相同
        rightCount = rightCount + 1;  % 如果分类正确，则正确分类的数量加1
    end
end

% 计算分类准确率：正确分类的样本数除以总测试样本数，乘以100得到百分比
CP = rightCount / length(testClassIDs) * 100;

end
