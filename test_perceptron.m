tot_trials = 50;
success = zeros(tot_trials,1);
for trial = 1:tot_trials
    run('perceptron.m')
    load('perceptron.mat')
    s = length(SAMPLES); tot = 0;
    for i = 0:4
        tot = tot + length(SAMPLES{s-i,1});
    end
    W = [w1;w2;w3]; b = b0;
    n = length(effects(:,1));
    test_set = effects(n-tot+1:n,:);
    shots = SHOT(n-tot+1:n);
    estimate = zeros(size(shots));
    for i = 1:length(test_set)
        x = test_set(i,:)';
        y = p(W,x,b);
        estimate(i) = f(y);
    end
    idx = 1:tot;
    i_diff = idx(shots == estimate);
    success(trial) = length(i_diff)/tot;

    clear i s x y
end
%%
histogram(success,25)
title(['Success of the Linear Classifier of n = ', num2str(tot_trials)])
xlabel(['\mu_{success} = ',num2str(round(mean(success)*100,2)),'%'])