function [data_deriv, new_names] = derivative(data, names)

[~,n] = size(data);

check_smoothing = getappdata(0, 'check_smoothing');
check_1sgolay = getappdata(0, 'check_1sgolay');
check_2sgolay = getappdata(0, 'check_2sgolay');

if (eq(check_1sgolay, 1) && eq(check_2sgolay, 1))
    
    porder1 = getappdata(0, 'edit_porder1');
    porder1 = strsplit(porder1, ',');
    porder1 = str2double(porder1);
    num_porder1 = numel(porder1);

    porder2 = getappdata(0, 'edit_porder2');
    porder2 = strsplit(porder2, ',');
    porder2 = str2double(porder2);
    num_porder2 = numel(porder2);

    wsize1sgolay = getappdata(0, 'edit_wsize1sgolay');
    wsize1sgolay = strsplit(wsize1sgolay, ',');
    wsize1sgolay = str2double(wsize1sgolay);
    num_wsize1 = numel(wsize1sgolay);

    wsize2sgolay = getappdata(0, 'edit_wsize2sgolay');
    wsize2sgolay = strsplit(wsize2sgolay, ',');
    wsize2sgolay = str2double(wsize2sgolay);
    num_wsize2 = numel(wsize2sgolay);

    data_deriv = cell(1, n*(num_porder1*num_wsize1 + num_porder2*num_wsize2));
    
    if (ischar(names))
    else
    end
    new_names = cell(1, n*(num_porder1*num_wsize1 + num_porder2*num_wsize2));

    aux1=1;
    for i=1:n

        abs = cell2mat(data{1, i});
        if (eq(check_smoothing, 0))
            abs = abs(1:end, 2:end);
        else
            abs = abs(1:end, 1:end);
        end

        for j=1:num_porder1
            for k=1:num_wsize1
                data_deriv{1, aux1} = savgol(abs, wsize1sgolay(1, k), porder1(1, j), 1);
                
                if (ischar(names))
                    new_names{1, aux1} = strcat(names, '_SG1st', num2str(porder1(1, j)), ...
                    'x', num2str(wsize1sgolay(1, k)), 'pts');
                else
                    new_names{1, aux1} = strcat(names{i}, '_SG1st', num2str(porder1(1, j)), ...
                    'x', num2str(wsize1sgolay(1, k)), 'pts');
                end
                aux1=aux1+1;
            end
        end

        for j=1:num_porder2
            for k=1:num_wsize2
                data_deriv{1, aux1} = savgol(abs, wsize2sgolay(1, k), porder2(1, j), 1);
                
                if (ischar(names))
                    new_names{1, aux1} = strcat(names, '_SG2nd', num2str(porder2(1, j)), ...
                    'x', num2str(wsize2sgolay(1, k)), 'pts');
                else
                    new_names{1, aux1} = strcat(names{i}, '_SG2nd', num2str(porder2(1, j)), ...
                    'x', num2str(wsize2sgolay(1, k)), 'pts');
                end
                aux1 = aux1 + 1;
            end
        end
    end

elseif (eq(check_1sgolay, 1) && eq(check_2sgolay, 0))
    
    porder1 = getappdata(0, 'edit_porder1');
    porder1 = strsplit(porder1, ',');
    porder1 = str2double(porder1);
    num_porder1 = numel(porder1);

    wsize1sgolay = getappdata(0, 'edit_wsize1sgolay');
    wsize1sgolay = strsplit(wsize1sgolay, ',');
    wsize1sgolay = str2double(wsize1sgolay);
    num_wsize1 = numel(wsize1sgolay);

    data_deriv = cell(1, n*num_porder1*num_wsize1);
    
    if (ischar(names))
    else
    end
    new_names = cell(1, n*num_porder1*num_wsize1);

    aux1=1;
    for i=1:n

        abs = cell2mat(data{1, i});
        if (eq(check_smoothing, 0))
            abs = abs(1:end, 2:end);
        else
            abs = abs(1:end, 1:end);
        end

        for j=1:num_porder1
            for k=1:num_wsize1
                data_deriv{1, aux1} = savgol(abs, wsize1sgolay(1, k), porder1(1, j), 1);
                
                if (ischar(names))
                    new_names{1, aux1} = strcat(names, '_SG1st', num2str(porder1(1,j)), ...
                    'x', num2str(wsize1sgolay(1,k)), 'pts');
                else
                    new_names{1, aux1} = strcat(names{i}, '_SG1st', num2str(porder1(1,j)), ...
                    'x', num2str(wsize1sgolay(1,k)), 'pts');
                end
                aux1=aux1+1;
            end
        end
    end
else

    porder2 = getappdata(0, 'edit_porder2');
    porder2 = strsplit(porder2, ',');
    porder2 = str2double(porder2);
    num_porder2 = numel(porder2);

    wsize2sgolay = getappdata(0, 'edit_wsize2sgolay');
    wsize2sgolay = strsplit(wsize2sgolay, ',');
    wsize2sgolay = str2double(wsize2sgolay);
    num_wsize2 = numel(wsize2sgolay);

    data_deriv = cell(1, n*num_porder2*num_wsize2);
    
    if (ischar(names))
    else
    end
    new_names = cell(1, n*num_porder2*num_wsize2);

    aux1=1;
    for i=1:n

        abs = cell2mat(data{1, i});
        if (eq(check_smoothing, 0))
            abs = abs(1:end, 2:end);
        else
            abs = abs(1:end, 1:end);
        end

        for j=1:num_porder2
            for k=1:num_wsize2
                data_deriv{1, aux1} = savgol(abs, wsize2sgolay(1, k), porder2(1, j), 1);
                
                if (ischar(names))
                    new_names{1, aux1} = strcat(names, '_SG2nd', num2str(porder2(1, j)), ...
                    'x', num2str(wsize2sgolay(1, k)), 'pts');
                else
                    new_names{1, aux1} = strcat(names{i}, '_SG2nd', num2str(porder2(1, j)), ...
                    'x', num2str(wsize2sgolay(1, k)), 'pts');
                end
                aux1 = aux1 + 1;
            end
        end
    end
end
end