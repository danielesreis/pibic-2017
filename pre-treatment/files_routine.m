function [m, names, files_paths] = files_routine(files_folder)

%salvo em files os arquivos excel da pasta selecionada
files = dir(fullfile(files_folder, '*.xlsx'));

[m,n] = size(files);
files = struct2cell(files);
names = files(1, :);

%converto para o formato cell array
names = cellstr(names);

%removo o sufixo .xlsx
for i=1:m
    C = strsplit(names{i}, '.');
    names{i} = C{1};
end

files_paths = cell(m, 1);
%concateno os nomes com o caminho
for i=1:m
   files_paths(i, 1) = strcat(files_folder, '\', names(i));
end
end