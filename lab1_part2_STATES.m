clear all, clc

%% Kalman filter

% Parameters 
L = 512; % L is always a power of 2
Ts = 1*10^-3;
Delta = 0.1;
A = 0.1; 

% Input voltage
D = 0.5; % Duration
[u,t] = input_voltage(D,A,Delta,Ts);

if 1
    figure(100)
    hold off
    plot(t,u), hold on
    title('Input sampled voltage u ')
    axis([0 D 1.1*min(u) 1.1*max(u)])
end
 

%% System modeling and simulation

G = 50; % rad.s^-1.V^-1
T = 20*10^-1; % Time constant in s (higher it is, the more the system is slow)
x1 = [0; 0];

[y, x_sim] = simulate(u,G,T,Ts,L,x1);
x_sim = x_sim';

figure(200)
subplot(211), hold off

plot(t,x_sim(1,:),'g','Linewidth',1), hold on
lgd200_1 = {'Theta simulation (Theta=x(1)=y, noise-free)'};

plot(t,y,'k','Linewidth', 1)
lgd200_1(length(lgd200_1)+1) = {'Real Theta (y)'};

legend(lgd200_1)
title('Angular position output')

subplot(212), hold off
plot(t,x_sim(2,:)), hold on
lgd200_2 = {'Omega simulation'};
legend(lgd200_2)
title('Angular velocity output')



%% Kalman filter

% Input = u[n] = u[n] + v[n] with variance q of v
% Output : y[n] = theta[n] + w[n] with variance r of w the quantization noise

% r is the variance of the encoder. It's the difference between the actual
% theta and the theta as encoder output. We modelize it by a uniform rv of
% values from -pi/L to pi/L so its variance is r = (2pi/L)^2/12

x1_0 = [0.05; 0]; % Prior information
P1_0 = [10^300 0;0 0]; % Variance of prior information (inf for theta because no information on the initial angular position)

r = ((2*pi/L)^2)/12; % Variance of the quantization noise of the incremental encoder

% Tuning parameter
q = 10^-3; % Variance of the input white noise
% Very big q we don't trust the model (output will tend to the encoder
% output), very small we completely trust the model (output tend to the
% simulation). q=0 is the same as simulation

if 1
    [x_kal] = kal(y,u,G,T,Ts,L,x1_0,P1_0,q,r);

    figure(200)
    subplot(211)
    plot(t,x_kal(1,:),'b--','Linewidth',1)
    lgd200_1(length(lgd200_1)+1) = {'Theta Kalman output (filtered)'};

    legend(lgd200_1)

    subplot(212)
    plot(t,x_kal(2,:),'b--','Linewidth',1)
    lgd200_2(length(lgd200_2)+1) = {'Omega Kalman output'};
    legend(lgd200_2)
end


%% Stationnary Kalman filter


if 1
    x_skal = skal(y,u,G,T,Ts,L,x1_0,P1_0,q,r);

    figure(200)
    subplot(211), hold on
    plot(t,x_skal(1,:),'r--','LineWidth',1)
    lgd200_1(length(lgd200_1)+1) = {'Theta stationnary Kalman output (filtered)'};
    legend(lgd200_1)


    subplot(212), hold on
    plot(t,x_skal(2,:),'r--','LineWidth',1)
    lgd200_2(length(lgd200_2)+1) = {'Omega stationnary Kalman output'};
    legend(lgd200_2)
end


