#SingleInstance,Force
#NoTrayIcon
INIRead,mzhwnd,%A_Temp%\mzc,auto,hwnd,%A_Space%
v := %0%
If RegExMatch(v,"i)\-r")
  string := "reload"
If RegExMatch(v,"i)\-c")
  string := "conf"
If RegExMatch(v,"i)\-i")
  string := "init"
If not v
  string := "init"
Send_WM_COPYDATA(string,mzhwnd)


Send_WM_COPYDATA(ByRef StringToSend, hwnd)
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize) 
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    ;SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%  
    SendMessage, 0x4a, 0, &CopyDataStruct,, ahk_id %hwnd%
    DetectHiddenWindows %Prev_DetectHiddenWindows%  
    SetTitleMatchMode %Prev_TitleMatchMode% 
    return ErrorLevel  
}

