function mplot(x,y,label)
x_label = 'Time (sec)'; % x axis label
y_label = label; % y axis label

legend_name = {'Gen 2','Gen 3', 'Gen 4'}; % legend names

%%%%%%% Theta fig
figure('Renderer', 'painters', 'Position', [10 10 1000 400])
plot(x,y(1,:),'-b','LineWidth',1.5)
hold on
plot(x,y(2,:),'-r','LineWidth',1.5)
plot(x,y(3,:),'-k','LineWidth',1.5)
xlabel(x_label,'FontSize',18,'FontName','Times New Roman')
ylabel(y_label,'FontSize',18,'FontName','Times New Roman')
legend (legend_name,'Location','northeast')
set(gca,'fontsize',16,'Fontname','Times New Roman','GridAlpha',0.5)
ax = gca

ax.XRuler.Axle.LineWidth = 1.5;
ax.YRuler.Axle.LineWidth = 1.5;
grid
grid minor
% legend (legend_name,'Location','southeast')
saveas(gca,[label '_plot.png'])

end