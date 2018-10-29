function [abs, qua, mx, my] = center_data(num_files, abs_data, qua_data, smp_size, rng_size)

if (ndims(abs_data)>2)
    mx = zeros(num_files, 1, rng_size);
    my = zeros(num_files, 1, 1);

    abs = zeros(num_files, smp_size, rng_size);
    qua = zeros(smp_size, num_files);

    for i=1:num_files
    %abs_data e qua_data agora são matrizes com colunas centralizadas na média e
    %mx/my são as médias utilizadas no scaling
        abs_data2(:,:) = abs_data(i,:,:);
        qua_data2(:,:) = qua_data(i,:,:);
        [abs(i,:,:),mx(i,:,:)] = mncn2(abs_data2);
        [qua(:,i),my(i,:,:)] = mncn2(qua_data2);
    end
    
else
    mx = zeros(1, rng_size);
    my = zeros(1, 1);

    abs = zeros(smp_size, rng_size);
    qua = zeros(smp_size, 1);

    [abs(:,:),mx(1,:)] = mncn(abs_data);
    [qua(:,1),my(1,1)] = mncn(qua_data);
    
end
end