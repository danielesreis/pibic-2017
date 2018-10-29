function export(files_names, new_names, data, att, dest_folder)

att_text = getappdata(0, 'att_text');
rng_size = getappdata(0, 'rng_size');
smp_size = getappdata(0, 'smp_size');
variety_x = getappdata(0, 'variety_x');
files_folder = getappdata(0, 'files_folder');

raw1{1, 4} = [];
raw1{1} = 'Coleta';
raw1{2} = 'Amostra';
raw1{3} = att_text;

data = [att'; data'];
data = data';

for i=1:rng_size
    raw1{i+3} = variety_x(i);
end

A = raw1;
range = strcat('A2:C', num2str(smp_size+1));

% [m, n] = size(data);
if ischar(files_names)
    [~,~,raw2] = xlsread(strcat(files_folder, '\', files_names), range);
else
    [~,~,raw2] = xlsread(strcat(files_folder, '\', files_names{i}), range);
end

for j=2:(smp_size+1)
    A{j, 1} = raw2{j-1, 1};
    A{j, 2} = raw2{j-1, 2};
    %A{j, 3} = raw2{j-1, 3};
end

for k=2:(smp_size + 1)
    for w=3:(rng_size + 3)
        %data_export = data{1, i};
        A{k, w} = data{k-1, w-2};
    end
end

path = strcat(dest_folder, '\', new_names, '.xlsx');
xlswrite(path, A);
end