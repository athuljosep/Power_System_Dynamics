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
[P,Q] = PQ_calc(V1_data(:,size(V1_data,2)),T1_data(:,size(T1_data,2)),Y);
V = V1_data(:,size(V1_data,2));
T = T1_data(:,size(T1_data,2));
% [P,Q] = PQ_calc(V,T,Y)

% plotting convergence curves
% mplot([1:size(V1_data,2)],T1,[1:size(V1_data,2)],T1)

bus_data = importdata('ieee11bus_ynet.txt').data;
branch_data = importdata('ieee11branch_ynet.txt').data;
t = 0; % 0 for without tap, 1 for with tap
n_bus = 14;
Y = y_bus_calc(n_bus,bus_data,branch_data,t);

% calculating Ygen matrix

Y_gen = Y_gen_calc(Y)

P_gen = P(2:4);
Q_gen = Q(2:4);
V(12:14) = V(2:4);
T(12:14) = T(2:4);

% calculating Igen
I_gen = (P_gen - i*Q_gen)./(V(12:14).*exp(-i*T(12:14)));

X_gen = (((0.3+0.55)/2)*base_MVA/900);

% calculating Egen
E = (V(12:14).*exp(i*T(12:14))) + (i*X_gen.*I_gen);
[Theta, E_g] = cart2pol(real(E),imag(E))
E_g = [V(1); E_g]
Theta = [T(1); Theta]

%% using fsolve
% x0 = [0.5 1.2 0.5 1.2 0.5 1.2]
% 
% fun = @(x)paramfun(x, P_gen, Y_gen, E_g);
% x = fsolve(fun,x0)

%% using vpasolve
t = sym('t', [1 3]);
w = sym('w', [1 3]);

F = type3(t, w, P_gen, Y_gen, E_g);
vars = [t, w];

sol = vpasolve(F,vars)

% making Jacobian
for i = 1:length(vars)
    for j = 1:3
        J(i,j) = diff(F(i),t(j));
        J(i,j+3) = diff(F(i),w(j));
    end
    sol_val{i} = sol.(char(vars(i)));
end

% substituting solution
J_val = subs(J, vars, sol_val);
J_val = double(J_val);

% eigen value and vectors
[r_ev, eig_val] = eig(J_val);
l_ev = inv(r_ev);

% participation factor
norm_p = []; 
for i = 1: length(vars)
    p_mat = r_ev(:,i)*l_ev(i,:);
    diag_vec = abs(diag(p_mat));
    norm_p = [norm_p diag_vec./max(diag_vec)];
end

% calculating mode frequency
eigen_frequency_mode= abs(imag(diag(eig_val)))/2/pi;

%% Transient Stability

% Ybus
Y_pre = Y;
Y_fault = y_fault_update();
Y_post = y_post_update();

% generating fault on system equations
Y_gen_fault = Y_gen_calc(Y_fault)
F_fault = type3(t, w, P_gen, Y_gen_fault, E_g);

t_k1 = 0.3308;
t_k2 = 0.3308;
t_k2 = 0.3308;
w_k1 = 1.0;
w_k2 = 1.0;
w_k3 = 1.0;
time_data = [0];
t_data = [t_k1; t_k2; t_k3];
w_data = [w_k1; w_k2; w_k3];
h = 0.002;
Tc = 1/60
for time = 0:h:Tc
    t_kn = t_k + (2*h);
    w_kn = w_k + (double(subs(F(1), w(1), w_k))*h);
    time_data = [time_data time];
    t_data = [t_data t_kn];
    w_data = [w_data w_kn];
    t_k = t_kn;
    w_k = w_kn;
end

figure(1)
plot(time_data,t_data)
figure(2)
plot(time_data,w_data)

%% Type 2
% 
% t = sym('t', [1 3]);
% w = sym('w', [1 3]);
% Eq = sym('Eq', [1 3]);
% Ed = sym('Ed', [1 3]);
% Efd = sym('Efd', [1 3]);
% Pm = sym('Pm', [1 3]);
% Vref = sym('Vref', [1 3]);
% Pc = sym('Pc', [1 3]);
% F = type2(t, w, Eq, Ed, Efd, Pm, Vref, Pc, P_gen, Y_gen, E_g, V, T);
% vars = [t, w, Eq, Ed, Efd, Pm, Vref, Pc];
% 
% x0 = [0.685 0.614 0.504  1 1 1  0.935 0.991 0.916  0.549 0.537 0.559  1.845 1.935 1.813  7.013 7.204 7.013 1.019 1.040 1.019 7.013 7.204 7.013];
% sol = vpasolve(F,vars,x0)
% 
% state_vars = [t, w, Eq, Ed, Efd, Pm];
% 
% % making Jacobian
% for i = 1:length(state_vars)
%     for j = 1:3
%         J(i,j) = diff(F(i),t(j));
%         J(i,j+3) = diff(F(i),w(j));
%         J(i,j+6) = diff(F(i),Eq(j));
%         J(i,j+9) = diff(F(i),Ed(j));
%         J(i,j+12) = diff(F(i),Efd(j));
%         J(i,j+15) = diff(F(i),Pm(j));
%     end
%     sol_val{i} = sol.(char(state_vars(i)));
% end
% 
% % substituting solution
% J_val = subs(J, state_vars, sol_val);
% J_val = double(J_val);
% 
% % eigen value and vectors
% [r_ev, eig_val] = eig(J_val);
% l_ev = inv(r_ev);
% 
% % participation factor
% norm_p = []; 
% for i = 1: length(state_vars)
%     p_mat = r_ev(:,i)*l_ev(i,:);
%     diag_vec = abs(diag(p_mat));
%     norm_p = [norm_p diag_vec./max(diag_vec)];
% end
% 
% % calculating mode frequency
% eigen_frequency_mode= abs(imag(diag(eig_val)))/2/pi;


