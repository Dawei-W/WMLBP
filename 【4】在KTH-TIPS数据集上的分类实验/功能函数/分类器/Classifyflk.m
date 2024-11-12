function SMCCP = Classifyflk(SMCH, trainIDs, trainClassIDs, testIDs, testClassIDs)
% 函数功能：使用基于卡方距离的最近邻分类方法进行分类测试，利用 CLBP（Circular Local Binary Pattern）特征。
% 输入参数：
% SMCH：特征矩阵，每一行是一个样本的特征向量。
% trainIDs：训练集样本的索引。
% trainClassIDs：训练集样本的类别标签。
% testIDs：测试集样本的索引。
% testClassIDs：测试集样本的类别标签。
% 输出参数：
% SMCCP：分类结果，通过最近邻方法（k-NN）得到的预测类别标签。

% 提取训练集和测试集的数据
trains = SMCH(trainIDs,:);  % 从SMCH中提取训练集的样本数据（通过trainIDs索引）
tests = SMCH(testIDs,:);    % 从SMCH中提取测试集的样本数据（通过testIDs索引）

% 获取训练集和测试集的样本数
trainNum = size(trains, 1); % 训练集样本数，size返回矩阵的维度，取第一维即行数
testNum = size(tests, 1);   % 测试集样本数

% 初始化距离矩阵DM，行数为测试集样本数，列数为训练集样本数
DM = zeros(testNum, trainNum);  % 创建一个testNum行trainNum列的零矩阵，用于存储测试样本与训练样本之间的距离

% 对每个测试样本进行处理
for i = 1:testNum
    test = tests(i,:);  % 取出第i个测试样本的特征向量（行向量）

    % 计算当前测试样本与所有训练样本之间的卡方距离，并存储到DM矩阵
    DM(i,:) = distMATChiSquare(trains, test)'; % 调用distMATChiSquare函数计算训练集样本与当前测试样本之间的卡方距离，
                                                % 结果转置后存储到DM矩阵的第i行
end

% 使用最近邻方法（k-NN）进行分类，得到预测结果
SMCCP = ClassifyOnNN(DM, trainClassIDs, testClassIDs); % 根据计算出的距离矩阵DM，使用ClassifyOnNN函数进行最近邻分类，
                                                         % trainClassIDs是训练集的真实类别标签，testClassIDs是测试集的真实类别标签
                                                         % 函数返回预测的类别标签SMCCP
end
