

#SingleInstance,force
CoordMode,Mouse,Screen
; MD_Load {{{1
Menu, Tray, Icon , %A_ScriptDir%\icons\menuz.icl, 1
wclip := new winClip
ppum := new pum(MD_GetPUMParams())
MZ_Conf_file := A_ScriptDir "\config.yaml"
If Not FileExist(MZ_Conf_file)
  FileCopy, %A_ScriptDir%\sample.yaml, %MZ_Conf_file%
conf  := yaml( MZ_Conf_file, IsFile:=True)
If not Isobject(conf.menu_default)
  conf.Add("menu_default: ")
menu_default_check := {"Any":false,"AnyFile":false,"AnyText":false,"AnyClass":false}
Loop, % conf.menu_default.()
  menu_default_check[conf.menu_default.(A_Index).name] := true
For i , k in menu_default_check
  If not k 
    conf.menu_default.add("- {name: " i "}")

If not Isobject(conf.menu_text)
  conf.Add("menu_text: ")
If not Isobject(conf.menu_text)
  conf.Add("menu_text: ")
If not Isobject(conf.menu_class)
  conf.Add("menu_class: ")
If not Isobject(conf.menu_file)
  conf.Add("menu_file: ")

MZ_GUI_SaveConfig()
INIWrite,%A_Scripthwnd%,%A_Temp%\mzc,auto,hwnd
OnMessage(0x4a, "MD_Command")
for i , k in conf.hotkey
  Hotkey , %i%, MD_Init
return



MD_Init:
  MD_Init()
return

; MD_Init() {{{1
MD_Init()
{
  Global wclip,ppum,pmenu,conf,MD_Object,MD_SaveSelect
  timeout := 1
  method  := 1
  MouseGetPos, px, py, MD_hwnd
  WinGetClass, MD_Class, ahk_id %MD_hwnd%
  MD_SaveSelect := []
  MD_SaveSelect["hwnd"] :=MD_hwnd
  MD_SaveSelect["class"] := MD_Class
  IsClass := Not wclip.iCopy( timeout, method)
  pmenu :=  ppum.CreateMenu(MD_GetMenuParams(""))
  If wclip.iHasFormat(fmt_file:=15)
  {
    ext := iGetFileType(f:=wclip.iGetFiles())
    MD_SaveSelect["type"] := 1
    MD_SaveSelect["file"] := f
    Params := MD_GetMenuItemParams("")
    Params["name"] := MD_AdjustString(f,20)
    GetExtIcon(ext,file,num)
    Params["icon"] := file ":" num
    Params["uid"] := {"type":"file","string":f}
    pmenu.Add(Params)
    pmenu.Add()
    Loop,% conf.menu_file.()
    {
      If MD_Search(conf.menu_file.(A_Index).filter,ext)
        MD_AppendMenuItem(conf.menu_file.(A_Index))
    }
    if not conf.config.nosplit
    pmenu.Add()
    Loop,% conf.menu_default.()
    {
      If RegExMatch(conf.menu_default.(A_Index).name,"i)^anyfile$")
      {
        MD_AppendMenuItem(conf.menu_default.(A_Index))
        break
      }
    }
  }
  Else If IsClass
  {
    MD_SaveSelect["type"] := 0
    Params := MD_GetMenuItemParams("")
    Params["name"] := MD_AdjustString(conf.win_comment[MD_Class] ? conf.win_comment[MD_Class] : MD_Class ,20)
    winGet, file, ProcessPath, ahk_class %MD_Class%
    Params["icon"] := file ":0" 
    Params["uid"] := {"type":"class","string":MD_hwnd}
    pmenu.Add(Params)
    pmenu.Add()
    Loop,% conf.menu_class.()
    {
      If MD_Search(conf.menu_class.(A_Index).filter, MD_Class)
        MD_AppendMenuItem(conf.menu_class.(A_Index))
    }
    if not conf.config.nosplit
      pmenu.Add()
    Loop,% conf.menu_default.()
    {
      If RegExMatch(conf.menu_default.(A_Index).name,"i)^anyclass$")
      {
        MD_AppendMenuItem(conf.menu_default.(A_Index))
        break
      }
    }
  }
  Else
  {
    string := wclip.iGetText()
    MD_SaveSelect["type"] := 2
    MD_SaveSelect["text"] := string
    Params := MD_GetMenuItemParams("")
    Params["name"] := MD_AdjustString(string,20)
    Params["uid"] := {"type":"text","string":string}
    Params["icon"] := windir "\system32\shell32.dll:267"
    pmenu.Add(Params)
    pmenu.Add()
    Loop, % conf.text_regex.()
    {
      If RegExMatch(string,conf.text_regex.(A_Index).regex)
      {
        MD_TextType := conf.text_regex.(A_Index).name
        Loop,% conf.menu_text.()
        {
          If MD_Search(conf.menu_text.(A_Index).filter, MD_TextType)
            MD_AppendMenuItem(conf.menu_text.(A_Index))
        }
        break
      }
    }
    if not conf.config.nosplit
      pmenu.Add()
    Loop,% conf.menu_default.()
    {
      If RegExMatch(conf.menu_default.(A_Index).name,"i)^anytext$")
      {
        MD_AppendMenuItem(conf.menu_default.(A_Index))
        break
      }
    }
  }
  if not conf.config.nosplit
    pmenu.Add()
  Loop,% conf.menu_default.()
  {
    If RegExMatch(conf.menu_default.(A_Index).name,"i)^Any$")
    {
      MD_AppendMenuItem(conf.menu_default.(A_Index))
      break
    }
  }
  pmenu.Add()
  Params := MD_GetMenuItemParams("")
  Params["name"] := "打开配置"
  Params["icon"] := A_ScriptDir "\icons\menuz.icl:10"
  Params["uid"] := "setting"
  pmenu.Add(Params)
  selected := pmenu.show(px,py)
  Tooltip
  MD_Object:=selected["uid"]
  If MD_Object.type = 1
    Clipboard := wclip.iGetFiles()
  Else If MD_Object.type = 2
    Clipboard := wclip.iGetText()
  Else If MD_object = setting
    Run "%A_ahkPath%" "%A_ScriptDir%\GUI.ahk"
  Else
  {
    SR_Engine_Interpret(MD_Object.String,MD_SaveSelect,True)
  }
  wclip.iClear()
}

GetSaveSelect()
{
  Global MD_SaveSelect
  return MD_SaveSelect
}

; MD_Functions {{{1
; MD_AppendMenuItem(item,IsSub=False) {{{2
MD_AppendMenuItem( item, IsSub= False)
{
  Global pmenu,ppum,conf
  If IsSub
  {
    thismenu := ppum.CreateMenu(MD_GetMenuParams(item))
    item := item.sub
  }
  Else
    thismenu := pmenu
  Loop, % item.()
  {
    If RegExMatch(Item.(A_Index).name,"^[\-]+$")
    {
      thismenu.Add()
      Continue
    }
    Params := MD_GetMenuItemParams(Item.(A_Index))
    Params["name"] := Item.(A_Index).name
    Params["uid"] := Item.(A_Index)
    If Item.(A_Index).sub.()
      Params["submenu"] := MD_AppendMenuItem(item.(A_Index),True)
    thismenu.Add(Params)
  }
  If IsSub
    return thismenu.handle
}


; MD_SetFiles(file,cut= False) {{{2
; 设置文件到剪切板中，方便直接复制
; 返回添加到剪切板中的size
MD_SetFiles(file,cut= False)
{
  Global wclip
  return wclip.iSetFiles(file,cut)
}
; MD_SetText(text) {{{2
MD_SetText(text)
{
  Global wclip
  return wclip.iSetText(text)
}

; MD_Search(filter,string) {{{2
MD_Search(filter,string)
{
  m := ToMatch(string)
  return RegExMatch(filter,"i)(^" m ";|^" m "$|;" m ";|;" m ";?$)")
}

; MD_AppendText(text) {{{2
MD_AppendText(text)
{
  Global wclip
  return wclip.iAppendText(text)
}

; MD_GetPUMParams() {{{2
; 获取全局菜单设置
MD_GetPUMParams(){
	Global Conf
	Params := { "SelMethod" : "fill"            
					,"oninit"      : "MD_PumOut"      
					,"onuninit"    : "MD_PumOut"     
					,"onselect"    : "MD_PumOut"     
					,"onrbutton"   : "MD_PumOut"   
					,"onmbutton"   : "MD_PumOut"  
					,"onrun"       : "MD_PumOut"      
					,"onshow"      : "MD_PumOut"      
					,"onclose"     : "MD_PumOut"}
	If Strlen(SelTcolor := conf.config.SelTcolor)
		params["Seltcolor"] := SelTcolor 
	If Strlen(SelBGcolor := conf.config.SelBGcolor)
		params["Selbgcolor"] := SelBGcolor
	If Strlen(SelMethod := conf.config.SelMethod)
		params["SelMethod"]  := SelMethod
	If Strlen(frameWidth := conf.config.frameWidth)
		params["frameWidth"] := frameWidth
	return Params
}
; MD_GetMenuParams(Conf,Section) {{{2
; 获取菜单参数
MD_GetMenuParams(obj){
	Global conf
	params := []
  tcolor := strlen(t := conf.config.tcolor) ? t : 0x00
  bgcolor := strlen(b := conf.config.bgcolor) ? b : 0xe8e8e8
  If conf.color2sub
  {
	  params["tcolor"]  := Strlen(t:=obj.Tcolor) ? t : tcolor
	  params["bgcolor"] :=  Strlen(b:=obj.BGcolor) ? b : bgcolor
  }
  Else
  {
	  params["tcolor"]  := tcolor
	  params["bgcolor"] := bgcolor
  }
  params["textoffset"] := Strlen(textoffset := obj.textoffset) ?  textoffset : 8
	params["maxheight"] := Strlen(maxheight := obj.maxheight) ? maxheight
	params["xmargin"] := Strlen(xmargin := obj.xmargin) ? xmargin
	params["ymargin"] := Strlen(ymargin := obj.ymargin) ? ymargin 
	params["textMargin"] := Strlen(textMargin:= obj.textMargin) ? textMargin
	params["nocolors"] := Strlen(nocolors := obj.nocolors) ? nocolors
	params["noicons"] := Strlen(noicons := obj.noicons) ? noicons
	params["notext"] := Strlen(notext := obj.notext) ? notext
	params["IconsSize"] := Strlen(IconsSize := obj.IconsSize) ? IconsSize : 16
	return params
}
; MD_GetMenuItemParams(obj) {{{2
; 从配置ini文件中获取菜单项的参数
MD_GetMenuItemParams(obj){
	params := []
	params["tcolor"] := obj["tcolor"]
	params["bgcolor"] := obj["bgcolor"]
	params["bold"] := obj["bold"]
	params["break"] := obj["break"]
	If Strlen(obj["icon"])
	{
    icon := ReplaceEnv(obj["icon"])
		If RegExMatch(Icon,"i).png$")
			params["icon"] := icon
		Else
			params["icon"] := RegExMatch(icon,":\d*$") ? icon  : icon ":0"
	}
	return params
}

; MD_PumOut(msg,obj) {{{2
MD_PumOut(msg,obj)
{
  If msg = onrbutton
  {
    If GetKeyState("shift")
    {
      item := obj["uid"]
      search := item.uid
      ;Run, "%A_ahkPath%" "%A_ScriptDir%\GUI.ahk" %search%  , %A_ScriptDir%
      INIWrite,%search%,%A_Temp%\mzc,auto,uid
      Run "%A_ahkPath%" "%A_ScriptDir%\GUI.ahk"
    }
    Else
      tooltip % LTrim(obj["uid"].string,">")
  }

}
; MD_Command() {{{2
MD_Command(wParam, lParam)
{
    Global MD_CMD
    StringAddress := NumGet(lParam + 2*A_PtrSize)  ; 获取 CopyDataStruct 的 lpData 成员.
    MD_CMD := StrGet(StringAddress)  ; 从结构中复制字符串.
    Settimer,MD_Command_Load,200
    return true
}
MD_Command_Load:
  Settimer,MD_Command_Load,off
  MD_Command_Load()
return
MD_Command_Load()
{
    Global MD_CMD,conf
    If RegExMatch(MD_CMD,"reload")
      reload
    If RegExMatch(MD_CMD,"conf")
      conf  := yaml( A_ScriptDir "\config.yaml", IsFile:=True)
    If RegExMatch(MD_CMD,"init")
      MD_Init()
/*
    If RegExMatch(MD_CMD,"conf")
      conf  := yaml( A_ScriptDir "\config.yaml", IsFile:=True)
*/
}

/*
; MD_WatchDir(from,to) {{{2
MD_WatchDir(from,to)
{
  Global conf
  If RegExMatch(from,"i)\\config.yaml$")
    conf := yaml(from,True)
}
*/
MZ_GUI_SaveConfig()
{
  global conf,MZ_Conf_file
  yaml_Save(conf,MZ_Conf_file)
}
; 限制文本长度为Count,不够的话，补充空格
; MD_AdjustString(String,Count) {{{2
MD_AdjustString(String,Count){
    String := Trim(String)
    p := Count - Strlen(String)
    If p > 0
    {
        Loop,%p%
            String .= A_Space
    }
    Else
        String := SubStr(String,1,Count/2) "..." Substr(String,-(count/2)+1)
    Return String
}

#Include %A_ScriptDir%\Lib\MZ_API.ahk
#Include %A_ScriptDir%\Lib\MZ_plugin.ahk
#Include %A_ScriptDir%\Lib\PUM.ahk
#Include %A_ScriptDir%\Lib\PUM_API.ahk
#Include %A_ScriptDir%\Lib\winclip.ahk
#Include %A_ScriptDir%\Lib\winclipAPI.ahk
#Include %A_ScriptDir%\Lib\yaml.ahk
#Include %A_ScriptDir%\Engine2.ahk
