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
% 定义函数 getmappingold，用于生成不同类型的 LBP 映射表。

% 版本信息
% Version 0.1.1
% 作者：Marko Heikkil? 和 Timo Ahonen

% 更新日志
% 0.1.1 将输出修改为结构体。
% 修复了生成旋转不变映射表时采样点数量过高引起的内存溢出问题。
% 感谢 Lauge Sorensen 提供的反馈。

table = 0:2^samples-1;  % 初始化映射表 table，范围从 0 到 2^samples - 1
newMax = 0;             % 初始化最终 LBP 码模式数量变量 newMax
index = 0;              % 初始化索引 index

% 判断映射类型是否为 'u2'（Uniform 2，即统一模式）
if strcmp(mappingtype,'u2')
  newMax = samples * (samples - 1) + 3; % 计算统一模式下的模式数量
  for i = 0:2^samples-1                 % 遍历所有可能的二进制模式
    samples2 = 'uint8';
    j = bitset(bitshift(i,1,samples2),1,bitget(i,samples)); % 左移旋转二进制模式
    numt = sum(bitget(bitxor(i,j),1:samples)); % 计算二进制模式的跳变次数，即1->0和0->1的次数

    if numt <= 2
      table(i+1) = index;               % 若跳变次数小于等于2，模式为统一模式
      index = index + 1;
    else
      table(i+1) = newMax - 1;          % 若跳变次数大于2，模式为非统一模式
    end
  end
end

% 判断映射类型是否为 'ri'（Rotation invariant，即旋转不变模式）
if strcmp(mappingtype,'ri')
  tmpMap = zeros(2^samples,1) - 1;      % 初始化临时映射表 tmpMap
  for i = 0:2^samples-1                 % 遍历所有可能的二进制模式
    rm = i;                             % 初始最小旋转模式
    r  = i;                             % 当前旋转模式
    for j = 1:samples-1                 % 对每个样本点进行左移旋转
      r = bitset(bitshift(r,1,samples),1,bitget(r,samples));
      if r < rm                         % 若新的旋转模式小于当前最小旋转模式
        rm = r;                         % 更新最小旋转模式
      end
    end
    if tmpMap(rm+1) < 0                 % 若最小旋转模式尚未映射
      tmpMap(rm+1) = newMax;            % 更新模式数量
      newMax = newMax + 1;
    end
    table(i+1) = tmpMap(rm+1);          % 将当前模式映射到最小旋转模式
  end
end

% 判断映射类型是否为 'riu2'（Uniform & Rotation invariant，即旋转不变的统一模式）
if strcmp(mappingtype,'riu2')
  newMax = samples + 2;                 % 计算旋转不变统一模式数量
  for i = 0:2^samples - 1               % 遍历所有可能的二进制模式
    j = bitset(bitshift(i,1,'uint32'),1,bitget(i,samples)); % 左移旋转二进制模式
    numt = sum(bitget(bitxor(i,j),1:samples));             % 计算跳变次数

    if numt <= 2                        % 若跳变次数小于等于2
      table(i+1) = sum(bitget(i,1:samples)); % 计算1的个数并存储在 table 中
    else
      table(i+1) = samples + 1;         % 否则，模式归为第九种
    end
  end
end

% 将映射表及其相关信息存入结构体 mapping 中
mapping.table = table;                   % 保存最终的映射表 table
mapping.samples = samples;               % 保存采样点数量 samples
mapping.num = newMax;                    % 保存最终的模式数量 newMax
