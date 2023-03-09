import std/[osproc, os, strutils, strformat, httpclient], json

let (user, code) = execCmdEx "cmd /c echo %USERNAME%"
#let path = os.getenv("PATH")
let winalias_path = fmt"C:\Users\{user.strip()}\AppData\Roaming\winalias\"

discard os.existsOrCreateDir(winalias_path)
discard os.existsOrCreateDir(winalias_path & "\\winalias")


echo "Please add winalias to your path manually."
echo "This can be done by running the following: rundll32.exe sysdm.cpl,EditEnvironmentVariables"
echo fmt"Click edit when you have Path selected and add {winalias_path}"
echo "Press OK and you may need to restart your terminal"


#write "echo Hello World" to C:\Example\hello.bat
let winalias_bat = fmt"{winalias_path}\\winalias.bat"
let winalias_bat_content = "@echo off\n\"" & winalias_path & "\\winalias\\winalias.exe\" %*"

let batfile = open(winalias_bat, fmWrite)

for line in winalias_bat_content.splitLines():
    batfile.writeLine(line)
batfile.close()

# fetch https://api.github.com/repos/anotherpillow/winalias/releases/latest

let client = newHttpClient()
try:
    let response = client.getContent("https://api.github.com/repos/anotherpillow/winalias/releases/latest") 
    let responseJson = parseJson(response)
    echo responseJson
    let url = responseJson["assets"][0]["browser_download_url"].getStr()
    # download
    let winalias_exe = fmt"{winalias_path}\\winalias\\winalias.exe"
    client.downloadFile(url, winalias_exe)

except HttpRequestError:
    echo "Failed to fetch latest release" 
    quit(1)
    
