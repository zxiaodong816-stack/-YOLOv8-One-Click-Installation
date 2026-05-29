Option Explicit

Dim selectedDir
selectedDir = ShowFolderDialog()

If Not IsEmpty(selectedDir) Then
    WriteSelectedDirToFile selectedDir
End If

Function ShowFolderDialog()
    Dim objShell, objFolder, objFolderItem, path, wshShell
    Set wshShell = CreateObject("WScript.Shell")

    Set objShell = CreateObject("Shell.Application")
    Set objFolder = objShell.BrowseForFolder(0, _
    wshShell.ExpandEnvironmentStrings("请选择%pname%及miniconda3(可能)的安装位置") _
    & vbcrlf & "注意:安装路径中请勿包含空格或中文", 1, 0)
    Set wshShell = Nothing

    If Not objFolder Is Nothing Then
        Set objFolderItem = objFolder.Items.Item
        ShowFolderDialog = objFolderItem.Path
    Else
        ShowFolderDialog = Empty ' User canceled the selection
    End If
End Function

Sub WriteSelectedDirToFile(selectedDir)
    Dim objFSO, outFile
    Set objFSO = CreateObject("Scripting.FileSystemObject")

    Dim outFilePath
    outFilePath = "_utils\selected.txt"

    Set outFile = objFSO.CreateTextFile(outFilePath, True)
    outFile.WriteLine(selectedDir)
    outFile.Close

    Set objFSO = Nothing
End Sub
