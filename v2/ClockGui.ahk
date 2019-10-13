Class ClockGui {
	;  автор - serzh82saratov
	;  версия - 2.11
	;  01:11 14.10.2019
	;  описание - http://forum.script-coding.com/viewtopic.php?id=12931
	;  исходник - https://raw.githubusercontent.com/serzh82saratov/ClockGui/master/v2/ClockGui.ahk

	Static OnStepDelay := 300, WM_LBUTTONDOWN := 0x201, WM_LBUTTONDBLCLK := 0x203, WM_RBUTTONDOWN := 0x204
	, WM_RBUTTONDBLCLK := 0x206, WM_MOUSEWHEEL := 0x020A, WM_MBUTTONDOWN := 0x0207, Mem := {}

	__New(hParent, Option) {
		Local Class 
		Class := This.__Class, Class := %Class%, This.ThisClass := Class 
		This.Initialize()
		This.Change(hParent, Option, 0)
	}
	Change(hParent, Option, IsChange = 1) {
		Local Font, FontName, Width, Height, Sec, Name, DB, DS, hH1, hH2, hM1, hM2, hS1, hS2, hF1, hF2, W, FlashTime, Flash, Class
			, Colon, Colon_O, S_DefaultGui, S_FormatInteger, RealWidth, hWnd, ColorItem, BckgItem, BckgMain, Off, k, v, rm, rm1
			, hDel1, hDel2, hDel3, hDel4, hDel5, hDel6, hDel7, hDel8, hDel9, S_BatchLines
		
		Static all := ["hWnd","Name","Sec","RealWidth","RealHeight","FlashTime","hParent"
			,"Pos","Height","Flash","BckgMain","BckgItem","ColorItem"
			,"hDel1","hDel2","hDel3","hDel4","hDel5","hDel6","hDel7","hDel8","hDel9"
			,"hH1","hH2","hM1","hM2","hS1","hS2","hF1","hF2"]
			, items := ["H1","H2","M1","M2","S1","S2"]
		
		S_BatchLines := A_BatchLines 
		SetBatchLines, -1
		S_FormatInteger := A_FormatInteger
		SetFormat, IntegerFast, D
		Option := "|" Option "|"
		If !Width := This.Option("W", Option, 0)
			this._PrPos(hParent, _,_,w, _), Width := w 
		If !Height := This.Option("H", Option, 0) 
			this._PrPos(hParent, _,_,_, h), Height := h 
		DS := This.Option("DS", Option, 0)
		DB := This.Option("DB", Option, 0)
		BckgMain := This.Option("BckgMain", Option, "Default")
		BckgItem := This.Option("BckgItem", Option, "000000")
		ColorItem := This.Option("ColorItem", Option, "ffffff")
		Name := This.Option("Name", Option)
		Font := This.Option("Font", Option)
		FontName := This.Option("FontName", Option)
		Sec := !!RegExMatch(Option, "i)\|\s*Sec\s*\|")
		Colon := !!RegExMatch(Option, "i)\|\s*Colon\s*\|")
		Pos := This.Option("Pos", Option)
		Section := Instr(Option, "|Section|") ? "Section" : ""
		If (Colon_O := this.Option("Colon", Option)) && (Colon := 1)
		{
			InStr(Colon_O, "Flash") && (Flash := 1) && !RegExMatch(Colon_O, "\s+\d+", FlashTime) && (FlashTime := 500)
			FlashTime := FlashTime > 950 ? 950 : FlashTime < 50 ? 50 : FlashTime
		}
		W := (Width - (DS * (Sec ? 3 : 2) + DB * (Sec ? 2 : 1))) / (Sec ? 6 : 4)

		If IsChange
			For, k, v in This.AllControls
				DllCall("DestroyWindow", "Ptr", v)
				
		S_DefaultGui := A_DefaultGui
		If IsChange
		{
			hWnd := This.hWnd
			Gui, %hWnd%:Default
		}
		Else
		{
			Gui, New 
			Gui, +HWNDhWnd -DPIScale -Caption +0x40000000 -0x80000000  ; Add WS_CHILD, remove WS_POPUP, setparent no deactivate main gui
			Gui, Margin, 0, 0
		}
		If IsChange
			Gui, Show, Hide
		Gui, Font 
		Gui, Font, %Font%, %FontName%
		Gui, Color, %BckgItem%
		
		Gui, Add, Text, x0 y0 w%W% h%Height% +0x201 +0x100 c%ColorItem% HwndhH1, % This.h1
		Gui, Add, Progress, x+0 yp hp w%DS% Background%BckgMain% HwndhDel1
		Gui, Add, Text, x+0 y0 w%W% hp +0x201 +0x100 c%ColorItem% HwndhH2, % This.h2

		If Colon
		{
			Off := (RegExMatch(Colon_O, "i)v(\d+)", rm) ? rm1 : Height / 6)
			Gui, Add, Progress, x+0 yp hp w%DS% Background%BckgMain% HwndhDel2
			Gui, Add, Text, % "+0x201 x+0 yp-" Off " hp+" Off " w" (DB - DS * 2) " c" ColorItem " HwndhF1", :
			Gui, Add, Progress, x+0 y0 h%Height% w%DS% Background%BckgMain% HwndhDel3
		}
		Else
			Gui, Add, Progress, x+0 yp hp w%DB% Background%BckgMain% HwndhDel4

		Gui, Add, Text, x+0 y0 w%W% hp +0x201 +0x100 c%ColorItem% HwndhM1, % This.m1
		Gui, Add, Progress, x+0 yp hp w%DS% Background%BckgMain% HwndhDel5
		Gui, Add, Text, x+0 y0 w%W% hp +0x201 +0x100 c%ColorItem% HwndhM2, % This.m2
		
		If Sec
		{
			If Colon
			{
				Gui, Add, Progress, x+0 yp hp w%DS% Background%BckgMain% HwndhDel6
				Gui, Add, Text, % "+0x201 x+0 yp-" Off " hp+" Off " w" (DB - DS * 2) " c" ColorItem " HwndhF2", :
				Gui, Add, Progress, x+0 y0 h%Height% w%DS% Background%BckgMain% HwndhDel7
			}
			Else
				Gui, Add, Progress, x+0 yp hp w%DB% Background%BckgMain% HwndhDel8
			Gui, Add, Text, x+0 y0 w%W% hp +0x201 +0x100 c%ColorItem% HwndhS1, % This.s1
			Gui, Add, Progress, x+0 yp hp w%DS% Background%BckgMain% HwndhDel9
			Gui, Add, Text, x+0 y0 w%W% hp +0x201 +0x100 c%ColorItem% HwndhS2, % This.s2
		}
		Gui, +Parent%hParent%
		Gui, %hParent%:Add, Text, Hidden HWNDhDummy %Pos% w0 h0
		GuiControlGet, MyPos, Pos, %hDummy%
		DllCall("DestroyWindow", "Ptr", hDummy) 
		
		If IsChange
			Gui, Show, AutoSize x%MyPosX% y%MyPosY%
		Else
			Gui, Show, Hide AutoSize x%MyPosX% y%MyPosY%
			
		Gui, %S_DefaultGui%:Default
		
		WinGetPos, , , RealWidth, RealHeight, ahk_id %hWnd%
		Gui, %hParent%:Add, Text, Hidden HWNDhDummy x%MyPosX% y%MyPosY% w%RealWidth% h%RealHeight% %Section%
		DllCall("DestroyWindow", "Ptr", hDummy)

		For, k, v in all
			This[v] := %v%
		For k, v in items
			This.Mem.Ctrl[h%v%] := {Gui:hWnd, Name:v}
		This.Mem.Gui[hWnd] := This
		If !IsChange
			This.Stop(1)
		If IsChange
			This.Set(This.h1 This.h2, This.m1 This.m2, This.s1 This.s2)
		
		This.AllControls := [hH1,hH2,hM1,hM2,hS1,hS2,hF1,hF2
				,hDel1,hDel2,hDel3,hDel4,hDel5,hDel6,hDel7,hDel8,hDel9]
				
		SetFormat, IntegerFast, %S_FormatInteger%
		SetBatchLines, %S_BatchLines%
	}
	ChangeColor(BckgMain, BckgItem, ColorItem) {
		Static a := ["hDel1","hDel2","hDel3","hDel4","hDel5","hDel6","hDel7","hDel8","hDel9"]
			, b := ["hH1","hH2","hM1","hM2","hS1","hS2","hF1","hF2"]
		If BckgMain !=
			For, k, v in a, This.BckgMain := BckgMain {
				GuiControl, % This.hWnd ": +Background" BckgMain, % This[v]
				; GuiControl, % This.hWnd ": +Redraw", % This[v]
			}
		If ColorItem !=
			For, k, v in b, This.ColorItem := ColorItem {
				GuiControl, % This.hWnd ": +c" ColorItem, % This[v]
				; GuiControl, % This.hWnd ": +Redraw", % This[v]
			}
		Gui, % This.hWnd ": Color", % BckgItem != "" ? (This.BckgItem := BckgItem) : This.BckgItem
	}
	Initialize() {
		Static Start
		If Start
			Return
		Start := 1
		OnMessage(This.ThisClass.WM_LBUTTONDOWN, ObjBindMethod(This.ThisClass, "OnButtonDown"))
		OnMessage(This.ThisClass.WM_LBUTTONDBLCLK, ObjBindMethod(This.ThisClass, "OnButtonDown"))
		OnMessage(This.ThisClass.WM_RBUTTONDOWN, ObjBindMethod(This.ThisClass, "OnButtonDown"))
		OnMessage(This.ThisClass.WM_RBUTTONDBLCLK, ObjBindMethod(This.ThisClass, "OnButtonDown"))
		OnMessage(This.ThisClass.WM_MOUSEWHEEL, ObjBindMethod(This.ThisClass, "OnMouseWheel"))
		OnMessage(This.ThisClass.WM_MBUTTONDOWN, ObjBindMethod(This.ThisClass, "OnMbuttonDown"))
	}
	_PrPos(hParent, Byref MyPosx, Byref MyPosy, Byref MyPosw, Byref MyPosh) {
		Gui, %hParent%:Add, Text, Hidden HWNDhDummy xp yp wp hp
		GuiControlGet, MyPos, Pos, %hDummy%
		DllCall("DestroyWindow", "Ptr", hDummy)
	}
	Show(Show=1) {
		Gui, % This.hWnd ":" (Show ? "Show" : "Hide"), % (Show ? "NA" : "")
	}
	Move(x, y) {
		x := Format("{:d}", x), y := Format("{:d}", y)
		Gui, % This.hWnd ":Show", NA x%x% y%y%
	}
	Stop(Param = "") {
		If Param =
			Return This._Stop
		This._Stop := Param
		If !Param
			This.Block(1)
		If Param && This.InDay
			This.InDay := 0
		If Param
			This.KillTimer(1), This.KillTimer(2), This.KillTimer(3)
		If Param && This.Flash
			This.ColonView()
	}
	Block(Param = "") {
		If Param !=
			This._Block := Param
		Return This._Block
	}
	Option(key, option, ret="") {
		Local Match, Match1
		RegExMatch(option, "iS)\|\s*" key "\s+(.*?)\s*\|", Match)
		Return ret != "" && Match1 = "" ? ret  : Match1
	}
	NumInput(Func = "") {
		Local S_BatchLines, S_FormatInteger, Option
		Static hMethod, PrOption
		If !hMethod
			hMethod := ObjBindMethod(This.ThisClass, "OnNumInput")
		ClockGui.ThisNumInput := (Func != "") ? This : ""
		ClockGui.NumInputFunc := (Func != "") ? Func(Func) : ""
		Option := (Func != "") ? "On" : "Off"
		If (Option = PrOption)
			Return
		PrOption := Option
		#IF ClockGui.NumRules()
		#IF
		S_BatchLines := A_BatchLines
		SetBatchLines, -1 
		S_FormatInteger := A_FormatInteger
		SetFormat, IntegerFast, D
		Hotkey, IF, ClockGui.NumRules()
		Loop 10
		{
			Hotkey, % A_Index - 1, % hMethod, % Option
			Hotkey, % "Numpad" A_Index - 1, % hMethod, % Option
		}
		Hotkey, Backspace, % hMethod, % Option
		Hotkey, Delete, % hMethod, % Option
		Hotkey, NumpadDot, % hMethod, % Option
		Hotkey, IF
		SetFormat, IntegerFast, %S_FormatInteger%
		SetBatchLines, %S_BatchLines%
	}
	OnNumInput() {
		Local str, d, d1, T
		T := ClockGui.ThisNumInput
		add := RegExMatch(A_ThisHotkey, "(\d)$", d)
		str := T.h1 T.h2 T.m1 T.m2 . (T.Sec ? T.s1 T.s2 : "")
		str := (add ? "" : 0) . SubStr(Str, add ? 2 : 1, add ? 6 : -1) . (add ? d1 : "")
		T.Set(SubStr(Str, 1, 2), SubStr(Str, 3, 2), T.Sec ? SubStr(Str, 5, 2) : "")
	}
	NumRules() {
		Return ClockGui.NumInputFunc.Call()
	}
	OnButtonDown(wp, lp, msg, hwnd) {
		If !This.Mem.Ctrl.HasKey(hwnd) || (This.Mem.Gui[A_Gui]).Block()
			Return
		If (msg = This.WM_LBUTTONDOWN || msg = This.WM_LBUTTONDBLCLK)
			This.Step(1, This.Mem.Ctrl[hwnd].Name, A_Gui)
		Else
			This.Step(0, This.Mem.Ctrl[hwnd].Name, A_Gui)
		Return 1
	}
	OnMouseWheel(wp, lp, Msg, hwnd) {
		Local hCtrl
		MouseGetPos, , , , hCtrl, 2
		If !This.Mem.Ctrl.HasKey(hCtrl) || (This.Mem.Gui[This.Mem.Ctrl[hCtrl].Gui]).Block()
			Return
		This.Step((wp >> 16) = 120 ? 1 : 0, This.Mem.Ctrl[hCtrl].Name, This.Mem.Ctrl[hCtrl].Gui)
		Return 1
	}
	OnMbuttonDown(wp, lp, Msg, hwnd) {
		Local o, l
		If !This.Mem.Ctrl.HasKey(hwnd) || (o := This.Mem.Gui[A_Gui]).Block()
			Return
		l := SubStr(This.Mem.Ctrl[hwnd].Name, 1, 1)
		GuiControl, % A_Gui ":", % o["h" l 1], % o[l 1] := "0"
		GuiControl, % A_Gui ":", % o["h" l 2], % o[l 2] := "0"
		Return 1, This._OnStep(o)
	}
	Step(add, c, hwnd, o="", b=0) {
		Static a := {H1:2,H2:9,M1:5,M2:9,S1:5,S2:9} 
		o := This.Mem.Gui[hwnd] 
		o[c] := Format("{:d}", add ? (o[c] >= a[c] ? 0 : o[c] + 1) : (o[c] = 0 || o[c] > a[c] ? a[c] : o[c] - 1))
		If InStr(c, "h") && (o.H1 o.H2 > 23) && (1, b := c = "H2")
			GuiControl, % o.hwnd ":", % o["hH2"], % o.H2 := (c = "H1" || add ? "0" : "3")
		If !b
			GuiControl, % o.hwnd ":", % o["h" c], % o[c]
		This._OnStep(o)
	}
	_OnStep(o) {
		If o.OnStep
		{
			hFunc := Func(o.OnStep).Bind(o)
			SetTimer, % hFunc, % "-" o.OnStepDelay
		}  
	}
	Set(h, m, s) {
		Local k, v, d
		Static a := ["H1","H2","M1","M2","S1","S2"]
		For k, v in a
			If This[v] != (d := SubStr(h m s, k, 1))
				GuiControl, % This.hwnd ":", % This["h" v], % This[v] := Format("{:d}", d)
	}
	SetTime(Time) {
		Local o
		If Time =
			Return This.Watch ? This.Set("00", "00", "00") : This.Set(A_Hour, A_Min, A_Sec)
		o := StrSplit(Time, ":")
		This.Set(o[1], o[2], o[3])
	}
	Get(obj=0) {
		Local Time
		Time := This.h1 This.h2 ":" This.m1 This.m2 ":" This.s1 This.s2
		Return obj ? StrSplit(Time, ":") : Time
	}
	StartClock() {
		If !This.Stop()
			Return 0
		This.Stop(0), This.Timer := 0, This.Watch := 0, This.InDay := 0, This.Loop := 0
		This.Set(A_Hour, A_Min, A_Sec)
		This.SetTimer((1000 - A_Msec) + 100, 1, "TimerClock")
		Return 1
	}
	StartTimer(Func="") {
		Local TimerPeriod
		If !This.Stop() || This.Get() = "00:00:00"
			Return 0
		This.Stop(0)
		TimerPeriod := This.HMSToMSec(This.h1 This.h2, This.m1 This.m2, This.s1 This.s2)
		If !TimerPeriod
			Return 0, This.Stop(1)
		This.TimerStart := A_TickCount + 1000, This.TimerStartMsec := A_Msec
		This.TimerPeriod := TimerPeriod, This.Func := Func, This.Timer := 1, This.Watch := 0, This.InDay := 0, This.Loop := 0
		This.SetTimer(1100, 1, "TimerTimer")
		Return 1
	}
	StartWatch(Func="", Loop=0) {
		If !This.Stop()
			Return 0
		This.Stop(0)
		This.WatchStart := A_TickCount - This.HMSToMSec(This.h1 This.h2, This.m1 This.m2, This.s1 This.s2)
		This.WatchStartMsec := A_Msec, This.Func := Func, This.Timer := 0, This.Watch := 1, This.InDay := 0, This.Loop := Loop
		This.SetTimer(1100, 1, "TimerWatch")
		Return 1
	}
	StartTimerDay(Func="", Date="", Loop=0) {
		Local TimerPeriod
		If !This.Stop()
			Return 0
		If Date = User
			TimerPeriod := This.DifferenceTime((This.CheckDate := This.Get()), A_Hour ":" A_Min ":" A_Sec, 1) - A_Msec
		Else If Date
			TimerPeriod := This.DifferenceTime((This.CheckDate := Date), A_Hour ":" A_Min ":" A_Sec, 1) - A_Msec
		Else
			TimerPeriod := 86400000 - A_Msec, This.CheckDate := A_Hour ":" A_Min ":" A_Sec
		If !TimerPeriod
			Return 0, This.Stop(1)
		This.TimerStart := A_TickCount + 1000, This.TimerStartMsec := 0, This.TimerPeriod := TimerPeriod
		This.Timer := 1, This.Watch := 0, This.InDay := 1, This.Func := Func, This.Stop(0), This.Loop := Loop
		This.SetTime(This.FormatTime(TimerPeriod))
		This.SetTimer(10, 1, "TimerTimer")
		Return 1
	}
	StartWatchDay(Func="", Date="", Loop=0) {
		If !This.Stop()
			Return 0
		If Date = User
			This.WatchStart := A_TickCount - (This.DifferenceTime(A_Hour ":" A_Min ":" A_Sec, (This.CheckDate := This.Get()), 1) + A_Msec)
		Else If Date
			This.WatchStart := A_TickCount - (This.DifferenceTime(A_Hour ":" A_Min ":" A_Sec, (This.CheckDate := Date), 1) + A_Msec)
		Else
			This.WatchStart := A_TickCount - A_Msec, This.CheckDate := A_Hour ":" A_Min ":" A_Sec
		This.Watch := 1, This.Timer := 0, This.InDay := 1, This.Loop := Loop
		This.WatchStartMsec := 0, This.Func := Func, This.Stop(0)
		This.SetTimer(10, 1, "TimerWatch")
		Return 1
	}
	TimerTimer() {
		Local Time, t
		If This.Stop()
			Return
		Time := This.FormatTime(This.TimerPeriod - (A_TickCount - This.TimerStart))
		This.SetTime(Time)
		This.CheckFlash()
		If Time = 00:00:00
		{
			If !This.Loop
				Return This.Stop(1), Func(This.Func).Call(This)
			This.TimerStart := A_TickCount + 1000
			TimerPeriod := This.DifferenceTime(This.CheckDate, A_Hour ":" A_Min ":" A_Sec, 1) - A_Msec
			This.TimerPeriod := TimerPeriod <= 0 ? 86400000 + TimerPeriod : TimerPeriod
			This.SetTimer(10, 3, This.Func) 
		}
		If This.InDay
			t := (1000 - A_Msec)
		Else
			t := This.TimerStartMsec - A_Msec, t := (t < 0 ? 1000 + t : t)
		This.SetTimer(t + 100, 1, "TimerTimer")
	}
	TimerWatch() {
		Local Time, t
		If This.Stop()
			Return
		If (t := A_TickCount - This.WatchStart) > 86399999
		{
			If !This.Loop
				Return This.Stop(1), This.SetTime("00:00:00"), Func(This.Func).Call(This)
			This.SetTimer(10, 3, This.Func)
			Time := "00:00:00", This.WatchStart += 86400000
		}
		Else
			Time := This.FormatTime(t)
		This.SetTime(Time)
		This.CheckFlash()
		If This.InDay
			t := (1000 - A_Msec)
		Else
			t := This.WatchStartMsec - A_Msec, t := (t < 0 ? 1000 + t : t)
		This.SetTimer(t + 100, 1, "TimerWatch")
	}
	Reset() {
		This.Stop(1)
		This.Set("00", "00", "00")
	}
	TimerClock() {
		If This.Stop()
			Return
		This.Set(A_Hour, A_Min, A_Sec)
		This.CheckFlash()
		This.SetTimer((1000 - A_Msec) + 100, 1, "TimerClock")
	}
	SetTimer(Delay, ID, Method) {
		If !This.__Class {
			This := Object(A_EventInfo), This.KillTimer(ID)
			Return ID = 3 ? Func(This.TimerCall[ID]).Call(This) : This[This.TimerCall[ID]]()
		}
		This.TimerCall[ID] := Method
		DllCall("SetTimer", Ptr, This.Hwnd, Ptr, ID, UInt, Delay, Ptr, RegisterCallback(This.SetTimer, "CDecl Fast", "", Object(This)))
	}
	KillTimer(ID) {
		DllCall("KillTimer", Ptr, This.hWnd, Ptr, ID)
	}
	CheckFlash() {
		If !This.Flash
			Return
		DllCall("ShowWindowAsync", "Ptr", This.hF1, "Int", 0)
		If This.Sec
			DllCall("ShowWindowAsync", "Ptr", This.hF2, "Int", 0)
		This.SetTimer(This.FlashTime, 2, "ColonView")
	}
	ColonView() {
		DllCall("ShowWindowAsync", "Ptr", This.hF1, "Int", 1)
		If This.Sec
			DllCall("ShowWindowAsync", "Ptr", This.hF2, "Int", 1)
	}
	Destroy() {
		Local k, v
		If !This
			Return
		This.Stop(1)
		Gui, % This.hWnd ":Destroy"
		For k, v in ["hS1","hM1","hH1","hS2","hM2","hH2"]
			This.Mem.Ctrl.Delete(This[v])
		This.Mem.Gui.Delete(This.hWnd)
		This.Delete(Chr(0), Chr(0x10FFFF))
		This.Delete(This.MinIndex(), This.MaxIndex())
		This.SetCapacity(0)
		This.Base := ""
	}
	IsTimeInDay() {
		Static a := {H1:2,H2:9,M1:5,M2:9,S1:5,S2:9} 
		For k, v in a
			If (This[k] = "" || This[k] > v)
				Return 0
		Return This.H1 This.H2 < 24
	}
	IsTimeEmpty() { 
		Return This.Get() = "00:00:00"
	}
	MathTime(Time1, S, Time2) {
		Local T
		Time1 := Time1 = "" ? A_Hour ":" A_Min ":" A_Sec : Time1
		T := This.StrToMSec(Time1) + (S This.StrToMSec(Time2))
		T := Mod(T, 86400000)
		Return This.FormatTime(T < 0 ? 86400000 + T : T)
	}
	FormatTime(Time) {
		Local Rest, Hours, Min, Sec, MSec
		If Time < 0
			Return "00:00:00"
		Rest := Mod(Time, 3600000)
		Hours := Format("{:02d}", Time // 3600000)
		Min := Format("{:02d}", Rest // 60000)
		Sec := Format("{:02d}", Mod(Rest, 60000) // 1000)
		; MSec := Format("{:03d}", Mod(Rest, 1000))
		Return Hours ":" Min ":" Sec
	}
	StrToMSec(Time) {
		Local o
		o := StrSplit(Time, ":")
		Return This.HMSToMSec(o[1], o[2], o[3])
	}
	HMSToMSec(h, m, s=0) {
		Local sec
		sec := h * 3600
		sec += m * 60
		sec += s
		Return sec * 1000
	}
	DifferenceTime(Time1, Time2, Day=0) {
		Local T
		T := StrSplit(Time1, ":")
		Time1 := This.HMSToMSec(T[1], T[2], (T[3] ? T[3] : "00"))
		T := StrSplit(Time2, ":")
		Time2 := This.HMSToMSec(T[1], T[2], (T[3] ? T[3] : "00"))
		T := Time1 - Time2
		If !Day
			Return T
		T := Mod(T, 86400000)
		If T < 0
			Return 86400000 + T
		Return T
	}
}
  
