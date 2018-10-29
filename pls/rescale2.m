function rx = rescale(x,mx,stdx)
[m,n] = size(x);
if nargin == 3
  rx  = (x.*stdx(ones(m,1),:))+mx(ones(m,1),:);
else
  rx  = x+mx(ones(m,1),:);
end