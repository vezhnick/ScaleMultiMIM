function [iknorm,ik] = calc_lz_ik(v1,v2)
% author: Alberto Giovanni Busetto
% CALC_IK estimates Validated Model Information through Lempel-Ziv coding
% 
% INPUT:
%        v1,v2:	 integer vectors; symbolic values labeled sequentially from n to m, m>n
% OUTPUT:
%	 ik:     estimation of the absolute information through Lempel-Ziv coding
%        iknorm: normalized bit rate (that is, k/(n/log2(n))), where n=length(svect)

v1=v1(:);
v2=v2(:);
% concatenation
v=[v1;v2];
nv=length(v1);

% estimate K(v1)
[~,k1]=calc_lz_k(v1);
% estimate K(v2)
[~,k2]=calc_lz_k(v2);
% estimate K for the concatenation
[~,k12]=calc_lz_k(v);
ik=k1+k2-k12;
% normalization (bit rate)
iknorm=ik*log2(nv)/nv;

end

