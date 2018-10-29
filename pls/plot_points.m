function plot_points(pts, smp_size, current_file, color)

lv = getappdata(0, 'lv');
axes1 = getappdata(0, 'axes1');
m_qua = getappdata(0, 'm_qua');
max_lv = getappdata(0, 'max_lv');
qua_data = getappdata(0, 'qua_data');

pts2 = zeros(smp_size, max_lv);
for i=1:smp_size
    for j=1:max_lv
        pts2(i,j) = pts(i,:,j);
    end
end

pts3 = rescale2(pts2(:, lv(current_file, 1)), m_qua);

for i=1:smp_size
    plot(axes1, qua_data(i, 1), pts3(i, 1), strcat(color, 'o'), 'MarkerFaceColor', color, 'MarkerSize', 3);
    hold on
end
hold off
end