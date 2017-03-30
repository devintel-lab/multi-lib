% File name: gui_plot.m
% Created By: Jared Wentz, jjwentz@indiana.edu
%
% -------------------------------------------------------------------------
% 
% This function creates a GUI that allows the user to view and save 
% generated correlation plots; function is called by
% gui_correlation_plots.m
%
% -------------------------------------------------------------------------
%
% Program Flow:
%   1. gui_plot is called when user presses plot button on
%   gui_correlation_plots
%   2. displays all correlation plots using gscatter; user can press arrow
%   buttons to cycle through all plots
%   
% -------------------------------------------------------------------------
%
% This function calls:
%   sub2exp
%   write2csv
%
% -------------------------------------------------------------------------
%
% GUI Handles
%
%   data - input data in n x 3 cell array; 1st column is x-axis
%   data, 2nd column is y-axis data, 3rd is subjects
%
%   xaxis - input x-axis headers
%
%   yaxis - input y-axis headers
%
%   modulo - number of correlation plots
%
%   k - tracks current position in event data
%
%   forward_button - button that allows user to view next
%   correlation plot
%
%   backward_button - button that allows user to view previous
%   correlation plot
%
%   rsquared_textbox - displays coefficient of determination of correlation
%   plot
%
%   saveAll - button that allows user to save all correlation plots in the
%   form of .csv files
%
%   save_plots - button that allows user to save all correlation plots in
%   the form of .png files
%
%   graph - axes that display the correlation plots
%
% -------------------------------------------------------------------------


function varargout = gui_plot(varargin)
% GUI_PLOT MATLAB code for gui_plot.fig
%      GUI_PLOT, by itself, creates a new GUI_PLOT or raises the existing
%      singleton*.
%
%      H = GUI_PLOT returns the handle to a new GUI_PLOT or the handle to
%      the existing singleton*.
%
%      GUI_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PLOT.M with the given input arguments.
%
%      GUI_PLOT('Property','Value',...) creates a new GUI_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_plot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_plot

% Last Modified by GUIDE v2.5 10-Apr-2015 11:50:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_plot_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_plot_OutputFcn, ...
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


% --- Executes just before gui_plot is made visible.
function gui_plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_plot (see VARARGIN)

% Choose default command line output for gui_plot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_plot wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% 

handles.data = varargin{1,1};
handles.xaxis = varargin{1,2};
handles.yaxis = varargin{1,3};
[handles.modulo, ~] = size(handles.data);
handles.k = 1;

guidata(hObject,handles);

if handles.k == handles.modulo
    set(handles.forward_button,'visible','off');
end

set(handles.backward_button, 'visible','off');

make_scatter(hObject, eventdata, handles);
    
% --- Outputs from this function are returned to the command line.
function varargout = gui_plot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in forward_button.
function forward_button_Callback(hObject, eventdata, handles)
% hObject    handle to forward_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.backward_button,'visible','on');

handles.k = handles.k + 1;

make_scatter(hObject, eventdata, handles)

if handles.k == handles.modulo
    set(handles.forward_button,'visible','off');
end

guidata(hObject,handles);

% --- Executes on button press in backward_button.
function backward_button_Callback(hObject, eventdata, handles)
% hObject    handle to backward_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.forward_button,'visible','on');

handles.k = handles.k - 1;

make_scatter(hObject, eventdata, handles)

if handles.k == 1
    set(handles.backward_button,'visible','off');
end

guidata(hObject,handles);

function make_scatter(hObject, eventdata, handles)

if ~isempty(handles.data{handles.k,1})
    gscatter(handles.data{handles.k,1}, handles.data{handles.k,2}, sub2exp(handles.data{handles.k,3}));

    xlabel(char(handles.xaxis{handles.k}))
    ylabel(char(handles.yaxis{handles.k}))
    legend('hide');
    title(horzcat(handles.yaxis{handles.k}, ' vs. ', handles.xaxis{handles.k}));

    for i=1:length(handles.data{handles.k})
        text(handles.data{handles.k,1}(i), handles.data{handles.k,2}(i), num2str(handles.data{handles.k,3}(i)), 'horizontal','left', 'vertical','bottom');
    end

    if ~isempty(handles.data{handles.k,1}) 
        p = LinearModel.fit(handles.data{handles.k,1}, handles.data{handles.k,2}, 'linear');
        set(handles.rsquared_textbox,'String',horzcat('r^2: ', num2str(p.Rsquared.Ordinary))); % ordinary r^2 value
    end
else
    plot(0,0);
    xlabel(handles.xaxis{handles.k});
    ylabel(handles.yaxis{handles.k});
    legend('hide');
    title(horzcat(handles.yaxis{handles.k}, ' vs. ', handles.xaxis{handles.k}));
    set(handles.rsquared_textbox,'String','r^2: 0');
end

guidata(hObject,handles);

% --- Executes on button press in saveAll.
function saveAll_Callback(hObject, eventdata, handles)
% hObject    handle to saveAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    [FileName, PathName] = uiputfile('/scratch/*.csv', 'Save As');
    FileName = strrep(FileName,'.csv','_figure0.csv');

    for i=1:handles.modulo
        x = handles.data{i,1};
        y = handles.data{i,2};
        ex = handles.data{i,3};
        fdata = horzcat(ex,x,y);
    
        FileName = strrep(FileName, horzcat('_figure',num2str(i-1)), horzcat('_figure',num2str(i)));
        Name = fullfile(PathName,FileName);
        %Name = sttrep(Name, '/', '');
        xax = handles.xaxis{i};
        yax = handles.yaxis{i};
        xax = strrep(xax,'\','');
        yax = strrep(yax,'\','');
        headers = sprintf('SubjectID,%s,%s',char(xax), char(yax));
        write2csv(fdata,Name,headers);
    end
catch ME
    h = msgbox(ME.message);
end

guidata(hObject,handles);


function filePath_Callback(hObject, eventdata, handles)
% hObject    handle to filePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filePath as text
%        str2double(get(hObject,'String')) returns contents of filePath as a double


% --- Executes during object creation, after setting all properties.
function filePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, PathName] = uiputfile('*.jpg', 'Save As'); %# <-- dot
Name = fullfile(PathName,FileName);
saveas(handles.graph, Name);

guidata(hObject,handles);

function rsquared_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to rsquared_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rsquared_textbox as text
%        str2double(get(hObject,'String')) returns contents of rsquared_textbox as a double


% --- Executes during object creation, after setting all properties.
function rsquared_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rsquared_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_plots.
function save_plots_Callback(hObject, eventdata, handles)
% hObject    handle to save_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.k = 1;
make_scatter(hObject,eventdata,handles);
[FileName, PathName] = uiputfile('/scratch/*.png', 'Save As'); 
FileName = strrep(FileName,'.png','_figure1.png');
Name = fullfile(PathName,FileName);

F=getframe(handles.graph); %select axes in GUI
figure(); %new figure
image(F.cdata); %show selected axes in new figure
xlabel(handles.xaxis{1});
ylabel(handles.yaxis{1});
title(horzcat(handles.yaxis{handles.k}, ' vs. ', handles.xaxis{handles.k}));
saveas(gcf, Name, 'png'); %save figure
close(gcf); %and close it

for i = 2:handles.modulo
    handles.k = i;
    make_scatter(hObject,eventdata,handles);
    
    FileName = strrep(FileName, horzcat('_figure',num2str(i-1)), horzcat('_figure',num2str(i)));
    Name = fullfile(PathName,FileName);
    F = getframe(handles.graph);
    figure();
    image(F.cdata);
    xax = handles.xaxis{i};
    yax = handles.yaxis{i};
    xax = strrep(xax,'\','');
    yax = strrep(yax,'\','');
    xax = strrep(xax,'_','-');
    yax = strrep(yax,'_','-');
    xlabel(xax);
    ylabel(yax);
    title(horzcat(yax, ' vs. ', xax));
    saveas(gcf,Name,'png');
    close(gcf);
end

set(handles.backward_button,'visible','on');
set(handles.forward_button,'visible','off');




