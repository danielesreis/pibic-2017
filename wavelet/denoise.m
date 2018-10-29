function L = denoise(pos_mat, smp_size, data, wname, variety_x, rng_size, threshold)


%obtenho o número de linhas da matriz de posiçao, que corresponderá ao
%número de faixas inseridas pelo usuário
[m,~] = size(pos_mat);
s = m;
L = zeros(12, smp_size, rng_size);

%o threshold agora é calculado de acordo com o que o usuário escolheu
switch threshold
    
    case 1 %global threshold
        
        %iteração para cada nível de decomposição
        for level=1:12
            %plotando um gráfico de proporções 3x4, identificado pelo level
            subplot(3, 4, level);
            xd = zeros(smp_size, rng_size);
            %iteração para cada amostra
            for i=1:smp_size
                %xd armazena as novas absorbâncias calculadas. Inicialmente
                %ela recebe os valores originais.
                xd(i,:) = data(i,:);
                
                %iteração para cada faixa definida pelo usuário
                for k=1:s       
                    
                    %thr contém o threshold global. Sorh indica se o
                    %threshold é do tipo soft ('s') ou hard ('h'). Keepapp
                    %indica se os valores correspondentes à baixa frequência
                    %serão mantidos. Nos argumentos de ddencmp: 'den' indica que
                    %a operação é de denoise, 'wv' indica que é
                    %transformada wavelet e o terceiro argumento contém
                    %os dados de absorbância da faixa definida pelo usuário
                    [thr,sorh,keepapp] = ddencmp('den','wv', data(i,pos_mat(k,1):pos_mat(k,2)));
                    
                    %a matriz xd terá seus valores substituídos apenas nas
                    %faixas definidas pelo usuário. Nos parâmetros de
                    %wdencmp, 'gbl' indica que o threshold é global. Os 
                    %valores originais (data) são indexados nas faixas 
                    %inseridas pelo usuário. Wname indica a wavelet e level
                    %o nível de decomposição.
                    [xd(i,pos_mat(k,1):pos_mat(k,2)),~,~,~,~] = wdencmp('gbl', data(i,pos_mat(k,1):pos_mat(k,2)), wname, level, thr, sorh, keepapp);
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
            L(level,:,:) = xd;
            
            %título do gráfico
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
                    %os dados originais são decompostos para que o
                    %threshold de cada nível seja encontrado. c é o vetor
                    %de decomposição do sinal e l contém o número de
                    %coeficientes por nível
                    [c, l] = wavedec(data(i,pos_mat(k,1):pos_mat(k,2)), level, wname); 
    
                    %alpha = 3 para denoising. m recebe esse valor
                    %normalmente
                    alpha = 3; m = l(1);
                    
                    %thr é um vetor contendo os threshols para cada nível
                    %da wavelet atual. 
                    [thr,~] = wdcbm(c, l, alpha, m);
                    %o primeiro parâmetro é 'lvd' pois o threshold é do
                    %tipo scale adaptative. O último parâmetro indica que o
                    %threshold é do tipo hard
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
                        %O último parâmetro indica que o threshold é do
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

%de acordo com o número contido em threshold, determina-se o nome do mesmo
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
