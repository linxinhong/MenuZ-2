; Tools function {{{1
; ToMatch(str) {{{2
; 正则表达式转义
ToMatch(str){
    str := RegExReplace(str,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0")
    Return RegExReplace(str,"\s","\s")
}
; ToReplace(str) {{{2
;
ToReplace(str){
    If RegExMatch(str,"\$")
        return  Regexreplace(str,"\$","$$$$")
    Else
        Return str
}
; ReplaceEnv(string) {{{2
ReplaceEnv(string)
{
		Global conf 
		p1 := 1
    Loop 
    {
      p2 := RegExMatch(string,"%[^%]*%",m,p1)
      If Not p2 
      {
        If P1 > 1
          r .= over
        Else
          r := string
        Break
      }
      Else If Strlen(m)
      {
        env := SubStr(m,2,strlen(m)-2)
        If strlen(conf.user_env[env])
          Rstring := conf.user_env[env]
        Else If RegExMatch(env,"i)(^apps$)|(^Script$)|(^config$)|(^Plugins$)|(^icons$)",MZVar)
          RString := A_ScriptDir "\" MZVar
        Else If RegExMatch(env,"i)(^A_Tab$)|(^A_SPACE$)|(^A_WorkingDir$)|(^A_ScriptDir$)|(^A_ScriptName$)|(^A_ScriptFullPath$)|(^A_ScriptHwnd$)|(^A_LineNumber$)|(^A_LineFile$)|(^A_ThisFunc$)|(^A_ThisLabel$)|(^A_AhkVersion$)|(^A_AhkPath$)|(^A_IsUnicode$)|(^A_IsCompiled$)|(^A_ExitReason$)|(^A_YYYY$)|(^A_MM$)|(^A_DD$)|(^A_MMMM$)|(^A_MMM$)|(^A_DDDD$)|(^A_DDD$)|(^A_WDay$)|(^A_YDay$)|(^A_YWeek$)|(^A_Hour$)|(^A_Min$)|(^A_Sec$)|(^A_MSec$)|(^A_Now$)|(^A_NowUTC$)|(^A_TickCount$)|(^A_IsSuspended$)|(^A_IsPaused$)|(^A_IsCritical$)|(^A_BatchLines$)|(^A_TitleMatchMode$)|(^A_TitleMatchModeSpeed$)|(^A_DetectHiddenWindows$)|(^A_DetectHiddenText$)|(^A_AutoTrim$)|(^A_StringCaseSense$)|(^A_FileEncoding$)|(^A_FormatInteger$)|(^A_FormatFloat$)|(^A_KeyDelay$)|(^A_WinDelay$)|(^A_ControlDelay$)|(^A_MouseDelay$)|(^A_DefaultMouseSpeed$)|(^A_RegView$)|(^A_IconHidden$)|(^A_IconTip$)|(^A_IconFile$)|(^A_IconNumber$)|(^A_TimeIdle$)|(^A_TimeIdlePhysical$)|(^A_Gui$)|(^A_GuiControl$)|(^A_GuiWidth$)|(^A_GuiHeight$)|(^A_GuiX$)|(^A_GuiY$)|(^A_GuiEvent$)|(^A_EventInfo$)|(^A_ThisHotkey$)|(^A_PriorHotkey$)|(^A_PriorKey$)|(^A_TimeSinceThisHotkey$)|(^A_TimeSincePriorHotkey$)|(^A_Temp$)|(^A_OSType$)|(^A_OSVersion$)|(^A_Is64bitOS$)|(^A_PtrSize$)|(^A_Language$)|(^A_ComputerName$)|(^A_UserName$)|(^A_WinDir$)|(^A_ProgramFiles$)|(^A_AppData$)|(^A_AppDataCommon$)|(^A_Desktop$)|(^A_DesktopCommon$)|(^A_StartMenu$)|(^A_StartMenuCommon$)|(^A_Programs$)|(^A_ProgramsCommon$)|(^A_Startup$)|(^A_StartupCommon$)|(^A_MyDocuments$)|(^A_IsAdmin$)|(^A_ScreenWidth$)|(^A_ScreenHeight$)|(^A_IPAddress1$)|(^A_IPAddress2$)|(^A_IPAddress3$)|(^A_IPAddress4$)|(^A_Cursor$)|(^A_CaretX$)|(^A_CaretY$)",ahkVar)
          RString := %ahkVar%
        Else If RegExMatch(env,"i)(^ALLUSERSPROFILE$)|(^APPDATA$)|(^CommonProgramFiles$)|(^COMPUTERNAME$)|(^ComSpec$)|(^FP_NO_HOST_CHECK$)|(^HOMEDRIVE$)|(^HOMEPATH$)|(^LOCALAPPDATA$)|(^LOGONSERVER$)|(^NUMBER_OF_PROCESSORS$)|(^OS$)|(^Path$)|(^PROCESSOR_ARCHITECTURE$)|(^PROCESSOR_IDENTIFIER$)|(^PROCESSOR_LEVEL$)|(^PROCESSOR_REVISION$)|(^ProgramData$)|(^ProgramFiles$)|(^PROMPT$)|(^PSModulePath$)|(^SESSIONNAME$)|(^SystemDrive$)|(^SystemRoot$)|(^TEMP$)|(^TMP$)|(^USERDOMAIN$)|(^USERNAME$)|(^USERPROFILE$)|(^windir$)",sysVar)
        {
          EnvGet,getsysVar,%sysVar%
          RString := getsysVar
        }
        Else
          RString := m
      }
      inter := SubStr(string,p1,p2-p1)
      p1 := p2 + Strlen(m)
      over := SubStr(string,p1)
      r .= inter RString
    }
    Return r
}
; SetMenuIcon(Name,Item,Value,Default=0){{{2
; 返回对应的文件的图标
SetMenuIcon(Name,Item,Value,Default=0){
	Obj := []
    If RegExMatch(Value,"i)\{icon:[^\}]*\}",Icon)
    {
        Icon := SubStr(icon,7,strlen(icon)-7)
        Loop,Parse,Icon,|
        {

            If A_Index = 1
                IconFile := A_LoopField
            If A_Index = 2
                IconNumber := A_LoopField
            If A_Index = 3
                IconWidth := A_LoopField
        }
    }
    Else {
        Value := Trim(Value)  ;去掉多余的空格的制表符
        If FileExist(Value) {
            IconFile := Value
        }
        Else {
            Loop % Strlen(Value)
            {
                Exec := SubStr(Value,1,Strlen(Value)-A_Index)
                If InStr(FileExist(Exec),"D")
                    Break
                If FileExist(Exec) {
                    IconFile := Trim(Exec)
                    Break
                }
            }
        }
    }

    If Strlen(IconFile) > 0 {
        If Not RegExMatch(IconFile,"i)(\.ICO)|(\.CUR)|(\.ANI)|(\.EXE)|(\.DLL)|(\.CPL)|(\.SCR)$") {
            SplitPath, IconFile, , , Ext
            Ext := Strlen(Ext) ? "." Ext : "Folder"
            GetExtIcon(Ext,IconFile,IconNumber)
        }
        ;Menu,%Name%,Icon,%Item%,%IconFile%,%IconNumber%,%IconWidth%
    }

    If DefalutIcon
    {
        IconFile := A_ScriptDir "\ICONS\default.ico"
        ;Menu,%Name%,Icon,%Item%,%IconFile%
    }
	Obj["IconFile"] := IconFile
	Obj["IconNumber"] := IconNumber
	Obj["IconWidth"] := IconWidth
	Return Obj
}
; GetExtIcon(ext,ByRef IconFile,ByRef IconNumber) {{{2
GetExtIcon(ext,ByRef IconFile,ByRef IconNumber){

    If RegExMatch(ext,"i)^Folder$") {
        IconFile    := A_WinDir "\system32\shell32.dll"
        IconNumber  := 4
        Return
    }

    If RegExMatch(ext,"i)^Drive$") {
        IconFile    := A_WinDir "\system32\shell32.dll"
        IconNumber  := 9
        Return
    }

    If RegExMatch(ext,"i)^\.lnk$") {
        IconFile    := A_WinDir "\system32\shell32.dll"
        IconNumber  := 264
        Return
    }

    If RegExMatch(ext,"i)^\.mza$") {
        IconFile    := A_ScriptDir "\ICONS\MenuZ.icl"
        IconNumber  := 0
        Return
    }

    If RegExMatch(ext,"i)^NoExt$") {
        IconFile    := A_WinDir "\system32\shell32.dll"
        IconNumber  := 291
        Return
    }

    If RegExMatch(ext,"i)^[^\.]*$") {
        IconFile    := A_WinDir "\system32\shell32.dll"
        IconNumber  := 268
        Return
    }

    RegRead,file,HKEY_CLASSES_ROOT,%ext%
    If Strlen(file) = 0 {
        IconFile    := A_WinDir "\system32\shell32.dll"
        IconNumber  := 290
        Return
    }
    RegRead,IconString,HKEY_CLASSES_ROOT,%file%\DefaultIcon
    If ErrorLevel {
        IconFile := A_Windir "\system32\shell32.dll"
        IconNumber := 291
    }
    If RegExMatch(IconString,"%1") or Not IconString
    {
        RegRead,IconPath,HKCR,%file%\Shell\Open\Command
        ;IconPath := LTrim(ReplaceVar(IconPath),tm)
        IconPath := LTrim(IconPath,"""")
        If FileExist(IconPath)
            Loop_exec := IconPath
        Else
            Loop,% Strlen(IconPath)
            {
                Loop_exec := SubStr(IconPath,1,strlen(IconPath)-A_Index)
                If FileExist(Loop_exec)
                    Break
            }
        IconFile   := Loop_exec
        IconNumber := 0
    }
    Else
    {
        IconFile   := RegExReplace(IconString,",-?\d*","")
        IconNumber := RegExReplace(IconString,".*,","")
    }
}
; rgbcolor(red=0,green=0,blue=0) {{{2
rgbcolor(red=0,green=0,blue=0)
{
  color:= (red << 16) + (green << 8) + blue
  return color
}

; bgrcolor(red=0,green=0,blue=0) {{{2
bgrcolor(red=0,green=0,blue=0)
{
  color:= (blue << 16) + (green << 8) + red
  return color
}

; rgb_bgr_swap(color) {{{2
; this swaps the color rgb <-> bgr
rgb_bgr_swap(color)
{
  red:= ((Color & 0xff0000) >> 16)
  green:= ((Color & 0x00ff00) >> 8)
  blue:= (Color & 0xff)

  color2:= (blue << 16) + (green << 8) + red
  return color2
}
; zh2py(str) {{{2
; 从 php 转换而来的 (http://www.sjyhome.com/php/201311170606.html)
; http://ahkscript.org/boards/viewtopic.php?f=27&t=1629
; 作者: tmplinshi 
zh2py(str)
{
    ; 根据汉字区位表,(http://www.mytju.com/classcode/tools/QuWeiMa_FullList.asp)
    ; 我们可以看到从16-55区之间是按拼音字母排序的,所以我们只需要判断某个汉字的区位码就可以得知它的拼音首字母.

    ; 区位表第一部份,按拼音字母排序的.
    ; 16区-55区
    /*
        'A'=>0xB0A1, 'B'=>0xB0C5, 'C'=>0xB2C1, 'D'=>0xB4EE, 'E'=>0xB6EA, 'F'=>0xB7A2, 'G'=>0xB8C1,'H'=>0xB9FE,
        'J'=>0xBBF7, 'K'=>0xBFA6, 'L'=>0xC0AC, 'M'=>0xC2E8, 'N'=>0xC4C3, 'O'=>0xC5B6, 'P'=>0xC5BE,'Q'=>0xC6DA,
        'R'=>0xC8BB, 'S'=>0xC8F6, 'T'=>0xCBFA, 'W'=>0xCDDA, 'X'=>0xCEF4, 'Y'=>0xD1B9, 'Z'=>0xD4D1
    */
    static FirstTable  := [ 0xB0C5, 0xB2C1, 0xB4EE, 0xB6EA, 0xB7A2, 0xB8C1, 0xB9FE, 0xBBF7, 0xBFA6, 0xC0AC, 0xC2E8
                          , 0xC4C3, 0xC5B6, 0xC5BE, 0xC6DA, 0xC8BB, 0xC8F6, 0xCBFA, 0xCDDA, 0xCEF4, 0xD1B9, 0xD4D1, 0xD7FA ]
    static FirstLetter := StrSplit("ABCDEFGHJKLMNOPQRSTWXYZ")

    ; 区位表第二部份,不规则的,下面的字母是每个区里面对应字的拼音首字母.从网上查询整理出来的,可能会有部份错误.
    ; 56区-87区
    static SecondTable := [ StrSplit("CJWGNSPGCGNEGYPBTYYZDXYKYGTZJNMJQMBSGZSCYJSYYFPGKBZGYDYWJKGKLJSWKPJQHYJWRDZLSYMRYPYWWCCKZNKYYG")
                          , StrSplit("TTNGJEYKKZYTCJNMCYLQLYPYSFQRPZSLWBTGKJFYXJWZLTBNCXJJJJTXDTTSQZYCDXXHGCKBPHFFSSTYBGMXLPBYLLBHLX")
                          , StrSplit("SMZMYJHSOJNGHDZQYKLGJHSGQZHXQGKXZZWYSCSCJXYEYXADZPMDSSMZJZQJYZCJJFWQJBDZBXGZNZCPWHWXHQKMWFBPBY")
                          , StrSplit("DTJZZKXHYLYGXFPTYJYYZPSZLFCHMQSHGMXXSXJYQDCSBBQBEFSJYHWWGZKPYLQBGLDLCDTNMAYDDKSSNGYCSGXLYZAYPN")
                          , StrSplit("PTSDKDYLHGYMYLCXPYCJNDQJWXQXFYYFJLEJPZRXCCQWQQSBZKYMGPLBMJRQCFLNYMYQMSQYRBCJTHZTQFRXQHXMQJCJLY")
                          , StrSplit("QGJMSHZKBSWYEMYLTXFSYDXWLYCJQXSJNQBSCTYHBFTDCYZDJWYGHQFRXWCKQKXEBPTLPXJZSRMEBWHJLBJSLYYSMDXLCL")
                          , StrSplit("QKXLHXJRZJMFQHXHWYWSBHTRXXGLHQHFNMGYKLDYXZPYLGGSMTCFBAJJZYLJTYANJGBJPLQGSZYQYAXBKYSECJSZNSLYZH")
                          , StrSplit("ZXLZCGHPXZHZNYTDSBCJKDLZAYFFYDLEBBGQYZKXGLDNDNYSKJSHDLYXBCGHXYPKDJMMZNGMMCLGWZSZXZJFZNMLZZTHCS")
                          , StrSplit("YDBDLLSCDDNLKJYKJSYCJLKWHQASDKNHCSGAGHDAASHTCPLCPQYBSZMPJLPCJOQLCDHJJYSPRCHNWJNLHLYYQYYWZPTCZG")
                          , StrSplit("WWMZFFJQQQQYXACLBHKDJXDGMMYDJXZLLSYGXGKJRYWZWYCLZMSSJZLDBYDCFCXYHLXCHYZJQSQQAGMNYXPFRKSSBJLYXY")
                          , StrSplit("SYGLNSCMHCWWMNZJJLXXHCHSYZSTTXRYCYXBYHCSMXJSZNPWGPXXTAYBGAJCXLYXDCCWZOCWKCCSBNHCPDYZNFCYYTYCKX")
                          , StrSplit("KYBSQKKYTQQXFCMCHCYKELZQBSQYJQCCLMTHSYWHMKTLKJLYCXWHEQQHTQKZPQSQSCFYMMDMGBWHWLGSLLYSDLMLXPTHMJ")
                          , StrSplit("HWLJZYHZJXKTXJLHXRSWLWZJCBXMHZQXSDZPSGFCSGLSXYMJSHXPJXWMYQKSMYPLRTHBXFTPMHYXLCHLHLZYLXGSSSSTCL")
                          , StrSplit("SLDCLRPBHZHXYYFHBMGDMYCNQQWLQHJJCYWJZYEJJDHPBLQXTQKWHLCHQXAGTLXLJXMSLJHTZKZJECXJCJNMFBYCSFYWYB")
                          , StrSplit("JZGNYSDZSQYRSLJPCLPWXSDWEJBJCBCNAYTWGMPAPCLYQPCLZXSBNMSGGFNZJJBZSFZYNTXHPLQKZCZWALSBCZJXSYZGWK")
                          , StrSplit("YPSGXFZFCDKHJGXTLQFSGDSLQWZKXTMHSBGZMJZRGLYJBPMLMSXLZJQQHZYJCZYDJWFMJKLDDPMJEGXYHYLXHLQYQHKYCW")
                          , StrSplit("CJMYYXNATJHYCCXZPCQLBZWWYTWBQCMLPMYRJCCCXFPZNZZLJPLXXYZTZLGDLTCKLYRZZGQTTJHHHJLJAXFGFJZSLCFDQZ")
                          , StrSplit("LCLGJDJZSNZLLJPJQDCCLCJXMYZFTSXGCGSBRZXJQQCTZHGYQTJQQLZXJYLYLBCYAMCSTYLPDJBYREGKLZYZHLYSZQLZNW")
                          , StrSplit("CZCLLWJQJJJKDGJZOLBBZPPGLGHTGZXYGHZMYCNQSYCYHBHGXKAMTXYXNBSKYZZGJZLQJTFCJXDYGJQJJPMGWGJJJPKQSB")
                          , StrSplit("GBMMCJSSCLPQPDXCDYYKYPCJDDYYGYWRHJRTGZNYQLDKLJSZZGZQZJGDYKSHPZMTLCPWNJYFYZDJCNMWESCYGLBTZZGMSS")
                          , StrSplit("LLYXYSXXBSJSBBSGGHFJLYPMZJNLYYWDQSHZXTYYWHMCYHYWDBXBTLMSYYYFSXJCBDXXLHJHFSSXZQHFZMZCZTQCXZXRTT")
                          , StrSplit("DJHNRYZQQMTQDMMGNYDXMJGDXCDYZBFFALLZTDLTFXMXQZDNGWQDBDCZJDXBZGSQQDDJCMBKZFFXMKDMDSYYSZCMLJDSYN")
                          , StrSplit("SPRSKMKMPCKLGTBQTFZSWTFGGLYPLLJZHGJJGYPZLTCSMCNBTJBQFKDHBYZGKPBBYMTDSSXTBNPDKLEYCJNYCDYKZTDHQH")
                          , StrSplit("SYZSCTARLLTKZLGECLLKJLQJAQNBDKKGHPJTZQKSECSHALQFMMGJNLYJBBTMLYZXDXJPLDLPCQDHZYCBZSCZBZMSLJFLKR")
                          , StrSplit("ZJSNFRGJHXPDHYJYBZGDLQCSEZGXLBLGYXTWMABCHECMWYJYZLLJJYHLGNDJLSLYGKDZPZXJYYZLWCXSZFGWYYDLYHCLJS")
                          , StrSplit("CMBJHBLYZLYCBLYDPDQYSXQZBYTDKYXJYYCNRJMPDJGKLCLJBCTBJDDBBLBLCZQRPYXJCJLZCSHLTOLJNMDDDLNGKATHQH")
                          , StrSplit("JHYKHEZNMSHRPHQQJCHGMFPRXHJGDYCHGHLYRZQLCYQJNZSQTKQJYMSZSWLCFQQQXYFGGYPTQWLMCRNFKKFSYYLQBMQAMM")
                          , StrSplit("MYXCTPSHCPTXXZZSMPHPSHMCLMLDQFYQXSZYJDJJZZHQPDSZGLSTJBCKBXYQZJSGPSXQZQZRQTBDKYXZKHHGFLBCSMDLDG")
                          , StrSplit("DZDBLZYYCXNNCSYBZBFGLZZXSWMSCCMQNJQSBDQSJTXXMBLTXZCLZSHZCXRQJGJYLXZFJPHYMZQQYDFQJJLZZNZJCDGZYG")
                          , StrSplit("CTXMZYSCTLKPHTXHTLBJXJLXSCDQXCBBTJFQZFSLTJBTKQBXXJJLJCHCZDBZJDCZJDCPRNPQCJPFCZLCLZXZDMXMPHJSGZ")
                          , StrSplit("GSZZQLYLWTJPFSYASMCJBTZYYCWMYTZSJJLJCQLWZMALBXYFBPNLSFHTGJWEJJXXGLLJSTGSHJQLZFKCGNNNSZFDEQFHBS")
                          , StrSplit("AQTGYLBXMMYGSZLDYDQMJJRGBJTKGDHGKBLQKBDMBYLXWCXYTTYBKMRTJZXQJBHLMHMJJZMQASLDCYXYQDLQCAFYWYXQHZ") ]


    static nothing := VarSetCapacity(var, 2)
    
    ; 如果不包含中文字符，则直接返回原字符
	if not RegExMatch(str,"[^x00-xff]")
		return str
    ;if ( Asc(str) < 0x2E80 or Asc(str) > 0x9FFF )
    ;    Return str
    
    Loop, Parse, str
    {
        StrPut(A_LoopField, &var, "CP936")
        H := NumGet(var, 0, "UChar")
        L := NumGet(var, 1, "UChar")
        
        ; 字符集非法
        if (H < 0xB0 || L < 0xA1 || H > 0xF7 || L = 0xFF)
        {
            newStr .= A_LoopField
            Continue
        }
        
        if (H < 0xD8)//(H >= 0xB0 && H <=0xD7) ; 查询文字在一级汉字区(16-55)
        {
            W := (H << 8) | L
            For key, value in FirstTable
            {
                if (W < value)
                {
                    newStr .= FirstLetter[key]
                    Break
                }
            }
        }
        else ; if (H >= 0xD8 && H <= 0xF7) ; 查询中文在二级汉字区(56-87)
            newStr .= SecondTable[ H - 0xD8 + 1 ][ L - 0xA1 + 1 ]
    }
    
    Return newStr
}

; iRelativePath(i) {{{2
iRelativePath(file){
	;file := RegExReplace(file,"i)" ToMatch(A_ScriptDir "\Config"),"%CONFIG%")
	file := RegExReplace(file,"i)" ToMatch(A_ScriptDir "\Plugin"),"%PLUGIN%")
	;file := RegExReplace(file,"i)" ToMatch(A_ScriptDir "\Script"),"%SCRIPT%")
	file := RegExReplace(file,"i)" ToMatch(A_ScriptDir "\Icons"),"%ICONS%")
	file := RegExReplace(file,"i)" ToMatch(A_ScriptDir "\Apps"),"%APPS%")
	file := RegExReplace(file,"i)" ToMatch(A_ScriptDir),"%A_SCRIPTDIR%")
	file := RegExReplace(file,"i)" ToMatch(A_WinDir),"%A_WINDIR%")
	return file
}


