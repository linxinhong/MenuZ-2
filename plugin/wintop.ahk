/*
[plugin]
AlwaysOnTop=设置/取消顶置窗口
*/
AlwaysOnTop()
{
  Global MD_Hwnd
  WinSet, AlwaysOnTop, Toggle, ahk_id %MD_Hwnd%
}
