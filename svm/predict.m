function prediction = predict(model, pred_abs_data, pred_qua_data, prediction)

pred = svm(pred_abs_data, pred_qua_data, model, options);

prediction.rpearson = pred.detail.r2p;
prediction.correlation = sqrt(prediction.rpearson);
prediction.rsquare = rsquare(pred_data_y, pred.ssqresiduals{2,2}, t);
prediction.rmsep = pred.detail.rmsep;
prediction.secp = secv(pred.pred{2}, t, pred.detail.predbias, pred_data_y);
prediction.bias = pred.detail.predbias;
end

function sec = cal_sec(rmsec, smp_size)
num = (rmsec.^2) * smp_size;
den = smp_size - 1;

sec = sqrt(num/den);
end

function r = rsquare(qua_data, cumpress, smp_size)

med = mean(qua_data(:,1));
sum = 0;

for i=1:smp_size
    qua_data(i,1) = (qua_data(i,1)-med).^2;
    sum = sum + qua_data(i,1);
end
sum = sum/(smp_size-2);
r = (sum - (cumpress/smp_size))/sum;

end

function s = secv(pred, smp_size, bias, qua_data)

s = 0;

for i=1:smp_size
    df = (pred(i, 1) - qua_data(i, 1) - bias).^2;
    s = s + df;
end
s = sqrt(s/(smp_size-1));
end

function export(calibration, validation, prediction, att, var, c, p, time, path)

print = [calibration.correlation calibration.rpearson calibration.rsquare calibration.rmsec calibration.sec calibration.bias ...
    validation.correlation validation.rpearson validation.rsquare validation.rmsecv validation.secv validation.bias ...
    prediction.correlation prediction.rpearson prediction.rsquare prediction.rmsep prediction.secp prediction.bias c p time];

A{2, 1} = '';
for j=2:22
    A{2, j} = print(j-1);
end

range = strcat('A2:V2');
xlswrite(path, A(2,:), strcat(att, '_', var), range);

end

