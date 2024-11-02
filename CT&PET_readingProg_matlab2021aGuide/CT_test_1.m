function varargout = CT_test_1(varargin)
% CT_TEST_1 MATLAB code for CT_test_1.fig
%      CT_TEST_1, by itself, creates a new CT_TEST_1 or raises the existing
%      singleton*.
%
%      H = CT_TEST_1 returns the handle to a new CT_TEST_1 or the handle to
%      the existing singleton*.
%
%      CT_TEST_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CT_TEST_1.M with the given input arguments.
%
%      CT_TEST_1('Property','Value',...) creates a new CT_TEST_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CT_test_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CT_test_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CT_test_1

% Last Modified by GUIDE v2.5 06-Sep-2023 15:39:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CT_test_1_OpeningFcn, ...
                   'gui_OutputFcn',  @CT_test_1_OutputFcn, ...
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


% --- Executes just before CT_test_1 is made visible.
function CT_test_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CT_test_1 (see VARARGIN)

% Choose default command line output for CT_test_1
handles.output = hObject;

    handles.CT_Point=0;                                                     %%标记是否载入CT
    handles.PET_Point=0;                                                    %%标记是否载入PET

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CT_test_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CT_test_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)                  %%读取CT文件函数
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    AIM=uigetdir();                                                         %%选择目标文件夹
    AIMPOT=dir(AIM);                                                        %%取目标文件夹路径
    MARK=[];                                                                
    for i=1:length(AIMPOT)-2                                                %%循环读取每个文件路径
        CT_PATH=[AIMPOT(i+2).folder,'\'];                                   %%循环读取每个文件路径
        CT_PATH=[CT_PATH,AIMPOT(i+2).name];
        CT_Info = dicominfo(CT_PATH);                                       %%其他数据信息
        CT_Image = dicomread(CT_PATH);                                      %%灰度矩阵
        CT_Image_Total(:,:,CT_Info.InstanceNumber) = double(CT_Image*CT_Info.RescaleSlope+ CT_Info.RescaleIntercept);
                                                                            %%将灰度矩阵转换为CT值矩阵储存在新的三维数组中
        MARK=[MARK,CT_Info.InstanceNumber];                                 %%记录三维数组中的有效维度
    end
    
    handles.CT_Info = CT_Info;                                              %%将其他数据信息存入handles全局结构体，便于其他函数调用
    
    CT_MAXM_Origen=(CT_Info.WindowWidth+CT_Info.WindowCenter*2)/2;          %%CT图原始最大值
    CT_MINM_Origen=CT_MAXM_Origen-CT_Info.WindowWidth;                      %%CT图原始最小值
    
    Slice_Number1_Now=1;                                                    %%水平面当前页数
    Slice_Number2_Now=1;                                                    %%矢状面当前页数
    Slice_Number3_Now=1;                                                    %%冠状面当前页数
    
    
    SliceNumberTotal_2=512;                                                 %%存入矢状面总页数                                          
    SliceNumberTotal_3=512;                                                 %%存入冠状面总页数        
    
    handles.CT_Image_Total=CT_Image_Total(:,:,MARK);                        %%将有效的三维数组存入全局三维数组中
    CT_Image_Total=CT_Image_Total(:,:,MARK);                                
    
    handles.Slice_Number1_Now=Slice_Number1_Now;                            %%将当前页数存入handles全局结构体中
    handles.Slice_Number2_Now=Slice_Number2_Now;
    handles.Slice_Number3_Now=Slice_Number3_Now;
    
    
    handles.SliceNumberTotal_1=length(AIMPOT)-2;                            %%将每张图的总页数存入全局结构体中
    handles.SliceNumberTotal_2=SliceNumberTotal_2;
    handles.SliceNumberTotal_3=SliceNumberTotal_3;
    
    handles.CT_MAXM=CT_MAXM_Origen;                                         %%将CT图原始最大最小值存入全局结构体中
    handles.CT_MINM=CT_MINM_Origen;
    handles.CT_MAXM_Origen=CT_MAXM_Origen;
    handles.CT_MINM_Origen=CT_MINM_Origen;
    
    handles.CT_Figure=handles.CT_Image_Total;                               %%将原始CT图及相关信息存入全局结构体
    handles.CT_Point=handles.CT_Point+1;
    handles.CT_MAX_Origin=handles.CT_MAXM;
    handles.CT_MIN_Origin=handles.CT_MINM;
    handles.CT_Info_Origin=CT_Info;
    
    axes(handles.axes1);                                                    %%在axes1处显示CT图的水平面
    imshow(CT_Image_Total(:,:,Slice_Number1_Now),[CT_MINM_Origen CT_MAXM_Origen]);
    axes(handles.axes2);                                                    %%在axes2处显示CT图的矢状面
    imshow(reshape(CT_Image_Total(:,Slice_Number1_Now,:),[SliceNumberTotal_3 length(AIMPOT)-2])',[CT_MINM_Origen CT_MAXM_Origen]);
    axes(handles.axes3);                                                    %%在axes3处显示CT图的冠状面
    imshow(reshape(CT_Image_Total(Slice_Number1_Now,:,:),[SliceNumberTotal_2 length(AIMPOT)-2])',[CT_MINM_Origen CT_MAXM_Origen]);
    
    set(handles.slider1,'Max',length(AIMPOT)-2);                            %%设置水平面滑块的信息
    set(handles.slider1,'Min',1);
    set(handles.slider1,'Value',1);
    set(handles.text1,'String',[num2str(Slice_Number2_Now),'/',num2str(length(AIMPOT)-2)]);
                                                                            %%设置水平面的页码数据
    
    set(handles.slider2,'Max',SliceNumberTotal_3);                          %%同上设置矢状面的信息
    set(handles.slider2,'Min',1);
    set(handles.slider2,'Value',1);
    set(handles.text2,'String',[num2str(Slice_Number1_Now),'/',num2str(SliceNumberTotal_2)]);
    
    set(handles.slider3,'Max',SliceNumberTotal_2);                          %%同上设置冠状面的信息
    set(handles.slider3,'Min',1);
    set(handles.slider3,'Value',1);
    set(handles.text3,'String',[num2str(Slice_Number1_Now),'/',num2str(SliceNumberTotal_2)]);
    
    handles.windowcenter=(CT_MAXM_Origen+CT_MINM_Origen)/2;                 %%将当前窗心存入全局结构体
    handles.windowwidth=CT_MAXM_Origen-CT_MINM_Origen;                      %%将当前窗宽存入全局结构体
    
                                                                            %%设置显示窗心和窗宽数据
    set(handles.text_windowcenter,'String',['窗心：',num2str(handles.windowcenter)]);
    set(handles.text_windowwidth,'String',['窗宽：',num2str(handles.windowwidth)]);
                                                                            %%设置窗心和窗宽滑块的相关信息
    set(handles.slider_windowcenter,'Max',2048);
    set(handles.slider_windowcenter,'Min',-2048);
    set(handles.slider_windowcenter,'Value',handles.windowcenter);
    
    set(handles.slider_windowwidth,'Max',4096);
    set(handles.slider_windowwidth,'Min',0);
    set(handles.slider_windowwidth,'Value',handles.windowwidth);
    
    
    guidata(hObject,handles);                                               %%记录对handles结构体中的数据变更
    
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
   
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    handles.Slice_Number1_Now= round(get(handles.slider1,'Value'));         %%将当前滑块所代表的图的页数存入全局结构体
    axes(handles.axes1);                                                    %%在axes1处显示当前页数的水平面
    imshow(handles.CT_Image_Total(:,:,handles.Slice_Number1_Now),[handles.CT_MINM handles.CT_MAXM]);
    set(handles.text1,'String',[num2str(handles.Slice_Number1_Now),'/',num2str(handles.SliceNumberTotal_1)]);
    
    guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)                  %%读取PET文件函数
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

                                                                            %%同CT图的读取和存储，便不再过多注释
    AIM=uigetdir();
    AIMPOT=dir(AIM);%%取文件地址
    MARK=[];
    for i=1:length(AIMPOT)-2
        CT_PATH=[AIMPOT(i+2).folder,'\'];
        CT_PATH=[CT_PATH,AIMPOT(i+2).name];
        CT_Info = dicominfo(CT_PATH);%%取CT
        CT_Image = dicomread(CT_PATH);
        CT_Image_Total(:,:,CT_Info.InstanceNumber) = CT_Image;              %%PET图不需要转化为CT值
        MARK=[MARK,CT_Info.InstanceNumber];
    end
    
    handles.CT_Info = CT_Info;
    
    Slice_Number1_Now=1;
    Slice_Number2_Now=1;
    Slice_Number3_Now=1;
    
%     SliceNumberTotal_2=size(CT_Image_Total(:,Slice_Number1_Now,Slice_Number1_Now));
%     SliceNumberTotal_3=size(CT_Image_Total(Slice_Number1_Now,:,Slice_Number1_Now));
    
    SliceNumberTotal_2=512;
    SliceNumberTotal_3=512;
    
    handles.CT_Image_Total=CT_Image_Total(:,:,MARK);
    CT_Image_Total=CT_Image_Total(:,:,MARK);
    
    
    CT_MAXM_Origen=max(max(CT_Image));%%CT图范围
    CT_MINM_Origen=min(min(CT_Image));
    
    handles.Slice_Number1_Now=Slice_Number1_Now;
    handles.Slice_Number2_Now=Slice_Number2_Now;
    handles.Slice_Number3_Now=Slice_Number3_Now;
    
    
    handles.SliceNumberTotal_1=length(AIMPOT)-2;
    handles.SliceNumberTotal_2=SliceNumberTotal_2;
    handles.SliceNumberTotal_3=SliceNumberTotal_3;
    
    handles.CT_MAXM=CT_MAXM_Origen;
    handles.CT_MINM=CT_MINM_Origen;
    handles.CT_MAXM_Origen=CT_MAXM_Origen;
    handles.CT_MINM_Origen=CT_MINM_Origen;
    
    handles.PET_Figure=handles.CT_Image_Total;
    handles.PET_Point=handles.PET_Point+1;
    handles.PET_MAX_Origin=handles.CT_MAXM;
    handles.PET_MIN_Origin=handles.CT_MINM;
    handles.PET_Info_Origin=CT_Info;
    
    axes(handles.axes1);
    imshow(CT_Image_Total(:,:,Slice_Number1_Now),[CT_MINM_Origen CT_MAXM_Origen]);
    axes(handles.axes2);
    imshow(reshape(CT_Image_Total(:,Slice_Number1_Now,:),[SliceNumberTotal_3 length(AIMPOT)-2])',[CT_MINM_Origen CT_MAXM_Origen]);
    axes(handles.axes3);
    imshow(reshape(CT_Image_Total(Slice_Number1_Now,:,:),[SliceNumberTotal_2 length(AIMPOT)-2])',[CT_MINM_Origen CT_MAXM_Origen]);
    
    set(handles.slider1,'Max',length(AIMPOT)-2);
    set(handles.slider1,'Min',1);
    set(handles.slider1,'Value',1);
    set(handles.text1,'String',[num2str(Slice_Number2_Now),'/',num2str(length(AIMPOT)-2)]);
    
    set(handles.slider2,'Max',SliceNumberTotal_3);
    set(handles.slider2,'Min',1);
    set(handles.slider2,'Value',1);
    set(handles.text2,'String',[num2str(Slice_Number1_Now),'/',num2str(SliceNumberTotal_2)]);
    
    set(handles.slider3,'Max',SliceNumberTotal_2);
    set(handles.slider3,'Min',1);
    set(handles.slider3,'Value',1);
    set(handles.text3,'String',[num2str(Slice_Number1_Now),'/',num2str(SliceNumberTotal_2)]);
    
    handles.windowcenter=(CT_MAXM_Origen+CT_MINM_Origen)/2;
    handles.windowwidth=CT_MAXM_Origen-CT_MINM_Origen;
    
    set(handles.text_windowcenter,'String',['窗心：',num2str(handles.windowcenter)]);
    set(handles.text_windowwidth,'String',['窗宽：',num2str(handles.windowwidth)]);
    
    set(handles.slider_windowcenter,'Max',2048);
    set(handles.slider_windowcenter,'Min',-2048);
    set(handles.slider_windowcenter,'Value',handles.windowcenter);
    
    set(handles.slider_windowwidth,'Max',4096);
    set(handles.slider_windowwidth,'Min',0);
    set(handles.slider_windowwidth,'Value',handles.windowwidth);
    
    
    guidata(hObject,handles);




% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    handles.Slice_Number2_Now= round(get(handles.slider2,'Value'));         %%同水平面滑块slider1的处理，不再过多注释
    axes(handles.axes2);
    imshow(reshape(handles.CT_Image_Total(:,handles.Slice_Number2_Now,:),[handles.SliceNumberTotal_3 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    set(handles.text2,'String',[num2str(handles.Slice_Number2_Now),'/',num2str(handles.SliceNumberTotal_2)]);

    guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)                      %%同水平面滑块slider1的处理，不再过多注释
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    handles.Slice_Number3_Now= round(get(handles.slider3,'Value'));         
    axes(handles.axes3);
    imshow(reshape(handles.CT_Image_Total(handles.Slice_Number3_Now,:,:),[handles.SliceNumberTotal_2 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    set(handles.text3,'String',[num2str(handles.Slice_Number3_Now),'/',num2str(handles.SliceNumberTotal_3)]);

    guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)             %%重置窗心窗口显示
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles.CT_MAXM=handles.CT_MAXM_Origen;                                 %%重置最大最小值，于读取时的操作同理，不再过多注释
    handles.CT_MINM=handles.CT_MINM_Origen;
    
    handles.windowcenter=(handles.CT_MAXM_Origen+handles.CT_MINM_Origen)/2;
    handles.windowwidth=handles.CT_MAXM_Origen-handles.CT_MINM_Origen;
    
    set(handles.text_windowcenter,'String',['窗心：',num2str(handles.windowcenter)]);
    set(handles.text_windowwidth,'String',['窗宽：',num2str(handles.windowwidth)]);
    
    set(handles.slider_windowcenter,'Max',2048);
    set(handles.slider_windowcenter,'Min',-2048);
    set(handles.slider_windowcenter,'Value',handles.windowcenter);
    
    set(handles.slider_windowwidth,'Max',4096);
    set(handles.slider_windowwidth,'Min',0);
    set(handles.slider_windowwidth,'Value',handles.windowwidth);
    
    axes(handles.axes1);
    imshow(handles.CT_Image_Total(:,:,handles.Slice_Number1_Now),[handles.CT_MINM handles.CT_MAXM]);
    axes(handles.axes2);
    imshow(reshape(handles.CT_Image_Total(:,handles.Slice_Number2_Now,:),[handles.SliceNumberTotal_3 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    axes(handles.axes3);
    imshow(reshape(handles.CT_Image_Total(handles.Slice_Number3_Now,:,:),[handles.SliceNumberTotal_2 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    
    guidata(hObject,handles);
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)                  %%将窗心和窗宽改为肺窗的函数，与重置按钮同理，不再过多注释       
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.windowcenter=-500;
    handles.windowwidth=700;
    
    handles.CT_MAXM=(handles.windowwidth+handles.windowcenter*2)/2;
    handles.CT_MINM=handles.CT_MAXM-handles.windowwidth;
    
    set(handles.text_windowcenter,'String',['窗心：',num2str(handles.windowcenter)]);
    set(handles.text_windowwidth,'String',['窗宽：',num2str(handles.windowwidth)]);
    
    set(handles.slider_windowcenter,'Value',handles.windowcenter);
    set(handles.slider_windowwidth,'Value',handles.windowwidth);
    
    axes(handles.axes1);
    imshow(handles.CT_Image_Total(:,:,handles.Slice_Number1_Now),[handles.CT_MINM handles.CT_MAXM]);
    axes(handles.axes2);
    imshow(reshape(handles.CT_Image_Total(:,handles.Slice_Number2_Now,:),[handles.SliceNumberTotal_3 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    axes(handles.axes3);
    imshow(reshape(handles.CT_Image_Total(handles.Slice_Number3_Now,:,:),[handles.SliceNumberTotal_2 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    
    guidata(hObject,handles);
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)                  %%将窗心和窗宽改为纵膈窗的函数，与重置按钮同理，不再过多注释
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles.windowcenter=50;
    handles.windowwidth=400;
    
    handles.CT_MAXM=(handles.windowwidth+handles.windowcenter*2)/2;
    handles.CT_MINM=handles.CT_MAXM-handles.windowwidth;
    
    set(handles.text_windowcenter,'String',['窗心：',num2str(handles.windowcenter)]);
    set(handles.text_windowwidth,'String',['窗宽：',num2str(handles.windowwidth)]);
    
    set(handles.slider_windowcenter,'Value',handles.windowcenter);
    set(handles.slider_windowwidth,'Value',handles.windowwidth);
    
    axes(handles.axes1);
    imshow(handles.CT_Image_Total(:,:,handles.Slice_Number1_Now),[handles.CT_MINM handles.CT_MAXM]);
    axes(handles.axes2);
    imshow(reshape(handles.CT_Image_Total(:,handles.Slice_Number2_Now,:),[handles.SliceNumberTotal_3 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    axes(handles.axes3);
    imshow(reshape(handles.CT_Image_Total(handles.Slice_Number3_Now,:,:),[handles.SliceNumberTotal_2 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);

    guidata(hObject,handles);
% --- Executes on slider movement.
function slider_windowcenter_Callback(hObject, eventdata, handles)          %%改变窗心数值的滑块
% hObject    handle to slider_windowcenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    
    handles.windowcenter=round(get(handles.slider_windowcenter,'Value'));   %%读取此时窗心的值
    handles.CT_MAXM=(handles.windowwidth+handles.windowcenter*2)/2;         %%计算此时的最大最小值
    handles.CT_MINM=handles.CT_MAXM-handles.windowwidth;
    
    set(handles.text_windowcenter,'String',['窗心：',num2str(handles.windowcenter)]);
                                                                            %%将改变之后的窗心值显示在text
    
    set(handles.slider_windowcenter,'Value',handles.windowcenter);
                                                                            
    axes(handles.axes1);                                                    %%显示此时的三张图
    imshow(handles.CT_Image_Total(:,:,handles.Slice_Number1_Now),[handles.CT_MINM handles.CT_MAXM]);
    axes(handles.axes2);
    imshow(reshape(handles.CT_Image_Total(:,handles.Slice_Number2_Now,:),[handles.SliceNumberTotal_3 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    axes(handles.axes3);
    imshow(reshape(handles.CT_Image_Total(handles.Slice_Number3_Now,:,:),[handles.SliceNumberTotal_2 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    
    guidata(hObject,handles);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_windowcenter_CreateFcn(hObject, eventdata, handles)         
% hObject    handle to slider_windowcenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_windowwidth_Callback(hObject, eventdata, handles)           %%改变窗宽数值的滑块，与窗心同理，不再过多注释
% hObject    handle to slider_windowwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    handles.windowwidth=round(get(handles.slider_windowwidth,'Value'));
    
    handles.CT_MAXM=(handles.windowwidth+handles.windowcenter*2)/2;
    handles.CT_MINM=handles.CT_MAXM-handles.windowwidth;
    
    set(handles.text_windowwidth,'String',['窗宽：',num2str(handles.windowwidth)]);
    
    set(handles.slider_windowwidth,'Value',handles.windowwidth);
    
    axes(handles.axes1);
    imshow(handles.CT_Image_Total(:,:,handles.Slice_Number1_Now),[handles.CT_MINM handles.CT_MAXM]);
    axes(handles.axes2);
    imshow(reshape(handles.CT_Image_Total(:,handles.Slice_Number2_Now,:),[handles.SliceNumberTotal_3 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    axes(handles.axes3);
    imshow(reshape(handles.CT_Image_Total(handles.Slice_Number3_Now,:,:),[handles.SliceNumberTotal_2 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    
    guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider_windowwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_windowwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_showCT.
function pushbutton_showCT_Callback(hObject, eventdata, handles)            %%选择CT图像进行显示
% hObject    handle to pushbutton_showCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    if handles.CT_Point==0                                                  %%判断是否已读取CT文件，若未读取则提示报错
        msgbox('尚未载入CT图像','发生错误^^','error');
    else
        handles.CT_Image_Total=handles.CT_Figure;                           %%将当前显示的图改为CT图
        handles.CT_MAXM_Origen=handles.CT_MAX_Origin;                       %%将当前所存取有关图的数据全部换为CT图的数据
        handles.CT_MINM_Origen=handles.CT_MIN_Origin;
        handles.CT_MAXM=handles.CT_MAX_Origin;
        handles.CT_MINM=handles.CT_MIN_Origin;
        handles.CT_Info=handles.CT_Info_Origin;
       
        
   
        handles.windowcenter=(handles.CT_MAX_Origin+handles.CT_MIN_Origin)/2;
        handles.windowwidth=handles.CT_MAX_Origin-handles.CT_MIN_Origin;
    
        handles.CT_MAXM=handles.CT_MAX_Origin;
        handles.CT_MINM=handles.CT_MIN_Origin;

        set(handles.text_windowcenter,'String',['窗心：',num2str(handles.windowcenter)]);
        set(handles.text_windowwidth,'String',['窗宽：',num2str(handles.windowwidth)]);

        set(handles.slider_windowcenter,'Max',2048);
        set(handles.slider_windowcenter,'Min',-2048);
        set(handles.slider_windowcenter,'Value',handles.windowcenter);

        set(handles.slider_windowwidth,'Max',4096);
        set(handles.slider_windowwidth,'Min',0);
        set(handles.slider_windowwidth,'Value',handles.windowwidth);

        axes(handles.axes1);
        imshow(handles.CT_Image_Total(:,:,handles.Slice_Number1_Now),[handles.CT_MIN_Origin handles.CT_MAX_Origin]);
        axes(handles.axes2);
        imshow(reshape(handles.CT_Image_Total(:,handles.Slice_Number2_Now,:),[handles.SliceNumberTotal_3 handles.SliceNumberTotal_1])',[handles.CT_MIN_Origin handles.CT_MAX_Origin]);
        axes(handles.axes3);
        imshow(reshape(handles.CT_Image_Total(handles.Slice_Number3_Now,:,:),[handles.SliceNumberTotal_2 handles.SliceNumberTotal_1])',[handles.CT_MIN_Origin handles.CT_MAX_Origin]);

        guidata(hObject,handles);
    end

% --- Executes on button press in pushbutton_showPET.
function pushbutton_showPET_Callback(hObject, eventdata, handles)           %%选择PET图像进行显示
% hObject    handle to pushbutton_showPET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if handles.PET_Point==0                                                 %%判断是否已读取PET文件，若未读取则提示报错            
        msgbox('尚未载入PET图像','发生错误^^','error');
    else
        handles.CT_Image_Total=handles.PET_Figure;                          %%将当前显示的图改为PET图
        handles.CT_MAXM_Origen=handles.PET_MAX_Origin;                      %%将当前所存取有关图的数据全部换为PET图的数据
        handles.CT_MINM_Origen=handles.PET_MIN_Origin;
        handles.CT_MAXM=handles.PET_MAX_Origin;
        handles.CT_MINM=handles.PET_MIN_Origin;
        handles.CT_Info=handles.PET_Info_Origin;
        
   
        handles.windowcenter=(handles.PET_MAX_Origin+handles.PET_MIN_Origin)/2;
        handles.windowwidth=handles.PET_MAX_Origin-handles.PET_MIN_Origin;
    
        handles.CT_MAXM=handles.PET_MAX_Origin;
        handles.CT_MINM=handles.PET_MIN_Origin;

        set(handles.text_windowcenter,'String',['窗心：',num2str(handles.windowcenter)]);
        set(handles.text_windowwidth,'String',['窗宽：',num2str(handles.windowwidth)]);

        set(handles.slider_windowcenter,'Max',2048);
        set(handles.slider_windowcenter,'Min',-2048);
        set(handles.slider_windowcenter,'Value',handles.windowcenter);

        set(handles.slider_windowwidth,'Max',4096);
        set(handles.slider_windowwidth,'Min',0);
        set(handles.slider_windowwidth,'Value',handles.windowwidth);

        axes(handles.axes1);
        imshow(handles.CT_Image_Total(:,:,handles.Slice_Number1_Now),[handles.PET_MIN_Origin handles.PET_MAX_Origin]);
        axes(handles.axes2);
        imshow(reshape(handles.CT_Image_Total(:,handles.Slice_Number2_Now,:),[handles.SliceNumberTotal_3 handles.SliceNumberTotal_1])',[handles.PET_MIN_Origin handles.PET_MAX_Origin]);
        axes(handles.axes3);
        imshow(reshape(handles.CT_Image_Total(handles.Slice_Number3_Now,:,:),[handles.SliceNumberTotal_2 handles.SliceNumberTotal_1])',[handles.PET_MIN_Origin handles.PET_MAX_Origin]);

        guidata(hObject,handles);
    end

% --- Executes on button press in pushbutton_showMIX.
function pushbutton_showMIX_Callback(hObject, eventdata, handles)           %%选择PET图像进行显示
% hObject    handle to pushbutton_showMIX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if handles.PET_Point==0                                                 %%判断是否已读取CT或PET文件，若未读取则提示报错  
        msgbox('尚未载入PET图像','发生错误^^','error');
    end
    if handles.CT_Point==0
        msgbox('尚未载入CT图像','发生错误^^','error');
    end
    if handles.PET_Point>0 && handles.CT_Point>0                            
        
        Para=0.9;                                                           %%参数a的值
        
        handles.Para=Para;                                                  %%将参数a存入handles全局结构体
        
        handles.CT_Image_Total=double(Para*handles.CT_Figure)+double((1-Para)*handles.PET_Figure);
                                                                            %%将CT图与PET图进行融合，将当前显示的图改为融合图
        handles.CT_MAXM_Origen=Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin;
                                                                            %%将当前所存取有关图的数据全部换为融合图的数据
        handles.CT_MINM_Origen=Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin;
        handles.CT_MAXM=Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin;
        handles.CT_MINM=Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin;
        handles.CT_Info=handles.CT_Info_Origin;
        
   
        handles.windowcenter=(Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin+Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin)/2;
        handles.windowwidth=Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin-Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin;
    
        handles.CT_MAXM=Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin;
        handles.CT_MINM=Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin;

        set(handles.text_windowcenter,'String',['窗心：',num2str(handles.windowcenter)]);
        set(handles.text_windowwidth,'String',['窗宽：',num2str(handles.windowwidth)]);

        set(handles.slider_windowcenter,'Max',2048);
        set(handles.slider_windowcenter,'Min',-2048);
        set(handles.slider_windowcenter,'Value',handles.windowcenter);

        set(handles.slider_windowwidth,'Max',4096);
        set(handles.slider_windowwidth,'Min',0);
        set(handles.slider_windowwidth,'Value',handles.windowwidth);
        
        set(handles.slider_Para,'Max',0.999);
        set(handles.slider_Para,'Min',0.001);
        set(handles.text_Para,'String',['a=',num2str(Para)]);
        set(handles.slider_Para,'Value',Para);

        axes(handles.axes1);
        imshow(handles.CT_Image_Total(:,:,handles.Slice_Number1_Now),[Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin]);
        axes(handles.axes2);
        imshow(reshape(handles.CT_Image_Total(:,handles.Slice_Number2_Now,:),[handles.SliceNumberTotal_3 handles.SliceNumberTotal_1])',[Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin]);
        axes(handles.axes3);
        imshow(reshape(handles.CT_Image_Total(handles.Slice_Number3_Now,:,:),[handles.SliceNumberTotal_2 handles.SliceNumberTotal_1])',[Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin]);

        guidata(hObject,handles);
    end



% --- Executes on button press in pushbutton_draw1.
function pushbutton_draw1_Callback(hObject, eventdata, handles)             %%水平面的ROI选择
% hObject    handle to pushbutton_draw1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    axes(handles.axes1);
    imshow(handles.CT_Image_Total(:,:,handles.Slice_Number1_Now),[handles.CT_MINM handles.CT_MAXM]);
                                                                            %%选择axes1处为ROI目标
    h=imfreehand();
    wait(h);
    maskFreeHand=createMask(h);
    axes(handles.axes1);
    imshow(handles.CT_Image_Total(:,:,handles.Slice_Number1_Now),[handles.CT_MINM handles.CT_MAXM]);
    hold on;
    contour(maskFreeHand,'r');
    handles.Figure1_MAXM=-99999;                                            %%所划区域的最大值
    handles.Figure1_MINM=99999;                                             %%所划区域的最小值
    handles.Figure1_AVR=0.0;                                                %%所划区域的平均值
    handles.Figure1_S=0;                                                    %%所划区域的面积
    for i=1:handles.SliceNumberTotal_2                                      %%通过循环寻找以上四种数据
        for k=1:handles.SliceNumberTotal_3
            if (maskFreeHand(i,k)==1)                                       %%判断是否为所划区域
                handles.Figure1_S=handles.Figure1_S+1;                      %%S先存储像素点的个数
                handles.Figure1_AVR=double(handles.Figure1_AVR+handles.CT_Image_Total(i,k,handles.Slice_Number1_Now));
                                                                            %%AVR先存取所划矩阵的数值和
                if handles.Figure1_MAXM<=handles.CT_Image_Total(i,k,handles.Slice_Number1_Now)
                    handles.Figure1_MAXM=double(handles.CT_Image_Total(i,k,handles.Slice_Number1_Now));
                end
                if handles.Figure1_MINM>=handles.CT_Image_Total(i,k,handles.Slice_Number1_Now)
                    handles.Figure1_MINM=double(handles.CT_Image_Total(i,k,handles.Slice_Number1_Now));
                end
            end
        end
    end
    handles.Figure1_AVR=double(handles.Figure1_AVR/handles.Figure1_S);      %%用总和/像素点个数得到平均值
    handles.Figure1_S=handles.Figure1_S*handles.CT_Info.PixelSpacing(1)*handles.CT_Info.PixelSpacing(2);
                                                                            %%用像素个数*每个像素点的面积，得到总面积，单位为“/平方毫米”
    set(handles.text1_MAXM,'String',num2str(handles.Figure1_MAXM));         %%显示上述四种数据
    set(handles.text1_MINM,'String',num2str(handles.Figure1_MINM));
    set(handles.text1_AVR,'String',num2str(handles.Figure1_AVR));
    set(handles.text1_S,'String',num2str(handles.Figure1_S));
    
    guidata(hObject,handles);

% --- Executes on button press in pushbutton_draw2.
function pushbutton_draw2_Callback(hObject, eventdata, handles)             %%矢状面的ROI选择，与水平面同理，不再过多注释
% hObject    handle to pushbutton_draw2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    axes(handles.axes2);
    imshow(reshape(handles.CT_Image_Total(:,handles.Slice_Number2_Now,:),[handles.SliceNumberTotal_3 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    h=imfreehand();
    wait(h);
    maskFreeHand=createMask(h);
    axes(handles.axes2);
    imshow(reshape(handles.CT_Image_Total(:,handles.Slice_Number2_Now,:),[handles.SliceNumberTotal_3 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    hold on;
    contour(maskFreeHand,'r');
    handles.Figure2_MAXM=-99999;
    handles.Figure2_MINM=99999;
    handles.Figure2_AVR=0.0;
    handles.Figure2_S=0;
    for i=1:handles.SliceNumberTotal_3
        for k=1:handles.SliceNumberTotal_1
            if (maskFreeHand(k,i)==1)
                handles.Figure2_S=handles.Figure2_S+1;
                handles.Figure2_AVR=double(handles.Figure2_AVR+handles.CT_Image_Total(i,handles.Slice_Number2_Now,k));
                if handles.Figure2_MAXM<=handles.CT_Image_Total(i,handles.Slice_Number2_Now,k)
                    handles.Figure2_MAXM=double(handles.CT_Image_Total(i,handles.Slice_Number2_Now,k));
                end
                if handles.Figure2_MINM>=handles.CT_Image_Total(i,handles.Slice_Number2_Now,k)
                    handles.Figure2_MINM=double(handles.CT_Image_Total(i,handles.Slice_Number2_Now,k));
                end
            end
        end
    end
    handles.Figure2_AVR=double(handles.Figure2_AVR/handles.Figure2_S);
    handles.Figure2_S=handles.Figure2_S*handles.CT_Info.PixelSpacing(1)*handles.CT_Info.PixelSpacing(2);
    
    set(handles.text2_MAXM,'String',num2str(handles.Figure2_MAXM));
    set(handles.text2_MINM,'String',num2str(handles.Figure2_MINM));
    set(handles.text2_AVR,'String',num2str(handles.Figure2_AVR));
    set(handles.text2_S,'String',num2str(handles.Figure2_S));
    
    guidata(hObject,handles);

% --- Executes on button press in pushbutton_draw3.
function pushbutton_draw3_Callback(hObject, eventdata, handles)              %%冠状面的ROI选择，与水平面同理，不再过多注释
% hObject    handle to pushbutton_draw3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    axes(handles.axes3);
    imshow(reshape(handles.CT_Image_Total(handles.Slice_Number3_Now,:,:),[handles.SliceNumberTotal_2 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    h=imfreehand();
    wait(h);
    maskFreeHand=createMask(h);
    axes(handles.axes3);
    imshow(reshape(handles.CT_Image_Total(handles.Slice_Number3_Now,:,:),[handles.SliceNumberTotal_2 handles.SliceNumberTotal_1])',[handles.CT_MINM handles.CT_MAXM]);
    hold on;
    contour(maskFreeHand,'r');
    handles.Figure3_MAXM=-99999;
    handles.Figure3_MINM=99999;
    handles.Figure3_AVR=0.0;
    handles.Figure3_S=0;
    for i=1:handles.SliceNumberTotal_2
        for k=1:handles.SliceNumberTotal_1
            if (maskFreeHand(k,i)==1)
                handles.Figure3_S=handles.Figure3_S+1;
                handles.Figure3_AVR=double(handles.Figure3_AVR+handles.CT_Image_Total(handles.Slice_Number3_Now,i,k));
                if handles.Figure3_MAXM<=handles.CT_Image_Total(handles.Slice_Number3_Now,i,k)
                    handles.Figure3_MAXM=double(handles.CT_Image_Total(handles.Slice_Number3_Now,i,k));
                end
                if handles.Figure3_MINM>=handles.CT_Image_Total(handles.Slice_Number3_Now,i,k)
                    handles.Figure3_MINM=double(handles.CT_Image_Total(handles.Slice_Number3_Now,i,k));
                end
            end
        end
    end
    handles.Figure3_AVR=double(handles.Figure3_AVR/handles.Figure3_S);
    handles.Figure3_S=handles.Figure3_S*handles.CT_Info.PixelSpacing(1)*handles.CT_Info.PixelSpacing(2);
    
    set(handles.text3_MAXM,'String',num2str(handles.Figure3_MAXM));
    set(handles.text3_MINM,'String',num2str(handles.Figure3_MINM));
    set(handles.text3_AVR,'String',num2str(handles.Figure3_AVR));
    set(handles.text3_S,'String',num2str(handles.Figure3_S));
    
    guidata(hObject,handles);


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider_Para_Callback(hObject, eventdata, handles)                  %%融合图像特征参数a的选择
% hObject    handle to slider_Para (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if handles.CT_Point==0 || handles.PET_Point==0                          %%判断是否已载入融合图像，若未载入则报错
         msgbox('尚未载入完整融合图像','发生错误^^','error');
    else
       
        
        handles.Para=get(handles.slider_Para,'Value');                      %%读取此时滑块的值给Para
        
        Para=get(handles.slider_Para,'Value');
        
                                                                            %%计算新的Para，并显示新的融合图像及其数据，与前同理，不再过多注释
        handles.CT_Image_Total=double(Para*handles.CT_Figure)+double((1-Para)*handles.PET_Figure);
        handles.CT_MAXM_Origen=Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin;
        handles.CT_MINM_Origen=Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin;
        handles.CT_MAXM=Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin;
        handles.CT_MINM=Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin;
        handles.CT_Info=handles.CT_Info_Origin;
        
   
        handles.windowcenter=(Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin+Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin)/2;
        handles.windowwidth=Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin-Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin;
    
        handles.CT_MAXM=Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin;
        handles.CT_MINM=Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin;

        set(handles.text_windowcenter,'String',['窗心：',num2str(handles.windowcenter)]);
        set(handles.text_windowwidth,'String',['窗宽：',num2str(handles.windowwidth)]);

        set(handles.slider_windowcenter,'Max',2048);
        set(handles.slider_windowcenter,'Min',-2048);
        set(handles.slider_windowcenter,'Value',handles.windowcenter);

        set(handles.slider_windowwidth,'Max',4096);
        set(handles.slider_windowwidth,'Min',0);
        set(handles.slider_windowwidth,'Value',handles.windowwidth);
        
        set(handles.slider_Para,'Max',0.999);
        set(handles.slider_Para,'Min',0.001);
        set(handles.text_Para,'String',['a=',num2str(Para)]);
        set(handles.slider_Para,'Value',Para);

        axes(handles.axes1);
        imshow(handles.CT_Image_Total(:,:,handles.Slice_Number1_Now),[Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin]);
        axes(handles.axes2);
        imshow(reshape(handles.CT_Image_Total(:,handles.Slice_Number2_Now,:),[handles.SliceNumberTotal_3 handles.SliceNumberTotal_1])',[Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin]);
        axes(handles.axes3);
        imshow(reshape(handles.CT_Image_Total(handles.Slice_Number3_Now,:,:),[handles.SliceNumberTotal_2 handles.SliceNumberTotal_1])',[Para*handles.CT_MIN_Origin+(1-Para)*handles.PET_MIN_Origin Para*handles.CT_MAX_Origin+(1-Para)*handles.PET_MAX_Origin]);

        guidata(hObject,handles);
    end
 
        
        
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_Para_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Para (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
