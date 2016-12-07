function new_s = next_state(s,a)
% Compute the next state of the game.

assert(1<=s && s<=256 && 1<=a && a<=5)

% decode states of player and police
s_player = floor((s-1) / 16);
s_police = mod((s-1), 16);

% decode coordinates of player 
x_player = mod(s_player, 4);
y_player = floor(s_player / 4);

% decode coordinates of police
x_police = mod(s_police, 4);
y_police = floor(s_police / 4);

% define possible actions for the police
actions_police = false(5,1);  
actions_police(1) = false;  % the police always moves
if (x_police > 0); actions_police(2) = true; end  % police can go left
if (x_police < 3); actions_police(3) = true; end  % police can go right
if (y_police > 0); actions_police(4) = true; end  % police can go up
if (y_police < 3); actions_police(5) = true; end  % police can go down

% select an action randomly for the police
a_police = randsample(find(actions_police),1);

moves = [0 0; -1 0; 1 0; 0 -1; 0 1];

% compute new positions of player and police
new_x_player = x_player + moves(a,1);
new_y_player = y_player + moves(a,2);
new_x_police = x_police + moves(a_police,1);
new_y_police = y_police + moves(a_police,2);

new_s = (new_x_player + new_y_player*4) * 16 ...
      + (new_x_police + new_y_police*4) ...
      + 1;
end

