%% The inverted pendulum
clear
close all

l = 100;  % length of the pendulum 

g = 9;  % gravity constant

alpha = (2 * g) / l;
beta  = -2 / l;

% define matrix A
t1 = exp( sqrt(alpha));
t2 = exp(-sqrt(alpha));
A = [                    t1/2, (t1-t2)/2  ; 
      (sqrt(alpha)/2)*(t1-t2), (t1+t2)/2 ];

% define B
B = beta*(t1 - t2)*[1/alpha; 1/(2*sqrt(alpha))];

R  = [1 0; 0 0];
mu_vec = [1,5,20,100];  % 1,5,20,100

%% Riccati recursion

T = 100;
noice = normrnd(0,1,[2,T]);

for i = 1:length(mu_vec)
    mu = mu_vec(i);    

    Pi = zeros(2,2,T);
    K  = zeros(2,T-1);

    Pi(:,:,T) = R;

    for t = T-1:-1:1
        pi = Pi(:,:,t+1);
        Pi(:,:,t) = R + A'*pi*A - ((A'*pi*B)/(mu + B'*pi*B))*(B'*pi*A);    

        K(:,t) = (B'*pi*A) / -(mu + B'*pi*B);
    end
    
    % simulation
    X = zeros(2,T);

    for t = 1:T-1
        u_t = K(:,t)' * X(:,t);
        X(:,t+1) = A*X(:,t) + B*u_t + noice(:,t);
    end

    plot(X(1,:))
    hold on
end

title(['y(t) (T=',num2str(T),')'])
legend('mu=1', 'mu=5', 'mu=20', 'mu=100')

