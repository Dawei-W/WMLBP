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
% ���������
% Gray: ����ĻҶ�ͼ��
% radius: LBP���ӵİ뾶
% neighbors: LBP���ӵ��������
% mapping: LBPӳ��ṹ������ģʽ��ӳ���
% Mthre: ���ڼ���CLBPģʽ����ֵ����

% ������ĻҶ�ͼ��ת��Ϊdouble���ͣ��Ա������ֵ����
image = Gray;
d_image = double(image);

% ��ʼ���������������
spoints = zeros(neighbors, 2);

% ����ÿ�������ĽǶȣ��������ȷֲ���Բ����
a = 2 * pi / neighbors; % ÿ�������֮��ĽǶ�

for i = 1:neighbors
    spoints(i, 1) = -radius * sin((i - 1) * a); % ����������y����
    spoints(i, 2) = radius * cos((i - 1) * a);  % ����������x����
end

% ��ȡ����ͼ��ĳߴ�
[ysize, xsize] = size(image);

% ��ȡ������������С����ֵ
miny = min(spoints(:, 1));
maxy = max(spoints(:, 1));
minx = min(spoints(:, 2));
maxx = max(spoints(:, 2));

% ����ÿ���ֲ�����Ŀ��С��bsizey x bsizex��
bsizey = ceil(max(maxy, 0)) - floor(min(miny, 0)) + 1;
bsizex = ceil(max(maxx, 0)) - floor(min(minx, 0)) + 1;

% �������ԭ������ (0, 0) ��ͼ���е�λ��
origy = 1 - floor(min(miny, 0));
origx = 1 - floor(min(minx, 0));

% �������ͼ��ĳߴ�С����С����ߴ磬�򱨴�
if (xsize < bsizex || ysize < bsizey)
    error('����ͼ��̫С��ͼ��ߴ�����ӦΪ(2*radius+1) x (2*radius+1)');
end

% ����ͼ���п��õ������С
dx = xsize - bsizex;
dy = ysize - bsizey;

% ��ȡͼ����������� C
C = image(origy:origy + dy, origx:origx + dx);
d_C = double(C);

% ��ʼ����Ҫ�ı���
bins = 2^neighbors;  % LBPģʽ��������2���������η���
CLBP_S = zeros(dy + 1, dx + 1);  % CLBP_S�������
CLBP_M = zeros(dy + 1, dx + 1);  % CLBP_M�������
CLBP_C = zeros(dy + 1, dx + 1);  % CLBP_C�������
sumP = zeros(dy + 1, dx + 1);  % �洢ÿ�����ص�Ĳ���

% ����LBP����ͼ��
for i = 1:neighbors
    y = spoints(i, 1) + origy;
    x = spoints(i, 2) + origx;

    % �����������������꣬�������������ȡ��������ȡ������������
    fy = floor(y); cy = ceil(y); ry = round(y);
    fx = floor(x); cx = ceil(x); rx = round(x);

    % �ж��Ƿ���Ҫ��ֵ
    if (abs(x - rx) < 1e-6) && (abs(y - ry) < 1e-6)
        % �������Ҫ��ֵ��ֱ��ʹ��ԭʼ����
        N = (d_image(ry:ry + dy, rx:rx + dx)); 
        th = Mthre(ry:ry + dy, rx:rx + dx);
        D{i} = abs(N - d_C) >= abs(N - th);  % �����ֵ����
        Diff{i} = abs(N - d_C);              % ������Բ���
        MeanDiff(i) = mean(mean(Diff{i}));   % ����ƽ������
    else
        % �����Ҫ��ֵ�������˫���Բ�ֵ����
        ty = y - fy;
        tx = x - fx;

        % �����ĸ��������صĲ�ֵȨ��
        w1 = (1 - tx) * (1 - ty);
        w2 = tx * (1 - ty);
        w3 = (1 - tx) * ty;
        w4 = tx * ty;

        % �����ֵ�������ֵ
        N = (w1 * d_image(fy:fy + dy, fx:fx + dx) + w2 * d_image(fy:fy + dy, cx:cx + dx) + ...
             w3 * d_image(cy:cy + dy, fx:fx + dx) + w4 * d_image(cy:cy + dy, cx:cx + dx));
        th = Mthre(ry:ry + dy, rx:rx + dx);
        D{i} = abs(N - d_C) >= abs(N - th);  % �����ֵ����
        Diff{i} = abs(N - d_C);              % ������Բ���
        MeanDiff(i) = mean(mean(Diff{i}));   % ����ƽ������
    end
end

% ����CLBP_M�Ĳ�����ֵ
DiffThreshold = mean(MeanDiff);

% ����CLBP_S��CLBP_M�Ľ��
for i = 1:neighbors
    % ���½������
    v = 2^(i - 1);
    CLBP_S = CLBP_S + v * D{i};  % ����CLBP_S
    CLBP_M = CLBP_M + v * (Diff{i} >= DiffThreshold);  % ����CLBP_M
end

% ����CLBP_C
T = mean2(d_C);  % �������ĵ��ƽ���Ҷ�ֵ
l_idx = find(d_C >= T);  % �ҳ�����ƽ���Ҷȵ���������
ll_idx = find(d_C < T);  % �ҳ�С��ƽ���Ҷȵ���������
if (size(l_idx) >= size(ll_idx))  % �������ƽ���Ҷȵ�����������
    CLBP_C(l_idx) = 1;  % ������ƽ���Ҷȵ����ظ�ֵΪ1
    CLBP_C(ll_idx) = 0;  % ��С��ƽ���Ҷȵ����ظ�ֵΪ0
else
    CLBP_C(l_idx) = 0;  % ���򽫴���ƽ���Ҷȵ����ظ�ֵΪ0
    CLBP_C(ll_idx) = 1;  % ��С��ƽ���Ҷȵ����ظ�ֵΪ1
end

% ���������ӳ�䣬��Ӧ��ӳ��
if isstruct(mapping)
    bins = mapping.num;  % ��ȡӳ���ģʽ��
    sizarray = size(CLBP_S);
    CLBP_S = CLBP_S(:);  % ��CLBP_Sչ��Ϊһά����
    CLBP_M = CLBP_M(:);  % ��CLBP_Mչ��Ϊһά����
    CLBP_S = mapping.table(CLBP_S + 1);  % Ӧ��ӳ���
    CLBP_M = mapping.table(CLBP_M + 1);  % Ӧ��ӳ���
    CLBP_S = reshape(CLBP_S, sizarray);  % ��CLBP_S���ܻ�ԭ���ĳߴ�
    CLBP_M = reshape(CLBP_M, sizarray);  % ��CLBP_M���ܻ�ԭ���ĳߴ�
end

% ����CLBP_S/M/C��ֱ��ͼ
CLBP_MCSum = CLBP_M;
idx = find(CLBP_C);  % �ҳ�CLBP_C��Ϊ1������λ��
CLBP_MCSum(idx) = CLBP_MCSum(idx) + mapping.num;  % ����CLBP_MCSum

% ����CLBP_S��CLBP_M������ֱ��ͼ
CLBP_SMC = [CLBP_S(:), CLBP_MCSum(:)];
Hist3D = hist3(CLBP_SMC, [mapping.num, mapping.num * 2]);

% ��ֱ��ͼת��Ϊһά����
CLBP_SMCH = reshape(Hist3D, 1, numel(Hist3D));




