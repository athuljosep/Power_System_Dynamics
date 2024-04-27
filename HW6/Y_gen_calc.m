function Y_gen = Y_gen_calc(Y)
    Y_gen = Y(1:4,1:4)-(Y(1:4,5:14)*inv(Y(5:14,5:14)) *Y(5:14,1:4));
end