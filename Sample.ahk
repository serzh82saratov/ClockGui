#SingleInstance Force
#Persistent
#NoEnv
ListLines Off
SetBatchLines -1

Gui, +HWNDhMain -DPIScale
Gui, Color, F9D886


Timer := New ClockGui(hMain, "Sec|Name MyTimer|w 400|h 120|ds 1|db 16|bckgmain F9D886|Font s80|Colon")
Timer.SetTime("10:00:04")  
Timer.StartTimer()
Timer.Show()

Watch := New ClockGui(hMain, "Pos xp y+10|Sec|Name MyWatch|w 400|h 120|ds 1|db 10|bckgmain F9D886|bckgitem FFFFFF|coloritem F9D886|Font s80")
Watch.SetTime("23:59:56")
Watch.StartWatch(, 1) 
Watch.Show()

Clock := New ClockGui(hMain, "Pos xp y+10|Section|w 400|h 120|db 20|bckgitem C0C0C0|coloritem 5671BD|Font s90|FontName Comic Sans MS|Colon Flash 100")
Clock.StartClock()
Clock.Show()

Clock2 := New ClockGui(hMain, "Pos xs+120 y+10|Sec|w 160|h 30|db 6|bckgitem F9D886|coloritem 010101|Font Bold s20|Colon Flash")
Clock2.StartClock()
Clock2.Show()

TestTimer := New ClockGui(hMain, "Pos xs y+10|Sec|Name TestTimer|w 400|h 120|ds 1|db 14|bckgmain 555555|Font s80|Colon Flash 300")
TestTimer.SetTime("00:00:03")
TestTimer.Show()

Gui, Add, Button, xp60 y+20 gTimerStart, Запустить таймер
Gui, Add, Button, x+20 yp gTimerStop, Остановить
Gui, Add, Button, x+20 yp gTimerReset, Сбросить
Gui, Show
Return

TimerStart:
	TestTimer.StartTimer("EndTimer")
	Return

TimerStop:
	TestTimer.Stop(1)
	TestTimer.Block(0)
	Return

TimerReset:
	Gosub, TimerStop
	TestTimer.SetTime("00:00:03")
	Return

EndTimer(This) {
	MsgBox % This.Name "`nВремя вышло"
	(!This.Loop && This.Block(0))
}

GuiClose:
	ExitApp
