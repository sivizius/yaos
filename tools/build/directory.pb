Macro echo()
  text$ = ReplaceString(text$, "$base$", *main\base$)
  text$ = ReplaceString(text$, "$date$", *main\date$)
  text$ = ReplaceString(text$, "$dir$", directory$)
  text$ = ReplaceString(text$, "$file$", file$)
  text$ = ReplaceString(text$, "$format$", *main\format$)
  text$ = ReplaceString(text$, "$path$", path$)
  text$ = ReplaceString(text$, "$root$", *main\root$)
  text$ = ReplaceString(text$, "$temp$", *main\temp$)
  text$ = ReplaceString(text$, "$user$", *main\user$)
  text$ = ReplaceString(text$, "$val$", value$)
  text$ = ReplaceString(text$, "\$", "$")
  text$ = ReplaceString(text$, "\a", #BEL$)
  text$ = ReplaceString(text$, "\b", #BS$)
  text$ = ReplaceString(text$, "\f", #FF$)
  text$ = ReplaceString(text$, "\n", #LF$)
  text$ = ReplaceString(text$, "\r", #CR$)
  text$ = ReplaceString(text$, "\s", " ")
  text$ = ReplaceString(text$, "\t", #TAB$)
  text$ = ReplaceString(text$, "\v", #VT$)
  text$ = ReplaceString(text$, "\\", "\")
EndMacro
Procedure directory(*main.yaos)
  SetCurrentDirectory(*main\root$)
  If ExaminePreferenceGroups()
    While NextPreferenceGroup()
      path$ = PreferenceGroupName()
      file$ = ""
      If Asc(path$) <> '/'
        file$ = path$
        path$ = directory$ + path$
      EndIf
      directory$ = "/"
      For k = 2 To CountString(path$, "/")
        text$ = StringField(path$, k, "/")
        If LCase(text$) = "$user$"
          directory$ = directory$ + *main\user$  
        Else
          directory$ = directory$ + text$
        EndIf
        If SetCurrentDirectory(*main\root$ + directory$) = 0
          PrintN("[dir]  " + *main\root$ + directory$)
          *main\directories = *main\directories + 1
          If CreateDirectory(*main\root$ + directory$) = 0
            PrintN(">>>" + *main\root$ + directory$)
          EndIf
        EndIf
        directory$ = directory$ + "/"
      Next
      If file$ = ""
        file$ = StringField(path$, k - 1, "/")
        If LCase(file$) = "$user$"
          file$ = *main\user$
        EndIf
        If ExaminePreferenceKeys()
          While NextPreferenceKey()
            key$ = PreferenceKeyName()
            Select LCase(key$)
              Case "create"
              Case "echo"
                text$ = Trim(PreferenceKeyValue(), "'")
                echo()
                PrintN("[echo] " + text$)
              Case "yay" ;yet another »yet another ›...‹«
                value$ = Trim(PreferenceKeyValue(), "'")
                If CreateDirectory(*main\root$ + path$ + "code") = 0 Or
                   CreateDirectory(*main\root$ + path$ + "data") = 0 Or
                   CreateDirectory(*main\root$ + path$ + "misc") = 0 Or
                   CreateDirectory(*main\root$ + path$ + "resv") = 0 Or
                   CreateDirectory(*main\root$ + path$ + "stat") = 0 Or
                   CreateDirectory(*main\root$ + path$ + "text") = 0
                  PrintN(">>>" + *main\root$ + path$)
                Else
                  Select value$
                    Case "fasm"
                      PrintN("[fine] > create project »" + file$ + "« in flatassembler.")
                      text$ = ";#!editor:fasm"      + #LF$ +
                              ";a=" + *main\user$   + #LF$ +
                              ";b=ascii\n"          + #LF$ +
                              ";c="  + *main\date$  + #LF$ +
                              ";d="  + *main\date$  + #LF$ +
                              ";v=0.9.1.0"          + #LF$
                      fd = CreateFile(#PB_Any, *main\root$ + directory$ + "code/main.fasm")
                      If IsFile(fd)
                        PrintN("[file] " + *main\root$ + directory$ + "code/main.fasm")
                        WriteString(fd, text$, #PB_UTF8)
                        CloseFile(fd)
                      EndIf
                      fd = CreateFile(#PB_Any, *main\root$ + directory$ + "data/main.fdat")
                      If IsFile(fd)
                        PrintN("[file] " + *main\root$ + directory$ + "data/main.fdat")
                        WriteString(fd, text$, #PB_UTF8)
                        CloseFile(fd)
                      EndIf
                      fd = CreateFile(#PB_Any, *main\root$ + directory$ + "resv/main.fres")
                      If IsFile(fd)
                        PrintN("[file] " + *main\root$ + directory$ + "resv/main.fres")
                        WriteString(fd, text$, #PB_UTF8)
                        CloseFile(fd)
                      EndIf
                      fd = CreateFile(#PB_Any, *main\root$ + directory$ + "stat/main.finc")
                      If IsFile(fd)
                        PrintN("[file] " + *main\root$ + directory$ + "stat/main.finc")
                        WriteString(fd, text$, #PB_UTF8)
                        CloseFile(fd)
                      EndIf
                      fd = CreateFile(#PB_Any, *main\root$ + directory$ + "text/main.ftxt")
                      If IsFile(fd)
                        PrintN("[file] " + *main\root$ + directory$ + "text/main.ftxt")
                        WriteString(fd, text$, #PB_UTF8)
                        CloseFile(fd)
                      EndIf
                      fd = CreateFile(#PB_Any, *main\root$ + directory$ + file$ + ".fasm")
                      If IsFile(fd)
                        PrintN("[file] " + *main\root$ + directory$ + file$ + ".fasm")
                        WriteString(fd, text$, #PB_UTF8)
                        CloseFile(fd)
                      EndIf
                      *main\files = *main\files + 6
                      *main\directories = *main\directories + 6
                  EndSelect
                EndIf
              Default
                PrintN("[fail] unknown key »" + key$ + "« with value »" + PreferenceKeyValue() + "«!")
            EndSelect
          Wend
        Else
          PrintN("  cannot examaine keys!")
        EndIf  
      Else
        If LCase(file$) = "$user$"
          file$ = *main\user$
        EndIf
        ;PrintN(file$)
        link$ = ""
        ;file = CreateFile(#PB_Any, root$ + PreferenceGroupName())
        If ExaminePreferenceKeys()
          While NextPreferenceKey()
            key$ = PreferenceKeyName()
            Select LCase(key$)
              Case "build"
                value$ = Trim(PreferenceKeyValue(), "'")
                proc = RunProgram(StringField(value$, 1, " "), Mid(value$, Len(StringField(value$, 1, " ")) + 1), *main\temp$, #PB_Program_Wait)
                If proc = 0
                  link$ = link$ + "[fail] > cannot build »" + StringField(value$, 1, " ") + "(" + Mid(value$, Len(StringField(value$, 1, " ")) + 1) + ")«!" + #LF$
                EndIf
              Case "create"
                value$ = Trim(PreferenceKeyValue(), "'")
                fd = CreateFile(#PB_Any, *main\root$ + path$)
                If IsFile(fd)
                  CloseFile(fd)
                  RunProgram("chmod", value$ + " " + *main\root$ + path$, *main\temp$, #PB_Program_Wait)
                Else
                  link$ = link$ + "[fail] > cannot create file »" + file$ + "«!" + #LF$
                EndIf
                PrintN("[file] " + *main\root$ + path$)
              Case "echo"
                text$ = Trim(PreferenceKeyValue(), "'")
                echo()
                link$ = link$ + "[echo] " + text$ + #LF$
              Case "include"
                value$ = Trim(PreferenceKeyValue(), "'")
                If Mid(value$, 1, 2) = "./"
                  value$ = *main\base$ + Mid(value$, 3)
                EndIf
                If CopyFile(value$, *main\root$ + path$) = 0
                  link$ = link$ + "[fail] > cannot copy file »" + value$ + "«!" + #LF$
                Else
                  link$ = link$ + "[fine] > include file »" + value$ + "«." + #LF$
                EndIf
                PrintN("[file] " + *main\root$ + path$)
              Case "link"
                value$ = Trim(PreferenceKeyValue(), "'")
                If Asc(value$) = '/'
                  value$ = *main\root$ + value$
                Else
                  value$ = *main\root$ + directory$ + value$
                EndIf
                proc = RunProgram("ln", "-s " + value$ + " " + *main\root$ + path$, *main\temp$, #PB_Program_Wait)
                If proc = 0
                  link$ = link$ + #LF$ + "[fail] > cannot link to file »" + value$ + "«!"
                EndIf
                *main\links = *main\links + 1
                *main\files = *main\files - 1
                PrintN("[link] " + *main\root$ + path$ + " -> " + value$)
              Default
                PrintN("unknown key »" + key$ + "« with value »" + PreferenceKeyValue() + "«!")
            EndSelect
          Wend
          *main\files = *main\files + 1
        Else
          PrintN("cannot examaine keys!")
        EndIf
        Print(link$)
      EndIf
    Wend
    ProcedureReturn #True
  Else
    PrintN("cannot examaine directories!")
  EndIf
EndProcedure
; IDE Options = PureBasic 5.20 LTS (Linux - x64)
; CursorPosition = 76
; FirstLine = 53
; Folding = -
; EnableUnicode
; EnableXP