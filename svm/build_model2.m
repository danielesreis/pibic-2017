function build_model2(num_files, file_names, variety, smp_size, prediction_path)

%time = zeros(1, num_files);
qua_text = getappdata(0, 'qua_text');
field1 = {'correlation' 'rpearson' 'rsquare' 'rmsec' 'sec' 'bias'};
field2 = {'correlation' 'rpearson' 'rsquare' 'rmsecv' 'secv' 'bias'};
field3 = {'correlation' 'rpearson' 'rsquare' 'rmsep' 'secp' 'bias'};
[~,n] = size(field1);
cells = cell(num_files, n);
cells(:,:) = {0};

calibration = struct(field1{1}, cells, field1{2}, cells, field1{3}, cells, field1{4}, cells, field1{5}, cells, field1{6}, cells); 
validation = struct(field2{1}, cells, field2{2}, cells, field2{3}, cells, field2{4}, cells, field2{5}, cells, field2{6}, cells);
prediction = struct(field3{1}, cells, field3{2}, cells, field3{3}, cells, field3{4}, cells, field3{5}, cells, field3{6}, cells);

if (isempty(prediction_path) == 0)
    pred_data = xlsread(prediction_path);
    pred_abs_data = pred_data(2:end, 4:end);
    pred_qua_data = pred_data(2:end, 3);
end

cpred = cell(num_files, 1);
cvpred = cell(num_files, 1);
c = cell(num_files, 1);
g = cell(num_files, 1);

text6 = getappdata(0, 'text6');
options = svm('options');
options.display = 'off'; 
options.plots = 'none';
options.kerneltype = 'linear';
%options.gamma = [10^-1 1 10];
options.cost = [10^-3 10^-2 10^-1 10^0 10^1 10^2 10^3 10^4];
options.epsilon = 0.1;
options.splits = 10;

for i=1:num_files
    set(text6, 'string', strcat(qua_text, '_', file_names(1, i)));
    data = xlsread(variety{i, 1});
    abs_data2 = data(2:end, 4:end);
    qua_data = data(2:end, 3);
    
    model = svm(abs_data2, qua_data, options);
    
    if (isempty(prediction_path) == 0)
        prediction = predict(model, pred_abs_data, pred_qua_data, prediction);
    end
        
    cpred{i, 1} = model.pred{1, 2};
    cvpred{i, 1} = model.detail.cvpred;
    c{i, 1} = model.detail.svm.cvscan.best.c;
    
    calibration(i).rpearson = model.detail.r2c;
    calibration(i).correlation = sqrt(calibration(i).rpearson);
    calibration(i).rsquare = model.detail.r2y;
    calibration(i).rmsec = model.detail.rmsec;
    calibration(i).sec = cal_sec(calibration(i).rmsec, smp_size);
    calibration(i).bias = model.detail.bias;
    
    validation(i).rpearson = model.detail.r2cv;
    validation(i).correlation = sqrt(validation(i).rpearson);
    validation(i).rsquare = val_rsquare(qua_data, model.ssqresiduals{2,2}, smp_size);
    validation(i).rmsecv = model.detail.rmsecv;
    validation(i).secv = val_secv(model.detail.cvpred, smp_size, model.detail.cvbias, qua_data);
    validation(i).bias = model.detail.cvbias;
    
    export(calibration(i), validation(i), prediction, i, file_names, c{i, 1});
end
setappdata(0, 'calibration', calibration);
setappdata(0, 'validation', validation);
setappdata(0, 'cpred', cpred);
setappdata(0, 'cvpred', cvpred);

print_results(calibration(1), validation(1));
plot_points(cpred{1, 1}, smp_size, 'blue');
end

% function abs_data2 = twodmatrix(abs_data, smp_size, rng_size, index)
% 
% abs_data2 = zeros(smp_size, rng_size);
% for i=1:smp_size
%     for j=1:rng_size
%         abs_data2(i,j) = abs_data(index,i,j);
%     end
% end
% end

function sec = cal_sec(rmsec, smp_size)
num = (rmsec.^2) * smp_size;
den = smp_size - 1;

sec = sqrt(num/den);
end

function rsquare = val_rsquare(qua_data, cumpress, smp_size)

med = mean(qua_data(:,1));
sum = 0;

for i=1:smp_size
    qua_data(i,1) = (qua_data(i,1)-med).^2;
    sum = sum + qua_data(i,1);
end
sum = sum/(smp_size-2);
rsquare = (sum - (cumpress/smp_size))/sum;

end

function secv = val_secv(pred, smp_size, bias, qua_data)

secv = 0;

for i=1:smp_size
    df = (pred(i, 1) - qua_data(i, 1) - bias).^2;
    secv = secv + df;
end
secv = sqrt(secv/(smp_size-1));
end