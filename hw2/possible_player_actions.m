function actions = possible_player_actions(s)
% 

% decode states of player
s_player = floor((s-1) / 16);

% decode coordinates of player 
x_player = mod(s_player, 4);
y_player = floor(s_player / 4);

actions = false(5,1);  
actions(1) = true;  % player can always stay
if (x_player > 0); actions(2) = true; end  % player can go left
if (x_player < 3); actions(3) = true; end  % player can go right
if (y_player > 0); actions(4) = true; end  % player can go up
if (y_player < 3); actions(5) = true; end  % player can go down

end

