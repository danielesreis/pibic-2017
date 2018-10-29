function [results, lv_num, model] = train_model(index, abs_scaled, qua_scaled)

text9 = getappdata(0, 'text9');
file_names = getappdata(0, 'file_names');
pls_type = getappdata(0, 'pls_type');
cv_type = getappdata(0, 'cv_type');
max_lv = getappdata(0, 'max_lv');
qua_text = getappdata(0, 'qua_text');

set(text9, 'string', strcat(qua_text, '_', file_names(1, index)));
lvs = [];
k=1;

options = crossval('options');
options.display = 'off';
options.plots = 'off';

results = crossval(abs_scaled, qua_scaled, pls_type, cv_type, max_lv, options);

for j=1:(max_lv-1)
    aux = results.rmsecv(j)/results.rmsecv(j+1);
    if aux > 1
        if ((aux - 1)*100 >= 2)
            lvs(k) = j+1;
            k = k+1;
        end
    end
end

if (k==1)
    k=k+1;
    lvs(k-1) = 1;
end
lv_num = lvs(k-1);
[~,ssq] = pls(abs_scaled, qua_scaled, lvs(k-1));

for w=1:(k-2)
    if (ssq(lvs(w+1),4) < 1)
        lv_num = lvs(w);
        break;
    end
end

options = pls('options');
options.display = 'off';
options.plots = 'none';
model = pls(abs_scaled, qua_scaled, lv_num, options);
end