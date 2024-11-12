function ave_dark = MTH(image, N) 
%% 判断图像分块是否整除，如果不整除，则对图像边缘进行填充
xxx = 0;  % 标志变量，用于判断是否进行填充
n0 = 1;   % 调节参数，控制分块的大小
[ox, oy] = size(image);  % 获取输入图像的尺寸 (ox: 图像行数, oy: 图像列数)
M = 2^((N + n0) - 1);    % 基于分层数N计算分块的大小
px = ceil(ox / M) * M;   % 计算需要填充后的图像行数（向上取整为M的倍数）
py = ceil(oy / M) * M;   % 计算需要填充后的图像列数（向上取整为M的倍数）

% 如果图像尺寸已经是M的倍数，则无需填充
if ox == px && oy == py
   img = image;  % 不需要填充，直接使用原始图像
   x = ox;  % 图像的行数
   y = oy;  % 图像的列数
else
   xxx = 1;  % 设置标志位，表示图像需要填充
   x = px;  % 填充后的图像行数
   y = py;  % 填充后的图像列数
   img = padarray(image, [px - ox, py - oy], 'replicate', 'post');  % 在图像的右边和下边填充复制像素
end

% 初始化用于存储分块计算结果的数组
dark = zeros(x, y, N);  % 3D数组用于存储每一层次的结果
ave_dark = zeros(x, y);  % 用于存储所有层次的平均值

%% 计算分层阈值
for n = 1:N
    nn = n + n0 - 1;  % 调节参数，控制层次的变化
    nx = x / 2^(nn - 1);  % 计算每个块的行数，随着层次增加，块的尺寸逐渐减小
    ny = y / 2^(nn - 1);  % 计算每个块的列数，随着层次增加，块的尺寸逐渐减小
    d = ones(nx, ny);  % 初始化一个全为1的矩阵，用于后续的计算
    fun = @(block_struct) mean(mean(block_struct.data)) * d;  % 定义一个函数，用于计算每个分块的均值，并乘以全1矩阵d
    dark(:,:,n) = blockproc(img, [nx, ny], fun);  % 使用blockproc函数对图像进行分块处理，计算每个分块的均值
    ave_dark = ave_dark + dark(:,:,n);  % 将当前层次的计算结果累加到ave_dark
end

ave_dark = ave_dark / N;  % 计算所有层次的平均值

%% 如果图像进行了填充，则恢复原始图像的尺寸
if xxx == 1
    ave_dark = ave_dark(1:ox, 1:oy);  % 去除填充区域，恢复到原图的尺寸
end

end
