function export(calibration, validation, prediction, index, file_names, c)

var_text = getappdata(0, 'var_text');
qua_text = getappdata(0, 'qua_text');
path = getappdata(0, 'dest_folder');

file = dir(fullfile(path, strcat(var_text, '*.xlsx')));
path = fullfile(path, file.name);
data = xlsread(path, strcat(qua_text, '_', var_text));
[m,~] = size(data);

aux = [calibration.correlation calibration.rpearson calibration.rsquare calibration.rmsec calibration.sec ...
       calibration.bias validation.correlation validation.rpearson validation.rsquare validation.rmsecv ...
       validation.secv validation.bias prediction.correlation prediction.rpearson prediction.rsquare ...
       prediction.rmsec prediction.sec prediction.bias c]; 
   
A{m+2,1} = strcat('SVM_', file_names{index});

for j=2:20
    A{m+2,j} = aux(j-1);
end

range = strcat('A', num2str(m+2), ':', 'T', num2str(m+2));
xlswrite(path, A(m+2,:), strcat(qua_text, '_', var_text), range);
end