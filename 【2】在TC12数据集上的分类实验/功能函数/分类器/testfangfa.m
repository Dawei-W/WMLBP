%CLBP returns the complete local binary pattern image or LBP histogram of an image.
%  [CLBP_S,CLBP_M,CLBP_C] = CLBP(I,R,N,MAPPING,MODE) returns either a local binary pattern
%  coded image or the local binary pattern histogram of an intensity
%  image I. The CLBP codes are computed using N sampling points on a 
%  circle of radius R and using mapping table defined by MAPPING. 
%  See the getmapping function for different mappings and use 0 for
%  no mapping. Possible values for MODE are
%       'h' or 'hist'  to get a histogram of LBP codes
%       'nh'           to get a normalized histogram
%  Otherwise an CLBP code image is returned.

%  [CLBP_S,CLBP_M,CLBP_C] = CLBP(I,SP,MAPPING,MODE) computes the CLBP codes using n sampling
%  points defined in (n * 2) matrix SP. The sampling points should be
%  defined around the origin (coordinates (0,0)).
%
%  Examples
%  --------
%       I=imread('rice.png');
%       mapping=getmapping(8,'u2'); 
%       [CLBP_SH,CLBP_MH]=CLBP(I,1,8,mapping,'h'); %CLBP histogram in (8,1) neighborhood
%                                  %using uniform patterns

function [CLBP_SMCH] = testfangfa(Gray, radius, neighbors, mapping, Mthre)
% 输入参数：
% Gray: 输入的灰度图像
% radius: LBP算子的半径
% neighbors: LBP算子的邻域点数
% mapping: LBP映射结构，包含模式的映射表
% Mthre: 用于计算CLBP模式的阈值矩阵

% 将输入的灰度图像转换为double类型，以便进行数值计算
image = Gray;
d_image = double(image);

% 初始化邻域点坐标数组
spoints = zeros(neighbors, 2);

% 计算每个邻域点的角度，邻域点均匀分布在圆周上
a = 2 * pi / neighbors; % 每个邻域点之间的角度

for i = 1:neighbors
    spoints(i, 1) = -radius * sin((i - 1) * a); % 计算邻域点的y坐标
    spoints(i, 2) = radius * cos((i - 1) * a);  % 计算邻域点的x坐标
end

% 获取输入图像的尺寸
[ysize, xsize] = size(image);

% 获取邻域点的最大和最小坐标值
miny = min(spoints(:, 1));
maxy = max(spoints(:, 1));
minx = min(spoints(:, 2));
maxx = max(spoints(:, 2));

% 计算每个局部区域的块大小（bsizey x bsizex）
bsizey = ceil(max(maxy, 0)) - floor(min(miny, 0)) + 1;
bsizex = ceil(max(maxx, 0)) - floor(min(minx, 0)) + 1;

% 计算块内原点坐标 (0, 0) 在图像中的位置
origy = 1 - floor(min(miny, 0));
origx = 1 - floor(min(minx, 0));

% 如果输入图像的尺寸小于最小允许尺寸，则报错
if (xsize < bsizex || ysize < bsizey)
    error('输入图像太小，图像尺寸至少应为(2*radius+1) x (2*radius+1)');
end

% 计算图像中可用的区域大小
dx = xsize - bsizex;
dy = ysize - bsizey;

% 提取图像的中心区域 C
C = image(origy:origy + dy, origx:origx + dx);
d_C = double(C);

% 初始化需要的变量
bins = 2^neighbors;  % LBP模式的总数（2的邻域数次方）
CLBP_S = zeros(dy + 1, dx + 1);  % CLBP_S结果矩阵
CLBP_M = zeros(dy + 1, dx + 1);  % CLBP_M结果矩阵
CLBP_C = zeros(dy + 1, dx + 1);  % CLBP_C结果矩阵
sumP = zeros(dy + 1, dx + 1);  % 存储每个像素点的差异

% 计算LBP代码图像
for i = 1:neighbors
    y = spoints(i, 1) + origy;
    x = spoints(i, 2) + origx;

    % 计算邻域点的像素坐标，并对其进行向下取整、向上取整和四舍五入
    fy = floor(y); cy = ceil(y); ry = round(y);
    fx = floor(x); cx = ceil(x); rx = round(x);

    % 判断是否需要插值
    if (abs(x - rx) < 1e-6) && (abs(y - ry) < 1e-6)
        % 如果不需要插值，直接使用原始数据
        N = (d_image(ry:ry + dy, rx:rx + dx)); 
        th = Mthre(ry:ry + dy, rx:rx + dx);
        D{i} = abs(N - d_C) >= abs(N - th);  % 计算二值差异
        Diff{i} = abs(N - d_C);              % 计算绝对差异
        MeanDiff(i) = mean(mean(Diff{i}));   % 计算平均差异
    else
        % 如果需要插值，则进行双线性插值计算
        ty = y - fy;
        tx = x - fx;

        % 计算四个邻域像素的插值权重
        w1 = (1 - tx) * (1 - ty);
        w2 = tx * (1 - ty);
        w3 = (1 - tx) * ty;
        w4 = tx * ty;

        % 计算插值后的像素值
        N = (w1 * d_image(fy:fy + dy, fx:fx + dx) + w2 * d_image(fy:fy + dy, cx:cx + dx) + ...
             w3 * d_image(cy:cy + dy, fx:fx + dx) + w4 * d_image(cy:cy + dy, cx:cx + dx));
        th = Mthre(ry:ry + dy, rx:rx + dx);
        D{i} = abs(N - d_C) >= abs(N - th);  % 计算二值差异
        Diff{i} = abs(N - d_C);              % 计算绝对差异
        MeanDiff(i) = mean(mean(Diff{i}));   % 计算平均差异
    end
end

% 计算CLBP_M的差异阈值
DiffThreshold = mean(MeanDiff);

% 计算CLBP_S和CLBP_M的结果
for i = 1:neighbors
    % 更新结果矩阵
    v = 2^(i - 1);
    CLBP_S = CLBP_S + v * D{i};  % 更新CLBP_S
    CLBP_M = CLBP_M + v * (Diff{i} >= DiffThreshold);  % 更新CLBP_M
end

% 计算CLBP_C
T = mean2(d_C);  % 计算中心点的平均灰度值
l_idx = find(d_C >= T);  % 找出大于平均灰度的像素索引
ll_idx = find(d_C < T);  % 找出小于平均灰度的像素索引
if (size(l_idx) >= size(ll_idx))  % 如果大于平均灰度的像素数更多
    CLBP_C(l_idx) = 1;  % 将大于平均灰度的像素赋值为1
    CLBP_C(ll_idx) = 0;  % 将小于平均灰度的像素赋值为0
else
    CLBP_C(l_idx) = 0;  % 否则将大于平均灰度的像素赋值为0
    CLBP_C(ll_idx) = 1;  % 将小于平均灰度的像素赋值为1
end

% 如果定义了映射，则应用映射
if isstruct(mapping)
    bins = mapping.num;  % 获取映射的模式数
    sizarray = size(CLBP_S);
    CLBP_S = CLBP_S(:);  % 将CLBP_S展开为一维数组
    CLBP_M = CLBP_M(:);  % 将CLBP_M展开为一维数组
    CLBP_S = mapping.table(CLBP_S + 1);  % 应用映射表
    CLBP_M = mapping.table(CLBP_M + 1);  % 应用映射表
    CLBP_S = reshape(CLBP_S, sizarray);  % 将CLBP_S重塑回原来的尺寸
    CLBP_M = reshape(CLBP_M, sizarray);  % 将CLBP_M重塑回原来的尺寸
end

% 生成CLBP_S/M/C的直方图
CLBP_MCSum = CLBP_M;
idx = find(CLBP_C);  % 找出CLBP_C中为1的像素位置
CLBP_MCSum(idx) = CLBP_MCSum(idx) + mapping.num;  % 更新CLBP_MCSum

% 计算CLBP_S和CLBP_M的联合直方图
CLBP_SMC = [CLBP_S(:), CLBP_MCSum(:)];
Hist3D = hist3(CLBP_SMC, [mapping.num, mapping.num * 2]);

% 将直方图转换为一维数组
CLBP_SMCH = reshape(Hist3D, 1, numel(Hist3D));




