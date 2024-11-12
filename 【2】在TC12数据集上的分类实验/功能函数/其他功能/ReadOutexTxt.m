%  ReadOutexTxt gets picture IDs and class IDs from txt for Outex Database
%  [filenames, classIDs] = ReadOutexTxt(txtfile) gets picture IDs and class
%  IDs from TXT file for Outex Database


function [filenames, classIDs] = ReadOutexTxt(txtfile)
% Version 1.0
% Authors: Zhenhua Guo, Lei Zhang, and David Zhang
% Copyright @ Biometrics Research Centre, the Hong Kong Polytechnic University
%
% 功能：此函数用于从指定的文本文件中读取图像文件名和其对应的类别标签。
% 该文本文件中的每一行包含一个图像的文件名和类别ID。函数将读取文件中的内容，并提取出
% 图像的文件名和对应的类别ID，并分别返回这些信息。
%
% 输入：
%   txtfile：包含图像文件名和类别ID的文本文件路径（字符串）。
%
% 输出：
%   filenames：一个包含图像文件ID（以数字表示）的数组。
%   classIDs：一个包含图像类别ID的数组。

% 打开文本文件并获取文件的读取权限
fid = fopen(txtfile, 'r'); % 'r'表示只读模式
tline = fgetl(fid); % 读取文件的第一行（可能是图像样本数，但实际未用到）

% 初始化计数器 i
i = 0;

% 开始逐行读取文件内容
while 1
    tline = fgetl(fid); % 读取下一行文本
    if ~ischar(tline)  % 如果读到文件结尾，则退出循环
        break;
    end
    
    % 找到当前行中第一个'.'字符的位置，用于区分文件名和类别ID
    index = findstr(tline, '.'); % 返回 '.' 的位置索引
    i = i + 1;  % 增加样本计数器
    
    % 提取文件ID并转换为数字。文件名的数字部分从第一字符到'.'前一位。
    filenames(i) = str2num(tline(1:index-1)) + 1;  % 图片ID从0开始，而MATLAB数组索引从1开始，因此+1
    
    % 提取类别ID并将其转换为数字。类别ID在'.'后第5个字符开始直到行尾。
    classIDs(i) = str2num(tline(index + 5:end));  % 获取类别ID
end

% 关闭文件
fclose(fid);  % 关闭文件读取
