%fun��o que retorna a transformada fft
function L = calculate_fft(pos_mat)

%recupero as vari�veis salvas anteriormente
smp_size = getappdata(0, 'smp_size');
data = getappdata(0, 'data');
range_size = getappdata(0, 'range_size');

%recupero as dimens�es da matriz de posi��es. Assim, tenho a quantidade de
%faixas inseridas
[m,~] = size(pos_mat);

%inicializo a cell array L
L = cell(m);

%primeira itera��o para cada faixa inserida
for i=1:m
    num_points = int16(range_size(i)/2)+1;
    P1 = zeros(smp_size, num_points);
    %segunda itera��o para cada amostra
    for j=1:smp_size
        %calculo a fft da faixa atual e armazeno em Y
        Y = fft(data(j,pos_mat(i,1):pos_mat(i,2)));
        
        %normaliza��o dos valores atrav�s da divis�o de Y pela qtd de
        %comprimentos de onda, pois a fun��o fft computa a transformada
        %para cada ponto e soma tudo
        P2 = abs(Y/range_size(i));
        
        %obtendo apenas a metade do sinal, pois fft() calcula a transformada
        %para frequ�ncias negativas
        P1(j,:) = P2(1:num_points);
        
        %multiplicando por 2 pois na single side band a amplitude � o dobro
        %da amplitude em double side band
        P1(j,2:end-1) = 2*P1(j,2:end-1);
        hold on
    end
    hold off
    
    %a matriz de transformada contida em P1 � convertida para cell array e
    %armazenada em Laux
    Laux = num2cell(P1);
    
    %a cell array Laux far� parte da matriz 3D L. Assim, cada matriz 2D de
    %amostra x comprimento de onda ser� elemento da matriz L. O terceiro
    %�ndice dessa matriz corresponde �s faixas inseridas pelo usu�rio.
    L{i} = Laux;
end

end