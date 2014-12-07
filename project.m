function varargout = project(varargin)
% PROJECT MATLAB code for project.fig
%      PROJECT, by itself, creates a new PROJECT or raises the existing
%      singleton*.
%
%      H = PROJECT returns the handle to a new PROJECT or the handle to
%      the existing singleton*.
%
%      PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT.M with the given input arguments.
%
%      PROJECT('Property','Value',...) creates a new PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project

% Last Modified by GUIDE v2.5 24-Jun-2013 19:38:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project_OpeningFcn, ...
                   'gui_OutputFcn',  @project_OutputFcn, ...
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


% --- Executes just before project is made visible.
function project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project (see VARARGIN)

% Choose default command line output for project
handles.output = hObject;
handles.col = 1;  %initial col to make all zeros
handles.board = size(get(handles.matrixtable, 'data')); %uitable size
handles.completed = 0;  %keeps note of whether or not the matrix is upper triangular

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when entered data in editable cell(s) in matrixtable.
function matrixtable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to matrixtable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in matrix_set.
function matrix_set_Callback(hObject, eventdata, handles)
% hObject    handle to matrix_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matrix = get(handles.matrixtable, 'data');
x = 0;   %counter for dimensions
y = 0;   %counter for dimensions
solvable = 1;
%Different duty when not all board is filled; irrelevant
for i = 1:handles.board(1),
    for j =1:handles.board(2),
        if ~isempty(matrix{i,j})
            if x < i 
                x = i;
            end
            if y < j  && j~= handles.board(1)   %last column is solutions
                y = j;
            end
        end
    end
end
for i = 1:handles.board(1),
    for j=1:handles.board(2),
        if isempty(matrix{i,j})
            set(handles.invalid_popup, 'Visible', 'on');
            set(handles.ok_invalidpopup, 'Visible', 'on');
            solvable = 0;
        end
    end
end
handles.dimensions = [x,y];            
matrix = str2double(matrix);
handles.matrix = matrix;
if solvable == 1
    matrix_solvable(hObject, eventdata, handles);
else 
    freeze_background(hObject, eventdata, handles);
end
set(handles.talkbox, 'String', 'Choose a row to eliminate.');
guidata(hObject, handles);




% --- Executes on button press in ResetButton.
function ResetButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.matrixtable, 'data', repmat({''},handles.board(1), handles.board(2)));
matrix_setable(hObject, eventdata, handles);
handles.col = 1;  %back to initial col
set(handles.finished_note, 'Visible', 'off');
set(handles.matrixtable, 'Visible', 'off');
set(handles.matrix_set, 'Visible', 'off');
set(handles.ResetButton, 'Visible', 'off');
set(handles.row_selection, 'Visible', 'on');
set(handles.col_selection, 'Visible', 'on'); 
set(handles.text5, 'Visible', 'on');
set(handles.text6, 'Visible', 'on');
set(handles.start_button, 'Visible', 'on');
set(handles.pushbutton1, 'Visible', 'off');
set(handles.pushbutton2, 'Visible', 'off');
set(handles.pushbutton3, 'Visible', 'off');
set(handles.pushbutton4, 'Visible', 'off');
set(handles.pushbutton5, 'Visible', 'off');
set(handles.pushbutton6, 'Visible', 'off');
set(handles.pushbutton7, 'Visible', 'off');
set(handles.pushbutton8, 'Visible', 'off');
set(handles.pushbutton9, 'Visible', 'off');
set(handles.pushbutton10, 'Visible', 'off');
set(handles.SolutionIndicator, 'Visible', 'off');
set(handles.talkbox, 'String', 'Input your matrix data to start.');
guidata(hObject, handles);


% --- Executes when matrix is solved.
function find_solution(hObject, eventdata, handles)
matrix = handles.matrix;
rows = size(matrix,1);
cols = size(matrix,2);
coeff = matrix(:, 1:cols-1);
constants = matrix(:,cols);
n = length(constants);
if rank(matrix) == rank(coeff) && rank(coeff) == cols-1
    if size(coeff, 2) < size(coeff, 1)
        n = size(coeff, 2);
        coeff = matrix(1:rows-1, 1:cols-1);
        constants = matrix(1:rows-1,cols);
    end
    solution(n, 1) = constants(n)/coeff(n,n);
    for i = n-1:-1:1
        solution(i,1) = (constants(i)-coeff(i,i+1:n)*solution(i+1:n,1))./coeff(i,i);
    end
    stringdisplay = '';
    for i = 1:n
        stringdisplay = strcat(stringdisplay, strcat('x', num2str(i)));
        stringdisplay = strcat(stringdisplay, '= ');
        stringdisplay = strcat(stringdisplay, num2str(solution(i)));
        stringdisplay = strcat(stringdisplay, '   ;');
    end
    set(handles.talkbox, 'String', stringdisplay);
elseif rank(matrix) == rank(coeff) & rank(matrix) < cols-1
    stringdisplay = 'This system has infinitely many solutions.';
    set(handles.talkbox, 'String', stringdisplay);
elseif rank(matrix) ~= rank(coeff)
    stringdisplay = 'This system has no solutions.';
    set(handles.talkbox, 'String', stringdisplay);
end
guidata(hObject, handles);



% --- Update table with converted matrix.
function update(hObject, eventdata, handles)
matrix = repmat({''},handles.board(1), handles.board(2));
for i = 1:handles.board(1),
    for j = 1:handles.board(2),
        if (~isnan(handles.matrix(i,j)))
            matrix{i,j} = num2str(handles.matrix(i, j));
        end
    end
end
set(handles.matrixtable, 'data', matrix);
handles.completed = 1;
if ~strcmp(get(handles.pushbutton1, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton2, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton3, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton4, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton5, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton6, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton7, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton8, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton9, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton10, 'Visible'), 'off')
    handles.completed = 0;
end
if (handles.completed == 1)
    handles.col = handles.col + 1;
    set(handles.pushbutton1, 'Visible', 'off');
    set(handles.pushbutton2, 'Visible', 'on');
    set(handles.pushbutton3, 'Visible', 'on');
    set(handles.pushbutton4, 'Visible', 'on');
    set(handles.pushbutton5, 'Visible', 'on');
    set(handles.pushbutton6, 'Visible', 'on');
    set(handles.pushbutton7, 'Visible', 'on');
    set(handles.pushbutton8, 'Visible', 'on');
    set(handles.pushbutton9, 'Visible', 'on');
    set(handles.pushbutton10, 'Visible', 'on');
    row = handles.dimensions(1);
    if row < 10 | isequalwithequalnans(matrix(10,:), repmat({'0'}, 1, j))
        set(handles.pushbutton10, 'Visible', 'off');
    end
    if row < 9 | isequalwithequalnans(matrix(9,:), repmat({'0'}, 1, j))
        set(handles.pushbutton9, 'Visible', 'off');
    end
    if row < 8 | isequalwithequalnans(matrix(8,:), repmat({'0'}, 1, j))
        set(handles.pushbutton8, 'Visible', 'off');
    end
    if row < 7 | isequalwithequalnans(matrix(7,:), repmat({'0'}, 1, j))
        set(handles.pushbutton7, 'Visible', 'off');
    end
    if row < 6 | isequalwithequalnans(matrix(6,:), repmat({'0'}, 1, j))
        set(handles.pushbutton6, 'Visible', 'off');
    end
    if row < 5 | isequalwithequalnans(matrix(5,:), repmat({'0'}, 1, j))
        set(handles.pushbutton5, 'Visible', 'off');
    end
    if row < 4 | isequalwithequalnans(matrix(4,:), repmat({'0'}, 1, j))
      set(handles.pushbutton4, 'Visible', 'off');
    end
    if row < 3 | isequalwithequalnans(matrix(3,:), repmat({'0'}, 1, j))
        set(handles.pushbutton3, 'Visible', 'off');
    end
    if row < 2 | isequalwithequalnans(matrix(2,:), repmat({'0'}, 1, j))
       set(handles.pushbutton2, 'Visible', 'off');
    end
    if handles.col > 1
        set(handles.pushbutton2, 'Visible', 'off');
    end
    if handles.col > 2
        set(handles.pushbutton3, 'Visible', 'off');
    end
    if handles.col > 3
        set(handles.pushbutton4, 'Visible', 'off');
    end
    if handles.col > 4
        set(handles.pushbutton5, 'Visible', 'off');
    end
    if handles.col > 5
        set(handles.pushbutton6, 'Visible', 'off');
    end
    if handles.col > 6
        set(handles.pushbutton7, 'Visible', 'off');
    end
    if handles.col > 7
        set(handles.pushbutton8, 'Visible', 'off');
    end
    if handles.col > 8
        set(handles.pushbutton9, 'Visible', 'off');
    end
    if handles.col > 9
        set(handles.pushbutton10, 'Visible', 'off');
    end
end
handles.completed = 1;
if ~strcmp(get(handles.pushbutton1, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton2, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton3, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton4, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton5, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton6, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton7, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton8, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton9, 'Visible'), 'off')
    handles.completed = 0;
end
if ~strcmp(get(handles.pushbutton10, 'Visible'), 'off')
    handles.completed = 0;
end
if handles.completed ==1
    set(handles.finished_note, 'Visible', 'on');
    find_solution(hObject, eventdata, handles)
end
if handles.col >= handles.dimensions(1)
    set(handles.finished_note, 'Visible', 'on');
    find_solution(hObject, eventdata, handles)
end
guidata(hObject, handles);




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton1, 'Visible', 'off');
guidata(hObject, handles);
update(hObject, eventdata, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton2, 'Visible', 'off');
matrix = handles.matrix;
j = handles.col;    %matrix col
i = 2;              %matrix row that client chose to eliminate
var = matrix(i, j)/matrix(j, j);
matrix(i, :) = matrix(i, :) - var*matrix(j, :);
handles.matrix = matrix;
% pause(0.5)
% points = get(handles.pushbutton1, 'Position');
% current = get(handles.arrow, 'Position');
% y = points(2);       %pixel position of the arrow
% current(2) = y;
% set(handles.arrow, 'Position', current);
% set(handles.arrow, 'Visible', 'on');
% pause(0.5)
%Controlling display
stringdisplay = strcat('Multiply this row by   ', num2str(var));
set(handles.talkbox, 'String', stringdisplay);
y = 500 - (35*j);      %starting pixel location of the arrow
position = get(handles.variable_display, 'position');
position(2) = y;
variable_words = strcat('x', num2str(var));
variable_words = strcat(variable_words, ' >');
set(handles.variable_display, 'String', variable_words);
set(handles.variable_display, 'Position', position);
set(handles.variable_display, 'Visible', 'on');
pause(2.0)
stringdisplay = 'Then, subtract from this row';
set(handles.talkbox, 'String', stringdisplay);
position(2) = 500 - (35*2);     %500 pixel starting position; 35 pixel height; 2nd row;
set(handles.variable_display, 'position', position);
set(handles.variable_display, 'String', '>');
pause(2.0)
stringdisplay = 'Choose a row to eliminate';
set(handles.talkbox, 'String', stringdisplay);
set(handles.variable_display, 'Visible', 'off');
guidata(hObject, handles);
update(hObject, eventdata, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton3, 'Visible', 'off');
matrix = handles.matrix;
j = handles.col;    %matrix col
i = 3;              %matrix row that client chose to eliminate
var = matrix(i, j)/matrix(j, j);
matrix(i, :) = matrix(i, :) - var*matrix(j, :);
handles.matrix = matrix;
%Controlling display
stringdisplay = strcat('Multiply this row by   ', num2str(var));
set(handles.talkbox, 'String', stringdisplay);
y = 500 - (35*j);      %starting pixel location of the arrow
position = get(handles.variable_display, 'position');
position(2) = y;
variable_words = strcat('x', num2str(var));
variable_words = strcat(variable_words, ' >');
set(handles.variable_display, 'String', variable_words);
set(handles.variable_display, 'Position', position);
set(handles.variable_display, 'Visible', 'on');
pause(2.0)
stringdisplay = 'Then, subtract from this row';
set(handles.talkbox, 'String', stringdisplay);
position(2) = 500 - (35*3);     %500 pixel starting position; 35 pixel height; 3rd row;
set(handles.variable_display, 'position', position);
set(handles.variable_display, 'String', '>');
pause(2.0)
stringdisplay = 'Choose a row to eliminate';
set(handles.talkbox, 'String', stringdisplay);
set(handles.variable_display, 'Visible', 'off');
guidata(hObject, handles);
update(hObject, eventdata, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton4, 'Visible', 'off');
matrix = handles.matrix;
j = handles.col;    %matrix col
i = 4;              %matrix row that client chose to eliminate
var = matrix(i, j)/matrix(j, j);
matrix(i, :) = matrix(i, :) - var*matrix(j, :);
handles.matrix = matrix;
%Controlling display
stringdisplay = strcat('Multiply this row by   ', num2str(var));
set(handles.talkbox, 'String', stringdisplay);
y = 500 - (35*j);      %starting pixel location of the arrow
position = get(handles.variable_display, 'position');
position(2) = y;
variable_words = strcat('x', num2str(var));
variable_words = strcat(variable_words, ' >');
set(handles.variable_display, 'String', variable_words);
set(handles.variable_display, 'Position', position);
set(handles.variable_display, 'Visible', 'on');
pause(2.0)
stringdisplay = 'Then, subtract from this row';
set(handles.talkbox, 'String', stringdisplay);
position(2) = 500 - (35*4);     %500 pixel starting position; 35 pixel height; 4th row;
set(handles.variable_display, 'position', position);
set(handles.variable_display, 'String', '>');
pause(2.0)
stringdisplay = 'Choose a row to eliminate';
set(handles.talkbox, 'String', stringdisplay);
set(handles.variable_display, 'Visible', 'off');
guidata(hObject, handles);
update(hObject, eventdata, handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton5, 'Visible', 'off');
matrix = handles.matrix;
j = handles.col;    %matrix col
i = 5;              %matrix row that client chose to eliminate
var = matrix(i, j)/matrix(j, j);
matrix(i, :) = matrix(i, :) - var*matrix(j, :);
handles.matrix = matrix;
%Controlling display
stringdisplay = strcat('Multiply this row by   ', num2str(var));
set(handles.talkbox, 'String', stringdisplay);
y = 500 - (35*j);      %starting pixel location of the arrow
position = get(handles.variable_display, 'position');
position(2) = y;
variable_words = strcat('x', num2str(var));
variable_words = strcat(variable_words, ' >');
set(handles.variable_display, 'String', variable_words);
set(handles.variable_display, 'Position', position);
set(handles.variable_display, 'Visible', 'on');
pause(2.0)
stringdisplay = 'Then, subtract from this row';
set(handles.talkbox, 'String', stringdisplay);
position(2) = 500 - (35*5);     %500 pixel starting position; 35 pixel height; 5th row;
set(handles.variable_display, 'position', position);
set(handles.variable_display, 'String', '>');
pause(2.0)
stringdisplay = 'Choose a row to eliminate';
set(handles.talkbox, 'String', stringdisplay);
set(handles.variable_display, 'Visible', 'off');
guidata(hObject, handles);
update(hObject, eventdata, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton6, 'Visible', 'off');
matrix = handles.matrix;
j = handles.col;    %matrix col
i = 6;              %matrix row that client chose to eliminate
var = matrix(i, j)/matrix(j, j);
matrix(i, :) = matrix(i, :) - var*matrix(j, :);
handles.matrix = matrix;
%Controlling display
stringdisplay = strcat('Multiply this row by   ', num2str(var));
set(handles.talkbox, 'String', stringdisplay);
y = 500 - (35*j);      %starting pixel location of the arrow
position = get(handles.variable_display, 'position');
position(2) = y;
variable_words = strcat('x', num2str(var));
variable_words = strcat(variable_words, ' >');
set(handles.variable_display, 'String', variable_words);
set(handles.variable_display, 'Position', position);
set(handles.variable_display, 'Visible', 'on');
pause(2.0)
stringdisplay = 'Then, subtract from this row';
set(handles.talkbox, 'String', stringdisplay);
position(2) = 500 - (35*6);     %500 pixel starting position; 35 pixel height; 6th row;
set(handles.variable_display, 'position', position);
set(handles.variable_display, 'String', '>');
pause(2.0)
stringdisplay = 'Choose a row to eliminate';
set(handles.talkbox, 'String', stringdisplay);
set(handles.variable_display, 'Visible', 'off');
guidata(hObject, handles);
update(hObject, eventdata, handles);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton7, 'Visible', 'off');
matrix = handles.matrix;
j = handles.col;    %matrix col
i = 7;              %matrix row that client chose to eliminate
var = matrix(i, j)/matrix(j, j);
matrix(i, :) = matrix(i, :) - var*matrix(j, :);
handles.matrix = matrix;
%Controlling display
stringdisplay = strcat('Multiply this row by   ', num2str(var));
set(handles.talkbox, 'String', stringdisplay);
y = 500 - (35*j);      %starting pixel location of the arrow
position = get(handles.variable_display, 'position');
position(2) = y;
variable_words = strcat('x', num2str(var));
variable_words = strcat(variable_words, ' >');
set(handles.variable_display, 'String', variable_words);
set(handles.variable_display, 'Position', position);
set(handles.variable_display, 'Visible', 'on');
pause(2.0)
stringdisplay = 'Then, subtract from this row';
set(handles.talkbox, 'String', stringdisplay);
position(2) = 500 - (35*7);     %500 pixel starting position; 35 pixel height; 7th row;
set(handles.variable_display, 'position', position);
set(handles.variable_display, 'String', '>');
pause(2.0)
stringdisplay = 'Choose a row to eliminate';
set(handles.talkbox, 'String', stringdisplay);
set(handles.variable_display, 'Visible', 'off');
guidata(hObject, handles);
update(hObject, eventdata, handles);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton8, 'Visible', 'off');
matrix = handles.matrix;
j = handles.col;    %matrix col
i = 8;              %matrix row that client chose to eliminate
var = matrix(i, j)/matrix(j, j);
matrix(i, :) = matrix(i, :) - var*matrix(j, :);
handles.matrix = matrix;
%Controlling display
stringdisplay = strcat('Multiply this row by   ', num2str(var));
set(handles.talkbox, 'String', stringdisplay);
y = 500 - (35*j);      %starting pixel location of the arrow
position = get(handles.variable_display, 'position');
position(2) = y;
variable_words = strcat('x', num2str(var));
variable_words = strcat(variable_words, ' >');
set(handles.variable_display, 'String', variable_words);
set(handles.variable_display, 'Position', position);
set(handles.variable_display, 'Visible', 'on');
pause(2.0)
stringdisplay = 'Then, subtract from this row';
set(handles.talkbox, 'String', stringdisplay);
position(2) = 500 - (35*8);     %500 pixel starting position; 35 pixel height; 8th row;
set(handles.variable_display, 'position', position);
set(handles.variable_display, 'String', '>');
pause(2.0)
stringdisplay = 'Choose a row to eliminate';
set(handles.talkbox, 'String', stringdisplay);
set(handles.variable_display, 'Visible', 'off');
guidata(hObject, handles);
update(hObject, eventdata, handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton9, 'Visible', 'off');
matrix = handles.matrix;
j = handles.col;    %matrix col
i = 9;              %matrix row that client chose to eliminate
var = matrix(i, j)/matrix(j, j);
matrix(i, :) = matrix(i, :) - var*matrix(j, :);
handles.matrix = matrix;
%Controlling display
stringdisplay = strcat('Multiply this row by   ', num2str(var));
set(handles.talkbox, 'String', stringdisplay);
y = 500 - (35*j);      %starting pixel location of the arrow
position = get(handles.variable_display, 'position');
position(2) = y;
variable_words = strcat('x', num2str(var));
variable_words = strcat(variable_words, ' >');
set(handles.variable_display, 'String', variable_words);
set(handles.variable_display, 'Position', position);
set(handles.variable_display, 'Visible', 'on');
pause(2.0)
stringdisplay = 'Then, subtract from this row';
set(handles.talkbox, 'String', stringdisplay);
position(2) = 500 - (35*9);     %500 pixel starting position; 35 pixel height; 9th row;
set(handles.variable_display, 'position', position);
set(handles.variable_display, 'String', '>');
pause(2.0)
stringdisplay = 'Choose a row to eliminate';
set(handles.talkbox, 'String', stringdisplay);
set(handles.variable_display, 'Visible', 'off');
guidata(hObject, handles);
update(hObject, eventdata, handles);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton10, 'Visible', 'off');
matrix = handles.matrix;
j = handles.col;    %matrix col
i = 10;              %matrix row that client chose to eliminate
var = matrix(i, j)/matrix(j, j);
matrix(i, :) = matrix(i, :) - var*matrix(j, :);
handles.matrix = matrix;
%Controlling display
stringdisplay = strcat('Multiply this row by   ', num2str(var));
set(handles.talkbox, 'String', stringdisplay);
y = 500 - (35*j);      %starting pixel location of the arrow
position = get(handles.variable_display, 'position');
position(2) = y;
variable_words = strcat('x', num2str(var));
variable_words = strcat(variable_words, ' >');
set(handles.variable_display, 'String', variable_words);
set(handles.variable_display, 'Position', position);
set(handles.variable_display, 'Visible', 'on');
pause(2.0)
stringdisplay = 'Then, subtract from this row';
set(handles.talkbox, 'String', stringdisplay);
position(2) = 500 - (35*10);     %500 pixel starting position; 35 pixel height; 10th row;
set(handles.variable_display, 'position', position);
set(handles.variable_display, 'String', '>');
pause(2.0)
stringdisplay = 'Choose a row to eliminate';
set(handles.talkbox, 'String', stringdisplay);
set(handles.variable_display, 'Visible', 'off');
guidata(hObject, handles);
update(hObject, eventdata, handles);


% --- Executes on selection change in invalid_popup.
function invalid_popup_Callback(hObject, eventdata, handles)
% hObject    handle to invalid_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns invalid_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from invalid_popup


% --- Executes during object creation, after setting all properties.
function invalid_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to invalid_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok_invalidpopup.
function ok_invalidpopup_Callback(hObject, eventdata, handles)
% hObject    handle to ok_invalidpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.invalid_popup, 'Visible', 'off');
set(handles.ok_invalidpopup, 'Visible', 'off');
matrix_setable(hObject, eventdata, handles);
guidata(hObject, handles);


function matrix_setable(hObject, eventdata, handles)
%allow user to set matrix
set(handles.matrixtable, 'ColumnEditable', [true true true true true true true true true true]);
set(handles.matrix_set, 'Enable', 'on');
set(handles.pushbutton1, 'Visible', 'off');
set(handles.pushbutton2, 'Visible', 'off');
set(handles.pushbutton3, 'Visible', 'off');
set(handles.pushbutton4, 'Visible', 'off');
set(handles.pushbutton5, 'Visible', 'off');
set(handles.pushbutton6, 'Visible', 'off');
set(handles.pushbutton7, 'Visible', 'off');
set(handles.pushbutton8, 'Visible', 'off');
set(handles.pushbutton9, 'Visible', 'off');
set(handles.pushbutton10, 'Visible', 'off');
set(handles.ResetButton, 'Enable', 'on');
set(handles.finished_note, 'Visible', 'off');
guidata(hObject, handles);


function matrix_solvable(hObject, eventdata, handles)
%The matrix is ready to be solved
set(handles.matrixtable, 'ColumnEditable', [false false false false false false false false false false]);
set(handles.matrix_set, 'Enable', 'off');
set(handles.pushbutton1, 'Visible', 'off');
set(handles.pushbutton2, 'Visible', 'on');
set(handles.pushbutton3, 'Visible', 'on');
set(handles.pushbutton4, 'Visible', 'on');
set(handles.pushbutton5, 'Visible', 'on');
set(handles.pushbutton6, 'Visible', 'on');
set(handles.pushbutton7, 'Visible', 'on');
set(handles.pushbutton8, 'Visible', 'on');
set(handles.pushbutton9, 'Visible', 'on');
set(handles.pushbutton10, 'Visible', 'on');
row = handles.dimensions(1);
    if row < 10
        set(handles.pushbutton10, 'Visible', 'off');
    end
    if row < 9
        set(handles.pushbutton9, 'Visible', 'off');
    end
    if row < 8
        set(handles.pushbutton8, 'Visible', 'off');
    end
    if row < 7
        set(handles.pushbutton7, 'Visible', 'off');
    end
    if row < 6
        set(handles.pushbutton6, 'Visible', 'off');
    end
    if row < 5
        set(handles.pushbutton5, 'Visible', 'off');
    end
    if row < 4
      set(handles.pushbutton4, 'Visible', 'off');
    end
    if row < 3
        set(handles.pushbutton3, 'Visible', 'off');
    end
    if row < 2
       set(handles.pushbutton2, 'Visible', 'off');
    end
set(handles.ResetButton, 'Enable', 'on');
guidata(hObject, handles);


function freeze_background(hObject, eventdata, handles)
%The background (button and matrix) freezes
set(handles.matrixtable, 'ColumnEditable', [false false false false false false false false false false]);
set(handles.matrix_set, 'Enable', 'off');
set(handles.pushbutton1, 'Visible', 'off');
set(handles.pushbutton2, 'Visible', 'off');
set(handles.pushbutton3, 'Visible', 'off');
set(handles.pushbutton4, 'Visible', 'off');
set(handles.pushbutton5, 'Visible', 'off');
set(handles.pushbutton6, 'Visible', 'off');
set(handles.pushbutton7, 'Visible', 'off');
set(handles.pushbutton8, 'Visible', 'off');
set(handles.pushbutton9, 'Visible', 'off');
set(handles.pushbutton10, 'Visible', 'off');
set(handles.ResetButton, 'Enable', 'off');
set(handles.finished_note, 'Visible', 'off');
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in row_selection.
function row_selection_Callback(hObject, eventdata, handles)
% hObject    handle to row_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns row_selection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from row_selection
handles.board(1) = get(hObject, 'Value');
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function row_selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to row_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in col_selection.
function col_selection_Callback(hObject, eventdata, handles)
% hObject    handle to col_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns col_selection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from col_selection
handles.board(2) = get(hObject, 'Value');
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function col_selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to col_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
table = repmat({''},handles.board(1), handles.board(2));
set(handles.matrixtable, 'data', table);
set(handles.matrixtable, 'Visible', 'on');
set(handles.matrix_set, 'Visible', 'on');
set(handles.ResetButton, 'Visible', 'on');
set(handles.row_selection, 'Visible', 'off');
set(handles.col_selection, 'Visible', 'off');
set(handles.text5, 'Visible', 'off');
set(handles.text6, 'Visible', 'off');
set(handles.start_button, 'Visible', 'off');
xstart = get(handles.matrixtable, 'Position');    %The position of the table
x = xstart(1) + (100*handles.board(2)) + 20;    %pixel location of the buttons
if x > 832    %pixel position of max x of interface
    x = 832;  %pixel position of max x of interface
end
%Setting x axis pixel location for each position
position = get(handles.pushbutton1, 'Position');
position(1) = x;
set(handles.pushbutton1, 'Position', position);
position = get(handles.pushbutton2, 'Position');
position(1) = x;
set(handles.pushbutton2, 'Position', position);
position = get(handles.pushbutton3, 'Position');
position(1) = x;
set(handles.pushbutton3, 'Position', position);
position = get(handles.pushbutton4, 'Position');
position(1) = x;
set(handles.pushbutton4, 'Position', position);
position = get(handles.pushbutton5, 'Position');
position(1) = x;
set(handles.pushbutton5, 'Position', position);
position = get(handles.pushbutton6, 'Position');
position(1) = x;
set(handles.pushbutton6, 'Position', position);
position = get(handles.pushbutton7, 'Position');
position(1) = x;
set(handles.pushbutton7, 'Position', position);
position = get(handles.pushbutton8, 'Position');
position(1) = x;
set(handles.pushbutton8, 'Position', position);
position = get(handles.pushbutton9, 'Position');
position(1) = x;
set(handles.pushbutton9, 'Position', position);
position = get(handles.pushbutton10, 'Position');
position(1) = x;
set(handles.pushbutton10, 'Position', position);
set(handles.pushbutton1, 'Visible', 'off');
set(handles.pushbutton2, 'Visible', 'off');
set(handles.pushbutton3, 'Visible', 'off');
set(handles.pushbutton4, 'Visible', 'off');
set(handles.pushbutton5, 'Visible', 'off');
set(handles.pushbutton6, 'Visible', 'off');
set(handles.pushbutton7, 'Visible', 'off');
set(handles.pushbutton8, 'Visible', 'off');
set(handles.pushbutton9, 'Visible', 'off');
set(handles.pushbutton10, 'Visible', 'off');
position = get(handles.SolutionIndicator, 'Position');
newx = 156 + (100*(handles.board(2)-1));    %156 is pizel starting x position of table
position(1) = newx;
set(handles.SolutionIndicator, 'Position', position);
set(handles.SolutionIndicator, 'Visible', 'on');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function matrixtable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matrixtable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
