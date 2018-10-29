function varargout = tela_inicial2(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tela_inicial2_OpeningFcn, ...
                   'gui_OutputFcn',  @tela_inicial2_OutputFcn, ...
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

function tela_inicial2_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
end

function varargout = tela_inicial2_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
end

%fun��o executada quando o primeiro bot�o browse � clicado
function btnbrowse1_Callback(hObject, eventdata, handles)

%obtendo o nome do arquivo (variety) e o caminho at� o arquivo (path)
[variety, path] = uigetfile('*.xlsx', 'Select the excel file');

%atribuindo � variety a concatena��o do caminho e nome do arquivo
variety = strcat(path, variety);

%colocando o nome do arquivo e caminho no campo de texto
set(handles.editexcelfile, 'string', variety);

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

variety_x = dt(1,4:end);
%salvando o vetor de comprimentos de onda
setappdata(0, 'variety_x', variety_x);

%os dados originais s�o plotados
plot_original_data(handles.axes2);
end

%fun��o ativada quando o usu�rio clica no segundo bot�o browse
function btnbrowse2_Callback(hObject, eventdata, handles)

%fun��o que abre uma janela para que o usu�rio escolha uma pasta onde o
%arquivo de destino ser� salvo
file = uigetdir();
% 
% %a pasta de destino � exibida no campo de texto edit10
set(handles.edit8, 'string', file);
% 
% %salvo a pasta de destino
setappdata(0, 'dest_folder', file);
% 
% %os dados originais s�o plotados
% plot_original_data(handles.axes2);

end

%fun��o para plotar os dados originais
function plot_original_data(hAxes2)

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
    hold on
end
hold off

%t�tulo do gr�fico
title('Raw data');

%limite das abscissas. variety_x(1) corresponde � 450 e variety_x(rng_size)
%corresponde ao comprimento de onda na �ltima posi��o, que � 1800 nesse caso
%(rng_size cont�m o n�mero de comprimentos de onda.
xlim([variety_x(1) variety_x(rng_size)])

end

%fun��o executada quando o usu�rio escolhe a wavelet
function popupmenu14_Callback(hObject, eventdata, handles)

%salvando em content a op��o escolhida como wavelet (content � um campo
%num�rico)

content = get(handles.popupmenu14, 'Value');

%de acordo com content, mostra-se as respectivas variantes da
%wavelet escolhida
if eq(content, 2) 
    %a fun��o set deixa o menu da wavelet daubechies 
    %correspondente ao n�mero 2) vis�vel (on) e os demais off
	set(handles.popupmenu17, 'visible', 'on');
	set(handles.popupmenu18, 'visible', 'off');
	set(handles.popupmenu19, 'visible', 'off');
	set(handles.popupmenu20, 'visible', 'off');
	set(handles.popupmenu21, 'visible', 'off');
elseif eq(content, 3)
    %wavelet symlets escolhida, ent�o seu menu fica vis�vel e os demais n�o
	set(handles.popupmenu17, 'visible', 'off');
	set(handles.popupmenu18, 'visible', 'on');
	set(handles.popupmenu19, 'visible', 'off');
	set(handles.popupmenu20, 'visible', 'off');
	set(handles.popupmenu21, 'visible', 'off');
elseif eq(content, 4)  
    %wavelet coiflets escolhida, ent�o seu menu fica vis�vel e os demais n�o
	set(handles.popupmenu17, 'visible', 'off');
	set(handles.popupmenu18, 'visible', 'off');
	set(handles.popupmenu19, 'visible', 'on');
	set(handles.popupmenu20, 'visible', 'off');
	set(handles.popupmenu21, 'visible', 'off');
elseif eq(content, 5)
    %wavelet biorsplines escolhida, ent�o seu menu fica vis�vel e os demais n�o
	set(handles.popupmenu17, 'visible', 'off');
	set(handles.popupmenu18, 'visible', 'off');
	set(handles.popupmenu19, 'visible', 'off');
	set(handles.popupmenu20, 'visible', 'on');
	set(handles.popupmenu21, 'visible', 'off');
elseif eq(content, 6)  
    %wavelet reverse bior escolhida, ent�o seu menu fica vis�vel e os demais n�o
	set(handles.popupmenu17, 'visible', 'off');
	set(handles.popupmenu18, 'visible', 'off');
	set(handles.popupmenu19, 'visible', 'off');
	set(handles.popupmenu20, 'visible', 'off');
	set(handles.popupmenu21, 'visible', 'on');
else
    %caso uma wavelet sem variantes tenha sido escolhida, todos os menus
    %ficam invis�veis
	set(handles.popupmenu17, 'visible', 'off');
	set(handles.popupmenu18, 'visible', 'off');
	set(handles.popupmenu19, 'visible', 'off');
	set(handles.popupmenu20, 'visible', 'off');
	set(handles.popupmenu21, 'visible', 'off');
end

end

%fun��o chamada quando o primeiro checkbox � marcado/desmarcado. Essa fun��o exibe os
%campos de texto e menus da wavelet denoise e desmarca o segundo checkbox
function checkbox4_Callback(hObject, eventdata, handles)

check4 = get(handles.checkbox4, 'value');

if eq(check4,0)
    set(handles.popupmenu15, 'visible', 'off');
    set(handles.text15, 'visible', 'off');
    
    set(handles.checkbox3, 'enable', 'on');
    
else
    set(handles.popupmenu15, 'visible', 'on');
    set(handles.text15, 'visible', 'on');

    set(handles.checkbox3, 'enable', 'off');
end

end

%fun��o chamada quando o segundo checkbox � marcado. Essa fun��o exibe o
%campo de texto e menu da wavelet compression e desmarca o primeiro checkbox
function checkbox3_Callback(hObject, eventdata, handles)

check3 = get(handles.checkbox3, 'value');

if eq(check3,0)
    set(handles.text23, 'visible', 'off');
    set(handles.edit11, 'visible', 'off');
    
    set(handles.checkbox4, 'enable', 'on');

else
    set(handles.text23, 'visible', 'on');
    set(handles.edit11, 'visible', 'on');

    set(handles.checkbox4, 'enable', 'off');
end

end

%fun��o executada quando o �ltimo bot�o OK � pressionado
function pushbutton6_Callback(hObject, eventdata, handles)

%recuperando o vetor de comprimentos de onda salvo anteriormente
variety_x = getappdata(0, 'variety_x');

%obtenho o nome da variedade e qualidade interna inseridas pelo usu�rio
var_text = get(handles.edit10, 'String');

%salvo essas vari�veis para que outras fun��es as acessem
setappdata(0, 'var_text', var_text);

%get retorna um n�mero correspondente � op��o escolhida no menu de wavelet
wavelet = get(handles.popupmenu14, 'Value');

%a fun��o waveletName retorna o nome da wavelet de acordo com a op��o
%escolhida
wname = waveletName(wavelet, handles.popupmenu17, handles.popupmenu18, handles.popupmenu19, handles.popupmenu20, handles.popupmenu21);

%salvando o nome da wavelet
setappdata(0, 'wname', wname);

%salvo em range_txt a range inserida pelo usu�rio, armazenada no campo de
%texto edit7 como string
range_txt = get(handles.edit7, 'String');

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

%salvo o tipo de opera��o
setappdata(0, 'op_type', 'den');
%obtenho o threshold selecionado e salvo
threshold = get(handles.popupmenu15, 'Value');
setappdata(0, 'threshold', threshold);

%chamando a tela de gr�ficos
tela_graficos;
end

%fun��o que retorna o nome da wavelet escolhido
function wname = waveletName(wavelet, popupmenu17, popupmenu18, popupmenu19, popupmenu20, popupmenu21)

switch wavelet
    case 1
        %wname recebe haar, que foi a wavelet escolhida.
        wname = 'haar';
    case 2
        %para wavelets que tenham variantes, obt�m-se tamb�m a variante
        %correspondente do menu. Assim, concatena-se esses dois nomes em wname.
        wname = 'db';
        lista = get(popupmenu17, 'String');
        index = get(popupmenu17, 'Value');
        num = lista{index};
        wname = strcat(wname, num);
    case 3 
        wname = 'sym';
        lista = get(popupmenu18, 'String');
        index = get(popupmenu18, 'Value');
        num = lista{index};
        wname = strcat(wname, num);
    case 4 
        wname = 'coif';
        lista = get(popupmenu19, 'String');
        index = get(popupmenu19, 'Value');
        num = lista{index};
        wname = strcat(wname, num);
    case 5 
        wname = 'bior';
        lista = get(popupmenu20, 'String');
        index = get(popupmenu20, 'Value');
        num = lista{index};
        wname = strcat(wname, num);
    case 6 
        wname = 'rbio';
        lista = get(popupmenu21, 'String');
        index = get(popupmenu21, 'Value');
        num = lista{index};
        wname = strcat(wname, num);
    case 7 
        wname = 'dmey';
end
end

%fun��o que retorna a matriz de comprimentos de onda das faixas inseridas
function range = getRange(range_txt)

%armazeno em num a quantidade de ; (separadores) na range
num = length(strfind(range_txt, ';'));

%incremento num. Essa vari�vel agora armazena a quantidade de faixas
%inseridas
num=num+1;

%quebro a string em substrings, utilizando como separador o ;
range_txt2 = strsplit(range_txt, ';');

range = cell(num,2);
for i=1:num
    %cada substring � quebrada em duas strings, utilizando como separador o -
    range(i,:) = strsplit(range_txt2{i},'-');
end

%as substrings s�o convertidas para inteiro. Cada linha da matriz range 
%corresponde a uma faixa inserida pelo usu�rio. Ex: [450 500]
range = str2double(range);
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

function popupmenu14_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function popupmenu15_Callback(hObject, eventdata, handles)

end

function popupmenu15_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function popupmenu16_Callback(hObject, eventdata, handles)

end

function popupmenu16_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function popupmenu17_Callback(hObject, eventdata, handles)

end

function popupmenu17_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function popupmenu18_Callback(hObject, eventdata, handles)

end

function popupmenu18_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function popupmenu19_Callback(hObject, eventdata, handles)

end

function popupmenu19_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function popupmenu20_Callback(hObject, eventdata, handles)

end

function popupmenu20_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function popupmenu21_Callback(hObject, eventdata, handles)

end

function popupmenu21_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function popupmenu22_Callback(hObject, eventdata, handles)

end

function popupmenu22_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function popupmenu23_Callback(hObject, eventdata, handles)

end

function popupmenu23_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function popupmenu24_Callback(hObject, eventdata, handles)

end

function popupmenu24_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function popupmenu25_Callback(hObject, eventdata, handles)

end

function popupmenu25_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function popupmenu26_Callback(hObject, eventdata, handles)

end

function popupmenu26_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit7_Callback(hObject, eventdata, handles)

end

function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit8_Callback(hObject, eventdata, handles)

end

function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function edit9_Callback(hObject, eventdata, handles)

end

function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit10_Callback(hObject, eventdata, handles)

end

function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit11_Callback(hObject, eventdata, handles)

end

function edit11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function editexcelfile_Callback(hObject, eventdata, handles)

end

function editexcelfile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
