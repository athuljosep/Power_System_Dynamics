function Y =  y_update(Y)
x = 0.5
i = 6
j = 7
Y = Y
yl = Y(i,j)
Y(i,i) = Y(i,i) + yl*(1-(1/x))
Y(j,j) = Y(j,j) + yl*(1-(1/(1-x)))
Y(i,j) = 0
Y(j,i) = 0
end