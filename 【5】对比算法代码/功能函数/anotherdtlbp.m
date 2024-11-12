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

function [CLBP_S,CLBP_M,CLBP_C] = DTLBP(Gray,radius,neighbors,mapping,mode) % image,radius,neighbors,mapping,mode)


image=Gray;
d_image=double(image);

%可取中心点为（4,4）-（125,125）
origy=4; 
origx=4;
dx = 121;
dy = 121;


C = image(origx:origx+dx,origy:origy+dy);
d_C = double(C);

bins = 2^neighbors;

% Initialize the result matrix with zeros.
CLBP_S=zeros(dx+1,dy+1);
CLBP_M=zeros(dx+1,dy+1);
CLBP_C=zeros(dx+1,dy+1);

%Compute the LBP code image

for i = 4:125   %4-125
    for j=4:125
      
    yi=(d_image(i,j+1)+d_image(i,j+2)+d_image(i,j+3))/3;
    er=(d_image(i-1,j+1)+d_image(i-2,j+2)+d_image(i-3,j+3))/3;
    san=(d_image(i-1,j)+d_image(i-2,j)+d_image(i-3,j))/3;
    si=(d_image(i-1,j-1)+d_image(i-2,j-2)+d_image(i-3,j-3))/3;
    wu=(d_image(i,j-1)+d_image(i,j-2)+d_image(i,j-3))/3;
    liu=(d_image(i+1,j-1)+d_image(i+2,j-2)+d_image(i+3,j-3))/3;
    qi=(d_image(i+1,j)+d_image(i+2,j)+d_image(i+3,j))/3;
    ba=(d_image(i+1,j+1)+d_image(i+2,j+2)+d_image(i+3,j+3))/3;
    zhaodian=[yi,er,san,si,wu,liu,qi,ba];
    N=zhaodian>=d_image(i,j);
    s=0;
    for k=1:7  %计算跳变
        if N{k}~=N{k+1}
            s=s+1;
        end
        if k == 7
            if N{1}~=N{8}
                s=s+1;
            end
        end
    end
    co = 0;
    if s<=2  %满足统一模式的取补码
        for l=1:8
            if N{l}==1
                co=co+1;
            end
        end
        buma=8-co;
    end
    if buma<=co
        N=~N;
    end
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
CLBP_C = d_C>=mean(d_image(:));

%Apply mapping if it is defined
if isstruct(mapping)
    bins = mapping.num;
    sizarray = size(CLBP_S);
    CLBP_S = CLBP_S(:);
    CLBP_M = CLBP_M(:);
    CLBP_S = mapping.table(CLBP_S+1);
    CLBP_M = mapping.table(CLBP_M+1);
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

if (strcmp(mode,'h') || strcmp(mode,'hist') || strcmp(mode,'nh'))
    % Return with LBP histogram if mode equals 'hist'.
    CLBP_S=hist(CLBP_S(:),0:(bins-1));
    CLBP_M=hist(CLBP_M(:),0:(bins-1));
    if (strcmp(mode,'nh'))
        CLBP_S=CLBP_S/sum(CLBP_S);
        CLBP_M=CLBP_M/sum(CLBP_M);
    end
else
%     %Otherwise return a matrix of unsigned integers
%     if ((bins-1)<=intmax('uint8'))
%         CLBP_S=uint8(CLBP_S);
%         CLBP_M=uint8(CLBP_M);
%     elseif ((bins-1)<=intmax('uint16'))
%         CLBP_S=uint16(CLBP_S);
%         CLBP_M=uint16(CLBP_M);
%     else
%         CLBP_S=uint32(CLBP_S);
%         CLBP_M=uint32(CLBP_M);
%     end
end






