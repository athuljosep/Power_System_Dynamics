function [P,Q,dP_states,dQ_states,P_statesIni,Q_statesIni] = pwrmod_dyn(P_states,Q_states,bus,Time,kSim,Flag,n_pwrmod)
% Implement state or output variables to model power injection
% This version implements speed gov and voltage regulation assuming a 
%  power modulatiion model.
% Inputs:
%   n_pwrmod = number of injection buses (number of rows of pwrmod_con).
%   Time = vector of simulation time
%   kSim = current simulation index.  Current time = Time(kSim).
%   Flag:
%       If Flag==0, Initialize P_statesIni, Q_statesIni at t = 0.
%       If Flag==1, Calculate P, Q at Time(kSim)
%       If Flag==2, Calculate dP_states, dQ_states at Time(kSim)
%   P_state = cell array of P injection states
%       P_state{k} = column vector of states corresponding to row k of
%       pwrmod_con.
%   Q_state = cell array of Q injection states.  Same format as P_states.
%   bus = initial bus matrix from the solved power flow.
%   
% Outputs:
%   P_statesIni = = cell array of initial of P_states
%   Q_statesIni = = cell array of initial of Q_states
%   dP_state = cell array of d/dt of P_states.
%   dQ_state = cell array of d/dt of Q_states.
%   P = n_pwrmod by 1 column vector of P commands at t = Time(kSim).  P(k)
%       corresponds to row k of pwrmod_con.
%   Q = n_pwrmod by 1 column vector of Q commands at t = Time(kSim).  Q(k)
%       corresponds to row k of pwrmod_con.
%   Note that injections are either power or current depending on load_con.
%
% Global:
%   pwrmod_data = general variable for storing data when necessary.
%   bus_v = solved bus voltages.  bus_v(n,k) is the solved voltage at bus n
%       at time t(k).  Note that for k>kSim, bus_v is not solved. 
%   load_con = see system data file.
%   pwrmod_con = see system data file.
% D. Trudnowski, 2015

global pwrmod_data bus_v pwrmod_con load_con

%% Parameters
nOrderP = 1; %order of state equations for P modulation
nOrderQ = 1; %order of state equations for Q modulation

%P modulation parameters
R = 0.05; %Droop constant (f/P - pu/pu)
Gv = 5; %Voltage gain (Q/V - pu/pu)

%% Initialize output variables
P = zeros(n_pwrmod,1);
Q = zeros(n_pwrmod,1);
dP_states = cell(n_pwrmod,1);
dQ_states = cell(n_pwrmod,1);
P_statesIni = cell(n_pwrmod,1);
Q_statesIni = cell(n_pwrmod,1);

%% Define and initialize states at Time = 0.
if Flag==0
    for k=1:n_pwrmod
        Q_statesIni{k} = zeros(nOrderQ,1);
        P_statesIni{k} = zeros(nOrderP,1);
    end
    pwrmod_data = zeros(n_pwrmod,length(Time)); %Store the P(k) for use below
    clear k n

%% Calculate P and Q
elseif Flag==1
    for k=1:length(P)
        n = find(pwrmod_con(k,1)==bus(:,1));
        m = find(pwrmod_con(k,1)==load_con(:,1));
        
        %Droop control
        if (load_con(m,2)==1) && (load_con(m,3)==1)  % check for power injection case
          P(k) = bus(n,4);  % power 
        elseif (load_con(m,4)==1) && (load_con(m,5)==1)  % check for current injection case
          P(k) = bus(n,4)/abs(bus(n,2));   % current
        else  % case of something wrong?
          error('Model is not configured properly for power or current injection');
        end           
        if kSim>1;
            if abs(bus_v(n,kSim))>0.5 && abs(bus_v(n,kSim-1))>0.5
                delT = Time(kSim)-Time(kSim-1);
                if abs(delT)>1e-8
                    f = angle(bus_v(n,kSim)/bus_v(n,kSim-1))/delT;
                    f = f/(2*pi*60); %freq error in pu
                    if (load_con(m,2)==1) && (load_con(m,3)==1)  % check for power injection case                    
                      P(k) = P(k) - f/R; %Droop control
                    elseif (load_con(m,4)==1) && (load_con(m,5)==1)  % check for current injection case  
                      P(k) = P(k) - f/R/abs(bus_v(n,kSim)); %Droop control - current
                    else  % case of something wrong?
                      error('Model is not configured properly for power or current injection');
                    end                       
                else
                    P(k) = pwrmod_data(k,kSim-1); %Use previous command
                end
            else
                P(k) = pwrmod_data(k,kSim-1); %Use previous command
            end
        end
        
        pwrmod_data(k,kSim) = P(k);
        
        %Voltage control
        if (load_con(m,2)==1) && (load_con(m,3)==1)  % check for power injection case
          Q(k) = bus(n,5);  % power 
        elseif (load_con(m,4)==1) && (load_con(m,5)==1)  % check for current injection case
          Q(k) = bus(n,5)/abs(bus(n,2));   % current
        else  % case of something wrong?
          error('Model is not configured properly for power or current injection');
        end          
        if kSim>1 && abs(bus_v(n,kSim))>0.5
          if (load_con(m,2)==1) && (load_con(m,3)==1)  % check for power injection case            
            Q(k) = Q(k) + Gv*(bus(n,2)-abs(bus_v(n,kSim)));
          elseif (load_con(m,4)==1) && (load_con(m,5)==1)  % check for current injection case 
            Q(k) = Q(k) + Gv*(bus(n,2)-abs(bus_v(n,kSim)))/abs(bus_v(n,kSim)); 
          else  % case of something wrong?
            error('Model is not configured properly for power or current injection');
          end            
        end 
    end
        
    %Apply a pulse
    if Time(kSim)>=1 && Time(kSim)<1.5
        P(1) = -0.001 + P(1);
    end
    if Time(kSim)>=4 && Time(kSim)<4.5
        P(2) = 0.002 + P(2);
    end

%% Calculate derivatives
elseif Flag==2
    for k=1:n_pwrmod
        %No dynamics
        dQ_states{k} = zeros(nOrderQ,1);
        dP_states{k} = zeros(nOrderP,1);
    end
    clear k
end


end

