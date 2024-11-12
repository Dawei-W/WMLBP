%GETMAPPING returns a structure containing a mapping table for LBP codes.
%  MAPPING = GETMAPPING(SAMPLES,MAPPINGTYPE) returns a 
%  structure containing a mapping table for
%  LBP codes in a neighbourhood of SAMPLES sampling
%  points. Possible values for MAPPINGTYPE are
%       'u2'   for uniform LBP
%       'ri'   for rotation-invariant LBP
%       'riu2' for uniform rotation-invariant LBP.
%
%  Example:
%       I=imread('rice.tif');
%       MAPPING=getmapping(16,'riu2');
%       LBPHIST=lbp(I,2,16,MAPPING,'hist');
%  Now LBPHIST contains a rotation-invariant uniform LBP
%  histogram in a (16,2) neighbourhood.
%

function mapping = getmappingold(samples,mappingtype)
% ���庯�� getmappingold���������ɲ�ͬ���͵� LBP ӳ���

% �汾��Ϣ
% Version 0.1.1
% ���ߣ�Marko Heikkil? �� Timo Ahonen

% ������־
% 0.1.1 ������޸�Ϊ�ṹ�塣
% �޸���������ת����ӳ���ʱ��������������������ڴ�������⡣
% ��л Lauge Sorensen �ṩ�ķ�����

table = 0:2^samples-1;  % ��ʼ��ӳ��� table����Χ�� 0 �� 2^samples - 1
newMax = 0;             % ��ʼ������ LBP ��ģʽ�������� newMax
index = 0;              % ��ʼ������ index

% �ж�ӳ�������Ƿ�Ϊ 'u2'��Uniform 2����ͳһģʽ��
if strcmp(mappingtype,'u2')
  newMax = samples * (samples - 1) + 3; % ����ͳһģʽ�µ�ģʽ����
  for i = 0:2^samples-1                 % �������п��ܵĶ�����ģʽ
    samples2 = 'uint8';
    j = bitset(bitshift(i,1,samples2),1,bitget(i,samples)); % ������ת������ģʽ
    numt = sum(bitget(bitxor(i,j),1:samples)); % ���������ģʽ�������������1->0��0->1�Ĵ���

    if numt <= 2
      table(i+1) = index;               % ���������С�ڵ���2��ģʽΪͳһģʽ
      index = index + 1;
    else
      table(i+1) = newMax - 1;          % �������������2��ģʽΪ��ͳһģʽ
    end
  end
end

% �ж�ӳ�������Ƿ�Ϊ 'ri'��Rotation invariant������ת����ģʽ��
if strcmp(mappingtype,'ri')
  tmpMap = zeros(2^samples,1) - 1;      % ��ʼ����ʱӳ��� tmpMap
  for i = 0:2^samples-1                 % �������п��ܵĶ�����ģʽ
    rm = i;                             % ��ʼ��С��תģʽ
    r  = i;                             % ��ǰ��תģʽ
    for j = 1:samples-1                 % ��ÿ�����������������ת
      r = bitset(bitshift(r,1,samples),1,bitget(r,samples));
      if r < rm                         % ���µ���תģʽС�ڵ�ǰ��С��תģʽ
        rm = r;                         % ������С��תģʽ
      end
    end
    if tmpMap(rm+1) < 0                 % ����С��תģʽ��δӳ��
      tmpMap(rm+1) = newMax;            % ����ģʽ����
      newMax = newMax + 1;
    end
    table(i+1) = tmpMap(rm+1);          % ����ǰģʽӳ�䵽��С��תģʽ
  end
end

% �ж�ӳ�������Ƿ�Ϊ 'riu2'��Uniform & Rotation invariant������ת�����ͳһģʽ��
if strcmp(mappingtype,'riu2')
  newMax = samples + 2;                 % ������ת����ͳһģʽ����
  for i = 0:2^samples - 1               % �������п��ܵĶ�����ģʽ
    j = bitset(bitshift(i,1,'uint32'),1,bitget(i,samples)); % ������ת������ģʽ
    numt = sum(bitget(bitxor(i,j),1:samples));             % �����������

    if numt <= 2                        % ���������С�ڵ���2
      table(i+1) = sum(bitget(i,1:samples)); % ����1�ĸ������洢�� table ��
    else
      table(i+1) = samples + 1;         % ����ģʽ��Ϊ�ھ���
    end
  end
end

% ��ӳ����������Ϣ����ṹ�� mapping ��
mapping.table = table;                   % �������յ�ӳ��� table
mapping.samples = samples;               % ������������� samples
mapping.num = newMax;                    % �������յ�ģʽ���� newMax
