clear all; close all; clc;

                  % Kwa   Kcm
% my_batch_gains = [   0,    0;
%                   5.33,    0; 
%                   8.67,    0; 
%                      0, 5.33;
%                   5.33, 5.33; 
%                   8.67, 5.33; 
%                      0, 8.67;
%                   5.33, 8.67; 
%                   8.67, 8.67;];       

% my_batch_gains = [5.33, 0.00, 0.000;
%                   5.33, 0.00, 0.250;
%                   5.33, 0.00, 0.500;
%                   5.33, 0.00, 1.000;
%                   5.33, 5.33, 0.000;
%                   5.33, 5.33, 0.250;
%                   5.33, 5.33, 0.500;
%                   5.33, 5.33, 1.000;
%                   8.67, 5.33, 0.000;
%                   8.67, 5.33, 0.250;
%                   8.67, 5.33, 0.500;
%                   8.67, 5.33, 1.000;];
              
% my_batch_gains = [ 6.00,  6.00,  0.000;
%                   12.00,  6.00,  0.000;
%                   18.00,  6.00,  0.000;
%                    6.00,  0.00,  0.000;
%                    6.00, 12.00,  0.000;];

my_batch_gains = [9.0, 4.5, 0.000;
                  9.0, 4.5, 0.625;
                  9.0, 4.5, 1.250;
                  4.5, 9.0, 0.000;
                  4.5, 9.0, 0.625;
                  4.5, 9.0, 1.250];
              
save('my_batch_gains', 'my_batch_gains');

% tmp = [8.67, 5.33, 0]; 
% my_Kwa = tmp(1); 
% my_Kcm = tmp(2); 
% my_Tdel = tmp(3); 
% save('K_sweep', 'my_Kwa', 'my_Kcm', 'my_Tdel');

for ii = 1:size(my_batch_gains,1)
    load('my_batch_gains');
    tmp = my_batch_gains(ii,:);
    my_Kwa = tmp(1); 
    my_Kcm = tmp(2); 
    my_Tdel = tmp(3); 
    save('K_sweep', 'my_Kwa', 'my_Kcm', 'my_Tdel');
    run('s_simu');
end

clear all; close all; clc;

fprintf('\nAll done!\n\n'); 