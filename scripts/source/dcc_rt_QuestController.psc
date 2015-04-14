Scriptname dcc_rt_QuestController extends Quest

Actor Property Player Auto
Spell Property dcc_rt_SpellTaste Auto

Event OnInit()
	self.Player.RemoveSpell(self.dcc_rt_SpellTaste)
	self.Player.AddSpell(self.dcc_rt_SpellTaste,False)
	Return
EndEvent
