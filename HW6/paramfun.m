function F = paramfun(x,P,Y,E)
    omega_s = 2*pi*60;
    Ym = abs(Y);
    Ya = angle(Y);
    F = [];
    for k = 1:3
        i = k+1;
        Pe = Ym(i,1)*E(i)*E(1)*cos(x((2*k)-1)-Ya(i,1));
        for j = 2:4
            Pe = Pe + Ym(i,j)*E(i)*E(j)*cos(x((2*k)-1)-x((2*j)-3)-Ya(i,j));
        end
        % (w-1)ws; Pm - Pe - Kd(w-1)
        F1 = [(x(2*k)-1)*omega_s;  P(k)-Pe-(2*(x(2*k)-1))];
        F = [F F1];
    end
end