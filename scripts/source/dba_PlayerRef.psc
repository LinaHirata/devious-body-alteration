Scriptname dba_PlayerRef extends ReferenceAlias

Actor Property dba_player  Auto  
dba_BodyTicker Property BodyTicker  Auto
dba_MCM Property MCMValue Auto

event OnPlayerLoadGame()
	BodyTicker.OnInit()

	if MCMValue.modenabled
		BodyTicker.resetAlterations()
		utility.wait(2)
	
		BodyTicker.BodyTransform()
		utility.wait(2)
	
		BodyTicker.BodyMorph()
	endif
	BodyTicker.RegisterForSingleUpdate(10)
endEvent

event onObjectEquipped (Form type, ObjectReference ref)
	if MCMValue.weight
		if type.getType() != 46	; little workaround to avoid Error spaming in the log :)
			if MCMValue.debuglogenabled
				Debug.Trace("DBA: type=" + type + " Nothing done.")
			endif
		else
			if MCMValue.debuglogenabled
				Debug.Trace("DBA: type=" + type)
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
				BodyTicker.weighttime += add

				if MCMValue.debuglogenabled
					Debug.Trace("DBA: Weightplus= " + add + " ; Weight=" + BodyTicker.weighttime)
				endif
			endif
		endif
	endif
endEvent
