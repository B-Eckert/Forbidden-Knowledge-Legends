this.forbiddenknowledge_lich_takes_minion <- this.inherit("scripts/events/event", {
	m = {
		LastCombatID = 0,
		ChosenBackground = "",
		Dude = null,
		civilianBackgrounds = [
			"anatomist_background",
			"apprentice_background",
			"beggar_background",
			"bowyer_background",
			"brawler_background",
			"butcher_background",
			"cripple_background",
			"daytaler_background",
			"eunuch_background",
			"farmhand_background",
			"fisherman_background",
			"gambler_background",
			"gravedigger_background",
			"graverobber_background",
			"historian_background",
			"houndmaster_background",
			"juggler_background",
			"lumberjack_background",
			"mason_background",
			"messenger_background",
			"miller_background",
			"miner_background",
			"minstrel_background",
			"monk_background",
			"ratcatcher_background",
			"refugee_background",
			"servant_background",
			"shepherd_background",
			"tailor_background",
			"legend_herbalist_background",
			"legend_inventor_background",
			"legend_ironmonger_background",
			"legend_taxidermist_background",
			"legend_trader_background",
		],
		PotentialIndicator = " \n\n[color=#2fbd90]As you examine them, you realize that this one has the potential to learn from you.[/color]"
	},
	function standardStart(_event, special){
		local roster = this.World.getTemporaryRoster();
		_event.m.Dude = roster.create("scripts/entity/tactical/player");
		::logInfo("Making individual with background " + _event.m.ChosenBackground);
		if (_event.m.ChosenBackground == "" || _event.m.ChosenBackground ==  null) {
			::logInfo("HLICH: Warning - Background is blank! Replacing with vagabond background.")
			_event.m.ChosenBackground = "vagabond_background"
		}
		_event.m.Dude.setStartValuesEx([
			_event.m.ChosenBackground,
		]);
		_event.m.Dude.getBackground().m.RawDescription = "A " + special + " who has been swayed to your cause after a decisive loss on his behalf. They shall prove useful...";
		_event.m.Dude.getBackground().buildDescription(true);
	}
	function create()
	{
		::logInfo("Created event.")
		this.m.ID = "event.forbiddenknowledge_lich_takes_minion";
		this.m.Title = "A new minion?";
		this.m.IsSpecial = true;
		/*
		Event Classes
		 - Noble
		 - NobleSoldier
		 - Civilians
		 - Bandits
		 - Barbarians
		 - CityState
		 - Nomads
		 - Trading
		 - Necromancer
		 - Zombies
		 	- Remember to refer to the background charts to see what gear they should have. Civilians and Armored can remain untouched.
		 - Undead
		 - Generic (mercenaries)
		*/
		// %SPEECH_ON%
		// %SPEECH_OFF%
		// %SPEECH_ON% words %SPEECH_OFF%
		local standardOptions = [
			{
				Text = "Join me as a living servant.",
				function getResult( _event )
				{
					this.World.getPlayerRoster().add(_event.m.Dude);
					this.World.getTemporaryRoster().clear();
					_event.m.Dude.onHired();
					_event.m.Dude.m.MoodChanges = [];
					_event.m.Dude.worsenMood(2.0, "Has become the minion of a lich.");
					_event.m.Dude = null;
					return 0;
				}

			},
			{
				Text = "You will serve in death.",
				function getResult( _event )
				{
					local undeadType = this.Math.rand(1, 100);
					if(undeadType > 25){
						this.Const.Necromance.Zombify(_event.m.Dude);
					}
					else {
						this.Const.Necromance.Skeletonize(_event.m.Dude);
					}
					this.World.getPlayerRoster().add(_event.m.Dude);
					this.World.getTemporaryRoster().clear();
					_event.m.Dude.onHired();
					_event.m.Dude = null;
					return 0;
				}

			},
			{
				Text = "{No. | Kill him. | I do not need this weakling.}",
				function getResult( _event )
				{
					this.World.getTemporaryRoster().clear();
					_event.m.Dude = null;
					return 0;
				}

			}
		];
		this.m.Screens.push({
			ID = "Noble",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_noble.png[/img]{The noble, in all their finery, seems rather startled. They were just spectating the battle, and didn\'t expect that the battle would end in such a disastrous way for their side. As you approach, they looks terrified. Their legs shake weakly beneath them as they stumble back and look up. %SPEECH_ON%W-what do you want? I have land, men!%SPEECH_OFF% You\'ve already found what you wanted however. | The noble was mixed amidst the rest of their troops, wearing a helmet that has since been battered and knocked off. They scramble on the grass away from you, screaming %SPEECH_ON%Get away, get away!%SPEECH_OFF% But you don\'t get away - you approach. Silently, menacingly, you approach. | You smelled weakness on the wind, but you didn\'t realize how close weakness truly was. Taking stock of the battlefield, you see a noble cowering in a nearby bush. Pitiful. You hold your hand out to end their weak little life and the noble shouts %SPEECH_ON%Stop! Please! I can... ah... I can serve you! Loyally, yes!%SPEECH_OFF% You lower your hand and consider the noble\'s offer.}",
			Image = "",
			List = [],
			Characters = [],
			Options = standardOptions,
			function start( _event )
			{
				_event.standardStart(_event, "noble");
				if(this.Const.Necromance.CanLearnNecromancy(_event.m.Dude)){
					this.Text += _event.m.PotentialIndicator;
				}
				this.Characters.push(_event.m.Dude.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "NobleSoldier",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_noble_soldier.png[/img]{The injured soldier looks up at you in clear distress. They spit blood onto the ground as they gather their nerves enough to ask %SPEECH_ON%Are you going to kill me? If you are, make it quick.%SPEECH_OFF% This one was defiant, but they had spirit. Are you going to kill them? They could prove useful... | You find a soldier cowering behind a tree in terror, whispering a mantra to himself. When you approach him, you hear an unearthly scream of shock as they cover their eyes before they seem... surprised. They were waiting for something that didn\'t come, an end to their life. You play with the thought of killing them in your mind as they visibly sweat. | At the end of a battle, you hear the clattering of armor as a soldier runs up behind you. You thought you were being ambushed by another troop, or perhaps a particularly vengeful fighter, when you turn around and see a soldier on their knees. %SPEECH_ON%I... I swear my l-loyalty to you, oh, uhh, Lord of Bone.%SPEECH_OFF% You would chuckle if you had a throat for the noise to rattle around in. Instead, you are now faced with a choice.}",
			Image = "",
			List = [],
			Characters = [],
			Options = standardOptions,
			function start( _event )
			{
				_event.standardStart(_event, "soldier");
				if(this.Const.Necromance.CanLearnNecromancy(_event.m.Dude)){
					this.Text += _event.m.PotentialIndicator;
				}
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Civilians",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_civilian.png[/img]{Amidst the carnage, you see a subtle jerk of a knee. You hear the sound of a person quietly sobbing. You walk over and gaze down at them, and when they realize they\'ve been noticed, they attempt to meekly scramble away. %SPEECH_ON%Stay.%SPEECH_OFF% you say, and they freeze in their tracks. | You hear a ferocious roar as you turn around and see a commoner charging you with a discarded pitchfork. You break the pitchfork with a blast of magic, snapping it with a spectral bony hand as they fall to their knees. %SPEECH_ON%Make it quick.%SPEECH_OFF% they say, %SPEECH_ON%And... please don\'t do anything unnatural with me body.%SPEECH_OFF% | Amidst the strewn-about bodies, you see one person on their knees, looking down in a blank devastation. When you approach, they don\'t even have the energy to cry or scream, and they just gaze emptily at the floor in front of them.}",
			Image = "",
			List = [],
			Characters = [],
			Options = standardOptions,
			function start( _event )
			{
				_event.standardStart(_event, "commoner");
				if(this.Const.Necromance.CanLearnNecromancy(_event.m.Dude)){
					this.Text += _event.m.PotentialIndicator;
				}
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Bandits",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_bandit.png[/img]{You watch as the cowardly man raises his hands, screaming %SPEECH_ON%I just wanted to make a bit of coin, please sir! Please!%SPEECH_OFF% As cowardly as he may seem, he is still an able fighter. | You see a bandit sitting on a stump just off the side of a road, sharpening their weapon. %SPEECH_ON%You hiring?%SPEECH_OFF% he says calmly, as if he weren\'t speaking to a master over the forces of life and death. You could kill him for your insolence, but this brazen attitude may prove useful yet... | You look over the field of the slain, and you notice something... odd. You see a single eye of one of the allegedly dead bandits scan the periphery, watching for their moment to cut and run. You walk up to the bandit playing dead and stoop low. The eye twitches in fear as the pupil grows smaller... You could kill him now, if you wanted.}",
			Image = "",
			List = [],
			Characters = [],
			Options = standardOptions,
			function start( _event )
			{
				_event.standardStart(_event, "bandit");
				if(this.Const.Necromance.CanLearnNecromancy(_event.m.Dude)){
					this.Text += _event.m.PotentialIndicator;
				}
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Nomads",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_nomad.png[/img]{The nomad turns their head down and looks at the ground, defeated. You walk over to them and play with the idea of killing them - it would be so easy to just finish them here, after all - before they look up at your empty eyesockets soulfully and you see the expression of a man who is truly lost. | You watch a nomad in the corner of the battlefield digging into the sand with their hands. You wonder what they\'re doing and as you approach, they begin to dig even faster. You conclude that it might be some custom, that all nomads should be buried in the desert. You could grant the man\'s wish and end him here, in his little sandy hole... or, put him to better use. | At the end of the battle, you thought all of the nomads were slain until you hear the whimpering of a wounded warrior. You walk up to them and they lay in the sand, holding their eyes as tears streamed from them. You could grant them the dignity of a simple death... but why not put them to good use?}",
			Image = "",
			List = [],
			Characters = [],
			Options = standardOptions,
			function start( _event )
			{
				_event.standardStart(_event, "nomad");
				if(this.Const.Necromance.CanLearnNecromancy(_event.m.Dude)){
					this.Text += _event.m.PotentialIndicator;
				}
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CityState",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_southern.png[/img]{The gilder looks up at you with fear in their eyes, their golden-brass armor glistening in the sun. They mutter prayers to their pitiful god, begging them to be spared the most horrible fate of undeath, but they are not in control of their fate, not anymore. You are. | At the end of the battle, you hear a quiet shuddering. You follow the sound and you find a man huddling behind a rock. When you approach, he holds up his arms in fear and presses himself into the rock, making him seem small and ever so easy to crush. | Even when you believed everyone to be dead, there was one who remained. Under a pile of bodies you could hear the shift of metal on metal, the shift of a moving person. You order your minions to cast the bodies aside, revealing a man with a steely determination in his eyes meeting your undead gaze. The impertinence alone is enough to kill him, but...}",
			Image = "",
			List = [],
			Characters = [],
			Options = standardOptions,
			function start( _event )
			{
				_event.standardStart(_event, "southerner");
				if(this.Const.Necromance.CanLearnNecromancy(_event.m.Dude)){
					this.Text += _event.m.PotentialIndicator;
				}
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Barbarians",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_barbarian.png[/img]{Finally, the annoying ululations of these northern savages ceased. Just as you were about to turn and leave, you see something move out of the corner of your fiery eyes. You turn, and you see one of the savages struggling to raise themselves up to their feet. Just as they see they\'ve garnered your notice, they lower their head and bow. You could end their life now, but their audacity... | You survey the scattered remains of the barbarian fools, admiring your handiwork. You saw a rustle of movement amongst the corpses and lifted your bony hand in an attempt to quash the undead\'s spirit back to the grave, only to find that this was no undead at all. Their heart beat, however faintly. They could be captured, healed, and pressed into service quite easily, but where\'s the fun in that? | Even after the battlefield, there is one berserking warrior that continues to swing their weapon aimlessly, screaming into the wind. You could easily end them now, but why not wait until they tire themselves out and recruit them to your own ends?}",
			Image = "",
			List = [],
			Characters = [],
			Options = standardOptions,
			function start( _event )
			{
				_event.standardStart(_event, "barbarian");
				if(this.Const.Necromance.CanLearnNecromancy(_event.m.Dude)){
					this.Text += _event.m.PotentialIndicator;
				}
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Trading",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_merchant.png[/img]{You use the body of the nearest donkey as footstool to look into the cart, and just as you peer into it you see, amidst the goods and wares, a person cowering under the cover. You stop yourself from laughing at his pitiful nature. He is weak enough to hide, and would probably bend to your will just as easily as his bones would bend and snap. | You order your subordinates to topple over the nearest cart, and as you do so a person spills out onto the road and backs up from you in terror. It might be fun to see how far they can run, but they could prove useful to your plans as well. | Amidst the goods in the caravan, you find a suspiciously large pot that your servants had yet to open. You open the lid and look in and see a pair of eyes staring back up at you. A clever hiding spot, but not clever enough to escape your notice.}",
			Image = "",
			List = [],
			Characters = [],
			Options = standardOptions,
			function start( _event )
			{
				_event.standardStart(_event, "caravaneer"); // to account for caravan guards too
				if(this.Const.Necromance.CanLearnNecromancy(_event.m.Dude)){
					this.Text += _event.m.PotentialIndicator;
				}
				this.Characters.push(_event.m.Dude.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Necromancer",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_necromancer.png[/img]{As the necromancer\'s undead servants fall away, they raise their hands in submission and prostrates themselves before you. %SPEECH_ON%Oh great lord of death, surely you could take me as an underling? I clearly have so much to learn from you - why don\'t we work together?%SPEECH_OFF% The services of a colleague could be useful, but he has already proved himself weak and foolish. | You see a person in black clothes descend from a nearby hill. Clearly the master of this force remained far from the battle itself. You admire their audacity as they stride directly up to you and extend a hand towards you. %SPEECH_ON%Pleased to make your acquaintance. I presume you are the ancient lich spoken of in whispers. I admit, I am a great student of your works... but it appears I have not studied well enough.%SPEECH_OFF% He turns back to the field of corpses that was once his army contemplatively. You could strike him down, but why deny a colleague? Even a dead one has their purposes. | In the midst of the collapsing undead horde, a person swaddled in black falls to their hands and knees. %SPEECH_ON%It was my life\'s work... gathering these undead... I sacrificed so much.%SPEECH_OFF% Their life\'s work was a pitiful force. It was a shame that they wasted their life so, but in your hands, their life could become far more valuable.}",
			Image = "",
			List = [],
			Characters = [],
			Options = standardOptions,
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					_event.m.ChosenBackground,
				]);
				_event.m.Dude.getBackground().m.RawDescription = "A " + "necromancer" + " who has been swayed to your cause after a decisive loss on his behalf. They shall prove useful...";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Const.Necromance.LearnNecromancy(_event.m.Dude); // to represent his knowledge of n e c r o m a n c y
				local inventory = _event.m.Dude.getItems();
				inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Mainhand)); // starts wtih grim scythe which is silly
				local choices = ["dagger", "legend_scythe", "scramasax"];
				inventory.equip(this.new("scripts/items/weapons/" + choices[this.Math.rand(0, choices.len() - 1)]));
				this.Characters.push(_event.m.Dude.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Zombies",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_zombie.png[/img]After the battle, one of the undead creatures stands mindlessly in the center of the field. Its commander is either dead or has fled and abandoned their careful control over it. It is ripe for the taking, if you believe it worthy enough.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bring it under your control.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "{Kill it. | I do not need this creature.}",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					_event.m.ChosenBackground,
				]);
				_event.m.Dude.getBackground().m.RawDescription = "A " + "zombie" + " who has been brought under your control, stolen from a rival.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Const.Necromance.Zombify(_event.m.Dude); // he dead
				local inventory = _event.m.Dude.getItems();
				local zombieBackgrounds = [
					_event.m.civilianBackgrounds, // Regular Zombies
					["militia_background", "deserter_background",  "retired_soldier_background"], // Armored Zombies
					["hedge_knight_background",  "paladin_background"], // Fallen Heroes
				];
				// gear picking copied from zombie_yeoman.nut / zombie_knight.nut
				if (zombieBackgrounds[0].find(_event.m.ChosenBackground) == null) {
					inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Mainhand));
					inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Offhand));
					inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Body));
					inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Head));
					inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Ammo));
					if (zombieBackgrounds[1].find(_event.m.ChosenBackground) !=  null) {
						local r;
						r = this.Math.rand(1, 7);
						if (r == 1)
						{
							inventory.equip(this.new("scripts/items/weapons/bludgeon"));
						}
						else if (r == 2)
						{
							inventory.equip(this.new("scripts/items/weapons/hatchet"));
						}
						else if (r == 3)
						{
							inventory.equip(this.new("scripts/items/weapons/hand_axe"));
						}
						else if (r == 4)
						{
							inventory.equip(this.new("scripts/items/weapons/scramasax"));
						}
						else if (r == 5)
						{
							inventory.equip(this.new("scripts/items/weapons/militia_spear"));
						}
						else if (r == 6)
						{
							inventory.equip(this.new("scripts/items/weapons/shortsword"));
						}
						else if (r == 7)
						{
							inventory.equip(this.new("scripts/items/weapons/legend_militia_glaive"));
						}

						local aList = [
							[
								1,
								"padded_leather"
							],
							[
								1,
								"worn_mail_shirt"
							],
							[
								1,
								"patched_mail_shirt"
							],
							[
								1,
								"ragged_surcoat"
							],
							[
								1,
								"basic_mail_shirt"
							]
						];
						local armor = this.Const.World.Common.pickArmor(aList);

						if (this.Math.rand(1, 100) <= 66)
						{
							armor.setArmor(this.Math.round(armor.getArmorMax() / 2 - 1));
						}

						inventory.equip(armor);

						if (this.Math.rand(1, 100) <= 75)
						{
							local item = this.Const.World.Common.pickHelmet([
								[
									1,
									"aketon_cap"
								],
								[
									1,
									"full_aketon_cap"
								],
								[
									1,
									"kettle_hat"
								],
								[
									1,
									"padded_kettle_hat"
								],
								[
									1,
									"dented_nasal_helmet"
								],
								[
									1,
									"mail_coif"
								],
								[
									1,
									"full_leather_cap"
								]
							]);

							if (item != null)
							{
								if (this.Math.rand(1, 100) <= 66)
								{
									item.setArmor(this.Math.round(item.getArmorMax() / 2 - 1));
								}

								inventory.equip(item);
							}
						}
					}
					else if (zombieBackgrounds[2].find(_event.m.ChosenBackground) !=  null) {
						local r;
						if (inventory.getItemAtSlot(this.Const.ItemSlot.Mainhand) == null)
						{
							local weapons = [
								"weapons/winged_mace",
								"weapons/hand_axe",
								"weapons/fighting_axe",
								"weapons/morning_star",
								"weapons/arming_sword",
								"weapons/flail",
								"weapons/military_cleaver"
							];

							if (inventory.hasEmptySlot(this.Const.ItemSlot.Offhand))
							{
								weapons.extend([
									"weapons/longsword",
									"weapons/legend_longsword",
									"weapons/greataxe",
									"weapons/legend_reinforced_flail"
								]);
							}

							if (this.Const.DLC.Unhold && inventory.hasEmptySlot(this.Const.ItemSlot.Offhand))
							{
								weapons.extend([
									"weapons/two_handed_flail"
								]);
							}

							inventory.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
						}

						if (inventory.getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
						{
							local shields = [
								"shields/worn_heater_shield",
								"shields/worn_kite_shield"
							];
							inventory.equip(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
						}

						local aList = [
							[
								1,
								"decayed_coat_of_plates"
							],
							[
								1,
								"decayed_coat_of_scales"
							],
							[
								1,
								"decayed_reinforced_mail_hauberk"
							]
						];
						local armor = this.Const.World.Common.pickArmor(aList);

						if (this.Math.rand(1, 100) <= 33)
						{
							armor.setArmor(this.Math.round(armor.getArmorMax() / 2 - 1));
						}

						inventory.equip(armor);

						if (inventory.getItemAtSlot(this.Const.ItemSlot.Head) == null && this.Math.rand(1, 100) <= 90)
						{
							local helmet = [
								[
									1,
									"decayed_closed_flat_top_with_sack"
								],
								[
									3,
									"decayed_closed_flat_top_with_mail"
								],
								[
									3,
									"decayed_full_helm"
								],
								[
									3,
									"decayed_great_helm"
								]
							];
							local h = this.Const.World.Common.pickHelmet(helmet);

							if (this.Math.rand(1, 100) <= 33)
							{
								h.setArmor(this.Math.round(h.getArmorMax() / 2 - 1));
							}

							inventory.equip(h);
						}
					}
				}
				this.Characters.push(_event.m.Dude.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Undead",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_undead.png[/img]{After the battle, one of the skeletons walks up to you and takes a knee, lowering their head. %SPEECH_ON%I was wrong to oppose you. You are not the False King, my Emperor. The Empire must rise again.%SPEECH_OFF% The skeleton wordlessly offers their weapon to you. Its bones are brittle, you could shatter them in an instant, but such loyalty should be rewarded. | When the battle has ended, you see a lone legionary standing amidst the shattered bones of the rest. It seems lost in thought, its mind in a place far away and long ago. You can almost imagine it, a soldier dutifully watching the forum as citizens in brightly colored tunics, togas and dresses walk past. You could seize upon this dream and depict yourself as this soldier\'s lost emperor, surely gaining its loyalty. After all, the distant pictures echoing in your skull suggest there is more truth to this claim than you realize. | A lone skeleton stands, weapon at the ready, holding it out towards you. %SPEECH_ON%The False King must die for the Empire to rise. He promised it would.%SPEECH_OFF% In an instant, you could use your magics to sieze what little consciousness remains in that hollowed out skull, but it may be safer to simply dispatch the creature.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bring it under your control.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "{Kill it. | I do not need this creature.}",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					_event.m.ChosenBackground,
				]);
				_event.m.Dude.getBackground().m.RawDescription = "A " + "soldier of the old empire" + " who has been brought under your control after seeming lost.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Const.Necromance.Skeletonize(_event.m.Dude); // B O N E S
				local inventory = _event.m.Dude.getItems();
				local undeadBackgrounds = [
					["militia_background"], // auxiliary gear
					["retired_soldier_background"], // soldier gear
					["gladiator_background",  "beast_hunter_background"], // gladiator gear
					["hedge_knight_background",  "swordmaster_background"] // honorguard gear
				];
				if(true) {// this is because im lazy and for formatting purposes so i can minimize everything
					inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Mainhand));
					inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Offhand));
					inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Body));
					inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Head));
					inventory.unequip(inventory.getItemAtSlot(this.Const.ItemSlot.Ammo));
					if (undeadBackgrounds[0].find(_event.m.ChosenBackground) !=  null) {
						local r = this.Math.rand(1, 3);
						if (r == 1)
						{
							inventory.equip(this.new("scripts/items/weapons/ancient/broken_ancient_sword"));
						}
						else if (r == 2)
						{
							inventory.equip(this.new("scripts/items/weapons/ancient/falx"));
						}
						else if (r == 3)
						{
							inventory.equip(this.new("scripts/items/weapons/ancient/ancient_spear"));
						}

						if (this.Math.rand(1, 100) <= 66)
						{
							inventory.equip(this.new("scripts/items/shields/ancient/auxiliary_shield"));
						}

						local armor = [
							[
								1,
								"ancient/ancient_ripped_cloth"
							]
						];
						local item = this.Const.World.Common.pickArmor(armor);
						inventory.equip(item);
						item = this.Const.World.Common.pickHelmet([
							[
								66,
								"ancient/ancient_household_helmet"
							],
							[
								34,
								""
							]
						]);

						if (item != null)
						{
							inventory.equip(item);
						}
					}
					else if (undeadBackgrounds[1].find(_event.m.ChosenBackground) !=  null) {
						local weapons = [
							[
								1,
								"weapons/ancient/broken_ancient_sword"
							],
							[
								2,
								"weapons/ancient/ancient_sword"
							],
							[
								1,
								"weapons/ancient/legend_gladius"
							],
							[
								1,
								"weapons/ancient/broken_bladed_pike"
							],
							[
								1,
								"weapons/ancient/bladed_pike"
							]
						];
						inventory.equip(this.Const.World.Common.pickItem(weapons, "scripts/items/"));

						if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
						{
							if (this.Math.rand(1, 100) <= 66)
							{
								inventory.equip(this.new("scripts/items/shields/ancient/coffin_shield"));
							}
							else
							{
								inventory.equip(this.new("scripts/items/shields/ancient/tower_shield"));
							}
						}

						local armor = [
							[
								1,
								"ancient/ancient_scale_harness"
							],
							[
								1,
								"ancient/ancient_breastplate"
							],
							[
								1,
								"ancient/ancient_mail"
							],
							[
								1,
								"ancient/ancient_double_layer_mail"
							]
						];
						local item = this.Const.World.Common.pickArmor(armor);
						inventory.equip(item);
						local item = this.Const.World.Common.pickHelmet([
							[
								99,
								"ancient/ancient_honorguard_helmet"
							],
							[
								1,
								"ancient/legend_ancient_legionary_helmet_restored"
							]
						]);

						if (item != null)
						{
							inventory.equip(item);
						}
					}
					else if (undeadBackgrounds[2].find(_event.m.ChosenBackground) !=  null) {
						inventory.equip(this.new("scripts/items/weapons/ancient/ancient_spear"));
						inventory.equip(this.new("scripts/items/weapons/throwing_spear"));
						inventory.equip(this.new("scripts/items/weapons/throwing_spear"));
						inventory.equip(this.new("scripts/items/weapons/throwing_spear"));
						inventory.equip(this.new("scripts/items/tools/throwing_net"));
						inventory.equip(this.new("scripts/items/shields/ancient/tower_shield"));
						local item = this.Const.World.Common.pickArmor([
							[
								1,
								"ancient/ancient_ripped_cloth"
							]
						]);
						inventory.equip(item);
						local item = this.Const.World.Common.pickHelmet([
							[
								66,
								"ancient/ancient_gladiator_helmet"
							]
						]);

						if (item != null)
						{
							inventory.equip(item);
						}
					}
					else if (undeadBackgrounds[3].find(_event.m.ChosenBackground) !=  null) {
						if (inventory.hasEmptySlot(this.Const.ItemSlot.Mainhand))
						{
							local weapons = [
								"weapons/ancient/ancient_sword",
								"weapons/ancient/legend_gladius",
								"weapons/ancient/khopesh"
							];

							if (inventory.hasEmptySlot(this.Const.ItemSlot.Offhand))
							{
								weapons.extend([
									"weapons/ancient/warscythe",
									"weapons/ancient/crypt_cleaver",
									"weapons/ancient/rhomphaia",
									"weapons/ancient/bladed_pike"
								]);
							}

							inventory.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
						}

						if (inventory.hasEmptySlot(this.Const.ItemSlot.Offhand))
						{
							inventory.equip(this.new("scripts/items/shields/ancient/tower_shield"));
						}

						if (inventory.hasEmptySlot(this.Const.ItemSlot.Body))
						{
							local armor = [
								[
									1,
									"ancient/ancient_plated_scale_hauberk"
								],
								[
									1,
									"ancient/ancient_scale_coat"
								],
								[
									1,
									"ancient/ancient_plate_harness"
								],
								[
									1,
									"ancient/ancient_plated_mail_hauberk"
								]
							];
							local item = this.Const.World.Common.pickArmor(armor);
							inventory.equip(item);
						}

						if (inventory.hasEmptySlot(this.Const.ItemSlot.Head))
						{
							local item = this.Const.World.Common.pickHelmet([
								[
									66,
									"ancient/ancient_honorguard_helmet"
								]
							]);

							if (item != null)
							{
								inventory.equip(item);
							}
						}
					}
				}
				this.Characters.push(_event.m.Dude.getImagePath());
			}
		});

		/*
		 - Generic (mercenaries) - not a covered case so im just gonna leave it be for now
		 */
	}

	function isValid()
	{
		if (!this.Const.DLC.Desert || !this.Const.DLC.Wildmen || !this.Const.DLC.Paladins || !this.Const.DLC.Unhold)
		{
			return false;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.dse_forbidden_knowledge_hated_lich")
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatID") <= this.m.LastCombatID)
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 5.0 || this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 1)
		{
			return false;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return false;
		}

		local f = this.World.FactionManager.getFaction(this.World.Statistics.getFlags().getAsInt("LastCombatFaction"));

		if (f == null)
		{
			return false;
		}

		if (f.getType() != this.Const.FactionType.NobleHouse && f.getType() != this.Const.FactionType.Settlement && f.getType() != this.Const.FactionType.Bandits && f.getType() != this.Const.FactionType.Barbarians && f.getType() != this.Const.FactionType.OrientalCityState && f.getType() != this.Const.FactionType.OrientalBandits && f.getType() != this.Const.FactionType.TradingCompany && f.getType() != this.Const.FactionType.Zombies && f.getType() != this.Const.FactionType.Undead)
		{
			return false;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		this.m.LastCombatID = this.World.Statistics.getFlags().get("LastCombatID");
		return true;
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		::logInfo("Starting screen.")
		local f = this.World.FactionManager.getFaction(this.World.Statistics.getFlags().getAsInt("LastCombatFaction"));
		// note: for the following backgrounds, make a separate event. they will join as followers willingly
		/*
		"cultist_background",
		*/
		// note: for the following backgrounds, make a separate event; they will try to kill the Lich by themselves and become undead if you cant talk them down (5% chance).
		// if you fail you get injured and kill them anyway
		/*
		"paladin_background",
		"witchhunter_background",
		*/

		// todo: seed based on frequency, repeat items that should be more frequent.
		local rarity = this.Math.rand(1, 100);
		if (f.getType() == this.Const.FactionType.NobleHouse)
		{
			::logInfo("Faction Type: Nobles");
			local nobleBackgrounds = [
				"adventurous_noble_background",
				"bastard_background",
				"disowned_noble_background"
			];
			local nobleMilitaryBackgrounds = [
				"deserter_background", // common
				"legend_master_archer_background",
				"retired_soldier_background",
				"squire_background",
				"swordmaster_background", // rare
				"hedge_knight_background", // rare
				"legend_noble_ranged", // arbalester
				"legend_noble_shield", // foot soldier
				"legend_noble_2h", //2hander
			];
			local choice = [];
			if (rarity >=  70){
				choice = nobleBackgrounds;
				this.m.ChosenBackground = choice[this.Math.rand(0, choice.len() - 1)];
				return "Noble";
			}
			else{
				choice = nobleMilitaryBackgrounds;
				this.m.ChosenBackground = choice[this.Math.rand(0, choice.len() - 1)]; // random noble or military background.
				return "NobleSoldier";
			}
			// Pick out backgrounds
		}
		else if (f.getType() == this.Const.FactionType.Settlement)
		{

			::logInfo("Faction Type: Civilian (Settlement)");
			local militiaBackgrounds = [
				"militia_background",
			];
			local rareCivilianBackgrounds = [
				"hunter_background", // rare
				"retired_soldier_background", // rare
				"legend_inventor_background",
				"legend_blacksmith_background",
			];
			local choice = [];
			if (rarity >  80){ // 20% rare background
				choice = rareCivilianBackgrounds;
			}
			else if (rarity >  55){ // 25% militia
				choice = militiaBackgrounds;
			}
			else { // 55% Civilian
				choice = this.m.civilianBackgrounds;
			}
			this.m.ChosenBackground = choice[this.Math.rand(0, choice.len() - 1)]; // random civvie background.
			return "Civilians";
			// Select random from CharacterVillageBackgrounds or CharacterLaborerBackgrounds
		}
		else if (f.getType() == this.Const.FactionType.Bandits)
		{
			::logInfo("Faction Type: Bandits");
			local rabbleBackgrounds = [
				"graverobber_background", // common
				"thief_background", // vcommon - "rabble" analogy
				"killer_on_the_run_background", // vcommon - "rabble"/"thug
				"vagabond_background", // vcommon
			]
			local thugBackgrounds = [
				"deserter_background", // common - thug equivalent
				"poacher_background", // vcommon
			];
			local raiderBackgrounds = [
				"hunter_background", // brigand marksman
				"raider_background", // common
			];
			local veryRareBackgrounds = [
				"hedge_knight_background", // hedge knights are high level bandit enemies; it'll be hilarious if they appear after attacking goons
				"legend_master_archer_background", // master archers
			];
			local choice = [];
			if (rarity >  90){ // 10%
				choice = veryRareBackgrounds;
			}
			else if (rarity > 70){ // 20%
				choice = raiderBackgrounds;
			}
			else if (rarity > 40){ // 30%
				choice = thugBackgrounds;
			}
			else { // 40%
				choice = rabbleBackgrounds;
			}
			this.m.ChosenBackground = choice[this.Math.rand(0, choice.len() - 1)]; // random bandit background.
			return "Bandits";
		}
		else if (f.getType() == this.Const.FactionType.Barbarians)
		{
			::logInfo("Faction Type: Barbarians");
			local barbarianBackgrounds = [
				"barbarian_background", // x40 (4/5 or 80%)
				"wildman_background", // rare (x3) (3/50 or 6%)
				"legend_berserker_background", // super rare (x3) (3/50 or 6%)
				"legend_druid_background", // even rarer (x1) (1/50 or 2%)
				"legend_vala_background", // as rare as Druid (x1) (1/50 or 2%)
			];
			if (rarity >  95){ // 5% vala or druid
				this.m.ChosenBackground = barbarianBackgrounds[this.Math.rand(3, 4)];
			}
			else if (rarity > 85) { // 10% berserker
				this.m.ChosenBackground = barbarianBackgrounds[2];
			}
			else if(rarity > 70) { // 15% wildman
				this.m.ChosenBackground = barbarianBackgrounds[1]
			}
			else { // 70% regular barbarian
				this.m.ChosenBackground = barbarianBackgrounds[0];
			}
			return "Barbarians";
		}
		else if (f.getType() == this.Const.FactionType.OrientalCityState)
		{
			::logInfo("Faction Type: Southern");
			local southCivilianBackgrounds = [
				"beggar_southern_background",
				"belly_dancer_background",
				"butcher_southern_background",
				"caravan_hand_southern_background",
				"cripple_southern_background",
				"daytaler_southern_background",
				"eunuch_southern_background",
				"fisherman_southern_background",
				"gambler_southern_background",
				"historian_southern_background",
				"juggler_southern_background",
				"peddler_southern_background",
				"servant_southern_background",
				"shepherd_southern_background",
				"slave_background",
				"slave_southern_background",
				"tailor_southern_background",
				"legend_muladi_background",
				"legend_qiyan_background",
				"legend_alchemist_background"
			];
			local southBackgrounds = [
				"manhunter_background",
				"legend_conscript_background",
				"legend_conscript_ranged_background",
				"legend_dervish_background",
			];
			local southRareBackgrounds =  [
				"assassin_southern_background", // lil rare
				"gladiator_background", // rare
				"assassin_southern_background", // lil rare
			];
			local choice = [];

			if(rarity > 90){ // 10% rare
				choice = southRareBackgrounds;
			}
			else if(rarity > 60){ // 30% military
				choice = southBackgrounds;
			}
			else { // 60% civvie
				choice = southCivilianBackgrounds;
			}
			this.m.ChosenBackground = choice[this.Math.rand(0, choice.len() - 1)]; // random south background.
			return "CityState";
		}
		else if (f.getType() == this.Const.FactionType.OrientalBandits)
		{
			::logInfo("Faction Type: Nomads");
			local nomadBackgrounds = [
				"thief_southern_background", // 0
				"manhunter_background", // 1
				"nomad_background", // 2
				"nomad_ranged_background", // 3
				"legend_dervish_background", // 4
				"legend_bladedancer_background", // 5
			];
			local slaveBackgrounds = [
				"slave_background",
				"slave_southern_background"
			]
			if (rarity >  95){ // 5% blade dancer
				this.m.ChosenBackground = nomadBackgrounds[nomadBackgrounds.len() - 1];
			}
			else if (rarity > 35) { // 60% regular nomad or dervish
				this.m.ChosenBackground = nomadBackgrounds[this.Math.rand(0, nomadBackgrounds.len() - 2)];
			}
			else { // 25% indebted. Only that low because they probably died.
				this.m.ChosenBackground = slaveBackgrounds[this.Math.rand(0, 1)];
			}
			return "Nomads";
		}
		else if (f.getType() ==  this.Const.FactionType.TradingCompany){
			::logInfo("Faction Type: Trading");
			local tradingBackgrounds = [
				"peddler_background",
				"legend_trader_background",
			];
			local tradingGuardBackgrounds = [
				"caravan_hand_background",
				"sellsword_background", // mercenaries often defend caravans
			];
			if(rarity > 60){
				this.m.ChosenBackground = tradingBackgrounds[this.Math.rand(0, tradingBackgrounds.len() - 1)];
			}
			else{
				this.m.ChosenBackground = tradingGuardBackgrounds[this.Math.rand(0, tradingGuardBackgrounds.len() - 1)];
			}
			return "Trading";
		}
		else if (f.getType() ==  this.Const.FactionType.Zombies) {

			::logInfo("Faction Type: Zombies");
			// no specific backgrounds; 5% necromancer, 95% zombie of mostly random background
			local zombieBackgrounds = [
				this.m.civilianBackgrounds, // Regular Zombies
				["militia_background", "deserter_background",  "retired_soldier_background"], // Armored Zombies
				["hedge_knight_background",  "paladin_background"], // Fallen Heroes
			];
			local choice = [];
			if(rarity > 95){ // necromancer
				this.m.ChosenBackground = "legend_necromancer_background";
				return "Necromancer";
			}
			else if (rarity > 80) { // 15% fallen hero
				choice = zombieBackgrounds[2];
			}
			else if (rarity > 50){ // 30% armored
				choice = zombieBackgrounds[1];
			}
			else{ // 50% civilian
				choice = zombieBackgrounds[0];
			}
			this.m.ChosenBackground = choice[this.Math.rand(0, choice.len() - 1)]; // random zombie background.
			return "Zombies";
		}
		else if (f.getType() ==  this.Const.FactionType.Undead) {
			::logInfo("Faction Type: Undead");
			// no specific backgrounds; 5% necrosavant, 95% skeleton military w/ Ancient Dead gear
			local undeadBackgrounds = [
				["militia_background"], // auxiliary gear
				["retired_soldier_background"], // soldier gear
				["gladiator_background",  "beast_hunter_background"], // gladiator gear
				["hedge_knight_background",  "swordmaster_background"] // honorguard gear
			];
			local choice = [];
			/*if(rarity > 95){ - Add this in if you can figure dependency checks out. Then you can use Red Court stuff.
				this.m.ChosenBackground = "legend_necrosavant_background";
				return "Necrosavant";
			}*/
			if (rarity > 90){ // 10
				choice = undeadBackgrounds[3];
			}
			else if(rarity > 80){ // 10
				choice = undeadBackgrounds[2];
			}
			else if(rarity > 50){ // 30
				choice = undeadBackgrounds[1];
			}
			else{ // 50
				choice = undeadBackgrounds[0];
			}
			this.m.ChosenBackground = choice[this.Math.rand(0, choice.len() - 1)]; // random skele background.
			return "Undead";
		}
		else
		{
			::logInfo("Faction Type: Other/Generic");
			local mercenaryBackgrounds = [
				"sellsword_background",
				"swordmaster_background", // rare
				"legend_master_archer_background",
				"assassin_background", // rare
				"legend_bounty_hunter_background",
			];
			this.m.ChosenBackground = mercenaryBackgrounds[this.Math.rand(0, mercenaryBackgrounds.len() - 1)]; // random merc background.
			return "Generic";
		}
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.ChosenBackground = "";
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU32(this.m.LastCombatID);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);

		if (_in.getMetaData().getVersion() >= 54)
		{
			this.m.LastCombatID = _in.readU32();
		}
	}

});

