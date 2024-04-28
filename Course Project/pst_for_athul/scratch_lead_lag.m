
w_lag_c = 2*pi*0.5; 
w_lag_left = 2*pi*0.1; 

T_lag = 1/w_lag_left; 
a_lag = (1/(w_lag_c*T_lag))^2;

Tn_lag = a_lag*T_lag; 
Td_lag = T_lag; 

w_lead_c = 2*pi*5; 
w_lead_right = 2*pi*15; 

T_lead = 1/w_lead_right; 
a_lead = (1/(w_lead_c*T_lead))^2;

Tn_lead = a_lead*T_lead; 
Td_lead = T_lead; 

n_point = 2048;
s_jw = 1j*2*pi*logspace(-4, 1, n_point);
t_del = 0.0; 

my_Tw = 10;
my_Tn1 = Tn_lead; % Tn_lead;
my_Td1 = Td_lead; % Td_lead;
my_Tn2 = Tn_lead; % Tn_lead;
my_Td2 = Td_lead; % Td_lead;

my_tmpC1 = freqs([my_Tw, 0], [my_Tw, 1], s_jw/(1j));    % washout
my_tmpC2 = freqs([my_Tn1, 1], [my_Td1, 1], s_jw/(1j));  % lead-lag stage 1
my_tmpC3 = freqs([my_Tn2, 1], [my_Td2, 1], s_jw/(1j));  % lead-lag stage 2
my_Cpss = my_tmpC1.*my_tmpC2.*my_tmpC3;

cmap = lines(5); 

fig1 = figure; 
ax21 = subplot(2,1,1,'parent',fig1); 
ax22 = subplot(2,1,2,'parent',fig1); 
plot(ax21, s_jw/(1j*2*pi), 20*log10(abs(my_Cpss)), 'color', cmap(1,:));
plot(ax22, s_jw/(1j*2*pi), (180/pi)*angle(my_Cpss), 'color', cmap(1,:));

set(ax21,'xscale','log'); 
set(ax22,'xscale','log'); 