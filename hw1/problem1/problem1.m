%% Problem 1: The Maze and the Random Minotaur 

clearvars
close all

%% Initialization

% The maze is represented as a grid of squares specified by their x and
% y-coordinates (column & row). 

% The walls of the maze are encoded as the pairs of cells that are
% separated using the format row_1, col_1, row_2, col_2.

height = 5;  % hight of the maze
width  = 6;  % width of the maze

exit_row = 5;
exit_col = 5;

num_cells = width*height;      % number of cells in the maze
num_states = num_cells^2 + 1;  % number of states, the last state is the end state (we exited the maze or got cought by the minotaur)
num_actions = 5;               % number of actions (UP, DOWN, LEFT, RIGHT, STAY)

P = cell(num_states, 1);  % initialize the transition probabilities

P{num_states} = zeros(num_states, num_actions);     % initialize the transition probabilities for end state
P{num_states}(num_states,:) = ones(1,num_actions);  % make end state absorbing

r = zeros(num_states, num_actions);  % initialize rewards

% specify the valid player actions in each square (UP DOWN LEFT RIGHT STAY)
valid_player_actions = true(height, width, num_actions);
valid_player_actions(1,:,1) = 0;       % UP    is forbidden on the first row
valid_player_actions(height,:,2) = 0;  % DOWN  is forbidden on the last row
valid_player_actions(:,1,3) = 0;       % LEFT  is not valid in the first column
valid_player_actions(:,width,4) = 0;   % RIGHT is not valid in the last column

valid_minotaur_actions = valid_player_actions;
valid_minotaur_actions(:,:,5) = 0;  % the minotaur is not allowed to STAY

% add restriction by walls for the player
valid_player_actions(1:3,2,4) = 0;     
valid_player_actions(1:3,3,3) = 0;
valid_player_actions(2:3,4,4) = 0;
valid_player_actions(2:3,5,3) = 0;
valid_player_actions(2,5:6,2) = 0;
valid_player_actions(3,5:6,1) = 0;
valid_player_actions(4,2:5,2) = 0;
valid_player_actions(5,2:5,1) = 0;
valid_player_actions(5,4,4) = 0;
valid_player_actions(5,5,3) = 0;


for s = 1:num_states-1  % fill in the transition probabilities for all states except end state
    P{s} = zeros(num_states, num_actions);
    
    [player_row, player_col, minotaur_row, minotaur_col] = decode_state(s);  % decode state into player and minotaur positions
    
    if (player_row == minotaur_row && player_col == minotaur_col)  % if the player and minotaur are in the same square
        P{s}(num_states,:) = 1;                                    % we move to end state with probability 1
    elseif (player_row == exit_row && player_col == exit_col)      % if player reached the exit square of the maze
        P{s}(num_states,:) = 1;                                    % we move to end state with probability 1
        r(s,:) = 1;                                                % any action in exit square gives a reward
    else
        
        player_actions   = find(valid_player_actions(player_row, player_col, :));
        minotaur_actions = find(valid_minotaur_actions(minotaur_row, minotaur_col, :));
        
        action_offsets   = [-1 0; 1 0; 0 -1; 0 1; 0 0];
        
        for i = 1:length(player_actions)
            
            % compute the next player row and col under action a 
            next_player_row = player_row + action_offsets(player_actions(i), 1);
            next_player_col = player_col + action_offsets(player_actions(i), 2);

            for j = 1:length(minotaur_actions)
                next_minotaur_row = minotaur_row + action_offsets(minotaur_actions(j), 1);
                next_minotaur_col = minotaur_col + action_offsets(minotaur_actions(j), 2);

                next_s = encode_state(next_player_row, next_player_col, next_minotaur_row, next_minotaur_col);
                
                P{s}(next_s, player_actions(i)) = 1/length(minotaur_actions);
            end                
        end
    end
end

%% Compute optimal policy for T = 15

T = 15;

policy = zeros(num_states, T);
V      = zeros(num_states, T);
V(:,T) = max(r,[],2);

for t = (T-1):-1:1
   for s = 1:num_states-1
       res = r(s,:)' + P{s}'*V(:,t+1);
       [val, idx] = max(res);
       V(s,t) = val;
       policy(s,t) = idx;
   end
end

disp(['Value Function:', num2str(V(29,1))])

%% Make a simulation for T=15
states = zeros(15,1);
states(1) = encode_state(1,1,5,5);  % start state
for t = 1:14
    action = policy(states(t),t);
    states(t+1) = randsample(1:num_states, 1, true, P{states(t)}(:,action));
end
figure('name', 'Simulation using obtained policy.')
plot_state(states)

%% Plot max probability of exiting the maze as function of T

T_range = 8:15;
max_prob = zeros(1,length(T_range));

for T = T_range
    V = zeros(num_states,T);
    V(:,T) = max(r,[],2);
    for t = (T-1):-1:1
       for s = 1:num_states-1
           res = r(s,:)' + P{s}'*V(:,t+1);
           V(s,t) = max(res);
       end
    end
    max_prob(T-7) = V(29,1);
end
figure
plot(T_range, max_prob);
title('Probability of exiting maze in max T steps')
xlabel('T')

%% Policy minimizing time to exit the maze.

% value iteration with lambda 29/30

% Discount factor
lambda = 29 / 30;

epsilon = 0.0001;
n = 0;
v0 = zeros(num_states, 1);
v1 = ones(num_states, 1);
policy = zeros(num_states, 1);

v0_vec = v0; 
policy_vec = policy;

while max(abs(v1-v0)) >= epsilon*(1-lambda)/(2*lambda)
    n = n+1;
    v1 = v0;
    for s=1:num_states
        tmp_s = r(s, :)' + lambda*P{s}'*v1;
        [v0(s), policy(s)] = max(tmp_s);
    end
    
    v0_vec = [v0_vec v0]; %#ok<*AGROW>
    policy_vec = [policy_vec policy];
            
    if n>50000
        break;
    end
end

%% Make a simulation
states = zeros(15,1);
states(1) = 29;  % start state
for t = 1:14
    action = policy(states(t));
    states(t+1) = randsample(1:num_states, 1, true, P{states(t)}(:,action));
end
figure('name', 'Simulation using policy minimizing the time to exit.')
plot_state(states)
