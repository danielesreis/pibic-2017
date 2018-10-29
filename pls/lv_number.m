function lv_num = lv_number(max_lv, num_files, smp_size, rng_size, abs_scaled, qua_scaled, pls_type, cv_type, max_iter, m_qua)

abs_scaled2 = zeros(smp_size, rng_size);
lv_num = zeros(num_files,1);
text9 = getappdata(0, 'text9');
file_names = getappdata(0, 'file_names');
time = zeros(1,num_files);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:num_files
    set(text9, 'string', file_names(1,i));
    lvs = [];
    k=1;
    abs_scaled2(:,:) = abs_scaled(i,:,:);
    %[plspress, plscumpress, rmsecv(i,:), rmsec(i,:), R_val(i,:), bias(i,:)] = ... 
    tic
    results(i) = crossval(abs_scaled2(:,:), qua_scaled(:,i), pls_type, cv_type, max_lv);

    for j=1:(max_lv-1)
        aux = results(i).rmsecv(j)/results(i).rmsecv(j+1);
        if aux > 1
            if ((aux - 1)*100 >= 2)
                lvs(k) = j+1;
                k = k+1;
            end
        end
    end
    
    [b,ssq] = pls(abs_scaled2(:,:), qua_scaled(:,i), k-1);
    for w=1:(k-2)
        if (ssq(lvs(1,w+1),2) < 1 && ssq(lvs(1,w+1),4) < 0.9)
            lv_num(i,1) = lvs(1,w);
            break;
        end
    end
    aux = toc;
    time(1,i) = aux;
    
end
setappdata(0, 'results', results);
setappdata(0, 'time', time);
end