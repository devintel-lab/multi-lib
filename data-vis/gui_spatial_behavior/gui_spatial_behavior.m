function varargout = gui_spatial_behavior(varargin)
% GUI_SPATIAL_BEHAVIOR MATLAB code for gui_spatial_behavior.fig
%      GUI_SPATIAL_BEHAVIOR, by itself, creates a new GUI_SPATIAL_BEHAVIOR or raises the existing
%      singleton*.
%
%      H = GUI_SPATIAL_BEHAVIOR returns the handle to a new GUI_SPATIAL_BEHAVIOR or the handle to
%      the existing singleton*.
%
%      GUI_SPATIAL_BEHAVIOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SPATIAL_BEHAVIOR.M with the given input arguments.
%
%      GUI_SPATIAL_BEHAVIOR('Property','Value',...) creates a new GUI_SPATIAL_BEHAVIOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_spatial_behavior_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_spatial_behavior_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_spatial_behavior

% Last Modified by GUIDE v2.5 30-Sep-2016 18:05:37


% Gui designed and developed by Ethan Vogelsang with help from Seth Foster
% Concept by Chen Yu
% Version 2 released 7/18/2016
% Most Recent Stable Build: Version 2.3
% ========================================================================
% This program was designed to show sensor data taken from white room
% experiments.
% Directions: 1) Enter a subject ID 2) Search for a cevent variable and
% press the base variable button button. 3) Search for cstream
% variable and select variable 1 button 4) The main plot should display
% colored dots representing interactions. The size of the dot shows the
% duration of the event. The color shows how long the second variable
% lasted during the event of the first variable. Darker green represents a
% longer time while red shows that the 2nd variable did not happen at the
% time of the first variable. The position of the dot is the mean
% position of where the event happened during the actual experiment. 5)
% searching for a second cstream and selecting variable 2 will update the
% plot's rings to show a proportion of how long the second variable lasts.
% 6) Clicking on a point will update the axes on the right side to display
% a frame from the video which shows the interaction.


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_spatial_behavior_OpeningFcn, ...
    'gui_OutputFcn',  @gui_spatial_behavior_OutputFcn, ...
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


% --- Executes just before gui_spatial_behavior is made visible.
function gui_spatial_behavior_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_spatial_behavior (see VARARGIN)
% This creates the 'background' axes
ha = axes('units','normalized','position',[0 0 1 1]);
% Move the background axes to the bottom
uistack(ha,'bottom');
I=imread('http://www.justinmaller.com/img/projects/wallpaper/WP_Meta-2560x1440_00062.jpg');
hi = imagesc(I);
colormap gray
set(ha,'handlevisibility','off','visible','off')

% Choose default command line output for gui_spatial_behavior
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = gui_spatial_behavior_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
subid=handles.edit1.String;
subid=str2num(subid);
handles=load_data_object(subid, handles);
guidata(hObject,handles)


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


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.listbox1.String=[];
subID=str2num(handles.edit1.String);
searchTerm=handles.edit2.String;
handles.listbox1.String=list_variables(subID,searchTerm);
guidata(hObject,handles)


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cevent=handles.listbox1.String{handles.listbox1.Value};
subid=handles.edit1.String;
subid=str2num(subid);
handles=load_cevent_variable(subid, cevent, handles);
obj_data=handles.UserData.Object_Location_Raw;
cevent_data=handles.UserData.Cevent_Raw;
handles=filter_data_object(obj_data,cevent_data,handles);
filtered_data=handles.UserData.Object_Location_Filtered;
handles=object_location_to_meanxy(filtered_data, handles);
position_data=handles.UserData.Object_XY;
handles=plot_scatter_data(position_data, handles);
handles=update_scatter_size(handles);
handles.text9.String=cevent;
guidata(hObject,handles)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cstream=handles.listbox1.String{handles.listbox1.Value};
subid=handles.edit1.String;
subid=str2num(subid);
handles=load_variable2(subid,cstream,handles);
handles=update_plot_variable2(handles);
handles.text10.String=cstream;
guidata(hObject,handles)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cstream=handles.listbox1.String{handles.listbox1.Value};
subid=handles.edit1.String;
subid=str2num(subid);
handles=load_variable3(subid,cstream,handles);
handles=update_plot_variable3(handles);
handles.text11.String=cstream;
guidata(hObject,handles)


%Gets base variable data, can also be used to grab any data for any vars
function [ handles ] = load_data_object(subid, handles)
variables={'cont2_vision_location_obj1_topdown','cont2_vision_location_obj2_topdown','cont2_vision_location_obj3_topdown'};
handles.UserData.Object_Location_Raw=cell(1,3);
for x=1:3
    handles.UserData.Object_Location_Raw{1,x}=get_variable_by_trial_cat(subid,variables{x});
end


%Gets base variable data, can also be used to grab any data for any vars
function [ handles ] = load_cevent_variable(subid, cevent, handles)
handles.UserData.Cevent_Raw=get_variable_by_trial_cat(subid,cevent);


%Filters data to a cell array of just times when an even is happening
function [ handles ] = filter_data_object(obj_data,cevent_data,handles)
handles.UserData.Object_Location_Filtered={};
if ~isempty(cevent_data)
    for x=1:3
        for r=1:size(cevent_data,1)
            mask=mark_ranges(obj_data{x},cevent_data(r,:));
            handles.UserData.Object_Location_Filtered{r,1}=obj_data{x}(mask,:);
        end
    end
end


%Takes the mean of the data from the cell array
function [ handles ] = object_location_to_meanxy(filtered_data, handles)
handles.UserData.Object_XY=zeros(size(filtered_data,1),2);
for x=1:size(filtered_data,1)
    handles.UserData.Object_XY(x,1)=nanmean(filtered_data{x}(:,2));
    handles.UserData.Object_XY(x,2)=nanmean(filtered_data{x}(:,3));
end
handles.UserData.Object_XY(:,2)=240-handles.UserData.Object_XY(:,2);


%Calls scatter on the mean data, plotting each point individually
function [ handles ] = plot_scatter_data(position_data, handles)
cla reset
axes(handles.axes1)
hold on
handles.UserData.Scatter_Data={};
for x=1:size(handles.UserData.Object_XY,1)
    timestamp=(handles.UserData.Object_Location_Filtered{x}(end,1)+handles.UserData.Object_Location_Filtered{x}(1,1))/2;
    handles.UserData.Scatter_Data{x,1}=scatter(handles.UserData.Object_XY(x,1),handles.UserData.Object_XY(x,2),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor', [1 1 1],'LineWidth',1.5);    %(x,y,a,c) a = size, c = color
    subid=handles.edit1.String;
    subid=str2num(subid);
    handles.UserData.Scatter_Data{x}.ButtonDownFcn = {@sayLocation, subid, timestamp, handles};
end
xlim(handles.axes1,[0 320])
ylim(handles.axes1,[0 240])


%Updates points on plot so that size is related to the length of the event
function [ handles ] = update_scatter_size(handles)
for x=1:size(handles.UserData.Object_Location_Filtered)
    tempData=handles.UserData.Object_Location_Filtered{x};
    difference=tempData(size(tempData,1),1)-tempData(1,1);
    handles.UserData.Scatter_Data{x}.SizeData=difference*30+.0001;
end


%Loads the data for variable2, must be cstream
function [ handles ] = load_variable2(subid, cstream, handles)
handles.UserData.Variable2_Raw_Data=get_variable_by_trial_cat(subid, cstream);

%Loads the data for variable3, must be cstream
function [ handles ] = load_variable3(subid, cstream, handles)
handles.UserData.Variable3_Raw_Data=get_variable_by_trial_cat(subid, cstream);


%Updates of the points so that the color represent variable 2
function [ handles ] = update_plot_variable2(handles)
for x=1:size(handles.UserData.Cevent_Raw,1)
    mask=mark_ranges(handles.UserData.Variable2_Raw_Data, handles.UserData.Cevent_Raw(x,:));
    refined_data=handles.UserData.Variable2_Raw_Data(mask,:);
    percentage=sum(refined_data(:,2)==handles.UserData.Cevent_Raw(x,3))/size(refined_data,1);
    if percentage == 0
        HSV=[1 1 1];
    else
        percentage=percentage*.85;
        percentage=percentage+.15;
        HSV=[100/360 percentage 1];
    end
    RGB=hsv2rgb(HSV);
    handles.UserData.Scatter_Data{x}.MarkerFaceColor=RGB;
end


function [ handles ] = update_plot_variable3(handles)
for x=1:size(handles.UserData.Cevent_Raw,1)
    mask=mark_ranges(handles.UserData.Variable3_Raw_Data, handles.UserData.Cevent_Raw(x,:));
    refined_data=handles.UserData.Variable3_Raw_Data(mask,:);
    percentage=sum(refined_data(:,2)==handles.UserData.Cevent_Raw(x,3))/size(refined_data,1);
    if percentage == 0
        HSV=[1 1 1];
    else
        percentage=percentage*.85;
        percentage=percentage+.15;
        HSV=[240/360 percentage 1];
    end
    RGB=hsv2rgb(HSV);
    handles.UserData.Scatter_Data{x}.MarkerEdgeColor=RGB;
    handles.UserData.Scatter_Data{x}.LineWidth=ceil(handles.UserData.Scatter_Data{x}.SizeData*.01+.1);
end


% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox6.
function listbox6_Callback(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function listbox6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%loads the picture of the subject pov
function sayLocation(thingsthatsethtoldmetoputhere, hit, subid, timestamp, handles)
axes(handles.axes2);
perspective=1;
load_frame(subid, timestamp, perspective);
axes(handles.axes3);
perspective=2;
load_frame(subid, timestamp, perspective);


function load_frame(subid, timestamp, camIDs)
framenum = time2frame_num(timestamp, subid);
for c = 1:numel(camIDs);
    path = [get_subject_dir(subid) sprintf('/cam%02d_frames_p/img_%d.jpg', camIDs(c), framenum)];
    im = imread(path);
    image(im);
    axis image; % maintain image size
    set(gca, 'xtick', []);
    set(gca, 'ytick', []);
end


%Demo button, runs the program for a subject id specified and shows data
%for cevent = child inhand and var 2 and 3 = parent and child eye roi
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(str2num(handles.edit1.String))
    handles.edit1.String='7206';
    subid=str2num(handles.edit1.String);
else
    subid=str2num(handles.edit1.String);
end
handles=load_data_object(subid, handles);
cevent='cevent_inhand_child';
handles=load_cevent_variable(subid, cevent, handles);
obj_data=handles.UserData.Object_Location_Raw;
cevent_data=handles.UserData.Cevent_Raw;
handles=filter_data_object(obj_data,cevent_data,handles);
filtered_data=handles.UserData.Object_Location_Filtered;
handles=object_location_to_meanxy(filtered_data, handles);
position_data=handles.UserData.Object_XY;
handles=plot_scatter_data(position_data, handles);
handles=update_scatter_size(handles);
handles.text9.String=cevent;
cstream='cstream_eye_roi_parent';
handles=load_variable2(subid,cstream,handles);
handles=update_plot_variable2(handles);
handles.text10.String=cstream;
cstream='cstream_eye_roi_child';
handles=load_variable3(subid,cstream,handles);
handles=update_plot_variable3(handles);
handles.text11.String=cstream;
guidata(hObject,handles)
