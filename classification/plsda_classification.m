function [info_struct, pred_struct] = plsda_classification(classes, x_block, y_block, x_pred_block, y_pred_block)

options = plsda('options');
options.display = 'off';
options.plots = 'none';

[mcx,~,~] = mncn(x_block,options);
[mcy,~,~] = mncn(y_block,options);

lv = optimal_lv(mcx, mcy);
info_struct = struct('lv_number', lv);

model = pls(mcx, mcy, lv, options);
pred_struct = predict_plsda(classes, model, options, x_pred_block, y_pred_block);
end

function lv_num = optimal_lv(x_block, y_block)
options = crossval('options');
options.display = 'off';
options.plots = 'off';

results = crossval(x_block, y_block, 'sim', 'loo', 20, options);

lvs = [];
k=1;

for j=1:19
    aux = results.rmsecv(j)/results.rmsecv(j+1);
    if aux > 1
        if ((aux - 1)*100 >= 2)
            lvs(k) = j+1;
            k = k+1;
        end
    end
end

if (k==1)
    k=k+1;
    lvs(k-1) = 1;
end
lv_num = lvs(k-1);
[~,ssq] = pls(x_block, y_block, lvs(k-1));

for w=1:(k-2)
    if (ssq(lvs(w+1),4) < 1)
        lv_num = lvs(w);
        break;
    end
end
end

function predictions = get_predictions(thresholds, probabilities)

n_classes = getappdata(0, 'n_classes');
classes = getappdata(0, 'classes');

min_value = min(probabilities);
max_value = max(probabilities);

ranges = zeros(n_classes, 2);
ranges(1,1) = min_value;
ranges(1,2) = thresholds(1,1);
ranges(end,1) = thresholds(1,end);
ranges(end,2) = max_value;

for i=2:(n_classes-1)
    ranges(i,1) = thresholds(1,i-1);
    ranges(i,2) = thresholds(1,i);
end

n = max(size(probabilities));
predictions = zeros(n,1);

for i=1:n
    for j=1:n_classes
        if(probabilities(i,1) > ranges(j,1) && probabilities(i,1) < ranges(j,2))
            predictions(i,1) = classes(j);
        end    
    end
end
end

function pred_struct = predict_plsda(classes, model, options, x_pred_block, y_pred_block)

[mcx,~,~] = mncn(x_pred_block,options);
[mcy,my,~] = mncn(y_pred_block,options);
pred = pls(mcx, mcy, model, options);
pred_rescaled = rescale(pred.pred{2}, my);

thresholds = bayesian(y_pred_block, classes);
predictions = get_predictions(thresholds, pred_rescaled);

metrics = calculate_metrics(classes, predictions, y_pred_block);
pred_struct = struct('sensitivity', metrics.sensitivity, 'specificity', metrics.specificity, 'accuracy', metrics.accuracy, 'conf_matrix', metrics.conf_matrix);
end
