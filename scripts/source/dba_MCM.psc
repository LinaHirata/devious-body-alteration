Scriptname dba_MCM extends SKI_ConfigBase

dba_BodyTicker Property BodyTicker Auto
Actor Property dba_player Auto
zadConfig Property zadConfigHandle Auto ; zadConfigQuest [QUST:1501A282]
zadGagQuestScript Property zadGagHandle Auto ; zadGagQuest [QUST:1502B5EF]

;import po3_SKSEFunctions

Faction Property dba_Eye Auto  
Faction Property dba_Mouth Auto  
Faction Property dba_Neck Auto  
Faction Property dba_Arm Auto
Faction Property dba_Hand Auto 
Faction Property dba_Breast Auto  
Faction Property dba_Waist Auto  
Faction Property dba_Butt Auto
Faction Property dba_Anus Auto
Faction Property dba_Vagina	Auto 
Faction Property dba_Leg Auto
Faction Property dba_Foot Auto 
Faction Property dba_Weight Auto

bool property modenabled = false Auto
float property updateticker = 6.66 Auto
float property speed = 1.0 Auto
float property morphtimer = 1.0 Auto

bool property eyeAlt = false Auto
bool property waistalt = false Auto

bool property comment = false Auto
bool property walkingspeed = true Auto
float property maxspeedmult = 100.0 Auto
float property minspeedmult = 25.0 Auto
float property heeldebuff = 1.0 Auto
float property legdebuff = 1.0 Auto

bool property SLIFpresent = false Auto
bool property ypspresent = false Auto
bool property MMEpresent = false Auto

bool property SLIF = false Auto
bool property yps = false Auto
bool property MME = false Auto
float property MMEbreastmax = 4.5 Auto

bool property DDBlindfoldStrengthAdjustmentEnabled = false auto
float property DDBlindfoldStrengthBase = 0.5 auto
float property DDBlindfoldStrengthTarget = 0.0 auto
float property DDDarkfogStrengthBase = 300.0 auto
float property DDDarkfogStrengthTarget = 500.0 auto
float property DDBlindfoldStrengthRatio = 0.005 auto 	; <------- these two values exist just so we dont have to recalculate them every update tick
float property DDDarkfogStrengthRatio = -2.0 auto 		; set when base and target values are changed (in mcm) and are equal '(base - target) / 100'
bool property DDGagTrainingEnabled = false auto
float property DDGagProficiencyThreshold = 80.0 auto

bool property eyeEnabled 	= true Auto
bool property mouthEnabled 	= true Auto
bool property neckEnabled 	= true Auto
bool property armEnabled 	= true Auto
bool property handEnabled 	= true Auto
bool property breastEnabled = true Auto
bool property waistEnabled 	= true Auto
bool property buttEnabled 	= true Auto
bool property anusEnabled 	= true Auto
bool property vaginaEnabled = true Auto
bool property legEnabled 	= true Auto
bool property footEnabled 	= true Auto
bool property weight 		= true Auto

float property eye 		= 75.0 Auto
float property mouth 	= 75.0 Auto
float property neck 	= 25.0 Auto
float property arm 		= 50.0 Auto
float property hand 	= 50.0 Auto
float property breast 	= 50.0 Auto
float property waist 	= 75.0 Auto
float property butt 	= 50.0 Auto
float property anus 	= 50.0 Auto
float property vagina 	= 100.0 Auto
float property leg 		= 50.0 Auto
float property foot 	= 100.0 Auto

float property eyerecover 		= 3.50 Auto
float property mouthrecover 	= 3.50 Auto
float property neckrecover 		= 0.75 Auto
float property armrecover 		= 0.75 Auto
float property handrecover 		= 0.75 Auto
float property breastrecover 	= 1.00 Auto
float property waistrecover 	= 0.50 Auto
float property buttrecover 		= 1.00 Auto
float property anusrecover 		= 0.75 Auto
float property vaginarecover 	= 0.75 Auto
float property legrecover 		= 0.75 Auto
float property footrecover 		= 0.75 Auto

float property eyeRecoveryLimit 	= 0.25 auto
float property mouthRecoveryLimit 	= 0.25 auto
float property neckRecoveryLimit 	= 0.25 auto
float property armRecoveryLimit 	= 0.25 auto
float property handRecoveryLimit 	= 0.25 auto
float property breastRecoveryLimit 	= 0.25 auto
float property waistRecoveryLimit 	= 0.25 auto
float property buttRecoveryLimit 	= 0.25 auto
float property anusRecoveryLimit 	= 0.25 auto
float property vaginaRecoveryLimit 	= 0.25 auto
float property legRecoveryLimit 	= 0.25 auto
float property footRecoveryLimit 	= 0.25 auto

bool property eyesResetQueued = false auto
bool property mouthResetQueued = false auto
bool property neckResetQueued = false auto
bool property armsResetQueued = false auto
;bool property handsResetQueued = false auto
bool property breastsResetQueued = false auto
bool property waistResetQueued = false auto
bool property buttResetQueued = false auto
bool property anusResetQueued = false auto
bool property vaginaResetQueued = false auto
bool property legsResetQueued = false auto
bool property feetResetQueued = false auto
bool property movSpeedResetQueued = false auto
bool property weightUpdateQueued = false auto

bool property debuglogenabled = true Auto
bool property debugenabled = true Auto
bool property MCMclose = false Auto

int modenabledOID
int updatetickerOID
int speedOID
int morphtimerOID

int waistaltOID

int commentOID
int walkingspeedOID
int maxspeedmultOID
int minspeedmultOID
int heeldebuffOID
int legdebuffOID

int slifOID
int ypsOID
int mmeOID
int MMEbreastmaxOID

int eyeOID
int mouthOID
int neckOID
int armOID
int handOID
int breastOID
int waistOID
int buttOID
int anusOID
int vaginaOID
int legOID
int footOID
int weightOID

int eyerecoverOID
int mouthrecoverOID
int neckrecoverOID
int armrecoverOID
int handrecoverOID
int breastrecoverOID
int waistrecoverOID
int buttrecoverOID
int anusrecoverOID
int vaginarecoverOID
int legrecoverOID
int footrecoverOID
int weightrecoverOID

int debuglogenabledOID
int debugenabledOID

;-------------------------------------------------------------------------------------------------

int function GetVersion()
	return 2
endFunction

string function  GetStringVer()
	return "Version 1.3"
endFunction

event OnConfigInit()
	InitPages()
	debug.notification(self + GetStringVer())
	debug.trace(self + GetStringVer())
endEvent

event OnVersionUpdate(int a_version)
	;if (a_version >= 2 && CurrentVersion < 2)
		InitPages()
		debug.notification(self + GetStringVer() + " loaded.")
		debug.trace(self + GetStringVer())
	;endif
endEvent

;--------------------------------------------------------------------------------------------------

function  CheckOptionalMods()	
	if Game.GetModByName("Sexlab Inflation Framework.esp") == 255
		SLIFpresent = false		
	else		
		SLIFpresent = true
	endif
	
	if Game.GetModByName("yps-ImmersivePiercing.esp") == 255
		ypspresent = false		
	else		
		ypspresent = true
	endif
	
	if Game.GetModByName("MilkModNew.esp") == 255
		MMEpresent = false
	else 
		MMEpresent = true
	endif
endFunction

function InitPages()
	CheckOptionalMods()
	dba_player = Game.GetPlayer()
	
	if dba_player.IsInFaction(dba_Eye) != true
		dba_player.AddToFaction(dba_Eye)
	endif
	if dba_player.IsInFaction(dba_Mouth) != true
		dba_player.AddToFaction(dba_Mouth)
	endif
	if dba_player.IsInFaction(dba_Neck) != true
		dba_player.AddToFaction(dba_Neck)
	endif
	if dba_player.IsInFaction(dba_Arm) != true
		dba_player.AddToFaction(dba_Arm)
	endif
	if dba_player.IsInFaction(dba_Hand) != true
		dba_player.AddToFaction(dba_Hand)
	endif
	if dba_player.IsInFaction(dba_Breast) != true
		dba_player.AddToFaction(dba_Breast)
	endif
	if dba_player.IsInFaction(dba_Waist) != true
		dba_player.AddToFaction(dba_Waist)
	endif
	if dba_player.IsInFaction(dba_Butt) != true
		dba_player.AddToFaction(dba_Butt)
	endif
	if dba_player.IsInFaction(dba_Anus) != true
		dba_player.AddToFaction(dba_Anus)
	endif
	if dba_player.IsInFaction(dba_Vagina) != true
		dba_player.AddToFaction(dba_Vagina)
	endif
	if dba_player.IsInFaction(dba_Leg) != true
		dba_player.AddToFaction(dba_Leg)
	endif
	if dba_player.IsInFaction(dba_Foot) != true
		dba_player.AddToFaction(dba_Foot)
	endif
	if dba_player.IsInFaction(dba_Weight) != true
		dba_player.AddToFaction(dba_Weight)
	endif

	Pages = new string[6]
	Pages[0] = "General"
	Pages[1] = "Alteration"
	Pages[2] = "Recovery"
	Pages[3] = "Status"
	Pages[4] = "Debug"
	Pages[5] = "Aux"
endFunction

event OnConfigClose()
	if debugenabled
		Debug.notification("Apply DBA MCM changes.")
	endif
	MCMclose = true
endEvent

event OnPageReset(string page)
	dba_player = Game.GetPlayer()
	CheckOptionalMods()
	SetCursorFillMode(TOP_TO_BOTTOM)
	if (page == "")
		LoadCustomContent("DeviousBodyAlteration/dbaLogo.dds", 156, 3)
		return
	else
		UnloadCustomContent()
	endif
	
	if (page == "General")
		AddHeaderOption("Devious Body Alteration " + GetStringVer())
		modenabledOID 	= AddToggleOption("Mod enabled", modenabled)
		updatetickerOID = AddSliderOption("Update Interval setting", updateticker, "{2}sec")
		speedOID 		= AddSliderOption("Alteration Speed", speed, "{1}")
		morphtimerOID 	= AddSliderOption("Body Morph Speed", morphtimer, "{1}h")
		AddHeaderOption("Mod Compatibility")
		if SLIFpresent
			slifOID = AddToggleOption("SexLabInflationFramework", SLIF)
		else 
			slifOID = AddToggleOption("SexLabInflationFramework", SLIF, OPTION_FLAG_DISABLED)
		endif
		if ypspresent
			ypsOID = AddToggleOption("Yps - Immersive Fashion", yps)
		else 
			ypsOID = AddToggleOption("Yps - Immersive Fashion", yps, OPTION_FLAG_DISABLED)
		endif
		if MMEpresent
			mmeOID = AddToggleOption("Milk Mod Economy", MME)
			MMEbreastmaxOID = AddSliderOption("max MMEbreast size", mmebreastmax, "{1}")
		else 
			mmeOID = AddToggleOption("Milk Mod Economy", MME, OPTION_FLAG_DISABLED)
			MMEbreastmaxOID = AddSliderOption("max MMEbreast size", mmebreastmax, "{1}", OPTION_FLAG_DISABLED)
		endif
		AddHeaderOption("Devious Devices Integration")
		AddToggleOptionST("DDBlindfoldStrengthAdjustmentST", "Adjust Blindfold strength", DDBlindfoldStrengthAdjustmentEnabled)
		if DDBlindfoldStrengthAdjustmentEnabled
			AddSliderOptionST("DDBlindfoldStrengthBaseST", 		"Blindfold strength Base", 		DDBlindfoldStrengthBase, 	"{2}")
			AddSliderOptionST("DDBlindfoldStrengthTargetST", 	"Blindfold strength Target", 	DDBlindfoldStrengthTarget, 	"{2}")
			AddSliderOptionST("DDDarkfogStrengthBaseST", 		"Dark Fog strength Base", 		DDDarkfogStrengthBase, 		"{0}")
			AddSliderOptionST("DDDarkfogStrengthTargetST", 		"Dark Fog strength Target", 	DDDarkfogStrengthTarget, 	"{0}")
		else
			AddSliderOptionST("DDBlindfoldStrengthBaseST", 		"Blindfold strength Base", 		DDBlindfoldStrengthBase, 	"{2}", OPTION_FLAG_DISABLED)
			AddSliderOptionST("DDBlindfoldStrengthTargetST", 	"Blindfold strength Target", 	DDBlindfoldStrengthTarget, 	"{2}", OPTION_FLAG_DISABLED)
			AddSliderOptionST("DDDarkfogStrengthBaseST", 		"Dark Fog strength Base", 		DDDarkfogStrengthBase, 		"{0}", OPTION_FLAG_DISABLED)
			AddSliderOptionST("DDDarkfogStrengthTargetST", 		"Dark Fog strength Target", 	DDDarkfogStrengthTarget, 	"{0}", OPTION_FLAG_DISABLED)
		endif
		AddEmptyOption()
		AddToggleOptionST("DDGagTrainingST", "Gag training (allows to speak freely)", DDGagTrainingEnabled)
		if DDGagTrainingEnabled
			AddSliderOptionST("DDGagProficiencyThresholdST", "Gag proficiency threshold", DDGagProficiencyThreshold, "{0}")
		else
			AddSliderOptionST("DDGagProficiencyThresholdST", "Gag proficiency threshold", DDGagProficiencyThreshold, "{0}", OPTION_FLAG_DISABLED)
		endif
		AddEmptyOption()
		AddTextOptionST("updateMenuST", "Update Menu", "")
		
		SetCursorPosition(1)
		AddHeaderOption("Alteration effects to use")
		commentOID 		= AddToggleOption("Alteration comments", comment)
		AddToggleOptionST("eyeAltST", "Alternative Eye Alteration", eyeAlt)
		waistaltOID 	= AddToggleOption("Alternative Waist Alteration", waistalt)
		walkingspeedOID = AddToggleOption("Walking Speed Adjustment", walkingspeed)
		if walkingspeed 
			maxspeedmultOID = AddSliderOption("max Speed Adjustment", maxspeedmult, "{0}%")
			minspeedmultOID = AddSliderOption("min Speed Adjustment", minspeedmult, "{0}%")
			heeldebuffOID = AddSliderOption("Heel Speed Debuff", heeldebuff, "{1}")
			legdebuffOID = AddSliderOption("Leg Speed Debuff", legdebuff, "{1}")
		else 
			maxspeedmultOID = AddSliderOption("max Speed Adjustment", maxspeedmult, "{0}%", OPTION_FLAG_DISABLED)
			minspeedmultOID = AddSliderOption("min Speed Adjustment", minspeedmult, "{0}%", OPTION_FLAG_DISABLED)
			heeldebuffOID = AddSliderOption("Heel Speed Debuff", heeldebuff, "{1}", OPTION_FLAG_DISABLED)
			legdebuffOID = AddSliderOption("Leg Speed Debuff", legdebuff, "{1}", OPTION_FLAG_DISABLED)
		endif
	endif
	
	if (page == "Alteration")
		AddHeaderOption("Alteration Settings")
		AddToggleOptionST("eyeEnabledToggleST", 	"Enable eyes alteration", 		eyeEnabled)
		AddToggleOptionST("mouthEnabledToggleST", 	"Enable mouth alteration", 		mouthEnabled)
		AddToggleOptionST("neckEnabledToggleST", 	"Enable neck alteration", 		neckEnabled)
		AddToggleOptionST("armEnabledToggleST", 	"Enable arms alteration", 		armEnabled)
		AddToggleOptionST("handEnabledToggleST", 	"Enable hands alteration", 		handEnabled)
		AddToggleOptionST("breastEnabledToggleST", 	"Enable breasts alteration", 	breastEnabled)
		AddToggleOptionST("waistEnabledToggleST", 	"Enable waist alteration", 		waistEnabled)
		AddToggleOptionST("buttEnabledToggleST", 	"Enable butt alteration", 		buttEnabled)
		AddToggleOptionST("anusEnabledToggleST", 	"Enable anus alteration", 		anusEnabled)
		AddToggleOptionST("vaginaEnabledToggleST", 	"Enable vagina alteration", 	vaginaEnabled)
		AddToggleOptionST("legEnabledToggleST", 	"Enable legs alteration", 		legEnabled)
		AddToggleOptionST("footEnabledToggleST", 	"Enable feet alteration", 		footEnabled)
		weightOID = AddToggleOption("Enable weight alteration", weight)

		SetCursorPosition(1)
		AddEmptyOption()
		eyeOID = 	AddSliderOption("Eyes alteration strength", 	eye, 	"{0}")
		mouthOID = 	AddSliderOption("Mouth alteration strength", 	mouth, 	"{0}")
		neckOID = 	AddSliderOption("Neck alteration strength", 	neck, 	"{0}")
		armOID = 	AddSliderOption("Arms alteration strength", 	arm, 	"{0}")
		handOID = 	AddSliderOption("Hands alteration strength", 	hand, 	"{0}")
		breastOID = AddSliderOption("Breasts alteration strength", 	breast, "{0}")
		waistOID = 	AddSliderOption("Waist alteration strength", 	waist, 	"{0}")
		buttOID = 	AddSliderOption("Butt alteration strength", 	butt, 	"{0}")
		anusOID = 	AddSliderOption("Anus alteration strength", 	anus, 	"{0}")
		vaginaOID = AddSliderOption("Vagina alteration strength", 	vagina, "{0}")
		legOID = 	AddSliderOption("Legs alteration strength", 	leg, 	"{0}")
		footOID = 	AddSliderOption("Feet alteration strength", 	foot, 	"{0}")
	endif

	if (page == "Recovery")
		AddHeaderOption("Recovery Settings")
		mouthrecoverOID 	= AddSliderOption("Mouth recovery mulitplier", 	mouthrecover, 	"{2}")
		eyerecoverOID 		= AddSliderOption("Eye recovery mulitplier", 	eyerecover, 	"{2}")
		neckrecoverOID 		= AddSliderOption("Neck recovery mulitplier", 	neckrecover, 	"{2}")
		armrecoverOID 		= AddSliderOption("Arm recovery mulitplier", 	armrecover, 	"{2}")
		handrecoverOID 		= AddSliderOption("Hand recovery mulitplier", 	handrecover, 	"{2}")
		breastrecoverOID 	= AddSliderOption("Breast recovery mulitplier", breastrecover, 	"{2}")
		waistrecoverOID 	= AddSliderOption("Waist recovery mulitplier", 	waistrecover, 	"{2}")
		buttrecoverOID 		= AddSliderOption("Butt recovery mulitplier", 	buttrecover, 	"{2}")
		anusrecoverOID 		= AddSliderOption("Anus recovery mulitplier", 	anusrecover, 	"{2}")
		vaginarecoverOID 	= AddSliderOption("Vagina recovery mulitplier", vaginarecover, 	"{2}")
		legrecoverOID 		= AddSliderOption("Leg recovery mulitplier", 	legrecover, 	"{2}")
		footrecoverOID 		= AddSliderOption("Foot recovery mulitplier", 	footrecover, 	"{2}")

		SetCursorPosition(1)
		AddEmptyOption()
		AddSliderOptionST("eyeRecoveryLimitST", 	"Eye recovery limit", 		eyeRecoveryLimit, 		"{2}")
		AddSliderOptionST("mouthRecoveryLimitST", 	"Mouth recovery limit", 	mouthRecoveryLimit, 	"{2}")
		AddSliderOptionST("neckRecoveryLimitST", 	"Neck recovery limit", 		neckRecoveryLimit, 		"{2}")
		AddSliderOptionST("armRecoveryLimitST", 	"Arm recovery limit", 		armRecoveryLimit, 		"{2}")
		AddSliderOptionST("handRecoveryLimitST", 	"Hand recovery limit", 		handRecoveryLimit, 		"{2}")
		AddSliderOptionST("breastRecoveryLimitST", 	"Breast recovery limit", 	breastRecoveryLimit, 	"{2}")
		AddSliderOptionST("waistRecoveryLimitST", 	"Waist recovery limit", 	waistRecoveryLimit, 	"{2}")
		AddSliderOptionST("buttRecoveryLimitST", 	"Butt recovery limit", 		buttRecoveryLimit, 		"{2}")
		AddSliderOptionST("anusRecoveryLimitST", 	"Anus recovery limit", 		anusRecoveryLimit, 		"{2}")
		AddSliderOptionST("vaginaRecoveryLimitST", 	"Vagina recovery limit", 	vaginaRecoveryLimit, 	"{2}")
		AddSliderOptionST("legRecoveryLimitST", 	"Leg recovery limit", 		legRecoveryLimit, 		"{2}")
		AddSliderOptionST("footRecoveryLimitST", 	"Foot recovery limit", 		footRecoveryLimit, 		"{2}")
	endif
	
	if (page == "Status")
		AddHeaderOption("Alteration Ranks")
		AddSliderOptionST("eyeAlterationRankST", 	"Set eye alteration rank", 		BodyTicker.eyetime, 	"{0}")
		AddSliderOptionST("mouthAlterationRankST", 	"Set mouth alteration rank", 	BodyTicker.mouthtime, 	"{0}")
		AddSliderOptionST("neckAlterationRankST", 	"Set neck alteration rank", 	BodyTicker.necktime, 	"{0}")
		AddSliderOptionST("armAlterationRankST", 	"Set arm alteration rank", 		BodyTicker.armtime, 	"{0}")
		AddSliderOptionST("handAlterationRankST", 	"Set hand alteration rank", 	BodyTicker.handtime, 	"{0}")
		AddSliderOptionST("breastAlterationRankST", "Set breast alteration rank", 	BodyTicker.breasttime, 	"{0}")
		AddSliderOptionST("waistAlterationRankST", 	"Set waist alteration rank", 	BodyTicker.waisttime, 	"{0}")
		AddSliderOptionST("buttAlterationRankST", 	"Set butt alteration rank", 	BodyTicker.butttime, 	"{0}")
		AddSliderOptionST("anusAlterationRankST", 	"Set anus alteration rank", 	BodyTicker.anustime, 	"{0}")
		AddSliderOptionST("vaginaAlterationRankST", "Set vagina alteration rank", 	BodyTicker.vaginatime, 	"{0}")
		AddSliderOptionST("legAlterationRankST", 	"Set leg alteration rank", 		BodyTicker.legtime, 	"{0}")
		AddSliderOptionST("footAlterationRankST", 	"Set foot alteration rank", 	BodyTicker.foottime, 	"{0}")
		AddSliderOptionST("weightAlterationRankST", "Set weight alteration rank", 	BodyTicker.weighttime, 	"{0}")

		SetCursorPosition(1)
		AddEmptyOption()
		AddTextOptionST("resetRanksST", "Reset ranks", "")
	endif

	if (page == "Debug")
		debuglogenabledOID = AddToggleOption("Debug to log", debuglogenabled)
		debugenabledOID = AddToggleOption("Debug notifications", debugenabled)
	endif

	;if (page == "disable")
	;	MagicEffect[] playerEffect = GetAllActiveEffectsOnActor(dba_player, true)
	;	int i = 0
	;	while i < playerEffect.length
	;		string archetype = GetEffectArchetypeAsString(playerEffect[i])
	;		if archetype == "ValueMod" || archetype == "DualValueMod" || archetype == "PeakValueMod"
	;			AddTextOption(playerEffect[i].GetName(), "")
	;		endif
	;		i += 1
	;	endwhile
	;endif
endEvent

event OnOptionSliderOpen(int option)
;###########General##############
	If option == updatetickerOID
		SetSliderDialogStartValue(updateticker)
		SetSliderDialogDefaultValue(6.66)
		SetSliderDialogRange(6.00, 30.00)
		SetSliderDialogInterval(0.01)
	elseif option == speedOID
		SetSliderDialogStartValue(speed)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.1, 100.0)
		SetSliderDialogInterval(0.1)
	elseif option == morphtimerOID
		SetSliderDialogStartValue(morphtimer)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.5, 24.0)
		SetSliderDialogInterval(0.5)
	elseif option == maxspeedmultOID
		SetSliderDialogDefaultValue(maxspeedmult)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(1.0, 250.0)
		SetSliderDialogInterval(1)
	elseif option == minspeedmultOID
		SetSliderDialogDefaultValue(minspeedmult)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(1.0, 200.0)
		SetSliderDialogInterval(1)
	elseif option == heeldebuffOID
		SetSliderDialogStartValue(heeldebuff)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.1, 2.0)
		SetSliderDialogInterval(0.1)
	elseif option == legdebuffOID
		SetSliderDialogStartValue(legdebuff)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.1, 2.0)
		SetSliderDialogInterval(0.1)
	elseif option == MMEbreastmaxOID
		SetSliderDialogStartValue(mmebreastmax)
		SetSliderDialogDefaultValue(4.5)
		SetSliderDialogRange(0.1, 10.0)
		SetSliderDialogInterval(0.1)	
	endif

;##########Alteration############
	If option == eyeOID
		SetSliderDialogStartValue(eye)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)
	elseif option == mouthOID
		SetSliderDialogStartValue(mouth)
		SetSliderDialogDefaultValue(75.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)
	elseif option == neckOID
		SetSliderDialogStartValue(neck)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)
	elseif option == armOID
		SetSliderDialogStartValue(arm)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)
	elseif option == handOID
		SetSliderDialogStartValue(hand)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)
	elseif option == breastOID
		SetSliderDialogStartValue(breast)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)		
	elseif option == waistOID
		SetSliderDialogStartValue(waist)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)
	elseif option == buttOID
		SetSliderDialogStartValue(butt)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)
	elseif option == anusOID
		SetSliderDialogStartValue(anus)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)
	elseif option == vaginaOID
		SetSliderDialogStartValue(vagina)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)
	elseif option == legOID
		SetSliderDialogStartValue(leg)
		SetSliderDialogDefaultValue(75.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)
	elseif option == footOID
		SetSliderDialogStartValue(foot)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)
	endif
	
;##########Recovery############
	If option == eyerecoverOID
		SetSliderDialogStartValue(eyerecover)
		SetSliderDialogDefaultValue(3.50)
		SetSliderDialogRange(0.00, 5.00)
		SetSliderDialogInterval(0.01)
	elseif option == mouthrecoverOID
		SetSliderDialogStartValue(mouthrecover)
		SetSliderDialogDefaultValue(3.50)
		SetSliderDialogRange(0.00, 5.00)
		SetSliderDialogInterval(0.01)
	elseif option == neckrecoverOID
		SetSliderDialogStartValue(neckrecover)
		SetSliderDialogDefaultValue(0.75)
		SetSliderDialogRange(0.00, 2.00)
		SetSliderDialogInterval(0.01)
	elseif option == armrecoverOID
		SetSliderDialogStartValue(armrecover)
		SetSliderDialogDefaultValue(0.75)
		SetSliderDialogRange(0.00, 2.00)
		SetSliderDialogInterval(0.01)
	elseif option == handrecoverOID
		SetSliderDialogStartValue(handrecover)
		SetSliderDialogDefaultValue(0.75)
		SetSliderDialogRange(0.00, 2.00)
		SetSliderDialogInterval(0.01)
	elseif option == breastrecoverOID
		SetSliderDialogStartValue(breastrecover)
		SetSliderDialogDefaultValue(1.00)
		SetSliderDialogRange(0.00, 2.00)
		SetSliderDialogInterval(0.01)		
	elseif option == waistrecoverOID
		SetSliderDialogStartValue(waistrecover)
		SetSliderDialogDefaultValue(0.50)
		SetSliderDialogRange(0.00, 2.00)
		SetSliderDialogInterval(0.01)
	elseif option == buttrecoverOID
		SetSliderDialogStartValue(buttrecover)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.00, 2.00)
		SetSliderDialogInterval(0.01)
	elseif option == anusrecoverOID
		SetSliderDialogStartValue(anusrecover)
		SetSliderDialogDefaultValue(0.75)
		SetSliderDialogRange(0.00, 2.00)
		SetSliderDialogInterval(0.01)
	elseif option == vaginarecoverOID
		SetSliderDialogStartValue(vaginarecover)
		SetSliderDialogDefaultValue(0.75)
		SetSliderDialogRange(0.00, 2.00)
		SetSliderDialogInterval(0.01)
	elseif option == legrecoverOID
		SetSliderDialogStartValue(legrecover)
		SetSliderDialogDefaultValue(0.75)
		SetSliderDialogRange(0.00, 2.00)
		SetSliderDialogInterval(0.01)
	elseif option == footrecoverOID
		SetSliderDialogStartValue(footrecover)
		SetSliderDialogDefaultValue(0.75)
		SetSliderDialogRange(0.00, 2.00)
		SetSliderDialogInterval(0.01)
	endif
endEvent

event OnOptionSliderAccept(int option, float value)
;###########General##############
	if option == updatetickerOID
		updateticker = value as float
		SetSliderOptionValue(option, updateticker, "{2}s")
	elseif option == speedOID
		speed = value as float
		SetSliderOptionValue(option, speed, "{1}")
	elseif option == morphtimerOID
		morphtimer = value as float
		SetSliderOptionValue(option, morphtimer, "{1}h")
	elseif option == maxspeedmultOID
		if maxspeedmult != value
			maxspeedmult = value as float
			SetSliderOptionValue(option, maxspeedmult, "{0}%")
			movSpeedResetQueued = true
		endif
	elseif option == minspeedmultOID
		if minspeedmult != value
			minspeedmult = value as float
			SetSliderOptionValue(option, minspeedmult, "{0}%")
			movSpeedResetQueued = true
		endif
	elseif option == heeldebuffOID
		if heeldebuff != value
			heeldebuff = value as float
			SetSliderOptionValue(option, heeldebuff, "{1}")
			movSpeedResetQueued = true
		endif
	elseif option == legdebuffOID
		if legdebuff != value
			legdebuff = value as float
			SetSliderOptionValue(option, legdebuff, "{1}")
			movSpeedResetQueued = true
		endif
	elseif option == MMEbreastmaxOID
		if mmebreastmax != value
			mmebreastmax = value as float
			SetSliderOptionValue(option, mmebreastmax, "{1}")
			breastsResetQueued = true
		endif
	endif

;###########Alteration###########	
	if option == eyeOID
		if eye != value
			eye = value as float
			SetSliderOptionValue(option, eye, "{0}")
			eyesResetQueued = true
		endif
	elseif option == mouthOID
		if mouth != value
			mouth = value as float
			SetSliderOptionValue(option, mouth, "{0}")
			mouthResetQueued = true
		endif
	elseif option == neckOID
		if neck != value
			neck = value as float
			SetSliderOptionValue(option, neck, "{0}")
			neckResetQueued = true
		endif
	elseif option == armOID
		if arm != value
			arm = value as float
			SetSliderOptionValue(option, arm, "{0}")
			armsResetQueued = true
		endif
	elseif option == handOID
		if hand != value
			hand = value as float
			SetSliderOptionValue(option, hand, "{0}")
			;handsResetQueued = true
		endif
	elseif option == breastOID
		if breast != value
			breast = value as float
			SetSliderOptionValue(option, breast, "{0}")
			breastsResetQueued = true
		endif
	elseif option == waistOID
		if waist != value
			waist = value as float
			SetSliderOptionValue(option, waist, "{0}")
			waistResetQueued = true
		endif
	elseif option == buttOID
		if butt != value
			butt = value as float
			SetSliderOptionValue(option, butt, "{0}")
			buttResetQueued = true
		endif
	elseif option == anusOID
		if anus != value
			anus = value as float
			SetSliderOptionValue(option, anus, "{0}")
			anusResetQueued = true
		endif
	elseif option == vaginaOID
		if vagina != value
			vagina = value as float
			SetSliderOptionValue(option, vagina, "{0}")
			vaginaResetQueued = true
		endif
	elseif option == legOID
		if leg != value
			leg = value as float
			SetSliderOptionValue(option, leg, "{0}")
			legsResetQueued = true
		endif
	elseif option == footOID
		if foot != value
			foot = value as float
			SetSliderOptionValue(option, foot, "{0}")
			feetResetQueued = true
		endif
	endif
	
;###########Recovery###########
	if option == eyerecoverOID
		if eyerecover != value
			eyerecover = value as float
			SetSliderOptionValue(option, eyerecover, "{2}")
			eyesResetQueued = true
		endif
	elseif option == mouthrecoverOID
		if mouthrecover != value
			mouthrecover = value as float
			SetSliderOptionValue(option, mouthrecover, "{2}")
			mouthResetQueued = true
		endif
	elseif option == neckrecoverOID
		if neckrecover != value
			neckrecover = value as float
			SetSliderOptionValue(option, neckrecover, "{2}")
			neckResetQueued = true
		endif
	elseif option == armrecoverOID
		if armrecover != value
			armrecover = value as float
			SetSliderOptionValue(option, armrecover, "{2}")
			armsResetQueued = true
		endif
	elseif option == handrecoverOID
		if handrecover != value
			handrecover = value as float
			SetSliderOptionValue(option, handrecover, "{2}")
			;handsResetQueued = true
		endif
	elseif option == breastrecoverOID
		if breastrecover != value
			breastrecover = value as float
			SetSliderOptionValue(option, breastrecover, "{2}")
			breastsResetQueued = true
		endif
	elseif option == waistrecoverOID
		if waistrecover != value
			waistrecover = value as float
			SetSliderOptionValue(option, waistrecover, "{2}")
			waistResetQueued = true
		endif
	elseif option == buttrecoverOID
		if buttrecover != value
			buttrecover = value as float
			SetSliderOptionValue(option, buttrecover, "{2}")
			buttResetQueued = true
		endif
	elseif option == anusrecoverOID
		if anusrecover != value
			anusrecover = value as float
			SetSliderOptionValue(option, anusrecover, "{2}")
			anusResetQueued = true
		endif
	elseif option == vaginarecoverOID
		if vaginarecover != value
			vaginarecover = value as float
			SetSliderOptionValue(option, vaginarecover, "{2}")
			vaginaResetQueued = true
		endif
	elseif option == legrecoverOID
		if legrecover != value
			legrecover = value as float
			SetSliderOptionValue(option, legrecover, "{2}")
			legsResetQueued = true
		endif
	elseif option == footrecoverOID
		if footrecover != value
			footrecover = value as float
			SetSliderOptionValue(option, footrecover, "{2}")
			feetResetQueued = true
		endif
	endif
endEvent

event OnOptionHighlight (int option)
;###########General##############
	if option == modenabledOID
		setInfoText("If you disabled the mod, all changes to your body will reset.\nIf you enable the mod again within the next inGame hour no Changes to your body will occur.")
	elseif option == updatetickerOID
		SetInfoText("Set Update Interval to customize script load.")
	elseif option == speedOID
		SetInfoText("This menu will set the overall alteration speed.\nDefault 1.0 will transform your body within weeks (28 days constant wearing).\nLower values will result in month. Higher Values will adjust your body in minutes.\n(a setting of 28 will result in one day constant wearing restraints)")
	elseif option == morphtimerOID
		SetInfoText("This menu will set the Body Transformation Timer.\nDefault 1.0 hour meaning every single hour your appearance will update.\nAdjustable to a maximum of 24 hours meaning once per day your appearance will update.")
	elseif option == slifOID
		SetInfoText("Toggles Sex Lab Inflation Framework Morphs on/off.")
	elseif option == ypsOID
		SetInfoText("Toggles Yps Immersive Fashion support on/off.")
	elseif option == mmeOID
		SetInfoText("Toggles Milk Mod Economy breast scaling support on/off.\nIf support is on deactivate breast scaling from MME.")
	elseif option == walkingspeedOID
		SetInfoText("Toogles the SpeedMult Adjustment on/off.")
	elseif option == maxspeedmultOID
		SetInfoText("Use Slider to determine the maximum walking speed.\nDefault and game default is 100%.")
	elseif option == minspeedmultOID
		SetInfoText("Use Slider to determine the minimum walking speed.\nDefault is 25%.")
	elseif option == heeldebuffOID
		SetInfoText("Use Slider to set the speed debuff amount of footwear having a heel or restrict feet movement.\nDefault is 1. Values above 1 will slowly change the debuff into a buff.")
	elseif option == legdebuffOID
		SetInfoText("Use Slider to set the speed debuff amount of leg restricting clothing, e.g. hobble skirt.\nDefault is 1. Values above 1 will slowly change the debuff into a buff.")
	endif

;###########Alteration###########	
	if option == eyeOID
		SetInfoText("Use slider to determine the eye squint maximum.\nSet 0 to disable.")
	elseif option == mouthOID
		SetInfoText("Use slider to determine mouth opening maxium.\nSet 0 to disable.")
	elseif option == neckOID
		SetInfoText("Use slider to determine the neck elongation maximum.\nSet 0 to disable.")
	elseif option == armOID
		SetInfoText("Use slider to determine muscle loss off your arms.\nSet 0 to disable.")
	elseif option == handOID
		SetInfoText("Use slider to determine the ability loss from your hands.\nSet 0 to disable.")
	elseif option == breastOID
		SetInfoText("Use slider to determine boob growth maxium.\nSet 0 to disable.")
	elseif option == waistOID
		SetInfoText("Use slider to determine your waist pinch.\nSet 0 to disable.")
	elseif option == buttOID
		SetInfoText("Use slider to determine your butt growth maximum.\nSet 0 to disable.")
	elseif option == anusOID
		SetInfoText("Use slider to determine the anus widening effect.\nNo visual effect yet.\nSet 0 to disable.")
	elseif option == vaginaOID
		SetInfoText("Use slider to determine the vagina widening effect.\nSet 0 to disable.")
	elseif option == legOID
		SetInfoText("Use slider to determine the muscle loss off your legs.\nSet 0 to disable.")
	elseif option == footOID
		SetInfoText("Use slider to determine the achilles shortening.\nSet 0 to disable.")
	elseif option == weightOID
		SetInfoText("Toggles weight support active.")
	elseif option == waistaltOID
		SetInfoText("Toggles alternative (more extreme) waist scaling.")
	elseif option  == commentOID
		SetInfoText("Toggles the comment function to body alteration status in the left corner on/off.")
	endif

;###########Recovery###########
	if option == eyerecoverOID
		SetInfoText("Use slider to determine the eye recovery rate.\nSet 0 to never recover.\nValues below 1 will slow down the recovery rate.")
	elseif option == mouthrecoverOID
		SetInfoText("Use slider to determine mouth recovery rate.\nSet 0 to never recover.\nValues below 1 will slow down the recovery rate.")
	elseif option == neckrecoverOID
		SetInfoText("Use slider to determine the neck recovery rate.\nSet 0 to never recover.\nValues below 1 will slow down the recovery rate.")
	elseif option == armrecoverOID
		SetInfoText("Use slider to determine muscle recovery rate off your arms.\nSet 0 to never recover.\nValues below 1 will slow down the recovery rate.")
	elseif option == handrecoverOID
		SetInfoText("Use slider to determine the ability recovery rate from your hands.\nSet 0 to never recover.\nValues below 1 will slow down the recovery rate.")
	elseif option == breastrecoverOID
		SetInfoText("Use slider to determine boob growth recovery rate.\nSet 0 to never recover.\nValues below 1 will slow down the recovery rate.")
	elseif option == waistrecoverOID
		SetInfoText("Use slider to determine your waist pinch recovery rate.\nSet 0 to never recover.\nValues below 1 will slow down the recovery rate.")
	elseif option == buttrecoverOID
		SetInfoText("Use slider to determine your butt growth recovery rate.\nSet 0 to never recover.\nValues below 1 will slow down the recovery rate.")
	elseif option == anusrecoverOID
		SetInfoText("Use slider to determine the anus widening recovery rate.\nNo visual effect yet.\nSet 0 to never recover.\nValues below 1 will slow down the recovery rate.")
	elseif option == vaginarecoverOID
		SetInfoText("Use slider to determine the vagina widening recovery rate.\nSet 0 to never recover.\nValues below 1 will slow down the recovery rate.")
	elseif option == legrecoverOID
		SetInfoText("Use slider to determine the muscle recovery rate off your legs.\nSet 0 to never recover.\nValues below 1 will slow down the recovery rate.")
	elseif option == footrecoverOID
		SetInfoText("Use slider to determine the achilles training recovery rate.\nSet 0 to never recover.\nValues below 1 will slow down the recovery rate.")
	endif
endEvent

event OnOptionMenuOpen(int option)
;###########General##############
endEvent

event OnOptionMenuAccept(int option, int index)
;###########General##############
endEvent

event OnOptionSelect(int option)
;###########General##############
	if (option == modenabledOID)
		modenabled = !modenabled
		SetToggleOptionValue(modenabledOID, modenabled)
	elseif (option == slifOID)
		SLIF = !SLIF
		SetToggleOptionValue(slifOID, SLIF)
	elseif (option == ypsOID)
		yps = !yps
		SetToggleOptionValue(ypsOID, yps)
		feetResetQueued = true
	elseif (option == mmeOID)
		mme =!mme
		SetToggleOptionValue(mmeOID, mme)
		breastsResetQueued = true
	endif

;###########Alteration###########	
	if (option == weightOID)
		weight = !weight
		SetToggleOptionValue(weightOID, weight)
	elseif (option == waistaltOID)
		waistalt = !waistalt
		SetToggleOptionValue(waistaltOID, waistalt)
		waistResetQueued = true
	elseif (option == commentOID)
		comment = !comment
		SetToggleOptionValue(commentOID, comment)
	elseif (option == walkingspeedOID)
		walkingspeed = !walkingspeed
		SetToggleOptionValue(walkingspeedOID, walkingspeed)
		if walkingspeed
			SetOptionFlags(maxspeedmultOID, OPTION_FLAG_NONE)
			SetOptionFlags(minspeedmultOID, OPTION_FLAG_NONE)
			SetOptionFlags(heeldebuffOID, OPTION_FLAG_NONE)
			SetOptionFlags(legdebuffOID, OPTION_FLAG_NONE)
		else
			SetOptionFlags(maxspeedmultOID, OPTION_FLAG_DISABLED)
			SetOptionFlags(minspeedmultOID, OPTION_FLAG_DISABLED)
			SetOptionFlags(heeldebuffOID, OPTION_FLAG_DISABLED)
			SetOptionFlags(legdebuffOID, OPTION_FLAG_DISABLED)
		endif
		movSpeedResetQueued = true
	endif

;###########Debug##############	
	if (option == debuglogenabledOID)
		debuglogenabled = !debuglogenabled
		SetToggleOptionValue(debuglogenabledOID, debuglogenabled)
	elseif (option == debugenabledOID)
		debugenabled = !debugenabled
		SetToggleOptionValue(debugenabledOID, debugenabled)
	endif
endEvent

;################################################################################################################################################################
;---------------------------------------------------------------------------- States ----------------------------------------------------------------------------
;################################################################################################################################################################
;---------------------------------------------------------------------------- General ---------------------------------------------------------------------------
;################################################################################################################################################################
state DDBlindfoldStrengthAdjustmentST
	event onSelectST()
		DDBlindfoldStrengthAdjustmentEnabled = !DDBlindfoldStrengthAdjustmentEnabled
		SetToggleOptionValueST(DDBlindfoldStrengthAdjustmentEnabled)
		if DDBlindfoldStrengthAdjustmentEnabled
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "DDBlindfoldStrengthBaseST")
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "DDBlindfoldStrengthTargetST")
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "DDDarkfogStrengthBaseST")
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "DDDarkfogStrengthTargetST")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "DDBlindfoldStrengthBaseST")
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "DDBlindfoldStrengthTargetST")
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "DDDarkfogStrengthBaseST")
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "DDDarkfogStrengthTargetST")
			zadConfigHandle.blindfoldStrength = 0.5
			zadConfigHandle.darkfogStrength = 300
		endif
	endEvent
endState

state DDBlindfoldStrengthBaseST
	event onSliderOpenST() 
		SetSliderDialogStartValue(DDBlindfoldStrengthBase)
		SetSliderDialogDefaultValue(0.5)
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		DDBlindfoldStrengthBase = value
		SetSliderOptionValueST(DDBlindfoldStrengthBase, "{2}")
		updateDDBlindfoldBaseTargetRatio()
	endEvent

	event onDefaultST()
		DDBlindfoldStrengthBase = 0.5
		SetSliderOptionValueST(DDBlindfoldStrengthBase, "{2}")
		updateDDBlindfoldBaseTargetRatio()
	endEvent
endState

state DDBlindfoldStrengthTargetST
	event onSliderOpenST() 
		SetSliderDialogStartValue(DDBlindfoldStrengthTarget)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		DDBlindfoldStrengthTarget = value
		SetSliderOptionValueST(DDBlindfoldStrengthTarget, "{2}")
		updateDDBlindfoldBaseTargetRatio()
	endEvent

	event onDefaultST()
		DDBlindfoldStrengthTarget = 0.0
		SetSliderOptionValueST(DDBlindfoldStrengthTarget, "{2}")
		updateDDBlindfoldBaseTargetRatio()
	endEvent
endState

function updateDDBlindfoldBaseTargetRatio()
	DDBlindfoldStrengthRatio = (DDBlindfoldStrengthBase - DDBlindfoldStrengthTarget) / 100
endfunction

state DDDarkfogStrengthBaseST
	event onSliderOpenST() 
		SetSliderDialogStartValue(DDDarkfogStrengthBase)
		SetSliderDialogDefaultValue(300)
		SetSliderDialogRange(200, 500)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		DDDarkfogStrengthBase = value
		SetSliderOptionValueST(DDDarkfogStrengthBase, "{0}")
		updateDDDarkfogBaseTargetRatio()
	endEvent

	event onDefaultST()
		DDDarkfogStrengthBase = 300
		SetSliderOptionValueST(DDDarkfogStrengthBase, "{0}")
		updateDDDarkfogBaseTargetRatio()
	endEvent
endState

state DDDarkfogStrengthTargetST
	event onSliderOpenST() 
		SetSliderDialogStartValue(DDDarkfogStrengthTarget)
		SetSliderDialogDefaultValue(500)
		SetSliderDialogRange(200, 500)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		DDDarkfogStrengthTarget = value
		SetSliderOptionValueST(DDDarkfogStrengthTarget, "{0}")
		updateDDDarkfogBaseTargetRatio()
	endEvent

	event onDefaultST()
		DDDarkfogStrengthTarget = 500
		SetSliderOptionValueST(DDDarkfogStrengthTarget, "{0}")
		updateDDDarkfogBaseTargetRatio()
	endEvent
endState

function updateDDDarkfogBaseTargetRatio()
	DDDarkfogStrengthRatio = (DDDarkfogStrengthBase - DDDarkfogStrengthTarget) / 100
endfunction

state DDGagTrainingST
	event onSelectST()
		DDGagTrainingEnabled = !DDGagTrainingEnabled
		SetToggleOptionValueST(DDGagTrainingEnabled)
		if DDGagTrainingEnabled
			SetOptionFlagsST(OPTION_FLAG_NONE, false, "DDGagProficiencyThresholdST")
		else
			SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "DDGagProficiencyThresholdST")
			zadGagHandle.canTalk = false
		endif
	endEvent
endState

state DDGagProficiencyThresholdST
	event onSliderOpenST() 
		SetSliderDialogStartValue(DDGagProficiencyThreshold)
		SetSliderDialogDefaultValue(80)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		DDGagProficiencyThreshold = value
		SetSliderOptionValueST(DDGagProficiencyThreshold, "{0}")
	endEvent

	event onDefaultST()
		DDGagProficiencyThreshold = 80
		SetSliderOptionValueST(DDGagProficiencyThreshold, "{0}")
	endEvent
endState

state eyeAltST
	event onSelectST()
		eyeAlt = !eyeAlt
		SetToggleOptionValueST(eyeAlt)
		eyesResetQueued = true
	endEvent
endState

;################################################################################################################################################################
;-------------------------------------------------------------------------- Alteration --------------------------------------------------------------------------
;################################################################################################################################################################
state eyeEnabledToggleST
	event onSelectST()
		eyeEnabled = !eyeEnabled
		SetToggleOptionValueST(eyeEnabled)
		eyesResetQueued = true
		if !eyeEnabled
			zadConfigHandle.blindfoldStrength = 0.5
			zadConfigHandle.darkfogStrength = 300
		endif
	endEvent
endState

state mouthEnabledToggleST
	event onSelectST()
		mouthEnabled = !mouthEnabled
		SetToggleOptionValueST(mouthEnabled)
		mouthResetQueued = true
		if !mouthEnabled
			zadGagHandle.canTalk = false
		endif
	endEvent
endState

state neckEnabledToggleST
	event onSelectST()
		neckEnabled = !neckEnabled
		SetToggleOptionValueST(neckEnabled)
		neckResetQueued = true
	endEvent
endState

state armEnabledToggleST
	event onSelectST()
		armEnabled = !armEnabled
		SetToggleOptionValueST(armEnabled)
		armsResetQueued = true
	endEvent
endState

state handEnabledToggleST
	event onSelectST()
		handEnabled = !handEnabled
		SetToggleOptionValueST(handEnabled)
		;handsResetQueued = true
	endEvent
endState

state breastEnabledToggleST
	event onSelectST()
		breastEnabled = !breastEnabled
		SetToggleOptionValueST(breastEnabled)
		breastsResetQueued = true
	endEvent
endState

state waistEnabledToggleST
	event onSelectST()
		waistEnabled = !waistEnabled
		SetToggleOptionValueST(waistEnabled)
		waistResetQueued = true
	endEvent
endState

state buttEnabledToggleST
	event onSelectST()
		buttEnabled = !buttEnabled
		SetToggleOptionValueST(buttEnabled)
		buttResetQueued = true
	endEvent
endState

state anusEnabledToggleST
	event onSelectST()
		anusEnabled = !anusEnabled
		SetToggleOptionValueST(anusEnabled)
		anusResetQueued = true
	endEvent
endState

state vaginaEnabledToggleST
	event onSelectST()
		vaginaEnabled = !vaginaEnabled
		SetToggleOptionValueST(vaginaEnabled)
		vaginaResetQueued = true
	endEvent
endState

state legEnabledToggleST
	event onSelectST()
		legEnabled = !legEnabled
		SetToggleOptionValueST(legEnabled)
		legsResetQueued = true
	endEvent
endState

state footEnabledToggleST
	event onSelectST()
		footEnabled = !footEnabled
		SetToggleOptionValueST(footEnabled)
		feetResetQueued = true
	endEvent
endState

;################################################################################################################################################################
;--------------------------------------------------------------------------- Recovery ---------------------------------------------------------------------------
;################################################################################################################################################################
state eyeRecoveryLimitST
	event onSliderOpenST() 
		SetSliderDialogStartValue(eyeRecoveryLimit)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		eyeRecoveryLimit = value
		SetSliderOptionValueST(eyeRecoveryLimit, "{2}")
	endEvent

	event onDefaultST()
		eyeRecoveryLimit = 0.25
		SetSliderOptionValueST(eyeRecoveryLimit, "{2}")
	endEvent
endState

state mouthRecoveryLimitST
	event onSliderOpenST() 
		SetSliderDialogStartValue(mouthRecoveryLimit)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		mouthRecoveryLimit = value
		SetSliderOptionValueST(mouthRecoveryLimit, "{2}")
	endEvent

	event onDefaultST()
		mouthRecoveryLimit = 0.25
		SetSliderOptionValueST(mouthRecoveryLimit, "{2}")
	endEvent
endState

state neckRecoveryLimitST
	event onSliderOpenST() 
		SetSliderDialogStartValue(neckRecoveryLimit)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		neckRecoveryLimit = value
		SetSliderOptionValueST(neckRecoveryLimit, "{2}")
	endEvent

	event onDefaultST()
		neckRecoveryLimit = 0.25
		SetSliderOptionValueST(neckRecoveryLimit, "{2}")
	endEvent
endState

state armRecoveryLimitST
	event onSliderOpenST() 
		SetSliderDialogStartValue(armRecoveryLimit)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		armRecoveryLimit = value
		SetSliderOptionValueST(armRecoveryLimit, "{2}")
	endEvent

	event onDefaultST()
		armRecoveryLimit = 0.25
		SetSliderOptionValueST(armRecoveryLimit, "{2}")
	endEvent
endState

state handRecoveryLimitST
	event onSliderOpenST() 
		SetSliderDialogStartValue(handRecoveryLimit)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		handRecoveryLimit = value
		SetSliderOptionValueST(handRecoveryLimit, "{2}")
	endEvent

	event onDefaultST()
		handRecoveryLimit = 0.25
		SetSliderOptionValueST(handRecoveryLimit, "{2}")
	endEvent
endState

state breastRecoveryLimitST
	event onSliderOpenST() 
		SetSliderDialogStartValue(breastRecoveryLimit)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		breastRecoveryLimit = value
		SetSliderOptionValueST(breastRecoveryLimit, "{2}")
	endEvent

	event onDefaultST()
		breastRecoveryLimit = 0.25
		SetSliderOptionValueST(breastRecoveryLimit, "{2}")
	endEvent
endState

state waistRecoveryLimitST
	event onSliderOpenST() 
		SetSliderDialogStartValue(waistRecoveryLimit)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		waistRecoveryLimit = value
		SetSliderOptionValueST(waistRecoveryLimit, "{2}")
	endEvent

	event onDefaultST()
		waistRecoveryLimit = 0.25
		SetSliderOptionValueST(waistRecoveryLimit, "{2}")
	endEvent
endState

state buttRecoveryLimitST
	event onSliderOpenST() 
		SetSliderDialogStartValue(buttRecoveryLimit)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		buttRecoveryLimit = value
		SetSliderOptionValueST(buttRecoveryLimit, "{2}")
	endEvent

	event onDefaultST()
		buttRecoveryLimit = 0.25
		SetSliderOptionValueST(buttRecoveryLimit, "{2}")
	endEvent
endState

state anusRecoveryLimitST
	event onSliderOpenST() 
		SetSliderDialogStartValue(anusRecoveryLimit)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		anusRecoveryLimit = value
		SetSliderOptionValueST(anusRecoveryLimit, "{2}")
	endEvent

	event onDefaultST()
		anusRecoveryLimit = 0.25
		SetSliderOptionValueST(anusRecoveryLimit, "{2}")
	endEvent
endState

state vaginaRecoveryLimitST
	event onSliderOpenST() 
		SetSliderDialogStartValue(vaginaRecoveryLimit)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		vaginaRecoveryLimit = value
		SetSliderOptionValueST(vaginaRecoveryLimit, "{2}")
	endEvent

	event onDefaultST()
		vaginaRecoveryLimit = 0.25
		SetSliderOptionValueST(vaginaRecoveryLimit, "{2}")
	endEvent
endState

state legRecoveryLimitST
	event onSliderOpenST()
		SetSliderDialogStartValue(legRecoveryLimit)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		legRecoveryLimit = value
		SetSliderOptionValueST(legRecoveryLimit, "{2}")
	endEvent

	event onDefaultST()
		legRecoveryLimit = 0.25
		SetSliderOptionValueST(legRecoveryLimit, "{2}")
	endEvent
endState

state footRecoveryLimitST
	event onSliderOpenST()
		SetSliderDialogStartValue(footRecoveryLimit)
		SetSliderDialogDefaultValue(0.25)
		SetSliderDialogRange(0, 1)
		SetSliderDialogInterval(0.01)
	endEvent

	event onSliderAcceptST(float value)
		footRecoveryLimit = value
		SetSliderOptionValueST(footRecoveryLimit, "{2}")
	endEvent

	event onDefaultST()
		footRecoveryLimit = 0.25
		SetSliderOptionValueST(footRecoveryLimit, "{2}")
	endEvent
endState

;################################################################################################################################################################
;---------------------------------------------------------------------------- Status ----------------------------------------------------------------------------
;################################################################################################################################################################
state eyeAlterationRankST
	event onSliderOpenST()
		SetSliderDialogStartValue(BodyTicker.eyetime)
		SetSliderDialogDefaultValue(BodyTicker.eyetime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.eyetime = value
		BodyTicker.eyetimeMax = value
		SetSliderOptionValueST(BodyTicker.eyetime, "{0}")
	endEvent
endState

state mouthAlterationRankST
	event onSliderOpenST()
		SetSliderDialogStartValue(BodyTicker.mouthtime)
		SetSliderDialogDefaultValue(BodyTicker.mouthtime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.mouthtime = value
		BodyTicker.mouthtimeMax = value
		SetSliderOptionValueST(BodyTicker.mouthtime, "{0}")
	endEvent
endState

state neckAlterationRankST
	event onSliderOpenST()
		SetSliderDialogStartValue(BodyTicker.necktime)
		SetSliderDialogDefaultValue(BodyTicker.necktime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.necktime = value
		BodyTicker.necktimeMax = value
		SetSliderOptionValueST(BodyTicker.necktime, "{0}")
	endEvent
endState

state armAlterationRankST
	event onSliderOpenST() 
		SetSliderDialogStartValue(BodyTicker.armtime)
		SetSliderDialogDefaultValue(BodyTicker.armtime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.armtime = value
		BodyTicker.armtimeMax = value
		SetSliderOptionValueST(BodyTicker.armtime, "{0}")
	endEvent
endState

state handAlterationRankST
	event onSliderOpenST() 
		SetSliderDialogStartValue(BodyTicker.handtime)
		SetSliderDialogDefaultValue(BodyTicker.handtime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.handtime = value
		BodyTicker.handtimeMax = value
		SetSliderOptionValueST(BodyTicker.handtime, "{0}")
	endEvent
endState

state breastAlterationRankST
	event onSliderOpenST() 
		SetSliderDialogStartValue(BodyTicker.breasttime)
		SetSliderDialogDefaultValue(BodyTicker.breasttime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.breasttime = value
		BodyTicker.breasttimeMax = value
		SetSliderOptionValueST(BodyTicker.breasttime, "{0}")
	endEvent
endState

state waistAlterationRankST
	event onSliderOpenST() 
		SetSliderDialogStartValue(BodyTicker.waisttime)
		SetSliderDialogDefaultValue(BodyTicker.waisttime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.waisttime = value
		BodyTicker.waisttimeMax = value
		SetSliderOptionValueST(BodyTicker.waisttime, "{0}")
	endEvent
endState

state buttAlterationRankST
	event onSliderOpenST() 
		SetSliderDialogStartValue(BodyTicker.butttime)
		SetSliderDialogDefaultValue(BodyTicker.butttime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.butttime = value
		BodyTicker.butttimeMax = value
		SetSliderOptionValueST(BodyTicker.butttime, "{0}")
	endEvent
endState

state anusAlterationRankST
	event onSliderOpenST() 
		SetSliderDialogStartValue(BodyTicker.anustime)
		SetSliderDialogDefaultValue(BodyTicker.anustime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.anustime = value
		BodyTicker.anustimeMax = value
		SetSliderOptionValueST(BodyTicker.anustime, "{0}")
	endEvent
endState

state vaginaAlterationRankST
	event onSliderOpenST() 
		SetSliderDialogStartValue(BodyTicker.vaginatime)
		SetSliderDialogDefaultValue(BodyTicker.vaginatime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.vaginatime = value
		BodyTicker.vaginatimeMax = value
		SetSliderOptionValueST(BodyTicker.vaginatime, "{0}")
	endEvent
endState

state legAlterationRankST
	event onSliderOpenST() 
		SetSliderDialogStartValue(BodyTicker.legtime)
		SetSliderDialogDefaultValue(BodyTicker.legtime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.legtime = value
		BodyTicker.legtimeMax = value
		SetSliderOptionValueST(BodyTicker.legtime, "{0}")
	endEvent
endState

state footAlterationRankST
	event onSliderOpenST() 
		SetSliderDialogStartValue(BodyTicker.foottime)
		SetSliderDialogDefaultValue(BodyTicker.foottime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.foottime = value
		BodyTicker.foottimeMax = value
		SetSliderOptionValueST(BodyTicker.foottime, "{0}")
	endEvent
endState

state weightAlterationRankST
	event onSliderOpenST() 
		SetSliderDialogStartValue(BodyTicker.weighttime)
		SetSliderDialogDefaultValue(BodyTicker.weighttime)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endEvent

	event onSliderAcceptST(float value)
		BodyTicker.weighttime = value
		SetSliderOptionValueST(BodyTicker.weighttime, "{0}")
		weightUpdateQueued = true
	endEvent
endState

state resetRanksST
	event OnSelectST()
		BodyTicker.eyetime = 0.0
		BodyTicker.mouthtime = 0.0
		BodyTicker.necktime = 0.0
		BodyTicker.armtime = 0.0
		BodyTicker.handtime = 0.0
		BodyTicker.breasttime = 0.0
		BodyTicker.waisttime = 0.0
		BodyTicker.butttime = 0.0
		BodyTicker.anustime = 0.0
		BodyTicker.vaginatime = 0.0
		BodyTicker.legtime = 0.0
		BodyTicker.foottime = 0.0
		BodyTicker.weighttime = 50.0

		BodyTicker.eyetimeMax = 0.0
		BodyTicker.mouthtimeMax = 0.0
		BodyTicker.necktimeMax = 0.0
		BodyTicker.armtimeMax = 0.0
		BodyTicker.handtimeMax = 0.0
		BodyTicker.breasttimeMax = 0.0
		BodyTicker.waisttimeMax = 0.0
		BodyTicker.butttimeMax = 0.0
		BodyTicker.anustimeMax = 0.0
		BodyTicker.vaginatimeMax = 0.0
		BodyTicker.legtimeMax = 0.0
		BodyTicker.foottimeMax = 0.0

		eyesResetQueued = true ; we call these specific resets here coz every time you close mcm
		mouthResetQueued = true ; moprhs and transforms get updated
		feetResetQueued = true ; but eyes mouth and feet do not belong to morphs
		; and if we disabled anything along the way checks wont be called
		; and nothing will happen (which is bad)

		SetSliderOptionValueST(0.0, "{0}", false, "eyeAlterationRankST")
		SetSliderOptionValueST(0.0, "{0}", false, "mouthAlterationRankST")
		SetSliderOptionValueST(0.0, "{0}", false, "neckAlterationRankST")
		SetSliderOptionValueST(0.0, "{0}", false, "armAlterationRankST")
		SetSliderOptionValueST(0.0, "{0}", false, "handAlterationRankST")
		SetSliderOptionValueST(0.0, "{0}", false, "breastAlterationRankST")
		SetSliderOptionValueST(0.0, "{0}", false, "waistAlterationRankST")
		SetSliderOptionValueST(0.0, "{0}", false, "buttAlterationRankST")
		SetSliderOptionValueST(0.0, "{0}", false, "anusAlterationRankST")
		SetSliderOptionValueST(0.0, "{0}", false, "vaginaAlterationRankST")
		SetSliderOptionValueST(0.0, "{0}", false, "legAlterationRankST")
		SetSliderOptionValueST(0.0, "{0}", false, "footAlterationRankST")
		SetSliderOptionValueST(0.0, "{0}", false, "weightAlterationRankST")

		SetTextOptionValueST("Done")
	endEvent
endState

state updateMenuST
	event OnSelectST()
		InitPages()
		SetTextOptionValueST("Done, reopen menu")
	endEvent
endState
