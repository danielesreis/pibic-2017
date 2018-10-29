function pretreat_routine_complete()

dest_folder = getappdata(0, 'dest_folder');
files_folder = getappdata(0, 'files_folder');
text_att = getappdata(0, 'text_att');
check_msc = getappdata(0, 'check_msc');
check_snv = getappdata(0, 'check_snv');
check_1sgolay = getappdata(0, 'check_1sgolay');
check_2sgolay = getappdata(0, 'check_2sgolay');

wsizemfilter = getappdata(0, 'edit_wsizemfilter');
wsizemfilter = strsplit(wsizemfilter, ',');
wsizemfilter = str2double(wsizemfilter);
num_median = numel(wsizemfilter);

wsizemaverage = getappdata(0, 'edit_wsizemaverage');
wsizemaverage = strsplit(wsizemaverage, ',');
wsizemaverage = str2double(wsizemaverage);
num_average = numel(wsizemaverage);

if eq(check_1sgolay, 1)
    porder1 = getappdata(0, 'edit_porder1');
    porder1 = strsplit(porder1, ',');
    porder1 = str2double(porder1);
    % num_porder1 = numel(porder1);
    
    wsize1sgolay = getappdata(0, 'edit_wsize1sgolay');
    wsize1sgolay = strsplit(wsize1sgolay, ',');
    wsize1sgolay = str2double(wsize1sgolay);
    num_wsize1 = numel(wsize1sgolay);
end

if eq(check_2sgolay, 1)
    porder2 = getappdata(0, 'edit_porder2');
    porder2 = strsplit(porder2, ',');
    porder2 = str2double(porder2);
    % num_porder2 = numel(porder2);
    
    wsize2sgolay = getappdata(0, 'edit_wsize2sgolay');
    wsize2sgolay = strsplit(wsize2sgolay, ',');
    wsize2sgolay = str2double(wsize2sgolay);
    num_wsize2 = numel(wsize2sgolay);
end

[num_files, files_names, files_paths] = files_routine(files_folder);

for i=1:num_files
    set(text_att, 'string', files_names{i});
    
    [read,str] = xlsread(files_paths{i, 1});
    variety_x = read(1, 4:end);
    att_text = str{1,3};
    setappdata(0, 'att_text', att_text);
    setappdata(0, 'variety_x', variety_x);
    data = read(2:end, 3:end);

    [m, n] = size(data);
    setappdata(0, 'smp_size', m);
    setappdata(0, 'rng_size', n-1);

    c = cell(1,1);
    c{1,1} = num2cell(data);
    data = c;
    aux = cell2mat(data{1});
    att = num2cell(aux(1:end, 1));
    abs = aux(1:end, 2:end);
    
    for j=1:num_median
        pre_data = median_filter(abs, wsizemfilter(j));
        pre_name = strcat(files_names{i}, '_MF', num2str(wsizemfilter(j)));
        export(files_names{i}, pre_name, num2cell(double(pre_data)), att, dest_folder);
        
        if eq(check_1sgolay, 1)
            for k=1:num_wsize1
                pre_data1 = savgol(pre_data, wsize1sgolay(1, k), porder1(1, 1), 1);
                window_half = (wsize1sgolay(1, k)-1)/2;
                pre_data1(:, 1:window_half) = 0;
                pre_data1(:, (n - window_half):end) = 0;

                pre_name1 = strcat(pre_name, '_SG1st', num2str(porder1(1, 1)), 'x', num2str(wsize1sgolay(1, k)));
                pre_data1 = num2cell(pre_data1);

                export(files_names{i}, pre_name1, pre_data1, att, dest_folder);
                
                if eq(check_msc, 1)
                    pre_data_msc = preprocess('calibrate', 'msc', cell2mat(pre_data1));
                    pre_name_msc = strcat(pre_name1, '_MSC');
                    export(files_names{i}, pre_name_msc, num2cell(double(pre_data_msc)), att, dest_folder);
                end

                if eq(check_snv, 1)
                    pre_data_snv = preprocess('calibrate', 'snv', cell2mat(pre_data1));
                    pre_name_snv = strcat(pre_name1, '_SNV');
                    export(files_names{i}, pre_name_snv, num2cell(double(pre_data_snv)), att, dest_folder);
                end
            end
        end

        if eq(check_2sgolay, 1)
            for k=1:num_wsize2
                pre_data2 = savgol(pre_data, wsize2sgolay(1, k), porder2(1, 1), 2);
                window_half = (wsize2sgolay(1, k)-1)/2;
                pre_data2(:, 1:window_half) = 0;
                pre_data2(:, (n - window_half):end) = 0;

                pre_name2 = strcat(pre_name, 'SG2nd', num2str(porder2(1, 1)), 'x', num2str(wsize2sgolay(1, k)));
                pre_data2 = num2cell(pre_data2);

                export(files_names{i}, pre_name2, pre_data2, att, dest_folder);
    
                if eq(check_msc, 1)
                    pre_data_msc = preprocess('calibrate', 'msc', cell2mat(pre_data2));
                    pre_name_msc = strcat(pre_name2, '_MSC');
                    export(files_names{i}, pre_name_msc, num2cell(double(pre_data_msc)), att, dest_folder);
                end
                
                if eq(check_msv, 1)
                    pre_data_snv = preprocess('calibrate', 'snv', cell2mat(pre_data2));
                    pre_name_snv = strcat(pre_name2, '_SNV');
                    export(files_names{i}, pre_name_snv, num2cell(double(pre_data_snv)), att, dest_folder);
                end
            end
        end
    end

    for j=1:num_average
        pre_data = moving_average(abs, wsizemaverage(j));
        pre_name = strcat(files_names{i}, '_MA', num2str(wsizemaverage(j)));
        export(files_names{i}, pre_name, num2cell(double(pre_data)), att, dest_folder);

        if eq(check_1sgolay, 1)
            for k=1:num_wsize1
                pre_data1 = savgol(pre_data, wsize1sgolay(1, k), porder1(1, 1), 1);
                window_half = (wsize1sgolay(1, k)-1)/2;
                pre_data1(:, 1:window_half) = 0;
                pre_data1(:, (n - window_half):end) = 0;

                pre_name1 = strcat(pre_name, '_SG1st', num2str(porder1(1, 1)), 'x', num2str(wsize1sgolay(1, k)));
                pre_data1 = num2cell(pre_data1);

                export(files_names{i}, pre_name1, pre_data1, att, dest_folder);
                
                if eq(check_msc, 1)
                    pre_data_msc = preprocess('calibrate', 'msc', cell2mat(pre_data1));
                    pre_name_msc = strcat(pre_name1, '_MSC');
                    export(files_names{i}, pre_name_msc, num2cell(double(pre_data_msc)), att, dest_folder);
                end

                if eq(check_snv, 1)
                    pre_data_snv = preprocess('calibrate', 'snv', cell2mat(pre_data1));
                    pre_name_snv = strcat(pre_name1, '_SNV');
                    export(files_names{i}, pre_name_snv, num2cell(double(pre_data_snv)), att, dest_folder);
                end
            end
        end

        if eq(check_2sgolay, 1)
            for k=1:num_wsize2
                pre_data2 = savgol(pre_data, wsize2sgolay(1, k), porder2(1, 1), 2);
                window_half = (wsize2sgolay(1, k)-1)/2;
                pre_data2(:, 1:window_half) = 0;
                pre_data2(:, (n - window_half):end) = 0;

                pre_name2 = strcat(pre_name, 'SG2nd', num2str(porder2(1, 1)), 'x', num2str(wsize2sgolay(1, k)));
                pre_data2 = num2cell(pre_data2);

                export(files_names{i}, pre_name2, pre_data2, att, dest_folder);
    
                if eq(check_msc, 1)
                    pre_data_msc = preprocess('calibrate', 'msc', cell2mat(pre_data2));
                    pre_name_msc = strcat(pre_name2, '_MSC');
                    export(files_names{i}, pre_name_msc, num2cell(double(pre_data_msc)), att, dest_folder);
                end
                
                if eq(check_msv, 1)
                    pre_data_snv = preprocess('calibrate', 'snv', cell2mat(pre_data2));
                    pre_name_snv = strcat(pre_name2, '_SNV');
                    export(files_names{i}, pre_name_snv, num2cell(double(pre_data_snv)), att, dest_folder);
                end
            end
        end
    end
end