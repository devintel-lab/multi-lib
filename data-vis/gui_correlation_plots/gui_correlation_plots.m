% File Name: gui_correlation_plots.m
% Created By: Jared Wentz, jjwentz@indiana.edu
%
% -------------------------------------------------------------------------
%
% This function creates a GUI that allows the user to generate correlation
% plots between existing events, and custom .csv files. 
%
% -------------------------------------------------------------------------
% To run the GUI, type the following into the command line:
%
% >> gui_correlation_plots
%
% -------------------------------------------------------------------------
%
% Program flow:
% 1. User enters experiment/subject ID's, keyword, and/or args
% 2. Calls list_variables on the experiment/subject ID's and keyword and 
%    displays events in the event listbox
% 3. Displays all .csv files in the multilong_metadata folder in listbox 
%    below
% 4. User selects events and places them in the y-axis listbox
%    and/or the x-axis listbox, and selects the event variables. User can
%    also enter their own custom .csv file and the corresponding column 
%    numbers in the indicated text boxes.
% 5. Plot button pulls data for each event in y-axis and x-axis listbox and 
%    organizes it into a cell array
% 6. gui_plot GUI is called to display correlation plots of the data 
%    contained in the cell array
%
% -------------------------------------------------------------------------
% 
% This function calls:
%   list_subjects
%   list_variables
%   get_age_at_exp
%   subjects
%   get_chunks_v2
%   get_data_type
%   gui_plot
%   get_csv_data_v2
%   
% -------------------------------------------------------------------------
%
% Hard-coded Variables
%
%   fileColumns - global hashmap that keeps track of column numbers for 
%   each file
%
%   fileData - global hashmap that stores .csv file data for each file
%
%   fileHeaders - global hashmap that stores .csv file headers
%
%   multiworkDir - multiwork metadata directory
%
%   multiworkSubjects - array of subjects from experiments 70-73; must 
%   be updated manually to include future experiments
%
%   data - n x 3 cell array of event data where n is the # of x-axis; 1st
%   column is x-axis data, 2nd column is y-axis data, 3rd is subjects
%   
%   events - # of y-axis events
%
%   xaxis - cell array containing x-axis labels
%
%   yaxis - cell array containing y-axis labels
%
% -------------------------------------------------------------------------
%
% Description of GUI Handles
%
%   SubjectID - Edit Text that allows user to refine search based on 
%   experiment and/or subject ID 
%   -- e.g. 34,43
%   
%   DataType - Edit Text that allows user to refine search based on a
%   based on a keyword 
%   -- e.g. cevent 
%   
%   EnterArgs - Edit Text that allows user to refine search based on 
%   arguments for get_chunks_v2
%   -- e.g. cevent_name, cevent_eye_roi_child, cevent_values, [1 2 3]
%               
%   EventList - Listbox that displays the events based on input from
%   SubjectID and DataType
%
%   multilongCSVFiles - Listbox that displays the events for experiments 
%   70-73 from the multilong metadata folder
%
%   CSV_EnterFile - Edit Text that allows user to enter properly formated 
%   .csv file; must contain full file path
%   -- e.g. /scratch/sbf/test.csv
%   
%   ColumnValues - Edit Text that allows user to specify the column numbers 
%   of the .csv file they want to analyze
%   -- e.g. 2,3 would add the 2nd and 3rd column data to 
%   -- NOTE: User can enter .csv file name in CSV_EnterFile, then tab to
%      ColumnValues and enter column numbers, then press enter to add
%      events to multilongCSVFiles. They can also enter .csv file name and
%      press enter, then select the file in multilongCSVFiles and enter the
%      column numbers. 
%
%   YAxisEvents - Listbox that displays the selected y-axis events
%
%   XAxisEvents - Listbox that displays the selected x-axis events
%      
%   x/y_btn - Push Buttons that add events from EventList to X/YAxisEvents
%
%   csv_x/y_btn - Push Buttons that add events from multilongCSVFiles to
%   X/YAxisEvents
%
%   y_event_prop - Radio Button that allows user to select event measure
%   they want to analyze
%
%   y_event_custom - Edit Text that allows user to enter valid event
%   measure
%
%   Generate - Push Button that displays data in EventList and
%   multilongCSVFiles; not visible 
%
%   remove_btn
%   clear_btn
%   plot_btn - Push Button that calls gui_plot
%   exit_btn
%
% -------------------------------------------------------------------------

function varargout = gui_correlation_plots(varargin)
% GUI_CORRELATION_PLOTS MATLAB code for gui_correlation_plots.fig
%      GUI_CORRELATION_PLOTS, by itself, creates a new GUI_CORRELATION_PLOTS or raises the existing
%      singleton*.
%
%      H = GUI_CORRELATION_PLOTS returns the handle to a new GUI_CORRELATION_PLOTS or the handle to
%      the existing singleton*.
%
%      GUI_CORRELATION_PLOTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CORRELATION_PLOTS.M with the given input arguments.
%
%      GUI_CORRELATION_PLOTS('Property','Value',...) creates a new GUI_CORRELATION_PLOTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_correlation_plots_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_correlation_plots_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_correlation_plots

% Last Modified by GUIDE v2.5 04-May-2015 20:43:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_correlation_plots_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_correlation_plots_OutputFcn, ...
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


% --- Executes just before gui_correlation_plots is made visible.
function gui_correlation_plots_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_correlation_plots (see VARARGIN)

% Choose default command line output for gui_correlation_plots
handles.output = hObject;

if ~isempty(varargin)
    handles.exit_on_close = varargin{1};
end

% pull subjects from multiwork experiments
global multiworkSubjects;
a = list_subjects(70);
b = list_subjects(71);
c = list_subjects(72);
d = list_subjects(73);
multiworkSubjects = [a;b;c;d];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_correlation_plots wait for user response (see UIRESUME)
% uiwait(handles.figure1);
uicontrol(handles.SubjectID);


% --- Outputs from this function are returned to the command line.
function varargout = gui_correlation_plots_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Generate.
function Generate_Callback(hObject, eventdata, handles)
% hObject    handle to Generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fileColumns
global fileData
global fileHeaders

fileColumns = containers.Map;
fileData = containers.Map;
fileHeaders = containers.Map;

subjectIDS = get(handles.SubjectID, 'String'); 
keyword = get(handles.DataType, 'String');
set(handles.multilongCSVFiles,'Value',1);
set(handles.multilongCSVFiles,'String','');
set(handles.EventList,'Value',1);
set(handles.EventList,'String','');

subjectIDS = str2num(subjectIDS);

try
    events = list_variables(subjectIDS,keyword);
    set(handles.EventList,'string',events);
    if isempty(events)
        h = msgbox('Event list is empty. Please recheck the subject ID list and/or the keyword');
    else
        multiworkDir = dir('/restore/multiwork/multilong_metadata/*.csv');
        csv_list = cell(length(multiworkDir),1);
        for i = 1:length(multiworkDir)
            csv_list{i} = multiworkDir(i).name;
        end
        set(handles.multilongCSVFiles,'string',csv_list);
    end
catch ME
    h = msgbox(ME.message);
end

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


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function EventList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EventList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function SubjectID_Callback(hObject, eventdata, handles)
% hObject    handle to SubjectID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SubjectID as text
%        str2double(get(hObject,'String')) returns contents of SubjectID as a double

currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13)) %char(13) == enter key
   Generate_Callback(hObject, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function SubjectID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SubjectID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function DataType_Callback(hObject, eventdata, handles)
% hObject    handle to DataType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DataType as text
%        str2double(get(hObject,'String')) returns contents of DataType as a double

currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13)) %char(13) == enter key
   Generate_Callback(hObject, eventdata, handles);
end
       

% --- Executes during object creation, after setting all properties.
function DataType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exit_btn.
function exit_btn_Callback(hObject, eventdata, handles)
% hObject    handle to exit_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_CloseRequestFcn(hObject, eventdata, handles);

% --- Executes on button press in clear_btn.
function clear_btn_Callback(hObject, eventdata, handles)
% hObject    handle to clear_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.SubjectID,'String','');
set(handles.DataType,'String','');
set(handles.EnterArgs,'String','');
set(handles.YAxisEvents,'String', '');
set(handles.XAxisEvents,'String', '');
set(handles.EventList,'Value',1);
set(handles.EventList,'String','');
set(handles.y_event_age,'Value',1);
set(handles.x_event_age,'Value',1);
set(handles.multilongCSVFiles,'Value',1);
set(handles.y_cont_mean,'Value',1);
set(handles.x_cont_mean,'Value',1);
set(handles.multilongCSVFiles,'String','');
set(handles.CSV_EnterFile,'String','');
set(handles.ColumnValues,'String','');
set(handles.x_event_custom,'String','');
set(handles.y_event_custom,'String','');
set(handles.x_cont_custom,'String','');
set(handles.y_cont_custom,'String','');


% --- Executes on button press in remove_btn.
function remove_btn_Callback(hObject, eventdata, handles)
% hObject    handle to remove_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.YAxisEvents,'string','');
set(handles.XAxisEvents,'string','');
set(handles.y_event_age,'Value',1);
set(handles.x_event_age,'Value',1);
set(handles.y_cont_mean,'Value',1);
set(handles.x_cont_mean,'Value',1);
set(handles.x_event_custom,'String','');
set(handles.y_event_custom,'String','');
set(handles.x_cont_custom,'String','');
set(handles.y_cont_custom,'String','');

% --- Executes during object creation, after setting all properties.
function YAxisEvents_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YAxisEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_btn.
function plot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to plot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fileColumns;
global fileData;
global fileHeaders;

h = msgbox('Generating correlation plots...');
edithandle = findobj(h,'Style','pushbutton');
delete(edithandle);

args = struct();
arguments = get(handles.EnterArgs,'String');
if ~isempty(arguments)
    
    arguments = strtrim(arguments);
    arguments = strsplit(arguments,',');
    arguments = arrayfun(@(a) strtrim(a),arguments);
    keys = arguments(1:2:end);
    vals = arguments(2:2:end);
    for i = 1:length(keys)
        if ~isempty(str2num(vals{i}))
            vals{i} = str2num(vals{i});
        end
        args.(keys{i}) = vals{i};
    end
end
    
indEvents = get(handles.YAxisEvents,'string');
depEvents = get(handles.XAxisEvents,'string');
subjectList = str2num(get(handles.SubjectID,'string'));
subjects = [];

% create array of all entered subjects 
for i = 1:length(subjectList)
    if length(num2str(subjectList(i))) > 2
        subjects = vertcat(subjects, subjectList(i));
    else
        subjects = vertcat(subjects, list_subjects(subjectList(i)));
    end
end

xlen = length(depEvents);
if xlen == 0
    xlen = xlen + 1;
end
ylen = length(indEvents);
if ylen == 0
    ylen = ylen + 1;
end
data = cell(ylen*xlen, 3);
xaxis = cell(ylen*xlen,1);
yaxis = cell(ylen*xlen,1);

eventXMeasure = get(get(handles.dep_event_variable,'SelectedObject'),'string');
if strcmp(eventXMeasure,'Custom:')
    eventXMeasure = get(handles.x_event_custom,'String');
end
eventYMeasure = get(get(handles.ind_event_variable,'SelectedObject'),'string');
if strcmp(eventYMeasure,'Custom:')
    eventYMeasure = get(handles.y_event_custom,'String');
end
contXMeasure = get(get(handles.dep_cont_variable,'SelectedObject'),'string');
if strcmp(contXMeasure,'Custom:')
    contXMeasure = get(handles.x_cont_custom,'String');
end
contYMeasure = get(get(handles.ind_cont_variable,'SelectedObject'),'string');
if strcmp(contYMeasure,'Custom:')
    contYMeasure = get(handles.y_cont_custom,'String');
end

xdata = cell(xlen,3);
ydata = cell(ylen,3); 

for i = 1:xlen
    if strcmp(eventXMeasure,'age')
        [x, ~, p] = get_age_at_exp(subjects);
        xsub = subjects(p);
        xlabel = 'Age';
    else
        if isempty(strfind(depEvents{i},'.csv'))
            
            try
                [~,b,c,~] = get_chunks_v2(depEvents{i},subjects,args);
                if strcmp(get_data_type(depEvents{i}), 'cont')
                    measure = contXMeasure;
                else
                    measure = eventXMeasure;
                end
                xsub = unique(b.sub_list);
                logs = arrayfun(@(a) ismember(b.sub_list, a), xsub, 'un', 0);
                xlabel = horzcat(depEvents{i},': ', measure);
                xlabel = strrep(xlabel,'_','\_');
                x = cellfun(@(a) nanmean(c{1}.(measure)(a,:), 1), logs, 'un', 0);
                x = vertcat(x{:});
            catch ME
                h = msgbox(ME.message);
                break;
            end
        else
            try
                f = depEvents{i};
                % we know this file will be of the form column#_filename.csv
                b = strsplit(f,'_');
                csvData = fileData(char(b(2)));
                col = fileColumns(f);
            
                if isKey(fileHeaders,char(b(2)))
                    heads = fileHeaders(char(b(2)));
                    xlabel = strcat(char(b(2)), {' '}, strjoin(heads(:,col)'));
                    xlabel = strrep(xlabel, ' ', '-');
                else
                    xlabel = strrep(f,'_','-');
                end
            
                csvData = help(csvData, col);
                x = csvData(:,2);
                xsub = csvData(:,1);
            catch ME
                h = msgbox(ME.message);
            end
        end
    end
    xdata{i,1} = x;
    xdata{i,2} = xsub;
    xdata{i,3} = xlabel;
end

for j = 1:ylen
    if strcmp(eventYMeasure,'age')
        [y, ~, p] = get_age_at_exp(subjects);
        ysub = subjects(p);
        ylabel = 'Age';
    else
        if isempty(strfind(indEvents{j},'.csv'))
            try
                if strcmp(get_data_type(indEvents{j}),'cont')
                    measure = contYMeasure;
                else
                    measure = eventYMeasure;
                end
                [~,b,c,~] = get_chunks_v2(indEvents{j},subjects,args);
                ysub = unique(b.sub_list);
                logs = arrayfun(@(a) ismember(b.sub_list, a), ysub, 'un', 0);
                ylabel = horzcat(indEvents{j},': ', measure);
                ylabel = strrep(ylabel,'_','\_');
                y = cellfun(@(a) nanmean(c{1}.(measure)(a,:), 1), logs, 'un', 0);
                y = vertcat(y{:});
            catch ME
                h = msgbox(ME.message);
            end
        else
            try
                f = indEvents{j};
                b = strsplit(f,'_');
                csvData = fileData(char(b(2)));
                col = fileColumns(f);
            
                if isKey(fileHeaders,char(b(2)))
                    heads = fileHeaders(char(b(2)));
                    ylabel = strcat(char(b(2)), {' '}, strjoin(heads(:,col)'));
                    ylabel = strrep(ylabel, ' ', '-');
                else
                    ylabel = strrep(f,'_','-');
                end
        
                csvData = help(csvData,col);
                y = csvData(:,2);
                ysub = csvData(:,1);
            catch ME
                h = msgbox(ME.message);
                break;
            end
        end
    end
    ydata{j,1} = y;
    ydata{j,2} = ysub;
    ydata{j,3} = ylabel;
end

k = 1;

for i = 1:xlen
    x = xdata{i,1};
    xsub = xdata{i,2};
    xlabel = xdata{i,3};
    for j = 1:ylen
        y = ydata{j,1};
        ysub = ydata{j,2};
        ylabel = ydata{j,3};
        % here we filter the data based upon common subjects; we only plot 
        % two events that have data for the same subjects
        xlog = ismember(xsub,ysub);
        ylog = ismember(ysub,xsub);
        data{k,1} = x(xlog);
        data{k,2} = y(ylog);
        data{k,3} = ysub(ylog);
        xaxis{k} = xlabel;
        yaxis{k} = ylabel;
        k = k+1;
    end
end

if exist('h','var')
    delete(h);
    clear('h');
end

gui_plot(data, xaxis, yaxis);

function D = help(csv_data,col)
global f;
global multiworkSubjects;

f = containers.Map;
% check if the .csv file is a multilong file; help2 checks for NaN data
if csv_data(1,1) < 100
   arrayfun(@(x,y) help2(x,y), csv_data(:,1), csv_data(:,col));
   M = [];
   for i = 1:length(multiworkSubjects)
       z = num2str(mod(multiworkSubjects(i), 100));
       if isKey(f,z)
           M = vertcat(M,[multiworkSubjects(i),f(z)]);
       end
   end
   D = M;
else
   missing = arrayfun(@(a) ~isnan(a),csv_data(:,col));
   csv_data = [csv_data(missing,1), csv_data(missing,col)];
   D = csv_data;
end

function help2(a,b)
global f
if isnumeric(b)
    f(num2str(a)) = b;
end

% --- Executes during object creation, after setting all properties.
function XAxisEvents_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XAxisEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in y_btn.
function y_btn_Callback(hObject, eventdata, handles)
% hObject    handle to y_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
allEvents = get(handles.EventList, 'string');
if ~isempty(allEvents)
    selectedIndexes = get(handles.EventList, 'value');
    allEvents = allEvents(selectedIndexes);
    alreadySelected = get(handles.YAxisEvents, 'string');
    repeats = ~ismember(allEvents,alreadySelected);
    events = vertcat(alreadySelected, allEvents(repeats));
    set(handles.YAxisEvents,'string',events);
    set(handles.y_event_prop,'Value',1);
    
end
    

% --- Executes on button press in x_btn.
function x_btn_Callback(hObject, eventdata, handles)
% hObject    handle to x_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
allEvents = get(handles.EventList, 'string');
if ~isempty(allEvents)
    selectedIndexes = get(handles.EventList, 'value');
    allEvents = allEvents(selectedIndexes);
    alreadySelected = get(handles.XAxisEvents, 'string');
    repeats = ~ismember(allEvents,alreadySelected);
    events = vertcat(alreadySelected, allEvents(repeats));
    set(handles.XAxisEvents,'string',events);
    set(handles.x_event_prop,'Value',1);
end


% --- Executes on selection change in multilongCSVFiles.
function multilongCSVFiles_Callback(hObject, eventdata, handles)
% hObject    handle to multilongCSVFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns multilongCSVFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from multilongCSVFiles


% --- Executes during object creation, after setting all properties.
function multilongCSVFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multilongCSVFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CSV_EnterFile_Callback(hObject, eventdata, handles)
% hObject    handle to CSV_EnterFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CSV_EnterFile as text
%        str2double(get(hObject,'String')) returns contents of CSV_EnterFile as a double

currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13)) %char(13) == enter key
   file = get(handles.CSV_EnterFile,'String');
   % star indicates user input file
   f = horzcat('*', file);
   csv_events = get(handles.multilongCSVFiles,'String');
   csv_events = vertcat(csv_events,f);
   set(handles.multilongCSVFiles,'String',csv_events);
   set(handles.CSV_EnterFile,'String',''); 
end


% --- Executes during object creation, after setting all properties.
function CSV_EnterFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CSV_EnterFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over CSV_EnterFile.
function CSV_EnterFile_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to CSV_EnterFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.CSV_EnterFile,'string','');


% --- Executes on button press in csv_y_btn.
function csv_y_btn_Callback(hObject, eventdata, handles)
% hObject    handle to csv_y_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
allEvents = get(handles.multilongCSVFiles,'string');
if ~isempty(allEvents)
    selectedIndexes = get(handles.multilongCSVFiles,'value');
    allEvents = allEvents(selectedIndexes);
    alreadySelected = get(handles.YAxisEvents,'string');
    repeats = ~ismember(allEvents,alreadySelected);
    events = vertcat(alreadySelected, allEvents(repeats));
    set(handles.YAxisEvents,'string',events);
    set(handles.y_event_prop,'Value',1);
end

% --- Executes on button press in csv_x_btn.
function csv_x_btn_Callback(hObject, eventdata, handles)
% hObject    handle to csv_x_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
allEvents = get(handles.multilongCSVFiles,'string');
if ~isempty(allEvents)
    selectedIndexes = get(handles.multilongCSVFiles,'value');
    allEvents = allEvents(selectedIndexes);
    alreadySelected = get(handles.XAxisEvents,'string');
    repeats = ~ismember(allEvents,alreadySelected);
    events = vertcat(alreadySelected, allEvents(repeats));
    set(handles.XAxisEvents,'string',events);
    set(handles.x_event_prop,'Value',1);
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes on selection change in EventList.
function EventList_Callback(hObject, eventdata, handles)
% hObject    handle to EventList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EventList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EventList


% --- Executes on key press with focus on edit1 and none of its controls.
function edit1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in YAxisEvents.
function YAxisEvents_Callback(hObject, eventdata, handles)
% hObject    handle to YAxisEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns YAxisEvents contents as cell array
%        contents{get(hObject,'Value')} returns selected item from YAxisEvents


% --- Executes on button press in cbAge.
function cbAge_Callback(hObject, eventdata, handles)
% hObject    handle to cbAge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbAge


% --- Executes on selection change in XAxisEvents.
function XAxisEvents_Callback(hObject, eventdata, handles)
% hObject    handle to XAxisEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns XAxisEvents contents as cell array
%        contents{get(hObject,'Value')} returns selected item from XAxisEvents


function ColumnValues_Callback(hObject, eventdata, handles)
% hObject    handle to ColumnValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ColumnValues as text
%        str2double(get(hObject,'String')) returns contents of ColumnValues as a double

global fileColumns;
global fileData;
global fileHeaders;

currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13))
   file = get(handles.CSV_EnterFile,'String');
   columns = get(handles.ColumnValues,'String');
   columns = str2num(columns);
   if ~isempty(columns)    
       if ~isempty(file)
           csvEvents = get(handles.multilongCSVFiles,'String');
           csvEvents = vertcat(csvEvents,strcat('*',file));
           [a,b] = get_csv_data_v2(char(file));
           % here a are the data and b are the headers 
           fileData(file) = a;
           if ~isempty(b)
               b = arrayfun(@(x) strtrim(x), b);
               fileHeaders(file) = b;
           end
           for i = 1:length(columns)
               f = strcat('column',num2str(columns(i)),'_', file);
               csvEvents = vertcat(csvEvents,f);
               set(handles.multilongCSVFiles,'String',csvEvents);
               fileColumns(f) = columns(i);
           end
       else
           selected = get(handles.multilongCSVFiles,'Value');
           csvEvents = get(handles.multilongCSVFiles,'String');
           selected = csvEvents(selected);
           for i = 1:length(selected)
               file = char(selected(i));
               if strfind(file,'*')
                  file = file(2:end);
                  p = file;
               else
                  p = strcat('/restore/multiwork/multilong_metadata/',file);
               end
               [a,b] = get_csv_data_v2(p);
               fileData(file) = a;
               if ~isempty(b)
                   b = arrayfun(@(x) strtrim(x), b);
                   fileHeaders(file) = b;
               end
               for j = 1:length(columns)
                   if strfind(file,'*')
                       f = strcat('column',num2str(columns(j)),'_',file(2:end));
                   else
                       f = strcat('column',num2str(columns(j)),'_',file);
                   end
                   csvEvents = vertcat(csvEvents,f);
                   set(handles.multilongCSVFiles,'String',csvEvents);
                   fileColumns(char(f)) = columns(i);
               end
           end 
       end
   end
   set(handles.CSV_EnterFile,'String','');
   set(handles.ColumnValues,'String','');
end
   

% --- Executes during object creation, after setting all properties.
function ColumnValues_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ColumnValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in view_csv_btn.
function view_csv_btn_Callback(hObject, eventdata, handles)
% hObject    handle to view_csv_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = get(handles.CSV_EnterFile,'String');
if ~isempty(file)
    open(file);
end
    


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
if isfield(handles,'exit_on_close')
    if handles.exit_on_close == 1
        exit;
    end
else
    clear all;
    close all;
end



function EnterArgs_Callback(hObject, eventdata, handles)
% hObject    handle to EnterArgs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EnterArgs as text
%        str2double(get(hObject,'String')) returns contents of EnterArgs as a double
currChar = get(handles.figure1,'CurrentCharacter');
if isequal(currChar,char(13)) %char(13) == enter key
   Generate_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function EnterArgs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EnterArgs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_cont_custom_Callback(hObject, eventdata, handles)
% hObject    handle to x_cont_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_cont_custom as text
%        str2double(get(hObject,'String')) returns contents of x_cont_custom as a double


% --- Executes during object creation, after setting all properties.
function x_cont_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_cont_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_cont_custom_Callback(hObject, eventdata, handles)
% hObject    handle to y_cont_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_cont_custom as text
%        str2double(get(hObject,'String')) returns contents of y_cont_custom as a double


% --- Executes during object creation, after setting all properties.
function y_cont_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_cont_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_event_custom_Callback(hObject, eventdata, handles)
% hObject    handle to x_event_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_event_custom as text
%        str2double(get(hObject,'String')) returns contents of x_event_custom as a double


% --- Executes during object creation, after setting all properties.
function x_event_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_event_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_event_custom_Callback(hObject, eventdata, handles)
% hObject    handle to y_event_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_event_custom as text
%        str2double(get(hObject,'String')) returns contents of y_event_custom as a double


% --- Executes during object creation, after setting all properties.
function y_event_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_event_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in help_btn1.
function help_btn1_Callback(hObject, eventdata, handles)
% hObject    handle to help_btn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure();
[I,map] = imread('/scratch/jjwentz/Help1.png','png');
imshow(I,map)

% --- Executes on button press in help_btn2.
function help_btn2_Callback(hObject, eventdata, handles)
% hObject    handle to help_btn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure()
[I,map] = imread('/scratch/jjwentz/Help2.png','png');
imshow(I,map)
