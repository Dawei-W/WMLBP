function SMCCP = Classifyflk(SMCH, trainIDs, trainClassIDs, testIDs, testClassIDs)
% �������ܣ�ʹ�û��ڿ������������ڷ��෽�����з�����ԣ����� CLBP��Circular Local Binary Pattern��������
% ���������
% SMCH����������ÿһ����һ������������������
% trainIDs��ѵ����������������
% trainClassIDs��ѵ��������������ǩ��
% testIDs�����Լ�������������
% testClassIDs�����Լ�����������ǩ��
% ���������
% SMCCP����������ͨ������ڷ�����k-NN���õ���Ԥ������ǩ��

% ��ȡѵ�����Ͳ��Լ�������
trains = SMCH(trainIDs,:);  % ��SMCH����ȡѵ�������������ݣ�ͨ��trainIDs������
tests = SMCH(testIDs,:);    % ��SMCH����ȡ���Լ����������ݣ�ͨ��testIDs������

% ��ȡѵ�����Ͳ��Լ���������
trainNum = size(trains, 1); % ѵ������������size���ؾ����ά�ȣ�ȡ��һά������
testNum = size(tests, 1);   % ���Լ�������

% ��ʼ���������DM������Ϊ���Լ�������������Ϊѵ����������
DM = zeros(testNum, trainNum);  % ����һ��testNum��trainNum�е���������ڴ洢����������ѵ������֮��ľ���

% ��ÿ�������������д���
for i = 1:testNum
    test = tests(i,:);  % ȡ����i������������������������������

    % ���㵱ǰ��������������ѵ������֮��Ŀ������룬���洢��DM����
    DM(i,:) = distMATChiSquare(trains, test)'; % ����distMATChiSquare��������ѵ���������뵱ǰ��������֮��Ŀ������룬
                                                % ���ת�ú�洢��DM����ĵ�i��
end

% ʹ������ڷ�����k-NN�����з��࣬�õ�Ԥ����
SMCCP = ClassifyOnNN(DM, trainClassIDs, testClassIDs); % ���ݼ�����ľ������DM��ʹ��ClassifyOnNN������������ڷ��࣬
                                                         % trainClassIDs��ѵ��������ʵ����ǩ��testClassIDs�ǲ��Լ�����ʵ����ǩ
                                                         % ��������Ԥ�������ǩSMCCP
end
