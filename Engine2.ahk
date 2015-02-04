
/*
 * 由于MenuZ\GestureZ\VimDesktop的需要，做一个统一的功能库
 * 1、类似StrokeIt里的命令集成，发挥AHK的优势
 * 2、此功能库有一个界面，可以允许加载，方便集成到三个程序中
 * 3、此功能库是可扩展的，方便维护和使用的
 * 4、此功能库使用yaml做为配置文件的保存、读取和执行
*/


/*
变量
SRE_GUIName: 功能库界面名，方便功能块嵌入
SRE_Handle: 功能库界面的Handle
SRE_Object: 功能库界面保存到数据（按数据结构）
*/

/*
数据结构:
Method: Run
  File: ''
  WorkingDir: ''
  Param: ''
  State: '0|1|2|3' 
--- 0为正常运行; 1为最小化运行; 2为最大化运行; 3为隐藏运行

Method: RunWait
  File: ''
  WorkingDir: ''
  Param: ''
  State: '0|1|2|3' 
--- 0为正常运行; 1为最小化运行; 2为最大化运行; 3为隐藏运行

Method: WinActivate
  Class: ''
  Title: ''
  fuzzy: False
  Wait: 0

Method: WinResize
  Width: 0
  Height: 0

Method: WinMove
  X: 0
  Y: 0

Method: WinMaximize
  Class: ''
  Title: ''
  fuzzy: False
Method: WinMinimize
  Class: ''
  Title: ''
  fuzzy: False
Method: WinRestore
  Class: ''
  Title: ''
  fuzzy: False
Method: AlwaysOnTop
  Class: ''
  Title: ''
  fuzzy: False

Method: SendMessage
  Class: ''
  Title: ''
  fuzzy: False
  Message: 0
  WParam:
  LParam:

Method: Send
  Hotkey: '{down 10}'

Method: Input
  String: ''

Method: Click
  X: 0
  Y: 0
  Count: 1
  Key: 'Right'

Method: Sleep
  Time: 0

Method: Label
  Sub: ''

Method: Function
  Name: ''

暂不支持：
Method: AHK
  Script: ''
*/

; SR_Engine_Load(GUIName="SRE",y=10) {{{1
; 此函数用于加载界面库
; 需要提供界面名称，默认为SR_Engine
SR_Engine_Load(GUIName="SRE",yy=10)
{
  Global SRE_GUIName,SRE_Array_method:=[]
        ,SRE_ListView_Step,SRE_DDL_Method,SRE_Text_Main,SRE_Button_Save
        ,SRE_Tab1_Edit1,SRE_Tab1_Edit2,SRE_Tab1_Edit3,SRE_Tab1_DDL
        ,SRE_Tab2_Edit1,SRE_Tab2_Edit2,SRE_Tab2_Edit3,SRE_Tab2_Button
        ,SRE_Tab3_Edit1,SRE_Tab3_Edit2
        ,SRE_Tab4_Edit1,SRE_Tab4_Edit2
        ,SRE_Tab5_Edit1,SRE_Tab5_Edit2,SRE_Tab5_Button
        ,SRE_Tab6_Edit1,SRE_Tab6_Edit2,SRE_Tab6_Buttnn
        ,SRE_Tab7_Edit1,SRE_Tab7_Edit2,SRE_Tab7_Buttnn
        ,SRE_Tab8_Edit1,SRE_Tab8_Edit2,SRE_Tab8_Buttnn
        ,SRE_Tab9_Edit1,SRE_Tab9_Edit2,SRE_Tab9_Buttnn,SRE_Tab9_Edit3,SRE_Tab9_Edit4,SRE_Tab9_Edit5
        ,SRE_Tab10_Edit1,SRE_Tab10_Edit2,SRE_Tab10_Buttnn,SRE_Tab10_Edit3,SRE_Tab10_Edit4,SRE_Tab10_Edit5
        ,SRE_Tab11_Edit1
        ,SRE_Tab12_Edit1
        ,SRE_Tab13_Edit1,SRE_Tab13_Edit2,SRE_Tab13_Edit3,SRE_Tab13_Edit4
        ,SRE_Tab14_Edit1
        ,SRE_Tab15_Edit1
        ,SRE_Tab16_Edit1
  SRE_GUIName := GUIName
  
  CH := "运行`n"
      . "运行并等待`n"
      . "激活指定窗口`n"
      . "调整窗口`n"
      . "移动窗口`n"
      . "最大化窗口`n"
      . "最小化窗口`n"
      . "还原窗口`n"
      . "顶置窗口`n"
      . "SendMessage`n"
      . "PostMessage`n"
      . "发送热键`n"
      . "发送文本`n"
      . "点击鼠标`n"
      . "延时`n"
      . "转到Label`n"
      . "执行Function"
      
  SRE_Array_method["Run"]:=1
  SRE_Array_method["RunWait"]:=2
  SRE_Array_method["WinActivate"]:=3
  SRE_Array_method["WinResize"]:=4
  SRE_Array_method["WinMove"]:=5
  SRE_Array_method["WinMaximize"]:=6
  SRE_Array_method["WinMinimize"]:=7
  SRE_Array_method["WinRestore"]:=8
  SRE_Array_method["AlwaysOnTop"]:=9
  SRE_Array_method["SendMessage"]:=10
  SRE_Array_method["PostMessage"]:=11
  SRE_Array_method["Send"]:=12
  SRE_Array_method["Input"]:=13
  SRE_Array_method["Click"]:=14
  SRE_Array_method["Sleep"]:=15
  SRE_Array_method["Label"]:=16
  SRE_Array_method["Function"]:=17
  
  y := yy
  GUI,%SRE_GUIName%:+Delimiter`n
  GUI,%SRE_GUIName%:Add,ListView,w200 h430 x10  y%y% hwndSRE_ListView_Step -ReadOnly gSR_Engine_LV AltSubmit NoSort, 步骤
  y+=5
  GUI,%SRE_GUIName%:Add,Text,w200 h28  x225 y%y% ,命令(&D)：
  y-=3
  GUI,%SRE_GUIName%:Add,DDL,w200 h28 x285 y%y% hwndSRE_DDL_Method r18  AltSubmit gSR_Engine_ChangeUI,% CH
  y+=40
  GUI,%SRE_GUIName%:Add,Text,w260 h50 x225 y%y% border
  y+=5
  GUI,%SRE_GUIName%:Add,Text,w256 h40 x227 y%y% center hwndSRE_Text_Main
  y+=360
  GUI,%SRE_GUIName%:Add,Button,w80 h26 x310 y%y% center gSR_Engine_SaveModify,帮助(&H)
  GUI,%SRE_GUIName%:Add,Button,w80 h26 x406 y%y% center hwndSRE_Button_Save gSR_Engine_SaveModify,应用(&A)
  ; Run 或者 RunWait {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom buttons Hidden,Run
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h298 x225 y%y%
  y+=16
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,文件/文件夹:(&E)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab1_Edit1 gSR_Engine_SaveButtonState
  y+=30
  GUI,%SRE_GUIName%:Add,Button,w90 h26 x285 y%y%,浏览文件(&F)
  GUI,%SRE_GUIName%:Add,Button,w90 h26 x385 y%y%,浏览文件夹(&D)
  y+=40
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,参数:(&P)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab1_Edit2 gSR_Engine_SaveButtonState
  y+=35
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,工作目录:(&W)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab1_Edit3  gSR_Engine_SaveButtonState
  y+=35
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,运行方式:(&M)
  y+=26
  GUI,%SRE_GUIName%:Add,DDL,w240 h26 x235 r4 y%y%  hwndSRE_Tab1_DDL AltSubmit Choose1 gSR_Engine_SaveButtonState,正常运行`n最小化运行`n最大化运行`n隐藏运行 
  ; WinActivate {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden ,WinActivate
  y+=7
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h230 x225 y%y%
  y+=16
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口类(&C)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab2_Edit1  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口标题:(&T)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab2_Edit2   gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,超时时间:(&T)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab2_Edit3   gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,CheckBox,h26 x235 y%y% hwndSRE_Tab2_Button ,模糊匹配标题文本(&M) 
  ; WinResize {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden,WinResize
  y+=7
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h140 x225 y%y%
  y+=16
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,宽度:(&W)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab3_Edit1   gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,高度:(&H)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab3_Edit2   gSR_Engine_SaveButtonState
  ; WinMove {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden ,WinMove
  y+=7
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h140 x225 y%y%
  y+=16
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,X坐标(&X)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab4_Edit1  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,Y坐标(&Y)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab4_Edit2  gSR_Engine_SaveButtonState
  ; WinMaximize {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden,WinMaximize
  y+=7
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h180 x225 y%y%
  y+=16
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口类(&C)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab5_Edit1  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口标题:(&T)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab5_Edit2  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,CheckBox,h26 x235 y%y% hwndSRE_Tab5_Button  gSR_Engine_SaveButtonState,模糊匹配标题文本(&M)
  ; WinMinimize {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden ,WinMinimize
  y+=7
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h180 x225 y%y%
  y+=16
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口类(&C)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab6_Edit1  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口标题:(&T)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab6_Edit2  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,CheckBox,h26 x235 y%y% hwndSRE_Tab6_Button  gSR_Engine_SaveButtonState,模糊匹配标题文本(&M)
  ; WinRestore {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden,WinRestore
  y+=7
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h180 x225 y%y%
  y+=16
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口类(&C)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab7_Edit1  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口标题:(&T)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab7_Edit2  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,CheckBox,h26 x235 y%y% hwndSRE_Tab7_Button  gSR_Engine_SaveButtonState,模糊匹配标题文本(&M)
  ; AlwaysOnTop {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden,AlwaysOnTop
  y+=7
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h180 x225 y%y%
  y+=16
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口类(&C)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab8_Edit1  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口标题:(&T)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab8_Edit2  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,CheckBox,h26 x235 y%y% hwndSRE_Tab8_Button  gSR_Engine_SaveButtonState,模糊匹配标题文本(&M)
  ; SendMessage {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden,SendMessage
  y+=7
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h150 x225 y%y%
  y+=16
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口类(&C)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab10_Edit1  gSR_Engine_SaveButtonState
  y+=28
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口标题:(&T)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab10_Edit2  gSR_Engine_SaveButtonState
  y+=28
  GUI,%SRE_GUIName%:Add,CheckBox,h26 x235 y%y% hwndSRE_Tab10_Button  gSR_Engine_SaveButtonState,模糊匹配标题文本(&M)
  y+=45
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h140 x225 y%y%
  y+=25
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,消息类型:(&I)
  y-=3
  GUI,%SRE_GUIName%:Add,ComboBox,w160 h24 x314 y%y% hwndSRE_Tab10_Edit3 R10  gSR_Engine_SaveButtonState
  y+=38
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,&WParam:
  y-=3
  GUI,%SRE_GUIName%:Add,ComboBox,w160 h24 x314 y%y% hwndSRE_Tab10_Edit4 R5  gSR_Engine_SaveButtonState
  y+=38
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,&LParam:
  y-=3
  GUI,%SRE_GUIName%:Add,ComboBox,w160 h24 x314 y%y% hwndSRE_Tab10_Edit5 R5  gSR_Engine_SaveButtonState
  ; PostMessage {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden,PostMessage
  y+=7
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h150 x225 y%y%
  y+=16
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口类(&C)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab10_Edit1  gSR_Engine_SaveButtonState
  y+=28
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,窗口标题:(&T)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab10_Edit2  gSR_Engine_SaveButtonState
  y+=28
  GUI,%SRE_GUIName%:Add,CheckBox,h26 x235 y%y% hwndSRE_Tab10_Button ,模糊匹配标题文本(&M)
  y+=45
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h140 x225 y%y% 
  y+=25
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,消息类型:(&I)
  y-=3
  GUI,%SRE_GUIName%:Add,ComboBox,w160 h24 x314 y%y% hwndSRE_Tab10_Edit3 R10  gSR_Engine_SaveButtonState
  y+=38
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,&WParam:
  y-=3
  GUI,%SRE_GUIName%:Add,ComboBox,w160 h24 x314 y%y% hwndSRE_Tab10_Edit4 R5  gSR_Engine_SaveButtonState
  y+=38
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,&LParam:
  y-=3
  GUI,%SRE_GUIName%:Add,ComboBox,w160 h24 x314 y%y% hwndSRE_Tab10_Edit5 R5  gSR_Engine_SaveButtonState
  ; Send {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden,Send
  y+=10
  GUI,%SRE_GUIName%:Add,Text,h26 x225 y%y%,热键列表(&H)
  y+=25
  GUI,%SRE_GUIName%:Add,Edit,w260 h270 x225 y%y% hwndSRE_Tab11_Edit1  gSR_Engine_SaveButtonState
  Gui,%SRE_GUIName%:Tab
  ; Input {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden,Input
  y+=10
  GUI,%SRE_GUIName%:Add,Text,h26 x225 y%y%,发送文本(&H)
  y+=25
  GUI,%SRE_GUIName%:Add,Edit,w260 h270 x225 y%y% hwndSRE_Tab12_Edit1  gSR_Engine_SaveButtonState
  ; Click {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden ,Click
  y+=7
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h240 x225 y%y%
  y+=16
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,X坐标(&X)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab13_Edit1  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,Y坐标(&Y)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab13_Edit2  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,次数(&C)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab13_Edit3  gSR_Engine_SaveButtonState
  y+=36
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,按键(&K)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab13_Edit4  gSR_Engine_SaveButtonState
  ; Sleep {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden,Sleep
  y+=10
  GUI,%SRE_GUIName%:Add,Text,h26 x225 y%y%,等待时间(&T)
  y+=25
  GUI,%SRE_GUIName%:Add,Edit,w260 h26 x225 y%y% hwndSRE_Tab14_Edit1  gSR_Engine_SaveButtonState
  GUI,%SRE_GUIName%:Tab
  ; Label {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden,Label
  y+=10
  GUI,%SRE_GUIName%:Add,Text,h26 x225 y%y%,转到Label(&G)
  y+=25
  GUI,%SRE_GUIName%:Add,ComboBox,w260 h26 x225 y%y% hwndSRE_Tab15_Edit1 gSR_Engine_SaveButtonState
  ; Function {{{2
  y:=yy+94
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom Buttons Hidden,Function
  y+=10
  GUI,%SRE_GUIName%:Add,Text,h26 x225 y%y%,函数名(&F)
  y+=25
  GUI,%SRE_GUIName%:Add,ComboBox,w260 h26 x225 y%y% hwndSRE_Tab16_Edit1 gSR_Engine_SaveButtonState
  GUI,%SRE_GUIName%:Tab
}

; SR_Engine_Show(option,title="StarRed Engine") {{{1
; 此函数显示配置界面,保存并返回Yaml格式
SR_Engine_Show(option="",title="StarRed Engine")
{
  Global SRE_Object,SRE_GUIName
  SRE_Object := yaml("",False)
  GUI,%SRE_GUIName%:+hwndSRE_Handle
  GUI,%SRE_GUIName%:Show,w500 h450 %option%,%title%
}
; SR_Engine_SaveButtonState: {{{1
SR_Engine_SaveButtonState:
	SR_Engine_SaveButtonState()
return
SR_Engine_SaveButtonState()
{
	Global SRE_GUIName,SRE_Button_Save
	GUI,%SRE_GUIName%:Default
	GUIControlGet,e,Enabled,%SRE_Button_Save%
	If not e
		GUIControl, Enable, %SRE_Button_Save%
}
; SR_Engine_SaveModify: {{{1
SR_Engine_SaveModify:
  SR_Engine_SaveModify()
return  
SR_Engine_SaveModify()
{
  Global SRE_GUIName,SRE_DDL_Method,SRE_Button_Save,SRE_SaveObject
  If not Isobject(SRE_SaveObject)
    SRE_SaveObject := []
  GUI,%SRE_GUIName%:Default
  GUIControlGet,choose,,%SRE_DDL_Method%
  SRE_SaveObject[(idx:=LV_GetNext(0,"Focus"))?idx:1] := SR_Engine_ShowTab%choose%_Save()
  GUIControl, Disable, %SRE_Button_Save%
}
; SR_Engine_LV: {{{1
SR_Engine_LV:
  If A_GUIEvent = Normal
  {
    GUI,%SRE_GUIName%:Default
    GUIControlGet,choose,,%SRE_DDL_Method%
    obj := SRE_SaveObject[A_EventInfo]
    choose := SRE_Array_method[m:=obj["method"]]
    SR_Engine_ShowTab%choose%_Load(obj)
  }
return
; SR_Engine_ChangeUI {{{1
SR_Engine_ChangeUI:
  SR_Engine_ChangeUI()
return
SR_Engine_ChangeUI()
{
  Global SRE_GUIName,SRE_DDL_Method
  GUI,%SRE_GUIName%:Default
  GUIControlGet,choose,,%SRE_DDL_Method%
  SR_Engine_HideControl()
  SR_Engine_ShowTab%choose%()
}
; SR_Engine_HideControl() {{{2
SR_Engine_HideControl(idx=0)
{
  Global SRE_GUIName
  GUI,%SRE_GUIName%:Default
  Loop,16
  {
  	If A_Index = %idx%
  	{
  		GUIControl,Show,SysTabControl32%A_Index%
  		continue
  	}
  	GUIControlGet, v, Visible, SysTabControl32%A_Index%
  	If v
  	    GUIControl,Hide,SysTabControl32%A_Index%
  }


}
; SR_Engine_ShowTab1() {{{2
SR_Engine_ShowTab1()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  SR_Engine_HideControl(1)
  GUIControl,,%SRE_Text_Main%,执行指定的程序或打开文件/文件夹。
}
; SR_Engine_ShowTab1_Save() {{{2
SR_Engine_ShowTab1_Save()
{
  Global SRE_GUIName
        ,SRE_Tab1_Edit1,SRE_Tab1_Edit2,SRE_Tab1_Edit3,SRE_Tab1_DDL
  v := yaml("",0)
  v.add("Method: Run")
  v.add("File: ")
  v.add("Param: ")
  v.add("WorkingDir: ")
  v.add("State: ")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,file,,%SRE_Tab1_Edit1%
  GUIControlGet,Param,,%SRE_Tab1_Edit2%
  GUIControlGet,WorkingDir,,%SRE_Tab1_Edit3%
  GUIControlGet,State,,%SRE_Tab1_DDL%
  v.file := file
  v.Param := Param
  v.WorkingDir := WorkingDir
  v.State := State-1
  return v
}
SR_Engine_ShowTab1_Load(object)
{
  Global SRE_GUIName,SRE_DDL_Method
        ,SRE_Tab1_Edit1,SRE_Tab1_Edit2,SRE_Tab1_Edit3,SRE_Tab1_DDL
  SR_Engine_ShowTab1()
  GUI,%SRE_GUIName%:Default
  GUIControl,Choose,%SRE_DDL_Method%,1
  file := object.file
  Param := object.Param
  WorkingDir := object.WorkingDir
  State := object.State +1
  GUIControl,,%SRE_Tab1_Edit1%,%file%
  GUIControl,,%SRE_Tab1_Edit2%,%Param%
  GUIControl,,%SRE_Tab1_Edit3%,%WorkingDir%
  GUIControl,Choose,%SRE_Tab1_DDL%,%State%
}
; SR_Engine_ShowTab2() {{{2
SR_Engine_ShowTab2()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,执行指定的程序或打开文件/文件夹，并等待。
  SR_Engine_HideControl(1)
}
; SR_Engine_ShowTab2_Save() {{{2
SR_Engine_ShowTab2_Save()
{
  Global SRE_GUIName
        ,SRE_Tab1_Edit1,SRE_Tab1_Edit2,SRE_Tab1_Edit3,SRE_Tab1_DDL
  v := yaml("",0)
  v.add("Method: RunWait")
  v.add("File: ")
  v.add("Param: ")
  v.add("WorkingDir: ")
  v.add("State: ")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,file,,%SRE_Tab1_Edit1%
  GUIControlGet,Param,,%SRE_Tab1_Edit2%
  GUIControlGet,WorkingDir,,%SRE_Tab1_Edit3%
  GUIControlGet,State,,%SRE_Tab1_DDL%
  v.file := file
  v.Param := Param
  v.WorkingDir := WorkingDir
  v.State := State-1
  return v
}
; SR_Engine_ShowTab2_Load(Object) {{{2
SR_Engine_ShowTab2_Load(object)
{
	  Global SRE_GUIName,SRE_DDL_Method
        ,SRE_Tab1_Edit1,SRE_Tab1_Edit2,SRE_Tab1_Edit3,SRE_Tab1_DDL
      SR_Engine_ShowTab2()
      GUI,%SRE_GUIName%:Default
      GUIControl,Choose,%SRE_DDL_Method%,2
      file := object.file
      Param := object.Param
      WorkingDir := object.WorkingDir
      State := object.State +1
      GUIControl,,%SRE_Tab1_Edit1%,%file%
      GUIControl,,%SRE_Tab1_Edit2%,%Param%
      GUIControl,,%SRE_Tab1_Edit3%,%WorkingDir%
      GUIControl,Choose,%SRE_Tab1_DDL%,%State%
}
; SR_Engine_ShowTab3() {{{2
SR_Engine_ShowTab3()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,根据指定窗口类或窗口标题激活窗口。
  SR_Engine_HideControl(2)
}
; SR_Engine_ShowTab3_Save() {{{2
SR_Engine_ShowTab3_Save()
{
  Global SRE_GUIName
        ,SRE_Tab2_Edit1,SRE_Tab2_Edit2,SRE_Tab2_Edit3,SRE_Tab2_Button
  v := yaml("",0)
  v.add("Method: WinActivate")
  v.add("Class: ")
  v.add("Title: ")
  v.add("Fuzzy: false")
  v.add("Wait: 0")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,class,,%SRE_Tab2_Edit1%
  GUIControlGet,title,,%SRE_Tab2_Edit2%
  GUIControlGet,wait,,%SRE_Tab2_Edit3%
  GUIControlGet,Fuzzy,,%SRE_Tab2_Button%
  v.Class := Class
  v.Title := Title
  v.Fuzzy := Fuzzy
  v.Wait := Wait
  return v
}
; SR_Engine_ShowTab3_Load(Object) {{{2
SR_Engine_ShowTab3_Load(object)
{
	  Global SRE_GUIName,SRE_DDL_Method
            ,SRE_Tab2_Edit1,SRE_Tab2_Edit2,SRE_Tab2_Edit3,SRE_Tab2_Button
      SR_Engine_ShowTab3()
      GUI,%SRE_GUIName%:Default
      GUIControl,Choose,%SRE_DDL_Method%,3
      GUIControl,,%SRE_Tab2_Edit1%,% Object.Class
      GUIControl,,%SRE_Tab2_Edit2% ,% Object.title
      GUIControl,,%SRE_Tab2_Edit3%,% Object.Wait
      GUIControl,,%SRE_Tab2_Button%,% Object.Fuzzy
}
; SR_Engine_ShowTab4() {{{2
SR_Engine_ShowTab4()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,设置当前窗口为指定的宽度和高度
  SR_Engine_HideControl(3)
}
; SR_Engine_ShowTab4_Save() {{{2
SR_Engine_ShowTab4_Save()
{
  Global SRE_GUIName
        ,SRE_Tab3_Edit1,SRE_Tab3_Edit2
  v := yaml("",0)
  v.add("Method: WinResize")
  v.add("Width: 0")
  v.add("Height: 0")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,w,,%SRE_Tab3_Edit1%
  GUIControlGet,h,,%SRE_Tab3_Edit2%
  v.Width := w
  v.Height := h
  return v
}
; SR_Engine_ShowTab5() {{{2
SR_Engine_ShowTab5()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,移动当前窗口到指定座标
  SR_Engine_HideControl(4)
}
; SR_Engine_ShowTab5_Save() {{{2
SR_Engine_ShowTab5_Save()

{
  Global SRE_GUIName
        ,SRE_Tab4_Edit1,SRE_Tab4_Edit2
  v := yaml("",0)
  v.add("Method: WinMove")
  v.add("x: 0")
  v.add("y: 0")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,w,,%SRE_Tab4_Edit1%
  GUIControlGet,h,,%SRE_Tab4_Edit2%
  v.x:= w
  v.y:= h
  return v
}
; SR_Engine_ShowTab6() {{{2
SR_Engine_ShowTab6()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,最大化指定窗口`n没有指定参数时最大化当前窗口
  SR_Engine_HideControl(5)
}
; SR_Engine_ShowTab6_Save() {{{2
SR_Engine_ShowTab6_Save()
{
  Global SRE_GUIName
        ,SRE_Tab5_Edit1,SRE_Tab5_Edit2,SRE_Tab5_Button
  v := yaml("",0)
  v.add("Method: WinMaximize")
  v.add("Class: ")
  v.add("Title: ")
  v.add("Fuzzy: false")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,class,,%SRE_Tab5_Edit1%
  GUIControlGet,title,,%SRE_Tab5_Edit2%
  GUIControlGet,Fuzzy,,%SRE_Tab5_Button%
  v.Class := Class
  v.Title := Title
  v.Fuzzy := Fuzzy
  return v
}
; SR_Engine_ShowTab7() {{{2
SR_Engine_ShowTab7()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,最小化指定窗口`n没有指定参数时最小化当前窗口
  SR_Engine_HideControl(6)
}
; SR_Engine_ShowTab7_Save() {{{2
SR_Engine_ShowTab7_Save()
{
  Global SRE_GUIName
        ,SRE_Tab6_Edit1,SRE_Tab6_Edit2,SRE_Tab6_Button
  v := yaml("",0)
  v.add("Method: WinMinimize")
  v.add("Class: ")
  v.add("Title: ")
  v.add("Fuzzy: false")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,class,,%SRE_Tab6_Edit1%
  GUIControlGet,title,,%SRE_Tab6_Edit2%
  GUIControlGet,Fuzzy,,%SRE_Tab6_Button%
  v.Class := Class
  v.Title := Title
  v.Fuzzy := Fuzzy
  return v
}
; SR_Engine_ShowTab8() {{{2
SR_Engine_ShowTab8()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,还原指定的窗口`n如果无指定内容则还原当前窗口
  SR_Engine_HideControl(7)
}
; SR_Engine_ShowTab8_Save() {{{2
SR_Engine_ShowTab8_Save()
{
  Global SRE_GUIName
        ,SRE_Tab7_Edit1,SRE_Tab7_Edit2,SRE_Tab7_Button
  v := yaml("",0)
  v.add("Method: WinRestore")
  v.add("Class: ")
  v.add("Title: ")
  v.add("Fuzzy: false")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,class,,%SRE_Tab7_Edit1%
  GUIControlGet,title,,%SRE_Tab7_Edit2%
  GUIControlGet,Fuzzy,,%SRE_Tab7_Button%
  v.Class := Class
  v.Title := Title
  v.Fuzzy := Fuzzy
  return v
}
; SR_Engine_ShowTab9() {{{2
SR_Engine_ShowTab9()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,设置/取消置顶指定窗口
  SR_Engine_HideControl(8)
}
; SR_Engine_ShowTab9_Save() {{{2
SR_Engine_ShowTab9_Save()
{
  Global SRE_GUIName
        ,SRE_Tab8_Edit1,SRE_Tab8_Edit8,SRE_Tab8_Button
  v := yaml("",0)
  v.add("Method: AlwaysOnTop")
  v.add("Class: ")
  v.add("Title: ")
  v.add("Fuzzy: false")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,class,,%SRE_Tab8_Edit1%
  GUIControlGet,title,,%SRE_Tab8_Edit2%
  GUIControlGet,Fuzzy,,%SRE_Tab8_Button%
  v.Class := Class
  v.Title := Title
  v.Fuzzy := Fuzzy
  return v
}
; SR_Engine_ShowTab10() {{{2
SR_Engine_ShowTab10()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,向指定窗口发送消息(SendMessage)。
  SR_Engine_HideControl(9)
}
; SR_Engine_ShowTab10_Save() {{{2
SR_Engine_ShowTab10_Save()
{
  Global SRE_GUIName
        ,SRE_Tab9_Edit1,SRE_Tab9_Edit2,SRE_Tab9_Buttnn,SRE_Tab9_Edit3,SRE_Tab9_Edit4,SRE_Tab9_Edit5
  v := yaml("",0)
  v.add("Method: SendMessage")
  v.add("Class: ")
  v.add("Title: ")
  v.add("Fuzzy: 0")
  v.add("Message: ")
  v.add("WParam: ")
  v.add("LParam: ")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,class,,%SRE_Tab9_Edit1%
  GUIControlGet,title,,%SRE_Tab9_Edit2%
  GUIControlGet,Fuzzy,,%SRE_Tab9_Button%
  GUIControlGet,msg,,%SRE_Tab9_Edit1%
  GUIControlGet,wp,,%SRE_Tab9_Edit2%
  GUIControlGet,lp,,%SRE_Tab9_Edit1%
  v.Class := Class
  v.Title := Title
  v.Fuzzy := Fuzzy
  v.Message := msg
  v.WParam := wp
  v.LParam := lp
  return v
}
; SR_Engine_ShowTab11() {{{2
SR_Engine_ShowTab11()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,向指定窗口提交消息(PostMessage)。
  SR_Engine_HideControl(10)
}
; SR_Engine_ShowTab11_Save() {{{2
SR_Engine_ShowTab11_Save()
{
  Global SRE_GUIName
        ,SRE_Tab10_Edit1,SRE_Tab10_Edit2,SRE_Tab10_Buttnn,SRE_Tab10_Edit3,SRE_Tab10_Edit4,SRE_Tab10_Edit5
  v := yaml("",0)
  v.add("Method: PostMessage")
  v.add("Class: ")
  v.add("Title: ")
  v.add("Fuzzy: 0")
  v.add("Message: ")
  v.add("WParam: ")
  v.add("LParam: ")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,class,,%SRE_Tab10_Edit1%
  GUIControlGet,title,,%SRE_Tab10_Edit2%
  GUIControlGet,Fuzzy,,%SRE_Tab10_Button%
  GUIControlGet,msg,,%SRE_Tab10_Edit1%
  GUIControlGet,wp,,%SRE_Tab10_Edit2%
  GUIControlGet,lp,,%SRE_Tab10_Edit1%
  v.Class := Class
  v.Title := Title
  v.Fuzzy := Fuzzy
  v.Message := msg
  v.WParam := wp
  v.LParam := lp
  return v
}
; SR_Engine_ShowTab12() {{{2
SR_Engine_ShowTab12()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,发送连续的热键
  SR_Engine_HideControl(11)
}
; SR_Engine_ShowTab12_Save() {{{2
SR_Engine_ShowTab12_Save()
{
  Global SRE_GUIName
        ,SRE_Tab11_Edit1
  v := yaml("",0)
  v.add("Method: Send")
  v.add("Hotkey: ")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,hks,,%SRE_Tab11_Edit1%
  v.Hotkey := hks
  return v
}
; SR_Engine_ShowTab13() {{{2
SR_Engine_ShowTab13()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,发送文本到当前窗口
  SR_Engine_HideControl(12)
}
; SR_Engine_ShowTab13_Save() {{{2
SR_Engine_ShowTab13_Save()
{
  Global SRE_GUIName
        ,SRE_Tab12_Edit1
  v := yaml("",0)
  v.add("Method: Input")
  v.add("String: ")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,str,,%SRE_Tab12_Edit1%
  v.String := str
  return v
}
; SR_Engine_ShowTab14() {{{2
SR_Engine_ShowTab14()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,模拟鼠标点击
  SR_Engine_HideControl(13)
}
; SR_Engine_ShowTab14_Save() {{{2
SR_Engine_ShowTab14_Save()
{
  Global SRE_GUIName
        ,SRE_Tab13_Edit1,SRE_Tab13_Edit2,SRE_Tab13_Edit3,SRE_Tab13_Edit4
  v := yaml("",0)
  v.add("Method: Click")
  v.add("x: ")
  v.add("y: ")
  v.add("count: ")
  v.add("key: ")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,x,,%SRE_Tab13_Edit1%
  GUIControlGet,y,,%SRE_Tab13_Edit2%
  GUIControlGet,c,,%SRE_Tab13_Edit3%
  GUIControlGet,k,,%SRE_Tab13_Edit4%
  v.x := x
  v.y := y
  v.count := c
  v.key := k
  return v
}
; SR_Engine_ShowTab15() {{{2
SR_Engine_ShowTab15()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,等待一段时间(单位为ms)
  SR_Engine_HideControl(14)
}
; SR_Engine_ShowTab15_Save() {{{2
SR_Engine_ShowTab15_Save()
{
  Global SRE_GUIName
        ,SRE_Tab14_Edit1
  v := yaml("",0)
  v.add("Method: Sleep")
  v.add("Time: ")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,t,,%SRE_Tab14_Edit1%
  v.Time := t
  return v
}
; SR_Engine_ShowTab16() {{{2
SR_Engine_ShowTab16()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,跳转到指定的Label
  SR_Engine_HideControl(15)
}
; SR_Engine_ShowTab16_Save() {{{2
SR_Engine_ShowTab16_Save()
{
  Global SRE_GUIName
        ,SRE_Tab15_Edit1
  v := yaml("",0)
  v.add("Method: Label")
  v.add("Sub: ")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,s,,%SRE_Tab15_Edit1%
  v.Sub := t
  return v
}
; SR_Engine_ShowTab17() {{{2
SR_Engine_ShowTab17()
{
  Global SRE_GUIName,SRE_Text_Main
  GUI,%SRE_GUIName%:Default
  GUIControl,,%SRE_Text_Main%,执行指定的函数
  SR_Engine_HideControl(16)
}
; SR_Engine_ShowTab17_Save() {{{2
SR_Engine_ShowTab17_Save()
{
  Global SRE_GUIName
        ,SRE_Tab16_Edit1
  v := yaml("",0)
  v.add("Method: Function")
  v.add("Name: ")
  GUI,%SRE_GUIName%:Default
  GUIControlGet,f,,%SRE_Tab16_Edit1%
  v.Name := f
  return v
}
; SR_Engine_Interpret(String,Save) {{{1
; 适用于Run/RunWait
; 解析内容,返回解析完成的新内容
SR_Engine_Interpret(String,Save,GoFunc=false,byRef Obj="")
{
/*
Save
  Hwnd:
  Class:
  Text:
  File:
  Type:
*/
  Global MZ_Return
  ; 替换变量
  RunString := ReplaceEnv(LTrim(string,">"))
  ; 判断类型并获取相应的内容
  SelectType := Save.Type 
  Hwnd := Save.Hwnd
  WinGet,pPath,ProcessPath,ahk_id %hwnd%
  If SelectType = 0
    Content := pPath
  If SelectType = 1
    Content := Save.File
  If SelectType = 2
    Content := Save.Text
  ; 开始进行判断所有的 {switch} 开关
  P1 := 1
	Loop
	{
		Pos := RegExMatch(RunString,"\{[^\{\}]*\}",switch,P1)
		If Pos
		{
			RtString := switch
      If RegExMatch(switch,"i)\{file[^\{\}]*\}") 
			{
				If RegExMatch(iGetFileType(Save.File),"i)^(\..*)|(Multifiles)|(Folder)$")
					RtString := fileswitch(content,switch)
				Else
					RtString := ""
			}
      If RegExMatch(switch,"i)\{select[^\{\}]*\}")
				RtString := selectswitch(content,switch)
      If RegExMatch(switch,"i)\{window[^\{\}]*\}")
        RtString := WindowSwitch(pPath,switch)
      If RegExMatch(switch,"i)\{box[^\{\}]*\}",box)
				RtString := boxswitch(box)
      If RegExMatch(switch,"i)\{date[^\{\}]*\}",date)
				RtString := dateswitch(date)
      If GoFunc
      {
			  If RegExMatch(switch,"i)\{func:([^\{\}]*)\}",Func)
			  {
          {
            RtString := ""
				    If Isfunc(Func1)
					    RtString := %Func1%()
            If IsLabel(Func1)
            {
              MZ_Return := ""
              GoSub,%Func1%
              RtString := MZ_Return
            }
          }
			  }
      }
      Else If RegExMatch(switch,"i)\{func:([^\{\}]*)\}")
        RtString := ""
      If RegExMatch(switch,"i)\{ps:([^\{\}]*)\}")
        RtString := ""
			P1 := Pos + Strlen(switch)
			RunString := SubStr(RunString,1,Pos-1) RtString Substr(RunString,P1)
			P1 := Pos + Strlen(RtString)
		}
		Else
			Break
	}
  obj["Method"] := "Run"
  obj["File"] := RunString
  Return RunString
}
; dateswitch(switch) {{{2
; 根据参数返回对应的时间
dateswitch(switch)
{
	If RegExMatch(switch,"\[(.*?)(?<!\\)\]",now)
	{
		If RegExMatch(now1,"^\w*$")
			now := now1
		Else
		{
			Now := A_now
			If RegExMatch(now1,"i)d\s*\+\s*(\d+)",d)
				now += d1 , d
			If RegExMatch(now1,"i)m\s*\+\s*(\d+)",m)
				now += d1 , m
			If RegExMatch(now1,"i)s\s*\+\s*(\d+)",s)
				now += d1 , s
		}
	}
	Else
		now := A_Now
	If RegExMatch(switch,"i)^\{date\}$")
		FormatTime, time , %now% ,yyyyMMdd
	Else
	{
		format := RegExReplace(RegExReplace(switch,"i)(^\{date:)|(\}$)"),"\[(.*?)(?<!\\)\]")
		If RegExMatch(format,"\w*")
			FormatTime, time , %now% ,%format%
	}
	return time
}

; boxswitch(switch) {{{2
; {box} 输入内容
; 提供一个简洁的界面给用户输入
boxswitch(switch)
{
  Global MZ_NotRun
	GUI,boxswitch:Destroy
	GUI,boxswitch:Font ,s9 ,Microsoft YaHei
	GUI,boxswitch:Default
	GUI,boxswitch:+hwndboxhandle
	Exist := 0
	
	; {box:input} {{{4
	If RegExMatch(switch,"i)^\{box:input")
	{
		If RegExMatch(switch,"\[>(.*?)(?<!\\)\]",tips)
		{
			tips := RegExReplace(RegExReplace(tips1,"\\\]","]"),"i)\\n","`n")
			GUI,boxswitch:Add,Edit,x10 y10 w400 h60 ReadOnly, %Tips%
		}
		Exist++
		If RegExMatch(switch,"\[\*\]")
			opt := "Password"
		GUI,boxswitch:Add,Edit, x10 w400 h24 R1 %opt%
		GUIControl, Focus , Edit2
		GUI,boxswitch:Add,Button,x120 w120 h26 default gGUI_boxswitch_EditOK, 确定(&O)
		GUI,boxswitch:Add,Button,x274 yp w120 h26 gGUI_boxswitch_Cancel, 取消(&C)
		title := MenuZ 输入内容
	}
	; {box:list} {{{4
	If RegExMatch(switch,"i)^\{box:list")
	{
		If RegExMatch(switch,"\[>(.*?)(?<!\\)\]",tips)
		{
			tips := RegExReplace(RegExReplace(tips1,"\\\]","]"),"i)\\n","`n")
			GUI,boxswitch:Add,Edit,x10 y10 w300 r1 ReadOnly, %Tips%
		}
		Exist++
		GUI,boxswitch:Add,Listview,x10 w300 h200 gGUI_boxswitch_ListViewOK , 序号|选项
		P1 := 1
		Loop
		{
			Pos := RegExMatch(switch,"\[[^>](.*?)(?<!\\)\]",opt,P1)
			If Pos
			{
				P1 := Pos + strlen(opt)
				LV_Add("",A_Index,RegExReplace(opt,"(^\[)|(\]$)"))
			}
			Else
				Break
		}
		GUI,boxswitch:Add,Button,x20 w120 h26 default gGUI_boxswitch_ListViewOK, 确定(&O)
		GUI,boxswitch:Add,Button,x174 yp w120 h26 gGUI_boxswitch_ListViewClose, 取消(&C)
		title := MenuZ 选择列表
	}
	If Exist
	{
		Box_OK := ""
		GUI,boxswitch:Show,xCenter yCenter,% title
    OnMessage(0x4e,"")
		WinWaitClose,ahk_id %boxhandle%
		return Box_OK
	}
	; {box:file} {{{4
	If RegExMatch(switch,"i)^\{box:file")
	{
		If RegExMatch(switch,"\[>(.*?)(?<!\\)\]",tips)
			tips := RegExReplace(RegExReplace(tips1,"\\\]","]"),"i)\\n","`n")
		Else
			tips := "MenuZ 选择文件"
		;opt := ""
		If RegExMatch(switch,"i)\[m\]")
			opt := "M35"
		Else If RegExMatch(switch,"i)\[s\]")
			opt := "S24"
		If RegExMatch(switch,"\[&(.*?)\*(?<!\\)\]",rootdir)
			rootdir := RegExReplace(rootdir1,"\\\]","]")
		Else
			SplitPath,SaveSelect,,rootdir
		If RegExMatch(switch,"\[#(.*?)(?<!\\)\]",filter)
			filter := RegExReplace(RegExReplace(filter1,"\\\]","]"),"i)\\n","`n")
		Else
			filter := ""
		FileSelectFile,Box_OK,%opt%,%rootdir%,%tips%,%filter%
		If opt = M35
		{
			Loop,Parse,Box_OK,`n
			{
				If not strlen(A_LoopField) 
					continue
				If A_Index = 1
					dir := A_LoopField
				Else
					newTemp .= dir "\" A_LoopField "`n"
			}
			If RegExMatch(switch,"i)\[(file:.*)\]",file)
			{
				file := "{" file1 "}"
				Box_OK := fileswitch(newTemp,file)
			}
			Else
				Box_OK := newTemp
		}
		return Box_OK
	}
	; {box:dir} {{{4
	If RegExMatch(switch,"i)^\{box:dir")
	{
		If RegExMatch(switch,"\[>(.*?)(?<!\\)\]",tips)
			tips := RegExReplace(RegExReplace(tips1,"\\\]","]"),"i)\\n","`n")
		Else
			tips := "MenuZ 选择文件夹"
		If RegExMatch(switch,"\[&(.*?)\*(?<!\\)\]",rootdir)
			rootdir := RegExReplace(rootdir1,"\\\]","]")
		Else
			SplitPath,SaveSelect,,rootdir
		FileSelectFolder, Box_OK, %rootdir%, 3, %tips%
	}
  return

	GUI_boxswitch_EditOK:
		GuiControlGet, vis, Visible,Edit2
		If vis
			GUIControlGet,Box_OK,,Edit2
		Else
			GUIControlGet,Box_OK,,Edit1
		GUI,boxswitch:Destroy
	return
	GUI_boxswitch_Cancel:
    MZ_NotRun := true
		GUI,boxswitch:Destroy
  return
	GUI_boxswitch_ListViewOK:
		If A_GuiEvent = DoubleClick
		{
      If not A_EventInfo
        return
			If ( idx := A_EventInfo)
				LV_GetText(Box_OK,idx,2)
			GUI,boxswitch:Destroy
		}
    Else If Not A_EventInfo
    {
			If ( idx := LV_GetNext())
				LV_GetText(Box_OK,idx,2)
			GUI,boxswitch:Destroy
    }
	return
	GUI_boxswitch_ListViewClose:
    MZ_NotRun := true
	  GoSub,boxswitchGUIClose
  return
	boxswitchGUIClose:
		GUI,boxswitch:Destroy
    OnMessage(0x4e,"TV_WM_NOTIFY")
	return
}

; selectswitch(select,switch) {{{2
; {select} 选择内容
selectswitch(select,switch)
{
  RtString := select
	If RegExMatch(switch,"\[@(.*?)(?<!\\)\]",RegExSelect)
	{
		RegExSelect:= RegExReplace(RegExSelect1,"\\\]","]")
		RegExMatch(select,RegExSelect,RtString)
	}
	If RegExMatch(switch,"\[(?<!@)(.*?)(?<!\\)\]",RegExEncode)
	{
		Encode := RegExReplace(RegExEncode1,"\\\]","]")
		RtString := SksSub_UrlEncode(select,Encode)
	}
	Return RtString
}

; SksSub_UrlEncode(string, enc="UTF-8") {{{4
; 来自万年书妖的Candy里的函数，用于转换编码。感谢！
SksSub_UrlEncode(string, enc="UTF-8")
{   ;url编码
    enc:=trim(enc)
    If enc=
        Return string
	If Strlen(String) > 200
		string := Substr(string,1,200)
    formatInteger := A_FormatInteger
    SetFormat, IntegerFast, H
    VarSetCapacity(buff, StrPut(string, enc))
    Loop % StrPut(string, &buff, enc) - 1
    {
        byte := NumGet(buff, A_Index-1, "UChar")
        encoded .= byte > 127 or byte <33 ? "%" Substr(byte, 3) : Chr(byte)
    }
    SetFormat, IntegerFast, %formatInteger%
    return encoded
}


; fileSwitch(FileList,switch) {{{2
; 非常复杂的文件参数，需要时间学习
fileSwitch(FileList,switch){
    If Strlen(switch) And RegExMatch(switch,"^\{.*\}$")
        Temp := switch
    Else
        Return switch
    If RegExMatch(switch,"i)^\{file\}$",m)
    OR RegExMatch(switch,"i)^\{file:((path)|(name)|(dir)|(ext)|(namenoext)|(drive)|(ver))\}$",m)
    OR RegExMatch(switch,"i)^\{file:size(\[[KMG]B\])?\}",m)
    OR RegExMatch(switch,"i)^\{file:time(\[[MAC]\])?\}",m)
;    OR RegExMatch(switch,"i)^\{file:content(\[((uft-(8|16)(-raw)?)|(cp\d{1,5}))\])?\}",m) {
    OR RegExMatch(switch,"i)^\{file:content(\[((cp\d{1,5})|(utf-(8|16))(-raw)?)\])?\}",m) {
        Loop,Parse,FileList,`n,`r
        {
            m := mFileGetAttrib(A_LoopField,"fn,fd,fe,fo,ff,v")
            If RegExMatch(switch,"i)^\{file\}$") Or RegExMatch(switch,"i)^\{file:path\}$"){
                nSwitch := A_LoopField
                break
            }
            If RegExMatch(switch,"i)^\{file:name\}$") {
                nSwitch := m["fn"]
                break
            }
            If RegExMatch(switch,"i)^\{file:dir\}$") {
                nSwitch := m["ff"]
                break
            }
            If RegExMatch(switch,"i)^\{file:ext\}$") {
                nSwitch := m["fe"]
                break
            }
            If RegExMatch(switch,"i)^\{file:namenoext\}$") {
                nSwitch := m["fo"]
                break
            }
            If RegExMatch(switch,"i)^\{file:drive\}$") {
                nSwitch := m["fd"]
                break
            }
            If RegExMatch(switch,"i)^\{file:ver\}$") {
                nSwitch := m["v"]
                break
            }
            If RegExMatch(switch,"i)^\{file:size(\[[kmg]b\])?\}$",m) {
                Units := SubStr(m,12,strlen(m)-14)
                m := mFileGetAttrib(A_LoopField,"sb,sk,sm,sg")
                If Strlen(Units) = 0
                    nSwitch := m["sb"]
                Else If InStr(Units,"k")
                    nSwitch := m["sk"]
                Else If InStr(Units,"m")
                    nSwitch := m["sm"]
                Else If InStr(Units,"g")
                    nSwitch := m["sg"]
                Else
                    nSwitch := m["sb"]
                break
            }
            If RegExMatch(switch,"i)^\{file:time(\[[mac]\])?\}$",m) {
                WhichTime := SubStr(m,12,strlen(m)-13)
                If Instr("mac",WhichTime) {
                    FileGetTime,nSwitch,%A_LoopField%,%WhichTime%
                    Break
                }
                FileGetTime,nSwitch,%A_LoopField%
                break
            }
            If RegExMatch(switch,"i)^\{file:content(\[[^\[\]]*\])?\}$",m) {
                If InStr(FileExist(A_LoopField),"D")
                    nSwitch := ""
                Else {
                    Encode := SubStr(m,15,strlen(m)-16)
                    SaveEncode := A_FileEncoding
                    FileEncoding, %Encode%
                    FileRead,nSwitch,%A_LoopField%
                    FileEncoding, %SaveEncode%
                }
                Break
            }
            Break
        }
        Return nSwitch
    }
    Else {
        co_Regex := ""
        co_Index := ""
        co_Equal := ""
        co_Unequ := ""
        co_Folder := ""
        co_File  := ""
        co_Char  := 0

        If RegExMatch(switch,"\[@.*?(?<!\\)\]",co_Regex) {
            Temp := RegexReplace(Temp,ToMatch(co_Regex))
            co_Regex := EscapeSwitch(SubStr(co_Regex,3,Strlen(co_Regex)-3))
        }
        If RegExMatch(switch,"\[<\d*\]",co_Char) {
            Temp := RegexReplace(Temp,ToMatch(co_Char))
            co_Char := Substr(co_Char,3,Strlen(co_Char)-3)
        }
        If RegExMatch(switch,"\[%[\d,-]*\]",idx) {
            ; [1,2-4,5,6,7]
            Temp := RegexReplace(Temp,ToMatch(idx))
            co_Index := ","
            idx := EscapeSwitch(SubStr(idx ,3,Strlen(idx)-3))
            If Instr(idx,",") OR InStr(idx,"-") {
                Loop,Parse,Idx,`,
                {
                    If RegExMatch(A_LoopField,"\d*-\d*",lidx)
                    {
                        N1 := Substr(lidx,1,Instr(A_LoopField,"-")-1)
                        N2 := SubStr(lidx, InStr(A_LoopField,"-")+1)
                        co_Index .= N1 ","
                        Loop % ( N2 - N1 )
                            co_Index .= (A_Index + N1 ) ","
                    }
                    Else
                        co_Index .= A_LoopField ","
                }
            }
            Else
                co_Index .= Idx ","
        }
        If RegExMatch(switch,"\[!.*?(?<!\\)\]",Ex) {
            Temp := RegexReplace(Temp,ToMatch(Ex))
            Ex := EscapeSwitch(SubStr(Ex,3,Strlen(Ex)-3))
            If Instr(Ex,"|") {
                Loop,Parse,Ex,|
                    co_Unequ .= "(" RegExReplace(RegExReplace(A_LoopField,"\s"),"\+|\?|\.|\*|\{|\}|\(|\)|\||\[|\]|\\","\$0") ")|"
                co_Unequ := "i)" SubStr(co_Unequ,1,Strlen(co_Unequ)-1)
            }
            Else
                co_Unequ := "i)" Ex
        }
        If RegExMatch(switch,"\[=.*?(?<!\\)\]",Ix) {
            Temp := RegexReplace(Temp,ToMatch(Ix))
            Ix := EscapeSwitch(SubStr(Ix,3,Strlen(Ix)-3))
            If InStr(Ix,"|") {
                Loop,Parse,Ix,|
                    co_Equal .= "(" RegExReplace(RegExReplace(A_LoopField,"\s"),"\+|\?|\.|\*|\{|\}|\(|\)|\||\[|\]|\\","\$0") ")|"
                co_Equal := "i)" SubStr(co_Equal,1,Strlen(co_Equal)-1)
            }
            Else
                co_Equal := "i)" Ix
        }
        If RegExMatch(switch,"i)\[OF\]") {
            Temp := RegexReplace(Temp,"i)\[OF\]")
            co_File := True
        }
        If RegExMatch(switch,"i)\[OD\]") {
            Temp := RegexReplace(Temp,"i)\[OD\]")
            co_Folder := True
        }
        LoopListCount := 0
        Loop,Parse,FileList,`n,`r
        {
            AddLine := True
            m := mFileGetAttrib(A_LoopField,"n")
            If co_Regex And (Not RegExMatch(A_LoopField,co_Regex) )
                AddLine := False
            If co_Index And (Not InStr(co_Index,"," A_Index ",") )
                AddLine := False
            If co_Equal And (Not RegExMatch(m["n"],co_Equal) )
                AddLine := False
            If co_Unequ And RegExMatch(m["n"],co_Unequ)
                AddLine := False
            If co_File  And InStr(FileExist(A_LoopField),"D")
                AddLine := False
            If co_Folder And (Not InStr(FileExist(A_LoopField),"D"))
                AddLine := False
            If AddLine {
                LoopList .= A_LoopField "`n"
                LoopListCount++
            }
        }
        Temp := SubStr(Temp,7,Strlen(Temp)-7)
        Loop,Parse,LoopList,`n
        {
            If Strlen(A_LoopField) = 0
                Continue
            LoopListIndex := A_Index
            m := mFileGetAttrib(A_LoopField,"fn,ff,fe,fo,fd")
            r := ""
            P1 := 1
            Loop
            {
                P2 := RegExMatch(Temp,"\[((P)|(F)|(N)|(n)|(E)|(e)|(CR)|(TAB)|(I)|(II)|(C)|(D)|(d)|(M)|(m)|(Y)|(h)|(s)|(t)|(#.*?(?<!\\)))\]",s,P1)
                If P2
                {
                    Loop
                    {
                        If RegExMatch(s,"\[P\]") {
                            RString := A_LoopField
                            Break
                        }
                        If RegExMatch(s,"\[F\]") {
                            RString := m["ff"]
                            Break
                        }
                        If RegExMatch(s,"\[N\]") {
                            RString := m["fn"]
                            Break
                        }
                        If RegExMatch(s,"\[E\]") {
                            RString := m["fe"]
                            Break
                        }
                        If RegExMatch(s,"\[n\]") {
                            RString := m["fo"]
                            Break
                        }
                        If RegExMatch(s,"\[e\]") {
                            RString := m["fd"]
                            Break
                        }
                        If RegExMatch(s,"\[CR\]") {
                            RString := "`r`n"
                            Break
                        }
                        If RegExMatch(s,"\[Tab\]") {
                            RString := A_Tab
                            Break
                        }
                        If RegExMatch(s,"\[I\]") {
                            RString := LoopListIndex
                            Break
                        }
                        If RegExMatch(s,"\[II\]") {
                            Index := ""
                            If Strlen(LoopListIndex) < Strlen(LoopListCount) {
                                Loop, % strlen(LoopListCount) - strlen(LoopListIndex)
                                    Index .= "0"
                                Index .= LoopListIndex
                            }
                            Else
                                Index := LoopListIndex
                            RString := Index
                            Break
                        }
                        If RegExMatch(s,"\[C\]") {
                            RString := LoopListCount
                            Break
                        }

                        If RegExMatch(s,"\[d\]") {
                            RString := A_YYYY "-" A_MM "-" A_DD
                            Break
                        }

                        If RegExMatch(s,"\[t\]") {
                            RString := A_Hour A_Min A_Sec
                            Break
                        }

                        If RegExMatch(s,"\[Y\]") {
                            RString := A_YYYY
                            Break
                        }
                        If RegExMatch(s,"\[M\]") {
                            RString := A_MM
                            Break
                        }
                        If RegExMatch(s,"\[D\]") {
                            RString := A_DD
                            Break
                        }
                        If RegExMatch(s,"\[h\]") {
                            RString := A_Hour
                            Break
                        }
                        If RegExMatch(s,"\[m\]") {
                            RString := A_Min
                            Break
                        }
                        If RegExMatch(s,"\[s\]") {
                            RString := A_Sec
                            Break
                        }
                        If RegExMatch(s,"\[#.*?(?<!\\)\]",Exten) {
                            Exten := SubStr(Exten,3,Strlen(Exten)-3)
                            If Isfunc(Exten)
                                RString := %Exten%()
                            Else
                                RString := ""
                            Break
                        }

                    }
                }
                Else {
                    If P1 > 1
                        r .= Over
                    Else
                        r := Temp
                    Break
                }
                Inter := Substr(Temp,P1,P2-P1)
                P1 := P2 + Strlen(s)
                Over  := Substr(Temp,P1)
                r .= Inter RString
            }
            k .= r
        }
        co_Char := co_Char ? co_Char : 0
        return SubStr(k,1,Strlen(k) - co_Char)
    }
}
; iGetFileType(file) {{{3
iGetFileType(file,dot="."){
	If InStr(file,"`n") ;多文件
		Return "MultiFiles"
	Else
	{
		If RegExMatch(file,"[a-zA-Z]:\\$")
			Return "Drive"
		Else
		{
			Attrib := FileExist(file)
			If InStr(Attrib,"D")
				Return "Folder"
			Else
			{
				SplitPath,file,,,ext
				If strlen(ext)
					Return dot ext
				Else
					Return "NoExt"
			}
		}
	}
}
; 获取文件的属性
; type 的设置
; f 相当于Splitpath, 返回名称、目录、扩展名、驱动器
;   fn 文件名
;   ff 文件目录
;   fe 文件拓展名
;   fo 文件不事拓展名的名称
;   fd 驱动器
; a 相当于FileGetAttrib，返回字符串 "RASHNDOCT" 中部分字母组成的子集
; s 相当于FileGetSize ，返回文件大小 , s/sb sk sm 分别代表返回字节大小、返回千字节大小，返回兆字节大小，默认字节
; t 相当于FileGetTime , 返回文件的时间，t/tm tc ta 分别代表修改时间，创建时间，上次访问时间
; v 相当于FileGetVersion ，返回文件的版本
; l 相当于FileGetShortcut ，返回快捷方式的属性 ,
;   lt  用来存储快捷方式目标的变量名 (不包含它可能含有的任何参数). 例如: C:\WINDOWS\system32\notepad.exe
;   lf  用来保存快捷方式工作目录的变量名. 例如: C:\My Documents. 如果在字符串中存在像 %WinDir% 这样的环境变量, 那么解决它们的一种方法是使用
;   la  用来保存快捷方式参数的变量名 (如果没有则为空).
;   ld  用来保存快捷方式注释的变量名 (如果没有则为空).
;   li  用来保存快捷方式图标文件名的变量名 (如果没有则为空).
;   ln  用来保存快捷方式图标在图标文件中编号的变量名 (如果没有则为空). 这个值通常为 1, 表示首个图标.
;   lr  用来存储快捷方式初始运行方式的变量名, 其值为下列数字的其中一个: 1: 普通 3: 最大化 7: 最小化
; n 获取文件名/文件夹名
; mFileGetAttrib(file,type) {{{3
mFileGetAttrib(file,type){
    If Not FileExist(file) {
        ErrorLevel := True
        Return
    }
    If RegExMatch(type,"(`,f)|^f") {
        SplitPath, file, fn, ff, fe, fo, fd
        fd .= "\"
    }
    If RegExMatch(type,"(`,l)|^l") And RegExmatch(file,"i)\.lnk$")
        FileGetShortcut,%file%,lt,lf,la,ld,li,ln,lr
    If RegExMatch(type,"(`,a)|^a")
        FileGetAttrib, a, %file%
    If RegExMatch(type,"(`,s)|^s") {
        FileGetSize, s, %file%
        sb := s
        sk := Round((sb/1024))
        sm := Round((sk/1024))
        sg := Round((sm/1024))
        ;FileGetSize, sk, %file% ,k
        ;FileGetSize, sm, %file% ,m
    }
    If RegExMatch(type,"(`,t)|^t") {
        FileGetTime, t, %file% , m
        FormatTime , t , %t% , yyyy年MM月dd日 HH:mm:ss
        tm := t
        FileGetTime, tc, %file% , c
        FileGetTime, ta, %file% , a
    }
    If RegExMatch(type,"(`,v)|^v") {
        FileGetVersion, v, %file%
    }
    If RegExMatch(type,"(`,n)|^n") {
        If InStr(FileExist(file),"D")  {
            Loop,Parse,file
            {
                If RegExMatch(Substr(file,1-A_Index,1),"\\")
                {
                    n:= Substr(file,Strlen(file)-A_index+2)
                    Break
                }
            }
        }
        Else
            Splitpath,file,n
    }
    r := []
    Loop,Parse,Type,`,
        r[A_LoopField] := %A_LoopField%
    return r
}
; WindowSwitch(f,switch) {{{2
WindowSwitch(f,switch)
{
  Splitpath,f,filename,dir,,namenoext,drive
  If RegExMatch(switch,"i)\{window:file\}")
    return filename
  If RegExMatch(switch,"i)\{window:dir\}")
    return dir
  If RegExMatch(switch,"i)\{window:name\}")
    return namenoext
  If RegExMatch(switch,"i)\{window:drive\}")
    return drive
}
; EscapeSwitch(switch) {{{2
; 转义
EscapeSwitch(switch){
    ;switch := RegExReplace(switch,"(^\{)|(\}$)")
    switch := RegExReplace(switch,"\\(?=[\[\]\{\}])")
    return switch
}

; SR_Engine_Exec() {{{1
; 此函数负责执行配置
; Object: 保存配置内容，根据设置执行对应的功能
SR_Engine_Exec(Object)
{
  Global SR_Save
  If not Isobject(SR_Save)
    SR_Save := []
  If RegExMatch(Object.Method,"i)^Run$")
  {
    Target := Object.file " " Object.Param
    wDir := Object.WorkingDir
    If Object.State = 1
      Run,%Target%,%wDir%,Min UseErrorLevel
    Else If Object.State = 2
      Run,%Target%,%wDir%,Max UseErrorLevel
    Else If Object.State = 3
      Run,%Target%,%wDir%,Hide UseErrorLevel
    Else
      Run,%Target%,%wDir%,UseErrorLevel
  }
  If RegExMatch(Object.Method,"i)^RunWait$")
  {
    Target := Object.file " " Object.Param
    wDir := Object.WorkingDir
    If Object.State = 1
      RunWait,%Target%,%wDir%,Min UseErrorLevel
    Else If Object.State = 2
      RunWait,%Target%,%wDir%,Max UseErrorLevel
    Else If Object.State = 3
      RunWait,%Target%,%wDir%,Hide UseErrorLevel
    Else
      RunWait,%Target%,%wDir%,UseErrorLevel
  }
  If RegExMatch(Object.Method,"i)^WinActivate$")
  {
    If Strlen(c:=Object.Class)
    {
      If (s:=Object.Wait)
        WinWait,ahk_class %c%,,%s%
      WinActivate,ahk_class %c%
    }
    Else
    {
      If Object.Fuzzy
      {
        TMM := A_TitleMatchMode
        SetTitleMatchMode, 2
      }
      t := Object.Title
      If (s:=Object.Wait)
        WinWait,%t%,,%s%
      WinActivate,%t%
      If Object.Fuzzy
        SetTitleMatchMode, %TMM%
    }
  }
  If RegExMatch(Object.Method,"i)^WinMaximize$")
  {
    If Strlen(c:=Object.Class)
      WinMaximize,ahk_class %c%
    Else
    {
      If Object.Fuzzy
      {
        TMM := A_TitleMatchMode
        SetTitleMatchMode, 2
      }
      t := Object.Title
      If strlen(t)
        WinMaximize,%t%
      Else
        WinMaximize,A
      If Object.Fuzzy
        SetTitleMatchMode, %TMM%
    }
  }
  If RegExMatch(Object.Method,"i)^WinMinimize$")
  {
    If Strlen(c:=Object.Class)
      WinMinimize,ahk_class %c%
    Else
    {
      If Object.Fuzzy
      {
        TMM := A_TitleMatchMode
        SetTitleMatchMode, 2
      }
      t := Object.Title
      If strlen(t)
        WinMinimize,%t%
      Else
        WinMinimize,A
      If Object.Fuzzy
        SetTitleMatchMode, %TMM%
    }
  }
  If RegExMatch(Object.Method,"i)^WinRestore$")
  {
    If Strlen(c:=Object.Class)
      WinRestore,ahk_class %c%
    Else
    {
      If Object.Fuzzy
      {
        TMM := A_TitleMatchMode
        SetTitleMatchMode, 2
      }
      t := Object.Title
      If strlen(t)
        WinRestore,%t%
      Else
        WinRestore,A
      If Object.Fuzzy
        SetTitleMatchMode, %TMM%
    }
  }
  If RegExMatch(Object.Method,"i)^WinResize$")
  {
    WinGet,hwnd,ID,A
    WinGetPos,SaveX,SaveY,SaveW,SaveH,ahk_id %hwnd%
    SR_Save[hwnd A_Tab "x"] := SaveX
    SR_Save[hwnd A_Tab "y"] := SaveY
    SR_Save[hwnd A_Tab "w"] := SaveW
    SR_Save[hwnd A_Tab "h"] := SaveH
    w := Object.Width
    h := Object.Height
    WinMove,ahk_id %hwnd%,,,, %w%, %h%
  }
  If RegExMatch(Object.Method,"i)^WinMove$")
  {
    WinGet,hwnd,ID,A
    WinGetPos,SaveX,SaveY,SaveW,SaveH,ahk_id %hwnd%
    SR_Save[hwnd A_Tab "x"] := SaveX
    SR_Save[hwnd A_Tab "y"] := SaveY
    SR_Save[hwnd A_Tab "w"] := SaveW
    SR_Save[hwnd A_Tab "h"] := SaveH
    x := Object.x
    y := Object.y
    WinMove,ahk_id %hwnd%,, %x%, %y%
  }
  If RegExMatch(Object.Method,"i)^AlwaysOnTop$")
  {
    If Strlen(c:=Object.Class)
      WinSet,AlwaysOnTop,Toggle,ahk_class %c%
    Else
    {
      If Object.Fuzzy
      {
        TMM := A_TitleMatchMode
        SetTitleMatchMode, 2
      }
      t := Object.Title
      If strlen(t)
        WinSet,AlwaysOnTop,Toggle,%t%
      Else
        WinSet,AlwaysOnTop,Toggle,A
      If Object.Fuzzy
        SetTitleMatchMode, %TMM%
    }
  }
  If RegExMatch(Object.Method,"i)^Input$")
  {
    string := Object.String
    SendRaw,%string%
  }
  If RegExMatch(Object.Method,"i)^Sleep$")
  {
    Time := Object.Time
    Sleep,%Time%
  }
  If RegExMatch(Object.Method,"i)^Click$")
  {
    Coordmode,Mouse,Screen
    x := Object.x
    y := Object.y
    key := Object.key
    count := Object.Count
    Click,%x%,%y%,%key%,%count%
  }
  If RegExMatch(Object.Method,"i)^Send$")
  {
    hks := Object.Hotkey
    Loop,Parse,hks,`n
    {
      If RegExMatch(A_LoopField,"^\{([\d]*)\}$",s)
        Sleep,%s1%
      Else
        Send,%A_LoopField%
    }
  }
  If RegExMatch(Object.Method,"i)^SendMessage$")
  {
    Msg := Object.Message
    wParam := Object.WParam
    lParam := Object.LParam
    If Strlen(c:=Object.Class)
      SendMessage, Msg , wParam, lParam, , ahk_class %c%
    Else
    {
      If Object.fuzzy
      {
        TMM := A_TitleMatchMode
        SetTitleMatchMode, 2
      }
      t := Object.Title
      If Strlen(t)
        SendMessage, Msg , wParam, lParam, , %t%
      Else
        SendMessage, Msg , wParam, lParam, , A
      If Object.fuzzy
        SetTitleMatchMode, %TMM%
    }
    
  }
  If RegExMatch(Object.Method,"i)^PostMessage$")
  {
    Msg := Object.Message
    wParam := Object.WParam
    lParam := Object.LParam
    If Strlen(c:=Object.Class)
      PostMessage, Msg , wParam, lParam, , ahk_class %c%
    Else
    {
      If Object.fuzzy
      {
        TMM := A_TitleMatchMode
        SetTitleMatchMode, 2
      }
      t := Object.Title
      If strlen(t)
        PostMessage, Msg , wParam, lParam, , %t%
      Else
        PostMessage, Msg , wParam, lParam, , A
      If Object.fuzzy
        SetTitleMatchMode, %TMM%
    }
  }
  If RegExMatch(Object.Method,"i)^AHK$")
  {
    return
  }
  If RegExMatch(Object.Method,"i)^Label$")
  {
    If IsLabel(Sub := Object.Sub)
      GoSub,%Sub%
  }
  If RegExMatch(Object.Method,"i)^Function$")
  {
    If Isfunc(name := Object.Name)
      %Name%()
  }
}
