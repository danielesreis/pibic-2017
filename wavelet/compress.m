function L = compress(pos_mat, smp_size, data, wname, variety_x, rng_size)

%recupero o threshold inserido
glb_threshold = getappdata(0, 'glb_threshold');

%obtenho o n�mero de linhas da matriz de posi�ao, que corresponder� ao
%n�mero de faixas inseridas pelo usu�rio
[m,n] = size(pos_mat);
s = m;

%itera��o para cada n�vel de decomposi��o
for level=1:12

    %plotando um gr�fico de propor��es 3x4, identificado pelo level
    subplot(3, 4, level);

    %itera��o para cada amostra
    for i=1:smp_size
        %xd armazena as novas absorb�ncias calculadas. Inicialmente
        %ela recebe os valores originais.
        xd(i,:) = data(i,:);

        %itera��o para cada faixa definida pelo usu�rio
        for k=1:s       

            %os dados originais s�o decompostos. c � o vetor
            %de decomposi��o do sinal e l cont�m o n�mero de
            %coeficientes por n�vel. Wname indica a wavelet e level
            %o n�vel de decomposi��o.
            [c, l] = wavedec(data(i,pos_mat(k,1):pos_mat(k,2)), level, wname);

            %a matriz xd ter� seus valores substitu�dos apenas nas
            %faixas definidas pelo usu�rio. Nos par�metros de
            %wdencmp, 'gbl' indica que o threshold � global. Os 
            %valores originais (data) s�o indexados nas faixas 
            %inseridas pelo usu�rio. 
            [xd(i,pos_mat(k,1):pos_mat(k,2)), cxd, lxd, perf0, perfl2] = wdencmp('gbl', c, l, wname, level, glb_threshold, 'h', 1);

        end

        %os 12 gr�ficos s�o plotados. Variety_x cont�m os
        %comprimentos de onda e xd as novas absorb�ncias.
        plot(variety_x, xd(i,:));
        hold on;

    end
    hold off

    %a matriz 3D L � atualizada com as absorb�ncias calculadas para
    %cada comprimento de onda de cada amostra em cada n�vel de
    %decomposi��o.
    L(:,:,level) = xd;

    %t�tulo do gr�fico
    title(strcat(wname, ' decomposition level', ' ', num2str(level)));

    %limites das abscissas
    xlim([variety_x(1) variety_x(rng_size)])
end 
end
