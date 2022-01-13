function [t,u] = input_voltage(D,A,Delta,Ts)
% Delta = period    
% D = duration
% A = amplitude
% Ts = sampling time
t = 0:Ts:D;
n = numel(t);
u = zeros(n,1);

for i=1:n
    if mod(t(i),Delta) < Delta/2
        u(i) = A/2;
    else
        u(i) = -A/2;
    end
end
end