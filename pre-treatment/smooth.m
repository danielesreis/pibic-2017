function [data_smoothed, new_names] = smooth(data, name)

abs = data{1};
abs = cell2mat(abs);

check_medianfilter = getappdata(0, 'check_medianfilter');
check_movingaverage = getappdata(0, 'check_movingaverage');

if (eq(check_medianfilter, 1) && eq(check_movingaverage, 1))
    
    wsizemfilter = getappdata(0, 'edit_wsizemfilter');
    wsizemfilter = strsplit(wsizemfilter, ',');
    wsizemfilter = str2double(wsizemfilter);
    num_median = numel(wsizemfilter);

    wsizemaverage = getappdata(0, 'edit_wsizemaverage');
    wsizemaverage = strsplit(wsizemaverage, ',');
    wsizemaverage = str2double(wsizemaverage);
    num_average = numel(wsizemaverage);

    data_smoothed = cell(1, num_median + num_average);
    new_names = cell(1, num_median + num_average);

    for i=1:num_median
        data_smoothed{1, i} = median_filter(abs(1:end, 2:end), wsizemfilter(i));
        new_names{1, i} = strcat(name, '_MF', num2str(wsizemfilter(i)));
    end

    for i=(num_median + 1):(num_average + num_median)
        data_smoothed{1, i} = moving_average(abs(1:end,2:end), wsizemaverage(i-num_average-1));
        new_names{1, i} = strcat(name, '_MA', num2str(wsizemaverage(i-num_average-1)));
    end
    
elseif (eq(check_medianfilter, 1) && eq(check_movingaverage, 0))
    
    wsizemfilter = getappdata(0, 'edit_wsizemfilter');
    wsizemfilter = strsplit(wsizemfilter, ',');
    wsizemfilter = str2double(wsizemfilter);
    num_median = numel(wsizemfilter);

    data_smoothed = cell(1, num_median);
    new_names = cell(1, num_median);

    for i=1:num_median
        data_smoothed{1, i} = median_filter(abs(1:end,2:end), wsizemfilter(i));
        new_names{1, i} = strcat(name, '_MF', num2str(wsizemfilter(i)));
    end
    
else
    
    wsizemaverage = getappdata(0, 'edit_wsizemaverage');
    wsizemaverage = strsplit(wsizemaverage, ',');
    wsizemaverage = str2double(wsizemaverage);
    num_average = numel(wsizemaverage);

    data_smoothed = cell(1, num_average);
    new_names = cell(1, num_average);

    for i=1:num_average
        data_smoothed{1, i} = moving_average(abs(1:end,2:end), wsizemaverage(i));
        new_names{1, i} = strcat(name, '_MA', num2str(wsizemaverage(i)));
    end
end
end