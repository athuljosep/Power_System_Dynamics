function [] = freqcalc(k,t,vmod)
% Author: Felipe Wilches-Bernal (fwilche@sandia.gov)
% Sandia National Laboratories
% Feb. 2017
% Function developed to calculate bus frequencies in PST

global basmva sys_freq_p bus_freq bus_freqf bf_hpf dbf_hpf o2p kpx %theta_un_k
global bus_v theta n_bus mac_con mac_spd
global x1_snlf x2_snlf dx1_snlf dx2_snlf bus_freqsnl

Nbf_hpf = 10;
K1bf_hpf = 1;

if vmod == 0
    kpx = ones(size(t));
    bus_freq = zeros(n_bus+1,length(t));
    bus_freq(:,1) = 1;

    %=====================================================================%
    bf_hpf = zeros(size(theta));
    dbf_hpf = zeros(size(theta));
    bus_freqf = zeros(size(theta));
    bus_freqf(:,1) = 1;
    %bus_freqf = zeros(n_bus+1,length(t));
    o2p = zeros(size(theta,1),1);
    bf_hpf(:,1) = K1bf_hpf.*theta(:,1);

    %** Sandia filter
    bus_freqsnl = zeros(size(theta));
    bus_freqsnl(:,1) = 1;
    x1_snlf = zeros(size(theta));
    dx1_snlf = zeros(size(theta));
    x2_snlf = zeros(size(theta));
    dx2_snlf = zeros(size(theta));

    %theta_un_k = zeros(size(theta));

elseif vmod == 1

    if k~=1
%       dVangle = angle(bus_v(1:n_bus,k)) - angle(bus_v(1:n_bus,k-1));

        dVangle = theta(:,k)-theta(:,k-1);
        dVangle(dVangle >= pi) = dVangle(dVangle >= pi) - 2*pi;
        dVangle(dVangle <= -pi) = dVangle(dVangle <= -pi) + 2*pi;

        dbus_freq = dVangle/(t(k)-t(k-1))*(1/(2*pi*sys_freq_p(1)));

%       dbus_freq(abs(dbus_freq) > 0.01) = 0;

        bus_freq(:,k) = bus_freq(:,1) + dbus_freq;

%       bfr_d = bus_freq(:,k) - bus_freq(:,k-1);
%       ix_dfr = abs(bfr_d) > 0.010;
%       bus_freq(ix_dfr,k) = bus_freq(ix_dfr,1);

        %=====================================================================%

        ixp2p = theta(:,k)-theta(:,k-1) >= pi;
        ixm2p = theta(:,k)-theta(:,k-1) <= -pi;
        o2p(ixp2p) = o2p(ixp2p) + 1*kpx(k);
        o2p(ixm2p) = o2p(ixm2p) - 1*kpx(k);
        theta_un_k = theta(:,k) - 2*pi.*o2p;

        % theta_un = unwrap(theta,[],2);
        % dbf_hpf(:,k) = Nbf_hpf.*K1bf_hpf.*theta_un_k(:,k) - Nbf_hpf.*bf_hpf(:,k);
        dbf_hpf(:,k) = Nbf_hpf.*K1bf_hpf.*theta_un_k - Nbf_hpf.*bf_hpf(:,k);
        bus_freqf(:,k) = bus_freqf(:,1) + dbf_hpf(:,k)*(1/(2*pi*sys_freq_p(1)));
        kpx(k) = 0;

        %** Sandia filter
        b1 = 277.2371876266; a0 = 277.2371876266; a1 = 28.8394098913241;
%       dx1_snlf(:,k) = b0*theta_un_k - a0*x2_snlf(:,k);
%       dx2_snlf(:,k) = x1_snlf(:,k) - a1*x2_snlf(:,k);
        dx1_snlf(:,k) = -a0*x2_snlf(:,k);
        dx2_snlf(:,k) = b1*theta_un_k + x1_snlf(:,k) - a1*x2_snlf(:,k);
        bus_freqsnl(:,k) = bus_freqsnl(:,1) + x2_snlf(:,k)*(1/(2*pi*sys_freq_p(1)));

    else
        dbf_hpf(:,k) = Nbf_hpf.*K1bf_hpf.*theta(:,k) - Nbf_hpf.*bf_hpf(:,k);
        bus_freqf(:,k) = bus_freqf(:,1) + dbf_hpf(:,k)*(1/(2*pi*sys_freq_p(1)));
        % when k==1, the vector is already initialized

        %** Sandia filter
        b1 = 277.2371876266; a0 = 277.2371876266; a1 = 28.8394098913241;
%       x1_snlf(:,1) = a1*b0/a0*theta(:,k);
%       x2_snlf(:,1) = b0/a0*theta(:,k);
        x1_snlf(:,1) = -b1*theta(:,k);
        x2_snlf(:,1) = 0;

%       dx1_snlf(:,k) = b0*theta(:,k) - a0*x2_snlf(:,k);
%       dx2_snlf(:,k) = x1_snlf(:,k) - a1*x2_snlf(:,k);
        dx1_snlf(:,k) = -a0*x2_snlf(:,k);
        dx2_snlf(:,k) = b1*theta(:,k) + x1_snlf(:,k) - a1*x2_snlf(:,k);
        bus_freqsnl(:,k) = bus_freqsnl(:,1) + x2_snlf(:,k)*(1/(2*pi*sys_freq_p(1)));

    end

end
