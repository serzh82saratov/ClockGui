#SingleInstance Force
#NoEnv
ListLines Off
SetBatchLines -1
OnMessage(0x404, "AHK_NOTIFYICON")
OnExit Exit
PlayFile = D:\Music\Ringtones\Aydio_-_02_-_Deltitnu.mp3
TimeStart = 00:00:00
VolumeStart = 6
StartHide := 0  ;	600  ;	0 - нескрывать после старта таймера, или кол-во мс через которое скрывать

Menu, Tray, UseErrorLevel
Menu, Tray, Icon, Shell32.dll, 266
Menu, Tray, Click, 1
Menu, Tray, NoStandard
Menu, Tray, Add, Min/Max, MinMax
Menu, Tray, Default, Min/Max 
Menu, Tray, Add, Close, ExitApp

Gui, +HWNDhMain +AlwaysOnTop +Owner -MinimizeBox -MaximizeBox
Gui, Color, F9D886
Gui, Margin, 10, 10
Gui, Font, s14
Timer := New ClockGui(hMain, "Sec|Timer|w 500|h 120|ds 1|db 20|bckgmain 444444|bckgitem 212121|coloritem FFFFFF|Font s90|Colon Flash")
Timer.SetTime(TimeStart)  
Timer.Show()
Timer.NumInput(1)
Gui, Add, Text, xp y+10 wp vInfo Center r2
Gui, Add, Button, xp y+10 gTimerStart, Запустить
Gui, Add, Button, x+39 yp gTimerPause, Пауза
Gui, Add, Button, x+39 yp gTimerRetry, Вернуть
Gui, Add, Button, x+39 yp gTimerReset, Сбросить
Gui, Add, Checkbox, x10 y+20 vPlaySound gCheckbox Checked1, Проигрывать мелодию
Gui, Add, Slider, x+10 yp-10 w203 vVolumeSlider hwndhVolumeSlider gSlider Center AltSubmit, % VolumeStart
Gui, Add, Text, x+10 yp+8 vTextVolume w40 Center, % VolumeStart
Gui, Show, , Таймер
GuiControlGet, VolumeSlider
GuiControlGet, PlaySound
Return
	
	
#If Playing
Space::
	Gosub, MinMax
	GoSub, TimerReset
	Return
#If

EndTimer(This) {
	Global
	This.Stop(1), This.Block(0) 
	GuiColor("E5684A")
	Playing := 1
	SetTimer, Playing, -1
	Gui, Show
	This.SetTime("00:00:00")
	This.StartWatch("", 1)
	TrayTip  ;	, % "Сработал таймер`n, прошло: " Duration, % " ", , 1
	GuiControl, , Info, % "сработал таймер`nпродолжительность: " TimeAddStr(Duration, 2)
	SetTimer, MinMax, Off
}

Playing:
	GuiControl, Disable, PlaySound
	If !PlaySound
		Return
	SoundGet, PrVolume
	SoundSet, %VolumeSlider%
	SoundPlay, %PlayFile%
	Return

SoundStop:
	SoundPlay, ::
	SoundSet, %PrVolume%
	Return

TimerStart:
	If Playing
		GoTo, Stop
	If !Timer.StartTimer("EndTimer")
		Return
	GuiColor("55C335")
	TrayTip, % "Запущен таймер`n, продолжительность: " , % (TimeAddStr(Duration := Timer.Get(), 2)), , 1
	GuiControl, , Info, % "запущен в: " A_Hour ":" A_Min ":" A_Sec "    сработает в: " Timer.MathTime("", "+", Timer.Get()) "`nпродолжительность: " TimeAddStr(Duration, 2) 
	If StartHide
		SetTimer, MinMax, -%StartHide%
	Return
	
TimerRetry:
	If (Playing)
		GoTo Stop
	If !Timer.Stop()
		Return
	Timer.SetTime(Duration)
	Return

TimerReset:
	If (Playing)
		GoTo Stop
	If !Timer.Stop()
		Return
	Timer.SetTime(TimeStart)
	Return
	
TimerPause:
	If (Playing)
		GoTo Stop
	GuiColor("F9D886")
	Timer.Stop(1)
	Timer.Block(0)
	Return
	
Stop:
	If (PlaySound)
		GoSub, SoundStop 
	Timer.Reset()
	GuiColor("F9D886")
	Timer.Reset(), Timer.Block(0)
	GuiControl, Enable, PlaySound
	SetTimer, MinMax, Off
	GuiControl, , Info
	Playing := 0
	Return 

GuiEscape:
GuiClose:
	Gosub, MinMax
	If Playing
		GoSub, Stop
	Return

ExitApp:
	ExitApp
	
Exit:
	If Timer.Stop()
		ExitApp
	MsgBox, 4388, Таймер, Включен активный таймер.`nТочно закрыть приложение?
	IfMsgBox Yes
		ExitApp
	Return

MinMax:
	Gui, Show, % !DllCall("IsWindowVisible", "Ptr", hMain) ? "" : "Hide"
	Return

Slider:
	GuiControlGet, VolumeSlider
	GuiControl, , TextVolume, % VolumeSlider
	If (Playing && PlaySound)
		SoundSet, %VolumeSlider%
	Return

Checkbox:
	GuiControlGet, PlaySound
	Return

AHK_NOTIFYICON(wParam,lParam,Msg,hwnd) {
	Global
	If (lParam = 0x200) ; move
		Menu, Tray, Tip, % "Таймер" (Playing || Timer.Stop() ? "" : "`nОсталось: " Timer.Get() " из " Duration)
}

GuiColor(Color) {
	Static prColor
	If (prColor = Color)
		Return
	Gui, Color, % (prColor := Color)
	GuiControl, Disable, VolumeSlider
	GuiControl, Enable, VolumeSlider
}

TimeAddStr(Time, Trim=0, d=" ") { 
	Local k, v, r1, r2, r3
	Static m := [["час","часа","часов"],["минута","минуты","минут"],["секунда","секунды","секунд"]]
	, s := {1:1,2:2,3:2,4:2,5:3,6:3,7:3,8:3,9:3,0:3}
	For k, v in StrSplit(Time, ":") {
		(!v) && (Trim >= k || (k = 3 && r1 || r2)) 
		|| (v > 10 && v < 20) && (1, r%k% := v + 0 " " m[k][3] d)
		|| (r%k% := v + 0 " " m[k][s[SubStr(v, 0)]] d)
	} Return RTrim(r1 r2 r3, d)
}
