%% Homework 2: Bank Robbing
close all
clear

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
    elseif s_player == 5     % we are at the bank
        r(s) = 1;
    end
    
end

%% Learn Q-function

N = 1e6;         % number of iterations
Q = zeros(S,A);  % Q-function, initialized to 0
V = zeros(S,N);  % V-function

% to keep track on the number of updates of each (s,a) pair.
num_updates = zeros(S,A);  

s = 16;          % initial state (player:(1,1) police:(4,4))
lambda = 0.8;    % discount factor

for n = 1:N
    
    % decode states of player and police
    s_player = floor((s-1) / 16);
    
    % decode coordinates of player 
    x_player = mod(s_player, 4);
    y_player = floor(s_player / 4);
    
    % 1: choose action with uniform probability
    %a = select_action(s);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % define the possible actions in this state
    % actions = 1:stay, 2:left, 3:right, 4:left, 5:right
    actions = false(5,1);  
    actions(1) = true;  % player can always stay
    if (x_player > 0); actions(2) = true; end  % player can go left
    if (x_player < 3); actions(3) = true; end  % player can go right
    if (y_player > 0); actions(4) = true; end  % player can go up
    if (y_player < 3); actions(5) = true; end  % player can go down
    
    % select an action randomly for the player
    a = randsample(find(actions),1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % 2: compute next state
    next_s = next_state(s,a);
    
    alpha = 1 / (num_updates(s,a)^(2/3) + 1);  % learning rate  
    
    % update Q
    Q(s,a) = Q(s,a) + alpha*(r(s) + lambda*max(Q(next_s,:)) - Q(s,a));
    
    num_updates(s,a) = num_updates(s,a) + 1;
    
    V(:,n) = max(Q,[],2);
    
    s = next_s;
end

%% Plot convergence

figure
states = randsample(S,30);

%subplot(1,2,1)
plot(V(states,:)')
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

N = 1e6;         % number of iterations
Q = zeros(S,A);  % Q-function, initialized to 0
V = zeros(S,N);  % V-function

% to keep track on the number of updates of each (s,a) pair.
num_updates = zeros(S,A);  

s = 16;          % initial state (player:(1,1) police:(4,4))
lambda = 0.8;    % discount factor
e = 0.1;

for n = 1:N
    
    % decode states of player and police
    s_player = floor((s-1) / 16);
    
    % decode coordinates of player 
    x_player = mod(s_player, 4);
    y_player = floor(s_player / 4);
    
    % 1: select action according to e-greedy policy
    a_n = select_action_e_greedy(s, Q, e);
    
    % 2: compute next state
    s_n1 = next_state(s, a_n);
    
    a_n1 = select_action_e_greedy(s_n1, Q, e);
    
    alpha = 1 / (num_updates(s,a_n)^(2/3) + 1);  % learning rate  
    
    % update Q
    Q(s,a_n) = Q(s,a_n) + alpha*(r(s) + lambda*(Q(s_n1, a_n1)) - Q(s, a_n));
    
    num_updates(s,a_n) = num_updates(s,a_n) + 1;
    
    V(:,n) = max(Q,[],2);
    
    s = s_n1;
end

%% Plot convergence

figure
states = randsample(S,30);

%subplot(1,2,1)
plot(V(states,:)')
title('SARSA-learning convergence for 30 random states')
xlabel('Iteration')
ylabel('Value')

