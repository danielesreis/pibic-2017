function varargout = tela_inicial(varargin)
% TELA_INICIAL MATLAB code for tela_inicial.fig
%      TELA_INICIAL, by itself, creates a new TELA_INICIAL or raises the existing
%      singleton*.
%
%      H = TELA_INICIAL returns the handle to a new TELA_INICIAL or the handle to
%      the existing singleton*.
%
%      TELA_INICIAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TELA_INICIAL.M with the given input arguments.
%
%      TELA_INICIAL('Property','Value',...) creates a new TELA_INICIAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tela_inicial_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tela_inicial_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tela_inicial

% Last Modified by GUIDE v2.5 16-Mar-2018 15:21:34

% Begin initialization code - DO NOT EDIT
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
% End initialization code - DO NOT EDIT
end

% --- Executes just before tela_inicial is made visible.
function tela_inicial_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tela_inicial (see VARARGIN)

% Choose default command line output for tela_inicial
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tela_inicial wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

function varargout = tela_inicial_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
end

function edit1_Callback(hObject, eventdata, handles)

end

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function pushbutton1_Callback(hObject, eventdata, handles)
folder = uigetdir();
files = dir(fullfile(folder, '*.xlsx'));

setappdata(0, 'train_path', folder);

[m,~] = size(files);
names = cell(m,1);
for i=1:size(files)
    names{i,1} = files(i).name;
end
setappdata(0, 'train_file', names);
setappdata(0, 'train_number', m);

set(handles.edit1, 'string', folder);
end

function edit2_Callback(hObject, eventdata, handles)

end

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function pushbutton2_Callback(hObject, eventdata, handles)
folder = uigetdir();
setappdata(0, 'dest_folder', folder);
set(handles.edit2, 'string', folder);
end

function pushbutton3_Callback(hObject, eventdata, handles)
train_path = getappdata(0, 'train_path');
train_file = getappdata(0, 'train_file');
dest_folder = getappdata(0, 'dest_folder');
train_number = getappdata(0, 'train_number');
predict_path = getappdata(0, 'predict_path');

main(train_path, train_file, dest_folder, train_number, predict_path);
end

function edit3_Callback(hObject, eventdata, handles)
end

function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function pushbutton4_Callback(hObject, eventdata, handles)
%obtendo o nome do arquivo e o caminho até o arquivo
[file, path] = uigetfile('*.xlsx', 'Select the excel file');
file_path = strcat(path, file);

setappdata(0, 'predict_path', file_path);
set(handles.edit3, 'string', file_path);
end
