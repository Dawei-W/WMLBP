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

function [CLBP_S,CLBP_M,CLBP_C] = GIDTLBPd1b(Gray,radius,neighbors,mapping,mode) % image,radius,neighbors,mapping,mode)
% Version 0.2
% Authors: Zhenhua Guo, Lei Zhang, and David Zhang

% The implementation is based on lbp code from MVG, Oulu University, Finland
% http://www.ee.oulu.fi/mvg/page/lbp_matlab


% Check number of input arguments.


image=Gray;
d_image=double(image);


    
    spoints=zeros(neighbors,2);

    % Angle step.
    a = 2*pi/neighbors;
    
    for i = 1:neighbors
        spoints(i,1) = -radius*sin((i-1)*a);
        spoints(i,2) = radius*cos((i-1)*a);
    end


% Determine the dimensions of the input image.
[ysize xsize] = size(image);



miny=min(spoints(:,1));
maxy=max(spoints(:,1));
minx=min(spoints(:,2));
maxx=max(spoints(:,2));

% Block size, each LBP code is computed within a block of size bsizey*bsizex
bsizey=ceil(max(maxy,0))-floor(min(miny,0))+1;
bsizex=ceil(max(maxx,0))-floor(min(minx,0))+1;

% Coordinates of origin (0,0) in the block
origy=1-floor(min(miny,0));
origx=1-floor(min(minx,0));

% Minimum allowed size for the input image depends
% on the radius of the used LBP operator.
if(xsize < bsizex || ysize < bsizey)
  error('Too small input image. Should be at least (2*radius+1) x (2*radius+1)');
end

% Calculate dx and dy;
dx = xsize - bsizex;
dy = ysize - bsizey;

% Fill the center pixel matrix C.
C = image(origy:origy+dy,origx:origx+dx);
d_C = double(C);

bins = 2^neighbors;

% Initialize the result matrix with zeros.
CLBP_S=zeros(dy+1,dx+1);
CLBP_M=zeros(dy+1,dx+1);
CLBP_C=zeros(dy+1,dx+1);

%Compute the LBP code image

for i = 1:neighbors
  y = spoints(i,1)+origy;
  x = spoints(i,2)+origx;
  % Calculate floors, ceils and rounds for the x and y.
  fy = floor(y); cy = ceil(y); ry = round(y);
  fx = floor(x); cx = ceil(x); rx = round(x);
  % Check if interpolation is needed.
  if (abs(x - rx) < 1e-6) && (abs(y - ry) < 1e-6)
    % Interpolation is not needed, use original datatypes  
    switch i
        case 1
            N = (d_image(ry:ry+dy,rx:rx+dx).*d_image(ry:ry+dy,rx-1:rx+dx-1).*d_image(ry:ry+dy,rx-2:rx+dx-2));
        case 3
            N = (d_image(ry:ry+dy,rx:rx+dx).*d_image(ry+1:ry+dy+1,rx:rx+dx).*d_image(ry+2:ry+dy+2,rx:rx+dx));
        case 5
            N = (d_image(ry:ry+dy,rx:rx+dx).*d_image(ry:ry+dy,rx+1:rx+dx+1).*d_image(ry:ry+dy,rx+2:rx+dx+2));
        case 7
            N = (d_image(ry:ry+dy,rx:rx+dx).*d_image(ry-1:ry+dy-1,rx:rx+dx).*d_image(ry-2:ry+dy-2,rx:rx+dx));
    end
    N = power(N,1/3);
    D{i} = N >= d_C;   
    Diff{i} = abs(N-d_C);     %g rp = xp-xc              
    MeanDiff(i) = mean(mean(Diff{i}));  
    
  else
     
    % Interpolation needed, use double type images 
    ty = y - fy;
    tx = x - fx;

    % Calculate the interpolation weights.
    w1 = (1 - tx) * (1 - ty);
    w2 =      tx  * (1 - ty);
    w3 = (1 - tx) *      ty ;
    w4 =      tx  *      ty ;
    % Compute interpolated pixel values
    switch i
        case 2
                N = ((w1*d_image(fy:fy+dy,fx:fx+dx) + w2*d_image(fy:fy+dy,cx:cx+dx) + ...
                    w3*d_image(cy:cy+dy,fx:fx+dx) + w4*d_image(cy:cy+dy,cx:cx+dx)).* ...
                    (w1*d_image(fy+1:fy+dy+1,fx-1:fx+dx-1) + w2*d_image(fy+1:fy+dy+1,cx-1:cx+dx-1) + ...
                    w3*d_image(cy+1:cy+dy+1,fx-1:fx+dx-1) + w4*d_image(cy+1:cy+dy+1,cx-1:cx+dx-1)).* ...
                    (w1*d_image(fy+2:fy+dy+2,fx-2:fx+dx-2) + w2*d_image(fy+2:fy+dy+2,cx-2:cx+dx-2) + ...
                    w3*d_image(cy+2:cy+dy+2,fx-2:fx+dx-2) + w4*d_image(cy+2:cy+dy+2,cx-2:cx+dx-2)));
        case 4
                N = ((w1*d_image(fy:fy+dy,fx:fx+dx) + w2*d_image(fy:fy+dy,cx:cx+dx) + ...
                    w3*d_image(cy:cy+dy,fx:fx+dx) + w4*d_image(cy:cy+dy,cx:cx+dx)).* ...
                    (w1*d_image(fy+1:fy+dy+1,fx+1:fx+dx+1) + w2*d_image(fy+1:fy+dy+1,cx+1:cx+dx+1) + ...
                    w3*d_image(cy+1:cy+dy+1,fx+1:fx+dx+1) + w4*d_image(cy+1:cy+dy+1,cx+1:cx+dx+1)).* ...
                    (w1*d_image(fy+2:fy+dy+2,fx+2:fx+dx+2) + w2*d_image(fy+2:fy+dy+2,cx+2:cx+dx+2) + ...
                    w3*d_image(cy+2:cy+dy+2,fx+2:fx+dx+2) + w4*d_image(cy+2:cy+dy+2,cx+2:cx+dx+2)));
        case 6
                N = ((w1*d_image(fy:fy+dy,fx:fx+dx) + w2*d_image(fy:fy+dy,cx:cx+dx) + ...
                    w3*d_image(cy:cy+dy,fx:fx+dx) + w4*d_image(cy:cy+dy,cx:cx+dx)).* ...
                    (w1*d_image(fy-1:fy+dy-1,fx+1:fx+dx+1) + w2*d_image(fy-1:fy+dy-1,cx+1:cx+dx+1) + ...
                    w3*d_image(cy-1:cy+dy-1,fx+1:fx+dx+1) + w4*d_image(cy-1:cy+dy-1,cx+1:cx+dx+1)).* ...
                    (w1*d_image(fy-2:fy+dy-2,fx+2:fx+dx+2) + w2*d_image(fy-2:fy+dy-2,cx+2:cx+dx+2) + ...
                    w3*d_image(cy-2:cy+dy-2,fx+2:fx+dx+2) + w4*d_image(cy-2:cy+dy-2,cx+2:cx+dx+2)));
        case 8
                N = ((w1*d_image(fy:fy+dy,fx:fx+dx) + w2*d_image(fy:fy+dy,cx:cx+dx) + ...
                    w3*d_image(cy:cy+dy,fx:fx+dx) + w4*d_image(cy:cy+dy,cx:cx+dx)).* ...
                    (w1*d_image(fy-1:fy+dy-1,fx-1:fx+dx-1) + w2*d_image(fy-1:fy+dy-1,cx-1:cx+dx-1) + ...
                    w3*d_image(cy-1:cy+dy-1,fx-1:fx+dx-1) + w4*d_image(cy-1:cy+dy-1,cx-1:cx+dx-1)).* ...
                    (w1*d_image(fy-2:fy+dy-2,fx-2:fx+dx-2) + w2*d_image(fy-2:fy+dy-2,cx-2:cx+dx-2) + ...
                    w3*d_image(cy-2:cy+dy-2,fx-2:fx+dx-2) + w4*d_image(cy-2:cy+dy-2,cx-2:cx+dx-2)));
    end     
    N = power(N,1/3);
    D{i} = N >= d_C;   
    Diff{i} = abs(N-d_C);                   
    MeanDiff(i) = mean(mean(Diff{i}));  

  end  
end
% Difference threshold for CLBP_M
DiffThreshold = mean(MeanDiff);
% compute CLBP_S and CLBP_M
for i=1:neighbors
  % Update the result matrix.
  v = 2^(i-1);
  CLBP_S = CLBP_S + v*D{i};
  CLBP_M = CLBP_M + v*(Diff{i}>=DiffThreshold);
end
% CLBP_C
% CLBP_C = d_C>=mean(d_image(:));
%  A = d_C>=mean2(d_C);
%  B = d_C<mean2(d_C);
%  CLBP_C=bitxor(A,B);

T = mean2(d_C);%���ĵ��ƽ���Ҷ�
l_idx = find(d_C >= T);%�ҳ�����ƽ���Ҷȵ�����λ������
ll_idx = find(d_C < T);%�ҳ�С��ƽ���Ҷȵ�����λ������
if (size(l_idx) >= size(ll_idx))%�������ƽ���Ҷȵ�����������С����С�ڵ�������С
    CLBP_C(l_idx) = 1;%C_result�д���ƽ���Ҷȵ�ֵΪ1
    CLBP_C(ll_idx) = 0;%C_result��С��ƽ���Ҷȵ�ֵΪ0
else
    CLBP_C(l_idx) = 0;%C_result�д���ƽ���Ҷȵ�ֵΪ0
    CLBP_C(ll_idx) = 1;%C_result��С��ƽ���Ҷȵ�ֵΪ1
end
%Apply mapping if it is defined
if isstruct(mapping)
    bins = mapping.num;
    bins1 = mapping.num1;
    sizarray = size(CLBP_S);
    CLBP_S = CLBP_S(:);
    CLBP_M = CLBP_M(:);
    CLBP_S = mapping.table(CLBP_S+1);
    CLBP_M = mapping.table1(CLBP_M+1);
    CLBP_S = reshape(CLBP_S,sizarray);
    CLBP_M = reshape(CLBP_M,sizarray);
    % % another implementation method
%     for i = 1:size(CLBP_S,1)
%         for j = 1:size(CLBP_S,2)
%             CLBP_S(i,j) = mapping.table(CLBP_S(i,j)+1);
%             CLBP_M(i,j) = mapping.table(CLBP_M(i,j)+1);
%         end
%     end
end
    % Generate histogram of CLBP_S/M/C
    CLBP_MCSum = CLBP_M;
    idx = find(CLBP_C);
    CLBP_MCSum(idx) = CLBP_MCSum(idx)+mapping.num1;
    CLBP_SMC = [CLBP_S(:),CLBP_MCSum(:)];
    Hist3D = hist3(CLBP_SMC,[mapping.num,mapping.num1*2]);
    CLBP_SMCH(i,:) = reshape(Hist3D,1,numel(Hist3D));
end






