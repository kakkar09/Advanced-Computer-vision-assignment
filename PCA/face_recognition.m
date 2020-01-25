%% Meldick Reimmer, Danie Sonizara and Selma Boudissa
% Applied Maths project
% PCA - Face recognition
%Date: 15/01/18


function varargout = face_recognition(varargin)
% FACE_RECOGNITION MATLAB code for face_recognition.fig
%      FACE_RECOGNITION, by itself, creates a new FACE_RECOGNITION or raises the existing
%      singleton*.
%
%      H = FACE_RECOGNITION returns the handle to a new FACE_RECOGNITION or the handle to
%      the existing singleton*.
%
%      FACE_RECOGNITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACE_RECOGNITION.M with the given input arguments.
%
%      FACE_RECOGNITION('Property','Value',...) creates a new FACE_RECOGNITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before face_recognition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to face_recognition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help face_recognition

% Last Modified by GUIDE v2.5 15-Jan-2018 01:47:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @face_recognition_OpeningFcn, ...
                   'gui_OutputFcn',  @face_recognition_OutputFcn, ...
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


% --- Executes just before face_recognition is made visible.
function face_recognition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to face_recognition (see VARARGIN)

% Choose default command line output for face_recognition
handles.output = hObject;

% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('wall.jpg'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = face_recognition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% read image to be recognize
global im;
[filename, pathname] = uigetfile({'*.jpg'},'choose photo');
str = [pathname, filename];
im = imread(str);
axes( handles.axes1);
imshow(im);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im
global reference
global W
global imgmean
global col_of_data
global pathname
global img_path_list


im = double(im(:));
objectone = W'*(im - imgmean);
distance = 100000000;


for k = 1:col_of_data
    temp = norm(objectone - reference(:,k));
    if(distance>temp)
        aimone = k;
        distance = temp;
        aimpath = strcat(pathname, '/', img_path_list(aimone).name);
        axes( handles.axes2 )
        imshow(aimpath)
    end
end




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global reference
global W
global imgmean
global col_of_data
global pathname
global img_path_list


pathname = uigetdir;
img_path_list = dir(strcat(pathname,'\*.jpg'));
img_num = length(img_path_list);
imagedata = [];
if img_num >0
    for j = 1:img_num
        img_name = img_path_list(j).name;
        temp = imread(strcat(pathname, '/', img_name));
        temp = double(temp(:));
        imagedata = [imagedata, temp];
    end
end
col_of_data = size(imagedata,2);


imgmean = mean(imagedata,2);
for i = 1:col_of_data
    imagedata(:,i) = imagedata(:,i) - imgmean;
end
covMat = imagedata'*imagedata;
[COEFF, latent, explained] = pcacov(covMat);


i = 1;
proportion = 0;
while(proportion < 95)
    proportion = proportion + explained(i);
    i = i+1;
end
p = i - 1;


W = imagedata*COEFF;   
W = W(:,1:p);           

reference = W'*imagedata;

% gettin the mean to use within the accurancy calculation
function cendata = center( testdata )

meandata = mean(testdata,2);
for i = 1:size(testdata,2)
    cendata(:,i) = testdata(:,i) - meandata;
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global W
global reference
col_of_data = 30;

pathname = uigetdir;
img_path_list = dir(strcat(pathname,'\*.jpg'));
img_num = length(img_path_list);
testdata = [];
if img_num >0
    for j = 1:img_num
        img_name = img_path_list(j).name;
        temp = imread(strcat(pathname, '/', img_name));
        temp = double(temp(:));
        testdata = [testdata, temp];
    end
end


col_of_test = size(testdata,2);
testdata = center( testdata );
object = W'* testdata;

error = 0;
for j = 1:col_of_test
    distance = 1000000000000;
    for k = 1:col_of_data;
        temp = norm(object(:,j) - reference(:,k));
        if(distance>temp)
            aimone = k;
            distance = temp;
        end
    end
    if ceil(j/3)==ceil(aimone/4)
       error = error + 1;
    end
end
% calculating the accuracy
accuracy = ((1-(error/col_of_test))*100);
msgbox(['Accuracy level is :   ', num2str(accuracy),sprintf('%%')],'accuracy')





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
