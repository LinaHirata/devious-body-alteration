Scriptname dba_PlayerRef extends ReferenceAlias

Actor Property dba_player  Auto  
dba_BodyTicker Property bodyticker  Auto
dba_MCM Property MCMValue Auto

event OnPlayerLoadGame()
	bodyticker.OnInit()

	if MCMValue.modenabled
		bodyticker.resetAlterations()
		utility.wait(2)
	
		bodyticker.BodyTransform()
		utility.wait(2)
	
		bodyticker.BodyMorph()
	endif
	bodyticker.RegisterForSingleUpdate(10)
endEvent

event onObjectEquipped (Form type, ObjectReference ref)
	if type.gettype() != 46	;little workaround to avoid Error spaming in the log :)
		if MCMValue.debuglogenabled
			Debug.trace("DBA: type=" + type + " Nothing done.")
		endif
	else
		if MCMValue.debuglogenabled
			Debug.trace("DBA: type=" + type)
		endif
		
		if (type as Potion).isFood()
			float[] magnitudes = (type as potion).GetEffectMagnitudes()
			int n = 0
			float s = 0.0

			while n < magnitudes.length
				s += magnitudes[n]
				n += 1
			endwhile

			float add = 0.0
			if s / n > 5
				add = 5
			else 
				add = s / n
			endif
			bodyticker.weighttime += add

			if MCMValue.debuglogenabled
				Debug.trace("DBA: Weightplus= " + add + " ; Weight=" + bodyticker.weighttime)
			endif
		endif
	endif
endEvent
