function varargout = tela_graficos(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tela_graficos_OpeningFcn, ...
                   'gui_OutputFcn',  @tela_graficos_OutputFcn, ...
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

%função executada quando a tela está abrindo
function tela_graficos_OpeningFcn(hObject, eventdata, handles, varargin)

%recupero as vari�veis salvas anteriormente
wname = getappdata(0, 'wname');
data = getappdata(0, 'data');
variety_x = getappdata(0, 'variety_x');
pos_mat = getappdata(0, 'pos_mat');
smp_size = getappdata(0, 'smp_size');
rng_size = getappdata(0, 'rng_size');
op_type = getappdata(0, 'op_type');
threshold = getappdata(0, 'threshold');

%dependendo da operação selecionada, chamo a função denoise ou comppress. 
%L é uma matriz de três dimensões (nível x amostra x comprimento de onda)
if (strcmp(op_type,'den'))
    L = denoise(pos_mat, smp_size, data, wname, variety_x, rng_size, threshold);
else
    L = compress(pos_mat, smp_size, data, wname, variety_x, rng_size);
end

%salvo L para que outras funções a acessem
setappdata(0, 'L', L);

handles.output = hObject;
guidata(hObject, handles);
end

function varargout = tela_graficos_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
end

%função executada quando o usuário aperta em Export
function pushbutton2_Callback(hObject, eventdata, handles)

%crio um vetor de checkboxes. Cada elemento conterá valores 1 para checkboxes
%marcadas e 0 para checkboxes desmarcadas
checkboxes = [handles.c1 handles.c2 handles.c3 handles.c4 handles.c5 ...
    handles.c6 handles.c7 handles.c8 handles.c9 handles.c10 handles.c11 handles.c12];
checkstate = get(checkboxes, 'Value');

%convertendo de formato de célula para matriz, para facilitar
checkstate = cell2mat(checkstate);

%recupero as variaveis salvas anteriormente
wname = getappdata(0, 'wname');
variety = getappdata(0, 'variety');
variety_x = getappdata(0, 'variety_x');
smp_size = getappdata(0, 'smp_size');
rng_size = getappdata(0, 'rng_size');
L = getappdata(0, 'L');
var_text = getappdata(0, 'var_text');
qua_text = getappdata(0, 'qua_text');
pos_mat = getappdata(0, 'pos_mat');
op_type = getappdata(0, 'op_type');

%raw1 conterá a primeira linha do arquivo excel original
raw1{1, 4} = [];
raw1{1} = 'Coleta';
raw1{2} = 'Amostra';
raw1{3} = qua_text;

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

%recuperando path, que corresponde ao caminho de destino
path = getappdata(0, 'dest_folder');

%obtenho o número de linhas da matriz de posiçao, que corresponderá ao
%número de faixas inseridas pelo usuário
[m,~] = size(pos_mat);

%para salvar o novo arquivo, deve-se adicionar ao caminho o nome dele. O
%nome será a concatenação do tipo de variedade, tipo de atributo e quantidade
%de faixas escolhidas, tipo de operação e tipo de threshold (se for
%denoise) ou valor do threshold (se for compression)
if (strcmp(op_type,'den'))
    threshold_type = getappdata(0, 'threshold_type');
    str = threshold_type;
    %path = strcat(path, '\', 'r', num2str(m), op_type, '_', threshold_type, '.xlsx');
else
    glb_threshold = getappdata(0, 'glb_threshold');
    str = num2str(glb_threshold);
    %path = strcat(path, '\', 'r', num2str(m), op_type, '_', num2str(glb_threshold), '.xlsx');
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
%qualidade), pois os valores pré-processados serão obtidos de L, que não
%possui essas 3 colunas
rng_size = rng_size + 3;

%verifica cada checkbox
for i=1:12
   %se o checkbox correspondente a determinado nível esvier selecionado, o
   %export é realizado
   if(eq(checkstate(i),1))
       %iteração para cada amostra
   		for j=2:smp_size
            %iteração para cada comprimento de onda
   			for k=4:rng_size
                %escrevendo para A as absorbâncias calculadas para cada
                %comprimento de onda de cada amostra
   				A{j, k} = L(i,j-1, k-3);
   			end
        end
        %copia para o caminho já definido (path) a matriz A, com o nome dos
        %spreadsheets dados pela concatenação do nome da wavelet, nível de
        %decomposição e tipo de threshold
        path = strcat(path, '\', var_text, '_', 'r', num2str(m), str, '_', wname, 'l', num2str(i),'.xlsx');
   		xlswrite(path, A);
        path = getappdata(0, 'dest_folder');
   end
end

end

%ignorar funções abaixo
function pushbutton1_Callback(hObject, eventdata, handles)
end

function checkbox2_Callback(hObject, eventdata, handles)

end

function checkbox3_Callback(hObject, eventdata, handles)

end

function checkbox4_Callback(hObject, eventdata, handles)

end

function checkbox5_Callback(hObject, eventdata, handles)

end

function checkbox6_Callback(hObject, eventdata, handles)

end

function checkbox7_Callback(hObject, eventdata, handles)

end

function checkbox8_Callback(hObject, eventdata, handles)

end

function c8_Callback(hObject, eventdata, handles)

end

function c9_Callback(hObject, eventdata, handles)

end

function c10_Callback(hObject, eventdata, handles)

end

function c11_Callback(hObject, eventdata, handles)

end

function c12_Callback(hObject, eventdata, handles)

end

function pushbutton2_KeyPressFcn(hObject, eventdata, handles)
end
  
function c3_Callback(hObject, eventdata, handles)

end

function c4_Callback(hObject, eventdata, handles)

end

function c5_Callback(hObject, eventdata, handles)

end

function c6_Callback(hObject, eventdata, handles)

end

function c7_Callback(hObject, eventdata, handles)

end

function asdasd_Callback(hObject, eventdata, handles)

end

function c2_Callback(hObject, eventdata, handles)

end
