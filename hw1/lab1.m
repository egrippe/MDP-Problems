%% Initialization
clear all
close all

A = 5;      % number of actions
S = 900;    % number of states
P = cell(S+1,1);
P{S+1} = zeros(S+1, A);
P{S+1}(S+1,:) = ones(1,5);

r = zeros(S+1,A);  %rewards

% Fill transition matricies for each state
for s = 1:S
    P{s} = zeros(S+1,A);
    
    [px,py,mx,my] = decode(s-1);  % remember 0-indexing
    
    % if s is losing state (p = m) we stay with prob 1
    if (px==mx && py==my)
        P{s}(S+1,:) = 1;
        continue
    end
    
    % if s is winning state (p = (4,4) != m) we stay with prob 1
    if ((px==4 && py==4) && (mx~=4 || my~=4))
        P{s}(S+1,:) = 1;
        r(s,:) = 1;  % any action in win state gives a reward
        continue
    end
  
    for a = 1:A
        % get the possible next states under this action
        next_states = get_next_states(s-1,a);  % states are 0-indexed
        for i = 1:size(next_states,1)
            next = next_states(i) + 1;
            P{s}(next,a) = 1 / size(next_states,1);
        end
    end
end


%% Compute optimal policy for T=15
T = 15;
% now we create a maxtrix for storing
policy = zeros(S+1,T);
U      = zeros(S+1,T);
U(:,T) = max(r,[],2);

for t = (T-1):-1:1
   for s = 1:S
       res = r(s,:)' + P{s}'*U(:,t+1);
       [val, idx] = max(res);
       U(s,t) = val;
       policy(s,t) = idx;
   end
end

disp(['Value Function:', num2str(U(29,1))])

%% Make a simulation
states = zeros(15,1);
states(1) = 29;  % start state
for t = 1:14
    action = policy(states(t),t);
    states(t+1) = randsample(1:S+1,1,true,P{states(t)}(:,action));
end
figure
plot_state(states)


%% Plot max probability of exiting the maze as function of T

T_range = 8:15;
max_prob = zeros(1,length(T_range));

for T = T_range
    U = zeros(S+1,T);
    U(:,T) = max(r,[],2);
    for t = (T-1):-1:1
       for s = 1:S
           res = r(s,:)' + P{s}'*U(:,t+1);
           U(s,t) = max(res);
       end
    end
    max_prob(T-7) = U(29,1);
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
v0 = zeros(S+1, 1);
v1 = ones(S+1, 1);
policy = zeros(S+1, 1);

v0_vec = v0; 
policy_vec = policy;

while max(abs(v1-v0)) >= epsilon*(1-lambda)/(2*lambda)
    n = n+1;
    v1 = v0;
    for s=1:S+1
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
    states(t+1) = randsample(1:S+1,1,true,P{states(t)}(:,action));
end
figure
plot_state(states)




