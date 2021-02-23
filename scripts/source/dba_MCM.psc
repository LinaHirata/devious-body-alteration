Scriptname dba_MCM extends SKI_ConfigBase  

Actor Property dba_player Auto

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


int modenabledOID
int speedOID
int debuglogenabledOID
int debugenabledOID
int updatetickerOID
int morphtimerOID
int slifOID
int ypsOID
int mmeOID
int MMEbreastmaxOID
int waistaltOID
int commentOID


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
int walkingspeedOID
int maxspeedmultOID
int minspeedmultOID
int heeldebuffOID
int legdebuffOID


float property eye = 75.0 Auto
float property mouth = 75.0 Auto
float property neck = 25.0 Auto
float property arm = 50.0 Auto
float property hand = 50.0 Auto
float property breast = 50.0 Auto
float property waist = 75.0 Auto
float property butt = 50.0 Auto
float property anus = 50.0 Auto
float property vagina = 100.0 Auto
float property leg = 50.0 Auto
float property foot = 100.0 Auto
float property eyerecover = 3.50 Auto
float property mouthrecover = 3.50 Auto
float property neckrecover = 0.75 Auto
float property armrecover = 0.75 Auto
float property handrecover = 0.75 Auto
float property breastrecover = 1.00 Auto
float property waistrecover = 0.50 Auto
float property buttrecover = 1.00 Auto
float property anusrecover = 0.75 Auto
float property vaginarecover = 0.75 Auto
float property legrecover = 0.75 Auto
float property footrecover = 0.75 Auto


float property updateticker = 6.66 Auto
float property speed = 1.0 Auto
float property morphtimer = 1.0 Auto
float property maxspeedmult = 100.0 Auto
float property minspeedmult = 25.0 Auto
float property heeldebuff = 1.0 Auto
float property legdebuff = 1.0 Auto
float property MMEbreastmax = 4.5 Auto

bool property SLIF = false Auto
bool property SLIFpresent = false Auto
bool property yps = false Auto
bool property ypspresent = false Auto
bool property MME = false Auto
bool property MMEpresent = false Auto

bool property modenabled = false Auto
bool property debuglogenabled = true Auto
bool property debugenabled = true Auto
bool property walkingspeed = true Auto

bool property weight = true Auto
bool property waistalt = false Auto
bool property comment = false Auto
bool property MCMclose = false Auto

;-------------------------------------------------------------------------------------------------

int function GetVersion()
	return 2
endFunction

string Function GetStringVer()
	return "Version 1.2"
EndFunction

event OnConfigInit()
	InitPages()
	debug.notification(self + GetStringVer())
	debug.trace(self + GetStringVer())
endEvent

event OnVersionUpdate(int a_version)
	
	if (a_version >= 2 && CurrentVersion < 2)
	InitPages()
	debug.notification(self + GetStringVer() + " loaded.")
	debug.trace(self + GetStringVer())
	endif
		
endEvent


;--------------------------------------------------------------------------------------------------

Function CheckOptionalMods()	
	
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

Function InitPages()

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

	Pages = new string[4]
	Pages[0] = "General"
	Pages[1] = "Alteration"
	Pages[2] = "Status"
	Pages[3] = "Debug"
		
endFunction

event OnConfigClose()

	Debug.notification("Apply DBA MCM changes.")
	MCMclose = true
	
endEvent

event OnPageReset(string page)
	
	dba_player = Game.GetPlayer()
	CheckOptionalMods()
	SetCursorFillMode(TOP_TO_BOTTOM)
	if (page == "")
		LoadCustomContent("DeviousBodyAlteration/dbaLogo.dds", 156,3)
		return
	else
		UnloadCustomContent()
	endIf
	
	if (page == "General")
		AddHeaderOption("Devious Body Alteration " + GetStringVer())
		modenabledOID = AddToggleOption("Mod enabled", modenabled)
		updatetickerOID = AddSliderOption("Update Interval setting", updateticker, "{2}sec")
		speedOID = AddSliderOption("Alteration Speed", speed, "{1}")
		morphtimerOID = AddSliderOption("Body Morph Speed", morphtimer, "{1}h")
		SetCursorPosition(1)
		AddHeaderOption("Morpheffects used")
		weightOID = AddToggleOption("Weight alteration option", weight)
		waistaltOID = AddToggleOption("Alternative Waist Alteration", waistalt)
		AddHeaderOption("Alteration effects to use")
		commentOID = AddToggleOption("Alteration comments", comment)
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
			MMEbreastmaxOID =AddSliderOption("max MMEbreast size", mmebreastmax, "{1}")
		else 
			mmeOID = AddToggleOption("Milk Mod Economy", MME, OPTION_FLAG_DISABLED)
			MMEbreastmaxOID =AddSliderOption("max MMEbreast size", mmebreastmax, "{1}", OPTION_FLAG_DISABLED)
		endif
	endIf
	
	if (page == "Alteration")
		AddHeaderOption("Alteration Settings")
		eyeOID = AddSliderOption("Eye alteration strength", eye, "{0}")
		mouthOID = AddSliderOption("Mouth alteration strength", mouth, "{0}")
		neckOID = AddSliderOption("Neck alteration strength", neck, "{0}")
		armOID = AddSliderOption("Arm alteration strength", arm, "{0}")
		handOID = AddSliderOption("Hand alteration strength", hand, "{0}")
		breastOID = AddSliderOption("Breast alteration strength", breast, "{0}")
		waistOID = AddSliderOption("Waist alteration strength", waist, "{0}")
		buttOID = AddSliderOption("Butt alteration strength", butt, "{0}")
		anusOID = AddSliderOption("Anus alteration strength", anus, "{0}")
		vaginaOID = AddSliderOption("Vagina alteration strength", vagina, "{0}")
		legOID = AddSliderOption("Leg alteration strength", leg, "{0}")
		footOID = AddSliderOption("Foot alteration strength", foot, "{0}")
		SetCursorPosition(1)
		AddHeaderOption("Recover Settings")
		eyerecoverOID = AddSliderOption("Eye recovery mulitplier", eyerecover, "{2}")
		mouthrecoverOID = AddSliderOption("Mouth recovery mulitplier", mouthrecover, "{2}")
		neckrecoverOID = AddSliderOption("Neck recovery mulitplier", neckrecover, "{2}")
		armrecoverOID = AddSliderOption("Arm recovery mulitplier", armrecover, "{2}")
		handrecoverOID = AddSliderOption("Hand recovery mulitplier", handrecover, "{2}")
		breastrecoverOID = AddSliderOption("Breast recovery mulitplier", breastrecover, "{2}")
		waistrecoverOID = AddSliderOption("Waist recovery mulitplier", waistrecover, "{2}")
		buttrecoverOID = AddSliderOption("Butt recovery mulitplier", buttrecover, "{2}")
		anusrecoverOID = AddSliderOption("Anus recovery mulitplier", anusrecover, "{2}")
		vaginarecoverOID = AddSliderOption("Vagina recovery mulitplier", vaginarecover, "{2}")
		legrecoverOID = AddSliderOption("Leg recovery mulitplier", legrecover, "{2}")
		footrecoverOID = AddSliderOption("Foot recovery mulitplier", footrecover, "{2}")
	endIf
	
	if (page == "Status")
		AddHeaderOption("Body Alteration Ranks")
		AddTextOption("Eye alteration status ", dba_player.GetFactionRank(dba_Eye))
		AddTextOption("Mouth alteration status ", dba_player.GetFactionRank(dba_Mouth))
		AddTextOption("Neck alteration status ", dba_player.GetFactionRank(dba_Neck))
		AddTextOption("Arm alteration status ", dba_player.GetFactionRank(dba_Arm))
		AddTextOption("Hand alteration status ", dba_player.GetFactionRank(dba_Hand))
		AddTextOption("Breast alteration status ", dba_player.GetFactionRank(dba_Breast))
		AddTextOption("Waist alteration status ", dba_player.GetFactionRank(dba_Waist))
		AddTextOption("Butt alteration status ", dba_player.GetFactionRank(dba_Butt))
		AddTextOption("Anus alteration status ", dba_player.GetFactionRank(dba_Anus))
		AddTextOption("Vagina alteration status ", dba_player.GetFactionRank(dba_Vagina))
		AddTextOption("Leg alteration status ", dba_player.GetFactionRank(dba_Leg))
		AddTextOption("Foot alteration status ", dba_player.GetFactionRank(dba_Foot))
		AddTextOption("Weight alteration status ", dba_player.GetFactionRank(dba_Weight))
	endIf
	
	if (page == "Debug")
		debuglogenabledOID = AddToggleOption("Debug to log enabled", debuglogenabled)
		debugenabledOID = AddToggleOption("Debug notifications enabled", debugenabled)
	endIf
		
	
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

Event OnOptionSliderAccept(int option, float value)
	
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
		maxspeedmult = value as float
		SetSliderOptionValue(option, maxspeedmult, "{0}%")
	elseif option == minspeedmultOID
		minspeedmult = value as float
		SetSliderOptionValue(option, minspeedmult, "{0}%")
	elseif option == heeldebuffOID
		heeldebuff = value as float
		SetSliderOptionValue(option, heeldebuff, "{1}")
	elseif option == legdebuffOID
		legdebuff = value as float
		SetSliderOptionValue(option, legdebuff, "{1}")
	elseif option == MMEbreastmaxOID
		mmebreastmax = value as float
		SetSliderOptionValue(option, mmebreastmax, "{1}")
	endif

;###########Alteration###########	
	if option == eyeOID
		eye = value as float
		SetSliderOptionValue(option, eye, "{0}")
	elseif option == mouthOID
		mouth = value as float
		SetSliderOptionValue(option, mouth, "{0}")
	elseif option == neckOID
		neck = value as float
		SetSliderOptionValue(option, neck, "{0}")
	elseif option == armOID
		arm = value as float
		SetSliderOptionValue(option, arm, "{0}")
	elseif option == handOID
		hand = value as float
		SetSliderOptionValue(option, hand, "{0}")
	elseif option == breastOID
		breast = value as float
		SetSliderOptionValue(option, breast, "{0}")
	elseif option == waistOID
		waist = value as float
		SetSliderOptionValue(option, waist, "{0}")
	elseif option == buttOID
		butt = value as float
		SetSliderOptionValue(option, butt, "{0}")
	elseif option == anusOID
		anus = value as float
		SetSliderOptionValue(option, anus, "{0}")
	elseif option == vaginaOID
		vagina = value as float
		SetSliderOptionValue(option, vagina, "{0}")
	elseif option == legOID
		leg = value as float
		SetSliderOptionValue(option, leg, "{0}")
	elseif option == footOID
		foot = value as float
		SetSliderOptionValue(option, foot, "{0}")
	endIf
	
;###########Recovery###########
	if option == eyerecoverOID
		eyerecover = value as float
		SetSliderOptionValue(option, eyerecover, "{2}")
	elseif option == mouthrecoverOID
		mouthrecover = value as float
		SetSliderOptionValue(option, mouthrecover, "{2}")
	elseif option == neckrecoverOID
		neckrecover = value as float
		SetSliderOptionValue(option, neckrecover, "{2}")
	elseif option == armrecoverOID
		armrecover = value as float
		SetSliderOptionValue(option, armrecover, "{2}")
	elseif option == handrecoverOID
		handrecover = value as float
		SetSliderOptionValue(option, handrecover, "{2}")
	elseif option == breastrecoverOID
		breastrecover = value as float
		SetSliderOptionValue(option, breastrecover, "{2}")
	elseif option == waistrecoverOID
		waistrecover = value as float
		SetSliderOptionValue(option, waistrecover, "{2}")
	elseif option == buttrecoverOID
		buttrecover = value as float
		SetSliderOptionValue(option, buttrecover, "{2}")
	elseif option == anusrecoverOID
		anusrecover = value as float
		SetSliderOptionValue(option, anusrecover, "{2}")
	elseif option == vaginarecoverOID
		vaginarecover = value as float
		SetSliderOptionValue(option, vaginarecover, "{2}")
	elseif option == legrecoverOID
		legrecover = value as float
		SetSliderOptionValue(option, legrecover, "{2}")
	elseif option == footrecoverOID
		footrecover = value as float
		SetSliderOptionValue(option, footrecover, "{2}")
	endIf

endEvent

Event OnOptionHighlight (int option)
	
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
	endIf

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
	endIf
	
endEvent

event OnOptionMenuOpen(int option)

;###########General##############

endEvent

event OnOptionMenuAccept(int option, int index)

;###########General##############

endEvent

event OnOptionSelect (int option)

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
	elseif (option == mmeOID)
		mme =!mme
		SetToggleOptionValue(mmeOID, mme)
	endif

;###########Alteration###########	
	if(option == weightOID)
		weight = !weight
		SetToggleOptionValue(weightOID, weight)
	elseif (option == waistaltOID)
		waistalt = !waistalt
		SetToggleOptionValue(waistaltOID, waistalt)
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
