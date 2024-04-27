function Y =  y_fault_update(Y)
bus_data = importdata('ieee11bus_ynet_fault.txt').data;
branch_data = importdata('ieee11branch_ynet_fault.txt').data;
t = 0; % 0 for without tap, 1 for with tap
n_bus = 14;
Y = y_bus_calc(n_bus,bus_data,branch_data,t);
end