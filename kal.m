function [x_estimated] = kal(y,u,G,T,Ts,L,x1_0,P1_0,q,r)

% State space representation
A = [0 1; 0 -1/T];
B = [0; G/T];
C = [1 0];
D = 0;
[Ad,Bd,~,~] = c2dm(A,B,C,D,Ts,'zoh');

H = [1 0];
h = 0;
F = Ad;

% Covariance matrices
Q = Bd*q*Bd.';
R = r;

% Initialization : prediction of x(1)
xe = x1_0;
P = P1_0;

for n = 1:length(u)
    
    % Store the evolution of the predicted state vector
    %x_predicted(:,n) = xe;

    % Prediction of ye(n)
    ye = H*xe+h;
    Cx_y = P*H.';
    Cy_y = H*P*H.'+R;

    % Noisy input u(n)
    f = Bd*u(n);

    % Estimation of x(n)
    %Cx_y/Cy_y % Kalman gain
    xe = xe+Cx_y/Cy_y*(y(n)-ye);
    x_estimated(:,n) = xe;
    P = P-Cx_y/Cy_y*Cx_y.';

    % Prediction of x(n+1)
    xe = F*xe+f;
    P = F*P*F.'+Q;
end 

