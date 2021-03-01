Scriptname dba_BodyTicker extends Quest Hidden 

dba_MCM property MCMValue Auto
Actor property dba_player Auto
zadlibs property libs Auto

import MfgConsoleFunc
import po3_SKSEFunctions

float GTcurrent = 0.0
float GTlastupdate = 0.0
float GTpassed = 0.0
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

event OnInit()
	utility.wait(5.0) ; wait first, to reduce game save load (and crash chance)

	Debug.trace("DBA: Trying to set variables and update timer.")

	dba_player = Game.Getplayer()
	InitVariables()
	RegisterForSingleUpdate(MCMValue.UpdateTicker)
	
	Debug.trace("DBA: Variables and update timer are set.")	
endEvent

event OnUpdate()
	if !MCMValue.modenabled
		if MCMValue.MCMclose
			resetAlterations(false)
			NiOverride.UpdateModelWeight(dba_player)
			
			MCMValue.MCMclose = false
		endif

		if MCMValue.debuglogenabled
			Debug.trace("DBA: Mod disabled.")
		endif
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

	float RTstart = Utility.GetCurrentRealTime()
	GTcurrent = Utility.GetCurrentGameTime()
	GTpassed = (GTcurrent - GTlastupdate) * MCMValue.speed

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
		if !libs.IsAnimating(dba_player) && !isIdle()
			BodyMorph()
			NiOverride.UpdateModelWeight(dba_player)
			if MCMValue.debuglogenabled
				Debug.trace("DBA: Morphupdate done.")
			endif

			if dba_player.GetAnimationVariableBool("IsFirstPerson")
				BodyTransform()
				if MCMValue.debuglogenabled
					Debug.trace("DBA: Transformupdate done.")
				endif
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
	Debug.Notification(Utility.GetCurrentRealTime() - RTstart)
	RegisterForSingleUpdate(MCMValue.UpdateTicker)
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
	
	int i
	altstatus = new String[20]
	while i < 13
		altstatus[i] = "(untrained)"
		i += 1
	endwhile

;	altstatus[0] = "(untrained)"	; eye
;	altstatus[1] = "(untrained)"	; mouth
;	altstatus[2] = "(untrained)"	; neck
;	altstatus[3] = "(untrained)"	; arm
;	altstatus[4] = "(untrained)"	; hand
;	altstatus[5] = "(untrained)"	; breast
;	altstatus[6] = "(untrained)"	; waist
;	altstatus[7] = "(untrained)"	; butt
;	altstatus[8] = "(untrained)"	; vagina
;	altstatus[9] = "(untrained)"	; anus
;	altstatus[10] = "(untrained)"	; leg
;	altstatus[11] = "(untrained)"	; feet
;	altstatus[12] = "(untrained)"	; weight
endFunction

bool function isIdle()
	bool status = 0
 	if dba_player.isInCombat()
		status = 1
		return status
	elseif dba_player.isRunning()
		status = 1
		return status
	elseif dba_player.isSprinting()
		status = 1
		return status
	elseif dba_player.isSneaking()
		status = 1
		return status
	elseif dba_player.isSwimming()
		status = 1
		return status
	elseif dba_player.isOnMount()
		status = 1
		return status
	elseif dba_player.isFlying()
		status = 1
		return status
	endif
	return status
endFunction

function checkEye()
	int status = 0
	if dba_player.WornHasKeyword(dditem[16])
		status = 1 ; control opening
	endif

	if status == 0 && MCMValue.eyerecover > 0 && eyetime > 0
		eyetime -= GTpassed  * 14.29 * MCMValue.eyerecover ; eyetime multiplied by 14.29 is approx 7 days from 0 to 100

		float eyetimeLimit = eyetimeMax * MCMvalue.eyeRecoveryLimit
		if eyetime < eyetimeLimit
			eyetime = eyetimeLimit
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
	elseif status == 1 && eyetime < 100
		eyetime += GTpassed * 14.29
		if eyetime > 100
			eyetime = 100
		endif
		if eyetime > eyetimeMax
			eyetimeMax = eyetime
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

	if status == 0 && MCMValue.mouthrecover > 0 && mouthtime > 0
		mouthtime -= GTpassed * 14.29 * MCMValue.mouthrecover

		float mouthtimeLimit = mouthtimeMax * MCMvalue.mouthRecoveryLimit
		if mouthtime < mouthtimeLimit
			mouthtime = mouthtimeLimit
		endif

		if MCMValue.mouth > 0 ; we don´t want facial expression change while wearing a gag
			float opening = (mouthtime * MCMValue.mouth / 100) ; slider setting multiplied with internal phonememodifier Value is maxed at 100
			setPhonemeModifier(dba_player, 0, 1, opening as int)
			setPhonemeModifier(dba_player, 0, 11, (opening * 0.7) as int) ; using factor 0.7 to prevent it looking weired... more weired as it is
		endif
	elseif status == 1 && mouthtime < 100
		mouthtime += GTpassed * 14.29 ; mouthtime multiplied by 14.29 is approx 7 days from 0 to 100

		if mouthtime > 100
			mouthtime = 100
		endif
		if mouthtime > mouthtimeMax
			mouthtimeMax = mouthtime
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
	elseif status == 1 && necktime < 100
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
	elseif status == 1 && armtime < 100
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
	elseif status == 1 && handtime < 100
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
	if dba_player.WornHasKeyword(dditem[2]) || dba_player.WornHasKeyword(dditem[12])
		status = 1 ; growing boobs
	elseif dba_player.WornHasKeyword(dditem[8])
		status = 2 ; fast growing boobs
	endif

	if status == 0 && MCMValue.breastrecover > 0 && breasttime > 0
		breasttime -= GTpassed * 3.57 * MCMValue.breastrecover

		float breasttimeLimit = breasttimeMax * MCMvalue.breastRecoveryLimit
		if breasttime < breasttimeLimit
			breasttime = breasttimeLimit
		endif
	else
		if status == 1 && breasttime < 100
			breasttime += GTpassed * 3.57 ; breasttime multiplied by 3.57 is approx 28 days from 0 to 100
		elseif status == 2 && breasttime < 100
			breasttime += GTpassed * 1.5 * 3.57
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
	else
		if status == 1 && waisttime < 66 ; only with corset it is possible to shrink the waist completly
			waisttime += GTpassed * 0.75 * 3.57
		elseif status == 2 && waisttime < 100
			waisttime += GTpassed * 3.57 ; waisttime multiplied by 3.57 is approx 28 days from 0 to 100
		elseif status == 3 && waisttime < 100
			waisttime += GTpassed * 1.5 * 3.57
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
	elseif status == 1 && butttime < 100
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
	elseif status == 1 && anustime < 100
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
	if dba_player.WornHasKeyword(dditem[10]) && dba_player.WornHasKeyword(dditem[13])
		status = 1 ; vagina widening
	endif

	if status == 0 && MCMValue.vaginarecover > 0 && vaginatime > 0
		vaginatime -= GTpassed * 7.14 * MCMValue.vaginarecover ; vaginatime multiplied by 7.14 is approx 14 days from 0 to 100

		float vaginatimeLimit = vaginatimeMax * MCMvalue.vaginaRecoveryLimit
		if vaginatime < vaginatimeLimit
			vaginatime = vaginatimeLimit
		endif
	elseif status == 1 && vaginatime < 100
		vaginatime += GTpassed * 7.14

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
	elseif status == 1 && legtime < 100
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
			Debug.trace("DBA: Anus adjustment done.")
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
endFunction

function BodyTransform()
	int r = utility.RandomInt(0, 44)
	
	if MCMvalue.neckEnabled && MCMvalue.neck > 0
		float head = 1 / (1 + (necktime * MCMValue.neck / 10000)) ; slider muliplied by factionrank is maxed at 10000
		float neck = 1 + (necktime * MCMValue.neck / 10000) ; slider muliplied by factionrank is maxed at 10000

		AddNodeTransformScale(dba_player, false, true, "NPC Head [Head]", head)
		AddNodeTransformScale(dba_player, false, true, "NPC Neck [Neck]", neck)

		if MCMValue.debuglogenabled
			Debug.trace("DBA: Neck transformation set. Necktime= " + necktime)
		endif
	endif
	
	if MCMvalue.vaginaEnabled && MCMvalue.vagina > 0
		float vagina = 1 / (1 + (vaginatime * MCMValue.vagina / 10000)) ; slider muliplied by factionrank is maxed at 10000
		AddNodeTransformScale(dba_player, false, true, "NPC L Pussy02", vagina)
		AddNodeTransformScale(dba_player, false, true, "NPC R Pussy02", vagina)

		if MCMValue.debuglogenabled
			Debug.trace("DBA: Vagina transformation set. Vaginatime= " + vaginatime)
		endif
	endif

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
endFunction

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

function resetHandsAlteration(bool checkQueue = true)
;	if checkQueue && !MCMValue.handsResetQueued
;		return
;	endif
;
;	MCMValue.handsResetQueued = false
endfunction

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

function Bodymeter()
	Comment()

	string statusbox1 = "Your body status:\n\nEyes: (" + eyetime as int +") " + altstatus[0] + "\nMouth: (" + mouthtime as int + ") " + altstatus[1] + "\nArms: (" + armtime as int + ") " + altstatus[3] + "\nHands: (" + handtime as int + ") " + altstatus[4] + "\nBreasts: (" + breasttime as int + ") " + altstatus[5] + "\nWaist: (" + waisttime as int + ") " + altstatus[6] + "\nButt: (" + butttime as int + ") " + altstatus[7]
	string statusbox2 = "Your body status:\n\nAnus: (" + anustime as int + ") " + altstatus[9] + "\nLegs: (" + legtime as int + ") " + altstatus[10] + "\nFeet: (" + foottime as int + ") " + altstatus[11] + "\nBodyweight: (" + weighttime as int + ") " + altstatus[12] + "\nNeck: (" + necktime as int + ") " + altstatus[2] + "\nVagina: (" + vaginatime as int + ") " + altstatus[8] + "\nSpeedmult: " + dba_player.getAV("Speedmult") as int
	
	debug.Messagebox(statusbox1)
	debug.Messagebox(statusbox2)
endFunction

function randomComment()
	comment()
	int i = 0

	int r1 = GenerateRandomInt(0, 12)
	int r2 = GenerateRandomInt(0, 12)

	while i < 13
		if (r1 == i || r2 == i) && altstatus[i] != "(untrained)"
			debug.notification(altstatus[i])
		endif
		i += 1
	endwhile
endFunction

function Comment()
	if eyetime >= 90
		altstatus[0] = "Persisting Blindfold training render your eyes useless."
	elseif eyetime >= 75
		altstatus[0] = "You almost don´t need your eyes to move around."
	elseif eyetime >= 50
		altstatus[0] = "With your eyes useless you stumble around."
	elseif eyetime >= 25
		altstatus[0] = "You´re very cautious because your lack of vision."
	endif

	if mouthtime >= 90
		altstatus[1] = "Persisting Gag training shaped your mouth to perfection."
	elseif mouthtime >= 75
		altstatus[1] = "Your jaw seems to never close again."
	elseif mouthtime >= 50
		altstatus[1] = "With your jaw permanently open you cannot eat or drink."
	elseif mouthtime >= 25
		altstatus[1] = "Your mouth seems to stay open on its own accord."
	endif

	if necktime >= 90
		altstatus[2] = "Persisting collar training did shape your delicate sexy posture."
	elseif necktime >= 75
		altstatus[2] = "Your collar training did elongate your sexy neck."
	elseif necktime >= 50
		altstatus[2] = "Your collar training did change your posture."
	elseif necktime >= 25
		altstatus[2] = "Your collar training does make your neck sore."
	endif

	if armtime >= 90
		altstatus[3] = "Persisting arm immobilization made them delicate."
	elseif armtime >= 75
		altstatus[3] = "Your arm immobilization render them dignified."
	elseif armtime >= 50
		altstatus[3] = "Your arm immobilization render them skinny."
	elseif armtime >= 25
		altstatus[3] = "Your arms feel weak."
	endif

	if handtime >= 90
		altstatus[4] = "Persisting glove usage render your finger delicate and sensitive."
	elseif handtime >= 75
		altstatus[4] = "Your hands seem very sensitive."
	elseif handtime >= 50
		altstatus[4] = "Your hands feel unnatural touchy."
	elseif handtime >= 25
		altstatus[4] = "Your hands feel considerable tender."
	endif

	if breasttime >= 90
		altstatus[5] = "Persisting breast stimulus render them tremendous."
	elseif breasttime >= 75
		altstatus[5] = "Your boobs feel heavy and billowy."
	elseif breasttime >= 50
		altstatus[5] = "Your breasts seem swollen."
	elseif breasttime >= 25
		altstatus[5] = "You have an ample cleavage now."
	endif

	if waisttime >= 90
		altstatus[6] = "Persisting waist training bring your hour glass figure to perfection."
	elseif waisttime >= 75
		altstatus[6] = "Your slim wasp waist does need corset support."
	elseif waisttime >= 50
		altstatus[6] = "Your wasp waist seems unnatural small."
	elseif waisttime >= 25
		altstatus[6] = "Your waist indicates the shape of hour glass."
	endif

	if butttime >= 90
		altstatus[7] = "Persisting butt stimulus render your bubble butt to perfection."
	elseif butttime >= 75
		altstatus[7] = "Your big butt wobbles with every step."
	elseif butttime >= 50
		altstatus[7] = "You ponder how your butt does fit in normal clothes."
	elseif butttime >= 25
		altstatus[7] = "Your butt does stretch the seams of your cloth."
	endif

	if vaginatime >= 90
		altstatus[8] = "Persisting vaginal plug training render you perpetually wet and open."
	elseif vaginatime >= 75
		altstatus[8] = "Filling your pussy with a plug does exceedingly arouse you."
	elseif vaginatime >= 50
		altstatus[8] = "Only filled with a plug you feel complete."
	elseif vaginatime >= 25
		altstatus[8] = "Your vagina plug usage feels arousing."
	endif

	if anustime >= 90
		altstatus[9] = "Persisting anal plug training render you yearn for more."
	elseif anustime >= 75
		altstatus[9] = "Filling your anus with a plug does arouse you."
	elseif anustime >= 50
		altstatus[9] = "Your anus is stretched to the limit."
	elseif anustime >= 25
		altstatus[9] = "Your anal plug usage feels unnatural."
	endif

	if legtime >= 90
		altstatus[10] = "Persisting training with cuffs render your legs delicate."
	elseif legtime >= 75
		altstatus[10] = "Your leg cuff training render them dignified."
	elseif legtime >= 50
		altstatus[10] = "Your leg cuff training render them skinny."
	elseif legtime >= 25
		altstatus[10] = "Your legs seem weak."
	endif

	if foottime >= 90
		altstatus[11] = "Persisting heel training induce you to walk sexy on your tippy toes."
	elseif foottime >= 75
		altstatus[11] = "Your heel training render your gait sexy."
	elseif foottime >= 50
		altstatus[11] = "Walking on heels feels natural."
	elseif foottime >= 25
		altstatus[11] = "Your heel training made your feet sore."
	endif

	if weighttime >= 90
		altstatus[12] = "Persistent training has given you the body of a sex doll."
	elseif weighttime >= 75
		altstatus[12] = "Ongoing training enhances your sexy curves."
	elseif weighttime >= 50
		altstatus[12] = "Training reshapes your body in all the right places."
	elseif weighttime >= 25
		altstatus[12] = "Your dainty body responds to training."
	endif
endFunction
