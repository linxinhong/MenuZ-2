#Include Lib\MZ_API.ahk
#Include Lib\Yaml.ahk
/*
 * 由于MenuZ\GestureZ\VimDesktop的需要，做一个统一的功能库
 * 1、类似StrokeIt里的命令集成，发挥AHK的优势
 * 2、此功能库有一个界面，可以允许加载，方便集成到三个程序中
 * 3、此功能库是可扩展的，方便维护和使用的
 * 4、此功能库使用yaml做为配置文件的保存、读取和执行
*/
GUI,Test:+hwndaa
SR_Engine_Load("Test",10)
SR_Engine_Show()
SR_Engine_HideControl()
return

TestGUIClose:
  GUI,Test:Destroy
  ;Msgbox % Yaml_Dump(SRE_Object,1)
return

/*
WinGet,v,id,ahk_class Notepad
save := {"hwnd":v}
SR_Engine_Interpret("{window:dir}",Save)
*/

/*
变量
SRE_GUIName: 功能库界面名，方便功能块嵌入
SRE_Handle: 功能库界面的Handle
SRE_Object: 功能库界面保存
*/

; SR_Engine_Load(GUIName="SRE",y=10) {{{1
; 此函数用于加载界面库
; 需要提供界面名称，默认为SR_Engine
SR_Engine_Load(GUIName="SRE",y=10)
{
  Global SRE_GUIName
         ,SRE_ListView_Step
         ,SRE_Button_Add,SRE_Button_Del,SRE_Button_Up,SRE_Button_Down
  SRE_GUIName := GUIName
  GUI,%SRE_GUIName%:Add,ListView,w484 h100 x10  y%y% hwndSRE_ListView_Step
  y+=110
  GUI,%SRE_GUIName%:Add,Button  ,w40  h26 x10  y%y% hwndSRE_Button_Add,Add
  GUI,%SRE_GUIName%:Add,Button  ,w40  h26 x60  y%y% hwndSRE_Button_Del,Del
  GUI,%SRE_GUIName%:Add,Button  ,w40  h26 x110 y%y% hwndSRE_Button_Up,Up
  GUI,%SRE_GUIName%:Add,Button  ,w40  h26 x160 y%y% hwndSRE_Button_Down,Down
  GUI,%SRE_GUIName%:Default
}

; SR_Engine_Show(option,title="StarRed Engine") {{{1
; 此函数显示配置界面,保存并返回Yaml格式
SR_Engine_Show(option="",title="StarRed Engine")
{
  Global SRE_Object,SRE_GUIName
  SRE_Object := yaml("",False)
  GUI,%SRE_GUIName%:+hwndSRE_Handle
  GUI,%SRE_GUIName%:Show,%option%,%title%
}


SR_Engine_HideControl()
{
  Global SRE_GUIName
         ,SRE_ListView_Step
         ,SRE_Button_Add,SRE_Button_Del,SRE_Button_Up,SRE_Button_Down
  GUI,%SRE_GUIName%:Default
  GuiControl,Hide,%SRE_ListView_Step%
  GuiControl,Hide,%SRE_Button_Add%
  GuiControl,Hide,%SRE_Button_Del%
  GuiControl,Hide,%SRE_Button_Up%
  GuiControl,Hide,%SRE_Button_Down%
}


; SR_Engine_Interpret() {{{1
; 适用于Run/RunWait
; 解析内容,返回解析完成的新内容
SR_Engine_Interpret(String,Save)
{
/*
Save
  Hwnd:
  Text:
  File:
  Type:
*/
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
			If RegExMatch(switch,"i)\{do:([^\{\}]*)\}",Func)
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
SR_Engine_Exec(Object,Level=1)
{
}


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

*/
