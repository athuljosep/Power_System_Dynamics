
gen_idx = [1 3 5 9 12 14 17 19 22 23 25 27 30 32 34 37 39 41 45 47 48 51 53 58 59 60 62 65 68 71 74 76 107];

bus_tmp = bus; 

% updating the bus voltages
bus_tmp(:,2) = abs(bus_v(1:end-1,end)); 
bus_tmp(:,3) = angle(bus_v(1:end-1,end) - bus_v(7,end))*180/pi;  % correcting for the swing bus

% updating the generator output
% bus_tmp(gen_idx,4) = pelect(1:end-1,end); 
% bus_tmp(gen_idx,5) = qelect(1:end-1,end); 
% bus_tmp(gen_idx,4) = 0.978*bus_tmp(gen_idx,4); 
% bus_tmp(gen_idx,5) = 0.978*bus_tmp(gen_idx,5);

bus_tmp = round(bus_tmp*1e6)/1e6;
bus_tmp(bus_tmp == -0 | abs(bus_tmp) == 9999) = 0; 

for ii = 1:size(bus_tmp,1)
    fprintf('%3i  %9.6f  %11.6f  %10.6f  %10.6f  %10.6g  %10.6g  %10.6g  %10.6g  %9.6g  %9.6g  %9.6g  %9.6g  %9.6g  %9.6g', bus_tmp(ii,:));
    fprintf('\n');
end