#define MAX_DENT_DECALS 15

/turf/closed/wall
	name = "wall"
	desc = "A huge chunk of metal used to separate rooms."
	icon = 'icons/turf/walls/wall.dmi'
	icon_state = "wall"
	explosion_block = 1

	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	baseturfs = /turf/open/floor/plating

	flags_ricochet = RICOCHET_HARD

	FASTDMM_PROP(\
		pipe_astar_cost = 35\
	)

	var/hardness = 40 //lower numbers are harder. Used to determine the probability of a hulk smashing through.
	var/slicing_duration = 100  //default time taken to slice the wall
	var/sheet_type = /obj/item/stack/sheet/iron
	var/sheet_amount = 2
	var/girder_type = /obj/structure/girder

	canSmoothWith = list(
	/turf/closed/wall,
	/turf/closed/wall/r_wall,
	/obj/structure/falsewall,
	/obj/structure/falsewall/brass,
	/obj/structure/falsewall/reinforced,
	/turf/closed/wall/rust,
	/turf/closed/wall/r_wall/rust,
	/turf/closed/wall/clockwork,
	//MONKESTATION EDIT BEGIN - WINDOW AND WALL RESPRITE
	/obj/structure/window/fulltile,
	/obj/structure/window/plasma/fulltile,
	/obj/structure/window/reinforced/fulltile,
	/obj/structure/window/reinforced/tinted/fulltile,
	/obj/machinery/door/airlock, //Hey, did you know that it's purposeful that this list requires strict typing? FUN.
	/obj/machinery/door/airlock/command,
	/obj/machinery/door/airlock/security,
	/obj/machinery/door/airlock/engineering,
	/obj/machinery/door/airlock/medical,
	/obj/machinery/door/airlock/maintenance,
	/obj/machinery/door/airlock/maintenance/external,
	/obj/machinery/door/airlock/mining,
	/obj/machinery/door/airlock/atmos,
	/obj/machinery/door/airlock/research,
	/obj/machinery/door/airlock/freezer,
	/obj/machinery/door/airlock/science,
	/obj/machinery/door/airlock/virology,
	/obj/machinery/door/airlock/gold,
	/obj/machinery/door/airlock/silver,
	/obj/machinery/door/airlock/diamond,
	/obj/machinery/door/airlock/uranium,
	/obj/machinery/door/airlock/plasma,
	/obj/machinery/door/airlock/bananium,
	/obj/machinery/door/airlock/sandstone,
	/obj/machinery/door/airlock/wood,
	/obj/machinery/door/airlock/public,
	/obj/machinery/door/airlock/external,
	/obj/machinery/door/airlock/arrivals_external,
	/obj/machinery/door/airlock/centcom,
	/obj/machinery/door/airlock/grunge,
	/obj/machinery/door/airlock/vault,
	/obj/machinery/door/airlock/hatch,
	/obj/machinery/door/airlock/maintenance_hatch,
	/obj/machinery/door/airlock/highsecurity,
	/obj/machinery/door/airlock/glass_large,
	/obj/machinery/door/airlock/glass,
	/obj/machinery/door/airlock/command/glass,
	/obj/machinery/door/airlock/security/glass,
	/obj/machinery/door/airlock/engineering/glass,
	/obj/machinery/door/airlock/medical/glass,
	/obj/machinery/door/airlock/maintenance/glass,
	/obj/machinery/door/airlock/maintenance/external/glass,
	/obj/machinery/door/airlock/mining/glass,
	/obj/machinery/door/airlock/atmos/glass,
	/obj/machinery/door/airlock/research/glass,
	/obj/machinery/door/airlock/science/glass,
	/obj/machinery/door/airlock/virology/glass,
	/obj/machinery/door/airlock/gold/glass,
	/obj/machinery/door/airlock/silver/glass,
	/obj/machinery/door/airlock/diamond/glass,
	/obj/machinery/door/airlock/uranium/glass,
	/obj/machinery/door/airlock/plasma/glass,
	/obj/machinery/door/airlock/bananium/glass,
	/obj/machinery/door/airlock/sandstone/glass,
	/obj/machinery/door/airlock/wood/glass,
	/obj/machinery/door/airlock/public/glass,
	/obj/machinery/door/airlock/external/glass)
	//MONKESTATION EDIT END
	smooth = SMOOTH_TRUE

	var/list/dent_decals

/turf/closed/wall/Initialize(mapload)
	. = ..()
	if(is_station_level(z))
		GLOB.station_turfs += src

/turf/closed/wall/Destroy()
	if(is_station_level(z))
		GLOB.station_turfs -= src
	return ..()

/turf/closed/wall/examine(mob/user)
	. += ..()
	. += deconstruction_hints(user)

/turf/closed/wall/proc/deconstruction_hints(mob/user)
	return "<span class='notice'>The outer plating is <b>welded</b> firmly in place.</span>"

/turf/closed/wall/attack_tk()
	return

/turf/closed/wall/proc/dismantle_wall(devastated=0, explode=0)
	if(devastated)
		devastate_wall()
	else
		playsound(src, 'sound/items/welder.ogg', 100, 1)
		var/newgirder = break_wall()
		if(newgirder) //maybe we don't /want/ a girder!
			transfer_fingerprints_to(newgirder)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O, /obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)

	ScrapeAway()

/turf/closed/wall/proc/break_wall()
	new sheet_type(src, sheet_amount)
	return new girder_type(src)

/turf/closed/wall/proc/devastate_wall()
	new sheet_type(src, sheet_amount)
	if(girder_type)
		new /obj/item/stack/sheet/iron(src)

/turf/closed/wall/ex_act(severity, target)
	if(target == src)
		dismantle_wall(1,1)
		return
	switch(severity)
		if(1)
			//SN src = null
			var/turf/NT = ScrapeAway()
			NT.contents_explosion(severity, target)
			return
		if(2)
			if (prob(50))
				dismantle_wall(0,1)
			else
				dismantle_wall(1,1)
		if(3)
			if (prob(hardness))
				dismantle_wall(0,1)
	if(!density)
		..()


/turf/closed/wall/blob_act(obj/structure/blob/B)
	if(prob(50))
		dismantle_wall()
	else
		add_dent(WALL_DENT_HIT)

/turf/closed/wall/mech_melee_attack(obj/mecha/M)
	M.do_attack_animation(src)
	switch(M.damtype)
		if(BRUTE)
			playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
			M.visible_message("<span class='danger'>[M.name] hits [src]!</span>", \
							"<span class='danger'>You hit [src]!</span>", null, COMBAT_MESSAGE_RANGE)
			if(prob(hardness + M.force) && M.force > 20)
				dismantle_wall(1)
				playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			else
				add_dent(WALL_DENT_HIT)
		if(BURN)
			playsound(src, 'sound/items/welder.ogg', 100, 1)
		if(TOX)
			playsound(src, 'sound/effects/spray2.ogg', 100, 1)
			return FALSE

/turf/closed/wall/attack_paw(mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	return attack_hand(user)


/turf/closed/wall/attack_animal(mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	if((M.environment_smash & ENVIRONMENT_SMASH_WALLS) || (M.environment_smash & ENVIRONMENT_SMASH_RWALLS))
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
		dismantle_wall(1)
		return

/turf/closed/wall/attack_hulk(mob/user, does_attack_animation = 0)
	..(user, 1)
	if(prob(hardness))
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ), forced = "hulk")
		dismantle_wall(1)
	else
		playsound(src, 'sound/effects/bang.ogg', 50, 1)
		add_dent(WALL_DENT_HIT)
		user.visible_message("<span class='danger'>[user] smashes \the [src]!</span>", \
					"<span class='danger'>You smash \the [src]!</span>", \
					"<span class='italics'>You hear a booming smash!</span>")

	return TRUE

/turf/closed/wall/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	to_chat(user, "<span class='notice'>You push the wall but nothing happens!</span>")
	playsound(src, 'sound/weapons/genhit.ogg', 25, 1)
	add_fingerprint(user)

/turf/closed/wall/attackby(obj/item/W, mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	//get the user's location
	if(!isturf(user.loc))
		return	//can't do this stuff whilst inside objects and such

	add_fingerprint(user)

	var/turf/T = user.loc	//get user's location for delay checks

	//the istype cascade has been spread among various procs for easy overriding
	if(try_clean(W, user, T) || try_wallmount(W, user, T) || try_decon(W, user, T) || try_destroy(W, user, T))
		return

	return ..()

/turf/closed/wall/proc/try_clean(obj/item/W, mob/user, turf/T)
	if((user.a_intent != INTENT_HELP) || !LAZYLEN(dent_decals))
		return FALSE

	if(W.tool_behaviour == TOOL_WELDER)
		if(!W.tool_start_check(user, amount=0))
			return FALSE

		balloon_alert(user, "You begin fixing dents on the wall")
		if(W.use_tool(src, user, 0, volume=100))
			if(iswallturf(src) && LAZYLEN(dent_decals))
				balloon_alert(user, "Some dents on the wall were fixed")
				cut_overlay(dent_decals)
				dent_decals.Cut()
			return TRUE

	return FALSE

/turf/closed/wall/proc/try_wallmount(obj/item/W, mob/user, turf/T)
	//check for wall mounted frames
	if(istype(W, /obj/item/wallframe))
		var/obj/item/wallframe/F = W
		if(F.try_build(src, user))
			F.attach(src, user)
		return TRUE
	//Poster stuff
	else if(istype(W, /obj/item/poster))
		place_poster(W,user)
		return TRUE
	return FALSE


/turf/closed/wall/proc/try_decon(obj/item/I, mob/user, turf/T)
	if(I.tool_behaviour == TOOL_WELDER)
		if(!I.tool_start_check(user, amount=0))
			return FALSE

		balloon_alert(user, "You start slicing through outer plating")
		if(I.use_tool(src, user, slicing_duration, volume=100))
			if(iswallturf(src))
				balloon_alert(user, "Outer plating removed")
				dismantle_wall()
			return TRUE

	return FALSE


/turf/closed/wall/proc/try_destroy(obj/item/I, mob/user, turf/T)
	if(istype(I, /obj/item/pickaxe/drill/jackhammer))
		if(!iswallturf(src))
			return TRUE
		if(user.loc == T)
			I.play_tool_sound(src)
			dismantle_wall()
			user.visible_message("<span class='warning'>[user] smashes through [src] with [I]!</span>", \
								"<span class='warning'>You smash through [src] with [I]!</span>", \
								"<span class='italics'>You hear the grinding of metal.</span>")
			return TRUE
	return FALSE

/turf/closed/wall/singularity_pull(S, current_size)
	..()
	wall_singularity_pull(current_size)

/turf/closed/wall/proc/wall_singularity_pull(current_size)
	if(current_size >= STAGE_FIVE)
		if(prob(50))
			dismantle_wall()
		return
	if(current_size == STAGE_FOUR)
		if(prob(30))
			dismantle_wall()

/turf/closed/wall/narsie_act(force, ignore_mobs, probability = 20)
	. = ..()
	if(.)
		ChangeTurf(/turf/closed/wall/mineral/cult)

/turf/closed/wall/ratvar_act(force, ignore_mobs)
	. = ..()
	if(.)
		ChangeTurf(/turf/closed/wall/clockwork)

/turf/closed/wall/get_dumping_location(obj/item/storage/source, mob/user)
	return null

/turf/closed/wall/acid_act(acidpwr, acid_volume)
	if(explosion_block >= 2)
		acidpwr = min(acidpwr, 50) //we reduce the power so strong walls never get melted.
	. = ..()

/turf/closed/wall/acid_melt()
	dismantle_wall(1)

/turf/closed/wall/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 40, "cost" = 26)
	return FALSE

/turf/closed/wall/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, "<span class='notice'>You deconstruct the wall.</span>")
			ScrapeAway()
			return TRUE
	return FALSE

/turf/closed/wall/proc/add_dent(denttype, x=rand(-8, 8), y=rand(-8, 8))
	if(LAZYLEN(dent_decals) >= MAX_DENT_DECALS)
		return

	var/mutable_appearance/decal = mutable_appearance('icons/effects/effects.dmi', "", BULLET_HOLE_LAYER)
	switch(denttype)
		if(WALL_DENT_SHOT)
			decal.icon_state = "bullet_hole"
		if(WALL_DENT_HIT)
			decal.icon_state = "impact[rand(1, 3)]"

	decal.pixel_x = x
	decal.pixel_y = y

	if(LAZYLEN(dent_decals))
		cut_overlay(dent_decals)
		dent_decals += decal
	else
		dent_decals = list(decal)

	add_overlay(dent_decals)

/turf/closed/wall/rust_heretic_act()
	if(prob(70))
		new /obj/effect/temp_visual/glowing_rune(src)
	ChangeTurf(/turf/closed/wall/rust)

#undef MAX_DENT_DECALS
