function varargout = label_hands(varargin)
% LABEL_HANDS MATLAB code for label_hands.fig
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @label_hands_OpeningFcn, ...
                       'gui_OutputFcn',  @label_hands_OutputFcn, ...
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


% --- Executes just before label_hands is made visible.
function label_hands_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to label_hands (see VARARGIN)

    % Choose default command line output for label_hands
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes label_hands wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = label_hands_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;


% --- Executes on button press in yourLEft.
function yourLeft_Callback(hObject, eventdata, handles)
% hObject    handle to yourLEft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    h = imrect(handles.frame);
    fcn = makeConstrainToRectFcn('imrect', get(handles.frame, 'Xlim'), get(handles.frame, 'Ylim'));
    setPositionConstraintFcn(h,fcn);
    setResizable(h, false);
    setColor(h, 'red');
    box = xywh2xyxy(h.getPosition);
    box = truncate_box_to_img_boundaries(box, handles);

    index = getappdata(handles.frame, 'framenum');
    GT = getappdata(handles.frame, 'GT');
    frame_nr = get_frame_number(handles);

    GT.yleft(index, :) = [frame_nr box];
    setappdata(handles.frame, 'GT', GT);
    

% --- Executes on button press in yourRight.
function yourRight_Callback(hObject, eventdata, handles)
% hObject    handle to yourRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    h = imrect(handles.frame);
    fcn = makeConstrainToRectFcn('imrect', get(handles.frame, 'Xlim'), get(handles.frame, 'Ylim'));
    setPositionConstraintFcn(h,fcn);
    setResizable(h, false);
    setColor(h, 'green');
    box = xywh2xyxy(h.getPosition);
    box = truncate_box_to_img_boundaries(box, handles);

    index = getappdata(handles.frame, 'framenum');
    GT = getappdata(handles.frame, 'GT');
    frame_nr = get_frame_number(handles);

    GT.yright(index, :) = [frame_nr box];
    setappdata(handles.frame, 'GT', GT);

    
% --- Executes on button press in myLeft.
function myLeft_Callback(hObject, eventdata, handles)
% hObject    handle to myLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    h = imrect(handles.frame);
    fcn = makeConstrainToRectFcn('imrect', get(handles.frame, 'Xlim'), get(handles.frame, 'Ylim'));
    setPositionConstraintFcn(h,fcn);
    setResizable(h, false);
    setColor(h, 'blue');
    box = xywh2xyxy(h.getPosition);
    box = truncate_box_to_img_boundaries(box, handles);

    index = getappdata(handles.frame, 'framenum');
    GT = getappdata(handles.frame, 'GT');
    frame_nr = get_frame_number(handles);

    GT.mleft(index, :) = [frame_nr box];
    setappdata(handles.frame, 'GT', GT);

% --- Executes on button press in myRight.
function myRight_Callback(hObject, eventdata, handles)
% hObject    handle to myRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    h = imrect(handles.frame);
    fcn = makeConstrainToRectFcn('imrect', get(handles.frame, 'Xlim'), get(handles.frame, 'Ylim'));
    setPositionConstraintFcn(h,fcn);
    setResizable(h, false);
    setColor(h, 'yellow');
    box = xywh2xyxy(h.getPosition);
    box = truncate_box_to_img_boundaries(box, handles);

    index = getappdata(handles.frame, 'framenum');
    GT = getappdata(handles.frame, 'GT');
    frame_nr = get_frame_number(handles);

    GT.mright(index, :) = [frame_nr box];
    setappdata(handles.frame, 'GT', GT);

% --- Executes on button press in head.
function head_Callback(hObject, eventdata, handles)
% hObject    handle to head (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    h = imrect(handles.frame);
    fcn = makeConstrainToRectFcn('imrect', get(handles.frame, 'Xlim'), get(handles.frame, 'Ylim'));
    setPositionConstraintFcn(h,fcn);
    setResizable(h, false);
    setColor(h, 'cyan');
    box = xywh2xyxy(h.getPosition);
    box = truncate_box_to_img_boundaries(box, handles);

    index = getappdata(handles.frame, 'framenum');
    GT = getappdata(handles.frame, 'GT');
    frame_nr = get_frame_number(handles);

    GT.head(index, :) = [frame_nr box];
    setappdata(handles.frame, 'GT', GT);

    
% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % read image list from dir
    data_dir = uigetdir('/cantor/space/sbambach/');
    files = dir([data_dir '/*.jpg']);
    file_names = {};
    for f = 1:numel(files)
        file_names = [file_names, {files(f).name}];
    end
    file_names = sort_nat(file_names);
    num_frames = size(file_names, 2);

    set(handles.frame_info,'String',['Frame 1/' num2str(num_frames) ' (' file_names{1} ')']);
    set(handles.editNumber,'String', num2str(1));

    index = 1;
    setappdata(handles.frame, 'names', file_names);
    setappdata(handles.frame, 'framenum', index);
    setappdata(handles.frame, 'maxframes', num_frames);
    setappdata(handles.frame, 'data_dir', data_dir);
    trial_number = num2str(data_dir(end));
    setappdata(handles.frame, 'trial_number', trial_number);

    if exist([data_dir '/../gt_tr' num2str(trial_number) '.mat'], 'file') == 2
        load([data_dir '/../gt_tr' num2str(trial_number) '.mat']); %polygons
        assignin('base','GT', GT);
        setappdata(handles.frame, 'GT', GT);
        %show_existing_polygons(handles);
        %show_existing_masks(handles, img);
        %img = overlay_existing_masks(img, polygons, index, 0.33);
        render_image_with_boxes(handles);
        %imshow(img);
    else
        % create struct to hold GT coordinates
        GT = struct('head', -1*ones(num_frames, 5), 'mleft', -1*ones(num_frames, 5),'mright', -1*ones(num_frames, 5), 'yleft', -1*ones(num_frames, 5), 'yright', -1*ones(num_frames, 5));

        GT.head(:,1) = get_all_frame_numbers(handles);
        GT.mleft(:,1) = get_all_frame_numbers(handles);
        GT.mright(:,1) = get_all_frame_numbers(handles);
        GT.yleft(:,1) = get_all_frame_numbers(handles);
        GT.yright(:,1) = get_all_frame_numbers(handles);

        assignin('base','GT', GT);
        setappdata(handles.frame, 'GT', GT);        
    end

    render_image_with_boxes(handles);
    
function img = overlay_existing_masks(img, polygons, index, opacity)
    if nargin < 4
        opacity = 0.33;
    end
    %index = getappdata(handles.frame, 'framenum');
    %polygons = getappdata(handles.frame, 'polygons');
    if index <= length(polygons)
        if ~isempty(polygons(index).yourright)
            shape = reshapeAreaCoords(polygons(index).yourright);
            img = insertShape(img, 'FilledPolygon', shape, 'Color', {'green'}, 'Opacity', opacity);
        end
        if ~isempty(polygons(index).yourleft)
            shape = reshapeAreaCoords(polygons(index).yourleft);
            img = insertShape(img, 'FilledPolygon', shape, 'Color', {'red'}, 'Opacity', opacity);
        end
        if ~isempty(polygons(index).myright)
            shape = reshapeAreaCoords(polygons(index).myright);
            img = insertShape(img, 'FilledPolygon', shape, 'Color', {'yellow'}, 'Opacity', opacity);
        end
        if ~isempty(polygons(index).myleft)
            shape = reshapeAreaCoords(polygons(index).myleft);
            img = insertShape(img, 'FilledPolygon', shape, 'Color', {'blue'}, 'Opacity', opacity);
        end
        %imshow(img);
    end
    
function shape2 = reshapeAreaCoords(shape)
    shape2 = zeros(1, 2*length(shape));
    shape2(1:2:end) = shape(:,1)';
    shape2(2:2:end) = shape(:,2)';
        
    
% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    index = getappdata(handles.frame, 'framenum');
    data_dir = getappdata(handles.frame, 'data_dir');
    file_names = getappdata(handles.frame, 'names');
    num_frames = getappdata(handles.frame, 'maxframes');

    % get most up to date masks and update .mat file
%     masks = getappdata(handles.frame, 'masks');
%     assignin('base','masks', masks);
%     save([data_dir '/masks.mat'], 'masks');
%     % write a png containing the mask for the current frame
%     mask_name = [data_dir '/' strrep(file_names{index}, '.jpg', '.png')];
%     imwrite(masks(:,:,:, index), mask_name);

    % get most up to date polygons and update .mat file
    GT = getappdata(handles.frame, 'GT');
    trial_number = getappdata(handles.frame, 'trial_number');
    assignin('base','GT', GT);
    save([data_dir '/../gt_tr' trial_number '.mat'], 'GT');

    if index < getappdata(handles.frame, 'maxframes')
        index = index + 1;
        setappdata(handles.frame, 'framenum', index);
        set(handles.frame_info,'String',['Frame ' num2str(index) '/' num2str(num_frames)  ' (' file_names{index} ')']);
        set(handles.editNumber,'String', num2str(index));
        render_image_with_boxes(handles)
    end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

    % disp(eventdata.Key);

    switch eventdata.Key
        case 'q'
            head_Callback(hObject, eventdata, handles);
        case 'w'
            yourLeft_Callback(hObject, eventdata, handles);
        case 'e'
            yourRight_Callback(hObject, eventdata, handles);
        case 'r'
            myLeft_Callback(hObject, eventdata, handles);
        case 't'
            myRight_Callback(hObject, eventdata, handles);
        case 'rightarrow'
            next_Callback(hObject, eventdata, handles);
        case 'leftarrow'
            prev_Callback(hObject, eventdata, handles);

    end

    
% --- Executes on button press in prev.
function prev_Callback(hObject, eventdata, handles)
% hObject    handle to prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    index = getappdata(handles.frame, 'framenum');
    data_dir = getappdata(handles.frame, 'data_dir');
    file_names = getappdata(handles.frame, 'names');
    num_frames = getappdata(handles.frame, 'maxframes');

    % get most up to date polygons and update .mat file
    GT = getappdata(handles.frame, 'GT');
    trial_number = getappdata(handles.frame, 'trial_number');
    assignin('base','GT', GT);
    save([data_dir '/../gt_tr' trial_number '.mat'], 'GT');

    if index > 1
        index = index - 1;
        setappdata(handles.frame, 'framenum', index);
        set(handles.frame_info,'String',['Frame ' num2str(index) '/' num2str(num_frames)  ' (' file_names{index} ')']);
        set(handles.editNumber,'String', num2str(index));
        render_image_with_boxes(handles);
    end


% --- Executes on button press in clearYL.
function clearYL_Callback(hObject, eventdata, handles)
% hObject    handle to clearYL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    data_dir = getappdata(handles.frame, 'data_dir');
    file_names = getappdata(handles.frame, 'names');
    GT = getappdata(handles.frame, 'GT');
    index = getappdata(handles.frame, 'framenum');
    
    GT.yleft(index, 2:5) = [-1 -1 -1 -1];
    setappdata(handles.frame, 'GT', GT);

    render_image_with_boxes(handles);
    


% --- Executes on button press in clearYR.
function clearYR_Callback(hObject, eventdata, handles)
% hObject    handle to clearYR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    data_dir = getappdata(handles.frame, 'data_dir');
    file_names = getappdata(handles.frame, 'names');
    GT = getappdata(handles.frame, 'GT');
    index = getappdata(handles.frame, 'framenum');
    
    GT.yright(index, 2:5) = [-1 -1 -1 -1];
    setappdata(handles.frame, 'GT', GT);

    render_image_with_boxes(handles);


% --- Executes on button press in clearML.
function clearML_Callback(hObject, eventdata, handles)
% hObject    handle to clearML (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    data_dir = getappdata(handles.frame, 'data_dir');
    file_names = getappdata(handles.frame, 'names');
    GT = getappdata(handles.frame, 'GT');
    index = getappdata(handles.frame, 'framenum');
    
    GT.mleft(index, 2:5) = [-1 -1 -1 -1];
    setappdata(handles.frame, 'GT', GT);

    render_image_with_boxes(handles);


% --- Executes on button press in clearMR.
function clearMR_Callback(hObject, eventdata, handles)
% hObject    handle to clearMR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    data_dir = getappdata(handles.frame, 'data_dir');
    file_names = getappdata(handles.frame, 'names');
    GT = getappdata(handles.frame, 'GT');
    index = getappdata(handles.frame, 'framenum');
    
    GT.mright(index, 2:5) = [-1 -1 -1 -1];
    setappdata(handles.frame, 'GT', GT);

    render_image_with_boxes(handles);



function editNumber_Callback(hObject, eventdata, handles)
% hObject    handle to editNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNumber as text
%        str2double(get(hObject,'String')) returns contents of editNumber as a double

    index = str2double(get(hObject,'String'));
    num_frames = getappdata(handles.frame, 'maxframes');
    
    if isnumeric(index) && ~isempty(num_frames) && index >= 1 && index <= num_frames

        %index = getappdata(handles.frame, 'framenum');
        data_dir = getappdata(handles.frame, 'data_dir');
        file_names = getappdata(handles.frame, 'names');
        num_frames = getappdata(handles.frame, 'maxframes');

        % get most up to date polygons and update .mat file
        GT = getappdata(handles.frame, 'GT');
        trial_number = getappdata(handles.frame, 'trial_number');
        assignin('base','GT', GT);
        save([data_dir '/../gt_tr' trial_number '.mat'], 'GT');

        setappdata(handles.frame, 'framenum', index);
        set(handles.frame_info,'String',['Frame ' num2str(index) '/' num2str(num_frames)  ' (' file_names{index} ')']);
        render_image_with_boxes(handles);

    end


% --- Executes during object creation, after setting all properties.
function editNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    data_dir = getappdata(handles.frame, 'data_dir');
    file_names = getappdata(handles.frame, 'names');
    GT = getappdata(handles.frame, 'GT');
    index = getappdata(handles.frame, 'framenum');
    
    GT.head(index, 2:5) = [-1 -1 -1 -1];
    setappdata(handles.frame, 'GT', GT);

    render_image_with_boxes(handles);



function [] = render_image_with_boxes(handles)


    file_names = getappdata(handles.frame, 'names');
    index = getappdata(handles.frame, 'framenum');
    data_dir = getappdata(handles.frame, 'data_dir');
    GT = getappdata(handles.frame, 'GT');

    img = imread([data_dir,'/' file_names{index}]);
    img_size = size(img);
    setappdata(handles.frame, 'img_size', img_size);
    %imshow(img);

    % show image
    imshow(img, 'Parent', handles.frame);
    
    % overlay boxes
    if GT.head(index, 2) >= 0
        pos = xyxy2xywh(GT.head(index, 2:5));
        color = [0 1 1];
        rectangle('Position', pos,...
              'LineWidth',2,...
              'EdgeColor', color, ...
              'LineStyle','-', 'Parent', handles.frame);
    end
    if GT.mleft(index, 2) >= 0
        pos = xyxy2xywh(GT.mleft(index, 2:5));
        color = [0 0 1];
        rectangle('Position', pos,...
              'LineWidth',2,...
              'EdgeColor', color, ...
              'LineStyle','-', 'Parent', handles.frame);
    end
    if GT.mright(index, 2) >= 0
    pos = xyxy2xywh(GT.mright(index, 2:5));
    color = [1 1 0];
    rectangle('Position', pos,...
          'LineWidth',2,...
          'EdgeColor', color, ...
          'LineStyle','-', 'Parent', handles.frame);
    end
    if GT.yright(index, 2) >= 0
    pos = xyxy2xywh(GT.yright(index, 2:5));
    color = [0 1 0];
    rectangle('Position', pos,...
          'LineWidth',2,...
          'EdgeColor', color, ...
          'LineStyle','-', 'Parent', handles.frame);
    end
    if GT.yleft(index, 2) >= 0
    pos = xyxy2xywh(GT.yleft(index, 2:5));
    color = [1 0 0];
    rectangle('Position', pos,...
          'LineWidth',2,...
          'EdgeColor', color, ...
          'LineStyle','-', 'Parent', handles.frame);
    end
        

function box = truncate_box_to_img_boundaries(box, handles)
    box = round(box);
    % assumes xyxy coords
    img_size = getappdata(handles.frame, 'img_size');
    n_rows = img_size(1);
    n_cols = img_size(2);
    box(1) = max(1, box(1));
    box(2) = max(1, box(2));
    box(3) = min(n_cols, box(3));
    box(4) = min(n_rows, box(4));

function box = xyxy2xywh(box)
    box(3) = box(3)-box(1)+1;
    box(4) = box(4)-box(2)+1;

function box = xywh2xyxy(box)
    box(3) = box(1)+box(3)-1;
    box(4) = box(2)+box(4)-1;

function frame_nr = get_frame_number(handles)
    file_names = getappdata(handles.frame, 'names');
    index = getappdata(handles.frame, 'framenum');
    file = file_names{index};
    frame_nr = strrep(file, 'img_', '');
    frame_nr = strrep(frame_nr, '.jpg', '');
    frame_nr = str2num(frame_nr);

function frame_numbers = get_all_frame_numbers(handles)
    file_names = getappdata(handles.frame, 'names');
    frame_numbers = zeros(length(file_names), 1);
    for f = 1:length(frame_numbers)
        file = file_names{f};
        frame_nr = strrep(file, 'img_', '');
        frame_nr = strrep(frame_nr, '.jpg', '');
        frame_numbers(f) = str2num(frame_nr);
    end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
exit();
