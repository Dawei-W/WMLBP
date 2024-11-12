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
% �汾 1.0
% ����: Zhenhua Guo, Lei Zhang �� David Zhang
% ��Ȩ @ �������ѧ ���������о�����

% �����������ĸ�����ȷ��������3���������
if nargin < 3
    disp('����������㡣')
    return
end

% ��ʼ����ȷ���������
rightCount = 0;

% �������Լ��е�ÿ������
for i = 1:length(testClassIDs)
    % ����ò���������ѵ������֮��ľ��룬�ҵ�����ڵ�ѵ������
    [distNew, index] = min(DM(i,:));   % ��DM�������ҵ���ǰ��������(i)������ѵ����������С���룬indexΪ����ڵ�ѵ������������
    
    % �ж�����ڵ�ѵ�������Ƿ��뵱ǰ��������������ͬ���
    if trainClassIDs(index) == testClassIDs(i)  % ���ѵ�����е��������������뵱ǰ�������������ͬ
        rightCount = rightCount + 1;  % ���������ȷ������ȷ�����������1
    end
end

% �������׼ȷ�ʣ���ȷ����������������ܲ���������������100�õ��ٷֱ�
CP = rightCount / length(testClassIDs) * 100;

end
