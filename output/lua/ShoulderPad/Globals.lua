-- Max players allowed in game
kMaxPlayers = 52
do
	local shoulderPads = {
		"8Bit",
		"Alien4",
		"Allen",
		"Approved",
		"Atoku",
		"Avenger",
		"Cactuar",
		"che",
		"Confederate",
		"Dilligaf",
		"dog",
		"Duck",
		"fbshoulder",
		"Fire",
		"Gandalf",
		"Gretel",
		"karrot",
		"Lerk",
		"MajorK",
		"majorkusanagi",
		"MalpraveShoulder",
		"MvM Event Nov 2017",
		"Nalice",
		"Nogizaka 46",
		"NS2:Combat Event",
		"O.R.A. Playtest",
		"Otter_Patch",
		"Pacific",
		"Paldon",
		"parche",
		"Patch52",
		"Priest",
		"QuackerJack",
		"Redguy",
		"Rose",
		"Tank",
		"Tanstaafl",
		"uwu",
		"Wooza Approved Patch",
		"wooza1",
		"Yolo",
		"Yolo2",
		"Yolo3",
		"ZycaR",
		"Spec Ops Hardman",
		"Space Cowboy"
	}
	
	function insertShoulderPad(name, value)
		table.insert(kShoulderPadNames, name)
		-- true does "disable it"
		-- 0 does enable it - but can't be disabled
		-- >0 does check if the user has access
		table.insert(kShoulderPad2ItemId, value) -- true makes it actually skip it
	end
	
	-- Original sprite has 20 images, so we start at 21
	local emptyCount = 20 - (#kShoulderPadNames + 1)
	for i = 1, emptyCount do
		insertShoulderPad("Dummy", true)
	end
	
	for i= 1, #shoulderPads do
		insertShoulderPad(shoulderPads[i], 40000)
	end
end


local ShoulderPadUsers = {
	[235367954] = {
		-- Meteru
		"Cactuar", "NS2:Combat Event"
	},
	[60458326] = {
		-- Las
		"O.R.A. Playtest", "NS2:Combat Event"
	},
	[57727861] = {
		-- wooza
		"wooza1", "O.R.A. Playtest", "NS2:Combat Event", "MvM Event Nov 2017"
	},
	[168118670] = {
		-- redd
		"wooza1", "O.R.A. Playtest", "NS2:Combat Event"
	},
	[159094373] = {
		-- Boss
		"O.R.A. Playtest"
	},
	[40820346]= {
		-- ZycaR
		"ZycaR", "NS2:Combat Event"
	},
	[132554895]= {
		"Fire"
	},
	[213294887]= {
		-- Waldo
		"uwu"
	},
	[118678504]= {
		-- Nalice
		"Nalice", "O.R.A. Playtest", "NS2:Combat Event"
	},
	[96252419]= {
		-- yumi_wakatsuki
		"Nogizaka 46"
	},
	[54048007]= {
		-- Underdog
		"MajorK"
	},
	[68947182]= {
		--
		"Tank"
	},
	[33531283]= {
		-- Xenomorphia
		"Otter_Patch"
	},
	[1727345]= {
		--
		"NovemberJuliet"
	},
	[57326008]= {
		-- QuackerJack
		"QuackerJack"
	},
	[100233870]= {
		--
		"Tanstaafl"
	},
	[56706930]= {
		--
		"parche", "Che"
	},
	[68692084]= {
		--
		"Duck"
	},
	[129329244]= {
		-- FROSTEROID
		"NS2:Combat Event"
	},
	[62770714]= {
		-- ehlek70
		"NS2:Combat Event"
	},
	[52798326]= {
		-- Chap Chappington
		"NS2:Combat Event"
	},
	[2691723]= {
		-- [FLG] [ = AleX= ] AR
		"NS2:Combat Event"
	},
	[44177021]= {
		-- Degu
		"NS2:Combat Event"
	},
	[42135872]= {
		-- Valkol
		"NS2:Combat Event"
	},
	[78397579]= {
		-- Elusive
		"NS2:Combat Event"
	},
	[34509961]= {
		-- ehman
		"NS2:Combat Event"
	},
	[207115488]= {
		-- Royal Chaos
		"NS2:Combat Event"
	},
	[114113738]= {
		-- NiceUrsa
		"NS2:Combat Event"
	},
	[47348197]= {
		-- Huudi
		"NS2:Combat Event"
	},
	[82559559]= {
		-- Shootinmutant
		"NS2:Combat Event"
	},
	[279183122]= {
		-- Rick harrison
		"NS2:Combat Event"
	},
	[1392304]= {
		-- DG
		"O.R.A. Playtest"
	},
	[115771342]= {
		-- eternal
		"O.R.A. Playtest"
	},
	[5658621]= {
		-- jumptard! heatley
		"O.R.A. Playtest"
	},
	[51318124]= {
		--Majesty
		"O.R.A. Playtest"
	},
	[42447363]= {
		-- Splash
		"O.R.A. Playtest"
	},
	[121067532]= {
		-- Packleader
		"O.R.A. Playtest"
	},
	[55494803]= {
		-- Moni
		"O.R.A. Playtest"
	},
	[841449]= {
		-- .refleX
		"O.R.A. Playtest"
	},
	[13581704]= {
		-- Ebe. Scrooge
		"O.R.A. Playtest"
	},
	[51829548]= {
		-- Timlox
		"O.R.A. Playtest"
	},
	[3186435]= {
		-- ANZIKTE
		"O.R.A. Playtest"
	},
	[74748775]= {
		-- Chokosnogen
		"O.R.A. Playtest"
	},
	[102613707]= {
		-- ScopS
		"O.R.A. Playtest"
	},
	[118634950]= {
		-- KrissirK
		"O.R.A. Playtest"
	},
	[337826080]= {
		-- cryptanthus
		"O.R.A. Playtest"
	},
	[121608212]= {
		-- Senpai Salt
		"O.R.A. Playtest"
	},
	[42248413]= {
		-- Fokus The Fucking Po
		"O.R.A. Playtest"
	},
	[31156068]= {
		-- CF ProctoR
		"O.R.A. Playtest"
	},
	[5212942]= {
		-- Spam meds
		"O.R.A. Playtest"
	},
	[324715]= {
		-- Snaker
		"O.R.A. Playtest"
	},
	[8086089]= {
		-- jordan.seeding
		"O.R.A. Playtest"
	},
	[302851218]= {
		-- la furher du dragon
		"O.R.A. Playtest"
	},
	[144472969]= {
		-- Jaymer
		"O.R.A. Playtest"
	},
	[308406311]= {
		-- Kiss Kiss (Raizo)
		"O.R.A. Playtest"
	},
	[93518654]= {
		-- Moldy Cheese
		"O.R.A. Playtest"
	},
	[64491797]= {
		-- Emily1991
		"O.R.A. Playtest"
	},
	[110841189]= {
		-- wave function
		"O.R.A. Playtest"
	},
	[118101066]= {
		-- StullenAndi
		"O.R.A. Playtest"
	},
	[10675335]= {
		-- peyote
		"O.R.A. Playtest"
	},
	[2999401]= {
		-- Blank Face
		"O.R.A. Playtest"
	},
	[54875390]= {
		-- Nobody
		"O.R.A. Playtest"
	},
	[55857513]= {
		-- Ratibor
		"O.R.A. Playtest"
	},
	[56698614]= {
		-- iuop^
		"O.R.A. Playtest"
	},
	[6683173]= {
		-- M'Lord
		"O.R.A. Playtest"
	},
	[20967862]= {
		-- DikhardPicard
		"O.R.A. Playtest"
	},
	[2111065]= {
		-- Roughneck
		"O.R.A. Playtest"
	},
	[83696508]= {
		-- Anonymous TITAN
		"O.R.A. Playtest"
	},
	[68083081]= {
		-- Classix
		"O.R.A. Playtest"
	},
	[1488247]= {
		-- Makiao
		"O.R.A. Playtest"
	},
	[98663180]= {
		-- asket
		"O.R.A. Playtest"
	},
	[307970704]= {
		-- devko
		"O.R.A. Playtest"
	},
	[50356962]= {
		-- CracK_Head
		"O.R.A. Playtest", "NS2:Combat Event"
	},
	[1461054]= {
		-- DCMAKER
		"O.R.A. Playtest"
	},
	[59740040]= {
		-- La sale bête
		"O.R.A. Playtest"
	},
	[3825532]= {
		-- liggs
		"O.R.A. Playtest"
	},
	[180546976]= {
		-- Eazy
		"O.R.A. Playtest"
	},
	[290676252]= {
		-- Morgoth
		"O.R.A. Playtest"
	},
	[104438895]= {
		-- Igor
		"O.R.A. Playtest"
	},
	[23353464]= {
		-- Bob Arctor
		"O.R.A. Playtest"
	},
	[76042603]= {
		-- Red October
		"O.R.A. Playtest"
	},
	[211197]= {
		-- Oka
		"O.R.A. Playtest"
	},
	[28135490]= {
		-- Oreo
		"O.R.A. Playtest"
	},
	[159285794]= {
		-- Yoda 084
		"O.R.A. Playtest"
	},
	[1175486]= {
		-- TAW'Magotchi Johan
		"O.R.A. Playtest"
	},
	[2451483]= {
		-- Alt+F4
		"O.R.A. Playtest"
	},
	[7473231]= {
		-- Hiders dad
		"O.R.A. Playtest"
	},
	[119991274]= {
		-- Havok
		"O.R.A. Playtest"
	},
	[000000000]= {
		-- Waddles
		"O.R.A. Playtest", "NS2:Combat Event"
	},
	[85890438]= {
		-- Yolo Lolo
		"Yolo", "NS2:Combat Event", "Yolo2", "Yolo3"
	},
	[3272775]= {
		--
		"Redguy"
	},
	[288803406]= {
		-- Muse
		"Rose"
	},
	[9253808]= {
		-- bus
		"fbshoulder"
	},
	[29486017]= {
		-- Dog
		"O.R.A. Playtest", "NS2:Combat Event"
	},
	[49080647]= {
		--
		"karrot", "NS2:Combat Event"
	},
	[3194400]= {
		--
		"Pacific", "Avenger", "MalpraveShoulder"
	},
	[5762487]= {
		--
		"NS2:Combat Event"
	},
	[25227466]= {
		--
		"Dilligaf", "O.R.A. Playtest"
	},
	[52053844]= {
		--
		"Lerk", "O.R.A. Playtest"
	},
	[98320555]= {
		--
		"NS2:Combat Event"
	},
	[28024011]= {
		--
		"Alien4"
	},
	[4775308]= {
		-- Tex
		"O.R.A. Playtest"
	},
	[3822121]= {
		-- Fazza
		"8Bit"
	},
	[111193796]= {
		-- Henriquecs
		"NS2:Combat Event"
	},
	[66369749]= {
		-- theseffy
		"NS2:Combat Event"
	},
	[32522015]= {
		-- gc d4rk ant
		"NS2:Combat Event"
	},
	[64063]= {
		-- ZerZ
		"O.R.A. Playtest"
	},
	[3325858]= {
		-- Uncle Chicken
		"O.R.A. Playtest", "NS2:Combat Event"
	},
	[210057430]= {
		-- Princess Cathy
		"O.R.A. Playtest"
	},
	[35331740]= {
		-- Parcoon
		"Patch52"
	},
	[67791683]= {
		-- Gretel Mk Monkey
		"Gretel", "O.R.A. Playtest"
	},
	[44249910]= {
		-- immortalking
		"NS2:Combat Event"
	},
	[3893507]= {
		-- Arkanum
		"NS2:Combat Event"
	},
	[47345795]= {
		-- Katzenfleisch
		"Priest"
	},
	[32532420]= {
		-- derv.god
		"O.R.A. Playtest"
	},
	[84566694]= {
		-- Black Forest Cake
		"O.R.A. Playtest"
	},
	[988933]= {
		-- Brute
		"O.R.A. Playtest"
	},
	[119788994]= {
		-- Pereba
		"O.R.A. Playtest"
	},
	[43005456]= {
		-- Spec Ops Hardman
		"Spec Ops Hardman"
	},
	[76208664]={
		-- Atoku
		"Atoku"
	},
	[90064642]={
		-- Möxl (SpaceCowboy)
		"Space Cowboy"
	},
	[6132501]={
		-- Paldon
		"Paldon"
	}
}

local oldGetHasShoulderPad = GetHasShoulderPad
function GetHasShoulderPad(index, client)

	if kShoulderPad2ItemId[index] == 40000 then
		local itemName = kShoulderPadNames[index]

		local userid
		if Client then
			userid = Client.GetSteamId()
		elseif client then
			userid = client:GetUserId()
		end

		if userid and ShoulderPadUsers[userid] then
			for i= 1, #ShoulderPadUsers[userid] do
				if ShoulderPadUsers[userid][i] == itemName then
					return true
				end
			end
		end

		return false
	end

	return oldGetHasShoulderPad(index, client)
end

local oldGetOwnsItem = GetOwnsItem
function GetOwnsItem( itemId, client )
	return itemId == 40000 or oldGetOwnsItem(itemId,client)
end

local oldGetIsItemThunderdomeUnlock = GetIsItemThunderdomeUnlock
function GetIsItemThunderdomeUnlock( itemId )
	if itemId == true then
		return false
	else
		oldGetIsItemThunderdomeUnlock(itemId)
	end
end