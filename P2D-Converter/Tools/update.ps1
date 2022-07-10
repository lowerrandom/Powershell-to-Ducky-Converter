Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'
[Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)

#-------------------------------------------------------------------------------------------------------

$myVer = 1.0

$myFile = ($MyInvocation.MyCommand.Path)

#$myFile = "C:\Users\micha\Desktop\app\Tools\update.ps1"

$red   = '#ff0000'
$white = '#ffffff'
$blue  = '#1a80b6'
$black = '#000000'

#-------------------------------------------------------------------------------------------------------

function Root {
$parentPath = Split-Path -parent $myFile
$root = Split-Path -parent $parentPath
$base = Split-Path -parent $root
return $root, $base
}

$Root, $Base = Root

. $Root\Tools\functions.ps1

#-------------------------------------------------------------------------------------------------------

Add-Type -AssemblyName System.Windows.Forms, System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$UpdForm                              = New-Object system.Windows.Forms.Form
$UpdForm.StartPosition                = "CenterScreen"
$UpdForm.Size                         = New-Object System.Drawing.Point(415,838)
$UpdForm.text                         = $Root
$UpdForm.TopMost                      = $false
$UpdForm.MaximumSize                  = $UpdForm.Size
$UpdForm.MinimumSize                  = $UpdForm.Size
$BGImage                              = [system.drawing.image]::FromFile("$Root\Assets\p2d-Updategui.png")
$UpdForm.BackgroundImage                 = $BGImage
$UpdForm.BackgroundImageLayout           = "None"

$yes                                  = Button -sx 207 -sy 30 -lx 100 -ly 450 -bc $blue -fc  $white -text Yes
$no                                   = Button -sx 207 -sy 30 -lx 100 -ly 500 -bc $red  -fc  $white -text No
$UpdForm.controls.AddRange(@($yes, $no))

#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
#	yes button click event

$yes.Add_Click({

    $ZipFile = "$Env:USERPROFILE\Desktop\Powershell-to-Ducky-Converter.zip"
    New-Item $ZipFile -ItemType File -Force
    $RepositoryZipUrl = "https://api.github.com/repos/I-Am-Jakoby/Powershell-to-Ducky-Converter/zipball/main" 
    Invoke-RestMethod -Uri $RepositoryZipUrl -OutFile $ZipFile
    Expand-Archive -Path $ZipFile -DestinationPath $Env:USERPROFILE\Desktop\p2d-temp -Force
    $NF = Get-ChildItem -Path $Env:USERPROFILE\Desktop\p2d-temp -Name
    $FF = Get-ChildItem -Directory $Env:USERPROFILE\Desktop\p2d-temp\$NF -Name
    echo "Copy-Item $Env:USERPROFILE\Desktop\p2d-temp\$NF\$FF $Base -Force -Recurse; powershell -w h -NoP -NonI -Exec Bypass $Root\Tools\main.ps1; Rm -Path $Env:USERPROFILE\Desktop\p2d-temp, $ZipFile, $Env:USERPROFILE\Desktop\erase.ps1 -Recurse -Force" > $Env:USERPROFILE\Desktop\erase.ps1
    powershell -w h -NoP -NonI -Exec Bypass $Env:USERPROFILE\Desktop\erase.ps1


$UpdForm.Close()
})
#-------------------------------------------------------------------------------------------------------
#	no button click event

$no.Add_Click({
$UpdForm.Visible = $false; powershell -w h -NoP -NonI -Exec Bypass $Root\Tools\main.ps1
})
#-------------------------------------------------------------------------------------------------------


[void]$UpdForm.ShowDialog()