function plot_points(pts, smp_size, color)

axes1 = getappdata(0, 'axes1');
%qua_data = getappdata(0, 'qua_data');
qua_data = evalin('base','qua_data');
for i=1:smp_size
    plot(axes1, qua_data(i, 1), pts(i, 1), strcat(color, 'o'), 'MarkerFaceColor', color, 'MarkerSize', 3);
    hold on
end
hold off
end