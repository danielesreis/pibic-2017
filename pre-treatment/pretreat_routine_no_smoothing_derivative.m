function pretreat_routine_no_smoothing()

dest_folder = getappdata(0, 'dest_folder');
files_folder = getappdata(0, 'files_folder');
text_att = getappdata(0, 'text_att');

[num_files, files_names, files_paths] = files_routine(files_folder);
read = xlsread(files_paths{1, 1});
setappdata(0, 'variety_x', read(1, 4:end));

data = read(2:end, 3:end);
[m, n] = size(data);
setappdata(0, 'smp_size', m);
setappdata(0, 'rng_size', n-1);

for i=1:num_files
    tic
    set(text_att, 'string', files_names{i});
    
    [read,str] = xlsread(files_paths{i, 1});
    att_text = str{1,3};
    setappdata(0, 'att_text', att_text);
    data = read(2:end, 3:end);

    c = cell(1,1);
    c{1,1} = num2cell(data);
    data = c;
    aux = cell2mat(data{1});
    att = num2cell(aux(1:end, 1));
    abs = aux(1:end, 2:end);
      
    pre_data_msc = preprocess('calibrate', 'msc', cell2mat(abs));
    pre_name_msc = strcat(files_names{i}, '_MSC');
    export(files_names{i}, pre_name_msc, num2cell(double(pre_data_msc)), att, dest_folder);

    pre_data_snv = preprocess('calibrate', 'snv', cell2mat(abs));
    pre_name_snv = strcat(files_names{i}, '_SNV');
    export(files_names{i}, pre_name_snv, num2cell(double(pre_data_snv)), att, dest_folder);

end
end