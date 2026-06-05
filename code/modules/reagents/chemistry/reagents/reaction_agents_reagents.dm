/datum/reagent/reaction_agent
	name = "Reaction Agent"
	description = "Hello! I am a bugged reagent. Please report me for my crimes. Thank you!!"

/datum/reagent/reaction_agent/intercept_reagents_transfer(datum/reagents/target, amount)
	if(!target)
		return FALSE
	if(target.flags & NO_REACT)
		return FALSE
	if(target.has_reagent(/datum/reagent/stabilizing_agent))
		return FALSE
	if(LAZYLEN(target.reagent_list) == 0)
		return FALSE
	if(LAZYLEN(target.reagent_list) == 1)
		if(target.has_reagent(type)) //Allow dispensing into self
			return FALSE
	return TRUE

/datum/reagent/reaction_agent/acidic_buffer
	name = "Strong Acidic Buffer"
	description = "This reagent will consume itself and move the pH of a beaker towards acidity when added to another."
	color = "#fbc314"
	ph = 0
	inverse_chem = null
	fallback_icon = 'icons/obj/drinks/drink_effects.dmi'
	fallback_icon_state = "acid_buffer_fallback"
	glass_price = DRINK_PRICE_HIGH

//Consumes self on addition and shifts ph
/datum/reagent/reaction_agent/acidic_buffer/intercept_reagents_transfer(datum/reagents/target, amount)
	. = ..()
	if(!.)
		return

	//do the ph change
	var/message
	if(target.ph <= ph)
		message = "The beaker froths as the buffer is added, to no effect."
	else
		message = "The beaker froths as the pH changes!"
		target.adjust_all_reagents_ph((-(amount / target.total_volume) * BUFFER_IONIZING_STRENGTH))

	//give feedback & remove from holder because it's not transferred
	target.my_atom.audible_message(span_warning(message))
	playsound(target.my_atom, 'sound/effects/chemistry/bufferadd.ogg', 50, TRUE)
	holder.remove_reagent(type, amount)

/datum/reagent/reaction_agent/basic_buffer
	name = "Strong Basic Buffer"
	description = "This reagent will consume itself and move the pH of a beaker towards alkalinity when added to another."
	color = "#3853a4"
	ph = 14
	inverse_chem = null
	fallback_icon = 'icons/obj/drinks/drink_effects.dmi'
	fallback_icon_state = "base_buffer_fallback"
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/reaction_agent/basic_buffer/intercept_reagents_transfer(datum/reagents/target, amount)
	. = ..()
	if(!.)
		return

	//do the ph change
	var/message
	if(target.ph >= ph)
		message = "The beaker froths as the buffer is added, to no effect."
	else
		message = "The beaker froths as the pH changes!"
		target.adjust_all_reagents_ph(((amount / target.total_volume) * BUFFER_IONIZING_STRENGTH))

	//give feedback & remove from holder because it's not transferred
	target.my_atom.audible_message(span_warning(message))
	playsound(target.my_atom, 'sound/effects/chemistry/bufferadd.ogg', 50, TRUE)
	holder.remove_reagent(type, amount)

//purity testor/reaction agent prefactors

/datum/reagent/prefactor_a
	name = "Interim Product Alpha"
	description = "This reagent is a prefactor to palladium synthate catalyst, and will react with stable plasma to create it."
	color = "#bafa69"

/datum/reagent/prefactor_b
	name = "Interim Product Beta"
	description = "This reagent is a prefactor to tempomyocin, and will react with stable plasma to create it."
	color = "#8a3aa9"
