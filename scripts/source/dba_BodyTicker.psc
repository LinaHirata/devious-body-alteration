Scriptname dba_BodyTicker extends Quest Hidden 

dba_MCM property MCMValue Auto
Actor property dba_player Auto
zadlibs property libs Auto
zadConfig Property zadConfigHandle Auto ; zadConfigQuest [QUST:1501A282]
zadGagQuestScript Property zadGagHandle Auto ; zadGagQuest [QUST:1502B5EF]

import MfgConsoleFunc
import po3_SKSEFunctions

float GTcurrent = 0.0
float GTlastupdate = 0.0
float GTpassed = 0.0
float GTpassedActual = 0.0 ; shouldnt change original variable names ._.
float Morphupdate = 0.0 
float Transformupdate = 0.0 
float NextUpdate = 0.0

float property eyetime = 0.0 auto
;float eyehelper = 0.0
float property mouthtime = 0.0 auto
;float mouthhelper = 0.0
float property necktime = 0.0 auto
float property armtime = 0.0 auto
float property handtime = 0.0 auto
float property breasttime = 0.0 auto
float property waisttime = 0.0 auto
float property butttime = 0.0 auto
float property anustime = 0.0 auto
float property vaginatime = 0.0 auto
float property legtime = 0.0 auto
float property foottime = 0.0 auto
float property weighttime = 0.0 auto

float property eyetimeMax = 0.0 auto
float property mouthtimeMax = 0.0 auto
float property necktimeMax = 0.0 auto
float property armtimeMax = 0.0 auto
float property handtimeMax = 0.0 auto
float property breasttimeMax = 0.0 auto
float property waisttimeMax = 0.0 auto
float property butttimeMax = 0.0 auto
float property anustimeMax = 0.0 auto
float property vaginatimeMax = 0.0 auto
float property legtimeMax = 0.0 auto
float property foottimeMax = 0.0 auto

float weightcalc = 0.0 
float speedmod = 0.0

Keyword[] property dditem Auto
string[] property altstatus Auto

Armor property AlteredFeet Auto
Armor Property CinderellaFeetItem Auto
int Property Slot37 = 0x00000080 AutoReadOnly ; Feet

;################################################################################################################################################################
;----------------------------------------------------------------------- Initialization -------------------------------------------------------------------------
;################################################################################################################################################################

event OnInit()
	utility.wait(5.0) ; wait first, to reduce game save load (and crash chance)

	Debug.trace("DBA: Trying to set variables and update timer.")

	dba_player = Game.Getplayer()
	InitVariables()
	RegisterForSingleUpdate(MCMValue.UpdateTicker)
	
	Debug.trace("DBA: Variables and update timer are set.")	
endEvent

function InitVariables()
	dditem = new Keyword[32] ;more to start with.
	dditem[0] = libs.zad_DeviousBoots
	dditem[1] = libs.zad_DeviousCorset
	dditem[2] = libs.zad_DeviousHarness	
	dditem[3] = libs.zad_DeviousLegCuffs
	dditem[4] = libs.zad_DeviousArmCuffs
	dditem[5] = libs.zad_DeviousGag
	dditem[6] = libs.zad_DeviousCollar
	dditem[7] = libs.zad_DeviousBelt
	dditem[8] = libs.zad_DeviousBra
	dditem[9] = libs.zad_DeviousGloves
	dditem[10] = libs.zad_DeviousPlugVaginal
	dditem[11] = libs.zad_DeviousPlugAnal
	dditem[12] = libs.zad_DeviousPiercingsNipple
	dditem[13] = libs.zad_DeviousPiercingsVaginal
	dditem[14] = libs.zad_DeviousYoke
	dditem[15] = libs.zad_DeviousArmbinder
	dditem[16] = libs.zad_DeviousBlindfold
	dditem[17] = libs.zad_DeviousYokeBB
	dditem[18] = libs.zad_DeviousStraitJacket
	dditem[19] = libs.zad_DeviousArmbinderElbow
	dditem[20] = libs.zad_DeviousHobbleSkirt
	dditem[21] = libs.zad_DeviousHobbleSkirtRelaxed
	dditem[22] = libs.zad_DeviousSuit
	dditem[23] = libs.zad_DeviousAnkleShackles

	weighttime = dba_player.GetActorBase().getWeight()
	weightcalc = dba_player.GetActorBase().getWeight()
endFunction

;################################################################################################################################################################
;---------------------------------------------------------------------- Main Update Loop ------------------------------------------------------------------------
;################################################################################################################################################################

event OnUpdate()
	;float RTstart = Utility.GetCurrentRealTime()
	if !MCMValue.modenabled
		if MCMValue.MCMclose
			resetAlterations(false)
			NiOverride.UpdateModelWeight(dba_player)
			
			MCMValue.MCMclose = false
		endif

		if MCMValue.debuglogenabled
			Debug.trace("DBA: Mod disabled.")
		endif
		;Debug.Notification(Utility.GetCurrentRealTime() - RTstart)
		RegisterForSingleUpdate(MCMValue.UpdateTicker)
		return
	elseif MCMValue.MCMclose
		resetAlterations()
		utility.wait(2)

		BodyMorph()
		NiOverride.UpdateModelWeight(dba_player)
		BodyTransform()

		MCMValue.MCMclose = false
		if MCMValue.debuglogenabled
			Debug.trace("DBA: MCM settings changed.")
		endif
	endif

	GTcurrent = Utility.GetCurrentGameTime()
	GTpassedActual = GTcurrent - GTlastupdate
	GTpassed = GTpassedActual * MCMValue.speed

	if MCMValue.eyeEnabled
		checkEye()
	endif
	if MCMValue.mouthEnabled
		checkMouth()
	endif
	if MCMValue.neckEnabled
		checkNeck()
	endif
	if MCMValue.armEnabled
		checkArm()
	endif
	if MCMValue.handEnabled
		checkHand()
	endif
	if MCMValue.breastEnabled
		checkBreast()
	endif
	if MCMValue.waistEnabled
		checkWaist()
	endif
	if MCMValue.buttEnabled
		checkButt()
	endif
	if MCMValue.anusEnabled
		checkAnus()
	endif
	if MCMValue.vaginaEnabled
		checkVagina()
	endif
	if MCMValue.legEnabled
		checkLeg()
	endif
	if MCMValue.footEnabled
		checkFoot()
	endif
	if MCMValue.weight
		checkWeight()
	endif
	if MCMValue.walkingspeed
		CheckWalkingStatus()
	endif

	if NextUpdate < GTcurrent
		if !libs.IsAnimating(dba_player) && isIdle()
			BodyMorph()
			NiOverride.UpdateModelWeight(dba_player)

			if dba_player.GetAnimationVariableBool("IsFirstPerson")
				BodyTransform()
			endif
			
			if (MCMValue.comment)
				randomComment()
			endif
			NextUpdate = GTcurrent + (MCMValue.morphtimer / 24)
		endif
	endif

	if MCMValue.debuglogenabled
		Debug.trace("DBA: GTcurrent= " + GTcurrent + " ; GTlastupdate= " + GTlastupdate + " ; NextUpdate= " + NextUpdate + " ; IdleStatus= " + isIdle())
	endif
	GTlastupdate = GTcurrent
	;Debug.Notification(Utility.GetCurrentRealTime() - RTstart)
	RegisterForSingleUpdate(MCMValue.UpdateTicker)
endEvent

;################################################################################################################################################################
;---------------------------------------------------------------------- Training section ------------------------------------------------------------------------
;-------------------------------------- eyes, mouth and feet alterations get applied here as they are more time sensitive ---------------------------------------
;################################################################################################################################################################

function checkEye()
	int status = 0
	if dba_player.WornHasKeyword(dditem[16])
		status = 1 ; control opening
	endif

	if status == 0 && eyetime > 0
		if MCMValue.eyerecover > 0
			eyetime -= GTpassed  * 14.29 * MCMValue.eyerecover ; eyetime multiplied by 14.29 is approx 7 days from 0 to 100

			float eyetimeLimit = eyetimeMax * MCMvalue.eyeRecoveryLimit
			if eyetime < eyetimeLimit
				eyetime = eyetimeLimit
			endif
		endif

		if MCMvalue.eye > 0 ; alteration enabled, not wearing blindfold, alteration strength > 0
			float squint = (eyetime * MCMValue.eye / 10000)	; slider setting multiplied with internal expressionmodifier Value is maxed at 10000
			if (MCMValue.eyeAlt)
				dba_player.setExpressionModifier(0, squint)
				dba_player.setExpressionModifier(1, squint)
			endif
			dba_player.setExpressionModifier(2, squint)
			dba_player.setExpressionModifier(3, squint)
			dba_player.setExpressionModifier(6, squint)
			dba_player.setExpressionModifier(7, squint)
			dba_player.setExpressionModifier(12, squint)
			dba_player.setExpressionModifier(13, squint)
		endif
	elseif status == 1
		if eyetime < 100
			eyetime += GTpassed * 14.29

			if eyetime > 100
				eyetime = 100
			endif
			if eyetime > eyetimeMax
				eyetimeMax = eyetime
			endif
		endif
		;	zadConfigHandle.bootsSlowdownToggle = false				; <-------- an option
		;	zadConfigHandle.blindfoldMode = 2
		if MCMValue.DDBlindfoldStrengthAdjustmentEnabled
			zadConfigHandle.blindfoldStrength = MCMValue.DDBlindfoldStrengthBase - MCMValue.DDBlindfoldStrengthRatio * eyetime
			zadConfigHandle.darkfogStrength = (MCMValue.DDDarkfogStrengthBase - MCMValue.DDDarkfogStrengthRatio * eyetime) as int
		endif
	endif

	if MCMValue.debuglogenabled
		Debug.trace("DBA: Eye Expression set. Eyetime= " + eyetime + "; eyeAlt= " + MCMValue.eyeAlt)
	endif
endFunction

function checkMouth()
	int status = 0
	if dba_player.WornHasKeyword(dditem[5])
		status = 1 ; control opening
	endif

	if status == 0 && mouthtime > 0
		if MCMValue.mouthrecover > 0
			mouthtime -= GTpassed * 14.29 * MCMValue.mouthrecover

			float mouthtimeLimit = mouthtimeMax * MCMvalue.mouthRecoveryLimit
			if mouthtime < mouthtimeLimit
				mouthtime = mouthtimeLimit
			endif
		endif

		if MCMValue.mouth > 0 ; we don´t want facial expression change while wearing a gag
			float opening = (mouthtime * MCMValue.mouth / 100) ; slider setting multiplied with internal phonememodifier Value is maxed at 100
			setPhonemeModifier(dba_player, 0, 1, opening as int)
			setPhonemeModifier(dba_player, 0, 11, (opening * 0.7) as int) ; using factor 0.7 to prevent it looking weired... more weired as it is
		endif
	elseif status == 1
		if mouthtime < 100
			mouthtime += GTpassed * 14.29 ; mouthtime multiplied by 14.29 is approx 7 days from 0 to 100

			if mouthtime > 100
				mouthtime = 100
			endif
			if mouthtime > mouthtimeMax
				mouthtimeMax = mouthtime
			endif
		endif

		if MCMValue.DDGagTrainingEnabled && mouthtime >= MCMValue.DDGagProficiencyThreshold
			zadGagHandle.canTalk = true
		endif
	endif

	if MCMValue.debuglogenabled
		Debug.trace("DBA: Mouth Opening set. Mouthtime= " + mouthtime)
	endif
endFunction

function checkNeck()
	int status = 0
	if dba_player.WornHasKeyword(dditem[6])
		status = 1 ; adjust length
	endif

	if status == 0 && MCMValue.neckrecover > 0 && necktime > 0
		necktime -= GTpassed * 3.57 * MCMValue.neckrecover
		
		float necktimeLimit = necktimeMax * MCMvalue.mouthRecoveryLimit
		if necktime < necktimeLimit
			necktime = necktimeLimit
		endif
	elseif necktime < 100; && status == 1
		necktime += GTpassed * 3.57 ; Necktime multiplied by 3.57 is approx 28 days from 0 to 100

		if necktime > 100
			necktime = 100
		endif
		if necktime > necktimeMax
			necktimeMax = necktime
		endif
	endif
endFunction

function checkArm()
	int status = 0
	if dba_player.WornHasKeyword(dditem[4]) || dba_player.WornHasKeyword(dditem[14]) || dba_player.WornHasKeyword(dditem[15]) || dba_player.WornHasKeyword(dditem[17]) || dba_player.WornHasKeyword(dditem[19])
		status = 1 ; adjust muscle / arm thickness
	endif

	if status == 0 && MCMValue.armrecover > 0 && armtime > 0
		armtime -= GTpassed * 4.76 * MCMValue.armrecover

		float armtimeLimit = armtimeMax * MCMvalue.armRecoveryLimit
		if armtime < armtimeLimit
			armtime = armtimeLimit
		endif	
	elseif armtime < 100; && status == 1
		armtime += GTpassed * 4.76 ; armtime multiplied by 4.76 is approx 21 days from 0 to 100

		if armtime > 100
			armtime = 100
		endif
		if armtime > armtimeMax
			armtimeMax = armtime
		endif
	endif
endFunction

function checkHand()
	int status = 0
	if dba_player.WornHasKeyword(dditem[9])
		status = 1 ; adjust ability
	endif

	if status == 0 && MCMValue.handrecover > 0 && handtime > 0
		handtime -= GTpassed * 4.76 * MCMValue.handrecover

		float handtimeLimit = handtimeMax * MCMvalue.handRecoveryLimit
		if handtime < handtimeLimit
			handtime = handtimeLimit
		endif
	elseif handtime < 100; && status == 1
		handtime += GTpassed * 4.76 ; handtime multiplied by 4.76 is approx 21 days from 0 to 100

		if handtime > 100
			handtime = 100
		endif
		if handtime > handtimeMax
			handtimeMax = handtime
		endif
	endif
endFunction

function checkBreast()
	int status = 0
	if dba_player.WornHasKeyword(dditem[12])
		status = 1 ; slow growing boobs
	elseif dba_player.WornHasKeyword(dditem[2]); || dba_player.WornHasKeyword(dditem[12])
		status = 2 ; growing boobs
	elseif dba_player.WornHasKeyword(dditem[8])
		status = 3 ; fast growing boobs
	endif

	if status == 0 && MCMValue.breastrecover > 0 && breasttime > 0
		breasttime -= GTpassed * 3.57 * MCMValue.breastrecover

		float breasttimeLimit = breasttimeMax * MCMvalue.breastRecoveryLimit
		if breasttime < breasttimeLimit
			breasttime = breasttimeLimit
		endif
	elseif breasttime < 100
		if status == 1
			breasttime += GTpassed * 3.57 * 0.5
		elseif status == 1
			breasttime += GTpassed * 3.57 ; breasttime multiplied by 3.57 is approx 28 days from 0 to 100
		elseif status == 2
			breasttime += GTpassed * 3.57 * 1.5
		endif

		if breasttime > 100
			breasttime = 100
		endif
		if breasttime > breasttimeMax
			breasttimeMax = breasttime
		endif
	endif
endFunction

function checkWaist()
	int status = 0
	if dba_player.WornHasKeyword(dditem[1]) && (dba_player.WornHasKeyword(dditem[18]) || dba_player.WornHasKeyword(dditem[20]) || dba_player.WornHasKeyword(dditem[21]))
		status = 3 ; fast shrinking waist
	elseif dba_player.WornHasKeyword(dditem[1])
		status = 2 ; shrinking waist
	elseif dba_player.WornHasKeyword(dditem[18]) || dba_player.WornHasKeyword(dditem[20]) || dba_player.WornHasKeyword(dditem[21])
		status = 1 ; slow shrinking waist
	endif

	if status == 0 && MCMValue.waistrecover > 0 && waisttime > 0
		waisttime -= GTpassed * 3.57 * MCMValue.waistrecover

		float waisttimeLimit = waisttimeMax * MCMvalue.waistRecoveryLimit
		if waisttime < waisttimeLimit
			waisttime = waisttimeLimit
		endif
	elseif waisttime < 100
		if status == 1 && waisttime < 66.66 ; only with corset it is possible to shrink the waist completly
			waisttime += GTpassed * 3.57 * 0.75
		elseif status == 2
			waisttime += GTpassed * 3.57 ; waisttime multiplied by 3.57 is approx 28 days from 0 to 100
		elseif status == 3
			waisttime += GTpassed * 3.57 * 1.5
		endif

		if waisttime > 100
			waisttime = 100
		endif
		if waisttime > waisttimeMax
			waisttimeMax = waisttime
		endif
	endif
endFunction

function checkButt()
	int status = 0
	if dba_player.WornHasKeyword(dditem[2]) || dba_player.WornHasKeyword(dditem[7])
		status = 1 ; growing butt
	endif

	if status == 0 && MCMValue.buttrecover > 0 && butttime > 0
		butttime -= GTpassed * 4.76	* MCMValue.buttrecover ; butttime multiplied by 4.76 is approx 21 days from 0 to 100

		float butttimeLimit = butttimeMax * MCMvalue.buttRecoveryLimit
		if butttime < butttimeLimit
			butttime = butttimeLimit
		endif
	elseif butttime < 100; && status == 1
		butttime += GTpassed * 4.76
		
		if butttime > 100
			butttime = 100
		endif
		if butttime > butttimeMax
			butttimeMax = butttime
		endif
	endif
endFunction

function checkAnus()
	int status = 0
	if dba_player.WornHasKeyword(dditem[11])
		status = 1 ; anus widening
	endif

	if status == 0 && MCMValue.anusrecover > 0 && anustime > 0
		anustime -= GTpassed * 4.76 * MCMValue.anusrecover

		float anustimeLimit = anustimeMax * MCMvalue.anusRecoveryLimit
		if anustime < anustimeLimit
			anustime = anustimeLimit
		endif
	elseif anustime < 100; && status == 1
		anustime += GTpassed * 4.76 ; anustime multiplied by 4.76 is approx 21 days from 0 to 100

		if anustime > 100
			anustime = 100
		endif
		if anustime > anustimeMax
			anustimeMax = anustime
		endif
	endif
endFunction

function checkVagina()
	int status = 0
	if dba_player.WornHasKeyword(dditem[13])
		status = 1
	elseif dba_player.WornHasKeyword(dditem[10]); && dba_player.WornHasKeyword(dditem[13]) ; ????????????????????
		status = 2 ; vagina widening
	endif

	if status == 0 && vaginatime > 0
		if MCMValue.vaginarecover > 0
			vaginatime -= GTpassed * 7.14 * MCMValue.vaginarecover ; vaginatime multiplied by 7.14 is approx 14 days from 0 to 100

			float vaginatimeLimit = vaginatimeMax * MCMvalue.vaginaRecoveryLimit
			if vaginatime < vaginatimeLimit
				vaginatime = vaginatimeLimit
			endif
		endif

		int handle = ModEvent.Create("slaUpdateExposure")
		ModEvent.PushForm(handle, dba_player)
		ModEvent.PushFloat(handle, GTpassedActual * vaginatime)
		ModEvent.Send(handle)
	elseif vaginatime < 100
		if status == 1 && vaginatime < 50
			vaginatime += GTpassed * 7.14 * 0.5
		elseif status == 2
			vaginatime += GTpassed * 7.14
		endif

		if vaginatime > 100
			vaginatime = 100
		endif
		if vaginatime > vaginatimeMax
			vaginatimeMax = vaginatime
		endif
	endif
endFunction

function checkLeg()
	int status = 0
	if dba_player.WornHasKeyword(dditem[3]) || dba_player.WornHasKeyword(dditem[0]) || (dba_player.WornHasKeyword(dditem[20]) && !dba_player.WornHasKeyword(dditem[21]))
		status = 1	; leg muscle loss
	endif

	if status == 0 && MCMValue.legrecover > 0 && legtime > 0
		legtime -= GTpassed * 4.76 * MCMValue.legrecover ; legtime multiplied by 4.76 is approx 21 days from 0 to 100

		float legtimeLimit = legtimeMax * MCMvalue.legRecoveryLimit
		if legtime < legtimeLimit
			legtime = legtimeLimit
		endif
	elseif legtime < 100; && status == 1
		legtime += GTpassed * 4.76

		if legtime > 100
			legtime = 100
		endif
		if legtime > legtimeMax
			legtimeMax > legtime
		endif
	endif
endFunction

function checkFoot()
	bool isFemale = dba_player.GetLeveledActorBase().GetSex()
	int status = 0

	if dba_player.WornHasKeyword(dditem[0])
		status = 1 ; Altered feet ; if I find a free desgin bared bondage feet UUNP
	elseif NiOverride.HasNodeTransformPosition(dba_player, False, isFemale, "NPC", "internal") && (dba_player.getWornForm(Slot37) != AlteredFeet || dba_player.getWornForm(Slot37) != CinderellaFeetItem)
		status = 2 ; Altered feet
	endif

	if status == 0
		if MCMValue.footrecover > 0 && foottime > 0
			foottime -= GTpassed * 3.57 * MCMValue.footrecover ; foottime multiplied by 3.57 is approx 28 days from 0 to 100

			float foottimeLimit = foottimeMax * MCMvalue.footRecoveryLimit
			if foottime < foottimeLimit
				foottime = foottimeLimit
			endif
		endif

		if foottime >= 75
			if isFemale && !MCMvalue.yps && dba_player.getWornForm(Slot37) != AlteredFeet
				dba_player.unequipItemSlot(37)
				Debug.Notification("You can only walk on your tippy toes or high heels with your altered feet.")
				dba_player.equipitem(AlteredFeet, false, true)
			endif
		endif
	elseif (status == 1 && foottime < 100) || (status == 2 && foottime < 80) ; High Heels will damage your Achilles
		foottime += GTpassed * 3.57 ; Devious boots will lead to extreme shortend Achilles

		if foottime > 100
			foottime = 100
		endif
		if foottime > foottimeMax
			foottimeMax = foottime
		endif
	endif

	if MCMValue.debuglogenabled
		Debug.trace("DBA: Foot adjustment done. Foottime= " + foottime)
	endif
endFunction

function checkWeight()
	int status = 0
	if dba_player.WornHasKeyword(dditem[1]) || dba_player.WornHasKeyword(dditem[22])
		status = 1
	endif

	if status == 0 && weighttime < 100 ; status 0 assuming you will eat to replenisch lost weight. TODO: find a good solution to use food in game.
		weighttime += GTpassed * 0.5 ; slow weight increase

		if weighttime > 100.0
			weighttime = 100.0
		endif
	elseif status == 1 && weighttime > 0
		weighttime -= GTpassed * 2.0 ; multiplied by 2.0 is 50 days from 100 to 0

		if weighttime < 0.0
			weighttime = 0.0
		endif
	endif
endFunction

function CheckWalkingStatus()
	; this will modify the speedmult value and not change the base of 100
	bool isFemale = dba_player.GetLeveledActorBase().GetSex()
	float status = MCMValue.maxspeedmult
	float currentspeedmod = speedmod
	float currentspeedmult = dba_player.getAV("Speedmult")
	float speedmodother = MCMValue.maxspeedmult - currentspeedmult - currentspeedmod

	if dba_player.wornhasKeyword(DDitem[0])
		status -= MCMValue.maxspeedmult - foottime * MCMValue.heeldebuff * 0.65
	elseif NiOverride.HasNodeTransformPosition(dba_player, false, isFemale, "NPC", "internal") && (dba_player.getWornForm(Slot37) != AlteredFeet || dba_player.getWornForm(Slot37) != CinderellaFeetItem)
		status -= MCMValue.maxspeedmult - foottime * MCMValue.heeldebuff * 0.9
	endif

	if !dba_player.wornhasKeyword(DDitem[0]) && !NiOverride.HasNodeTransformPosition(dba_player, false, isFemale, "NPC", "internal") || (dba_player.getWornForm(Slot37) == AlteredFeet || dba_player.getWornForm(Slot37) == CinderellaFeetItem)
		status -= (foottime * MCMValue.heeldebuff + legtime * MCMValue.legdebuff) * 0.4 ; opposite calculation, because the PC does wear nothing. Goal: 80% speeddamage having both trained.
	endif

	if dba_player.wornhasKeyword(DDitem[20]) && !dba_player.wornhasKeyword(DDitem[21])
		status -= MCMValue.maxspeedmult - (legtime + foottime) / 2 * MCMValue.legdebuff * 0.7 ; because of hobbleskirt nature the NiNodetransform will always apply, too.
	endif

	if dba_player.wornhasKeyword(DDitem[21])
		status -= MCMValue.maxspeedmult - (legtime + foottime) / 2 * MCMValue.legdebuff * 0.85 ; because of hobbleskirt nature the NiNodetransform will always apply, too.
	endif

	if dba_player.wornhasKeyword(DDitem[23])
		status -= MCMValue.maxspeedmult - (legtime + foottime) / 2 * MCMValue.legdebuff * 0.6
	endif

	if status > MCMValue.maxspeedmult ; to prevent the speed from getting higher and higher
		status = MCMValue.maxspeedmult
	elseif status < MCMValue.minspeedmult ; to prevent the character from getting stuck
		status = MCMValue.minspeedmult
	endif

	if currentspeedmult as int != status as int
		speedmod = MCMValue.maxspeedmult - status - speedmodother
		if speedmod < 0
			speedmod = 0
		endif

		dba_Player.restoreActorValue("SpeedMult", currentspeedmod as int)
		dba_Player.damageActorValue("SpeedMult", speedmod as int)
		dba_Player.damageActorValue("Carryweight", 0.02) ; this will hopefully act as a ping to the game to change the speed
		dba_Player.restoreActorValue("Carryweight", 0.02)
	endif
endFunction

;################################################################################################################################################################
;-------------------------------------------------------------------- Morphs and Transforms ---------------------------------------------------------------------
;################################################################################################################################################################

function BodyMorph()
;#####Armsection#####
	if MCMvalue.armEnabled && MCMvalue.arm > 0
		float arm = (armtime * MCMValue.arm / 10000) ; slider muliplied by factionrank is maxed at 10000
		SetMorphValue(dba_Player, arm, "Arms")
		setMorphValue(dba_Player, arm * 0.75, "ShoulderSmooth")
		setMorphValue(dba_player, -arm * 0.75, "ShoulderWidth")

		if MCMValue.debuglogenabled
			Debug.trace("DBA: Arm morph set. Armtime= " + armtime)
		endif
	endif
	
;#####Handsection#####
	if MCMValue.debuglogenabled
		Debug.trace("DBA: Hand adjustment does not exist, yet...")
	endif

;#####Breastsection#####
	if MCMvalue.breastEnabled && MCMvalue.breast > 0
		float breast = (breasttime * MCMValue.breast / 10000) ; slider muliplied by factionrank is maxed at 10000
		setMorphValue(dba_Player, breast, "BreastsFantasy")
		setMorphValue(dba_player, -breast, "BreastsSmall")
		setMorphValue(dba_player, breast * 0.25, "BreastPerkiness")
		setMorphValue(dba_player, breast * 0.5, "NippleLength")

		if MCMValue.debuglogenabled
			Debug.trace("DBA: Breast morph set. Breasttime= " + breasttime)
		endif
	endif

	if MCMValue.mme
		float MilkCnt = MME_Storage.getMilkCurrent(dba_player)
		int BreastRows = MME_Storage.getBreastRows(dba_player)
		float MMEbreast = MilkCnt / BreastRows / 10

		if MMEbreast > MCMvalue.mmebreastmax
			MMEbreast = MCMValue.mmebreastmax
		endif

		setMorphValue(dba_Player, MMEbreast * 0.75, "BreastsSSH")
		setMorphValue(dba_Player, MMEbreast, "DoubleMelon")

		if MCMValue.debuglogenabled
			Debug.trace("DBA: MME Breast morph set. MMEbreast= " + MMEbreast)
		endif
	endif

;#####Waistsection#####
	if MCMvalue.waistEnabled && MCMvalue.waist > 0
		float waist = (waisttime * MCMValue.waist / 10000) ; slider muliplied by factionrank is maxed at 10000
		setMorphValue(dba_player, waist / 2, "Waist")
		setMorphValue(dba_Player, -waist * 0.75, "WideWaistLine")
		setMorphValue(dba_Player, -waist * 0.75, "ChubbyWaist")
		setMorphValue(dba_Player, -waist, "Back")
		setMorphValue(dba_Player, -waist / 2, "BigBelly")

		if MCMValue.debuglogenabled
			Debug.trace("DBA: Waist morph set. Waisttime= " + waisttime)
		endif
	endif

;#####Buttsection#####
	if MCMvalue.buttEnabled && MCMvalue.butt > 0
		float butt = (butttime * MCMValue.butt / 10000) ; slider muliplied by factionrank is maxed at 10000
		setMorphValue(dba_player, butt, "BigButt")
		setMorphValue(dba_Player, butt, "AppleCheeks")

		if MCMValue.debuglogenabled
			Debug.trace("DBA: Butt morph set. Butttime= " + butttime)
		endif
	endif

;#####Anussection#####
	if MCMvalue.anusEnabled && MCMvalue.anus > 0
		float anus = (anustime * MCMValue.anus / 10000) ; slider muliplied by factionrank is maxed at 10000
		setMorphValue(dba_player, anus, "AnusSpread")

		if MCMValue.debuglogenabled
			Debug.trace("DBA: Anus adjustment done. Anustime= " + anustime)
		endif
	endif

;#####Legsection#####
	if MCMvalue.legEnabled && MCMvalue.leg > 0
		float leg = (legtime * MCMValue.leg / 10000) ; slider muliplied by factionrank is maxed at 10000
		setMorphValue(dba_Player, leg, "KneeHeight")
		setMorphValue(dba_Player, leg, "CalfSize")

		if MCMValue.debuglogenabled
			Debug.trace("DBA: Leg morph set. Legtime= " + legtime)
		endif
	endif

;#####Weightsection#####
	if MCMValue.weight
		if (!dba_player.isOnMount() || !dba_player.isSwimming())
			float neckdelta = (weightcalc / 100) - (weighttime / 100)
			dba_player.getActorBase().setWeight(weighttime)
			dba_player.updateWeight(neckdelta)		
			dba_player.QueueNiNodeUpdate()
			weightcalc = weighttime

			if MCMValue.debuglogenabled
				Debug.trace("DBA: Weight Alteration done. Weightvariable= " + weighttime + " ; weightcalc= " + weightcalc)
			endif
		endif
	endif

	if MCMValue.debuglogenabled
		Debug.trace("DBA: Morphupdate done.")
	endif
endFunction

function BodyTransform()
;#####Necksection#####
	if MCMvalue.neckEnabled && MCMvalue.neck > 0
		float head = 1 / (1 + (necktime * MCMValue.neck / 10000)) ; slider muliplied by factionrank is maxed at 10000
		float neck = 1 + (necktime * MCMValue.neck / 10000) ; slider muliplied by factionrank is maxed at 10000

		AddNodeTransformScale(dba_player, false, true, "NPC Head [Head]", head)
		AddNodeTransformScale(dba_player, false, true, "NPC Neck [Neck]", neck)

		if MCMValue.debuglogenabled
			Debug.trace("DBA: Neck transformation set. Necktime= " + necktime)
		endif
	endif

;#####Vaginasection#####
	if MCMvalue.vaginaEnabled && MCMvalue.vagina > 0
		float vagina = 1 / (1 + (vaginatime * MCMValue.vagina / 10000)) ; slider muliplied by factionrank is maxed at 10000
		AddNodeTransformScale(dba_player, false, true, "NPC L Pussy02", vagina)
		AddNodeTransformScale(dba_player, false, true, "NPC R Pussy02", vagina)

		if MCMValue.debuglogenabled
			Debug.trace("DBA: Vagina transformation set. Vaginatime= " + vaginatime)
		endif
	endif

;#####Waistaltsection#####
	if MCMValue.waistalt && MCMvalue.waistEnabled && MCMValue.waist > 0
		float spn1 = 1 / (1 + (waisttime * MCMValue.waist / 10000)) ; slider muliplied by factionrank is maxed at 10000
		float spn2 = 1 + (waisttime * MCMValue.waist / 10000) ; slider muliplied by factionrank is maxed at 10000
		float spn3 = waisttime * MCMValue.waist / 10000

		AddNodeTransformScale(dba_player, false, true, "NPC Spine1 [Spn1]", spn1)
		AddNodeTransformScale(dba_player, false, true, "NPC Spine2 [Spn2]", spn2)

		setMorphValue(dba_player, spn3 / 2 , "Breasts")
		setMorphValue(dba_player, spn3 , "BreastHeight")
		
		if MCMValue.debuglogenabled
			Debug.trace("DBA: Waistalternative transformation set.")
		endif
	endif

	if MCMValue.debuglogenabled
		Debug.trace("DBA: Transformupdate done.")
	endif
endFunction

;################################################################################################################################################################
;----------------------------------------------------------------------- Utility section ------------------------------------------------------------------------
;################################################################################################################################################################

function AddNodeTransformScale(Actor akActor, bool firstPerson, bool isFemale, string nodeName, float scale)
	if MCMValue.SLIF
		if scale != 0.0
			SLIF_Main.inflate(akActor, "Devious Body Alteration", nodeName, scale, -1, -1, "DBA")
		else
			SLIF_Main.unregisterNode(akActor, "Devious Body Alteration", nodeName)
		endif
	else
		if scale != 0.0 
			NiOverride.AddNodeTransformScale(akActor, firstPerson, isFemale, nodeName, "DBA", scale)
			NiOverride.UpdateNodeTransform(akActor, firstPerson, isFemale, nodeName)
		else
			NiOverride.RemoveNodeTransformScale(akActor, firstPerson, isFemale, nodeName, "DBA")
			NiOverride.UpdateNodeTransform(akActor, firstPerson, isFemale, nodeName)
		endif
	endif
endFunction

function setMorphValue(Actor akActor, float value, string morphName)
	if MCMValue.SLIF
		if value != 0.0
			SLIF_Morph.morph(akActor, "Devious Body Alteration", morphName, value, "DBA")
		else
			SLIF_Morph.unregisterMorph(akActor, morphName, "Devious Body Alteration") ; clear morph by toggle or disable mod implementation not done yet
		endif
	else
		if value != 0.0
			NiOverride.SetBodyMorph(akActor, morphName, "DBA", value)
		else		
			NiOverride.ClearBodyMorph(akActor, morphName, "DBA") ; clear morph by toggle or disable mod implementation not done yet
		endif
	endif
endFunction

bool function isIdle()
 	if dba_player.isInCombat() || dba_player.isRunning() || dba_player.isSprinting() || dba_player.isSneaking() || dba_player.isSwimming() || dba_player.isOnMount() || dba_player.isFlying()
		return false
	endif
	return true
endFunction

;################################################################################################################################################################
;------------------------------------------------------------------------ Reset section -------------------------------------------------------------------------
;################################################################################################################################################################

function resetAlterations(bool checkQueue = true)
	resetEyesAlteration(checkQueue)
	resetMouthAlteration(checkQueue)
	resetNeckAlteration(checkQueue)
	resetArmsAlteration(checkQueue)
	;resetHandsAlteration(checkQueue)
	resetBreastsAlteration(checkQueue)
	resetWaistAlteration(checkQueue)
	resetButtAlteration(checkQueue)
	resetAnusAlteration(checkQueue)
	resetVaginaAlteration(checkQueue)
	resetLegsAlteration(checkQueue)
	resetLegsAlteration(checkQueue)
	resetFeetAlteration(checkQueue)
	resetMovementSpeed(checkQueue)
endFunction

function resetEyesAlteration(bool checkQueue = true)
	if checkQueue && !MCMValue.eyesResetQueued
		return
	endif

	dba_player.setExpressionModifier(0, 0.0)
	dba_player.setExpressionModifier(1, 0.0)
	dba_player.SetExpressionModifier(2, 0.0)
	dba_player.SetExpressionModifier(3, 0.0)
	dba_player.SetExpressionModifier(6, 0.0)
	dba_player.SetExpressionModifier(7, 0.0)
	dba_player.SetExpressionModifier(12, 0.0)
	dba_player.SetExpressionModifier(13, 0.0)

	MCMValue.eyesResetQueued = false
endfunction

function resetMouthAlteration(bool checkQueue = true)
	if checkQueue && !MCMValue.mouthResetQueued
		return
	endif
	
	SetPhonemeModifier(dba_player, 0, 1, 0)
	SetPhonemeModifier(dba_player, 0, 11, 0)

	MCMValue.mouthResetQueued = false
endfunction

function resetNeckAlteration(bool checkQueue = true)
	if checkQueue && !MCMValue.neckResetQueued
		return
	endif
	
	AddNodeTransformScale(dba_player,false, true, "NPC Head [Head]", 1.0)
	AddNodeTransformScale(dba_player,false, true, "NPC Neck [Neck]", 1.0)

	MCMValue.neckResetQueued = false
endfunction

function resetArmsAlteration(bool checkQueue = true)
	if checkQueue && !MCMValue.armsResetQueued
		return
	endif

	SetMorphValue(dba_Player, 0.0, "Arms")
	setMorphValue(dba_Player, 0.0, "ShoulderSmooth")
	setMorphValue(dba_player, 0.0, "ShoulderWidth")

	MCMValue.armsResetQueued = false
endfunction

;function resetHandsAlteration(bool checkQueue = true)
;	if checkQueue && !MCMValue.handsResetQueued
;		return
;	endif
;
;	MCMValue.handsResetQueued = false
;endfunction

function resetBreastsAlteration(bool checkQueue = true)
	if checkQueue && !MCMValue.breastsResetQueued
		return
	endif

	setMorphValue(dba_Player, 0.0, "BreastsFantasy")
	setMorphValue(dba_player, 0.0, "BreastsSmall")
	setMorphValue(dba_player, 0.0, "BreastPerkiness")
	setMorphValue(dba_player, 0.0, "NippleLength")

	setMorphValue(dba_Player, 0.0, "BreastsSSH")
	setMorphValue(dba_Player, 0.0, "DoubleMelon")

	MCMValue.breastsResetQueued = false
endfunction

function resetWaistAlteration(bool checkQueue = true)
	if checkQueue && !MCMValue.waistResetQueued
		return
	endif

	setMorphValue(dba_player, 0.0, "Waist")
	setMorphValue(dba_Player, 0.0, "WideWaistLine")
	setMorphValue(dba_Player, 0.0, "ChubbyWaist")
	setMorphValue(dba_Player, 0.0, "Back")
	setMorphValue(dba_Player, 0.0, "BigBelly")

	AddNodeTransformScale(dba_player, false, true, "NPC Spine1 [Spn1]", 1.0)
	AddNodeTransformScale(dba_player, false, true, "NPC Spine2 [Spn2]", 1.0)

	setMorphValue(dba_player, 0.0, "Breasts")
	setMorphValue(dba_player, 0.0, "BreastHeight")

	MCMValue.waistResetQueued = false
endfunction

function resetButtAlteration(bool checkQueue = true)
	if checkQueue && !MCMValue.buttResetQueued
		return
	endif

	setMorphValue(dba_player, 0.0, "BigButt")
	setMorphValue(dba_Player, 0.0, "AppleCheeks")

	MCMValue.buttResetQueued = false
endfunction

function resetAnusAlteration(bool checkQueue = true)
	if checkQueue && !MCMValue.anusResetQueued
		return
	endif

	setMorphValue(dba_player, 0.0, "AnusSpread")

	MCMValue.anusResetQueued = false
endfunction

function resetVaginaAlteration(bool checkQueue = true)
	if checkQueue && !MCMValue.vaginaResetQueued
		return
	endif

	AddNodeTransformScale(dba_player, false, true, "NPC L Pussy02", 1.0)
	AddNodeTransformScale(dba_player, false, true, "NPC R Pussy02", 1.0)

	MCMValue.vaginaResetQueued = false
endfunction

function resetLegsAlteration(bool checkQueue = true)
	if checkQueue && !MCMValue.legsResetQueued
		return
	endif

	setMorphValue(dba_Player, 0.0, "KneeHeight")
	setMorphValue(dba_Player, 0.0, "CalfSize")

	MCMValue.legsResetQueued = false
endfunction

function resetFeetAlteration(bool checkQueue = true)
	if checkQueue && !MCMValue.feetResetQueued
		return
	endif

	if dba_player.getWornForm(Slot37) == AlteredFeet
		dba_player.unequipItemSlot(37)
	endif

	MCMValue.feetResetQueued = false
endfunction

function resetMovementSpeed(bool checkQueue = true)
	if checkQueue && !MCMValue.movSpeedResetQueued
		return
	endif

	dba_player.restoreAV("SpeedMult", speedmod)
	dba_Player.damageActorValue("Carryweight", 0.02)
	dba_Player.restoreActorValue("Carryweight", 0.02)
	
	MCMValue.movSpeedResetQueued = false
endfunction

;################################################################################################################################################################
;----------------------------------------------------------------------- Comment section ------------------------------------------------------------------------
;################################################################################################################################################################

function Bodymeter()
	string statusbox1 = "Your body status:\n\nEyes: (" + eyetime as int +") " + comment(0) + "\nMouth: (" + mouthtime as int + ") " + comment(1) + "\nArms: (" + armtime as int + ") " + comment(3) + "\nHands: (" + handtime as int + ") " + comment(4) + "\nBreasts: (" + breasttime as int + ") " + comment(5) + "\nWaist: (" + waisttime as int + ") " + comment(6) + "\nButt: (" + butttime as int + ") " + comment(7)	
	string statusbox2 = "Your body status:\n\nAnus: (" + anustime as int + ") " + comment(9) + "\nLegs: (" + legtime as int + ") " + comment(10) + "\nFeet: (" + foottime as int + ") " + comment(11) + "\nBodyweight: (" + weighttime as int + ") " + comment(12) + "\nNeck: (" + necktime as int + ") " + comment(2) + "\nVagina: (" + vaginatime as int + ") " + comment(8) + "\nSpeedmult: " + dba_player.getAV("Speedmult") as int
	
	debug.Messagebox(statusbox1)
	debug.Messagebox(statusbox2)
endFunction

function randomComment()
	int r1 = GenerateRandomInt(0, 13)
	int r2 = GenerateRandomInt(0, 13)

	string comment1 = comment(r1)
	if comment1 != "(untrained)"
		debug.notification(comment1)
	endif
	if r1 != r2
		string comment2 = comment(r2)
		if comment2 != "(untrained)"
			debug.notification(comment2)
		endif
	endif
endFunction

string function comment(int bodyPart)
	if bodyPart == 0
		if eyetime < 25
			return "(untrained)"
		elseif eyetime < 50
			return "You´re very cautious because your lack of vision."
		elseif eyetime < 75
			return "With your eyes useless you stumble around."
		elseif eyetime < 90
			return "You almost don´t need your eyes to move around."
		else
			return "Through persisting training you learned to navigate even when blindfolded."
		endif
	elseif bodyPart == 1
		if mouthtime < 25
			return "(untrained)"
		elseif mouthtime < 50
			return "Your mouth seems to stay open on its own accord."
		elseif mouthtime < 75
			return "With your jaw permanently open you cannot eat or drink."
		elseif mouthtime < 90
			return "Your jaw seems to never close again."
		else
			return "Persisting Gag training shaped your mouth to perfection."
		endif
	elseif bodyPart == 2
		if necktime < 25
			return "(untrained)"
		elseif necktime < 50
			return "Your collar training does make your neck sore."
		elseif necktime < 75
			return "Your collar training did change your posture."
		elseif necktime < 90
			return "Your collar training did elongate your sexy neck."
		else
			return "Persisting collar training did shape your delicate sexy posture."
		endif
	elseif bodyPart == 3
		if armtime < 25
			return "(untrained)"
		elseif armtime < 50
			return "Your arms feel weak."
		elseif armtime < 75
			return "Your arm immobilization render them skinny."
		elseif armtime < 90
			return "Your arm immobilization render them dignified."
		else
			return "Persisting arm immobilization made them delicate."
		endif
	elseif bodyPart == 4
		if handtime < 25
			return "(untrained)"
		elseif handtime < 50
			return "Your hands feel considerable tender."
		elseif handtime < 75
			return "Your hands feel unnatural touchy."
		elseif handtime < 90
			return "Your hands seem very sensitive."
		else
			return "Persisting glove usage render your finger delicate and sensitive."
		endif
	elseif bodyPart == 5
		if breasttime < 25
			return "(untrained)"
		elseif breasttime < 50
			return "You have an ample cleavage now."
		elseif breasttime < 75
			return "Your breasts seem swollen."
		elseif breasttime < 90
			return "Your boobs feel heavy and billowy."
		else
			return "Persisting breast stimulus render them tremendous."
		endif
	elseif bodyPart == 6
		if waisttime < 25
			return "(untrained)"
		elseif waisttime < 50
			return "Your waist indicates the shape of hour glass."
		elseif waisttime < 75
			return "Your wasp waist seems unnatural small."
		elseif waisttime < 90
			return "Your slim wasp waist does need corset support."
		else
			return "Persisting waist training bring your hour glass figure to perfection."
		endif
	elseif bodyPart == 7
		if butttime < 25
			return "(untrained)"
		elseif butttime < 50
			return "Your butt does stretch the seams of your cloth."
		elseif butttime < 75
			return "You ponder how your butt does fit in normal clothes."
		elseif butttime < 90
			return "Your big butt wobbles with every step."
		else
			return "Persisting butt stimulus render your bubble butt to perfection."
		endif
	elseif bodyPart == 8
		if vaginatime < 25
			return "(untrained)"
		elseif vaginatime < 50
			return "Your vagina plug usage feels arousing."
		elseif vaginatime < 75
			return "Only filled with a plug you feel complete."
		elseif vaginatime < 90
			return "Filling your pussy with a plug does exceedingly arouse you."
		else
			return "Persisting vaginal plug training render you perpetually wet and open."
		endif
	elseif bodyPart == 9
		if anustime < 25
			return "(untrained)"
		elseif anustime < 50
			return "Your anal plug usage feels unnatural."
		elseif anustime < 75
			return "Your anus is stretched to the limit."
		elseif anustime < 90
			return "Filling your anus with a plug does arouse you."
		else
			return "Persisting anal plug training render you yearn for more."
		endif
	elseif bodyPart == 10
		if legtime < 25
			return "(untrained)"
		elseif legtime < 50
			return "Your legs seem weak."
		elseif legtime < 75
			return "Your leg cuff training render them skinny."
		elseif legtime < 90
			return "Your leg cuff training render them dignified."
		else
			return "Persisting training with cuffs render your legs delicate."
		endif
	elseif bodyPart == 11
		if foottime < 25
			return "(untrained)"
		elseif foottime < 50
			return "Your heel training made your feet sore."
		elseif foottime < 75
			return "Walking on heels feels natural."
		elseif foottime < 90
			return "Your heel training render your gait sexy."
		else
			return "Persisting heel training induce you to walk sexy on your tippy toes."
		endif
	elseif bodyPart == 12
		if weighttime < 25
			return "(untrained)"
		elseif weighttime < 50
			return "Your dainty body responds to training."
		elseif weighttime < 75
			return "Training reshapes your body in all the right places."
		elseif weighttime < 90
			return "Ongoing training enhances your sexy curves."
		else
			return "Persistent training has given you the body of a sex doll."
		endif
	endif
endFunction
