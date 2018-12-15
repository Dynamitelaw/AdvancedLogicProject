clear

addpath('./NN');
addpath('./mnistHelper');
addpath('./data');

load_data;

epochs = 30;
batchsize = 250;
learning_rate = 1e-3;
iters_per_epoch = 1000;
pcorr = zeros(1,epochs);

smooth_loss = log(10);

cutoff = [0.5];
nodes = [16];
pcorr_max = zeros(length(nodes),length(cutoff));
pcorr_mean = zeros(length(nodes),length(cutoff));
% figure(4)
% hold on

% Reducing precision
w1_precision = 1;
w2_precision = 1;

%Empty container to store results and training weights
AllContainers = containers.Map(1, 1, 'UniformValues', false);
remove(AllContainers,1);

for j = 1:length(nodes)
    for i = 1:length(cutoff)
        disp('=============');
        printBuffer = ['Starting: ', num2str(i + (j - 1)*length(cutoff)),' out of ', num2str(length(cutoff)*length(nodes))];
        disp(printBuffer);
        printBuffer = ['Cutoff = ',num2str(cutoff(i)),'  Nodes = ',num2str(nodes(j))];
        disp(printBuffer);
        %keep track of max accuracy
        maxAccuracy = 0;
        
        %Temp storage for trained weights for this topology (only for linear
        %layers)
        Wlayer1 = {};
        Wlayer3 = {};
        
        nn = Network(batchsize);
        nn.layers{1} = Linear(28 * 28, nodes(j), batchsize);
        nn.layers{2} = ReLU(nodes(j), nodes(j), batchsize);
        nn.layers{3} = Linear(nodes(j), 10, batchsize);
        nn.layers{4} = Softmax(10, 10, batchsize);
        
        train_images = train_images >= cutoff(i);
        test_images = test_images >= cutoff(i);
        
        for e=1:1:epochs
            
           
            
            for ii=1:1:iters_per_epoch
                
                nn.train(train_images, train_labels, learning_rate);
                smooth_loss = [smooth_loss smooth_loss(end) * 0.99 + 0.01 * nn.loss/batchsize];
                
            end
            
            % Reduce precision of weights
%             nn.layers{1}.W = round(nn.layers{1}.W,w1_precision);
%             nn.layers{3}.W = round(nn.layers{3}.W,w3_precision);
%             nn.layers{1}.b = round(nn.layers{1}.b,w1_precision);
%             nn.layers{3}.b = round(nn.layers{3}.b,w3_precision);
%             w1 = nn.layers{1}.W;
            
%             % Sum of weights
%             psum = max(sum(((w1 > 0).*w1),2));
%             nsum = max(abs(sum(((w1 < 0).*w1),2)));
%             max_sum = max(psum,nsum);
%             
%             pm = max(max((w1 > 0).*w1));
%             nm = max(max(abs((w1 < 0).*w1)));
            
            
             % Re-initialize weights 
%             if max_sum > 51 || pm > 0.7 || nm > 0.8       % 10 bits in 2's compliment for sum, 5 for weights
%                 nn.layers{1}.W = randn(16, 28*28) * 0.1;
% %                 disp('continue')
%                 continue
%             end
            nn_normed = Network(batchsize);
            nn_normed.layers{1} = Linear(28 * 28, nodes(j), batchsize);
            nn_normed.layers{2} = ReLU(nodes(j), nodes(j), batchsize);
            nn_normed.layers{3} = Linear(nodes(j), 10, batchsize);
            nn_normed.layers{4} = Softmax(10, 10, batchsize);
            %norm first layer weight
            pos1 = nn.layers{1}.W.*(nn.layers{1}.W >= 0);
            neg1 = nn.layers{1}.W.*(nn.layers{1}.W < 0);
            pos1 = pos1./(max(max(pos1)))*0.7;
            neg1 = neg1./(max(max(abs(neg1))))*0.8;
            nn_normed.layers{1}.W = round((pos1 + neg1),w1_precision);
            %norm first layer weight
            pos2 = nn.layers{3}.W.*(nn.layers{3}.W >= 0);
            neg2 = nn.layers{3}.W.*(nn.layers{3}.W < 0);
            pos2 = pos2./(max(max(pos2)))*0.7;
            neg2 = neg2./(max(max(abs(neg2))))*0.8;
            nn_normed.layers{3}.W = round((pos2 + neg2),w2_precision);
            
            
            nn_normed.layers{1}.b = nn.layers{1}.b;
            nn_normed.layers{3}.b = nn.layers{3}.b;
            
            nn_normed.test(test_images, test_labels);
            disp(nn_normed.percent_correct);
            pcorr(e) = nn_normed.percent_correct;
            
            
            %printBuffer = ['Accuracy: ', num2str(nn.percent_correct),'   Max sum of weights: ', num2str(max_sum),'   Max weight: ', num2str(max(max(abs(nn.layers{1}.W))))];
            %disp(printBuffer);
            
            %If we have a new best accuracy, store it's weights
            if pcorr(e) > maxAccuracy
                maxAccuracy = pcorr(e);
                
                Wlayer1 = nn.layers{1}.W;
                Wlayer3 = nn.layers{3}.W;
            end
            
            
            
        end
        pcorr_max(j,i) = max(pcorr);
        pcorr_mean(j,i) = mean(pcorr);
        
        % Store best trained weights and best accuracy
        keySet = {'Accuracy', 'Layer1Weights','Layer3Weights'};
        valueSet = {maxAccuracy, Wlayer1, Wlayer3};
        topologyContainer = containers.Map(keySet, valueSet, 'UniformValues', false);
        
        AllContainers(cutoff(i)) = topologyContainer;
        
        printBuffer = ['Ending: ', num2str(i + (j - 1)*length(cutoff)),' out of ', num2str(length(cutoff)*length(nodes))];
        disp(printBuffer);
%         printBuffer = ['Cutoff = ',num2str(cutoff(i)),'  Nodes = ',num2str(nodes(j))];
%         disp(printBuffer);
        printBuffer = ['Max Accuracy = ', num2str(maxAccuracy)];
        disp(printBuffer);
        printBuffer = ['Mean Accuracy = ', num2str(pcorr_mean(j,i))];
        disp(printBuffer);
        disp('=============');
    end
end