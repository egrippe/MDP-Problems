%% Homework 2: Bank Robbing
close all
clearvars

%% Initialize Model

S = 256;  % number of states
A = 5;    % number of actions

r = zeros(S,1);  % rewards, only dependent of state

for s = 1:S
    
    % decode states of player and police
    s_player = floor((s-1) / 16);
    s_police = mod((s-1), 16);
    
    if s_player == s_police  % the police arrests us
        r(s) = -10;
    elseif s_player == 5     % player is at the bank
        r(s) = 1;
    end
    
end

% define the possible actions in each state
possible_actions = false(S,A);
for s = 1:S
    possible_actions(s,:) = possible_player_actions(s); 
end


%% Learn Q-function

N = 5e6;           % number of iterations
Q = zeros(S,A);    % Q-function, initialized to 0

M = 10000;         % stepsize for storing V-values
V = zeros(S,N/M);  % V-function

% to keep track on the number of updates of each (s,a) pair.
num_updates = zeros(S,A);  

s = 16;          % initial state (player:(1,1) police:(4,4))
lambda = 0.8;    % discount factor

for n = 1:N
    
    pa = possible_actions(s,:);
    
    % 1: select an action randomly for the player
    a = randsample(find(pa),1);
    
    % 2: compute next state
    next_s = next_state(s,a);
    
    alpha = 1 / (num_updates(s,a)^(2/3) + 1);  % learning rate  
    
    % update Q
    pa = possible_actions(next_s,:);
    Q(s,a) = Q(s,a) + alpha*(r(s) + lambda*max(Q(next_s, pa)) - Q(s,a));
    
    num_updates(s,a) = num_updates(s,a) + 1;
    
    % store value function for each state every M iteration
    if mod(n,M) == 0
        for s = 1:S
            V(s,n/M) = max(Q(s, possible_actions(s,:)));
        end
    end
    s = next_s;
end

%% Plot convergence

figure
states = randsample(S,30);
%states = [1,18,35,86,137];
%states = [35];

%subplot(1,2,1)
plot(1:M:N,V(states,:)')
title('Q-learning convergence for 30 random states')
xlabel('Iteration')
ylabel('Value')



%% Simulate run using policy obtained from Q-function

T = 20;  % timesteps to simulate

s = zeros(T,1);
s(1) = 16;  % starting state

for t = 1:T-1
    % choose player action
    [~, a] = max(Q(s(t),:));
    % compute next state
    s(t+1) = next_state(s(t),a);
end

% plot simulation results
figure
for t = 1:T
    subplot(4,5,t)
    plot_state(s(t))
    title(['T=', num2str(t)])
end


%% Learn with SARSA

N = 5e6;         % number of iterations
Q = zeros(S,A);  % Q-function, initialized to 0

M = 10000;         % stepsize for storing V-values
V = zeros(S,N/M);  % V-function

% to keep track on the number of updates of each (s,a) pair.
num_updates = zeros(S,A);  

s = 16;          % initial state (player:(1,1) police:(4,4))
lambda = 0.8;    % discount factor
e = 0.1;         % probability of chosing action at random

for n = 1:N
    
    % 1: select action according to e-greedy policy
    pa = find(possible_actions(s,:));  % vector with possible action
    if rand() > e
        % we choose action with highest Q-value
        [~, idx] = max(Q(s,pa));
        a_n = pa(idx);
    else
        % we choose action uniformly at random
        a_n = randsample(pa,1); 
    end
    
    % 2: compute next state
    s_n1 = next_state(s, a_n);
    
    pa = find(possible_actions(s_n1,:));
    if rand() > e
        % we choose action with highest Q-value
        [~, idx] = max(Q(s_n1,pa));
        a_n1 = pa(idx);
    else
        % we choose action uniformly at random
        a_n1 = randsample(pa,1); 
    end
    
    alpha = 1 / (num_updates(s,a_n)^(2/3) + 1);  % learning rate  
    
    % update Q
    Q(s,a_n) = Q(s,a_n) + alpha*(r(s) + lambda*(Q(s_n1, a_n1)) - Q(s, a_n));
    
    num_updates(s,a_n) = num_updates(s,a_n) + 1;
    
    % store value function for each state every M iteration
    if mod(n,M)==0
        for s = 1:S
            V(s,n/M) = max(Q(s, possible_actions(s,:)));
        end
    end
    
    s = s_n1;
end

%% Plot convergence

figure
states = randsample(S,30);

%subplot(1,2,1)
plot(1:M:N,V(states,:)')
title(['SARSA-learning convergence for 30 random states (e=',num2str(e),')'])
xlabel('Iteration')
ylabel('Value')

