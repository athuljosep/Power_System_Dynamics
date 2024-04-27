function F = type3(t,w,P,Y,E)
    H = [6.5 6.175 6.175];
    Kd = 2;
    omega_s = 2*pi*60;
    Ym = abs(Y);
    Ya = angle(Y);
    F = [];
    for k = 1:3
        i = k+1;
        Pe = Ym(i,1)*E(i)*E(1)*cos(t(k)-Ya(i,1));
        for j = 2:4
            Pe = Pe + Ym(i,j)*E(i)*E(j)*cos(t(k)-t(j-1)-Ya(i,j));
        end
        % (w-1)ws; Pm - Pe - Kd(w-1)
        F1 = [(w(k)-1)*omega_s,
              (P(k)-Pe-(Kd*(w(k)-1)))/(2*H(k)*9)];
        F = [F F1];
    end
    F = [F(1,:) F(2,:)].';
end