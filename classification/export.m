function export(dest_folder, train_file, info_struct, pred_struct, title)

n_classes = getappdata(0, 'n_classes');
train_file = strsplit(train_file, '.');
title = strcat(dest_folder, '\', train_file{1,1}, '_', title, '.xlsx');

field_names_info = fieldnames(info_struct);
[n,~] = size(field_names_info);

field_names_pred = fieldnames(pred_struct);
[m,~] = size(field_names_pred);

range = strcat('A1:J', num2str(6+n_classes*3));

cells = cell(6+n_classes*3,10);
for i=1:n
    cells{1,i} = field_names_info{i,1};
    num_data = size(getfield(info_struct, field_names_info{i,1}));
    cells(2:max(num_data)+1,i) = num2cell(getfield(info_struct, field_names_info{i,1}));
end

for i=1:(m-1)
    cells{n_classes+2, i} = field_names_pred{i,1};
    num_data = size(getfield(pred_struct, field_names_pred{i,1}));
    cells((n_classes+3):(n_classes+max(num_data)+2),i) = num2cell(getfield(pred_struct, field_names_pred{i,1}));
end

%conf matrix
cells((n_classes+max(num_data)+4), 1) = {'Confusion matrix'};
cells((n_classes+max(num_data)+5):(n_classes+max(num_data)+7), 1:n_classes) = num2cell(pred_struct.conf_matrix);

xlswrite(title, cells, range);
end