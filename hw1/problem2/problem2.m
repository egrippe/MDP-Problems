%% Problem 2: Robbing Banks

clearvars
close all

% The player starts at bank 1 (cell 1), the police at the police station
% (cell 9), thus the starting state = 9;
%
% The police always chases the thief and moves in the thiefs direction.
% 
%
% Map:
%      x 1   2   3   4   5   6   
%    y   ------------------------
%    1  |B1 |   |   |   |   |B4 |
%    2  |   |   |PS |   |   |   |
%    3  |B2 |   |   |   |   |B3 |
%        -----------------------
%   where Bi, is the 4 banks and PS the police station
%
%   The 

rows = 3;
cols = 6;
num_cells = rows*cols;
num_states = num_cells^2;

start_state = 9;

num_actions = 5;
offsets = [0 -1; 0 1; -1 0; 1 0; 0 0];

P = cell(num_states,1);
r = zeros(num_states);

for s = 1:num_states
    P{s} = zeros(num_states, num_actions);       % initialize transition probabilities for state s
    
    [t_s, p_s, t_x, t_y, p_x, p_y] = decode(s);  % decode the states of the thief and police
    
    if (t_s == p_s)                              % the police has caught the thief
        P{s}(start_state,:) = 1;                 % we move to the start state
        r(s) = -50;                              % we loose 50$
        continue
    elseif (ismember(t_s, [1,6,13,18]))  % the thief is robbing a bank
        r(s) = 10;                               % we steal 10$ 
    end
    
    for i = 1:num_actions
        new_t_x = t_x + offsets(i,1);
        new_t_y = t_y + offsets(i,2);
        
        if new_t_x < 1 || new_t_x > cols || new_t_y < 1 || new_t_y > rows
            continue
        end
        
        p_actions = 0;
        for j = 1:4
            if (sign(t_x - p_x) == sign(offsets(j,1)) && offsets(j,2) == 0) ... 
                    || (sign(t_y - p_y) == sign(offsets(j,2)) && offsets(j,1) == 0)
               p_actions = p_actions + 1;
            end
        end
        
        for j = 1:4
            if (sign(t_x - p_x) == sign(offsets(j,1)) && offsets(j,2) == 0) ... 
                    || (sign(t_y - p_y) == sign(offsets(j,2)) && offsets(j,1) == 0)
               new_p_x = p_x + offsets(j,1);
               new_p_y = p_y + offsets(j,2);
               new_s = encode(new_t_x, new_t_y, new_p_x, new_p_y);
               P{s}(new_s,i) = 1 / p_actions;
            end    
        end
    end
end

%% Obtain optimal policy using Value Iteration

epsilon = 0.01;
lambda  = 0.8;

n = 0;
v0 = zeros(num_states, 1);
v1 = ones(num_states, 1);
policy = zeros(num_states, 1);

while max(abs(v1-v0)) >= epsilon*(1-lambda)/(2*lambda)
    n = n + 1;
    v1 = v0;
    for s = 1:num_states
        tmp_s = r(s)' + lambda*P{s}'*v1;
        [v0(s), policy(s)] = max(tmp_s);
    end
end

value_convergence = n;  % iterations required for convergence of value function


%% Simulate the system using our obtained policy

T = 20;  % num of timesteps to simulate
state_vec = zeros(T,1);  % vetor containing the history of states 
state_vec(1) = start_state;
for t = 1:T
    a = policy(state_vec(t));  % choose an action according to our policy
    state_vec(t+1) = randsample(1:num_states, 1, true, P{state_vec(t)}(:,a));  % compute the next state
end
figure('name', 'Simulation.')
plot_states(state_vec)


