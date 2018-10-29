function [mcx,mx] = mncn2(x)
[m,~] = size(x);
mx    = mean(x);
mcx   = (x-mx(ones(m,1),:));
end