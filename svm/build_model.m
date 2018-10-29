function [calibration, validation] = build_model(num_files, file_names, abs_data, qua_data, smp_size, rng_size)

time = zeros(1, num_files);
field1 = {'correlation' 'rpearson' 'rsquare' 'rmsec' 'sec' 'bias'};
field2 = {'correlation' 'rpearson' 'rsquare' 'rmsecv' 'secv' 'bias'};
[m,n] = size(field1);
cells = cell(num_files, n);
cells(:,:) = {0};

calibration = struct(field1{1}, cells, field1{2}, cells, field1{3}, cells, field1{4}, cells, field1{5}, cells, field1{6}, cells); 
validation = struct(field2{1}, cells, field2{2}, cells, field2{3}, cells, field2{4}, cells, field2{5}, cells, field2{6}, cells);

text6 = getappdata(0, 'text6');
options = svm('options');
options.display = 'off'; 
options.plots = 'none';
options.gamma = [10^-6 10^-3];
options.cost = [10 100000];
options.epsilon = 0.1;
%options.compression = 'pca';

for i=1:num_files
    set(text6, 'string', file_names(1,i));
    abs_data2 = twodmatrix(abs_data, smp_size, rng_size, i);
    tic
    model = svm(abs_data2(:,:), qua_data(i,:), options);
    aux = toc;
    time(1,i) = aux;
    
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
    validation(i).secv = val_secv(model.detail.cvpred, smp_size, model.detail.cvbias, i, qua_data);
    validation(i).bias = model.detail.cvbias;
end
setappdata(0, 'time', time);
end

function abs_data2 = twodmatrix(abs_data, smp_size, rng_size, index)

abs_data2 = zeros(smp_size, rng_size);
for i=1:smp_size
    for j=1:rng_size
        abs_data2(i,j) = abs_data(index,i,j);
    end
end
end

function sec = cal_sec(rmsec, smp_size)
num = (rmsec.^2) * smp_size;
den = smp_size - 1;

sec = sqrt(num/den);
end

function rsquare = val_rsquare(qua_data, cumpress, smp_size)

med = mean(qua_data(1,:));
sum = 0;

for i=1:smp_size
    qua_data(1,i) = (qua_data(1,i)-med).^2;
    sum = sum + qua_data(1,i);
end
sum = sum/(smp_size-2);
rsquare = (sum - (cumpress/smp_size))/sum;

end

function secv = val_secv(pred, smp_size, bias, index, qua_data)
secv = 0;

for i=1:smp_size
    df = (pred(i, 1) - qua_data(index, i) - bias).^2;
    secv = secv + df;
end
secv = sqrt(secv/(smp_size-1));
end