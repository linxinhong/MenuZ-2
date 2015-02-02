/*
[plugin]
MZ_QRCode=将当前文本生成二维码
*/

MZ_QRCode()
{
global wclip
GUI,pic:Destroy
GUI,pic:Add,Pic,x20 y20 w500 h-1 hwndhimage,% f:=GEN_QR_CODE(Substr(wclip.iGetText(),1,850))
GUI,pic:Add,Text,x20 y542 h24,按Esc取消
GUI,pic:Add,Button,x420 y540 w100 h24 gMZ_QRCode_SaveAs,另存为(&S)
GUI,pic:Show,w540 h580
}

PICGUIEscape:
  GUI,pic:Destroy
return

MZ_QRCode_SaveAs:
  Fileselectfile,nf,s16,,另存为,PNG图片(*.png)
  If not strlen(nf)
    return
  nf := RegExMatch(nf,"i)\.png") ? nf : nf ".png"
  Filecopy,%f%,%nf%,1
return

GEN_QR_CODE(string,file="")
{
  sFile := strlen(file) ? file : A_Temp "\" A_NowUTC ".png"
  DllCall( A_ScriptDir "\apps\qrcode\quricol32.dll\GeneratePNG","str", sFile , "str", string, "int", 4, "int", 2, "int", 0)
  Return sFile
}
