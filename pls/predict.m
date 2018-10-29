function prediction = predict(model, pred_abs, pred_qua, prediction)

[t,~] = size(pred_qua);
[pred_abs_scaled,~] = mncn2(pred_abs);
[pred_qua_scaled,~] = mncn2(pred_qua);

options = pls('options');
options.display = 'off';
options.plots = 'none';
pred = pls(pred_abs_scaled, pred_qua_scaled, model, options);

prediction.rpearson = pred.detail.r2p;
prediction.correlation = sqrt(prediction.rpearson);
prediction.rsquare = rsquare(pred_qua, pred.ssqresiduals{2,2}, t);
prediction.rmsep = pred.detail.rmsep;
prediction.secp = secv(pred.pred{2}, t, pred.detail.predbias, pred_qua);
prediction.bias = pred.detail.predbias;
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