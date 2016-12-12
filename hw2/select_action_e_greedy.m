function action = select_action_e_greedy(s,Q,e)
% Select a action according to the e-greedy policy
% Params:
%   s   The current state
%   Q   Q-function
%   e   value specifying the probability of choosing action randomly

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

if rand() > e
    % we choose action with highest Q-value
    [~, action] = max(Q(s,:));
    if actions(action)
       return
    end
end

% we choose action uniformly at random
action = randsample(find(actions),1); 

end

