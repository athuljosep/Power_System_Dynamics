syms t
% Eq1 = 5 == 2*(t-2+(2*exp(-t/2)));

% Eq1 = 5 == 6.328 - 2*(t-7+(2*exp(-(t-5)/2)));

% Eq1 = -5 == 6.328 - 2*(t-7+(2*exp(-(t-5)/2)));

% Eq1 = -5 == -9.698 + 2*(t-17+(2*exp(-(t-15)/2)));

Eq1 = -5 == 5 - 2*(t-9.5+(2*exp(-(t-7.5)/2)));

t_sol = solve(Eq1, t)