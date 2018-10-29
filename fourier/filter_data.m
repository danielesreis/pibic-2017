%função que filtra os dados
function data = filter_data(data, filter_order, cut_freq, val, pos_mat, Fs)

%recupero a quantidade de amostras
smp_size = getappdata(0, 'smp_size');

%b contém os coeficientes de um filtro cuja ordem está contida na matriz 
%filter_order, com frequência de corte especificada na matriz cut_freq. 
%O segundo parâmetro deve ser maior que 0 e menor que 1, logo a frequência 
%de corte é dividida pela frequência de nyquist. O filtro deve ser passa 
%baixas, pois a maior parte das frequências do sinal são baixas
b = fir1(filter_order(val), cut_freq(val)/(Fs/2), 'low');

%crio o vetor com novos pontos para serem inseridos no início do sinal
new_data = insert_points(filter_order(val), data(:,pos_mat(val,1):pos_mat(val,2)), smp_size);

%novo vetor que conterá os dados originais da faixa + os novos pontos do
%começo
new_data2 = zeros(smp_size, filter_order(val) + pos_mat(val,2) - pos_mat(val,1) + 1);
new_data2(:, 1:filter_order(val)) = new_data(:,:);
new_data2(:, (filter_order(val)+1):end) = data(:,pos_mat(val,1):pos_mat(val,2));

%realizo a filtragem para cada amostra
for i=1:smp_size
   %b contém os coeficientes do filtro. 1 corresponde ao
   %denominador, que só possuirá coeficiente unitários. new_data2 contém as
   %absorbâncias dos valores na faixa especificada
   Y = filter(b, 1, new_data2(i,:));
   %substituo os novos valores em data
   data(i, pos_mat(val,1):pos_mat(val,2)) = Y(1,(filter_order(val)+1):end);
end
end

%função que cria vetor com os novos pontos a serem adicionados
function new_data = insert_points(num_pts, data_pts, smp_size)
    
%aloco memória 
new_data = zeros(smp_size,num_pts);

for i=1:smp_size
    for j=1:num_pts
        %repito os num_pts primeiros items dos dados originais 
        new_data(i,j) = data_pts(i,j);
    end
end
end