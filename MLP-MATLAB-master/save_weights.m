% Load saved weights and biases
W1 = importdata('W1.mat');
W2 = importdata('W3.mat');
B1 = importdata('B1.mat');
B2 = importdata('B3.mat');

W1_file = fopen('./W1.results','w');
W2_file = fopen('./W2.results','w');
B1_file = fopen('./B1.results','w');
B2_file = fopen('./B2.results','w');

for i = 1:size(W1,2)
    for j = 1:size(W1,1)
        fprintf(W1_file,'%d\n',W1(j,i));
    end
end

for i = 1:size(W2,2)
    for j = 1:size(W2,1)
        fprintf(W2_file,'%d\n',W2(j,i));
    end
end
    

for i = 1:length(B1)
        fprintf(B1_file,'%d\n',B1(i));
end

for i = 1:length(B2)
        fprintf(B2_file,'%d\n',B2(i));
end

fclose(W1_file);
fclose(W2_file);
fclose(B1_file);
fclose(B2_file);