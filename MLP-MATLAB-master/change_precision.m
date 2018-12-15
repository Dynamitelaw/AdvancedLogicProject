
for i=1:10
w1 = 2*(rand(3) - 0.5);

wp = (w1 > 0).*w1;
wn = abs((w1 < 0).*w1);

psum = sum(wp,2);
nsum = sum(wn,2);

psum_m = max(psum);
nsum_m = max(nsum);
max_sum = max(psum_m,nsum_m);
disp(max_sum)
end