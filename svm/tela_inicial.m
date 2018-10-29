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

%função executada quando o usuário clica no primeiro botão browse
function pushbutton1_Callback(hObject, eventdata, handles)
% função que abre uma janela para que o usuário escolha uma pasta onde estão
% os dados a serem testados
folder = uigetdir();

%colocando o nome do arquivo e caminho no campo de texto
set(handles.editexcel, 'string', folder);

%salvo o caminho até a pasta
setappdata(0, 'files_folder', folder);
end

%função chamada quando o usuário clica no segundo botão browse
function pushbutton2_Callback(hObject, eventdata, handles)
%função que abre uma janela para que o usuário escolha uma pasta onde o
%arquivo de destino será salvo
folder = uigetdir();

%a pasta de destino é exibida no campo de texto edit_dest_folder
set(handles.editdestfolder, 'string', folder);

%salvo a pasta de destino
setappdata(0, 'dest_folder', folder);
end

% --- Executes on button press in btnpred.
function btnpred_Callback(hObject, eventdata, handles)
% hObject    handle to btnpred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%obtendo o nome do arquivo (variety) e o caminho atÃ© o arquivo (path)
[variety, path] = uigetfile('*.xlsx', 'Select the excel file');

%atribuindo Ã  variety a concatenaÃ§Ã£o do caminho e nome do arquivo
variety = strcat(path, variety);

%colocando o nome do arquivo e caminho no campo de texto
set(handles.editpred, 'string', variety);

setappdata(0, 'prediction_path', variety);
end

%função chamada quando o usuário clica em build model
function pushbutton3_Callback(hObject, eventdata, handles)
%obtenho o nome da variedade e qualidade interna inseridas pelo usuário
var_text = get(handles.editvariety, 'String');
qua_text = get(handles.editinternal, 'String');

%salvo essas variáveis
setappdata(0, 'var_text', var_text);
setappdata(0, 'qua_text', qua_text);
setappdata(0, 'text6', handles.text6);

files_folder = getappdata(0, 'files_folder');

%salvo em files os arquivos excel da pasta selecionada
files = dir(fullfile(files_folder, '*.xlsx'));

%salvo os nomes dos arquivos
[m,~] = size(files);
setappdata(0, 'num_files', m);

files = struct2cell(files);
names = files(1,:);

%converto para o formato cell array
names = cellstr(names);

%removo o sufixo .xlsx
for i=1:m
    C = strsplit(names{i}, '.');
    names{i} = C{1};
end

setappdata(0, 'file_names', names);

variety = cell(m, 1);
%concateno os nomes com o caminho
for i=1:m
   variety{i} = strcat(files_folder, '\', names{i});
end

%salvando os caminhos + arquivos
setappdata(0, 'variety', variety);

%obtenho o n?mero de amostras e faixas
data = xlsread(variety{1});

[smp_size,rng_size] = size(data);
smp_size = smp_size - 1;
rng_size = rng_size - 3;

setappdata(0, 'smp_size', smp_size);
setappdata(0, 'rng_size', rng_size);
setappdata(0, 'variety_x', data(1, 4:end));
tela_modelo;
end 

function varargout = tela_inicial_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
end

function editdestfolder_Callback(hObject, eventdata, handles)
end

function editdestfolder_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function editinternal_Callback(hObject, eventdata, handles)
end

function editinternal_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function editvariety_Callback(hObject, eventdata, handles)
end

function editvariety_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function editexcel_Callback(hObject, eventdata, handles)
end

function editexcel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function editpred_Callback(hObject, eventdata, handles)
% hObject    handle to editpred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editpred as text
%        str2double(get(hObject,'String')) returns contents of editpred as a double
end

% --- Executes during object creation, after setting all properties.
function editpred_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editpred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
