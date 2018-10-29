function main(train_path, train_file, dest_folder, train_number, predict_path)

[num,~,~] = xlsread(predict_path);
x_pred_block = num(2:end, 4:end);
y_pred_block = num(2:end, 3);

for i=1:train_number
    [num,~,~] = xlsread(strcat(train_path, '\', train_file{i,1}));
    x_block = num(2:end, 4:end);
    y_block = num(2:end, 3);
        
    classes = unique(y_block);
    
    [info_struct, pred_struct] = plsda_classification(classes, x_block, y_block, x_pred_block, y_pred_block);
    export(dest_folder, train_file{i,1}, info_struct, pred_struct, 'PLS-DA');
    [info_struct, pred_struct] = svm_classification(classes, x_block, y_block, x_pred_block, y_pred_block);
    export(dest_folder, train_file{i,1}, info_struct, pred_struct, 'SVM');
end
end