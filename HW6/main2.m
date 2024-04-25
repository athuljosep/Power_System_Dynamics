clc
clear all; close all;

% Initializing Kundur 2 area system and importing data
n_bus = 11;
bus_data = importdata('ieee11bus.txt').data;
% bus_data = importdata('ieee11bus_allPV.txt').data;
branch_data = importdata('ieee11branch.txt').data;
   
% Ybus formation
t = 0; % 0 for without tap, 1 for with tap
Y = y_bus_calc(n_bus,bus_data,branch_data,t);

% Scheduled power calculation
base_MVA = 100;
P_inj = (bus_data(:,8) - bus_data(:,6)) / base_MVA;
Q_inj = (bus_data(:,9) - bus_data(:,7)) / base_MVA;

% Finding bus types
pv_i = find(bus_data(:,3) == 2);
pq_i = find(bus_data(:,3) == 0);
n_pv = length(pv_i);
n_pq = length(pq_i);

% Initializing Voltage magnitude and angles
V = bus_data(:,11);
V(find(V(:)==0)) = 1;
T = zeros(n_bus,1);

% Newton Raphson Method
[V1_data,T1_data,T1] = NR(bus_data,V,T,P_inj,Q_inj,n_bus,Y,n_pq,pq_i);
% V = V1_data(:,end)
% T = T1_data(:,end)

% Fast Decoupled Mehod
%[V2_data,T2_data,T2] = FD(bus_data,V,T,P_inj,Q_inj,n_bus,Y,n_pq,pq_i);

% P,Q calculation after convergence
[P,Q] = PQ_calc(V1_data(:,size(V1_data,2)),T1_data(:,size(T1_data,2)),Y)
V = V1_data(:,size(V1_data,2))
T = T1_data(:,size(T1_data,2))
% [P,Q] = PQ_calc(V,T,Y)

% plotting convergence curves
% mplot([1:size(V1_data,2)],T1,[1:size(V1_data,2)],T1)

bus_data = importdata('ieee11bus_ynet.txt').data;
branch_data = importdata('ieee11branch_ynet.txt').data;
t = 0; % 0 for without tap, 1 for with tap
n_bus = 14
Y = y_bus_calc(n_bus,bus_data,branch_data,t)

% calculating Ygen matrix
Y_gen = Y(1:4,1:4)-(Y(1:4,5:14)*inv(Y(5:14,5:14)) *Y(5:14,1:4))

P_gen = P(2:4)
Q_gen = Q(2:4)
V(12:14) = V(2:4)
T(12:14) = T(2:4)

% calculating Igen
I_gen = (P_gen - i*Q_gen)./(V(12:14).*exp(-i*T(12:14)))

X_gen = (((0.3+0.55)/2)*base_MVA/900)*[1 1 1]'

% calculating Egen
E = (V(12:14).*exp(i*T(12:14))) + (i*X_gen.*I_gen)

[Theta, E_g] = cart2pol(real(E),imag(E))
E_g = [V(1); E_g]
Theta = [T(1); Theta]
omega_s = 2*pi*60;

%% using fsolve
% x0 = [0.5 1.2 0.5 1.2 0.5 1.2]
% 
% fun = @(x)paramfun(x, P_gen, Y_gen, E_g);
% x = fsolve(fun,x0)

%% using vpasolve
x = sym('x', [1 6]);
F = type3(x, P_gen, Y_gen, E_g);

sol = vpasolve(F,x);

%% Transient Stability Analysis
% Prefault
Ynet = Y

n_bus = 11;
bus_data = importdata('ieee11bus.txt').data;
% bus_data = importdata('ieee11bus_allPV.txt').data;
branch_data = importdata('ieee11branch.txt').data;
   
% Ybus formation
t = 0; % 0 for without tap, 1 for with tap
Y = y_bus_calc(n_bus,bus_data,branch_data,t);



Ynew = y_update(Y);


% making Jacobian
for i = 1:6
    for j = 1:6
        J(i,j) = diff(F(j),x(i));
    end
end

J_val = subs(J,x,{sol.x1,sol.x2,sol.x3,sol.x4,sol.x5,sol.x6});
J_val = subs(J,x,{0.155,1.0,0.118,1.0,-0.043,1.0});
J_val = double(J_val);

% eigen value and vectors
[right_eigen_vector, eigen_values] = eig(J_val);
left_eigen_vector = inv(right_eigen_vector);
% participation factor
normalized_participant_vector = []; % each column contains participation factor pof other state to that mode
for i = 1: length(x)
    participation_matrix = right_eigen_vector(:,i)*left_eigen_vector(i,:);
    diagonal_vector = abs(diag(participation_matrix));
    normalized_participant_vector = [normalized_participant_vector diagonal_vector./max(diagonal_vector)];
end
% finding mode frequency
eigen_frequency_mode= abs(imag(diag(eigen_values)))/2/pi;
% 
% [right,eigen,left] = eig(J_val);
% 
% 
%     for j = 1:18
%         J1(i,j) = diff(F(j),x(i));
%     end
% end
% 
% J_val = subs(J,x,sol);
% J_val = double(J_val);



% % fun = @([t w Eq Ed Efd Pm])type2(t, w, Eq, Ed, Efd, Pm, P_gen, Y_gen, E_g, V);
% % x = fsolve(fun,x0);
% % x'
