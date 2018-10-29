function varargout = tela_modelo(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tela_modelo_OpeningFcn, ...
                   'gui_OutputFcn',  @tela_modelo_OutputFcn, ...
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

function tela_modelo_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

%recupero as variáveis
h_cal = [handles.cal_correlation, handles.cal_rpearson, handles.cal_rsquare, handles.cal_rmsec, handles.cal_sec, handles.cal_bias];
h_val = [handles.val_correlation, handles.val_rpearson, handles.val_rsquare, handles.val_rmsecv, handles.val_secv, handles.val_bias];
setappdata(0, 'h_cal', h_cal);
setappdata(0, 'h_val', h_val);
setappdata(0, 'axes1', handles.axes1);

num_files = getappdata(0, 'num_files');
smp_size = getappdata(0, 'smp_size');
rng_size = getappdata(0, 'rng_size');
file_names = getappdata(0, 'file_names');
variety = getappdata(0, 'variety');
prediction_path = getappdata(0, 'prediction_path');
set(handles.listbox_files, 'string', strcat('PLS_', file_names));

build_model2(num_files, file_names, variety, smp_size, rng_size, prediction_path);
end

function varargout = tela_modelo_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
end

function listbox_files_Callback(hObject, eventdata, handles)

calibration = getappdata(0, 'calibration');
validation = getappdata(0, 'validation');
smp_size = getappdata(0, 'smp_size');
cpred = getappdata(0, 'cpred');

current_file = get(handles.listbox_files, 'value');
setappdata(0, 'current_file', current_file);

plot_points(cpred{current_file, 1}, smp_size, current_file, 'blue');
print_results(calibration(current_file), validation(current_file));
end

function btn_cal_Callback(hObject, eventdata, handles)

smp_size = getappdata(0, 'smp_size');
cpred = getappdata(0, 'cpred');
current_file = getappdata(0, 'current_file');
plot_points(cpred{current_file, 1}, smp_size, current_file, 'blue');
end

function pushbutton4_Callback(hObject, eventdata, handles)

smp_size = getappdata(0, 'smp_size');
cvpred = getappdata(0, 'cvpred');
current_file = getappdata(0, 'current_file');
plot_points(cvpred{current_file, 1}, smp_size, current_file, 'red');
end

%botão apertado quando o usuário quer exportar
function btn_export_Callback(hObject, eventdata, handles)

% calibration = getappdata(0, 'calibration');
% validation = getappdata(0, 'validation');
% var_text = getappdata(0, 'var_text');
% qua_text = getappdata(0, 'qua_text');
% path = getappdata(0, 'dest_folder');
% num_files = getappdata(0, 'num_files');
% lv_num = getappdata(0, 'lv_num');
% file_names = getappdata(0, 'file_names');
% time = getappdata(0, 'time');
% 
% file = dir(fullfile(path, strcat(var_text, '*.xlsx')));
% path = fullfile(path, file.name);
% data = xlsread(path, strcat(qua_text, '_', var_text));
% [m,n] = size(data);
% 
% ind = 1;
% for i=1:num_files
%     aux = [calibration(i).correlation calibration(i).rpearson calibration(i).rsquare calibration(i).rmsec calibration(i).sec calibration(i).bias ...
%         validation(i).correlation validation(i).rpearson validation(i).rsquare validation(i).rmsecv validation(i).secv validation(i).bias ... 
%         time(1,i) lv_num(i,1)]; 
%     A{ind,1} = strcat('PLS_', file_names{i});
%     for j=2:15
%         A{ind,j} = aux(j-1);
%     end
%     ind = ind + 1;
% end
% range = strcat('A', num2str(m+2), ':', 'O', num2str(num_files+m+1));
% xlswrite(path, A, strcat(qua_text, '_', var_text), range);
end

function listbox_files_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function pushbutton2_Callback(hObject, eventdata, handles)

end
