function build_model2(num_files, file_names, variety, smp_size, rng_size, prediction_path)

%abs_scaled2 = zeros(smp_size, rng_size);
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

cpred = cells(num_files, 1);
cvpred = cells(num_files, 1);
lv = zeros(num_files, 1);

for i=1:num_files
    data = xlsread(variety{i, 1});
    abs_data = data(2:end, 4:end);
    qua_data = data(2:end, 3);
    
    [abs_scaled,qua_scaled,~,m_qua] = center_data(num_files, abs_data, qua_data, smp_size, rng_size);
    [results,lv_num,model] = train_model(i, abs_scaled, qua_scaled);
    
    if (isempty(prediction_path) == 0)
        prediction = predict(model, pred_abs_data, pred_qua_data, prediction);
    end
    
    lv(i, 1) = lv_num;
    cpred{i, 1} = results.cpred;
    cvpred{i, 1} = results.cvpred;
    
    calibration(i).rpearson = results.r2c(1, lv_num);
    calibration(i).correlation = sqrt(calibration(i).rpearson);
    calibration(i).rsquare = results.r2y(1, lv_num);
    calibration(i).rmsec = results.rmsec(1, lv_num);
    calibration(i).sec = cal_sec(calibration(i).rmsec, smp_size);
    calibration(i).bias = results.cbias(1, lv_num);
    
    validation(i).rpearson = results.r2cv(1, lv_num);
    validation(i).correlation = sqrt(validation(i).rpearson);
    validation(i).rsquare = val_rsquare(qua_data, results.cumpress(1, lv_num), smp_size);
    validation(i).rmsecv = results.rmsecv(1, lv_num);
    validation(i).bias = results.cvbias(1, lv_num);
    validation(i).secv = val_secv(results.cvpred, smp_size, validation(i).bias, lv_num, m_qua, qua_data);
    
    export(calibration(i), validation(i), prediction, i, file_names, lv_num);
end
setappdata(0, 'calibration', calibration);
setappdata(0, 'validation', validation);
setappdata(0, 'lv', lv);
setappdata(0, 'cpred', cpred);
setappdata(0, 'cvpred', cvpred);
setappdata(0, 'm_qua', m_qua);

print_results(calibration(1), validation(1));
plot_points(cpred{1, 1}, smp_size, 1, 'blue');
end

function sec = cal_sec(rmsec, smp_size)
num = (rmsec.^2) * smp_size;
den = smp_size - 1;
 
sec = sqrt(num/den);
end

function rsquare = val_rsquare(qua_data, cumpresslv, smp_size)

med = mean(qua_data(:,1));
sum = 0;

for i=1:smp_size
    qua_data(i,1) = (qua_data(i,1)-med).^2;
    sum = sum + qua_data(i,1);
end
sum = sum/(smp_size-2);
rsquare = (sum - (cumpresslv/smp_size))/sum;
end

function secv = val_secv(pred, smp_size, bias, lv_num, m_qua, qua_data)

secv = 0;
max_lv = getappdata(0, 'max_lv');
pred2 = zeros(smp_size, lv_num);

for i=1:smp_size
    for j=1:lv_num
        pred2(i,j) = pred(i,:,j);
    end
end

for i=1:lv_num
    pred2(:,i) = rescale2(pred2(:,i), m_qua);
end

for i=1:smp_size
    df = (pred2(i,lv_num) - qua_data(i,1) - bias).^2;
    secv = secv + df;
end
secv = sqrt(secv/(smp_size-1));

end