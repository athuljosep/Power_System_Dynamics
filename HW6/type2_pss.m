%%%%%%%%%%%%%%%%%% Type 2 Forumulation %%%%%%%%%%%%%%%%%%%%
function F = type2_pss(t, w, Eq, Ed, Efd, Pm, Vref, Pc, Vw, Vs, P,Y,E, V,T)
    %Vref = [1.019 1.040 1.019];
    H = [6.5 6.175 6.175];
    Kd = 40;
    omega_s = 2*pi*60;
    Xd = (1.8 + 1.7)/2/9;
    Xdp = (0.3 + 0.55)/2/9;
    Ym = abs(Y);
    Ya = angle(Y);
    F = [];
    
    Tw = [1 1 1]*10;
    Ta = [1 1 1]*0.5;
    Tb = [1 1 1]*1000;
    Ks = [1 1 1]*0.01;

    for k = 1:3
        Ep(k+1) = sqrt((Ed(k)*Ed(k)) + (Eq(k)*Eq(k)));
        g(k+1) = t(k)-(pi/2)+(atan(Eq(k)/Ed(k))); 
    end
    Ep;
    for k = 1:3
        i = k+1;
        Pe = Ym(i,1)*Ep(i)*E(1)*cos(g(i)-Ya(i,1));
        Id = Ym(i,1)*E(1)*sin(t(k)-Ya(i,1));
        Iq = Ym(i,1)*E(1)*cos(t(k)-Ya(i,1));

        for j = 2:4
            Pe = Pe + Ym(i,j)*Ep(i)*Ep(j)*cos(g(i)-g(j)-Ya(i,j));
            Id = Id + Ym(i,j)*Ep(j)*sin(t(k)-g(j)-Ya(i,j));
            Iq = Iq + Ym(i,j)*Ep(j)*cos(t(k)-g(j)-Ya(i,j));
        end
        vpa(Id,3);
        vpa(Iq,3);
        % (w-1)ws; Pm - Pe - Kd(w-1)

        F1 = [(w(k)-1)*omega_s,
              (Pm(k)-Pe-(Kd*(w(k)-1)))/(2*H(k)*9),
              (-Eq(k)-((Xd-Xdp)*Id)+Efd(k))/8,
              (-Ed(k)+((Xd-Xdp)*Iq))/0.4,
              (-Efd(k)-(200*(Vref(k) - V(i))))/0.01,
              (-Pm(k)+Pc(k)+((1/0.05)*(1-w(k))))/300,
              Ed(k) - (V(i)*sin(t(k)-T(i))) + Iq*Xdp
              Eq(k) - (V(i)*cos(t(k)-T(i))) - Id*Xdp
              (-Vw(k) - Tw(k)*((w(k)-1)*omega_s))/Tw(k)
              (-Ks(k)*Vs(k)+Vw(k)+Ta(k)*((-Vw(k) - Tw(k)*((w(k)-1)*omega_s))/Tw(k)))/(Ks(k)*Tb(k))];

        F = [F F1];
    end
    F = [F(1,:) F(2,:) F(3,:) F(4,:) F(5,:) F(6,:) F(7,:) F(8,:) F(9,:) F(10,:)].';



    % % PSS on G2
    % Vwdot2 = (1/Tw)*(-1*Vw(1)+Tw*((1-w(1))*omega_s));
    % Vcdot2 = (1/Tb)*(-1*Vs(1)+Vw(1)+Ta*(Vwdot2));
    % F(13) = (-Efd(1)-(200*((Ks*Vs(1))+Vref(1) - V(2))))/0.01;
    % 
    % % PSS on G3
    % Vwdot3 = (1/Tw)*(-1*Vw(2)+Tw*((1-w(2))*omega_s));
    % Vcdot3 = (1/Tb)*(-1*Vs(2)+Vw(2)+Ta*(Vwdot3));
    % F(14) = (-Efd(2)-(200*((Ks*Vs(2))+Vref(2) - V(3))))/0.01;

    % PSS on G4
    % Vwdot3 = (1/Tw)*(-1*Vw(2)+Tw*((1-w(3))*omega_s));
    % Vcdot3 = (1/Tb)*(-1*Vs(2)+Vw(2)+Ta*(Vwdot3));
    % F(15) = (-Efd(3)-(200*((Ks*Vs(2))+Vref(3) - V(4))))/0.01;

    w_b = 0;
    H_total = 0;
    for m = 1:3
        w_b = w_b + w(m)*H(m);
    end
    
    % PSS on G2
    % Vwdot2 = (1/Tw)*(-1*Vw(1)+Tw*((w(1)-1)*omega_s));
    % Vcdot2 = (1/Tb)*(-1*Vs(1)+Vw(1)+Ta*(Vwdot2));
    % F(13) = (-Efd(1)-(200*((Ks*Vs(1))+Vref(1) - V(2))))/0.01;
    % 
    % % PSS on G3
    % Vwdot3 = (1/Tw)*(-1*Vw(2)+Tw*((w(2)-1)*omega_s));
    % Vcdot3 = (1/Tb)*(-1*Vs(2)+Vw(2)+Ta*(Vwdot3));
    % F(14) = (-Efd(2)-(200*((Ks*Vs(2))+Vref(2) - V(3))))/0.01;
    
    % F = [F; Vwdot2; Vcdot2];
    % F = [F; Vwdot2; Vwdot3; Vcdot2; Vcdot3];
end