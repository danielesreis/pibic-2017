function pretreat_routine()

check_smoothing = getappdata(0, 'check_smoothing');
check_derivative = getappdata(0, 'check_derivative');
check_scattercor = getappdata(0, 'check_scattercor');
dest_folder = getappdata(0, 'dest_folder');
files_folder = getappdata(0, 'files_folder');

[num_files, files_names, files_paths] = files_routine(files_folder);
tic
if (eq(check_smoothing, 1) && (eq(check_derivative, 1)) && (eq(check_scattercor, 1)))
    for i=1:num_files

        read = xlsread(files_paths{i, 1});
        variety_x = read(1, 4:end);
        setappdata(0, 'variety_x', variety_x);
        data = read(2:end, 3:end);

        [m, n] = size(data);
        setappdata(0, 'smp_size', m);
        setappdata(0, 'rng_size', n-1);

        c = cell(1,1);
        c{1,1} = num2cell(data);
        data = c;
        att = cell2mat(data{1});
        att = att(1:end, 1);

        [data, new_names] = smooth(data, files_names{i});
        [data, new_names] = derivative(data, new_names);
        export(files_names{i}, new_names, data, dest_folder);

        [data, new_names] = scattercor(data, new_names, att);
        export(files_names{i}, new_names, data, dest_folder);
    end

elseif (eq(check_smoothing, 1) && (eq(check_derivative, 1)) && (eq(check_scattercor, 0)))
    for i=1:num_files

        read = xlsread(files_paths{i, 1});
        variety_x = read(1, 4:end);
        setappdata(0, 'variety_x', variety_x);
        data = read(2:end, 3:end);

        [m, n] = size(data);
        setappdata(0, 'smp_size', m);
        setappdata(0, 'rng_size', n-1);

        c = cell(1,1);
        c{1,1} = num2cell(data);
        data = c;
        att = cell2mat(data{1});
        att = att(1:end, 1);

        [data, new_names] = smooth(data, files_names{i});
        [data, new_names] = derivative(data, new_names);
        export(files_names{i}, new_names, data, dest_folder);
    end

elseif (eq(check_smoothing, 1) && (eq(check_derivative, 0)) && (eq(check_scattercor, 1)))
    for i=1:num_files

        read = xlsread(files_paths{i, 1});
        variety_x = read(1, 4:end);
        setappdata(0, 'variety_x', variety_x);
        data = read(2:end, 3:end);

        [m, n] = size(data);
        setappdata(0, 'smp_size', m);
        setappdata(0, 'rng_size', n-1);

        c = cell(1,1);
        c{1,1} = num2cell(data);
        data = c;
        att = cell2mat(data{1});
        att = att(1:end, 1);

        [data, new_names] = smooth(data, files_names{i});
        [data, new_names] = scattercor(data, new_names, att);
        export(files_names{i}, new_names, data, dest_folder);
    end

elseif (eq(check_smoothing, 1) && (eq(check_derivative, 0)) && (eq(check_scattercor, 0)))
    for i=1:num_files

        read = xlsread(files_paths{i, 1});
        variety_x = read(1, 4:end);
        setappdata(0, 'variety_x', variety_x);
        data = read(2:end, 3:end);

        [m, n] = size(data);
        setappdata(0, 'smp_size', m);
        setappdata(0, 'rng_size', n-1);

        c = cell(1,1);
        c{1,1} = num2cell(data);
        data = c;
        att = cell2mat(data{1});
        att = att(1:end, 1);

        [data, new_names] = smooth(data, files_names{i});
        export(files_names{i}, new_names, data, dest_folder);
    end

elseif (eq(check_smoothing, 0) && (eq(check_derivative, 1)) && (eq(check_scattercor, 1)))
    for i=1:num_files

        read = xlsread(files_paths{i, 1});
        variety_x = read(1, 4:end);
        setappdata(0, 'variety_x', variety_x);
        data = read(2:end, 3:end);

        [m, n] = size(data);
        setappdata(0, 'smp_size', m);
        setappdata(0, 'rng_size', n-1);

        c = cell(1,1);
        c{1,1} = num2cell(data);
        data = c;
        att = cell2mat(data{1});
        att = att(1:end, 1);

        [data, new_names] = derivative(data, files_names{i});
        [data, new_names] = scattercor(data, new_names, att);
        export(files_names{i}, new_names, data, dest_folder);
    end

elseif (eq(check_smoothing, 0) && (eq(check_derivative, 1)) && (eq(check_scattercor, 0)))
    for i=1:num_files

        read = xlsread(files_paths{i, 1});
        variety_x = read(1, 4:end);
        setappdata(0, 'variety_x', variety_x);
        data = read(2:end, 3:end);

        [m, n] = size(data);
        setappdata(0, 'smp_size', m);
        setappdata(0, 'rng_size', n-1);

        c = cell(1,1);
        c{1,1} = num2cell(data);
        data = c;
        att = cell2mat(data{1});
        att = att(1:end, 1);

        [data, new_names] = derivative(data, files_names{i});
        export(files_names{i}, new_names, data, dest_folder);
    end

else
    for i=1:num_files

        read = xlsread(files_paths{i, 1});
        variety_x = read(1, 4:end);
        setappdata(0, 'variety_x', variety_x);
        data = read(2:end, 3:end);

        [m, n] = size(data);
        setappdata(0, 'smp_size', m);
        setappdata(0, 'rng_size', n-1);

        c = cell(1,1);
        c{1,1} = num2cell(data);
        data = c;
        att = cell2mat(data{1});
        att = att(1:end, 1);

        [data, new_names] = scattercor(data, files_names{i}, att);
        export(files_names{i}, new_names, data, dest_folder);
    end
end
aux = toc;
figure
title(aux);
end
