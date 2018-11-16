
% Test for write_enable, write_in of F_node

clear;

n_cycle=256;
n_cycle = n_cycle + 1; %adding initialization
z = zeros(17,n_cycle);
z(:,1) = 0;

for i = 1:17
out_file = fopen(['./F_node1_' num2str(i) '.results'],'w');
    if i == 1
        for j=2:n_cycle
           z(i,j) = round(rand);
           fprintf(out_file,'%d\n',z(i,j));
        end   
    else
        for j=2:n_cycle
           if z(1,j) == 1
               z(i,j) = floor(rand*1000);
           else
               z(i,j) = z(i,j - 1);
           end
           fprintf(out_file,'%d\n',z(i,j));
        end 
    end
fclose(out_file);

end
exit;
