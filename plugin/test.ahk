/*
[plugin]
test1=测试1
test2=测试2
*/
; 每个Plugin必须要的以上一段，负责解释{do:func} 对应的func内容
; 所有的Func都必须是函数
test1:
msgbox t1
MZ_Return := "cmd.exe"
return
test2()
{
  return "test2"
}
