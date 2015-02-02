#SingleInstance,force
#Include %A_ScriptDir%\lib\yaml.ahk
#Include %A_ScriptDir%\lib\Anchor.ahk
#Include %A_ScriptDir%\lib\Acc.ahk
#Include %A_ScriptDir%\lib\Class_CtlColors.ahk
#Include %A_ScriptDir%\lib\sci.ahk
#Include %A_ScriptDir%\lib\toolbar.ahk
#Include %A_ScriptDir%\lib\GDIP.ahk
#Include %A_ScriptDir%\lib\Class_EasyINI.ahk
#Include %A_ScriptDir%\lib\MZ_API.ahk
#NoTrayIcon

Menu, Tray, Icon , %A_ScriptDir%\icons\menuz.icl, 1
If Not FileExist(A_ScriptDir "\lib\MZ_Plugin.ahk")
  FileAppend,, %A_ScriptDir%\lib\MZ_Plugin.ahk
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

sci := new scintilla
MZ_TVSave := new MZ_Data_Save
GoSub,LoadCUR
GoSub,MZ_GUI_Show
return
; MZ_GUI_Show: {{{1
MZ_GUI_Show:

ImageListID ? IL_Destroy(ImageListID)
ImageListID := IL_Create(10)
ImageListID_TB ? IL_Destroy(ImageListID_TB)
ImageListID_TB := IL_Create(10)
IL_Add(ImageListID_TB, A_ScriptDir "\icons\menuz.icl",2  )
IL_Add(ImageListID_TB, A_ScriptDir "\icons\menuz.icl",3  )
IL_Add(ImageListID_TB, A_ScriptDir "\icons\menuz.icl",4  )
IL_Add(ImageListID_TB, A_ScriptDir "\icons\menuz.icl",5  )
IL_Add(ImageListID_TB, A_ScriptDir "\icons\menuz.icl",6  )
IL_Add(ImageListID_TB, A_ScriptDir "\icons\menuz.icl",7  )
IL_Add(ImageListID_TB, A_ScriptDir "\icons\menuz.icl",8  )
IL_Add(ImageListID_TB, A_ScriptDir "\icons\menuz.icl",9  )
IL_Add(ImageListID_TB, A_ScriptDir "\icons\menuz.icl",10  )
IL_Add(ImageListID_TB, A_ScriptDir "\icons\menuz.icl",11  )
IL_Add(ImageListID_TB, A_ScriptDir "\icons\menuz.icl",12  )


Menu,MZ_Viewer,Add,显示全部大类(&A),MZ_Viewer_All
Menu,MZ_Viewer,Add
Menu,MZ_Viewer,Add,显示内置菜单(&D),MZ_Viewer_Default
Menu,MZ_Viewer,Add,显示文件菜单(&F),MZ_Viewer_file
Menu,MZ_Viewer,Add,显示文本菜单(&K),MZ_Viewer_text
Menu,MZ_Viewer,Add,显示窗口菜单(&C),MZ_Viewer_class

Menu,MZ_Edit,Add,新建菜单筛选器(&A),MZ_GUI_Filter_New
Menu,MZ_Edit,Add,删除菜单筛选器(&X),MZ_GUI_Filter_Remove
Menu,MZ_Edit,Add
Menu,MZ_Edit,Add,新建菜单项(&N),MZ_AddMenuItemDown
Menu,MZ_Edit,Add,新建菜单项(之前)(&M),MZ_AddMenuItemUp
Menu,MZ_Edit,Add,新建子菜单项(&S),MZ_AddMenuSub
Menu,MZ_Edit,Add,新建分隔符(&E),MZ_AddMenuSep
Menu,MZ_Edit,Add,删除菜单项(&Z),MZ_DeleteMenuItem
Menu,MZ_Edit,Add
Menu,MZ_Edit,Add,上移菜单项(&U),MZ_MoveDown
Menu,MZ_Edit,Add,下移菜单项(&D),MZ_MoveUP
Menu,MZ_Edit,Add
Menu,MZ_Edit,Add,搜索菜单(&F),MZ_SearchMenu

Menu,MZ_Setting,Add,选项(&O),MZ_Setting
Menu,MZ_Setting,Add,用户变量(&U),MZ_GUI_Item_Env

Menu,menubar,Add,设置(&S),:MZ_Setting
Menu,menubar,Add,编辑(&E),:MZ_Edit
Menu,menubar,Add,视图(&V),:MZ_Viewer
Menu,menubar,Add,帮助(&H),MZ_HELP

GUI, MZ_GUI: Destroy
GUI, MZ_GUI: +hwndMain_GUI +Resize
GUI, MZ_GUI: Font, s10, Microsoft YaHei
GUI, MZ_GUI: Menu , menubar
GUI, MZ_GUI: Add, TreeView , w500 h400 x5 y35 ImageList%ImageListID% hwndhMZ_GUI_TV gMZ_GUI_TreeView AltSubmit ;-Lines ;-ReadOnly 
GUI, MZ_GUI: Add, StatusBar
hwndTB := Toolbar_Add(Main_GUI,"MZ_TB_Notify","flat list tooltips",ImageListID_TB,"x5 y5 w400 h30")

Toolbar_Insert(hwndTB,"新建菜单筛选器 (F1),8,,,201")
Toolbar_Insert(hwndTB,"删除菜单筛选器 (F2),9,,,202")
Toolbar_Insert(hwndTB,"-")
Toolbar_Insert(hwndTB,"新建菜单项 (F3),2,,,101")
Toolbar_Insert(hwndTB,"新建菜单项(之前) (F4),1,,,102")
Toolbar_Insert(hwndTB,"新建子菜单项 (F5),3,,,103")
Toolbar_Insert(hwndTB,"新建分隔符 (F6),4,,,104")
Toolbar_Insert(hwndTB,"删除菜单项 (F7),5,,,105")
Toolbar_Insert(hwndTB,"上移菜单项 (F8),6,,,106")
Toolbar_Insert(hwndTB,"下移菜单项 (F9),7,,,107")
Toolbar_Insert(hwndTB,"-")
Toolbar_Insert(hwndTB,"设置 (F10),10,,,301")
Toolbar_Insert(hwndTB,"帮助 (F11),11,,,302")
MZ_TVColor := new TreeView(hMZ_GUI_TV)
INIRead,ToSearch,%A_Temp%\mzc,auto,uid,0
INIWrite,0,%A_Temp%\mzc,auto,uid
MZ_TVSave.SetType(MZ_GUI_LoadData("【内置菜单】================================== |",conf.menu_default,"%windir%\system32\shell32.dll:43"),"default")
MZ_TVSave.SetType(MZ_GUI_LoadData("【文件菜单】================================== |",conf.menu_file , "%windir%\system32\shell32.dll:54"),"file")
MZ_TVSave.SetType(MZ_GUI_LoadData("【文本菜单】================================== |",conf.menu_text ,"%windir%\system32\shell32.dll:1"),"text")
MZ_TVSave.SetType(MZ_GUI_LoadData("【窗口菜单】================================== |",conf.menu_class, "%windir%\system32\shell32.dll:2"),"class")

GUI, MZ_GUI: Show , w510 , MenuZ 编辑器
Control,Style,+0x1000,SysTreeView321,ahk_id %Main_GUI%

MZ_GUI_SaveConfig()

If ToSearchID
{
  MZ_TV_ThisObject := MZ_TVSave.Get(ToSearchID)
  GUI,MZ_GUI:Default
  TV_Modify(ToSearchID,"visfirst select")
  MZ_TVSelectID := ToSearchID
  MZ_TVSelectID := TV_GetSelection()
  TV_GetText(MZ_TVSelect,MZ_TVSelectID)
  SB_SetText(MZ_GetSBText(MZ_TVSave.GetLV(MZ_TVSelectID),MZ_TVSelectID))
  GoSub,MZ_GUI_Item
}

Hotkey, IfWinActive,ahk_id %Main_GUI%
Hotkey,f1,MZ_GUI_Filter_New
Hotkey,f2,MZ_GUI_Filter_Remove
Hotkey,f3,MZ_AddMenuItemDown
Hotkey,f4,MZ_AddMenuItemUp
Hotkey,f5,MZ_AddMenuSub
Hotkey,f6,MZ_AddMenuSep
Hotkey,f7,MZ_DeleteMenuItem
Hotkey,f9,MZ_MoveDown
Hotkey,f9,MZ_MoveUP
Hotkey,ctrl & f,MZ_SearchMenu

sleep,300
MZ_LoadPlugin()
return

MZ_GUIGUISize:
  GUI, MZ_GUI: Default
  Anchor("Static1","y")
  Anchor("edit1","w y")
  Anchor("sysTreeView321","w h")
  WinSet,Redraw,,ahk_id %Main_GUI%
return
;MZ_GUIGUIEscape:
MZ_GUIGUIClose:
  ExitApp
return

; MZ_GUI_SaveConfig() {{{1
MZ_GUI_SaveConfig()
{
  global conf,MZ_Conf_file
  yaml_Save(conf,MZ_Conf_file)
  MZ_GUI_Command("-c")
}
MZ_GUI_Command(cmd)
{
  run "%A_AhkPath%" "%A_Scriptdir%\command.ahk" %cmd%
}
; MZ_GUI_LoadData(itemname,obj,icon) {{{1
MZ_GUI_LoadData(itemname,obj,icon)
{
  Global MZ_TVSave
  GUI, MZ_GUI: Default
  mid := TV_Add(itemname,0, MZ_GUI_TV_option({"icon":icon}) " Expand")
  MZ_TVSave.Set(1,mid,obj)
  Loop,% obj.()
  {
    rid := TV_Add(obj.(A_Index).name,mid,MZ_GUI_TV_option({"icon":"%windir%\system32\shell32.dll:22"}))
    MZ_TVSave.Set(2,rid,Obj.(A_Index))
    MZ_GUI_LoadDataSub(Obj.(A_Index),rid)
  }
  return mid
}
; MZ_GUI_LoadDataSub( item, ID=0) {{{1
MZ_GUI_LoadDataSub( item, ID=0)
{
  Global conf,MZ_TVColor,MZ_TVSave,ToSearch,ToSearchID
  GUI, MZ_GUI: Default
  Loop, % Item.()
  {
    name := item.(A_Index).name
    If not item.(A_Index).uid
      item.(A_Index)["uid"]:= A_Now A_Index
    rid := TV_Add(name,ID,MZ_GUI_TV_option(item.(A_Index)))
    If item.(A_Index).uid = ToSearch
      ToSearchID := rid
    MZ_TVSave.Set(3,rid,item.(A_Index))
    MZ_TVColor.TV_Color({hwnd:rid,fore:rgb_bgr_swap((f:=item.(A_Index).tcolor)?f:(fd:=conf.config.Tcolor)?fd:0),back:rgb_bgr_swap((b:=Item.(A_Index).BGColor)?b:(bd:=Conf.config.BGColor)?bd:0xffffff)})
    If Isobject(item.(A_Index).sub)
      MZ_GUI_LoadDataSub(item.(A_Index).sub, rid)
  }
}
; MZ_GUI_TV_option(obj) {{{1
MZ_GUI_TV_option(obj)
{
  Global ImageListID
  icon := obj.icon
	Options := "icon9999"
	If Strlen(icon)
  {
	  If RegExMatch(icon,":[-\d]*$")
    {
      pos := RegExMatch(icon,":[^:]*$")
		  file   := ReplaceEnv(SubStr(icon,1,pos-1))
			Number := (number := substr(icon,pos+1)) > 0 ? Number + 1 : Number
			ic := IL_Add(ImageListID,file,Number)
			If ic
			  Options := "icon" ic 
    }
	  Else
  	{
			file := ReplaceEnv(icon)
			ic := IL_Add(ImageListID,file)
			If ic
			  Options := "icon" ic 
		}
	}
  return obj.Bold ? Options " bold" : Options " -bold"
}
; MZ_GUI_TreeView: {{{1
MZ_GUI_TreeView:
  GUI, MZ_GUI: Default
  If A_GUIEvent = Normal
  {

    MZ_TVSelectID := A_EventInfo
    TV_GetText(MZ_TVSelect,MZ_TVSelectID)
    SB_SetText(MZ_GetSBText(MZ_TVSave.GetLV(MZ_TVSelectID),MZ_TVSelectID))
/*
    item := MZ_TVSave.Get(PrevID)
    MZ_TVColor.TV_Color({hwnd:PrevID,fore:rgb_bgr_swap((f:=item.tcolor)?f:(fd:=conf.config.Tcolor)?fd:0),back:rgb_bgr_swap((b:=Item.BGColor)?b:(bd:=Conf.config.BGColor)?bd:0xffffff)})
    If MZ_TVSave.GetLV(MZ_TVSelectID) = 3
    {
      rid := PrevID := MZ_TVSelectID
      item := MZ_TVSave.Get(MZ_TVSelectID)
      MZ_TVColor.TV_Color({hwnd:rid,fore:rgb_bgr_swap(0xffffff),back:rgb_bgr_swap(0x3399ff)})
    }
    Else
      PrevID := 0
    MZ_GUI_ReDraw()
*/
  }
  If A_GUIEvent = RightClick
  {
    MZ_TVSelectID := A_EventInfo

/*
    rid := PrevID := MZ_TVSelectID
    item := MZ_TVSave.Get(MZ_TVSelectID)
    MZ_TVColor.TV_Color({hwnd:rid,fore:rgb_bgr_swap(0xffffff),back:rgb_bgr_swap(0x3399ff)})
    MZ_GUI_ReDraw()
    item := MZ_TVSave.Get(PrevID)
    MZ_TVColor.TV_Color({hwnd:PrevID,fore:rgb_bgr_swap((f:=item.tcolor)?f:(fd:=conf.config.Tcolor)?fd:0),back:rgb_bgr_swap((b:=Item.BGColor)?b:(bd:=Conf.config.BGColor)?bd:0xffffff)})
    If MZ_TVSave.GetLV(MZ_TVSelectID) = 3
    {
      rid := PrevID := MZ_TVSelectID
      item := MZ_TVSave.Get(MZ_TVSelectID)
      MZ_TVColor.TV_Color({hwnd:rid,fore:rgb_bgr_swap(0xffffff),back:rgb_bgr_swap(0x3399ff)})
    }
    Else
      PrevID := 0
    MZ_GUI_ReDraw()
*/

    TV_GetText(MZ_TVSelect,MZ_TVSelectID)
    If RegExMatch(MZ_TVSelect,"^[\-]+$")
      return
    SB_SetText(MZ_GetSBText(MZ_TVSave.GetLV(MZ_TVSelectID),MZ_TVSelectID))
    TV_Modify(MZ_TVSelectID,"select")
    If MZ_TVSave.GetLV(MZ_TVSelectID) = 1
      return
    MZ_TV_ThisObject := MZ_TVSave.Get(MZ_TVSelectID)
    If MZ_TVSave.GetLV(MZ_TVSelectID) = 2
      GoSub,MZ_GUI_Filter
    If MZ_TVSave.GetLV(MZ_TVSelectID) = 3
      GoSub,MZ_GUI_Item
    return
  }
  If (A_GUIEvent == "E")
  {
    MZ_TVSelectID := A_EventInfo
    If MZ_TVSave.GetLV(MZ_TVSelectID) = 1
      Send,{Esc}
  }
  If (A_GUIEvent == "e")
  {
    MZ_TVSelectID := A_EventInfo
    If MZ_TVSave.GetLV(MZ_TVSelectID) = 1
      return
    If MZ_TVSave.GetType(MZ_TVSelectID) = Default
      return
    TV_GetText(nText,MZ_TVSelectID)
    MZ_TV_ThisObject := MZ_TVSave.Get(MZ_TVSelectID)
    MZ_TV_ThisObject.name := nText
    MZ_GUI_SaveConfig()
  }
return
NULL:
return
MZ_GetSBText(level,id)
{
  Global MZ_TVSave
  obj := MZ_TVSave.Get(id)
  If Level = 1
  {
    If RegExMatch(MZ_TVSave.GetType(id),"^file$")
      return "  【文件菜单】：当选择的内容是文件时，此大类下的菜单项会响应"
    If RegExMatch(MZ_TVSave.GetType(id),"^text$")
      return "  【文本菜单】：当选择的内容是文本时，此大类下的菜单项会响应"
    If RegExMatch(MZ_TVSave.GetType(id),"^class$")
      return "  【窗口菜单】：当没有选择到内容时，此大类下的菜单项会响应"
    If RegExMatch(MZ_TVSave.GetType(id),"^default$")
      return "  【内置菜单】，此大类下的菜单项任意情况下都会响应"
  }
  If Level = 2
  {
    If RegExMatch(obj.name ,"i)^Any$")
      return "  筛选类型:【 任意选择的内容 】"
    Else If RegExMatch(obj.name ,"i)^AnyFile$")
      return "  筛选类型:【 任意选择的文件 】"
    Else If RegExMatch(obj.name ,"i)^AnyText$")
      return "  筛选类型:【 任意选择的文本 】"
    Else If RegExMatch(obj.name,"i)^AnyClass$")
      return "  筛选类型:【 任意选择的窗口 】"
    Else
      return "  筛选类型:【" obj.filter " 】"
  }
  If Level = 3
    return "  菜单项:【 " obj.name " 】"
}
; MZ_GUI_ReDraw() {{{1
MZ_GUI_ReDraw()
{
  GUI, MZ_GUI: Default
  GUIControl,+Redraw,SysTreeview321
}
; MZ_GUI_Filter {{{1
MZ_GUI_Filter:
GUI, MZ_GUI: Default
filter_type:=MZ_TVSave.GetType(Tv_getparent(TV_GetSelection()))
If filter_type = Default
  return
MZ_TV_ThisObject := MZ_TVSave.Get(TV_GetSelection())
GUI,Filter:Destroy
GUI,Filter:Default
GUI,Filter:+theme +Owner%main_GUI% 
GUI,Filter:Font,s9,Microsoft YaHei
GUI,Filter:Add,Text,x10 y13 h24 w90,筛选器名称(&N):
GUI,Filter:Add,Edit,x100 y10 h24 w390
GUI,Filter:Add,Text,x10 y43 h24 ,可选类型(&F): 
GUI,Filter:Add,ListView,x10 y70 h260 w320 sort Checked Grid Hidden,类型|说明
GUI,Filter:Add,Text,x380 y43 h24 w90,已添加(&D):
GUI,Filter:Add,ListView,x380 y70 h325 w110 Multi,类型
GUI,Filter:Add,Text,x10 y343 h24 w90,手动添加(&T):
GUI,Filter:Add,Edit,x10 y370 h24 w320
GUI,Filter:Add,Button,x340 y70  h26 w30 gMZ_GUI_Filter_Add,>>
GUI,Filter:Add,Button,x340 y100 h26 w30 gMZ_GUI_Filter_del,<<
GUI,Filter:Add,Button,x340 y370 h26 w30 gMZ_GUI_Filter_Add_manual,>>
GUI,Filter:Add,Button,x10  y410 h26 w80 hidden,帮助(&H)
GUI,Filter:Add,Button,x320 y410 h26 w80 gMZ_GUI_Filter_OK,确定(&O)
GUI,Filter:Add,Button,x410 y410 h26 w80 gFilterGUIClose,取消(&C)
GUI,Filter:Add,ListView,x10 y70 h225 w320 Checked Grid Hidden -Multi
GUI,Filter:Add,Button,x10  y300 h24 w65 hidden,添加(&A)
GUI,Filter:Add,Button,x80 y300 h24 w65 hidden,编辑(&E)
GUI,Filter:Add,Button,x150 y300 h24 w65 hidden,删除(&D)
GUI,Filter:Add,Text  ,x10  y410 ,注意: 手动添加类型名时，类型间用分号隔开`n如 .doc`;.xls`;.ppt 或者 notepad`;vim
GUI,Filter:show,w500 h450 , MenuZ 菜单筛选器
OnMessage(0x4E,"")
MZ_GUI_Filter_Load_file()
return

FilterGUIEscape:
FilterGUIClose:
  WinSet,Enable,,ahk_id %main_GUI%
  GUI,Filter:Destroy
  OnMessage(0x4e,"TV_WM_NOTIFY")
return

; MZ_GUI_Filter_Load_file {{{2
MZ_GUI_Filter_Load_file()
{
  Global MZ_TV_ThisObject,conf,MZ_Conf_file,Filter_type
  GUI,Filter: Default
  GUI,Filter: Listview, SysListview322
  GUIControl,,Edit1,% MZ_TV_ThisObject.name
  filter := MZ_TV_ThisObject.filter
  Loop,Parse,filter,`;
  {
    If strlen(A_LoopField)
      LV_Add("",A_LoopField)
  }
  If Filter_type = file
  {
    GUIControl, Show, SysListView321
    GUI,Filter: Listview, SysListview321
    GUIControl,,ListBox1, %added%
    GUIControl,-Redraw,SysListview321
    LV_ModifyCol(1,120)
	  LV_ModifyCol(2,400)
	  Loop,HKEY_CLASSES_ROOT,,2
	  {
		  If RegExMatch(A_LoopRegName,"^\.")
		  {
			  RegRead,r,HKEY_CLASSES_ROOT,%A_LoopRegName%
			  If Strlen(r)
				  RegRead,v,HKEY_CLASSES_ROOT,%r%
			  If Strlen(v)
				  LV_Add("",A_LoopRegName,v)
			  v := ""
		  }
	  }
    LV_Add("","Multifiles","多文件")
    LV_Add("","Folder","文件夹")
    LV_Add("","Drive","驱动器")
    LV_Add("","NoExt","无扩展名文件")
    GUIControl,+Redraw,SysListview321
    return
  }
  GUIControl, Show, SysListView323
  GUIControl, Show, Button7
  GUIControl, Show, Button8
  GUIControl, Show, Button9
  GUI,Filter: Listview, SysListview323
  If Filter_type = text
  {
    GUIControl,+gMZ_GUI_Filter_TextAdd,Button7
    GUIControl,+gMZ_GUI_Filter_TextEdit,Button8
    GUICOntrol,+gMZ_GUI_Filter_TextDelete,Button9
    LV_InsertCol(1,80,"类型")
	  LV_InsertCol(2,180,"说明")
	  LV_InsertCol(3,400,"正则式")
    Loop, % conf.text_regex.()
      LV_Add( "", conf.text_regex.(A_Index).name, conf.text_regex.(A_Index).comment, conf.text_regex.(A_Index).regex)
  }
  If Filter_type = class
  {
    GUIControl,+gMZ_GUI_Filter_ClassAdd,Button7
    GUIControl,+gMZ_GUI_Filter_ClassEdit,Button8
    GUICOntrol,+gMZ_GUI_Filter_ClassDelete,Button9
    LV_InsertCol(1,120,"窗口类")
	  LV_InsertCol(2,300,"窗口说明")
    for i , k in conf.win_comment
      LV_Add( "", i, k)
  }
}
; MZ_GUI_Filter_New {{{2
MZ_GUI_Filter_New:
  MZ_GUI_Filter_New()
return
MZ_GUI_Filter_New()
{
Global MZ_TVSave,MZ_TV_NewItem_Parent_ID
GUI, MZ_GUI: Default
id:=TV_GetSelection()
Loop
{
  If (nid:=Tv_getparent(id))
    id := nid
  Else
    break
}
MZ_TV_NewItem_Parent_ID := id
type := MZ_TVSave.GetType(id)
If type = Default
{
  MsgBox, 64, MenuZ , 不允许添加默认菜单筛选器。
  return
}
If type = file
  typename := "【文件"
If type = text
  typename := "【文本"
If type = class
  typename := "【窗口"
GUI,Filter_New: Destroy
GUI,Filter_New: Default
GUI,Filter_New: +theme +Owner%main_GUI% 
GUI,Filter_New: Font,s9,Microsoft YaHei
GUI,Filter_New: Add, Text, x10  y10 h24 ,%typename%菜单】筛选器名称: 
GUI,Filter_New: Add, Edit, x10  y40 w300 
GUI,Filter_New: Add, Button, x110  y80 w90 Default gFilter_New_OK, 确定(&O)
GUI,Filter_New: Add, Button, x220  y80 w90 gFilter_NewGUIClose, 取消(&C)
GUI,Filter_New: show, h120 , 新建菜单筛选器
}
Filter_NewGUIEscape:
Filter_NewGUIClose:
  GUI,Filter_New: Destroy
return
Filter_New_OK:
  Filter_New_OK()
return
Filter_New_OK()
{
  Global MZ_TVSave,MZ_TV_NewItem_Parent_ID,MZ_TVSelectID,MZ_TVSelect,MZ_TV_ThisObject
  GUI,Filter_New: Default
  GuiControlGet,NewItem,,Edit1
  If not strlen(NewItem)
  {
    MsgBox, 64, MenuZ , 名称不能为空
    return
  }
  GUI, MZ_GUI: Default
  rid:=TV_Add(NewItem,MZ_TV_NewItem_Parent_ID,"vis select " MZ_GUI_TV_option({"icon":"%windir%\system32\shell32.dll:22"}))
  obj := MZ_TVSave.Get(MZ_TV_NewItem_Parent_ID)
  obj.add("- {name: " NewItem "}")
  newobj := obj.(obj.())
  MZ_TVSave.Set(2,rid,newobj)
  MZ_GUI_SaveConfig()
  MZ_TVSelectID := rid
  MZ_TVSelect := NewItem
  MZ_TV_ThisObject := newobj
  GoSub,Filter_NewGUIClose
  GoSub,MZ_GUI_Filter
}
; MZ_GUI_Filter_Remove {{{2
MZ_GUI_Filter_Remove:
MZ_GUI_Filter_Remove()
return
MZ_GUI_Filter_Remove()
{
  Global MZ_TVSave
  GUI, MZ_GUI: Default
  type:=MZ_TVSave.GetType(id:=Tv_getparent(TV_GetSelection()))
  lv := MZ_TVSave.GetLV(sid:=TV_GetSelection())
  If type = Default
  {
    MsgBox, 64, MenuZ , 不允许删除默认菜单筛选器。
    return
  }
  If lv <> 2
    return
  nid := Tv_getchild(id)
  pos := 1
  Loop
  {
    If not nid
      break
    If nid = %sid%
      break
    nid := Tv_getnext(nid)
    pos++
  }
  pObj := MZ_TVSave.Get(Tv_getparent(Tv_getselection()))
  name := pObj.(pos).name

  MsgBox, 68, MenuZ , 请确认是否删除菜单筛选器( %name% )？`n`n注意: 此操作不可逆！ 请做好备份。

  OnMessage(0x4e,"TV_WM_NOTIFY")
  IfMsgbox,yes
  {
    pobj[""].Remove(pos)
    Tv_delete(sid)
    MZ_GUI_SaveConfig()
  }
}

; MZ_GUI_Filter_OK{{{2
MZ_GUI_Filter_OK:
  MZ_GUI_Filter_OK()
return
MZ_GUI_Filter_OK()
{
  Global MZ_TV_ThisObject, MZ_TVSelectID
  GUI,Filter: Default
  GUI,Filter: +hwndfilter
  GUIControlGet,newFilterName, , Edit1
  ControlGet, l, List, , SysListview322, ahk_id %filter%
  Loop, Parse, l, `n
  {
    filter_new .= A_LoopField ";"
  }
  MZ_TV_ThisObject.name   := newFilterName
  MZ_TV_ThisObject.filter := filter_new
  GUI, MZ_GUI: Default
  Tv_modify(MZ_TVSelectID,"",newFilterName)
  MZ_GUI_SaveConfig()
  GoSub, FilterGUIClose 
}

; MZ_GUI_Filter_Add {{{2
MZ_GUI_Filter_Add:
  MZ_GUI_Filter_Add()
return
; MZ_GUI_Filter_Add_manual {{{2
MZ_GUI_Filter_Add_manual:
  MZ_GUI_Filter_Add(Manual:=True)
return
MZ_GUI_Filter_Add(Manual=false)
{
  GUI,Filter: Default
  obj := []
  RowNumber = 0  ; 这样使得首次循环从列表的顶部开始搜索.
  Loop
	{
    GUI,Filter: Listview, SysListview322
		RowNumber := LV_GetNext(RowNumber,"Checked")  ; 在前一次找到的位置后继续搜索.
	 	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
	 		break
	 	LV_GetText(Text, RowNumber)
     obj[Text]:=True
	}
  If Manual
  {
    GUIControlGet,l,,Edit2
    GUI,Filter: Listview, SysListview322
    Loop,Parse,l,`;
    {
      If Strlen(A_LoopField)
        If not obj[A_LoopField]
          LV_Add("",A_LoopField)
    }
  }
  Else
  {
    RowNumber = 0  ; 这样使得首次循环从列表的顶部开始搜索.
	  Loop
	  {
      GUIControlGet,file,Visible,SysListview321
      If File
        GUI,Filter: Listview, SysListview321
      GUIControlGet,text,Visible,SysListview323
      If text
        GUI,Filter: Listview, SysListview323

	  	RowNumber := LV_GetNext(RowNumber,"Checked")  ; 在前一次找到的位置后继续搜索.
		  if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			  break
		  LV_GetText(Text, RowNumber)
      GUI,Filter: Listview, SysListview322
      If Strlen(Text)
        If not obj[Text]
          LV_Add("",Text)
	  }
  }
}
; MZ_GUI_Filter_del {{{2
MZ_GUI_Filter_Del:
  MZ_GUI_Filter_Del()
return
MZ_GUI_Filter_Del()
{
  GUI,Filter: Default
  GUIControl,-Redraw,SysListview322
  RowNumber = 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Loop
	{
    GUI,Filter: Listview, SysListview322
		RowNumber := LV_GetNext(RowNumber,"")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		If LV_Delete(RowNumber)
      RowNumber -=1
	}
  GUIControl,+Redraw,SysListview322
}
; MZ_GUI_Filter_TextAdd {{{2
MZ_GUI_Filter_TextAdd:
  MZ_GUI_Filter_Text()
return
MZ_GUI_Filter_TextEdit:
  MZ_GUI_Filter_Text(IsEdit:=True)
return
MZ_GUI_Filter_Text(IsEdit=False)
{
  Global Filter_Edit_Name
  GUI,Filter: +hwndhFilter
  GUI,Filter_TextAdd:Destroy
  GUI,Filter_TextAdd:+theme +Owner%hFilter% 
  GUI,Filter_TextAdd:Font,s9,Microsoft YaHei
  GUI,Filter_TextAdd: Add, Text, x10 y13 h24, 文本类型名称(&N):
  GUI,Filter_TextAdd: Add, Edit, x10 y35 h24 w400,
  GUI,Filter_TextAdd: Add, Text, x10 y68 h24, 文本类型备注(&F):
  GUI,Filter_TextAdd: Add, Edit, x10 y90 h24 w400 ,
  GUI,Filter_TextAdd: Add, Text, x10 y123 h24, 文本类型正则式(&T):
  GUI,Filter_TextAdd: Add, Edit, x10 y148 h24 w400 r4,
  GUI,Filter_TextAdd: Add, Button, x230 y240 h26 w80 gMZ_GUI_Filter_TextOK Default, 确认(&O)
  GUI,Filter_TextAdd: Add, Button, x330 y240 h26 w80 gFilter_TextAddGUIClose, 取消(&C)
  If IsEdit
  {
    GUI,Filter: Default
    GUI,Filter: Listview, SysListview323
    id := LV_GetNext(0,"Focused")
    LV_GetText(name,id,1)
    Filter_Edit_Name := name
    LV_GetText(comment,id,2)
    LV_GetText(regex,id,3)
    GUI,Filter_TextAdd: Default
    GUI,Filter_TextAdd: Add, CheckBox, x10 y225 h26 w80 checked Hidden
    GUI,Filter_TextAdd: Show, w420 h280 , 编辑文本类型
    GUIControl,,Edit1,%name%
    GUIControl,,Edit2,%comment%
    GUIControl,,Edit3,%regex%
  }
  Else
    GUI,Filter_TextAdd: Show, w420 h280 , 添加文本类型
  OnMessage(0x4E,"")
}
Filter_TextAddGUIEscape:
Filter_TextAddGUIClose:
  GUI,Filter_TextAdd: Destroy
  OnMessage(0x4e,"TV_WM_NOTIFY")
return
MZ_GUI_Filter_TextDelete:
  MZ_GUI_Filter_TextDelete()
return
MZ_GUI_Filter_TextDelete()
{
  Global conf
  GUI,Filter: Default
  GUI,Filter: Listview, SysListview323
  ID := LV_GetNext(0,"Focused")
  LV_GetText(name,ID)
  MsgBox, 68, MenuZ , 请确认是否删除文本类型( %name% )？`n`n注意: 此操作不可逆！ 请做好备份。
  IfMsgbox, yes
  {
    LV_Delete(ID)
    conf.text_regex[""].Remove(ID)
    MZ_GUI_SaveConfig()
  }
}
MZ_GUI_Filter_TextOK:
  MZ_GUI_Filter_TextOK()
return
MZ_GUI_Filter_TextOK()
{
  Global conf,Filter_Edit_Name
  GUI,Filter_TextAdd: Default
  GUIControlGet,IsEdit,,Button3
  GUIControlGet,name,,Edit1
  GUIControlGet,comment,,Edit2
  GUIControlGet,regex,,Edit3
  m := "i)^" ToMatch(name) "$"
  Loop,% conf.text_regex.() And (not IsEdit)
  {
    If RegExMatch(conf.text_regex.(A_Index).name,m)
    {
      MsgBox, 64, MenuZ , 文本类型已经存在，请修改名称
      return
    }
  }
  If not StrLen(name)
  {
    MsgBox, 64, MenuZ , 文本类型名称不能为空
    return
  }
  If not StrLen(regex)
  {
    MsgBox, 64, MenuZ , 文本类型正则式不能为空
    return
  }
  GUI,Filter: Default
  GUI,Filter: Listview, SysListview323
  If IsEdit
  {
    m := "i)^" ToMatch(Filter_Edit_Name) "$"
    Loop,% conf.text_regex.()
    {
      If RegExMatch(conf.text_regex.(A_Index).name,m)
        nid := A_Index
    }
    id = 0  
    Loop
    {
      id := LV_GetNext(id)  
      if not id
        break
      LV_GetText(Text, id)
      If RegExMatch(text,m)
        break
    }
    LV_Modify(id,"",name,comment,regex)
    conf.text_regex.(nid).name := name
    conf.text_regex.(nid).comment := comment
    conf.text_regex.(nid).regex := regex
  }
  Else
  {
    LV_Add("",name,comment,regex)
    conf.text_regex.Add("- ")
    conf.text_regex.(conf.text_regex.()).name := name
    conf.text_regex.(conf.text_regex.()).comment := comment
    conf.text_regex.(conf.text_regex.()).regex:= regex
  }
  MZ_GUI_SaveConfig()
  GoSub,Filter_TextAddGUIClose
}

; MZ_GUI_Filter_ClassAdd {{{2
MZ_GUI_Filter_ClassAdd:
  MZ_GUI_Filter_Class(IsEdit:=False)
return
MZ_GUI_Filter_ClassEdit:
  MZ_GUI_Filter_Class(IsEdit:=True)
return
MZ_GUI_Filter_ClassDelete:
  MZ_GUI_Filter_ClassDelete()
return
MZ_GUI_Filter_ClassDelete()
{
  Global conf
  GUI,Filter: Default
  GUI,Filter: Listview, SysListview323
  ID := LV_GetNext(0,"Focused")
  LV_GetText(name,ID)
  MsgBox, 68, MenuZ , 请确认是否删除窗口类型( %name% )？`n`n注意: 此操作不可逆！ 请做好备份。
  IfMsgbox, yes
  {
    LV_Delete(ID)
    conf.win_comment.Remove(name)
    MZ_GUI_SaveConfig()
  }
}
MZ_GUI_Filter_Class(IsEdit=False)
{
  Global Filter_Edit_Name,Cross_CUR_File
  GUI,Filter: +hwndhFilter
  GUI,Filter_Class:Destroy
  GUI,Filter_Class:+theme +Owner%hFilter% 
  GUI,Filter_Class:Font,s9,Microsoft YaHei
  GUI,Filter_Class: Add, Text, x10 y13 h24, 窗口类型名称(&N):
  GUI,Filter_Class: Add, Edit, x10 y38 h24 w400,
  GUI,Filter_Class: Add, Text, x10 y70 h24, 窗口类型备注(&F):
  GUI,Filter_Class: Add, Edit, x10 y95 r1 w400 -Multi,
  GUI,Filter_Class: Add, Button, x230 y138 h26 w80 gMZ_GUI_Filter_ClassOK Default, 确认(&O)
  GUI,Filter_Class: Add, Button, x330 y138 h26 w80 gFilter_ClassGUIClose, 取消(&C)
  GUI,Filter_Class: Add, Text, x285 y13 h24, 窗口类选择工具:
  GUI,Filter_Class: Add, Pic , x380 y5 h32 w32 gSetPosClass,%Cross_CUR_File%
  If IsEdit
  {
    GUI,Filter: Default
    GUI,Filter: Listview, SysListview323
    id := LV_GetNext(0,"Focused")
    LV_GetText(name,id,1)
    LV_GetText(comment,id,2)
    GUI,Filter_Class: Default
    GUIControl,Disable, Edit1
    GUIControl,Hide, Static3
    GUIControl,Hide, Static4
    GUIControl,,Edit1,%name%
    GUIControl,,Edit2,%comment%
    GUI,Filter_Class: Show, w420 h180 , 编辑窗口类型
  }
  Else
  {
    GUI,Filter_Class: Show, w420 h180 , 添加窗口类型
  }
}
Filter_ClassGUIEscape:
Filter_ClassGUIClose:
  GUI,Filter_Class: Destroy
return
MZ_GUI_Filter_ClassOK:
  MZ_GUI_Filter_ClassOK()
return
MZ_GUI_Filter_ClassOK()
{
  Global conf
  GUI,Filter_Class: Default
  GUIControlGet,name,,Edit1
  GUIControlGet,comment,,Edit2
  GuiControlGet, IsAdd, Enabled,Edit1
  If Strlen(conf.win_comment[name]) And IsAdd
  {
    MsgBox, 64, MenuZ , 窗口类型( %name% )已经存在，请选择其它窗口
    return
  }
  If not StrLen(name)
  {
    MsgBox, 64, MenuZ , 窗口类型名称不能为空
    return
  }
  If IsAdd
  {
    GUI,Filter: Default
    GUI,Filter: Listview, SysListview323
    LV_Add("",name,comment)
  }
  Else
  {
    GUI,Filter: Default
    GUI,Filter: Listview, SysListview323
    m := "i)^" ToMatch(name) "$"
    id = 0  
    Loop
    {
      id := LV_GetNext(id)  
      if not id
        break
      LV_GetText(Text, id)
      If RegExMatch(text,m)
        break
    }
    LV_Modify(id,"",name,comment)
  }
  conf.win_comment[name] := comment
  MZ_GUI_SaveConfig()
  GoSub,Filter_ClassGUIClose
}

; MZ_GUI_Item: {{{1
MZ_GUI_Item:
GUI, MZ_GUI: +hwndmain_GUI
WinSet,Disable,,ahk_id %main_GUI%
GUI,Item:Destroy
GUI,Item:Default
GUI,Item:+hwndItemGUI +theme +Owner%main_GUI% 
GUI,Item:Font,s9,Microsoft YaHei
/*
GUI,Item:Add,Text,x10 y13 h24 ,名称(&N):
GUI,Item:Add,Edit,x96 y10 h24 w303, 
GUI,Item:Add,Text,x65 y10 h24 w24 border
GUI,Item:Add,pic ,x69 y14 
GUI,Item:Add,Text,x10 y43 h24 ,图标路径:
GUI,Item:Add,Edit,x96 y40 h24 w303 Readonly , 
GUI,Item:Add,Button,x405 y9  h26 w90 gStyleSelect,菜单配色(&L)
GUI,Item:Add,Button,x405 y39 h26 w90 gIconSelect ,更换图标(&I)
GUI,Item:Add,Text  ,x170 y75 h24 ,添加:
GUI,Item:Add,Button,x210 y72 h24 w60 gMZ_GUI_Item_File,文件(&F)
GUI,Item:Add,Button,x275 y72 h24 w60 gMZ_GUI_Item_dir,目录(&D)
GUI,Item:Add,Button, x340 y72 h24 w60 gMZ_GUI_Item_Add,变量(&A)
GUI,Item:Add,Button,x405 y72 h24 w90 gMZ_GUI_Item_Assistant,参数(&S)
GUI,Item:Add,Button,x310 y215 h26 w90 gMZ_GUI_Item_OK Default,确定(&O)
GUI,Item:Add,Button,x405 y215 h26 w90 gItemGUIClose,取消(&C)
GUI,Item:Add,Text,x10 y75 h24 ,参数(&P):
sci.Add(itemGui, 10, 105, 484, 100, A_ScriptDir "\Lib\LexAHKL.dll")
*/
GUI,Item:Add,Text,x10 y13 h24 ,名称(&N):
GUI,Item:Add,Edit,x96 y10 h24 w268, 
GUI,Item:Add,Text,x65 y10 h24 w24 border
GUI,Item:Add,pic ,x69 y14 
GUI,Item:Add,Button,x370 y9 h26 w60 gIconSelect ,图标(&I)
GUI,Item:Add,Button,x435 y9  h26 w60 gStyleSelect,配色(&L)
GUI,Item:Add,Text  ,x200 y43 h24 ,添加:
GUI,Item:Add,Button,x240 y39 h24 w60 gMZ_GUI_Item_File,文件(&F)
GUI,Item:Add,Button,x305 y39 h24 w60 gMZ_GUI_Item_dir,目录(&D)
GUI,Item:Add,Button, x370 y39 h24 w60 gMZ_GUI_Item_Assistant,参数(&S)
GUI,Item:Add,Button,x435 y39  h24 w60 gMZ_GUI_Item_Add,变量(&A)
GUI,Item:Add,Button,x310 y182 h26 w90 gMZ_GUI_Item_OK Default,确定(&O)
GUI,Item:Add,Button,x405 y182 h26 w90 gItemGUIClose,取消(&C)
GUI,Item:Add,Text,x10 y43 h24 ,内容(&P):

GUI,Item:Add,CheckBox,x10 y182 h24 w100 gItemAdvance , 高级功能(&M)
GUI,Item:Add,GroupBox,x100 y182 h200 w383 hidden disabled
GUI,Item:Add,ListBox ,x10  y182 h200 w80  hidden disabled

sci.Add(itemGui, 10, 72, 484, 100, A_ScriptDir "\Lib\LexAHKL.dll")
sci.SetWrapMode(true) ; this removes the horizontal scrollbar
sci.SetMarginWidthN(1, 0) ; this removes the left margin
sci.StyleSetFont(STYLE_DEFAULT, "Microsoft YaHei") 
sci.StyleSetSize(STYLE_DEFAULT, 10)
sci.StyleClearAll()
sci.notify := "Notify"
sci.StyleSetFore(SCE_AHKL_LABEL, 0xEE0000)
sci.SetCodePage(936)
sci.STYLESETBOLD(SCE_AHKL_LABEL,1)
sci.StyleSetFore(SCE_AHKL_VAR, 0xAA2288)
sci.StyleSetFore(SCE_AHKL_BUILTINVAR, 0x0000EE)
sci.AUTOCSETSEPARATOR(10)
SCI.CLEARCMDKEY(Asc("Q")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("S")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("W")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("G")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("F")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("H")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("H")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("E")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("R")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("O")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("P")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("K")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("N")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("B")+(SCMOD_CTRL<<16))
;SCI.USEPOPUP(0)
GUI,Item:show,w506 h217 , MenuZ 菜单项配置
MZ_GUI_Item_Load()
return

ItemGUIClose:
  GUI, MZ_GUI: +hwndmain_GUI
  WinSet, Enable,,ahk_id %main_GUI%
  GUI,Item:+hwndItemGUI
  GUI,Item:Destroy
  OnMessage(0x4e,"TV_WM_NOTIFY")
  MZ_GUI_Item_Reload()
  GoSub,MZ_SearchMenuGo
return
ItemGUISize:
	Anchor("button7","y")
	Anchor("button8","y")
	Anchor("button9","y")
	GUI,Item:+LastFound
	WinGet,cid,ID,A
	WinSet,Redraw,,ahk_id %cid%
return
; MZ_GUI_Item_Load {{{2
MZ_GUI_Item_Load()
{
  Global MZ_TV_ThisObject,SCI,saveBGColor,saveTColor,saveBold,conf,MZ_Item_Icon
  GUI,Item:Default
  OnMessage(0x4E,"__sciNotify")
	GuiControl,,Edit1,% MZ_TV_ThisObject.name
  ;If IsObject(MZ_TV_ThisObject.string)
  ;  SCI.SetText(unused,RegExReplace(Substr(k:=yaml_Dump(MZ_TV_ThisObject.string,0),2,Strlen(k)-2),":\s",":"))
  ;Else
  SCI.SetText(unused,LTrim(MZ_TV_ThisObject.string,">"))
	GuiControlGet, bhwnd, Hwnd ,button1
	GuiControlGet, ehwnd, Hwnd ,Edit1
	MZ_Item_Icon := icon := MZ_TV_ThisObject.icon
	GuiControl,,Edit2,%icon%
	If Strlen(icon){
		If RegExMatch(icon,":[-\d]*$"){
			pos := RegExMatch(Icon,":[^:]*$")
			file   := ReplaceEnv(SubStr(icon,1,pos-1))
			Number := (number := substr(icon,pos+1)) > 0 ? Number + 1 : Number
		}
		Else
		{
			file := ReplaceEnv(icon)
		}
	}
	GuiControl,,Static3,*icon%number% *w16 *h-1 %file%
	saveTColor := TextColor := strlen(v:=MZ_TV_ThisObject.Tcolor)  ? v : conf.Config.Tcolor
	iTextColor := strlen(TextColor) ? SubStr("000000" . RegExReplace(TextColor,"i)^0x"),-5) : ""
	saveBGcolor := BackgroundColor := strlen(v:=MZ_TV_ThisObject.BGcolor) ? v : conf.config.BGcolor
	iBackgroundColor := strlen(BackgroundColor) ? SubStr("000000" . RegExReplace(BackgroundColor,"i)^0x"),-5) : ""
	saveBold := MZ_TV_ThisObject.Bold
  If saveBold
    GUI,Item:Font,s9 bold,Microsoft YaHei
  Else
    GUI,Item:Font,s9 Norm,Microsoft YaHei
  GuiControl, Font, Edit1
	CtlColors.Attach(ehwnd,iBackgroundColor,iTextColor)	
}

; MZ_GUI_Item_OK {{{2
MZ_GUI_Item_OK:
  MZ_GUI_Item_OK()
return
MZ_GUI_Item_OK()
{
  Global MZ_TV_ThisObject,SCI,saveBGColor,saveTColor,saveBold,conf,MZ_Conf_file,MZ_Item_Icon
	GUI,Item:Default
  GUIControlGet,name,,Edit1
  If len:=sci.GetLength()
    Sci.GetText(len+1,string)
  Else
    string := ""
  MZ_TV_ThisObject.name := name
  MZ_TV_ThisObject.icon := MZ_Item_Icon
  If RegExMatch(Trim(string),"^{.*}$")
  MZ_TV_ThisObject.string := ">" string
  Else
  MZ_TV_ThisObject.string := string
  MZ_TV_ThisObject.tcolor := saveTColor
  MZ_TV_ThisObject.bgcolor := saveBGColor
  MZ_TV_ThisObject.bold := saveBold
  MZ_TV_ThisObject["uid"] := A_Now
  MZ_GUI_SaveConfig()
  GoSub,ItemGUIClose
}
; MZ_GUI_Item_Reload {{{2
MZ_GUI_Item_Reload()
{
  Global conf,MZ_TVColor,MZ_TVSave,MZ_TVSelectID,MZ_TV_ThisObject,PrevID
  GUI, MZ_GUI: Default
  rid := TV_Modify(MZ_TVSelectID,MZ_GUI_TV_option(MZ_TV_ThisObject),MZ_TV_ThisObject.name)
  MZ_TVSave.Set(3,rid,MZ_TV_ThisObject)
  MZ_TVColor.TV_Color({hwnd:rid,fore:rgb_bgr_swap((f:=MZ_TV_ThisObject.tcolor)?f:(fd:=conf.config.Tcolor)?fd:0),back:rgb_bgr_swap((b:=MZ_TV_ThisObject.BGColor)?b:(bd:=Conf.config.BGColor)?bd:0xffffff)})
/*
  rid := PrevID := MZ_TVSelectID
  item := MZ_TVSave.Get(MZ_TVSelectID)
  MZ_TVColor.TV_Color({hwnd:rid,fore:rgb_bgr_swap(0xffffff),back:rgb_bgr_swap(0x3399ff)})
*/
}

; MZ_GUI_Item_Add {{{2
MZ_GUI_Item_Add:
  Button_Item_Add()
return

Button_Item_Add(cm=false)
{
	GUI,Item: Default
	coordMode,Menu,Screen
  If cm
  {
  }
  Else
  {
    GUIControlGet,SelectID,hwnd,Button6
	  location:=Acc_Location(Acc_ObjectFromWindow(SelectID))
    posx := location.x + location.w
	  posy := location.y + 1
  }
/*
  Menu, Item_Add_file, Add
  Menu, Item_Add_file, Delete
  Menu, Item_Add_file, Add, {file:path}%A_Tab%文件完整路径(&P),MZ_GUI_Item_Add_Label
  Menu, Item_Add_file, Add, {file:name}%A_Tab%文件名(&N),MZ_GUI_Item_Add_Label
  Menu, Item_Add_file, Add, {file:name2}%A_Tab%文件名(不含扩展名)(&S),MZ_GUI_Item_Add_Label
  Menu, Item_Add_file, Add, {file:ext}%A_Tab%文件扩展名(&E),MZ_GUI_Item_Add_Label
  Menu, Item_Add_file, Add, {file:dir}%A_Tab%文件所在目录(&F),MZ_GUI_Item_Add_Label
  Menu, Item_Add_file, Add, {file:drive}%A_Tab%文件所在驱动器(&D),MZ_GUI_Item_Add_Label
  Menu, Item_Add_file, Add, {file:content}%A_Tab%文件内容(仅文本)(&C),MZ_GUI_Item_Add_Label
  Menu, Item_Add_select, Add
  Menu, Item_Add_select, DeleteAll
  Menu, Item_Add_file, Add
  Menu, Item_Add_file, Add, 多文件(&M),MZ_GUI_Item_Add_mfile
  Menu, Item_Add, Add
  Menu, Item_Add, DeleteAll
  Menu, Item_Add, Add, 文件%A_Tab%(&F), MZ_GUI_Item_File
  Menu, Item_Add, Add, 目录%A_Tab%(&D), MZ_GUI_Item_dir
  Menu, Item_Add, Add
  Menu, Item_Add, Add, {file} 文件类%A_Tab%(&F),:Item_Add_file
  Menu, Item_Add, Add, {select} 选择文本%A_Tab%(&S),MZ_GUI_Item_Add_Label
*/
  Menu, Item_Add, Add, 内置变量(&K), MZ_GUI_Item_Env_Inside
  Menu, Item_Add, Add, 用户变量(&U), MZ_GUI_Item_Env
  Menu, Item_Add, Show, %posx%, %posy%
}

MZ_GUI_Item_Add_mfile:
  msgbox more
return
MZ_GUI_Item_Add_Label_Text:
  SCI.InsertText(SCI.GetCurrentPos(),"{Select}")
return
MZ_GUI_Item_Add_Label:
  SCI.InsertText(SCI.GetCurrentPos(),RegExReplace(A_ThisMenuItem,"\t.*$"))
return

; MZ_GUI_Item_File {{{2
MZ_GUI_Item_File:
  MZ_GUI_Item_File()
return
MZ_GUI_Item_File()
{
  Global SCI
  FileSelectfile,file,3,%A_ScriptDir%,MenuZ 选择文件
  SCI.InsertText(SCI.GetCurrentPos(),iRelativePath(file))
  colorstring()
}
; MZ_GUI_Item_dir {{{2
MZ_GUI_Item_dir:
  MZ_GUI_Item_dir()
return
MZ_GUI_Item_dir()
{
  Global SCI
  FileSelectfolder,dir,,3,MenuZ 选择目录
  SCI.InsertText(SCI.GetCurrentPos(),iRelativePath(Dir))
  colorstring()
}
; MZ_GUI_Item_Evn {{{2
MZ_GUI_Item_Env:
  MZ_GUI_Item_Env()
  colorstring()
return
MZ_GUI_Item_Env()
{
  Global conf
  GUI,Env:Default
  GoSub,MZ_GUI_Item_Env_show
  GUI,Env: Show, , MenuZ 用户变量
  for i , k in conf.user_env
  {
    If not strlen(i)
      Continue
    LV_Add("", i , k )
  }
}
MZ_GUI_Item_Env_Inside:
  MZ_GUI_Item_Env_Inside()
  colorstring()
return
MZ_GUI_Item_Env_Inside()
{
  GUI,Env:Default
  GoSub,MZ_GUI_Item_Env_show
  GUIControl,Hide,Button1
  GUIControl,Hide,Button2
  GUIControl,Hide,Button3
  GUI,Env: Show, , MenuZ 内置变量
  v := "Apps|Script|config|Plugins|Icons|A_WorkingDir|A_ScriptDir|A_YYYY|A_MM|A_DD|A_MMMM|A_MMM|A_DDDD|A_DDD|A_WDay|A_YDay|A_YWeek|A_Hour|A_Min|A_Sec|A_MSec|A_Now|A_NowUTC|A_ComputerName|A_UserName|A_WinDir|A_ProgramFiles|A_AppData|A_AppDataCommon|A_Desktop|A_DesktopCommon|A_StartMenu|A_StartMenuCommon|A_Programs|A_ProgramsCommon|A_Startup|A_StartupCommon|A_MyDocuments|A_IPAddress1|A_IPAddress2|A_IPAddress3|A_IPAddress4|ComSpec|LOCALAPPDATA|ProgramData|ProgramFiles|SystemDrive|TEMP"
  LV_Add("", "A_Tab" , "tab 字符")
  LV_Add("", "A_Space" , "空格")
  Loop, Parse, v , |
    LV_Add("", A_LoopField , ReplaceEnv( "`%" A_LoopField "`%" ) )
}



MZ_GUI_Item_Env_show:
GUI, MZ_GUI: +hwndMain_GUI
GUI,Env:Destroy
GUI,Env:Default
GUI,Env:+theme +Owner%main_GUI% 
GUI,Env:Font,s9,Microsoft YaHei
GUI,Env: Add, Text, x10 y10 h24, 请选择变量：
GUI,Env: Add, ListView, x10 y40 w400 h300 Grid gMZ_GUI_Item_Env_ListView, 名称|内容
GUI,Env: Add, Button, x10  y350 w60 h24 gMZ_GUI_Item_Env_Add, 新建(&N)
GUI,Env: Add, Button, x75  y350 w60 h24 gMZ_GUI_Item_Env_Modify, 修改(&M)
GUI,Env: Add, Button, x140 y350 w60 h24 gMZ_GUI_Item_Env_Delete, 删除(&D)
GUI,Env: Add, Button, x240 y350 w80 h24 gMZ_GUI_Item_Env_ListView, 确定(&O)
GUI,Env: Add, Button, x330 y350 w80 h24 gEnvGUIClose, 关闭(&C)
LV_ModifyCol(1,100)
LV_ModifyCol(2,300)
return

EnvGUIEscape:
EnvGUIClose:
  GUI,Env:Destroy
return

MZ_GUI_Item_Env_ListView:
  GUI,Env:Default
  If A_GuiEvent = DoubleClick
  {
    LV_GetText(Env_insert,A_EventInfo)
    SCI.InsertText(SCI.GetCurrentPos(),"%" Env_insert "%")
    GoSub,EnvGUIClose
  }
  If Not A_EventInfo
  {
    LV_GetText(Env_insert,LV_GetNext(0,"focus"))
    SCI.InsertText(SCI.GetCurrentPos(),"%" Env_insert "%")
    GoSub,EnvGUIClose
  }
return

MZ_GUI_Item_Env_Add:
GUI, MZ_GUI: +hwndMain_GUI
GUI,Env_Add:Destroy
GUI,Env_Add:Default
GUI,Env_Add:+theme +Owner%main_GUI% 
GUI,Env_Add:Font,s9,Microsoft YaHei
GUI,Env_Add: Add,Text, x10 y10 h24, 变量名称(&N):
GUI,Env_Add: Add,Edit, x10 y35 h24 w360 ,
GUI,Env_Add: Add,Text, x10 y65 h24, 变量内容(&S):
GUI,Env_Add: Add,Edit, x10 y90 h24 w360 ,
GUI,Env_Add: Add, Button, x200 y120 h24 w80 gMZ_GUI_Item_Env_Add_OK Default, 确认(&O)
GUI,Env_Add: Add, Button, x290 y120 h24 w80 gEnv_AddGUIClose, 取消(&C)
GUI,Env_Add: Show, , MenuZ 添加变量
return

MZ_GUI_Item_Env_Add_OK:
  MZ_GUI_Item_Env_Add_OK()
return

MZ_GUI_Item_Env_Add_OK()
{
  Global conf
  GUI,Env_Add:Default
  GUIControlGet, Key, , Edit1
  GUIControlGet, Value, , Edit2
  
  If conf.user_env.hasKey(key)
  {
    Msgbox , 64, MenuZ, 变量名称已经存在，请使用另外的名称
    return
  }
  conf.user_env[key] := value
  MZ_GUI_SaveConfig()
  GoSub,Env_AddGUIClose
  GUI,Env:Default
  LV_Add("", Key , Value)
}

Env_AddGUIEscape:
Env_AddGUIClose:
  GUI,Env_Add:Destroy
return

MZ_GUI_Item_Env_Modify:
GUI,Env:+hwndEnvGUI
WinSet,Disable, , ahk_id %EnvGUI%
GUI,Env_Modify:Destroy
GUI,Env_Modify:Default
GUI,Env_Modify:+theme +Owner%EnvGUI% 
GUI,Env_Modify:Font,s9,Microsoft YaHei

GUI,Env_Modify: Add,Text, x10 y10 h24 , 变量名称(&N):
GUI,Env_Modify: Add,Edit, x10 y35 h24 w360 Disabled
GUI,Env_Modify: Add,Text, x10 y65 h24, 变量内容(&S):
GUI,Env_Modify: Add,Edit, x10 y90 h24 w360 ,
GUI,Env_Modify: Add, Button, x200 y120 h24 w80 gMZ_GUI_Item_Env_Modify_OK Default , 确认(&O)
GUI,Env_Modify: Add, Button, x290 y120 h24 w80 gEnv_ModifyGUIClose, 取消(&C)

GUI,Env_Modify: Show, , MenuZ 编辑变量
MZ_GUI_Item_Env_Modify_load()
return
MZ_GUI_Item_Env_Modify_load()
{
  Global Conf,Env_ID
  GUI,Env:Default
  Env_ID := (id:=LV_GetNext(0,"focus")) ? id : 1
  LV_GetText(key,Env_ID)
  LV_GetText(value,Env_ID,2)
  GUI,Env_Modify:Default
  GUIControl, , Edit1, %key%
  GUIControl, , Edit2, %value%
}
MZ_GUI_Item_Env_Modify_OK:
  MZ_GUI_Item_Env_Modify_OK()
return
MZ_GUI_Item_Env_Modify_OK()
{
  Global Conf,Env_ID
  GUI,Env_Modify:Default
  GUIControlGet, key, , Edit1
  GUIControlGet, value, , Edit2
  conf.user_env[key] := value
  MZ_GUI_SaveConfig()
  GoSub,Env_ModifyGUIClose
  GUI,Env:Default
  LV_Modify(Env_ID,"", Key , Value)
}

Env_ModifyGUIEscape:
Env_ModifyGUIClose:
  WinSet,Enable, , ahk_id %EnvGUI%
  GUI,Env_Modify:Destroy
return


MZ_GUI_Item_Env_Delete:
  MZ_GUI_Item_Evn_Delete()
return
MZ_GUI_Item_Evn_Delete()
{
  Global conf
  GUI,Env:Default
  Env_ID := (id:=LV_GetNext(0,"focus")) ? id : 1
  LV_GetText(key,Env_ID)
  MsgBox, 68, MenuZ , 是否删除变量( %key% )？`n`n注意: 此操作不可逆！ 请做好备份。
  Ifmsgbox,Yes
  {
    LV_Delete(Env_ID)
    conf.user_env.remove(key)
    MZ_GUI_SaveConfig()
  }
}

; MZ_GUI_Item_Assistant {{{2
MZ_GUI_Item_Assistant:
  Item_Assistant()
return
Item_Assistant()
{
  Global MZ_WB
  GUI, Item: +hwndItemGUI
  GUI, Assistant:Destroy
  GUI, Assistant:Default
  GUI, Assistant:+hwnditemGUI +theme +Owner%ItemGUI% 
  GUI, Assistant:Font,s9,Microsoft YaHei
  GUI, Assistant: Add, Listview,x10 y10 w150 h340 grid AltSubmit gAssistantListView ,参数
  ;GUI, Assistant: Add, Text,  x10 y322  w400 h24 , 搜索(&F):
  ;GUI, Assistant: Add, Edit,  x60 y320  w350 h24
  Gui, Assistant: Add, ActiveX , x172 y12 w370 h336 vMZ_WB , Shell.Explorer
  Gui, Assistant: Add, Text, x170 y10 w376 h340 border
  MZ_WB.Navigate(A_ScriptDir "\Help\file_path.html")
  GUI, Assistant: Add, Button, x220 y355 w90 h26 Default,添加(&I)
  GUI, Assistant: Add, Button, x320 y355 w90 h26 gAssistantGUIClose,取消(&O)
  LV_ModifyCol(1,150)
  Loop, %A_ScriptDir%\Help\*.html
  {
    Splitpath,A_LoopFileFullPath, , , , name2
    LV_Add("","{" RegExReplace(name2,"_",":") "}")
  }
  GUI, Assistant: Show, w550 h390, 添加参数
  OnMessage(0x4e,"")
}
AssistantGUIEscape:
AssistantGUIClose:
  OnMessage(0x4e,"TV_WM_NOTIFY")
  GUI, Assistant:Destroy
return
AssistantListView:
  If A_GUIEvent = Normal
  {
    LV_GetText(ass,A_EventInfo,1)
    ass:= RegExReplace(SubStr(ass,2,strlen(ass)-2),":","_")
    If FileExist(A_ScriptDir "\Help\" ass ".html")
      MZ_WB.Navigate(A_ScriptDir "\Help\" ass ".html")
  }
  If A_GUIEvent = DoubleClick
  {
    If A_EventInfo
      LV_GetText(ass,A_EventInfo,1)
    Else
      LV_GetText(ass,LV_GetNext(0,"Focus"),1)
    SCI.InsertText(SCI.GetCurrentPos(),ass)
    colorstring()
    GoSub,AssistantGUIClose
  }
return
; ItemAdvance {{{2
ItemAdvance:
  ItemAdvance()
return
ItemAdvance()
{
	GUI,Item:Default
	GUI,Item:+LastFound
	GUIControlGet,m,,Button9
	WinGet,c,ID,A
	If m
	{
		GUIControl,Enable,Listbox1
		GUIControl,show,Listbox1
		;GUIControl,Enable,Button9
		;GUIControl,show,Button9
		WinMove,ahk_id %c%,,,,,450
	}
	Else
	{
		GUIControl,disable,Listbox1
		GUIControl,hide,Listbox1
		;GUIControl,disable,Button9
		;GUIControl,hide,Button9
		WinMove,ahk_id %c%,,,,,245
	}
}

; IconSelect {{{2
IconSelect:
GUI,IconSelect:Destroy
GUI,IconSelect:Default
GUI,IconSelect:+theme +hwndhIconGUI
GUI,IconSelect:Font,s9,Microsoft YaHei
GUI,IconSelect:Add,Text,x10 y10 h24 ,查找此路径中的图标:
GUI,IconSelect:Add,Edit    ,x10 y36  w500 h24 r1,`%ICONS`%
GUI,IconSelect:Add,Text,x10 y71 h24 ,视图:
GUI,IconSelect:Add,Radio   ,x48  y68 h24 gGoReport checked,普通(&N)
GUI,IconSelect:Add,Radio   ,x115 y68 h24 gGoList,列表(&L)
GUI,IconSelect:Add,Radio   ,x180 y68 h24 gGoSmallIcons,平铺(&S)
GUI,IconSelect:Add,Radio   ,x245 y68 h24 gGoIcons,大图标(&W)
GUI,IconSelect:Add,Button  ,x340 y68 h26 w80 gButton_Icon_Browse,浏览(&B)
GUI,IconSelect:Add,Button  ,x431 y68 h26 w80 gButton_Icon_Search , 搜索(&Q)
GUI,IconSelect:Add,ListView,x10  y100 w500 h300 nosort -Multi altsubmit gIconSelect_OK ,序号|图标
GUI,IconSelect:Add,Button  ,x250 y410 h26 w80 gIconSelect_Clear, 清除图标(&G)
GUI,IconSelect:Add,Button  ,x340 y410 h26 w80 gButton_Icon_OK Default,确定(&O)
GUI,IconSelect:Add,Button  ,x431 y410 h26 w80 gButton_Icon_Cancel, 取消(&C)
GUI,IconSelect:ListView,SysListView321
LV_ModifyCol(1,60)
GUI,IconSelect:Show,w520 h446 ,请选择图标(双击确认)
GoSub, Button_Icon_Search
OnMessage(0x4e,"")
return
; IconSelect_OK: {{{3
IconSelect_OK:
	If A_GuiEvent = DoubleClick
  {
    Button_Icon_OK(A_EventInfo)
  }
return
Button_Icon_OK:
    Button_Icon_OK()
return
Button_Icon_OK(ID=0)
{
    Global MZ_Item_Icon
		GUI,IconSelect:Default
		GUI,IconSelect:ListView,SysListView321
    If ID
		  LV_GetText(icon,id,2)
    Else
		  LV_GetText(icon,id := LV_GetNext(0,"focused"),2)
    If not id
      return
		GUI,Item:Default
		;GuiControl,,Edit2,%icon%
    MZ_Item_Icon := Icon
		If Strlen(icon){
			If RegExMatch(icon,":[-\d]*$"){
				pos := RegExMatch(Icon,":[^:]*$")
				file   := ReplaceEnv(SubStr(icon,1,pos-1))
				Number := (number := substr(icon,pos+1)) > 0 ? Number + 1 : Number
			}
			Else
				file := ReplaceEnv(icon)
		}
		GuiControl,,Static3,*icon%number% *w16 *h-1 %file%
		GUI,IconSelect:Destroy
}

; IconSelect_Clear: {{{3
IconSelect_Clear:
	GUI,Item:Default
	GuiControl,,Edit2
	GuiControl,,Static3
	GUI,IconSelect:Destroy
return
; Button_Icon_Cancel: {{{3
Button_Icon_Cancel:
	GUI,IconSelect:Destroy
  OnMessage(0x4e,"TV_WM_NOTIFY")
return

; Button_Icon_Browse: {{{3
Button_Icon_Browse:
  Button_Icon_Browse()
return
Button_Icon_Browse()
{
	GUI,IconSelect:Default
  GUIControlGet,IconSelectID,hwnd,Button5
	location:=Acc_Location(Acc_ObjectFromWindow(IconSelectID))
	posx := location.x + 1
	posy := location.y + location.h
	coordMode,Menu,Screen
  Menu, Icon_Browse, Add
  Menu, Icon_Browse, DeleteAll
  Menu, Icon_Browse, Add, 文件%A_Tab%(&F), Button_Icon_File
  Menu, Icon_Browse, Add, 目录%A_Tab%(&D), Button_Icon_Dir
  Menu, Icon_Browse, Add
  Menu, Icon_Browse, Add, Shell32.dll%A_Tab%&1,  Button_Icon_HotList
  Menu, Icon_Browse, Add, imageres.dll%A_Tab%&2, Button_Icon_HotList
  Menu, Icon_Browse, Add, mmcndmgr.dll%A_Tab%&3, Button_Icon_HotList
  Menu, Icon_Browse, Show, %posx%, %posy%
}
Button_Icon_HotList:
	GUI,IconSelect:Default
	GUIControl,,Edit1,% "`%A_WinDir`%\system32\" RegExReplace(A_ThisMenuItem,"\t.*")
  GoSub,Icon_Search_stop
  GoSub,Button_Icon_Search
return
Button_Icon_File:
	Button_Icon_Open()
return
Button_Icon_dir:
	Button_Icon_Open(false)
return
Button_Icon_Open(type=true)
{
	GUI,IconSelect:Default
	If type
		FileSelectFile,file	,3,  , 请选择图标文件 ,图标文件"(*.ICO; *.CUR; *.ANI; *.EXE; *.DLL; *.CPL; *.SCR; *.PNG)"
	Else
		FileSelectFolder,file ,*%A_ScriptDir%\Icons\,2, 选择图标所在的文档
	If not strlen(file)
		return
	GUIControl,,Edit1,%file%
  GoSub,Button_Icon_Search
}
; Button_Icon_Search: {{{3
Button_Icon_Search:
  Settimer,Icon_Search_start,100
return
Icon_Search_start:
  Settimer,Icon_Search_start,off
	GUI,IconSelect:Default
  GUIControl,+gIcon_Search_stop,Button6
	GUIControl,,Button6, 停止搜索(&S)
	Icon_Search_stop := False
	Icon_Search()
return
Icon_Search_stop:
	GUI,IconSelect:Default
	GUIControl,,Button6, 搜索(&Q)
  GUIControl,+gButton_Icon_Search,Button6
	Icon_Search_stop := True
return
Icon_Search(){
	Global Icon_Search_stop
	GUI,IconSelect:Default
	GUI,IconSelect:ListView,SysListView321
	GUIControlGet,file,,Edit1
	file := ReplaceEnv(file)
  If Not FileExist(File)
  {
    GoSub,Icon_Search_stop
    return
  }
  FileGetAttrib,type,%file%
	LV_Delete()
	iconfile := file
	iconfilerel := iRelativePath(file)
	IconListSmall := IL_Create(100,100,0)
	IconListLarge := IL_Create(100,100,1)
	ListID := LV_SetImageList(IconListSmall,1)
	If ListID
		IL_Destroy(ListID)
	ListID := LV_SetImageList(IconListLarge,0)
	If ListID
		IL_Destroy(ListID)
	If not InStr(Type,"D")
	{
		m := 0
		Loop, 9999
		{
			If (id := IL_Add(IconListSmall,Iconfile,A_Index)) {
				IL_Add(IconListLarge,Iconfile,A_Index)
				LV_Add("Icon"  id,A_Index,iconfilerel ":" A_Index-1)
				m++
			}
			Else
				Break
			If Icon_Search_stop
			  Break
		}
		If (not m) And (id := IL_Add(IconListSmall,A_LoopFileFullPath))
    {
			IL_Add(IconListLarge,A_LoopFileFullPath,A_Index)
			LV_Add("Icon" id ,i,iRelativePath(A_LoopFileFullPath))
			i++
		}
	}
	Else
	{
		i := 1
		If InStr(FileExist(IconFile),"D")
		{
			If RegExMatch(IconFile,"\\$")
				IconFile := SubStr(IconFile,1,Strlen(IconFile)-1)
			Loop,%iconfile%\*.*,0,1
			{
				If RegExMatch(A_LoopFileFullPath,"i)(\.ICL)|(\.ICO)|(\.CUR)|(\.ANI)|(\.EXE)|(\.DLL)|(\.CPL)|(\.SCR)|(\.PNG)$")
				{
					m := 0
					Loop,9999
					{
						If (id := IL_Add(IconListSmall,A_LoopFileFullPath,A_Index)) {
							IL_Add(IconListLarge,A_LoopFileFullPath,A_Index)
							LV_Add("Icon" id ,i,iRelativePath(A_LoopFileFullPath)":" A_Index-1)
							i++
							m++
						}
						Else
							Break
						If Icon_Search_stop
							Break
					}
					If ( not m ) and (id := IL_Add(IconListSmall,A_LoopFileFullPath)){
						IL_Add(IconListLarge,A_LoopFileFullPath,A_Index)
						LV_Add("Icon" id ,i,iRelativePath(A_LoopFileFullPath))
						i++
					}
				}
				If Icon_Search_stop
					Break
			}
		}
		;If i = 0
		;	MsgBox % Languages.GetValue(Lang,"select icon folder error")
	}
  GoSub,Icon_Search_stop
}
; GoReport: {{{3
GoReport:
GUI,IconSelect:Default
GUI,IconSelect:ListView,SysListView321
GuiControl,+Report, SysListView321
Return

; GoIcons: {{{3
GoIcons:
GUI,IconSelect:Default
GUI,IconSelect:ListView,SysListView321
GuiControl,+Icon, SysListView321
;Icon_Search(small:=False)
Return

; GoSmallIcons: {{{3
GoSmallIcons:
GUI,IconSelect:Default
GUI,IconSelect:ListView,SysListView321
GUIControl,-Redraw,SysListview321
GuiControl,+Icon, SysListView321
GUIControl,+Redraw,SysListView321
GuiControl,+IconSmall,SysListView321
Return

; GoList: {{{3
GoList:
GUI,IconSelect:Default
GUI,IconSelect:ListView,SysListView321
GuiControl,+List, SysListView321
Return

; StyleSelect {{{2
StyleSelect:
	GUI,Item:Default
	GUIControlGet,StyleSelectID,hwnd,Button2
	location:=Acc_Location(Acc_ObjectFromWindow(StyleSelectID))
	posx := location.x + location.w
	posy := location.y + 1
	coordMode,Menu,Screen
	Menu,StyleSelect,Add
	Menu,StyleSelect,DeleteAll
	Menu,StyleSelect,Add, 文本颜色(&T), StyleSelect_tcolor
	Menu,StyleSelect,Add, 背景颜色(&G), StyleSelect_bgcolor
	Menu,StyleSelect,Add, 加粗(&B),StyleSelect_bold
	Menu,StyleSelect,Add
	;Menu,StyleSelect,Add, 还原上一次配色(&R),StyleSelect_restore
	;Menu,StyleSelect,Add
	Menu,StyleSelect,Add, 清除配色(&C),StyleSelect_default
	If saveBold
		Menu,StyleSelect,Check, 加粗(&B) 
	Else
		Menu,StyleSelect,UnCheck,  加粗(&B)
	Menu,StyleSelect,Show,%posx%,%posy%
return

; StyleSelect_tcolor {{{3
StyleSelect_tcolor:
	GUI,Item:Default
	GUI,Item:+LastFound
	WinGet,hItem,id,A
	GUIControlGet,hEdit1,hwnd,Edit1
	saveTColor := TColor := Rgb(Dlg_Color(saveTColor,hItem))
	newBGColor := SubStr("000000" . RegExReplace(saveBGColor,"i)^0x"),-5)
	newTColor  := SubStr("000000" . RegExReplace(TColor,"i)^0x"),-5)
	CtlColors.Change(hEdit1,newBGcolor,newTColor)
return
; StyleSelect_bgcolor {{{3
StyleSelect_bgcolor:
	GUI,Item:Default
	GUI,Item:+LastFound
	WinGet,hItem,id,A
	GUIControlGet,hEdit1,hwnd,Edit1
	saveBGColor := BGColor := Rgb(Dlg_Color(saveBGColor,hItem))
	newBGColor := SubStr("000000" . RegExReplace(BGColor,"i)^0x"),-5)
	newTColor := SubStr("000000" . RegExReplace(saveTColor,"i)^0x"),-5)
	CtlColors.Change(hEdit1,newBGcolor,newTColor)
return
; StyleSelect_bold {{{3
StyleSelect_bold:
	saveBold := !saveBold
  If saveBold
    GUI,Item:Font,s9 bold,Microsoft YaHei
  Else
    GUI,Item:Font,s9 Norm,Microsoft YaHei
  GUI,Item:Default
  GuiControl, Font, Edit1
return

; StyleSelect_default {{{3
StyleSelect_default:
	GUI,Item:Default
	GUIControlGet,hEdit1,hwnd,Edit1
	saveTColor  := Conf.config.Tcolor
	saveBGColor := Conf.config.BGcolor
	saveBold := false
	CtlColors.Change(hEdit1,SubStr("000000" . RegExReplace(saveBGColor,"i)^0x"),-5),SubStr("000000" . RegExReplace(saveTColor,"i)^0x"),-5))
return
; StyleSelect_restore {{{3
StyleSelect_restore:
	GUI,Item:Default
	GUIControlGet,hEdit1,hwnd,Edit1
	saveTColor := TextColor := strlen(v:=MZ_TV_ThisObject.Tcolor)  ? v : conf.Config.Tcolor
	iTextColor := strlen(TextColor) ? SubStr("000000" . RegExReplace(TextColor,"i)^0x"),-5) : ""
	saveBGColor := BackgroundColor := strlen(v:=MZ_TV_ThisObject.BGcolor) ? v : Conf.config.BGcolor
	iBackgroundColor := strlen(BackgroundColor) ? SubStr("000000" . RegExReplace(BackgroundColor,"i)^0x"),-5) : ""
	CtlColors.Change(hEdit1,iBackgroundColor,iTextColor)
return

; Dlg_Color(Color,hwnd) {{{3
2Dlg_Color(Color,hwnd){
	static
;  Global conf
	if !cc{
		VarSetCapacity(CUSTOM,16*A_PtrSize,0),cc:=1,size:=VarSetCapacity(CHOOSECOLOR,9*A_PtrSize,0)
		Loop,16{
      col := conf.color.(A_Index)
			NumPut(col,CUSTOM,(A_Index-1)*4,"UInt")
		}
	}
	NumPut(size,CHOOSECOLOR,0,"UInt"),NumPut(hwnd,CHOOSECOLOR,A_PtrSize,"UPtr")
	,NumPut(Color,CHOOSECOLOR,3*A_PtrSize,"UInt"),NumPut(3,CHOOSECOLOR,5*A_PtrSize,"UInt")
	,NumPut(&CUSTOM,CHOOSECOLOR,4*A_PtrSize,"UPtr")
	ret:=DllCall("comdlg32\ChooseColor","UPtr",&CHOOSECOLOR,"UInt")
	if !ret
	exit
	Loop,16
    conf.color[""][A_Index] := col := NumGet(custom,(A_Index-1)*4,"UInt")
  MZ_GUI_SaveConfig()
	return Color
}

Dlg_Color(Color,hwnd){
;http://www.autohotkey.com/board/topic/94083-ahk-11-font-and-color-dialogs/
;Author => maestrith
	static
  Global conf
	if !cc{
		VarSetCapacity(CUSTOM,16*A_PtrSize,0),cc:=1,size:=VarSetCapacity(CHOOSECOLOR,9*A_PtrSize,0)
    Loop,16{
      col := conf.mz_color[A_Index]
			NumPut(col,CUSTOM,(A_Index-1)*4,"UInt")
		}
	}
	NumPut(size,CHOOSECOLOR,0,"UInt"),NumPut(hwnd,CHOOSECOLOR,A_PtrSize,"UPtr")
	,NumPut(Color,CHOOSECOLOR,3*A_PtrSize,"UInt"),NumPut(3,CHOOSECOLOR,5*A_PtrSize,"UInt")
	,NumPut(&CUSTOM,CHOOSECOLOR,4*A_PtrSize,"UPtr")
	ret:=DllCall("comdlg32\ChooseColor","UPtr",&CHOOSECOLOR,"UInt")
	if !ret
	exit
	rColor:=NumGet(CHOOSECOLOR,3*A_PtrSize,"UInt")
  If Not IsObject(conf.mz_color)
    conf["mz_color"] := ""
	Loop,16
    conf.mz_color[A_Index] := NumGet(custom,(A_Index-1)*4,"UInt")
  MZ_GUI_SaveConfig()
	return rColor
}
rgb(c){
	setformat,IntegerFast,H
	c:=(c&255)<<16|(c&65280)|(c>>16),c:=SubStr(c,1)
	SetFormat,IntegerFast,D
	return c
}
; MZ_SearchMenu {{{1
MZ_SearchMenu:
  MZ_SearchMenu()
return
MZ_SearchMenu()
{
Global main_GUI
GUI,Search:Destroy
GUI,Search:Default
GUI,Search:+theme +Owner%main_GUI%  +hwndSearchGUI
GUI,Search:Font,s9,Microsoft YaHei
GUI,Search: Add, Text , x10 y13 ,搜索(&F):
GUI,Search: Add, Edit , x65 y10 w205 gMZ_SearchMenuGo
GUI,Search: Add, Text , x10 y45 ,菜单项:
GUI,Search: Add, Text , x65 y45 , ( 请使用左键定位、右键编辑 )
GUI,Search: Add, TreeView , x10 y70 w260 h250 -Lines AltSubmit gMZ_SearchMenuRightClick
GUI,Search: Show,w280 h330, 搜索菜单项
Control,Style,+0x1000,SysTreeView321,ahk_id %SearchGUI%
}
SearchGUIEscape:
SearchGUIClose:
  GUI,Search:Destroy
return
MZ_SearchMenuRightClick:
  If A_GUIEvent = Normal
  {
    MZ_TVSelectID := MZ_SearchSave[A_EventInfo]
    GUI, MZ_GUI: Default
    TV_GetText(MZ_TVSelect,MZ_TVSelectID)
    SB_SetText(MZ_GetSBText(MZ_TVSave.GetLV(MZ_TVSelectID),MZ_TVSelectID))
    TV_Modify(MZ_TVSelectID,"visfirst select")
    MZ_TV_ThisObject := MZ_TVSave.Get(MZ_TVSelectID)
  }
  If A_GUIEvent = RightClick
  {
    MZ_TVSelectID := MZ_SearchSave[A_EventInfo]
    GUI, MZ_GUI: Default
    TV_GetText(MZ_TVSelect,MZ_TVSelectID)
    SB_SetText(MZ_GetSBText(MZ_TVSave.GetLV(MZ_TVSelectID),MZ_TVSelectID))
    TV_Modify(MZ_TVSelectID,"visfirst select")
    MZ_TV_ThisObject := MZ_TVSave.Get(MZ_TVSelectID)
    GoSub,MZ_GUI_Item
  }
return
MZ_SearchMenuGo:
  MZ_SearchMenuGo()
return
MZ_SearchMenuGo()
{
  Global MZ_TVSave,MZ_SearchSave
  MZ_SearchSave := []
  GUI,Search:Default
  TV_Delete()
  GUIControlGet,f,,Edit1
  If not strlen(f)
  {
    TV_Delete()
    return
  }
  GUIControl,-Redraw,SysTreeview321
  ItemID = 0  ; 这样使得首次循环从树的顶部开始搜索.
  Loop
  {
    GUI,MZ_GUI:Default
    ItemID := TV_GetNext(ItemID, "Full")  ; 把 "Full" 替换为 "Checked" 来找出所有含复选标记的项目.
    if not ItemID  ; 没有更多项目了.
        break
    If MZ_TVSave.GetLV(ItemID) < 3
      Continue
    TV_GetText(ItemText, ItemID)
    If InStr(zh2py(ItemText),f)
    {
      GUI,Search:Default
      MZ_SearchSave[TV_Add(ItemText,"")] := ItemID
    }
  }
  GUI,Search:Default
  GUIControl,+Redraw,SysTreeview321
}
; MZ_AddMenuItem {{{1
MZ_AddMenuItemDown:
  MZ_AddMenuItem(True)
return
MZ_AddMenuItemUp:
  MZ_AddMenuItem(False)
return
MZ_AddMenuItem(Direction)
{
  Global Main_GUI,MZ_TVSave
  GUI, MZ_GUI: Default
  MZ_TVSelectID:=TV_GetSelection()
  Level := MZ_TVSave.GetLV(MZ_TVSelectID)
  If Level = 1 
  {
    Msgbox , 64, MenuZ, 请选择菜单筛选器或者菜单项
    return
  }
  GUI,Item_New: Destroy
  GUI,Item_New: Default
  GUI,Item_New: +theme +Owner%main_GUI% 
  GUI,Item_New: Font,s9,Microsoft YaHei
  If Direction
    GUI,Item_New: Add, Text, x10  y10 h24 , 新建菜单项
  Else
    GUI,Item_New: Add, Text, x10  y10 h24 , 新建菜单项[在本项之前]
  GUI,Item_New: Add, Edit, x10  y40 w300 
  GUI,Item_New: Add, Button, x110  y80 w90 Default gMZ_AddMenuItemOK, 确定(&O)
  GUI,Item_New: Add, Button, x220  y80 w90 gItem_NewGUIClose, 取消(&C)
  GUI,Item_New: Add, CheckBox, x1  y80 w90 hidden
  GUI,Item_New: show, h120 , 新建菜单项
  GUIControl,,Button3,%Direction%
}
Item_NewGUIEscape:
Item_NewGUIClose:
  GUI,Item_New: Destroy
return
MZ_AddMenuItemOK:
  MZ_AddMenuItemOK()
return
MZ_AddMenuItemOK()
{
  Global MZ_TVSave,MZ_TVSelect,MZ_TVSelectID,MZ_TV_ThisObject,MZ_TVColor,conf
  GUI,Item_New: Default
  GUIControlGet,ItemName,,Edit1
  GUIControlGet,Direction,,Button3 ; true 为向下 false 向上
  GUI, MZ_GUI: Default
  MZ_TVSelectID:=TV_GetSelection()
  TV_GetText(MZ_TVSelect,MZ_TVSelectID)
  MZ_TV_ThisObject := MZ_TVSave.Get(MZ_TVSelectID)
  MZ_TV_ThisObjectParent := MZ_TVSave.Get(ParentID:=TV_GetParent(MZ_TVSelectID))
  addr1 := &MZ_TV_ThisObject
  Level := MZ_TVSave.GetLV(ParentID)
  If Level = 1 ; 当前选择菜单筛选器
  {
    MZ_TV_ThisObject.add("- name: " ItemName)
    MZ_TV_ThisObject := MZ_TV_ThisObject.(MZ_TV_ThisObject.()) ; 添加后子菜单后，重新将子菜单赋值给MZ_TV_ThisObject
    rid := TV_Add(ItemName,MZ_TVSelectID,"vis select icon9999")
  }
  If Level = 2 ; 当前选择为菜单筛选器的一级菜单
  {
    Loop,% MZ_TV_ThisObjectParent.()
    {
      pobj := MZ_TV_ThisObjectParent.(A_Index)
      addr2 := &pobj
      If addr1 = %addr2%
      {
        ID := A_Index
        break
      }
    }
    MZ_TV_ThisObjectParent[""].Insert(ID+Direction,{"name":ItemName})
    MZ_TV_ThisObject := MZ_TV_ThisObjectParent.(ID+Direction)
    GUI, MZ_GUI: Default
    If Direction
      rid := TV_Add(ItemName,ParentID,"vis select icon9999 " MZ_TVSelectID)
    Else
    {
      If (PrevID := TV_GetPrev(MZ_TVSelectID))
        rid := TV_Add(ItemName,ParentID,"vis select icon9999 " PrevID)
      Else
        rid := TV_Add(ItemName,ParentID,"vis select icon9999 first")
    }
  }
  If Level = 3 ; 当前选择为二级或以下菜单
  {
    Loop,% MZ_TV_ThisObjectParent.sub.()
    {
      pobj := MZ_TV_ThisObjectParent.sub.(A_Index)
      addr2 := &pobj
      If addr1 = %addr2%
      {
        ID := A_Index
        break
      }
    }
    MZ_TV_ThisObjectParent.sub[""].Insert(ID+Direction,{"name":ItemName})
    MZ_TV_ThisObject := MZ_TV_ThisObjectParent.sub.(ID+Direction)
    GUI, MZ_GUI: Default
    If Direction
      rid := TV_Add(ItemName,ParentID,"vis select icon9999 " MZ_TVSelectID)
    Else
    {
      If (PrevID := TV_GetPrev(MZ_TVSelectID))
        rid := TV_Add(ItemName,ParentID,"vis select icon9999 " PrevID)
      Else
        rid := TV_Add(ItemName,ParentID,"vis select icon9999 first")
    }
  }
  MZ_TVSave.Set(3,rid,MZ_TV_ThisObject)
  MZ_TVColor.TV_Color({hwnd:rid,fore:rgb_bgr_swap((fd:=conf.config.Tcolor)?fd:0),back:rgb_bgr_swap((bd:=Conf.config.BGColor)?bd:0xffffff)})
  SB_SetText("请选择菜单")
  GoSub,Item_NewGUIClose
  MZ_GUI_SaveConfig()
  GUI,MZ_GUI:Default
  MZ_TVSelectID := TV_GetSelection()
  TV_GetText(MZ_TVSelect,MZ_TVSelectID)
  SB_SetText(MZ_GetSBText(MZ_TVSave.GetLV(MZ_TVSelectID),MZ_TVSelectID))
  GoSub,MZ_GUI_Item
}

; MZ_AddMenuSub {{{1

MZ_AddMenuSub:
  MZ_AddMenuSub()
return
MZ_AddMenuSub()
{
  Global Main_GUI,MZ_TVSave
  GUI, MZ_GUI: Default
  MZ_TVSelectID:=TV_GetSelection()
  Level := MZ_TVSave.GetLV(MZ_TVSelectID)
  Obj := MZ_TVSave.Get(MZ_TVSelectID)
  If Level <> 3 
  {
    Msgbox , 64, MenuZ, 请选择菜单项
    return
  }
  If IsObject(obj.sub)
  {
    Msgbox , 64, MenuZ, 子菜单已经存在
    return
  }
  GUI,Item_Sub: Destroy
  GUI,Item_Sub: Default
  GUI,Item_Sub: +theme +Owner%main_GUI% 
  GUI,Item_Sub: Font,s9,Microsoft YaHei
  GUI,Item_Sub: Add, Text, x10  y10 h24 , 新建子菜单项
  GUI,Item_Sub: Add, Edit, x10  y40 w300 
  GUI,Item_Sub: Add, Button, x110  y80 w90 Default gMZ_AddMenuSubOK, 确定(&O)
  GUI,Item_Sub: Add, Button, x220  y80 w90 gItem_SubGUIClose, 取消(&C)
  GUI,Item_Sub: Add, CheckBox, x1  y80 w90 hidden
  GUI,Item_Sub: show, h120 , 新建菜单项
}
Item_SubGUIEscape:
Item_SubGUIClose:
  GUI,Item_Sub: Destroy
return
MZ_AddMenuSubOK:
  MZ_AddMenuSubOK()
return
MZ_AddMenuSubOK()
{
  Global MZ_TVSave,MZ_TVSelect,MZ_TVSelectID,MZ_TV_ThisObject,MZ_TVColor,conf
  GUI,Item_Sub: Default
  GUIControlGet,ItemName,,Edit1
  GUI, MZ_GUI: Default
  MZ_TVSelectID:=TV_GetSelection()
  TV_GetText(MZ_TVSelect,MZ_TVSelectID)
  MZ_TV_ThisObject := MZ_TVSave.Get(MZ_TVSelectID)
  MZ_TV_ThisObject.add("sub: ")
  MZ_TV_ThisObject.sub.add("- name: " ItemName)
  MZ_TV_ThisObject := MZ_TV_ThisObject.sub.(1)
  rid := TV_Add(ItemName,MZ_TVSelectID,"vis select icon9999")
  MZ_TVSave.Set(3,rid,MZ_TV_ThisObject)
  MZ_TVColor.TV_Color({hwnd:rid,fore:rgb_bgr_swap((fd:=conf.config.Tcolor)?fd:0),back:rgb_bgr_swap((bd:=Conf.config.BGColor)?bd:0xffffff)})
  GoSub,Item_SubGUIClose
  GUI,MZ_GUI:Default
  MZ_TVSelectID := TV_GetSelection()
  TV_GetText(MZ_TVSelect,MZ_TVSelectID)
  SB_SetText(MZ_GetSBText(MZ_TVSave.GetLV(MZ_TVSelectID),MZ_TVSelectID))
  GoSub,MZ_GUI_Item
  MZ_GUI_SaveConfig()
}

; MZ_AddMenuSep {{{1
MZ_AddMenuSep:
  MZ_AddMenuSep()
return
MZ_AddMenuSep()
{
  Global MZ_TVSave,MZ_TVSelect,MZ_TVSelectID,MZ_TV_ThisObject,MZ_TVColor,conf
  ItemName := "----------"
  Direction := True
  GUI, MZ_GUI: Default
  MZ_TVSelectID:=TV_GetSelection()
  TV_GetText(MZ_TVSelect,MZ_TVSelectID)
  MZ_TV_ThisObject := MZ_TVSave.Get(MZ_TVSelectID)
  MZ_TV_ThisObjectParent := MZ_TVSave.Get(ParentID:=TV_GetParent(MZ_TVSelectID))
  addr1 := &MZ_TV_ThisObject
  Level := MZ_TVSave.GetLV(ParentID)
  If Level = 1 ; 当前选择菜单筛选器
  {
    MZ_TV_ThisObject.add("- name: " ItemName)
    MZ_TV_ThisObject := MZ_TV_ThisObject.(MZ_TV_ThisObject.()) ; 添加后子菜单后，重新将子菜单赋值给MZ_TV_ThisObject
    rid := TV_Add(ItemName,MZ_TVSelectID,"vis select icon9999")
  }
  If Level = 2 ; 当前选择为菜单筛选器的一级菜单
  {
    Loop,% MZ_TV_ThisObjectParent.()
    {
      pobj := MZ_TV_ThisObjectParent.(A_Index)
      addr2 := &pobj
      If addr1 = %addr2%
      {
        ID := A_Index
        break
      }
    }
    MZ_TV_ThisObjectParent[""].Insert(ID+Direction,{"name":ItemName})
    MZ_TV_ThisObject := MZ_TV_ThisObjectParent.(ID+Direction)
    GUI, MZ_GUI: Default
    If Direction
      rid := TV_Add(ItemName,ParentID,"vis select icon9999 " MZ_TVSelectID)
    Else
    {
      If (PrevID := TV_GetPrev(MZ_TVSelectID))
        rid := TV_Add(ItemName,ParentID,"vis select icon9999 " PrevID)
      Else
        rid := TV_Add(ItemName,ParentID,"vis select icon9999 first")
    }
  }
  If Level = 3 ; 当前选择为二级或以下菜单
  {
    Loop,% MZ_TV_ThisObjectParent.sub.()
    {
      pobj := MZ_TV_ThisObjectParent.sub.(A_Index)
      addr2 := &pobj
      If addr1 = %addr2%
      {
        ID := A_Index
        break
      }
    }
    MZ_TV_ThisObjectParent.sub[""].Insert(ID+Direction,{"name":ItemName})
    MZ_TV_ThisObject := MZ_TV_ThisObjectParent.sub.(ID+Direction)
    GUI, MZ_GUI: Default
    If Direction
      rid := TV_Add(ItemName,ParentID,"vis select icon9999 " MZ_TVSelectID)
    Else
    {
      If (PrevID := TV_GetPrev(MZ_TVSelectID))
        rid := TV_Add(ItemName,ParentID,"vis select icon9999 " PrevID)
      Else
        rid := TV_Add(ItemName,ParentID,"vis select icon9999 first")
    }
  }
  MZ_TVSave.Set(3,rid,MZ_TV_ThisObject)
  MZ_TVColor.TV_Color({hwnd:rid,fore:rgb_bgr_swap((fd:=conf.config.Tcolor)?fd:0),back:rgb_bgr_swap((bd:=Conf.config.BGColor)?bd:0xffffff)})
  MZ_GUI_SaveConfig()
  MZ_GUI_ReDraw()
}

; MZ_DeleteMenuItem {{{1
MZ_DeleteMenuItem:
  MZ_DeleteMenuItem()
return
MZ_DeleteMenuItem()
{
  Global MZ_TVSave
  GUI, MZ_GUI: Default
  MZ_TVSelectID:=TV_GetSelection()
  TV_GetText(MZ_TVSelect,MZ_TVSelectID)
  Level := MZ_TVSave.GetLV(MZ_TVSelectID)
  If Level <> 3 
  {
    Msgbox , 64, MenuZ, 请选择菜单项
    return
  }
  MsgBox, 68, MenuZ , 请确认是否删除菜单项( %MZ_TVSelect% )？`n`n注意: 此操作不可逆！ 请做好备份。
  IfMsgbox,no
    return
  MZ_TV_ThisObject := MZ_TVSave.Get(MZ_TVSelectID)
  MZ_TV_ThisObjectParent := MZ_TVSave.Get(ParentID:=TV_GetParent(MZ_TVSelectID))
  addr1 := &MZ_TV_ThisObject
  Level := MZ_TVSave.GetLV(ParentID)
  If Level = 2 ; 当前选择为菜单筛选器的一级菜单
    Parent := MZ_TV_ThisObjectParent
  If Level = 3 
    Parent := MZ_TV_ThisObjectParent.sub
  Loop,% Parent.()
  {
    pobj := Parent.(A_Index)
    addr2 := &pobj
    If addr1 = %addr2%
    {
      ID := A_Index
      break
    }
  }
  TV_Delete(MZ_TVSelectID)
  Parent[""].Remove(ID)
  MZ_GUI_SaveConfig()
}
; MZ_MoveDown {{{1
MZ_MoveDown:
  MZ_MoveDown()
return
MZ_MoveDown()
{
  Global MZ_TVSave,MZ_TVColor,conf
  GUI, MZ_GUI: Default
  MZ_TVSelectID := TV_GetSelection()
  Level := MZ_TVSave.GetLV(MZ_TVSelectID)
  If Level <> 3 
  {
    Msgbox , 64, MenuZ, 请选择菜单项
    return
  }
  ParentID := TV_GetParent(MZ_TVSelectID)
  If ( NextID := TV_GetNext(MZ_TVSelectID))
  {
    thisObj := MZ_TVSave.Get(MZ_TVSelectID)
    NextObj := MZ_TVSave.Get(NextID)
    cid := TV_Add(NextObj.name,ParentID,MZ_GUI_TV_option(NextObj) " " MZ_TVSelectID)
    MZ_TVSave.Set(3,cid,NextObj)
    MZ_TVColor.TV_Color({hwnd:cid,fore:rgb_bgr_swap((f:=NextObj.tcolor)?f:(fd:=conf.config.Tcolor)?fd:0),back:rgb_bgr_swap((b:=NextObj.BGColor)?b:(bd:=Conf.config.BGColor)?bd:0xffffff)})
    MZ_GUI_LoadDataSub(NextObj.sub,cid)
    did := TV_Add(thisObj.name,ParentID,MZ_GUI_TV_option(ThisObj) " select " cid)
    MZ_TVSave.Set(3,did,thisObj)
    MZ_TVColor.TV_Color({hwnd:did,fore:rgb_bgr_swap((f:=thisObj.tcolor)?f:(fd:=conf.config.Tcolor)?fd:0),back:rgb_bgr_swap((b:=thisObj.BGColor)?b:(bd:=Conf.config.BGColor)?bd:0xffffff)})
    MZ_GUI_LoadDataSub(thisObj.sub,did)
    TV_Delete(MZ_TVSelectID)
    TV_Delete(NextId)
    ; 找到父对象
    ParentObject := MZ_TVSave.Get(ParentID)
    ; 找到当前位置
    Level := MZ_TVSave.GetLV(ParentID)
    addr1 := &thisobj
    If Level = 2
    {
      Loop,% ParentObject.()
      {
        pobj := ParentObject.(A_Index)
        addr2 := &pobj
        If addr1 = %addr2%
        {
          ID := A_Index
          break
        }
      } 
    ; 进行互换
      v := ParentObject.(ID+1)
      ParentObject.(ID+1) := ParentObject.(ID)
      ParentObject.(ID) := v
    }
    Else
    {
      Loop,% ParentObject.sub.()
      {
        pobj := ParentObject.sub.(A_Index)
        addr2 := &pobj
        If addr1 = %addr2%
        {
          ID := A_Index
          break
        }
      } 
    ; 进行互换
      v := ParentObject.(ID+1)
      ParentObject.(ID+1) := ParentObject.(ID)
      ParentObject.(ID) := v
    }
    ; 保存配置
    MZ_GUI_SaveConfig()
  }
  Else
    Msgbox , 64, MenuZ, 已经是最后一项，无法下移
  MZ_GUI_ReDraw()
}

; MZ_MoveUp {{{1
MZ_MoveUp:
  MZ_MoveUp()
return
MZ_MoveUp()
{
  Global MZ_TVSave,MZ_TVColor,conf
  GUI, MZ_GUI: Default
  MZ_TVSelectID := TV_GetSelection()
  Level := MZ_TVSave.GetLV(MZ_TVSelectID)
  If Level <> 3 
  {
    Msgbox , 64, MenuZ, 请选择菜单项
    return
  }
  ParentID := TV_GetParent(MZ_TVSelectID)
  If ( PrevID := TV_GetPrev(MZ_TVSelectID))
  {
    ; 在前一个项A与B之间，新建项c、d 
    PrevObj := MZ_TVSave.Get(PrevID)
    thisObj := MZ_TVSave.Get(MZ_TVSelectID)
    ; 把b的内容赋值给c
    cid := TV_Add(thisobj.name,ParentID,MZ_GUI_TV_option(thisObj) " select " PrevID)
    MZ_TVSave.Set(3,cid,thisObj)
    MZ_TVColor.TV_Color({hwnd:cid,fore:rgb_bgr_swap((f:=thisObj.tcolor)?f:(fd:=conf.config.Tcolor)?fd:0),back:rgb_bgr_swap((b:=thisObj.BGColor)?b:(bd:=Conf.config.BGColor)?bd:0xffffff)})
    MZ_GUI_LoadDataSub(thisObj.sub,cid)
    ; 把A的内容赋值给d
    did := TV_Add(prevobj.name,ParentID,MZ_GUI_TV_option(PrevObj) " " cid)
    MZ_TVSave.Set(3,did,prevobj)
    MZ_TVColor.TV_Color({hwnd:did,fore:rgb_bgr_swap((f:=prevObj.tcolor)?f:(fd:=conf.config.Tcolor)?fd:0),back:rgb_bgr_swap((b:=prevObj.BGColor)?b:(bd:=Conf.config.BGColor)?bd:0xffffff)})
    MZ_GUI_LoadDataSub(prevObj.sub,did)
    ; 删除 A 与 B
    TV_Delete(PrevID)
    TV_Delete(MZ_TVSelectID)
    ; 找到父对象
    ParentObject := MZ_TVSave.Get(ParentID)
    ; 找到当前位置
    Level := MZ_TVSave.GetLV(ParentID)
    addr1 := &thisobj
    If Level = 2
    {
      Loop,% ParentObject.()
      {
        pobj := ParentObject.(A_Index)
        addr2 := &pobj
        If addr1 = %addr2%
        {
          ID := A_Index
          break
        }
      } 
    ; 进行互换
      v := ParentObject.(ID-1)
      ParentObject.(ID-1) := ParentObject.(ID)
      ParentObject.(ID) := v
    }
    Else
    {
      Loop,% ParentObject.sub.()
      {
        pobj := ParentObject.sub.(A_Index)
        addr2 := &pobj
        If addr1 = %addr2%
        {
          ID := A_Index
          break
        }
      } 
    ; 进行互换
      v := ParentObject.sub.(ID-1)
      ParentObject.sub.(ID-1) := ParentObject.sub.(ID)
      ParentObject.sub.(ID) := v
    }
    ; 保存配置
    MZ_GUI_SaveConfig()
  }
  Else
    Msgbox , 64, MenuZ, 已经是第一项，无法上移
  MZ_GUI_ReDraw()
}

; MZ_Setting {{{1
MZ_Setting:
GUI,Setting:+hwndsGUI
sci.Add(sGUI, 10, 10 , 400, 300, A_ScriptDir "\Lib\LexAHKL.dll")
sci.SetWrapMode(true) ; this removes the horizontal scrollbar
sci.SetMarginWidthN(1, 0) ; this removes the left margin
sci.StyleSetFont(STYLE_DEFAULT, "Microsoft YaHei") 
sci.StyleSetSize(STYLE_DEFAULT, 10)
sci.SetCodePage(936)
SCI.SETLEXER(48)
/*
Public Const SCE_YAML_DEFAULT = 0
Public Const SCE_YAML_COMMENT = 1
Public Const SCE_YAML_IDENTIFIER = 2
Public Const SCE_YAML_KEYWORD = 3
Public Const SCE_YAML_NUMBER = 4
Public Const SCE_YAML_REFERENCE = 5
Public Const SCE_YAML_DOCUMENT = 6
Public Const SCE_YAML_TEXT = 7
Public Const SCE_YAML_ERROR = 8
*/
sci.StyleSetFore(0, 0x000000)
sci.StyleSetFore(1, 0x008000)
sci.StyleSetFore(2, 0x000080)
sci.StyleSetFore(3, 0x0000FF)
sci.StyleSetFore(4, 0xFF8040)
sci.StyleSetFore(5, 0x804000)
sci.StyleSetFore(6, 0x0000FF)
sci.StyleSetFore(7, 0x808080)
sci.StyleSetFore(8, 0xFF0000)
sci.AUTOCSETSEPARATOR(10)
SCI.CLEARCMDKEY(Asc("Q")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("S")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("W")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("G")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("F")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("H")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("H")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("E")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("R")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("O")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("P")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("K")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("N")+(SCMOD_CTRL<<16))
SCI.CLEARCMDKEY(Asc("B")+(SCMOD_CTRL<<16))
SCI.SetText(unused,yaml_dump(conf.config))
GUI,Setting:Show, w420 h320, 全局设置（测试效果）
return
SettingGUIClose:
  GUI, Setting: Destroy
  OnMessage(0x4e,"TV_WM_NOTIFY")
return

MZ_Help:
  msgbox 帮助界面未完成
return
MZ_Viewer_All:
GUI, MZ_GUI: Default
TV_Delete()
MZ_TVSave := new MZ_Data_Save
MZ_TVColor := new TreeView(hMZ_GUI_TV)
MZ_TVSave.SetType(MZ_GUI_LoadData("【内置菜单】================================== |",conf.menu_default,"%windir%\system32\shell32.dll:43"),"default")
MZ_TVSave.SetType(MZ_GUI_LoadData("【文件菜单】================================== |",conf.menu_file , "%windir%\system32\shell32.dll:54"),"file")
MZ_TVSave.SetType(MZ_GUI_LoadData("【文本菜单】================================== |",conf.menu_text ,"%windir%\system32\shell32.dll:1"),"text")
MZ_TVSave.SetType(MZ_GUI_LoadData("【窗口菜单】================================== |",conf.menu_class, "%windir%\system32\shell32.dll:2"),"class")
return
MZ_Viewer_Default:
GUI, MZ_GUI: Default
TV_Delete()
MZ_TVSave := new MZ_Data_Save
MZ_TVColor := new TreeView(hMZ_GUI_TV)
MZ_TVSave.SetType(MZ_GUI_LoadData("【内置菜单】================================== |",conf.menu_default,"%windir%\system32\shell32.dll:43"),"default")
return
MZ_Viewer_file:
GUI, MZ_GUI: Default
TV_Delete()
MZ_TVSave := new MZ_Data_Save
MZ_TVColor := new TreeView(hMZ_GUI_TV)
MZ_TVSave.SetType(MZ_GUI_LoadData("【文件菜单】================================== |",conf.menu_file , "%windir%\system32\shell32.dll:54"),"file")
return
MZ_Viewer_text:
GUI, MZ_GUI: Default
TV_Delete()
MZ_TVSave := new MZ_Data_Save
MZ_TVColor := new TreeView(hMZ_GUI_TV)
MZ_TVSave.SetType(MZ_GUI_LoadData("【文本菜单】================================== |",conf.menu_text ,"%windir%\system32\shell32.dll:1"),"text")
return
MZ_Viewer_class:
GUI, MZ_GUI: Default
TV_Delete()
MZ_TVSave := new MZ_Data_Save
MZ_TVColor := new TreeView(hMZ_GUI_TV)
MZ_TVSave.SetType(MZ_GUI_LoadData("【窗口菜单】================================== |",conf.menu_class, "%windir%\system32\shell32.dll:2"),"class")
return

; MZ_TB_Notify(hCtrl, Event, Txt, Pos) {{{1
MZ_TB_Notify(hCtrl, Event, Txt, Pos, Item)
{
  If Event = Click
  {
    If Item = 101
      GoSub,MZ_AddMenuItemDown
    If Item = 102
      GoSub,MZ_AddMenuItemUp
    If Item = 103
      GoSub,MZ_AddMenuSub
    If Item = 104
      GoSub,MZ_AddMenuSep
    If Item = 105
      GoSub,MZ_DeleteMenuItem
    If Item = 106
      GoSub,MZ_MoveDown
    If Item = 107
      GoSub,MZ_MoveUp
    If Item = 201
      GoSub,MZ_GUI_Filter_New
    If Item = 202
      GoSub,MZ_GUI_Filter_Remove
    MZ_SearchMenuGo()
  }
}
; MZ_LoadPlugin() {{{1
MZ_LoadPlugin()
{
  Global MZ_Plugin
  MZ_Plugin := []
  ; 加载所有可用的function
  Loop, %A_ScriptDir%\plugin\*.ahk
  {
    p := Class_EasyINI(A_LoopFileFullPath)
    k := p.Getkeys("Plugin")
    Loop,Parse, k ,`n
    {
      If RegExMatch(A_LoopField,"^[\s]*\*/[\s]*$")
        break
      MZ_Plugin[A_LoopField]:=p["plugin"][A_LoopField]
    }
  }
  ; 判断是否有function的增加、修改、删除，如果是,必须reload
  If CheckPlugin()
    MZ_GUI_Command("-r")    
}
CheckPlugin()
{
	PluginAHK := A_ScriptDir "\lib\MZ_Plugin.ahk"
  ; 是否修改
  p := Class_EasyINI(PluginAHK)
  k := p.Getkeys("PluginTime")
  Loop,Parse, k ,`n
  {
    If RegExMatch(A_LoopField,"^[\s]*\*/[\s]*$")
      break
    ; 是否删除
    If Not FileExist( A_ScriptDir "\plugin\" A_LoopField ".ahk")
    {
      rv := True
      break
    }
    old_time := p["pluginTime"][A_LoopField]
    FileGetTime,new_time,%A_ScriptDir%\Plugin\%A_LoopField%.ahk,M
    If old_time <> %new_time%
    {
      rv := True
      break
    }
  }
  ; 是否新增
	Loop,%A_ScriptDir%\Plugin\*.ahk
  {
    If not RegExMatch(A_LoopFileFullPath,"i)\.ahk$")
      Continue
    If not p["pluginTime"][RegExReplace(A_LoopFileName,"i)\.ahk$")]
    {
      rv := True
      break
    }
  }
	; 清理无用#include
	Filedelete,%PluginAHK%
	FileAppend,%NewPlugin%,%PluginAHK%
	Loop,%A_ScriptDir%\Plugin\*.ahk
		  FileAppend,#include `%A_ScriptDir`%\Plugin\%A_LoopFileName%`n , %PluginAHK%
	; 保存修改时间
	SaveTime := "/*`r`n[PluginTime]`r`n"
	Loop,%A_ScriptDir%\Plugin\*.ahk
	{
		If RegExMatch(A_LoopFileName,"i)^Plugin.ahk$")
			Continue
		FileGetTime,PluginTime,%A_LoopFileFullPath%,M
		SaveTime .= RegExReplace(A_LoopFileName,"i)\.ahk$") "=" PluginTime "`r`n"
	}
	SaveTime .= "*/`r`n"
	FileAppend,%SaveTime%,%PluginAHK%
  return rv
}
; Lib {{{1
; Class MZ_Data_Save {{{2
Class MZ_Data_Save
{
  __new()
  {
    this.level := []
    this.lv0 := []
    this.lv1 := []
    this.lv2 := []
    this.lv3 := []
  }
  Set(lv,id,obj)
  {
    If lv = 1
      this.lv1[id] := obj
    If lv = 2
      this.lv2[id] := obj
    If lv = 3
      this.lv3[id] := obj
    this.level[id] := lv
  }
  SetType(id,text)
  {
    this.lv0[id] := text
  }
  GetType(id)
  {
    return this.lv0[id]
  }
  Get(id)
  {
    lv := this.level[id]
    If lv = 1
      return this.lv1[id]
    If lv = 2
      return this.lv2[id]
    If lv = 3
      return this.lv3[id]
  }
  GetLV(id)
  {
    return this.level[id]
  }
}
; class treeview {{{2
class treeview{
	static list:=[]
	__New(hwnd){
		this.list[hwnd]:=this
		OnMessage(0x4e,"TV_WM_NOTIFY")
		this.hwnd:=hwnd
	}
	TV_Color(info){
		Gui,TreeView,% this.hwnd
		if info.fore!=""
			this.control[info.hwnd,"fore"]:=info.fore
		if info.back!=""
			this.control[info.hwnd,"back"]:=info.back
		this.control[hwnd]
	}
}
; TV_WM_NOTIFY(Param*) {{{2
TV_WM_NOTIFY(Param*){
	control:=
	if (this:=treeview.list[NumGet(Param.2)])&&(NumGet(Param.2,2*A_PtrSize,"int")=-12){
		stage:=NumGet(Param.2,3*A_PtrSize,"uint")
		if (stage=1) ; dwDrawStage == CDDS_PREPAINT
		return 0x20 ;sets CDRF_NOTIFYITEMDRAW
		if (stage=0x10001&&info:=this.control[numget(Param.2,A_PtrSize=4?9*A_PtrSize:7*A_PtrSize,"uint")]){ ;NM_CUSTOMDRAW && Control is in the list
			if info.fore!=""
				NumPut(info.fore,Param.2,A_PtrSize=4?12*A_PtrSize:10*A_PtrSize,"int") 	;sets the foreground
			if info.back!=""
				NumPut(info.back,Param.2,A_PtrSize=4?13*A_PtrSize:10.5*A_PtrSize,"int") ;sets the background
		}
	}
	Else
		Toolbar_onNotify(Param.1,Param.2,Param.3,Param.4)
}
; Notify(wParam, lParam, msg, hwnd, obj) {{{2
Notify(wParam, lParam, msg, hwnd, obj)
{ 
  Global SCI
	If (obj.scnCode = SCN_UPDATEUI)
	{
		colorstring()
	}
}
; colorstring() {{{3
colorstring(){
	Global SCI
	sci.StartStyling(0,0x1f)
	sci.SetStyling(sci.GetLength()+1,STYLE_DEFAULT)
	sci.GetText(sci.GetLength()+1,String)

	P0 := 1
	Loop
	{
		P1 := RegExMatch(String,"\{[^\{\}]*\}",switch,P0)
		If P1
		{
			P0 := P1 + strlen(switch)
			len := GetStringLen(SubStr(String,1,P1))
			sci.StartStyling(len-1,0x1f)
			sci.SetStyling(GetStringLen(switch),SCE_AHKL_LABEL)

			P2 := RegExMatch(switch,":([^\{\}]*)(?=\})",opt)
			If P2
			{
				len_opt := GetStringLen(SubStr(switch,1,P2))
				sci.StartStyling(len+len_opt-1,0x1f)
				sci.SetStyling(GetStringLen(opt1),SCE_AHKL_VAR)
			}
		}
		Else
			Break
	}

	P0 := 1
	Loop
	{
		P1 := RegExMatch(String,"%[^%]*%",switch,P0)
		If P1 
		{
			P0 := P1 + strlen(switch)
			If ( ReplaceEnv(switch) <> switch)
			{
				sci.StartStyling(GetStringLen(SubStr(String,1,P1))-1,0x1f)
				sci.SetStyling(GetStringLen(switch),SCE_AHKL_BUILTINVAR)
			}
		}
		Else
			Break
	}
}
; GetStringLen(string) {{{3
GetStringLen(string)
{
	;[^\x00-\xff]
	count := 0
	Loop,Parse,String
		If RegExMatch(A_LoopField,"[^\x00-\xff]")
			Count += 2
		Else
			Count++
	return Count
}

; LoadCUR {{{2
LoadCUR:
Cross_CUR:="000002000100202002000F00100034010000160000002800000020000000400000000100010000000000800000000000000000000000020000000200000000000000FFFFFF000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF83FFFFFE6CFFFFFD837FFFFBEFBFFFF783DFFFF7EFDFFFEAC6AFFFEABAAFFFE0280FFFEABAAFFFEAC6AFFFF7EFDFFFF783DFFFFBEFBFFFFD837FFFFE6CFFFFFF83FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF28000000"

Cross_CUR_File:= A_Temp "\Cross.CUR"
BYTE_TO_FILE(StrToBin(Cross_CUR),Cross_CUR_File)

return

; SetPos {{{3
SetPosClass:
IfNotExist,%Cross_CUR_File%
	BYTE_TO_FILE(StrToBin(Cross_CUR),Cross_CUR_File)
;设置鼠标指针为十字标
CursorHandle := DllCall( "LoadCursorFromFile", Str,Cross_CUR_File )
DllCall( "SetSystemCursor", Uint,CursorHandle, Int,32512 )
gLable := "GetPosClass"
If !pToken := Gdip_Startup()
	return
Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
Gui, 1: Show, NA
hwnd1 := WinExist()
hbm := CreateDIBSection(A_ScreenWidth, A_ScreenHeight)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G, 4)
pPen := Gdip_CreatePen(0xFFFF0000,3)

SetTimer,%gLable%,200
KeyWait,LButton
SetTimer,%gLable%,off

Gdip_DeletePen(pPen)
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
Gdip_Shutdown(pToken)
GUI,1:Destroy


;还原鼠标指针
DllCall( "SystemParametersInfo", UInt,0x57, UInt,0, UInt,0, UInt,0 )
return

; GetPos {{{3
GetPosClass:
	MouseGetPos,,,id
	WinGetPos,x,y,w,h,ahk_id %id%
	x < 0 ? x := 0 
	y < 0 ? y := 0
	w < 0 ? w := 3
	h < 0 ? h := 3
	Gdip_GraphicsClear(G)
	Gdip_DrawRectangle(G,pPen,x+1,y+1,w-2,h-2)
	UpdateLayeredWindow(hwnd1, hdc, 0, 0, A_ScreenWidth, A_ScreenHeight)
	WinGetClass,c,ahk_id %id%
  WinGetTitle,t,ahk_id %id%
  Gui, Filter_Class: Default
  GuiControl,,Edit1,%c%
  GuiControl,,Edit2,%t%
return


;字符串转二进制
StrToBin(Str) {
XMLDOM:=ComObjCreate("Microsoft.XMLDOM")
xmlver:="<?xml version=`"`"1.0`"`"?>"
XMLDOM.loadXML(xmlver)
Pic:=XMLDOM.createElement("pic")
Pic.dataType:="bin.hex"
pic.nodeTypedValue := Str
StrToByte := pic.nodeTypedValue
return StrToByte
}


; 数据流保存为文件
BYTE_TO_FILE(body, filePath){
  Stream := ComObjCreate("Adodb.Stream")
  Stream.Type := 1
  Stream.Open()
  Stream.Write(body)
  Stream.SaveToFile(filePath,2) ;文件存在的就覆盖
  Stream.Close()
}

Exit:
Gdip_shutdown(pToken)
ExitApp
return
