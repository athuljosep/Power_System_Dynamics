function mplot_eigen(x1,y1,x2,y2)
x_label = 'Real part'; % x axis label
y_label = 'Imaginary part'; % y axis label

legend_name = {'without PSS','with PSS'}; % legend names

%%%%%%% Theta fig
figure('Renderer', 'painters', 'Position', [10 10 1000 800])
plot(x1,y1,'or','LineWidth',2,'MarkerSize',20)
hold on
plot(x2,y2,'xb','LineWidth',2,'MarkerSize',20)
xlim([-105.0 5.0])
ylim([-7.0 7.0])
% plot(x,y(3,:),'-k','LineWidth',1.5)
xlabel(x_label,'FontSize',18,'FontName','Times New Roman')
ylabel(y_label,'FontSize',18,'FontName','Times New Roman')
legend (legend_name,'Location','northeast')
set(gca,'fontsize',16,'Fontname','Times New Roman','GridAlpha',0.5)
ax = gca

ax.XRuler.Axle.LineWidth = 1.5;
ax.YRuler.Axle.LineWidth = 1.5;
grid
grid minor
legend (legend_name,'Location','northwest')
saveas(gca,['eigen_plot.png'])

end