function ave_dark = MTH(image,N) 
%% �ж�ͼ��ֿ��Ƿ����� ��������� ��ͼ���Ե���
xxx=0;
n0=1;
[ox,oy]=size(image);
M=2^((N+n0)-1);
px=ceil(ox/M)*M;
py=ceil(oy/M)*M;

if ox==px&&oy==py
   img=image;
   x=ox;
   y=oy;
else
   xxx=1; 
   x=px;
   y=py;
   img = padarray(image,[px-ox py-oy],'replicate','post');
end

dark=zeros(x,y,N);
ave_dark=zeros(x,y);

%% ��ֲ���ֵ
for n=1:N
    nn=n+n0-1;%���ڲ���
    nx=x/2^(nn-1);
    ny=y/2^(nn-1);
    d = ones(nx, ny);
    fun = @(block_struct) mean(mean(block_struct.data)) * d;
    dark(:,:,n) = blockproc(img, [nx, ny], fun);
    ave_dark=ave_dark+dark(:,:,n);
    
end
ave_dark=ave_dark/N;
%% ���ͼ�񾭹����,��ԭͼ�� 
if xxx==1
    ave_dark=ave_dark(1:ox,1:oy);
end

end