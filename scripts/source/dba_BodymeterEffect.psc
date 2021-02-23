Scriptname dba_BodymeterEffect extends activemagiceffect

dba_BodyTicker property dba_BT Auto

Event OnEffectStart(Actor akTarget, Actor akActor)
	Utility.wait(0.1)
	dba_BT.Bodymeter()
endEvent
