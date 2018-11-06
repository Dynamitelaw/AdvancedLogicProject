clear

addpath('./NN');
addpath('./mnistHelper');
addpath('./data');

load_data;

epochs = 10;
batchsize = 250;
learning_rate = 1e-3;
iters_per_epoch = 1000;
pcorr = zeros(1,epochs);



smooth_loss = log(10);

% ~ 98 % correct
nodes = [20]; 
pcorr_max = zeros(1,length(nodes));
figure(4)
hold on
for i = 1:length(nodes)

nn = Network(batchsize);
nn.layers{1} = Linear(28 * 28, nodes(i), batchsize);
nn.layers{2} = ReLU(nodes(i), nodes(i), batchsize);
nn.layers{3} = Linear(nodes(i), 10, batchsize);
nn.layers{4} = Softmax(10, 10, batchsize);

for e=1:1:epochs

    fprintf('Epoch %d...\n', e);
    
    for ii=1:1:iters_per_epoch

    	nn.train(train_images, train_labels, learning_rate);
    	smooth_loss = [smooth_loss smooth_loss(end) * 0.99 + 0.01 * nn.loss/batchsize];
    
    end

    nn.test(test_images, test_labels);
    
    pcorr(e) = nn.percent_correct;
    
    
%     figure();
%     plot(smooth_loss);
%     drawnow

end
pcorr_max(i) = max(pcorr);
scatter(nodes(i),pcorr_max(i))

end
hold off



    