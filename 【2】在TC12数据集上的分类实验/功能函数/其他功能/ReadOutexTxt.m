%  ReadOutexTxt gets picture IDs and class IDs from txt for Outex Database
%  [filenames, classIDs] = ReadOutexTxt(txtfile) gets picture IDs and class
%  IDs from TXT file for Outex Database


function [filenames, classIDs] = ReadOutexTxt(txtfile)
% Version 1.0
% Authors: Zhenhua Guo, Lei Zhang, and David Zhang
% Copyright @ Biometrics Research Centre, the Hong Kong Polytechnic University
%
% ���ܣ��˺������ڴ�ָ�����ı��ļ��ж�ȡͼ���ļ��������Ӧ������ǩ��
% ���ı��ļ��е�ÿһ�а���һ��ͼ����ļ��������ID����������ȡ�ļ��е����ݣ�����ȡ��
% ͼ����ļ����Ͷ�Ӧ�����ID�����ֱ𷵻���Щ��Ϣ��
%
% ���룺
%   txtfile������ͼ���ļ��������ID���ı��ļ�·�����ַ�������
%
% �����
%   filenames��һ������ͼ���ļ�ID�������ֱ�ʾ�������顣
%   classIDs��һ������ͼ�����ID�����顣

% ���ı��ļ�����ȡ�ļ��Ķ�ȡȨ��
fid = fopen(txtfile, 'r'); % 'r'��ʾֻ��ģʽ
tline = fgetl(fid); % ��ȡ�ļ��ĵ�һ�У�������ͼ������������ʵ��δ�õ���

% ��ʼ�������� i
i = 0;

% ��ʼ���ж�ȡ�ļ�����
while 1
    tline = fgetl(fid); % ��ȡ��һ���ı�
    if ~ischar(tline)  % ��������ļ���β�����˳�ѭ��
        break;
    end
    
    % �ҵ���ǰ���е�һ��'.'�ַ���λ�ã����������ļ��������ID
    index = findstr(tline, '.'); % ���� '.' ��λ������
    i = i + 1;  % ��������������
    
    % ��ȡ�ļ�ID��ת��Ϊ���֡��ļ��������ֲ��ִӵ�һ�ַ���'.'ǰһλ��
    filenames(i) = str2num(tline(1:index-1)) + 1;  % ͼƬID��0��ʼ����MATLAB����������1��ʼ�����+1
    
    % ��ȡ���ID������ת��Ϊ���֡����ID��'.'���5���ַ���ʼֱ����β��
    classIDs(i) = str2num(tline(index + 5:end));  % ��ȡ���ID
end

% �ر��ļ�
fclose(fid);  % �ر��ļ���ȡ
