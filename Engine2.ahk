;#Include Lib\MZ_API.ahk
;#Include Lib\Yaml.ahk
/*
 * ����MenuZ\GestureZ\VimDesktop����Ҫ����һ��ͳһ�Ĺ��ܿ�
 * 1������StrokeIt�������ɣ�����AHK������
 * 2���˹��ܿ���һ�����棬����������أ����㼯�ɵ�����������
 * 3���˹��ܿ��ǿ���չ�ģ�����ά����ʹ�õ�
 * 4���˹��ܿ�ʹ��yaml��Ϊ�����ļ��ı��桢��ȡ��ִ��
*/

/*
GUI,Test:+hwndaa
GUI,Test:Font, s9, Microsoft YaHei
SR_Engine_Load("Test",10)
SR_Engine_Show()
return
f1::
  SR_Engine_HideControl()
return
f2::
  n:=1
  SR_Engine_ShowTab%n%()
  SR_Engine_Exec(v:=SR_Engine_ShowTab1_Save())
return
*/
/*
WinGet,v,id,ahk_class Notepad
save := {"hwnd":v}
SR_Engine_Interpret("{window:dir}",Save)
*/

/*
����
SRE_GUIName: ���ܿ�����������㹦�ܿ�Ƕ��
SRE_Handle: ���ܿ�����Handle
SRE_Object: ���ܿ���汣�浽���ݣ������ݽṹ��
*/

/*
���ݽṹ:
Method: Run
  File: ''
  WorkingDir: ''
  Param: ''
  State: '0|1|2|3' 
--- 0Ϊ��������; 1Ϊ��С������; 2Ϊ�������; 3Ϊ��������

Method: RunWait
  File: ''
  WorkingDir: ''
  Param: ''
  State: '0|1|2|3' 
--- 0Ϊ��������; 1Ϊ��С������; 2Ϊ�������; 3Ϊ��������

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
Method: AlwayOnTop
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
  HK1: '{down 10}'
  HK2: '{s 30}'
  HK3: '+{TAB 4}'

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

�ݲ�֧�֣�
Method: AHK
  Script: ''
*/

; SR_Engine_Load(GUIName="SRE",y=10) {{{1
; �˺������ڼ��ؽ����
; ��Ҫ�ṩ�������ƣ�Ĭ��ΪSR_Engine
SR_Engine_Load(GUIName="SRE",yy=10)
{
  Global SRE_GUIName
        ,SRE_ListView_Step,SER_DDL_Method
        ,SRE_Tab1_Edit1,SRE_Tab1_Edit2,SRE_Tab1_Edit3,SRE_Tab1_DDL
  SRE_GUIName := GUIName
  CH := "����`n"
      . "���в��ȴ�"
  y := yy
  GUI,%SRE_GUIName%:+Delimiter`n
  GUI,%SRE_GUIName%:Add,ListView,w200 h400 x10  y%y% hwndSRE_ListView_Step, ����
  y+=5
  GUI,%SRE_GUIName%:Add,Text,w200 h28  x225 y%y% ,����(&D)��
  y-=2
  GUI,%SRE_GUIName%:Add,DDL,w200 h28 x285 y%y% hwndSRE_DDL_Methd r10 ,% CH
  y+=40
  GUI,%SRE_GUIName%:Add,Text,w260 h50 x225 y%y% border
  y+=5
  GUI,%SRE_GUIName%:Add,Text,w256 h40 x227 y%y% center
  y+=54
  GUI,%SRE_GUIName%:Add,Tab2,w300 h420 x210 y%y% Bottom buttons,Run
  GUI,%SRE_GUIName%:Add,GroupBox,w260 h280 x225 y%y%
  y+=16
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,�ļ�/�ļ���:(&E)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab1_Edit1
  y+=30
  GUI,%SRE_GUIName%:Add,Button,w90 h26 x285 y%y%,����ļ�(&F)
  GUI,%SRE_GUIName%:Add,Button,w90 h26 x385 y%y%,����ļ���(&D)
  y+=40
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,����:(&P)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab1_Edit2
  y+=35
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,����Ŀ¼:(&W)
  y+=20
  GUI,%SRE_GUIName%:Add,Edit,w240 h24 x235 y%y% hwndSRE_Tab1_Edit3
  y+=35
  GUI,%SRE_GUIName%:Add,Text,h26 x235 y%y%,���з�ʽ:(&M)
  y+=20
  GUI,%SRE_GUIName%:Add,DDL,w240 h26 x235 r4 y%y%  hwndSRE_Tab1_DDL,��������`n��С������`n�������`n��������
}

; SR_Engine_Show(option,title="StarRed Engine") {{{1
; �˺�����ʾ���ý���,���沢����Yaml��ʽ
SR_Engine_Show(option="",title="StarRed Engine")
{
  Global SRE_Object,SRE_GUIName
  SRE_Object := yaml("",False)
  GUI,%SRE_GUIName%:+hwndSRE_Handle
  GUI,%SRE_GUIName%:Show,w500 h420 %option%,%title%
}
; �����л� {{{1
; SR_Engine_HideControl() {{{2
SR_Engine_HideControl()
{
  Global SRE_GUIName
  GUI,%SRE_GUIName%:Default
  GUIControl,Hide,SysTabControl321
  GUIControl,Hide,SysTabControl322
}

; SR_Engine_ShowTab1() {{{2
SR_Engine_ShowTab1()
{
  Global SRE_GUIName
  GUI,%SRE_GUIName%:Default
  GUIControl,Show,SysTabControl321
}
; SR_Engine_ShowTab1_Save() {{{2
SR_Engine_ShowTab1_Save()
{
  Global SRE_Tab1_Edit1,SRE_Tab1_Edit2,SRE_Tab1_Edit3,SRE_Tab1_DDL
  v := yaml("",0)
  v.add("Method: Run")
  v.add("File: ")
  v.add("Param: ")
  v.add("WorkingDir: ")
  v.add("State: 2")
  v.file := "Notepad"
  return v
}

; SR_Engine_Interpret(String,Save) {{{1
; ������Run/RunWait
; ��������,���ؽ�����ɵ�������
SR_Engine_Interpret(String,Save,Func=False)
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
  ; �滻����
  RunString := ReplaceEnv(LTrim(string,">"))
  ; �ж����Ͳ���ȡ��Ӧ������
  SelectType := Save.Type 
  Hwnd := Save.Hwnd
  WinGet,pPath,ProcessPath,ahk_id %hwnd%
  If SelectType = 0
    Content := pPath
  If SelectType = 1
    Content := Save.File
  If SelectType = 2
    Content := Save.Text
  ; ��ʼ�����ж����е� {switch} ����
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
      If Func
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
  Return RunString
}
; dateswitch(switch) {{{2
; ���ݲ������ض�Ӧ��ʱ��
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
; {box} ��������
; �ṩһ�����Ľ�����û�����
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
		GUI,boxswitch:Add,Button,x120 w120 h26 default gGUI_boxswitch_EditOK, ȷ��(&O)
		GUI,boxswitch:Add,Button,x274 yp w120 h26 gGUI_boxswitch_Cancel, ȡ��(&C)
		title := MenuZ ��������
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
		GUI,boxswitch:Add,Listview,x10 w300 h200 gGUI_boxswitch_ListViewOK , ���|ѡ��
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
		GUI,boxswitch:Add,Button,x20 w120 h26 default gGUI_boxswitch_ListViewOK, ȷ��(&O)
		GUI,boxswitch:Add,Button,x174 yp w120 h26 gGUI_boxswitch_ListViewClose, ȡ��(&C)
		title := MenuZ ѡ���б�
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
			tips := "MenuZ ѡ���ļ�"
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
			tips := "MenuZ ѡ���ļ���"
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
; {select} ѡ������
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
; ��������������Candy��ĺ���������ת�����롣��л��
SksSub_UrlEncode(string, enc="UTF-8")
{   ;url����
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
; �ǳ����ӵ��ļ���������Ҫʱ��ѧϰ
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
;        Msgbox % LoopList
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
	If InStr(file,"`n") ;���ļ�
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
; ��ȡ�ļ�������
; type ������
; f �൱��Splitpath, �������ơ�Ŀ¼����չ����������
;   fn �ļ���
;   ff �ļ�Ŀ¼
;   fe �ļ���չ��
;   fo �ļ�������չ��������
;   fd ������
; a �൱��FileGetAttrib�������ַ��� "RASHNDOCT" �в�����ĸ��ɵ��Ӽ�
; s �൱��FileGetSize �������ļ���С , s/sb sk sm �ֱ�������ֽڴ�С������ǧ�ֽڴ�С���������ֽڴ�С��Ĭ���ֽ�
; t �൱��FileGetTime , �����ļ���ʱ�䣬t/tm tc ta �ֱ�����޸�ʱ�䣬����ʱ�䣬�ϴη���ʱ��
; v �൱��FileGetVersion �������ļ��İ汾
; l �൱��FileGetShortcut �����ؿ�ݷ�ʽ������ ,
;   lt  �����洢��ݷ�ʽĿ��ı����� (�����������ܺ��е��κβ���). ����: C:\WINDOWS\system32\notepad.exe
;   lf  ���������ݷ�ʽ����Ŀ¼�ı�����. ����: C:\My Documents. ������ַ����д����� %WinDir% �����Ļ�������, ��ô������ǵ�һ�ַ�����ʹ��
;   la  ���������ݷ�ʽ�����ı����� (���û����Ϊ��).
;   ld  ���������ݷ�ʽע�͵ı����� (���û����Ϊ��).
;   li  ���������ݷ�ʽͼ���ļ����ı����� (���û����Ϊ��).
;   ln  ���������ݷ�ʽͼ����ͼ���ļ��б�ŵı����� (���û����Ϊ��). ���ֵͨ��Ϊ 1, ��ʾ�׸�ͼ��.
;   lr  �����洢��ݷ�ʽ��ʼ���з�ʽ�ı�����, ��ֵΪ�������ֵ�����һ��: 1: ��ͨ 3: ��� 7: ��С��
; n ��ȡ�ļ���/�ļ�����
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
        FormatTime , t , %t% , yyyy��MM��dd�� HH:mm:ss
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
; ת��
EscapeSwitch(switch){
    ;switch := RegExReplace(switch,"(^\{)|(\}$)")
    switch := RegExReplace(switch,"\\(?=[\[\]\{\}])")
    return switch
}

; SR_Engine_Exec() {{{1
; �˺�������ִ������
; Object: �����������ݣ���������ִ�ж�Ӧ�Ĺ���
SR_Engine_Exec(Object)
{
  Global SR_Save
  If not Isobject(SR_Save)
    SR_Save := []
  If RegExMatch(Object.Method,"i)^Run$")
  {
    Target := Object.file Object.Param
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
    Target := Object.file Object.Param
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
      WinMaximize,%t%
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
      WinMinimize,%t%
      If Object.Fuzzy
        SetTitleMatchMode, %TMM%
    }
  }
  If RegExMatch(Object.Method,"i)^WinRestore$")
  {
    If Strlen(c:=Object.Class)
    {
      WinRestore,ahk_class %c%
      WinGet,hwnd,ID,ahk_class %c%
      x := SR_Save[hwnd A_Tab "x"]
      y := SR_Save[hwnd A_Tab "y"]
      w := SR_Save[hwnd A_Tab "w"]
      h := SR_Save[hwnd A_Tab "h"]
      WinMove,ahk_class %c%,, %x%, %y%, %w%, %h%
    }
    Else
    {
      If Object.Fuzzy
      {
        TMM := A_TitleMatchMode
        SetTitleMatchMode, 2
      }
      t := Object.Title
      WinRestore,%t%
      WinGet,hwnd,ID,%t%
      x := SR_Save[hwnd A_Tab "x"]
      y := SR_Save[hwnd A_Tab "y"]
      w := SR_Save[hwnd A_Tab "w"]
      h := SR_Save[hwnd A_Tab "h"]
      WinMove,%t%,, %x%, %y%, %w%, %h%
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
  If RegExMatch(Object.Method,"i)^AlwayOnTop$")
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
      WinSet,AlwaysOnTop,Toggle,%t%
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
    Loop
    {
      If Not Strlen(Object["HK" A_Index])
        Break
      s := Object["HK" A_Index]
      Send,%s%
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
      SendMessage, Msg , wParam, lParam, , %t%
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
      PostMessage, Msg , wParam, lParam, , %t%
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
