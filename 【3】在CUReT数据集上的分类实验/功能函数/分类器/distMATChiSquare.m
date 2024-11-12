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
% �汾 1.0
% ����: Zhenhua Guo, Lei Zhang �� David Zhang
% ��Ȩ @ �������ѧ ���������о�����

% ��ȡѵ�����ݾ����ά��
[train_row, train_col] = size(trains);  % train_rowΪѵ�����ݵ�����������������train_colΪѵ�����ݵ���������������
[test_row, test_col] = size(test);      % test_rowΪ�������ݵ�����������������test_colΪ�������ݵ���������������

% ������������չΪ��ѵ�����ݾ����С��ͬ�ľ���
% ͨ��repmat������������������train_row�Σ��γ�һ����ѵ������������ͬ�ľ���
testExtend = repmat(test, train_row, 1); 

% ����ѵ����������չ�Ĳ�������֮��Ĳ�ֵ
subMatrix = trains - testExtend;   % ÿ��ѵ���������������֮��Ĳ�ֵ

% �Բ�ֵ����ƽ��
subMatrix2 = subMatrix .^ 2;   % �Բ�ֵ�����ÿ��Ԫ�ؽ���ƽ��

% ����ѵ����������չ�Ĳ�������֮���Ԫ�غ�
addMatrix = trains + testExtend;  % ѵ����������������ĺ;���

% ��Ԫ�غ�Ϊ0��λ���滻Ϊ1������������
% �ҵ�Ԫ�غ�Ϊ���λ��
idxZero = find(addMatrix == 0); 
% ����Щλ�õ�ֵ��Ϊ1
addMatrix(idxZero) = 1;

% ����Chi-Square����
DistMat = subMatrix2 ./ addMatrix;  % ����ÿ��������Chi-Square����

% ��ÿ��������Chi-Square���������ͣ��õ�ÿ��ѵ������������������ܾ���
DV = sum(DistMat, 2);  % ��ÿ�У���ÿ��ѵ����������������ľ��룩������ͣ��õ�DV

end
