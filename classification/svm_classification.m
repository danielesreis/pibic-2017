function [info_struct, pred_struct] = svm_classification(classes, x_block, y_block, x_pred_block, y_pred_block)

options = svmda('options');
options.display = 'off';
options.kerneltype = 'linear';
options.cvtimelimit = 20;
options.splits = 10;
options.cost = [10^-3 10^-2 10^-1 10^0 10^1 10^2 10^3 10^4];

model = svmda(x_block, y_block, options);

sv_number = model.detail.svm.model.l;
best_c = model.detail.svm.cvscan.best.c;

info_struct = struct('sv_number', sv_number, 'best_c', best_c);
pred_struct = predict_svmda(classes, model, options, x_pred_block, y_pred_block);
end

function pred_struct = predict_svmda(classes, model, options, x_pred_block, y_pred_block)

pred = svmda(x_pred_block, y_pred_block, model, options);

metrics = calculate_metrics(classes, pred.pred{2}, y_pred_block);
pred_struct = struct('sensitivity', metrics.sensitivity, 'specificity', metrics.specificity, 'accuracy', metrics.accuracy, ...
    'conf_matrix', metrics.conf_matrix);
end