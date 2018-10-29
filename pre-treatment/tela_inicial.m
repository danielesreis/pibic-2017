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

set(handles.check_medianfilter, 'enable', 'off');
set(handles.check_movingaverage, 'enable', 'off');
set(handles.edit_wsizemfilter, 'enable', 'off');
set(handles.edit_wsizemaverage, 'enable', 'off');

set(handles.check_1sgolay, 'enable', 'off');
set(handles.check_2sgolay, 'enable', 'off');
set(handles.edit_porder1, 'enable', 'off');
set(handles.edit_porder2, 'enable', 'off');
set(handles.edit_wsize1sgolay, 'enable', 'off');
set(handles.edit_wsize2sgolay, 'enable', 'off');

set(handles.check_msc, 'enable', 'off');
set(handles.check_snv, 'enable', 'off');
end

function varargout = tela_inicial_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
end

function btn_browse1_Callback(hObject, eventdata, handles)

%função que abre uma janela para que o usuário escolha uma pasta onde estão
%os dados
folder = uigetdir();

%colocando o caminho no campo de texto
set(handles.edit_origfolder, 'string', folder);

%salvo o caminho até a pasta
setappdata(0, 'files_folder', folder);
end

function btn_browse2_Callback(hObject, eventdata, handles)

%função que abre uma janela para que o usuário escolha uma pasta onde o
%arquivo de destino será salvo
folder = uigetdir();

%a pasta de destino é exibida no campo de texto edit_dest_folder
set(handles.edit_destfolder, 'string', folder);

%salvo a pasta de destino
setappdata(0, 'dest_folder', folder);
end

function check_smoothing_Callback(hObject, eventdata, handles)

check = get(handles.check_smoothing, 'value');

if eq(check, 0)
    set(handles.check_medianfilter, 'enable', 'off');
    set(handles.check_movingaverage, 'enable', 'off');
    set(handles.edit_wsizemfilter, 'enable', 'off');
    set(handles.edit_wsizemaverage, 'enable', 'off');
else
    set(handles.check_medianfilter, 'enable', 'on');
    set(handles.check_movingaverage, 'enable', 'on');
end
end

function check_derivative_Callback(hObject, eventdata, handles)

check = get(handles.check_derivative, 'value');

if eq(check, 0)
    set(handles.check_1sgolay, 'enable', 'off');
    set(handles.check_2sgolay, 'enable', 'off');
    set(handles.edit_porder1, 'enable', 'off');
    set(handles.edit_wsize1sgolay, 'enable', 'off');
    set(handles.edit_porder2, 'enable', 'off');
    set(handles.edit_wsize2sgolay, 'enable', 'off');
else
    set(handles.check_1sgolay, 'enable', 'on');
    set(handles.check_2sgolay, 'enable', 'on');
end
end

function check_scattercor_Callback(hObject, eventdata, handles)

check = get(handles.check_scattercor, 'value');

if eq(check, 0)
    set(handles.check_msc, 'enable', 'off');
    set(handles.check_snv, 'enable', 'off');
else
    set(handles.check_msc, 'enable', 'on');
    set(handles.check_snv, 'enable', 'on');
end
end

function check_medianfilter_Callback(hObject, eventdata, handles)

check = get(handles.check_medianfilter, 'value');

if eq(check, 0)
    set(handles.edit_wsizemfilter, 'enable', 'off');
else
    set(handles.edit_wsizemfilter, 'enable', 'on');
end
end

function check_movingaverage_Callback(hObject, eventdata, handles)

check = get(handles.check_movingaverage, 'value');

if eq(check, 0)
    set(handles.edit_wsizemaverage, 'enable', 'off');
else
    set(handles.edit_wsizemaverage, 'enable', 'on');
end

end

function check_1sgolay_Callback(hObject, eventdata, handles)

check = get(handles.check_1sgolay, 'value');

if eq(check, 0)
    set(handles.edit_porder1, 'enable', 'off');
    set(handles.edit_wsize1sgolay, 'enable', 'off');
else
    set(handles.edit_porder1, 'enable', 'on');
    set(handles.edit_wsize1sgolay, 'enable', 'on');
end
end

function check_2sgolay_Callback(hObject, eventdata, handles)

check = get(handles.check_2sgolay, 'value');

if eq(check, 0)
    set(handles.edit_porder2, 'enable', 'off');
    set(handles.edit_wsize2sgolay, 'enable', 'off');
else
    set(handles.edit_porder2, 'enable', 'on');
    set(handles.edit_wsize2sgolay, 'enable', 'on');
end
end

function check_msc_Callback(hObject, eventdata, handles)
end

function check_snv_Callback(hObject, eventdata, handles)
end

function btn_ok_Callback(hObject, eventdata, handles)

check_smoothing = get(handles.check_smoothing, 'value');
setappdata(0, 'check_smoothing', check_smoothing);

check_derivative = get(handles.check_derivative, 'value');
setappdata(0, 'check_derivative', check_derivative);

check_scattercor = get(handles.check_scattercor, 'value');
setappdata(0, 'check_scattercor', check_scattercor);

check_medianfilter = get(handles.check_medianfilter, 'value');
setappdata(0, 'check_medianfilter', check_medianfilter);

check_movingaverage = get(handles.check_movingaverage, 'value');
setappdata(0, 'check_movingaverage', check_movingaverage);

check_1sgolay = get(handles.check_1sgolay, 'value');
setappdata(0, 'check_1sgolay', check_1sgolay);

check_2sgolay = get(handles.check_2sgolay, 'value');
setappdata(0, 'check_2sgolay', check_2sgolay);

check_msc = get(handles.check_msc, 'value');
setappdata(0, 'check_msc', check_msc);

check_snv = get(handles.check_snv, 'value');
setappdata(0, 'check_snv', check_snv);

setappdata(0, 'edit_wsizemfilter', get(handles.edit_wsizemfilter, 'string'));
setappdata(0, 'edit_wsizemaverage', get(handles.edit_wsizemaverage, 'string'));
setappdata(0, 'edit_porder1', get(handles.edit_porder1, 'string'));
setappdata(0, 'edit_porder2', get(handles.edit_porder2, 'string'));
setappdata(0, 'edit_wsize1sgolay', get(handles.edit_wsize1sgolay, 'string'));
setappdata(0, 'edit_wsize2sgolay', get(handles.edit_wsize2sgolay, 'string'));

setappdata(0, 'var_text', get(handles.edit_var, 'string'));

setappdata(0, 'text_att', handles.text8);

if eq(check_smoothing, 0)
    if eq(check_derivative, 0)
        if eq(check_scattercor, 1)
            pretreat_routine_no_smoothing_derivative();
        end
    else
        pretreat_routine_no_smoothing();
    end
else
    pretreat_routine_complete();
end
end

function edit_wsizemaverage_Callback(hObject, eventdata, handles)
end

function edit_wsizemaverage_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_wsizemfilter_Callback(hObject, eventdata, handles)
end

function edit_wsizemfilter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_porder1_Callback(hObject, eventdata, handles)
end

function edit_porder1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_wsize1sgolay_Callback(hObject, eventdata, handles)
end

function edit_wsize1sgolay_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_porder2_Callback(hObject, eventdata, handles)
end

function edit_porder2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_wsize2sgolay_Callback(hObject, eventdata, handles)
end

function edit_wsize2sgolay_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_origfolder_Callback(hObject, eventdata, handles)
end

function edit_origfolder_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_destfolder_Callback(hObject, eventdata, handles)
end

function edit_destfolder_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_var_Callback(hObject, eventdata, handles)
end

function edit_var_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function edit_att_Callback(hObject, eventdata, handles)
end

function edit_att_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
