%%
HOME = xlsread('HOME_Dataset'); 
AWAY = xlsread('Away_Dataset');
%% 
% Extract sample mean shots and points for each player for HOME games
playerIds = HOME(:,1);
[uniquePlayerIds,idx,id] = unique(playerIds,'stable'); %find all the unique players for the sample sizes
playersCount = length(uniquePlayerIds);
SAMPLES_HOME = zeros(playersCount,2);
for i=1:playersCount
    player = uniquePlayerIds(i);
    playerDataStartIdx = idx(i);
    if (i == playersCount)
        playerDataEndIdx = length(HOME);
    else
        playerDataEndIdx = idx(i+1) - 1;
    end
    
    playerShots = HOME(playerDataStartIdx:playerDataEndIdx,2);
    playerPoints = HOME(playerDataStartIdx:playerDataEndIdx,3);
    
    SAMPLES_HOME(i,1) = mean(playerShots);
    SAMPLES_HOME(i,2) = mean(playerPoints);
end

%% 
% Extract sample mean shots and points for each player for AWAY games
playerIds = AWAY(:,1);
[uniquePlayerIds,idx,id] = unique(playerIds,'stable'); %find all the unique players for the sample sizes
playersCount = length(uniquePlayerIds);
SAMPLES_AWAY = zeros(playersCount,2);
for i=1:playersCount
    player = uniquePlayerIds(i);
    playerDataStartIdx = idx(i);
    if (i == playersCount)
        playerDataEndIdx = length(AWAY);
    else
        playerDataEndIdx = idx(i+1) - 1;
    end
    
    playerShots = AWAY(playerDataStartIdx:playerDataEndIdx,2);
    playerPoints = AWAY(playerDataStartIdx:playerDataEndIdx,3);
    
    SAMPLES_AWAY(i,1) = mean(playerShots);
    SAMPLES_AWAY(i,2) = mean(playerPoints);
end
%%
homeShotsData = SAMPLES_HOME(:,1);
homePointsData = SAMPLES_HOME(:,2);
awayShotsData = SAMPLES_AWAY(:,1);
awayPointsData = SAMPLES_AWAY(:,2);

figure
histogram(homeShotsData)
title('Average Shots taken at Home by all players')
figure
histogram(homePointsData)
title('Average Points made at Home by all players')
figure
histogram(awayShotsData)
title('Average Shots taken Away by all players')
figure
histogram(awayPointsData)
title('Average Points made Away by all players')

%%
% Perform paired t test
fprintf('\nPaired t test:');
fprintf('\nComparing average shots taken by players in home and away games');
[paired_shotsHypothesis,paired_shotsPValue] = ttest(homeShotsData,awayShotsData);
fprintf('\nHypothesis output = %i , P value = %f',paired_shotsHypothesis,paired_shotsPValue);

fprintf('\nComparing average points made players in home and away games');
[paired_pointsHypothesis,paired_pointsPValue] = ttest(homePointsData,awayPointsData);
fprintf('\nHypothesis output = %i , P value = %f',paired_pointsHypothesis,paired_pointsPValue);
%% 
% Perform 2 sample t test

fprintf('\n\n2 Sample t test:');
fprintf('\nComparing average shots taken by players in home and away games');
[twoSample_shotsHypothesis,twoSample_shotsPValue] = ttest2(homeShotsData,awayShotsData);
fprintf('\nHypothesis output = %i , P value = %f',twoSample_shotsHypothesis,twoSample_shotsPValue);

fprintf('\nComparing average points made players in home and away games');
[twoSample_pointsHypothesis,twoSample_pointsPValue] = ttest2(homePointsData,awayPointsData);
fprintf('\nHypothesis output = %i , P value = %f',twoSample_pointsHypothesis,twoSample_pointsPValue);
