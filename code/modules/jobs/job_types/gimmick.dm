/datum/job/gimmick //gimmick var must be set to true for all gimmick jobs BUT the parent
	title = "Gimmick"
	flag = GIMMICK
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "no one"
	selection_color = "#dddddd"
	chat_color = "#FFFFFF"

	exp_type_department = EXP_TYPE_GIMMICK

	access = list(ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MAINT_TUNNELS)
	paycheck = PAYCHECK_ASSISTANT
	paycheck_department = ACCOUNT_CIV

	display_order = JOB_DISPLAY_ORDER_ASSISTANT
	departments = DEPARTMENT_SERVICE
	rpg_title = "Peasant"

	allow_bureaucratic_error = FALSE
	outfit = /datum/outfit/job/gimmick

/datum/outfit/job/gimmick
	can_be_admin_equipped = FALSE // we want just the parent outfit to be unequippable since this leads to problems

/datum/job/gimmick/barber
	title = "Barber"
	flag = BARBER
	outfit = /datum/outfit/job/gimmick/barber
	access = list(ACCESS_MORGUE, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MORGUE, ACCESS_MAINT_TUNNELS)
	total_positions = 1 //MonkeStation Edit: Gimmick Latejoin
	gimmick = TRUE
	chat_color = "#bd9e86"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman
	)

/datum/outfit/job/gimmick/barber
	name = "Barber"
	jobtype = /datum/job/gimmick/barber

	belt = /obj/item/pda/unlicensed
	ears = /obj/item/radio/headset
	uniform = /obj/item/clothing/under/suit/sl
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/storage/wallet
	l_pocket = /obj/item/razor/straightrazor
	can_be_admin_equipped = TRUE

/datum/job/gimmick/magician
	title = "Stage Magician"
	flag = MAGICIAN
	outfit = /datum/outfit/job/gimmick/magician
	access = list(ACCESS_THEATRE, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_THEATRE, ACCESS_MAINT_TUNNELS)
	total_positions = 1 //MonkeStation Edit: Gimmick Latejoin
	gimmick = TRUE
	chat_color = "#b898b3"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/magic
	)

/datum/outfit/job/gimmick/magician
	name = "Stage Magician"
	jobtype = /datum/job/gimmick/magician

	belt = /obj/item/pda/unlicensed
	head = /obj/item/clothing/head/that
	ears = /obj/item/radio/headset
	neck = /obj/item/bedsheet/magician
	uniform = /obj/item/clothing/under/suit/black_really
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/white
	l_hand = /obj/item/cane
	backpack_contents = list(/obj/item/choice_beacon/magic=1)
	can_be_admin_equipped = TRUE

/datum/job/gimmick/hobo
	title = "Debtor"
	flag = HOBO
	outfit = /datum/outfit/job/gimmick/hobo
	access = list(ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MAINT_TUNNELS)
	total_positions = 2 //MonkeStation Edit: Gimmick Latejoin
	gimmick = TRUE
	chat_color = "#929292"
	departments = NONE		//being hobo is not a real job
	biohazard = 50 //hobos are very likely to have diseases

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/hobo
	)

/datum/outfit/job/gimmick/hobo
	name = "Debtor"
	jobtype = /datum/job/gimmick/hobo
	belt = /obj/item/pda/unlicensed
	head = /obj/item/clothing/head/foilhat
	ears = null //hobos dont start with a headset
	uniform = /obj/item/clothing/under/pants/jeans
	suit = /obj/item/clothing/suit/jacket
	can_be_admin_equipped = TRUE

//MonkeStation Edit: Hobos start as stowaways. This is copypasta as adding this trait post-start doesn't work.
/datum/job/gimmick/hobo/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	H.add_quirk(/datum/quirk/stowaway)
	var/mob/living/carbon/human/hobo = H
	hobo.Sleeping(5 SECONDS, TRUE, TRUE) //This is both flavorful and gives time for the rest of the code to work.
	var/obj/structure/closet/selected_closet = get_unlocked_closed_locker() //Find your new home
	if(selected_closet)
		hobo.forceMove(selected_closet) //Move in
//MonkeStation Edit End


/datum/outfit/job/gimmick/hobo/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	to_chat(H, "<span class='userdanger'>Although you're down on your luck, you're still a nanotrasen employee, and you are held to the same legal standards.</span>")
	var/list/possible_drugs = list(/obj/item/storage/pill_bottle/happy, /obj/item/storage/pill_bottle/zoom, /obj/item/storage/pill_bottle/stimulant, /obj/item/storage/pill_bottle/lsd, /obj/item/storage/pill_bottle/aranesp, /obj/item/storage/pill_bottle/floorpill/full)
	var/chosen_drugs = pick(possible_drugs)
	var/obj/item/storage/pill_bottle/I = new chosen_drugs(src)
	H.equip_to_slot_or_del(I,ITEM_SLOT_BACKPACK)
	var/datum/martial_art/psychotic_brawling/junkie = new //this fits well, but i'm unsure about it, cuz this martial art is so fucking rng dependent i swear...
	junkie.teach(H)
	ADD_TRAIT(H, TRAIT_APPRAISAL, JOB_TRAIT)


/datum/job/gimmick/shrink
	title = "Psychiatrist"
	flag = SHRINK
	outfit = /datum/outfit/job/gimmick/shrink
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MEDICAL)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_MEDICAL)
	total_positions = 1 //MonkeStation Edit: Gimmick Latejoin
	paycheck = PAYCHECK_EASY
	gimmick = TRUE
	chat_color = "#a2dfdc"
	departments = DEPARTMENT_MEDICAL

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman
	)

/datum/outfit/job/gimmick/shrink //psychiatrist doesnt get much shit, but he has more access and a cushier paycheck
	name = "Psychiatrist"
	jobtype = /datum/job/gimmick/shrink

	belt = /obj/item/pda/medical
	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/suit/black
	shoes = /obj/item/clothing/shoes/laceup
	backpack_contents = list(/obj/item/choice_beacon/pet/ems=1)
	can_be_admin_equipped = TRUE

/datum/job/gimmick/celebrity
	title = "VIP"
	flag = CELEBRITY
	outfit = /datum/outfit/job/gimmick/celebrity
	access = list(ACCESS_MAINT_TUNNELS) //Assistants with shitloads of money, what could go wrong?
	minimal_access = list(ACCESS_MAINT_TUNNELS)
	total_positions = 1 //MonkeStation Edit: Gimmick Latejoin
	gimmick = TRUE
	paycheck = PAYCHECK_VIP //our power is being fucking rich
	chat_color = "#ebc96b"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/vip
	)

/datum/outfit/job/gimmick/celebrity
	name = "VIP"
	jobtype = /datum/job/gimmick/celebrity

	belt = /obj/item/pda/celebrity
	glasses = /obj/item/clothing/glasses/sunglasses/advanced
	ears = /obj/item/radio/headset/heads //VIP can talk loud for no reason
	uniform = /obj/item/clothing/under/suit/black_really
	shoes = /obj/item/clothing/shoes/laceup
	can_be_admin_equipped = TRUE
