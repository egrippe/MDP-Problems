function plot_state(s)
% Plot the state of the game.

assert(1<=s&&s<=256)

% decode states of player and police
s_player = floor((s-1) / 16);
s_police = mod((s-1), 16);

% decode coordinates of player 
x_player = mod(s_player, 4);
y_player = floor(s_player / 4);

% decode coordinates of police
x_police = mod(s_police, 4);
y_police = floor(s_police / 4);

axis([0 4 0 4])
set(gca,'xtick',0:4)
set(gca,'ytick',0:4)
set(gca,'Ydir','reverse')
set(gca,'XtickLabel',[],'YtickLabel',[]);
hold on
grid on

rectangle('Position', [x_player, y_player, 1, 1], 'facecolor', 'g');
rectangle('Position', [x_police, y_police, 1, 1], 'facecolor', 'r');

end


