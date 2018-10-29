function L = denoise(pos_mat, smp_size, data, wname, variety_x, rng_size, threshold)


%obtenho o n�mero de linhas da matriz de posi�ao, que corresponder� ao
%n�mero de faixas inseridas pelo usu�rio
[m,~] = size(pos_mat);
s = m;
L = zeros(12, smp_size, rng_size);

%o threshold agora � calculado de acordo com o que o usu�rio escolheu
switch threshold
    
    case 1 %global threshold
        
        %itera��o para cada n�vel de decomposi��o
        for level=1:12
            %plotando um gr�fico de propor��es 3x4, identificado pelo level
            subplot(3, 4, level);
            xd = zeros(smp_size, rng_size);
            %itera��o para cada amostra
            for i=1:smp_size
                %xd armazena as novas absorb�ncias calculadas. Inicialmente
                %ela recebe os valores originais.
                xd(i,:) = data(i,:);
                
                %itera��o para cada faixa definida pelo usu�rio
                for k=1:s       
                    
                    %thr cont�m o threshold global. Sorh indica se o
                    %threshold � do tipo soft ('s') ou hard ('h'). Keepapp
                    %indica se os valores correspondentes � baixa frequ�ncia
                    %ser�o mantidos. Nos argumentos de ddencmp: 'den' indica que
                    %a opera��o � de denoise, 'wv' indica que �
                    %transformada wavelet e o terceiro argumento cont�m
                    %os dados de absorb�ncia da faixa definida pelo usu�rio
                    [thr,sorh,keepapp] = ddencmp('den','wv', data(i,pos_mat(k,1):pos_mat(k,2)));
                    
                    %a matriz xd ter� seus valores substitu�dos apenas nas
                    %faixas definidas pelo usu�rio. Nos par�metros de
                    %wdencmp, 'gbl' indica que o threshold � global. Os 
                    %valores originais (data) s�o indexados nas faixas 
                    %inseridas pelo usu�rio. Wname indica a wavelet e level
                    %o n�vel de decomposi��o.
                    [xd(i,pos_mat(k,1):pos_mat(k,2)),~,~,~,~] = wdencmp('gbl', data(i,pos_mat(k,1):pos_mat(k,2)), wname, level, thr, sorh, keepapp);
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
            L(level,:,:) = xd;
            
            %t�tulo do gr�fico
            title(strcat(wname, ' decomposition level', ' ', num2str(level)));
            
            %limites das abscissas
            xlim([variety_x(1) variety_x(rng_size)])
        end
 
    case 2 %hard scale adaptative
        
        for level=1:12
            subplot(3, 4, level);
            xd = zeros(smp_size, rng_size);
            for i=1:smp_size
                xd(i,:) = data(i,:);
                
                for k=1:s
                    %os dados originais s�o decompostos para que o
                    %threshold de cada n�vel seja encontrado. c � o vetor
                    %de decomposi��o do sinal e l cont�m o n�mero de
                    %coeficientes por n�vel
                    [c, l] = wavedec(data(i,pos_mat(k,1):pos_mat(k,2)), level, wname); 
    
                    %alpha = 3 para denoising. m recebe esse valor
                    %normalmente
                    alpha = 3; m = l(1);
                    
                    %thr � um vetor contendo os threshols para cada n�vel
                    %da wavelet atual. 
                    [thr,~] = wdcbm(c, l, alpha, m);
                    %o primeiro par�metro � 'lvd' pois o threshold � do
                    %tipo scale adaptative. O �ltimo par�metro indica que o
                    %threshold � do tipo hard
                    [xd(i,pos_mat(k,1):pos_mat(k,2)),~,~,~,~] = wdencmp('lvd', c, l, wname, level, thr, 'h'); 
                end
                
                plot(variety_x, xd(i,:));
                hold on;
            end
            hold off
            L(level,:,:) = xd;
            title(strcat(wname, ' decomposition level  ', ' ', num2str(level)));
            xlim([variety_x(1) variety_x(rng_size)])
        end

    case 3 %soft scale adaptative
        
        for level=1:12
                subplot(3, 4, level);
                xd = zeros(smp_size,rng_size);
                for i=1:smp_size
                    xd(i,:) = data(i,:);
                    
                    for k=1:s
                        [c, l] = wavedec(data(i,pos_mat(k,1):pos_mat(k,2)), level, wname); 
        
                        alpha = 3; m = l(1);
                        
                        [thr,~] = wdcbm(c, l, alpha, m);
                        %O �ltimo par�metro indica que o threshold � do
                        %tipo soft
                        [xd(i,pos_mat(k,1):pos_mat(k,2)),~,~,~,~] = wdencmp('lvd', c, l, wname, level, thr, 's'); 
                    end
                    
                    plot(variety_x, xd(i,:));
                    hold on;
                end
                hold off
                L(level,:,:) = xd;
                title(strcat(wname, ' decomposition level  ', ' ', num2str(level)));
                xlim([variety_x(1) variety_x(rng_size)])
        end
end

%de acordo com o n�mero contido em threshold, determina-se o nome do mesmo
switch threshold
    case 1
        threshold_type = 'gt';
    case 2
        threshold_type = 'ha';
    case 3
        threshold_type = 'sa';
end

setappdata(0, 'threshold_type', threshold_type);

end
