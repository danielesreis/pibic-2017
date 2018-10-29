function [data_corr, new_names] = scattercor(data, names, att)

[~,n] = size(data);
check_msc = getappdata(0, 'check_msc');
check_snv = getappdata(0, 'check_snv');

for i=1:n
    data{1, i} = [att'; data{1, i}'];
    data{1, i} = data{1, i}';
end

if (eq(check_msc, 1) && eq(check_snv, 1))
    
    data_corr = cell(1, 2*n);
    new_names = cell(1, 2*n);
    for i=1:n
        data_corr{1, i} = preprocess('calibrate', 'msc', data{1, i});
        new_names{1, i} = strcat(names{i}, '_MSC');

        data_corr{1, n + i} = preprocess('calibrate', 'snv', data{1, i});
        new_names{1, n + i} = strcat(names{i}, '_SNV');
    end
    
elseif (eq(check_msc, 1) && eq(check_snv, 0))
    
    data_corr = cell(1, n);
    new_names = cell(1, n);
    for i=1:n
        data_corr{1, i} = preprocess('calibrate', 'msc', data{1, i});
        new_names{1, i} = strcat(names{i}, '_SNV');
    end
    
else
    
    data_corr = cell(1, n);
    new_names = cell(1, n);
    for i=1:n
        data_corr{1, i} = preprocess('calibrate', 'snv', data{1, i});
        new_names{1, i} = strcat(names{i}, '_SNV');
    end
end
end