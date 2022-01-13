function[y, x] = simulate(u,G,T,Ts,L,x1)
% u = input to the dc motor. 1xn vector
% G = unit of rad/s.V
% T = time
% Ts = sampling time
% L = encoder resolution (512 angles/revolution)
% x1 = initial state vector
% x is a 2-column matrix

n_t = numel(u);
theta = zeros(1, n_t);
y = zeros(1,n_t);

A = [0 1; 0 -1/T];
B = [0; G/T];
C = [1 0];
D = zeros(1, 1);

x = zeros(n_t, 2);

x1_size = size(x1);
if x1_size(1) == 2
    x1 = x1';
    disp("Initial input vector transposed");
end

x(1,:) = x1;

[Ad, Bd, Cd, Dd] = c2dm(A, B, C, D, Ts, 'zoh'); % we use this function to convert the continuous SS parameters to discrete
for n = 1:length(u)-1
    theta(n) = Cd*x(n,:)' + Dd*u(n);
    y(n) = round(theta(n)*L/2/pi)*2*pi/L; % formula for this precision conversion given in lab subject
    x(n+1,:) = (Ad*x(n,:)' + Bd*u(n))';
end
theta(n_t) = Cd*x(n,:)' + Dd*u(n_t);
y(n_t) = round(theta(n_t)*L/2/pi)*2*pi/L;
end