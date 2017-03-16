%import useful data from data.xlsx file
DATA = xlsread('data');
[tot_samples,inputs] = size(DATA);

%Non-normalized data will be in capital letters
SHOT = DATA(:,4); %binary information of the shot (make/miss::1/0)
PLAYER = DATA(:,6); %iD information of the player shooting
CLOCK = DATA(:,1); DISTANCE = DATA(:,2); COVERAGE = DATA(:,3); %to analyze them independently
EFFECTS = DATA(:,1:3); %the proposed effects on the outcome all in one matrix (just in case)

%finding the expected values and standard deviation of the effects on shot
%accuracy
if any(isnan(CLOCK))
    N = 1:1:length(CLOCK);
    i_nan = N(isnan(CLOCK));
    for i = 1:length(i_nan)
        CLOCK(i_nan(i)) = 0;
    end
    clear i
end
EFFECTS(:,1) = CLOCK; %this is the data without any NaN values

%using the overall data of the proposed effects to find the mean and std to
%normalize
clock_data = [mean(CLOCK) std(CLOCK)];
distance_data = [mean(DISTANCE) std(DISTANCE)];
coverage_data = [mean(COVERAGE) std(COVERAGE)];

%normalized data
clock = (CLOCK - clock_data(1))./clock_data(2);
distance = (DISTANCE - distance_data(1))./distance_data(2);
coverage = (COVERAGE - coverage_data(1))./coverage_data(2);
effects = [clock,distance,coverage];
p_MADE = sum(SHOT)/tot_samples; %probability that the shot was made

%% 
[diff_players,i_switch,id] = unique(PLAYER,'stable'); %find all the unique players for the sample sizes
SAMPLES = cell(length(diff_players),(inputs - 1)); %creates cell array to store independent samples

%This seperates the total data set into indepent data sample sets in a cell
%array! Each sample set will have a different number of samples. From left
%to right, the columns carry the same information as the original data set.
for i = 1:length(diff_players)
    for j = 1:inputs
        if i == length(diff_players)
            k0 = i_switch(i); k1 = tot_samples;
        else
            k0 = i_switch(i); k1 = i_switch(i+1) - 1;
        end
        if j <= 3
            SAMPLES{i,j} = effects(k0:k1,j); %using normalized data in the samples
        else
            SAMPLES{i,j} = DATA(k0:k1,j);
        end
    end
end
clear i j

save total.mat SAMPLES EFFECTS effects SHOT