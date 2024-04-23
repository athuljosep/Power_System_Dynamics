%%%%%%%%%%%%%%%%%% Type 2 Forumulation %%%%%%%%%%%%%%%%%%%%
function F = type2(t, w, Eq, Ed, Efd, Pm, Vref, Pc, P,Y,E, V,T)
    %Vref = [1.019 1.040 1.019];
    H = [6.5 6.175 6.175];
    omega_s = 2*pi*60;
    Xd = (1.8 + 1.7)/2/9;
    Xdp = (0.3 + 0.55)/2/9;
    Ym = abs(Y);
    Ya = angle(Y);
    F = [];
    
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
              (Pm(k)-Pe-(2*(w(k)-1)))/(2*H(k)*9),
              (-Eq(k)-((Xd-Xdp)*Id)+Efd(k))/8,
              (-Ed(k)+((Xd-Xdp)*Iq))/0.4,
              (-Efd(k)+(200*(Vref(k) - V(i))))/0.01,
              (-Pm(k)+Pc(k)+((1/0.05)*(1-w(k))))/300,
              Ed(k) - (V(i)*sin(t(k)-T(i))) + Iq*Xdp
              Eq(k) - (V(i)*cos(t(k)-T(i))) - Id*Xdp];

        F = [F F1];
    end
    F = [F(1,:) F(2,:) F(3,:) F(4,:) F(5,:) F(6,:) F(7,:) F(8,:)].';
end