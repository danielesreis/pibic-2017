function L = compress(pos_mat, smp_size, data, wname, variety_x, rng_size)

%recupero o threshold inserido
glb_threshold = getappdata(0, 'glb_threshold');

%obtenho o número de linhas da matriz de posiçao, que corresponderá ao
%número de faixas inseridas pelo usuário
[m,n] = size(pos_mat);
s = m;

%iteração para cada nível de decomposição
for level=1:12

    %plotando um gráfico de proporções 3x4, identificado pelo level
    subplot(3, 4, level);

    %iteração para cada amostra
    for i=1:smp_size
        %xd armazena as novas absorbâncias calculadas. Inicialmente
        %ela recebe os valores originais.
        xd(i,:) = data(i,:);

        %iteração para cada faixa definida pelo usuário
        for k=1:s       

            %os dados originais são decompostos. c é o vetor
            %de decomposição do sinal e l contém o número de
            %coeficientes por nível. Wname indica a wavelet e level
            %o nível de decomposição.
            [c, l] = wavedec(data(i,pos_mat(k,1):pos_mat(k,2)), level, wname);

            %a matriz xd terá seus valores substituídos apenas nas
            %faixas definidas pelo usuário. Nos parâmetros de
            %wdencmp, 'gbl' indica que o threshold é global. Os 
            %valores originais (data) são indexados nas faixas 
            %inseridas pelo usuário. 
            [xd(i,pos_mat(k,1):pos_mat(k,2)), cxd, lxd, perf0, perfl2] = wdencmp('gbl', c, l, wname, level, glb_threshold, 'h', 1);

        end

        %os 12 gráficos são plotados. Variety_x contém os
        %comprimentos de onda e xd as novas absorbâncias.
        plot(variety_x, xd(i,:));
        hold on;

    end
    hold off

    %a matriz 3D L é atualizada com as absorbâncias calculadas para
    %cada comprimento de onda de cada amostra em cada nível de
    %decomposição.
    L(:,:,level) = xd;

    %título do gráfico
    title(strcat(wname, ' decomposition level', ' ', num2str(level)));

    %limites das abscissas
    xlim([variety_x(1) variety_x(rng_size)])
end 
end
