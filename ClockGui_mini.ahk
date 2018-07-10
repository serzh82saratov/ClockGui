Class ClockGui {
	;  Автор - serzh82saratov
	;  Описание - http://forum.script-coding.com/viewtopic.php?id=12931
	
	__New(hParent, Option) {
		Local Font, FontName, Width, Height, Sec, Name, DB, DS, hH1, hH2, hM1, hM2, hS1, hS2, hF1, hF2, W, Flash
		, FlashTime, Colon, Colon_O, S_DefaultGui, RealWidth, hWnd, ColorItem, BckgItem, BckgMain, Off, k, v, rm, rm1

		Option := "|" Option "|"
		Width := this.Option("W", Option)
		Height := this.Option("H", Option)
		DS := this.Option("DS", Option, 0)
		DB := this.Option("DB", Option, 0)
		BckgMain := this.Option("BckgMain", Option, "Default")
		BckgItem := this.Option("BckgItem", Option, "000000")
		ColorItem := this.Option("ColorItem", Option, "ffffff")
		Name := this.Option("Name", Option)
		Font := this.Option("Font", Option)
		FontName := this.Option("FontName", Option)
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
		
		S_DefaultGui := A_DefaultGui
		Gui, New
		Gui, +HWNDhWnd -DPIScale -Caption +0x40000000 -0x80000000  ; Add WS_CHILD, remove WS_POPUP, setarent no deactivate main gui
		Gui, Color, %BckgItem%
		Gui, Margin, 0, 0
		Gui, Font, %Font%, %FontName%

		Gui, Add, Text, x0 y0 w%W% h%Height% +0x201 +0x100 c%ColorItem% HwndhH1
		Gui, Add, Progress, x+0 yp hp w%DS% Background%BckgMain%
		Gui, Add, Text, x+0 y0 w%W% hp +0x201 +0x100 c%ColorItem% HwndhH2

		If Colon
		{
			Off := (RegExMatch(Colon_O, "i)v(\d+)", rm) ? rm1 : Height / 6)
			Gui, Add, Progress, x+0 yp hp w%DS% Background%BckgMain%
			Gui, Add, Text, % "+0x201 x+0 yp-" Off " hp+" Off " w" (DB - DS * 2) " c" ColorItem " HwndhF1", :
			Gui, Add, Progress, x+0 y0 h%Height% w%DS% Background%BckgMain%
		}
		Else
			Gui, Add, Progress, x+0 yp hp w%DB% Background%BckgMain%

		Gui, Add, Text, x+0 y0 w%W% hp +0x201 +0x100 c%ColorItem% HwndhM1
		Gui, Add, Progress, x+0 yp hp w%DS% Background%BckgMain%
		Gui, Add, Text, x+0 y0 w%W% hp +0x201 +0x100 c%ColorItem% HwndhM2
		If Sec
		{
			If Colon
			{
				Gui, Add, Progress, x+0 yp hp w%DS% Background%BckgMain%
				Gui, Add, Text, % "+0x201 x+0 yp-" Off " hp+" Off " w" (DB - DS * 2) " c" ColorItem " HwndhF2", :
				Gui, Add, Progress, x+0 y0 h%Height% w%DS% Background%BckgMain%
			}
			Else
				Gui, Add, Progress, x+0 yp hp w%DB% Background%BckgMain%
			Gui, Add, Text, x+0 y0 w%W% hp +0x201 +0x100 c%ColorItem% HwndhS1
			Gui, Add, Progress, x+0 yp hp w%DS% Background%BckgMain%
			Gui, Add, Text, x+0 y0 w%W% hp +0x201 +0x100 c%ColorItem% HwndhS2
		}
		Gui, +Parent%hParent%
		Gui, %hParent%:Add, Text, Hidden HWNDhDummy %Pos% w0 h0
		GuiControlGet, MyPos, Pos, %hDummy% 
		DllCall("DestroyWindow", "Ptr", hDummy)
		
		Gui, Show, Hide AutoSize x%MyPosX% y%MyPosY% 
		Gui, %S_DefaultGui%:Default
		WinGetPos, , , RealWidth, RealHeight, ahk_id %hWnd%
		
		Gui, %hParent%:Add, Text, Hidden HWNDhDummy x%MyPosX% y%MyPosY% w%RealWidth% h%RealHeight% %Section%
		DllCall("DestroyWindow", "Ptr", hDummy)

		For, k, v in ["hWnd","Name","Sec","RealWidth","FlashTime","RealHeight","hParent","Pos"
		,"Height","Flash","hH1","hH2","hM1","hM2","hS1","hS2","hF1","hF2"]
			this[v] := %v%
	}
	Show(Show=1) { 
		If !Show {
			Gui, % This.hWnd ":Hide"
			Return
		}
		This.Set(A_Hour, A_Min, A_Sec)
		Gui, % This.hWnd ":Show", NA
	}
	Move(x, y) {
		x := Format("{:d}", x), y := Format("{:d}", y)
		Gui, % This.hWnd ":Show", NA x%x% y%y%
	}
	Option(key, option, ret="") {
		Local Match, Match1
		RegExMatch(option, "iS)\|\s*" key "\s+(.*?)\s*\|", Match)
		Return ret != "" && Match1 = "" ? ret  : Match1
	}
	Set(h, m, s) {
		Local k, v, d
		For k, v in ["H1","H2","M1","M2","S1","S2"]
			If This[v] != (d := SubStr(h m s, k, 1))
				GuiControl, % This.hwnd ":", % This["h" v], % This[v] := Format("{:d}", d) 
	}
	StartClock(Func="", Loop=0) {
		Local obj
		This.Set(A_Hour, A_Min, A_Sec)
		obj := ObjBindMethod(This, "TimerClock")
		SetTimer, % obj, % "-" (1000 - A_Msec) + 100
	}
	TimerClock() {
		Local obj
		If This.Stop()
			Return
		This.Set(A_Hour, A_Min, A_Sec)
		This.CheckFlash()
		obj := ObjBindMethod(This, "TimerClock")
		SetTimer, % obj, % "-" (1000 - A_Msec) + 100
	}
	CheckFlash() {
		Local obj
		If !This.Flash
			Return
		DllCall("ShowWindowAsync", "Ptr", This.hF1, "Int", 0)
		If This.Sec
			DllCall("ShowWindowAsync", "Ptr", This.hF2, "Int", 0)
		obj := ObjBindMethod(This, "ColonView")
		SetTimer, % obj, % "-" This.FlashTime
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
		This.Delete(Chr(0), Chr(0x10FFFF))
		This.Delete(This.MinIndex(), This.MaxIndex())
		This.SetCapacity(0)
		This.Base := ""
	}
} 
