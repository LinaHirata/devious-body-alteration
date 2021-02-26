Scriptname dba_bodymeter extends ObjectReference

dba_BodyTicker property dba_BT Auto

event onEquipped(Actor dba_player)
	Utility.wait(0.1)
	dba_BT.Bodymeter()
	form a = game.getFormFromFile(0x00d6d7, "DeviousBodyAlteration.esp")
	dba_BT.dba_player.unEquipItem(a, false, true)
endEvent
