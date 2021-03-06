clear

addpath('./NN');
addpath('./mnistHelper');
addpath('./data');

% Load MNIST data and change inputs to binaray
load_data;
cutoff = 0.5;
train_images = train_images >= 0.5;
test_images = test_images >= 0.5;

% Load saved weights and biases
W1 = importdata('W1.mat');
W3 = importdata('W3.mat');
B1 = importdata('B1.mat');
B3 = importdata('B3.mat');

% Instantiate and test network
batchsize = 250;
nodes = 32;
nn = Network(batchsize);

nn.layers{1} = Linear(28 * 28, nodes, batchsize);
nn.layers{2} = ReLU(nodes, nodes, batchsize);
nn.layers{3} = Linear(nodes, 10, batchsize);
nn.layers{4} = Softmax(10, 10, batchsize);

nn.layers{1}.W = W1;
nn.layers{1}.b = B1;
nn.layers{3}.W = W3;
nn.layers{3}.b = B3;

%nn.test(test_images, test_labels);
%disp(nn.percent_correct);



%Get test images

Inputs_file = fopen('./Inputs.results','w');

for i = 1:20
    for j = 1:size(test_images,2)
        fprintf(Inputs_file,'%d',test_images(i,j));
    end
    fprintf(Inputs_file,'\n');
end

fclose(Inputs_file)