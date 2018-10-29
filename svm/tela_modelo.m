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

h_cal = [handles.cal_correlation, handles.cal_rpearson, handles.cal_rsquare, handles.cal_rmsec, handles.cal_sec, handles.cal_bias];
h_val = [handles.val_correlation, handles.val_rpearson, handles.val_rsquare, handles.val_rmsecv, handles.val_secv, handles.val_bias];
setappdata(0, 'h_cal', h_cal);
setappdata(0, 'h_val', h_val);
setappdata(0, 'axes1', handles.axes1);

%recupero as variáveis
num_files = getappdata(0, 'num_files');
%abs_data = getappdata(0, 'abs_data');
%qua_data = getappdata(0, 'qua_data');
smp_size = getappdata(0, 'smp_size');
rng_size = getappdata(0, 'rng_size');
file_names = getappdata(0, 'file_names');
variety = getappdata(0, 'variety');
prediction_path = getappdata(0, 'prediction_path');

set(handles.listbox_files, 'string', strcat('SVM_', file_names));

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

plot_points(cpred{current_file}, smp_size, 'blue');
print_results(calibration(current_file), validation(current_file));
end

function btn_cal_Callback(hObject, eventdata, handles)
cpred = getappdata(0, 'cpred');
smp_size = getappdata(0, 'smp_size');
current_file = getappdata(0, 'current_file');

plot_points(cpred{current_file}, smp_size, 'blue');
end

function btn_val_Callback(hObject, eventdata, handles)
cvpred = getappdata(0, 'cvpred');
smp_size = getappdata(0, 'smp_size');
current_file = getappdata(0, 'current_file');

plot_points(cvpred{current_file}, smp_size, 'red');
end

function btn_export_Callback(hObject, eventdata, handles)
% calibration = getappdata(0, 'calibration');
% validation = getappdata(0, 'validation');
% var_text = getappdata(0, 'var_text');
% qua_text = getappdata(0, 'qua_text');
% path = getappdata(0, 'dest_folder');
% num_files = getappdata(0, 'num_files');
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
%         time(1,i)]; 
%     A{ind,1} = strcat('SVM_', file_names{i});
%     for j=2:14
%         A{ind,j} = aux(j-1);
%     end
%     ind = ind + 1;
% end
% range = strcat('A', num2str(m+2), ':', 'N', num2str(num_files+m+1));
% xlswrite(path, A, strcat(qua_text, '_', var_text), range);
end

function listbox_files_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
