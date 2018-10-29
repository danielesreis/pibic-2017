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

%fun��o executada quando o primeiro bot�o browse � clicado
function btn_browse_orig_folder_Callback(hObject, eventdata, handles)

%obtendo o nome do arquivo (variety) e o caminho at� o arquivo (path)
[variety, path] = uigetfile('*.xlsx', 'Select the excel file');

%atribuindo � variety a concatena��o do caminho e nome do arquivo
variety = strcat(path, variety);

%colocando o nome do arquivo e caminho no campo de texto
set(handles.edit_origin_folder, 'string', variety);

%salvando o caminho + arquivo
setappdata(0, 'variety', variety);

[dt,txt,~] = xlsread(variety);
data = dt(2:end, 4:end);
qua_text = txt{1,3};

%m e n armazenam o n�mero de linhas e colunas de data respectivamente.
[m,n] = size(data);

%salvo a matriz data, assim como m (que corresponde ao n�mero de amostras)
%e n (n�mero de comprimentos de onda)
setappdata(0, 'data', data);
setappdata(0, 'smp_size', m);
setappdata(0, 'rng_size', n);
setappdata(0, 'qua_text', qua_text);

variety_x = dt(1, 4:end);
%salvando o vetor de comprimentos de onda
setappdata(0, 'variety_x', variety_x);

%os dados originais s�o plotados
plot_original_data(handles.axes1);

end

%fun��o para plotar os dados originais
function plot_original_data(hAxes1)

%recupero as vari�veis salvas anteriormente
smp_size = getappdata(0, 'smp_size');
data = getappdata(0, 'data');
rng_size = getappdata(0, 'rng_size');
variety_x = getappdata(0, 'variety_x');

%para cada uma das amostras, sua curva � plotada. handles.axes1 corresponde
%ao gr�fico onde as curvas ser�o plotadas, variety_x � o vetor de comprimentos 
%de onda e data cont�m as aborb�ncias.
for i=1:smp_size
    plot(variety_x, data(i,:));
    %plot(hAxes1, variety_x, data(i,:));
    hold on
end
hold off

%t�tulo do gr�fico
title('Raw data');

%limite das abscissas. variety_x(1) corresponde � 450 e variety_x(rng_size)
%corresponde ao comprimento de onda na �ltima posi��o, que � 1800 nesse caso
%rng_size cont�m o n�mero de comprimentos de onda.
xlim([variety_x(1) variety_x(rng_size)])

end

%fun��o ativada quando o usu�rio clica no segundo bot�o browse
function btn_browse_dest_folder_Callback(hObject, eventdata, handles)

%fun��o que abre uma janela para que o usu�rio escolha uma pasta onde o
%arquivo de destino ser� salvo
file = uigetdir();

%a pasta de destino � exibida no campo de texto edit_dest_folder
set(handles.edit_dest_folder, 'string', file);

%salvo a pasta de destino
setappdata(0, 'dest_folder', file);
end

%fun��o executada quando o �ltimo bot�o OK � pressionado
function btn_ok_Callback(hObject, eventdata, handles)

%obtenho a frequ�ncia de amostragem inserida e salvo
Fs = str2double(get(handles.edit_sampling_f, 'String'));
setappdata(0, 'Fs', Fs);

%recuperando o vetor de comprimentos de onda salvo anteriormente
variety_x = getappdata(0, 'variety_x');

%obtenho o nome da variedade e qualidade interna inseridas pelo usu�rio
var_text = get(handles.edit_variety, 'String');

%salvo essas vari�veis para que outras fun��es as acessem
setappdata(0, 'var_text', var_text);

%salvo em range_txt a range inserida pelo usu�rio, armazenada no campo de
%texto edit_range como string
range_txt = get(handles.edit_range, 'String');

%essa fun��o retorna a matriz de n�meros inteiros, que correspondem �s
%faixas inseridas pelo usu�rio
range = getRange(range_txt);

%salvando a matriz de faixas 
setappdata(0, 'range', range);

%essa fun��o retorna as posi��es no vetor de comprimento de onda de cada 
%faixa inserida
pos_mat = getPosMatrix(variety_x, range);

%salvo essa matriz de posi��es
setappdata(0, 'pos_mat', pos_mat);

%chamo a pr�xima tela
tela_freq;
end

%fun��o que retorna a matriz de comprimentos de onda das faixas inseridas
function range = getRange(range_txt)

%armazeno em num a quantidade de ; (separadores) na range
num = length(strfind(range_txt, ';'));

%incremento num. Essa vari�vel agora armazena a quantidade de faixas
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
    %cada substring � quebrada em duas strings, utilizando como separador o -
    range(i,:) = strsplit(range_txt2{i},'-');
end

%as substrings s�o convertidas para inteiro. Cada linha da matriz range 
%corresponde a uma faixa inserida pelo usu�rio. Ex: [450 500]
range = str2double(range);

range_size = zeros(num,1);
%calculo a quantidade de comprimentos de onda de cada faixa inserida
for i=1:num
    range_size(i) = range(i,2) - range(i,1) + 1;
end

%salvo essa quantidade
setappdata(0, 'range_size', range_size);
end

%fun��o que acha a matriz de posi��o de cada comprimento de onda das faixas
%inseridas
function pos_mat = getPosMatrix(variety_x, range)

%m e n armazenam o n�mero de linhas e colunas da matriz de faixas
[m,~] = size(range);

%para cada elemento da matriz range, encontro as colunas correspondentes 
%no vetor de comprimentos de onda, para encontrar a posi��o dos valores 
%nesse vetor original. 

pos_mat = zeros(m,2);
for i=1:m
    %ex: para [450 500], col1 recebe a coluna em que 450 est� no vetor
    %original variety_x e col2 recebe a coluna em que 500 est�. 
    [~,col1] = find(variety_x == range(i,1));
    [~,col2] = find(variety_x == range(i,2));
    
    %armazeno em pos_mat as posi��es de cada valor inserido pelo usu�rio 
    pos_mat(i,1) = col1;
    pos_mat(i,2) = col2;
end

end

%ignorar pr�ximas fun��es
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
