Structure yaos
  base$
  date$
  format$
  root$
  temp$
  user$
  files.l
  directories.l
  links.l
  align.l
  size.l
EndStructure
XIncludeFile "iso.pb"
XIncludeFile "directory.pb"
XIncludeFile "disk.pb"
XIncludeFile "ext2.pb"
XIncludeFile "ext3.pb"
XIncludeFile "ext4.pb"
If OpenConsole()
  PrintN("== yaos-builder ==")
  If CountProgramParameters()
    cfg$ = ProgramParameter()
  Else
    PrintN("no config-file defined!")
    ;Delay(5000)
    End
  EndIf
  ;cfg$ = GetCurrentDirectory() + "/test.cfg"
  If OpenPreferences(cfg$)
    PrintN("#a=_sivizius")
    PrintN("#c=2015-05-05_01:54:10_UTC+2")
    PrintN("#d=" + FormatDate("%yyyy-%mm-%dd_%hh:%ii:%ss_UTC+2", #PB_Compiler_Date))
    PrintN("#t=yaos-builder")
    PrintN("#v=0.9.1.0")
    PrintN("read config-file...")
    *main.yaos = AllocateMemory(SizeOf(yaos))
    *main\base$ = Trim(ReadPreferenceString("base", GetCurrentDirectory()), "'")
    *main\date$ = Trim(ReadPreferenceString("date", FormatDate("%yyyy-%mm-%dd_%hh:%ii:%ss_UTC+2", Date())), "'")
    *main\format$ = Trim(ReadPreferenceString("format", ""), "'")
    *main\root$ = Trim(ReadPreferenceString("root", *main\base$ + "root"), "'")
    *main\user$ = Trim(ReadPreferenceString("user", UserName()), "'")
    If Mid(*main\root$, 1, 2) = "./"
      *main\root$ = *main\base$ + Mid(*main\root$, 3)
    EndIf
    *main\temp$ = Trim(ReadPreferenceString("temp", *main\base$ + "temp"), "'")
    If Mid(*main\temp$, 1, 2) = "./"
      *main\temp$ = *main\base$ + Mid(*main\temp$, 3)
    EndIf
    directory$ = *main\temp$
    While CreateDirectory(*main\temp$) = 0
      k = k + 1
      *main\temp$ = directory$ + Str(k)
    Wend
    k = 0
    directory$ = *main\root$
    While CreateDirectory(*main\root$) = 0
      k = k + 1
      *main\root$ = directory$ + Str(k)
    Wend
    Select LCase(*main\format$)
      Case "dir", "directory"
        directory(*main)
        PrintN("align = " + Str(*main\align))
        PrintN("size = " + Str(*main\size))
        PrintN("files = " + Str(*main\files))
        PrintN("directories = " + Str(*main\directories))
        PrintN("links = " + Str(*main\links))
      Case "cd", "eltorito", "iso"
        directory(*main)
      Case "disk", "fat", "fat12"
        text$ = Trim(ReadPreferenceString("size", "0"), "'")
        Select Asc(LCase(Mid(text$, Len(text$))))
          Case 'g'
            size = Val(Mid(text$, 1, Len(text$) - 1)) * 1024 * 1024 * 1024
          Case 'm'
            size = Val(Mid(text$, 1, Len(text$) - 1)) * 1024 * 1024
          Case 'k'
            size = Val(Mid(text$, 1, Len(text$) - 1)) * 1024
          Case 'b'
            size = Val(Mid(text$, 1, Len(text$) - 1))
          Case '0' To '9'
            size = Val(text$)
          Default
            PrintN("unknown size-multiplier »" + LCase(Mid(text$, Len(text$))) + "«!")
        EndSelect
        *main\align = 512
        *main\size = 0
        *main\files = 0
        *main\directories = 0
        directory(*main)
        If size
          *main\size = size
        EndIf
        disk(*main)
      Case "ext2"
        directory(*main)
      Case "ext3"
        directory(*main)
      Case "ext4"
        directory(*main)
      Case "sba"
        ;...
      Case ""
        PrintN("no format specified!")
      Default
        PrintN("unknown format »" + format$ + "«!")
    EndSelect
    ClosePreferences()
  Else
    PrintN("cannot open config-file!")
  EndIf
  ;Delay(5000)
  CloseConsole()
Else
  MessageRequester("Console", "this program need a console!")
EndIf
; IDE Options = PureBasic 5.20 LTS (Linux - x64)
; ExecutableFormat = Console
; CursorPosition = 67
; FirstLine = 34
; EnableAsm
; EnableUnicode
; EnableThread
; EnableXP
; Executable = /home/sivizius/sba/bin/builder