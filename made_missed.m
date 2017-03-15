%import useful data from data.xlsx file
MADE = xlsread('made'); MISSED = xlsread('missed');
[tot_made,n] = size(MADE);
[tot_missed,m] = size(MISSED);

%Non-normalized data will be in capital letters
%SHOT = MADE(:,4); %binary information of the shot (make/miss::1/0)
PLAYER1 = MADE(:,6); PLAYER2 = MISSED(:,6); %iD information of the player shooting
CLOCK1 = MADE(:,1); CLOCK2 = MISSED(:,1);
DISTANCE1 = MADE(:,2); DISTANCE2 = MISSED(:,2);
COVERAGE1 = MADE(:,3); COVERAGE2 = MISSED(:,3); %to analyze them independently
EFFECTS1 = MADE(:,1:3); EFFECTS2 = MISSED(:,1:3); %the proposed effects on the outcome all in one matrix (just in case)

%finding the expected values and standard deviation of the effects on shot
%accuracy
CLOCK = [CLOCK1;CLOCK2];
if any(isnan(CLOCK))
    N = 1:1:length(CLOCK);
    i_nan = N(isnan(CLOCK));
    for i = 1:length(i_nan)
        CLOCK(i_nan(i)) = 0;
    end
    clear i
end
%the clock values without any NaN
CLOCK1 = CLOCK(1:tot_made); CLOCK2 = CLOCK(tot_made+1:tot_made+tot_missed);
EFFECTS1(:,1) = CLOCK1; EFFECTS2(:,1) = CLOCK2;
save effects.mat EFFECTS1 EFFECTS2

%using the overall data of the proposed effects to find the mean and std to
%normalize
clock_data = [mean(CLOCK1) std(CLOCK1);mean(CLOCK2) std(CLOCK2)];
distance_data = [mean(DISTANCE1) std(DISTANCE1);mean(DISTANCE2) std(DISTANCE2)];
coverage_data = [mean(COVERAGE1) std(COVERAGE1);mean(COVERAGE2) std(COVERAGE2)];
save mean_std.mat clock_data distance_data coverage_data

%% 
[diff_players,i_switch,id] = unique(PLAYER1,'stable'); %find all the unique players for the sample sizes
MADE_SAMPLES = cell(length(diff_players),(n - 1)); %creates cell array to store independent samples

%This seperates the total data set into indepent data sample sets in a cell
%array! Each sample set will have a different number of samples. From left
%to right, the columns carry the same information as the original data set.
for i = 1:length(diff_players)
    for j = 1:n
        if i == length(diff_players)
            k0 = i_switch(i); k1 = tot_made;
        else
            k0 = i_switch(i); k1 = i_switch(i+1) - 1;
        end
        if j <= 3
            MADE_SAMPLES{i,j} = EFFECTS1(k0:k1,j);
            MADE_SAMPLES{i,j} = MADE(k0:k1,j);
        end
    end
end
clear i j
[diff_players,i_switch,id] = unique(PLAYER2,'stable'); %find all the unique players for the sample sizes
MISSED_SAMPLES = cell(length(diff_players),(m - 1)); %creates cell array to store independent samples

%This seperates the total data set into indepent data sample sets in a cell
%array! Each sample set will have a different number of samples. From left
%to right, the columns carry the same information as the original data set.
for i = 1:length(diff_players)
    for j = 1:m
        if i == length(diff_players)
            k0 = i_switch(i); k1 = tot_missed;
        else
            k0 = i_switch(i); k1 = i_switch(i+1) - 1;
        end
        if j <= 3
            MISSED_SAMPLES{i,j} = EFFECTS2(k0:k1,j);
            MISSED_SAMPLES{i,j} = MISSED(k0:k1,j);
        end
    end
end
clear i j
save made.mat MADE_SAMPLES
save missed.mat MISSED_SAMPLES

