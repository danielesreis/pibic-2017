function varargout = tela_freq(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tela_freq_OpeningFcn, ...
                   'gui_OutputFcn',  @tela_freq_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
end

%função chamada quando a tela abre
function tela_freq_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

%recupero variáveis salvas anteriormente
pos_mat = getappdata(0, 'pos_mat');
range_txt = getappdata(0, 'range_txt');

%converto as strings de faixas para o formato cell array
rng2 = cellstr(range_txt);

%populo o menu pop up com as faixas armazenadas em rng2
set(handles.popuprange, 'String', rng2);

%a transformada fft é calculada para cada faixa.
L = calculate_fft(pos_mat);

%O resultado é salvo numa matriz 3D (amostra x comprimento de onda x faixa)
setappdata(0, 'L', L);

%recupero o inteiro correspondente à faixa exibida no menu
val = get(handles.popuprange, 'value');

%ploto a transformada para a faixa escolhida
plot_freq_data(handles.axes2, val);
end

function varargout = tela_freq_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
end

%função que plota a transformada
function plot_freq_data(hAxes2, val)

%recupero as variáveis salvas anteriormente
range_size = getappdata(0, 'range_size');
smp_size = getappdata(0, 'smp_size');
L = getappdata(0, 'L');
Fs = getappdata(0, 'Fs');

%recupero a matriz 2D correspondente à faixa selecionada
Laux = L{val};

%converto de cell array para matriz para que possa ser plotado o gráfico
aux = cell2mat(Laux);

%definindo o domínio da frequência. A freq máxima é chamada de frequência
%de nyquist e é dada pela metade da frequência de amostragem.
f = Fs*(0:range_size(val)/2+1)/range_size(val);

%para cada amostra, imprimo a transformada no gráfico
for i=1:smp_size
    plot(hAxes2, f, aux(i,:));
    hold(hAxes2, 'on');
end
hold(hAxes2, 'off');

%título do gráfico
title(hAxes2, 'Fourier transformed data');

%limite das abscissas. 
xlim(hAxes2, [0 Fs/2])
end

%função chamada quando seleciona-se uma das opções do menu de faixas
function popuprange_Callback(hObject, eventdata, handles)

%recupero o inteiro correspondente à opção do menu
val = get(handles.popuprange, 'value');

%salvo esse valor
setappdata(0, 'val', val);

%ploto a transformada para a faixa selecionada
plot_freq_data(handles.axes2, val);
end

%função chamada quando o botão preview é pressionado
function btn_preview_Callback(hObject, eventdata, handles)

%recupero as strings nos campos de texto de filter orders e cut off
%frequencies
filter_order = get(handles.edit_filter_order, 'string');
cut_freq = get(handles.edit_cut_freq, 'string');
      
%quebro a string usando como separador o ;
cut2 = strsplit(cut_freq, ';');

%converto para inteiro
cut_freq = str2double(cut2);

%salvo essa matriz
setappdata(0, 'cut_freq', cut_freq);

%quebro a string usando como separador o ;
fil2 = strsplit(filter_order, ';');

%converto para inteiro
filter_order = str2double(fil2);

%salvo essa matriz
setappdata(0, 'filter_order', filter_order);
    
%recupero variáveis salvas anteriormente
data = getappdata(0, 'data');
pos_mat = getappdata(0, 'pos_mat');
Fs = getappdata(0, 'Fs');
num = getappdata(0, 'num');

%variável auxiliar
data2 = data;

%realizo a filtragem de cada faixa
for i=1:num
    data2 = filter_data(data2, filter_order, cut_freq, i, pos_mat, Fs);
end

%salvo a matriz com os dados já filtrados
setappdata(0, 'data_export', data2);

%ploto a matriz no outro gráfico
plot_filtered_data(handles.axes1, data2);
end

%função que plota o sinal já filtrado 
function plot_filtered_data(hAxes1, data)

%recupero variáveis salvas anteriormente
smp_size = getappdata(0, 'smp_size');
variety_x = getappdata(0, 'variety_x');
rng_size = getappdata(0, 'rng_size');

%para cada amostra imprimo suas absorbâncias filtradas
for i=1:smp_size
    plot(hAxes1, variety_x, data(i, :));              
    hold(hAxes1, 'on');
end
hold(hAxes1, 'off');

%título do gráfico
title(hAxes1, 'Filtered data');

%limites do eixo x
xlim(hAxes1, [variety_x(1) variety_x(rng_size)])

end

%função chamada quando o botão export é pressionado
function btn_export_Callback(hObject, eventdata, handles)

%recupero as variáveis salvas anteriormente
data_export = getappdata(0, 'data_export');
dest_folder = getappdata(0, 'dest_folder');
rng_size = getappdata(0, 'rng_size');
var_text = getappdata(0, 'var_text');
qua_text = getappdata(0, 'qua_text');
variety_x = getappdata(0, 'variety_x');
smp_size = getappdata(0, 'smp_size');
variety = getappdata(0, 'variety');
pos_mat = getappdata(0, 'pos_mat');
filter_order = getappdata(0, 'filter_order');
cut_freq = getappdata(0, 'cut_freq');

%raw1 conterá a primeira linha do arquivo excel original
raw1{1, 4} = [];
raw1{1} = 'Coleta';
raw1{2} = 'Amostra';
raw1{3} = qua_text;

%adiciono à raw1 o cabeçalho de comprimentos de onda
for i=1:rng_size
   raw1{i+3} = variety_x(i); 
end

%A conterá todas as informações que serão copiados para o arquivo de
%destino do excel. Aqui ele está recebendo a primeira linha apenas. 
A = raw1;

%para copiar os valores de amostra, coleta e do atributo, devo determinar
%as células do excel, que estarão de acordo com a quantidade de amostras.
%Nesse caso, range será igual a A2:C289
range = strcat('A2:C', num2str(smp_size+1));

%lendo do arquivo excel as células
[~,~,raw2] = xlsread(variety, range);

%obtenho o número de linhas da matriz de posiçao, que corresponderá ao
%número de faixas inseridas pelo usuário
[m,~] = size(pos_mat);

%converto os primeiros valores nas matrizes em string
fil = num2str(filter_order(1));
cut = num2str(cut_freq(1));

%concateno os demais valores das strings, utilizando o _ como separador
for i=2:m
    fil = strcat(fil, '_', num2str(filter_order(i)));
    cut = strcat(cut, '_', num2str(cut_freq(i)));
end

smp_size = smp_size+1;
%A recebe os valores de coleta, amostra e do atributo para cada amostra
for i=2:smp_size
    %A só possui valores na segunda linha, por isso smp_size foi
    %incrementado, enquanto que raw2 já possui elemento na primeira linha
    A{i, 1} = raw2{i-1, 1};
    A{i, 2} = raw2{i-1, 2};
    A{i, 3} = raw2{i-1, 3};
end

%pulo as três primeiras colunas do arquivo excel (amostra, coleta,
%qualidade)
rng_size = rng_size + 3;

%iteração para cada amostra
for j=2:smp_size
    %iteração para cada comprimento de onda
   	for k=4:rng_size
        %escrevendo para A as absorbâncias calculadas para cada
        %comprimento de onda de cada amostra
        A{j, k} = data_export(j-1, k-3);
    end
end

%para salvar o novo arquivo, deve-se adicionar ao caminho o nome dele. 
path = strcat(dest_folder, '\', var_text, '_o_', fil, '_f_', cut,'.xlsx');
%copia para o caminho já definido (path) a matriz A com o nome
%especificado (ordens dos filtros e frequências de corte)
xlswrite(path, A);
end

function popuprange_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit_filter_order_Callback(hObject, eventdata, handles)

end

function edit_filter_order_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_cut_freq_Callback(hObject, eventdata, handles)

end

function edit_cut_freq_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
