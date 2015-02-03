/*
[plugin]
FT_AddDate=[FileTool] 追加日期到文件名后
FT_AddVer=[FileTool] 追加版本号到文件名后
*/
FT_AddDate()
{
  Save:=GetSaveSelect()
  If save["Type"] <> 1 ; 如果当前选择的内容不是文件，则返回
    return
  f := save["file"]
  Splitpath,f,,dir,ext,namenoext
  FileMove,%f%,%dir%\%namenoext%-%A_YYYY%%A_MM%%A_DD%.%ext%
}
FT_AddVer()
{
  Save:=GetSaveSelect()
  If save["Type"] <> 1 ; 如果当前选择的内容不是文件，则返回
    return
  f := save["file"]
  Splitpath,f,,dir,ext,namenoext
  If RegExMatch(namenoext,"i)ve?r?s?i?o?n?\s*-*([\d\.]*)$",m)
  {
    LastIdx := SubStr(m1,0)
    nLastIdx := LastIdx+1
    nNameNoExt := RegExReplace(namenoext,ToMatch(m1)"$",SubStr(m1,1,strlen(m1)-1) nLastIdx)
    FileMove,%f%,%dir%\%nNamenoext%.%ext%
  }
  Else
    FileMove,%f%,%dir%\%Namenoext%-Ver-1.0.%ext%
}
