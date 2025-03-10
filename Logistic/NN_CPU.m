clc;clear;close all;


%% Synthesize Data of Target Dynamics
demo_index=2;
xTrain=load(sprintf('%s/Logistic/data/gd_%d_kw.mat',pwd,demo_index)).X1;

%dim=2;
KW_N=4;
xTrain1=sum(xTrain(KW_N*(1-1)+1:KW_N*1,:));
xTrain2=sum(xTrain(KW_N*(2-1)+1:KW_N*2,:));

x0 = xTrain(:,1);

numTimeSteps = size(xTrain,2);
t_end=100;
dt=1e-2;
t = dt:dt:t_end;
%% Define and Initialize Model Parameters
neuralOdeParameters = struct;

stateSize = size(xTrain,1);
hiddenSize = 12;

neuralOdeParameters.fc1 = struct;
sz = [hiddenSize stateSize];
neuralOdeParameters.fc1.Weights = initializeGlorot(sz, hiddenSize, stateSize,'single');
neuralOdeParameters.fc1.Bias = initializeZeros([hiddenSize 1]);

neuralOdeParameters.fc2 = struct;
sz = [hiddenSize hiddenSize];
neuralOdeParameters.fc2.Weights = initializeGlorot(sz, hiddenSize, stateSize,'single');
neuralOdeParameters.fc2.Bias = initializeZeros([hiddenSize 1]);

neuralOdeParameters.fc3 = struct;
sz = [stateSize hiddenSize];
neuralOdeParameters.fc3.Weights = initializeGlorot(sz, stateSize, hiddenSize,'single');
neuralOdeParameters.fc3.Bias = initializeZeros([stateSize 1]);
%neuralOdeParameters=load(sprintf('%s/Logistic/data/neuralOdeParameters_%d.mat',pwd,demo_index)).neuralOdeParameters;

%% Specify Training Options
%neuralOdeTimesteps=200;learnRate=0.02;miniBatchSize=100;numIter=2e4
%neuralOdeTimesteps=200;learnRate=2e-3;miniBatchSize=100;numIter=2e4
%neuralOdeTimesteps=800;learnRate=5e-4;miniBatchSize=100;numIter=1e4
%neuralOdeTimesteps=2000;learnRate=5e-4;miniBatchSize=100;numIter=1e3

neuralOdeTimesteps = 500;
timesteps = (0:neuralOdeTimesteps)*dt;

% Adam optimization
gradDecay = 0.9;
sqGradDecay = 0.999;
%2e-3
learnRate = 1e-3;

%Train for 1200 iterations with a mini-batch-size of 200
numIter = 1e3;
miniBatchSize = 100;

%绘图频率
plotFrequency = 2e3;

%% Train Model Using Custom Training Loop

% Initialize the averageGrad and averageSqGrad parameters for the Adam solver
averageGrad = [];
averageSqGrad = [];

% Initialize the TrainingProgressMonitor object.
monitor = trainingProgressMonitor(Metrics="Loss",Info=["Iteration","LearnRate"],XLabel="Iteration");

% Train the network using a custom training loop.
numTrainingTimesteps = numTimeSteps;
plottingTimesteps = 2:numTimeSteps;

iteration = 0;
vel=[];

loss_list=zeros(1,numIter);
while iteration < numIter && ~monitor.Stop
    iteration = iteration + 1;

    % Create batch
    [X, targets] = createMiniBatch(numTrainingTimesteps,neuralOdeTimesteps,miniBatchSize,xTrain);
    

    % Evaluate network and compute loss and gradients
    [loss,gradients] = dlfeval(@modelLoss,timesteps,X,neuralOdeParameters,targets);
    loss_list(iteration) = extractdata(loss);

    % Update network adamupdate
    [neuralOdeParameters,averageGrad,averageSqGrad] = adamupdate(neuralOdeParameters,gradients,averageGrad,averageSqGrad,iteration,...
        learnRate,gradDecay,sqGradDecay);

%     [neuralOdeParameters,vel] = sgdmupdate(neuralOdeParameters,gradients,vel,learnRate);
    % Plot loss
    recordMetrics(monitor,iteration,Loss=loss);

    % Plot predicted vs. real dynamics
    if mod(iteration,plotFrequency) == 0  || iteration == 1
        % Use ode45 to compute the solution 
        y = dlode45(@odeModel,t,dlarray(x0),neuralOdeParameters,DataFormat="CB");
        y = extractdata(y(:,1,:));
        y = reshape(y,size(y,1),size(y,3));
       
        y_2_org1=sum(y(KW_N*(1-1)+1:KW_N*1,:));
        y_2_org2=sum(y(KW_N*(2-1)+1:KW_N*2,:));
        
        t1=1:1:size(xTrain1,2);
        t2=1:1:size(y_2_org1,2);
        
        subplot(1,2,1);
        plot(t1,xTrain1,"b--",t2,y_2_org1,'r-');
        xlabel("t")
        ylabel("x(t)")

        subplot(1,2,2);
        plot(t1,xTrain2,"b--",t2,y_2_org2,'r-');
        xlabel("t")
        ylabel("y(t)")
        legend("Training Ground Truth", "Predicted")

        drawnow;
    end
    updateInfo(monitor,Iteration=iteration,LearnRate=learnRate);
    monitor.Progress = 100*iteration/numIter;
end
save(sprintf('%s/Logistic/data/neuralOdeParameters_%d.mat',pwd,demo_index),'loss_list','neuralOdeParameters');

%% Model Function
function X = model(tspan,X0,neuralOdeParameters)

    X = dlode45(@odeModel,tspan,X0,neuralOdeParameters,DataFormat="CB");

end

%% ODE Model
function y = odeModel(~,y,theta)

    y = tanh(theta.fc1.Weights*y + theta.fc1.Bias);
    y = tanh(theta.fc2.Weights*y + theta.fc2.Bias);
    y = theta.fc3.Weights*y + theta.fc3.Bias;

end

%% Model Loss Function
function [loss,gradients] = modelLoss(tspan,X0,neuralOdeParameters,targets)
    dim=2;
    GK_N=4;
    
    % Compute predictions.
    X = model(tspan,X0,neuralOdeParameters);
    
    x_2_org=dlarray(zeros(dim,size(X,2),size(X,3)));
    targets_2_org=x_2_org;
    for i=1:dim
        x_2_org(i,:,:) = sum(X(GK_N*(i-1)+1:GK_N*i,:,:));
        targets_2_org(i,:,:)  = sum(targets(GK_N*(i-1)+1:GK_N*i,:,:));
    end
    
    % Compute L2 loss.
    loss1 = l2loss(X,targets,NormalizationFactor="all-elements",DataFormat="CBT");
    loss2 = l2loss(x_2_org,targets_2_org,NormalizationFactor="all-elements",DataFormat="CBT");
    
    loss = loss1+loss2;
    % Compute gradients.
    gradients = dlgradient(loss,neuralOdeParameters);

end

%%Create Mini-Batches Function
function [x0, targets] = createMiniBatch(numTimesteps,numTimesPerObs,miniBatchSize,X)
    % Create batches of trajectories.
    s = randperm(numTimesteps - numTimesPerObs, miniBatchSize);
    
    x0 = dlarray(X(:, s));
    targets = zeros([size(X,1) miniBatchSize numTimesPerObs]);
    
    for i = 1:miniBatchSize
        targets(:, i, 1:numTimesPerObs) = X(:, s(i) + 1:(s(i) + numTimesPerObs));
    end

end


%% parameters init function
function weights = initializeGlorot(sz,numOut,numIn,className)

    arguments
        sz
        numOut
        numIn
        className = 'single'
    end
    
    Z = 2*rand(sz,className) - 1;
    bound = sqrt(6 / (numIn + numOut));
    
    weights = bound * Z;
    weights = dlarray(weights);

end

function parameter = initializeZeros(sz,className)

    arguments
        sz
        className = 'single'
    end
    
    parameter = zeros(sz,className);
    parameter = dlarray(parameter);

end