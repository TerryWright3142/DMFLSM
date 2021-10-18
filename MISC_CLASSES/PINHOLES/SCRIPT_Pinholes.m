%Script Airy disk error analysis
m = 23.9;
pins = CPinholeAnalysis(0.55, 0.85, m, 200, 0.1, 200, 0.1, 0.5);
pins.SetSensor(6.5, 6.5, 0,0);
pins.DrawSensor();

score = StrehlScore(20);
fprintf('best score = %d \n',pins.ApplyStatistic(score));
%%
% %%
% num = 30;
% x_vals = zeros(1, num);
% y_vals = zeros(1, num);
% scores = zeros(1, num);
% score  = StrehlScore(20);
% for cnt = 1:num
%     fprintf('%d\n', cnt);
%     x_vals(cnt) = rand()*6.5 - 3.25;
%     y_vals(cnt) = rand()*6.5 - 3.25;
%     pins.SetSensor(6.5, 6.5, x_vals(cnt), y_vals(cnt));
%     pins.DrawSensor();
%     drawnow();
%     scores(cnt) = pins.ApplyStatistic(score);
%  
% end
% 
% hist(scores);
% %%
% csvwrite('results.csv', [x_vals', y_vals',  scores']);
%% 
score = StrehlScore(20);
pins.ApplyStatistic(score)

%%
pins.FindSensorPixellationNoise(score);
%%
%vallidate for an actual image
