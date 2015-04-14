Scriptname dcc_rt_EffectTaste_Main extends ActiveMagicEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Keyword Property VendorItemFood Auto
Keyword Property VendorItemFoodRaw Auto
Keyword Property VendorItemIngredient Auto

Int    Property SLAID = 0x4290f Auto Hidden
String Property SLAESP = "SexLabAroused.esm" Auto Hidden
String Property BWAESP = "Blush When Aroused.esp" Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnObjectEquipped(Form what, ObjectReference which)
	self.UnregisterForUpdate()

	If(what.HasKeyword(VendorItemFood))
		self.Happy()
	ElseIf(what.HasKeyword(VendorItemFoodRaw) || what.HasKeyword(VendorItemIngredient))
		self.Sad()
	EndIf

	self.RegisterForSingleUpdate(5)
	Return
EndEvent

Event OnUpdate()
	self.Clear()
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Happy()
	self.ModArousal(5)
	self.Blush(0.6,1,3.0)
	self.GetTargetActor().SetExpressionOverride(2,75)
	Return
EndFunction

Function Sad()
	self.ModArousal(-5)
	self.Blush(0.8,1,3.0)
	self.GetTargetActor().SetExpressionOverride(3,75)
	Return
EndFunction

Function Clear()
	self.GetTargetActor().ClearExpressionOverride()
	Return
EndFunction

Function Blush(Float opacity=0.8, Int fulltime=3, Float fadetime=1.0)
;; soft support for Blush When Aroused
;; http://www.loverslab.com/files/file/1724-blush-when-aroused/

	If(Game.GetModByName(self.BWAESP) == 255)
		Return
	Endif

	int e = 0
	Actor who = self.GetTargetActor()
	Actor player = Game.GetPlayer()

	If(who != player)
		e = ModEvent.Create("BWA_ForceBlushOn")
	Else
		e = ModEvent.Create("BWA_ForceBlushOnPlr")
	Endif

	If(e == 0)
		Return
	EndIf

	If(who != player)
		ModEvent.PushForm(e,who as Form)
	EndIf

	ModEvent.PushFloat(e,opacity)
	ModEvent.PushInt(e,fulltime)
	ModEvent.PushFloat(e,fadetime)
	ModEvent.PushBool(e,false)

	ModEvent.Send(e)
	Return
EndFunction

Function ModArousal(Int amount)
;; soft support for SexLab Aroused / SexLab Aroused Redux
;; http://www.loverslab.com/files/file/1421-sexlab-aroused-redux/

	If(Game.GetModByName(self.SLAESP) == 255)
		Return
	EndIf

	(Game.GetFormFromFile(self.SLAID,self.SLAESP) as slaFrameworkScr).UpdateActorExposure(self.GetTargetActor(),amount)
	Return
EndFunction

