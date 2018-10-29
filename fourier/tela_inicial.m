function varargout = tela_inicial(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tela_inicial_OpeningFcn, ...
                   'gui_OutputFcn',  @tela_inicial_OutputFcn, ...
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

function tela_inicial_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
end

function varargout = tela_inicial_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
end

%função executada quando o primeiro botão browse é clicado
function btn_browse_orig_folder_Callback(hObject, eventdata, handles)

%obtendo o nome do arquivo (variety) e o caminho até o arquivo (path)
[variety, path] = uigetfile('*.xlsx', 'Select the excel file');

%atribuindo à variety a concatenação do caminho e nome do arquivo
variety = strcat(path, variety);

%colocando o nome do arquivo e caminho no campo de texto
set(handles.edit_origin_folder, 'string', variety);

%salvando o caminho + arquivo
setappdata(0, 'variety', variety);

[dt,txt,~] = xlsread(variety);
data = dt(2:end, 4:end);
qua_text = txt{1,3};

%m e n armazenam o número de linhas e colunas de data respectivamente.
[m,n] = size(data);

%salvo a matriz data, assim como m (que corresponde ao número de amostras)
%e n (número de comprimentos de onda)
setappdata(0, 'data', data);
setappdata(0, 'smp_size', m);
setappdata(0, 'rng_size', n);
setappdata(0, 'qua_text', qua_text);

variety_x = dt(1, 4:end);
%salvando o vetor de comprimentos de onda
setappdata(0, 'variety_x', variety_x);

%os dados originais são plotados
plot_original_data(handles.axes1);

end

%função para plotar os dados originais
function plot_original_data(hAxes1)

%recupero as variáveis salvas anteriormente
smp_size = getappdata(0, 'smp_size');
data = getappdata(0, 'data');
rng_size = getappdata(0, 'rng_size');
variety_x = getappdata(0, 'variety_x');

%para cada uma das amostras, sua curva é plotada. handles.axes1 corresponde
%ao gráfico onde as curvas serão plotadas, variety_x é o vetor de comprimentos 
%de onda e data contém as aborbâncias.
for i=1:smp_size
    plot(variety_x, data(i,:));
    %plot(hAxes1, variety_x, data(i,:));
    hold on
end
hold off

%título do gráfico
title('Raw data');

%limite das abscissas. variety_x(1) corresponde à 450 e variety_x(rng_size)
%corresponde ao comprimento de onda na última posição, que é 1800 nesse caso
%rng_size contém o número de comprimentos de onda.
xlim([variety_x(1) variety_x(rng_size)])

end

%função ativada quando o usuário clica no segundo botão browse
function btn_browse_dest_folder_Callback(hObject, eventdata, handles)

%função que abre uma janela para que o usuário escolha uma pasta onde o
%arquivo de destino será salvo
file = uigetdir();

%a pasta de destino é exibida no campo de texto edit_dest_folder
set(handles.edit_dest_folder, 'string', file);

%salvo a pasta de destino
setappdata(0, 'dest_folder', file);
end

%função executada quando o último botão OK é pressionado
function btn_ok_Callback(hObject, eventdata, handles)

%obtenho a frequência de amostragem inserida e salvo
Fs = str2double(get(handles.edit_sampling_f, 'String'));
setappdata(0, 'Fs', Fs);

%recuperando o vetor de comprimentos de onda salvo anteriormente
variety_x = getappdata(0, 'variety_x');

%obtenho o nome da variedade e qualidade interna inseridas pelo usuário
var_text = get(handles.edit_variety, 'String');

%salvo essas variáveis para que outras funções as acessem
setappdata(0, 'var_text', var_text);

%salvo em range_txt a range inserida pelo usuário, armazenada no campo de
%texto edit_range como string
range_txt = get(handles.edit_range, 'String');

%essa função retorna a matriz de números inteiros, que correspondem às
%faixas inseridas pelo usuário
range = getRange(range_txt);

%salvando a matriz de faixas 
setappdata(0, 'range', range);

%essa função retorna as posições no vetor de comprimento de onda de cada 
%faixa inserida
pos_mat = getPosMatrix(variety_x, range);

%salvo essa matriz de posições
setappdata(0, 'pos_mat', pos_mat);

%chamo a próxima tela
tela_freq;
end

%função que retorna a matriz de comprimentos de onda das faixas inseridas
function range = getRange(range_txt)

%armazeno em num a quantidade de ; (separadores) na range
num = length(strfind(range_txt, ';'));

%incremento num. Essa variável agora armazena a quantidade de faixas
%inseridas
num=num+1;

%salvando a quantidade de faixas
setappdata(0, 'num', num);

%quebro a string em substrings, utilizando como separador o ;
range_txt2 = strsplit(range_txt, ';');

%armazeno range_txt2
setappdata(0, 'range_txt', range_txt2);

range = cell(num,2);
for i=1:num
    %cada substring é quebrada em duas strings, utilizando como separador o -
    range(i,:) = strsplit(range_txt2{i},'-');
end

%as substrings são convertidas para inteiro. Cada linha da matriz range 
%corresponde a uma faixa inserida pelo usuário. Ex: [450 500]
range = str2double(range);

range_size = zeros(num,1);
%calculo a quantidade de comprimentos de onda de cada faixa inserida
for i=1:num
    range_size(i) = range(i,2) - range(i,1) + 1;
end

%salvo essa quantidade
setappdata(0, 'range_size', range_size);
end

%função que acha a matriz de posição de cada comprimento de onda das faixas
%inseridas
function pos_mat = getPosMatrix(variety_x, range)

%m e n armazenam o número de linhas e colunas da matriz de faixas
[m,~] = size(range);

%para cada elemento da matriz range, encontro as colunas correspondentes 
%no vetor de comprimentos de onda, para encontrar a posição dos valores 
%nesse vetor original. 

pos_mat = zeros(m,2);
for i=1:m
    %ex: para [450 500], col1 recebe a coluna em que 450 está no vetor
    %original variety_x e col2 recebe a coluna em que 500 está. 
    [~,col1] = find(variety_x == range(i,1));
    [~,col2] = find(variety_x == range(i,2));
    
    %armazeno em pos_mat as posições de cada valor inserido pelo usuário 
    pos_mat(i,1) = col1;
    pos_mat(i,2) = col2;
end

end

%ignorar próximas funções
function edit_origin_folder_Callback(hObject, eventdata, handles)

end

function edit_origin_folder_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_range_Callback(hObject, eventdata, handles)

end

function edit_range_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function edit_dest_folder_Callback(hObject, eventdata, handles)

end

function edit_dest_folder_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_sampling_f_Callback(hObject, eventdata, handles)

end

function edit_sampling_f_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_variety_Callback(hObject, eventdata, handles)

end

function edit_variety_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
