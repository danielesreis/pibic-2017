%função que imprime valores na tela
function print_results(calibration, validation)
h_cal = getappdata(0, 'h_cal');
h_val = getappdata(0, 'h_val');

str1 = {'Correlation:' 'R2 (Pearson):' 'R-square:' 'RMSEC:' 'SEC:' 'Bias:'};
str2 = {'Correlation:' 'R2 (Pearson):' 'R-square:' 'RMSECV:' 'SECV:' 'Bias:'};

%calibração
set(h_cal(1), 'string', [str1{1}, ' ', num2str(calibration.correlation, '%.7f')]);
set(h_cal(2), 'string', [str1{2}, ' ', num2str(calibration.rpearson, '%.7f')]);
set(h_cal(3), 'string', [str1{3}, ' ', num2str(calibration.rsquare, '%.7f')]);
set(h_cal(4), 'string', [str1{4}, ' ', num2str(calibration.rmsec, '%.7f')]);
set(h_cal(5), 'string', [str1{5}, ' ', num2str(calibration.sec, '%.7f')]);
set(h_cal(6), 'string', [str1{6}, ' ', num2str(calibration.bias, '%.7f')]);

%validação
set(h_val(1), 'string', [str2{1}, ' ', num2str(validation.correlation, '%.7f')]);
set(h_val(2), 'string', [str2{2}, ' ', num2str(validation.rpearson, '%.7f')]);
set(h_val(3), 'string', [str2{3}, ' ', num2str(validation.rsquare, '%.7f')]);
set(h_val(4), 'string', [str2{4}, ' ', num2str(validation.rmsecv, '%.7f')]);
set(h_val(5), 'string', [str2{5}, ' ', num2str(validation.secv, '%.7f')]);
set(h_val(6), 'string', [str2{6}, ' ', num2str(validation.bias, '%.7f')]);
end