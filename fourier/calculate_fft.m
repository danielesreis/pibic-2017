%função que retorna a transformada fft
function L = calculate_fft(pos_mat)

%recupero as variáveis salvas anteriormente
smp_size = getappdata(0, 'smp_size');
data = getappdata(0, 'data');
range_size = getappdata(0, 'range_size');

%recupero as dimensões da matriz de posições. Assim, tenho a quantidade de
%faixas inseridas
[m,~] = size(pos_mat);

%inicializo a cell array L
L = cell(m);

%primeira iteração para cada faixa inserida
for i=1:m
    num_points = int16(range_size(i)/2)+1;
    P1 = zeros(smp_size, num_points);
    %segunda iteração para cada amostra
    for j=1:smp_size
        %calculo a fft da faixa atual e armazeno em Y
        Y = fft(data(j,pos_mat(i,1):pos_mat(i,2)));
        
        %normalização dos valores através da divisão de Y pela qtd de
        %comprimentos de onda, pois a função fft computa a transformada
        %para cada ponto e soma tudo
        P2 = abs(Y/range_size(i));
        
        %obtendo apenas a metade do sinal, pois fft() calcula a transformada
        %para frequências negativas
        P1(j,:) = P2(1:num_points);
        
        %multiplicando por 2 pois na single side band a amplitude é o dobro
        %da amplitude em double side band
        P1(j,2:end-1) = 2*P1(j,2:end-1);
        hold on
    end
    hold off
    
    %a matriz de transformada contida em P1 é convertida para cell array e
    %armazenada em Laux
    Laux = num2cell(P1);
    
    %a cell array Laux fará parte da matriz 3D L. Assim, cada matriz 2D de
    %amostra x comprimento de onda será elemento da matriz L. O terceiro
    %índice dessa matriz corresponde às faixas inseridas pelo usuário.
    L{i} = Laux;
end

end