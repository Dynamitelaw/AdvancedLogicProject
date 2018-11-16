
% Behavior model for LFSR1
% Producing 256 16b outputs
% MS 7/2015

clear;

reg=zeros(16,1);
reg=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
fb=zeros(16,1);
fb=[1 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1];

bw=length(fb);
n_cycle=256;
out_file = fopen('./lfsr1.results','w');

z(1) = sum(reg.*2.^(numel(reg)-1:-1:0));
for i=1:n_cycle
   fb_sum_out=0;
   xor_out=0;
   for j=1:bw
      if fb(j)==1 
         fb_sum_out=fb_sum_out+reg(j);
      end
   end
   xor_out = mod(fb_sum_out, 2);
   reg = [reg(2:bw) xor_out];
   z(i+1) = sum(reg.*2.^(numel(reg)-1:-1:0));
   fprintf(out_file,'%d\n',z(i));
end   

%finishing
fclose(out_file);
exit;

