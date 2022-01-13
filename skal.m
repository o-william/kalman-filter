function x_estimated = skal(y,u,G,T,Ts,L,x1_0,P1_0,q,r)


% State space representation
A = [0 1; 0 -1/T];
B = [0; G/T];
C = [1 0];
D = 0;
[Ad,Bd,~,~] = c2dm(A,B,C,D,Ts,'zoh');

H = [1 0];
h = 0;
F = Ad;

% Covariance matrices (calculated inside dlqe)
%Q = Bd*q*Bd.';
%R = r;

% Prelaminaries
[K,P,~,~] = dlqe(Ad,Bd,C,q,r);
% K % Stationnary Kalman gain

% Initialization : prediction of x(1)
xe = x1_0;


%% LOOP TO BE COMPLETED
for n = 1:length(u)
    
    % Store the evolution of the predicted state vector
    %x_predicted(:,n) = xe;
    
    % Prediction of ye(n)
    ye = H*xe+h;

    % Noisy input u(n)
    f = Bd*u(n);

    % Estimation of x(n)
    xe = xe+K*(y(n)-ye);
    
    % Store the evolution of the estimated state vector
    x_estimated(:,n) = xe;

    % Prediction of x(n+1)
    xe = F*xe+f;
end 

