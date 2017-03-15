load('missed.mat'); load('made.mat');
decision = zeros(length(MADE_SAMPLES),3);
p_value = zeros(size(decision));
for i = 1:length(MADE_SAMPLES)
    for j = 1:3
        x = MADE_SAMPLES{i,j};
        y = MISSED_SAMPLES{i,j};
        [h,p] = ttest2(x,y);
        decision(i,j) = h;
        p_value(i,j) = p;
    end
end

clear h i j p

figure(1)
subplot(3,1,1)
histogram(p_value(:,1),50)
title('p values of Game Clock')
subplot(3,1,2)
histogram(p_value(:,2),50)
title('p values of Distance from the Hoop')
subplot(3,1,3)
histogram(p_value(:,3),50)
title('p values of Defensive Coverage')

d1 = [sum(decision(:,1)) length(decision(:,1))-sum(decision(:,1))];
d2 = [sum(decision(:,2)) length(decision(:,2))-sum(decision(:,2))];
d3 = [sum(decision(:,3)) length(decision(:,3))-sum(decision(:,3))];
d = [d1;d2;d3];
figure(2)
bar(d,'stacked')
title('H_{0}: \mu_{made} = \mu_{missed} assuming independent normal distributions')
legend('reject the null hypothesis','do not reject the null hypothesis')
