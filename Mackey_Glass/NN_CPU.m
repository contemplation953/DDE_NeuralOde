clc;clear;close all;


%% Synthesize Data of Target Dynamics
demo_index=2;
xTrain=load(sprintf('%s/Mackey_Glass/data/mg_origin_%d_kw.mat',pwd,demo_index)).X1;

x0 = xTrain(:,1);

numTimeSteps = size(xTrain,2);
t_end=10;
dt=1e-3;
t = dt:dt:t_end;
%% Define and Initialize Model Parameters
% neuralOdeParameters = struct;
% 
% stateSize = size(xTrain,1);
% hiddenSize = 16;
% 
% neuralOdeParameters.fc1 = struct;
% sz = [hiddenSize stateSize];
% neuralOdeParameters.fc1.Weights = initializeGlorot(sz, hiddenSize, stateSize,'single');
% neuralOdeParameters.fc1.Bias = initializeZeros([hiddenSize 1]);
% 
% neuralOdeParameters.fc2 = struct;
% sz = [hiddenSize hiddenSize];
% neuralOdeParameters.fc2.Weights = initializeGlorot(sz, hiddenSize, stateSize,'single');
% neuralOdeParameters.fc2.Bias = initializeZeros([hiddenSize 1]);
% 
% neuralOdeParameters.fc3 = struct;
% sz = [stateSize hiddenSize];
% neuralOdeParameters.fc3.Weights = initializeGlorot(sz, stateSize, hiddenSize,'single');
% neuralOdeParameters.fc3.Bias = initializeZeros([stateSize 1]);
neuralOdeParameters=load(sprintf('%s/Mackey_Glass/data/neuralOdeParameters_%d.mat',pwd,demo_index)).neuralOdeParameters;

%% Specify Training Options
neuralOdeTimesteps = 2000;
timesteps = (0:neuralOdeTimesteps)*dt;

% Adam optimization
gradDecay = 0.9;
sqGradDecay = 0.999;
%2e-3
learnRate =1e-3;

%Train for 1200 iterations with a mini-batch-size of 200
numIter = 1e3;
miniBatchSize = 100;

%绘图频率
plotFrequency = 200;

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

while iteration < numIter && ~monitor.Stop
    iteration = iteration + 1;

    % Create batch
    [X, targets] = createMiniBatch(numTrainingTimesteps,neuralOdeTimesteps,miniBatchSize,xTrain);
    

    % Evaluate network and compute loss and gradients
    [loss,gradients] = dlfeval(@modelLoss,timesteps,X,neuralOdeParameters,targets);

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
        y = sum(y(:,:));
        plot(1:size(xTrain,2),sum(xTrain),"r--")

        hold on
        plot(1:size(y,2),y,"b-")
        hold off

        xlabel("x(1)")
        ylabel("x(2)")
        title("Predicted vs. Real Dynamics")
        legend("Training Ground Truth", "Predicted")

        drawnow;
    end
    updateInfo(monitor,Iteration=iteration,LearnRate=learnRate);
    monitor.Progress = 100*iteration/numIter;
end
save(sprintf('%s/Mackey_Glass/data/neuralOdeParameters_%d.mat',pwd,demo_index),'neuralOdeParameters');

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

    % Compute predictions.
    X = model(tspan,X0,neuralOdeParameters);
    
    
    % Compute L2 loss.
    loss1 = l2loss(X,targets,NormalizationFactor="all-elements",DataFormat="CBT");
    loss2 = l2loss(sum(X),sum(targets),NormalizationFactor="all-elements",DataFormat="CBT");
    
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