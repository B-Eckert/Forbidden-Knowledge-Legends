this.forbiddenknowledge_lich_takes_minion <- this.inherit("scripts/events/event", {
	m = {
		LastCombatID = 0,
		ChosenBackground = "",
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.forbiddenknowledge_lich_takes_minion";
		this.m.Title = "After the battle...";
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
		this.m.Screens.push({
			ID = "Noble",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_noble.png[/img]{The noble, in all their finery, seems rather startled. They were just spectating the battle, and didn\'t expect that the battle would end in such a disastrous way for their side. As you approach, they looks terrified. Their legs shake weakly beneath them as they stumble back and look up. %SPEECH_ON%W-what do you want? I have land, men!%SPEECH_OFF% You\'ve already found what you wanted however.|The noble was mixed amidst the rest of their troops, wearing a helmet that has since been battered and knocked off. They scramble on the grass away from you, screaming %SPEECH_ON%Get away, get away!%SPEECH_OFF% But you don\'t get away - you approach. Silently, menacingly, you approach.|You smelled weakness on the wind, but you didn\'t realize how close weakness truly was. Taking stock of the battlefield, you see a noble cowering in a nearby bush. Pitiful. You hold your hand out to end their weak little life and the noble shouts %SPEECH_ON%Stop! Please! I can... ah... I can serve you! Loyally, yes!%SPEECH_OFF% You lower your hand and consider the noble\'s offer.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
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
					Text = "No.",
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
					this.m.ChosenBackground,
				]);
				_event.m.Dude.getBackground().m.RawDescription = "A noble who has been swayed to your cause after a decisive loss on his behalf. They shall prove useful...";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "NobleSoldier",
			Text = "[img]gfx/ui/events/lich_captives/event_forbiddenknowledge_lich_captive_noble_soldier.png[/img]{The injured soldier looks up at you in clear distress. They spit blood onto the ground as they gather their nerves enough to ask %SPEECH_ON%Are you going to kill me? If you are, make it quick.%SPEECH_OFF% This one was defiant, but they had spirit. Are you going to kill them? They could prove useful...|You find a soldier cowering behind a tree in terror, whispering a mantra to himself. When you approach him, you hear an unearthly scream of shock as they cover their eyes before they seem... surprised. They were waiting for something that didn't come, an end to their life. You play with the thought of killing them in your mind as they visibly sweat.|At the end of a battle, you hear the clattering of armor as a soldier runs up behind you. You thought you were being ambushed by another troop, or perhaps a particularly vengeful fighter, when you turn around and see a soldier on their knees. %SPEECH_ON%I... I swear my l-loyalty to you, oh, uhh, Lord of Bone.%SPEECH_OFF% You would chuckle if you had a throat for the noise to rattle around in. Instead, you are now faced with a choice.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
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
					Text = "No.",
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
					this.m.ChosenBackground,
				]);
				_event.m.Dude.getBackground().m.RawDescription = "A soldier who joined your service after one of your many victories. They shall prove useful...";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		// ================== TODO LINE ==========================================
		this.m.Screens.push({
			ID = "Civilians",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take him as an indebted to the Gilder so that he may earn his salvation.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Lost a battle and was taken a captive");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
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
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% was taken as an indebted after barely surviving a battle against your men. His spirit was broken and he was forced to fight for you, so that he may pay his debt to the Gilder.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Bandits",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use. | The lone bandit survivor yells out for the old gods as you weigh a chain in your hand, wondering how it will fit around his neck. | %SPEECH_ON%Is this the penalty for banditry?%SPEECH_OFF%The northerner asks as you weigh a chain in your hand. You\'re still not sure yet of how you\'ll handle him, but answer anyway.%SPEECH_ON%This isn\'t punitive at all, it\'s merely business.%SPEECH_OFF% | The bandit tries to hide, but as the last survivor he\'s about as easy to spot as a white rabbit on a bloodslaked battlefield. He yells out that the old gods wouldn\'t abide by men such as yourself. You shrug.%SPEECH_ON%The old gods aren\'t standing where I am, now are they?%SPEECH_OFF%And you hold out the chain, sizing it with his neck.%SPEECH_ON%But I wonder, how much would you give up, to swap spots with one of your gods, hm?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take him as an indebted to the Gilder so that he may earn his salvation.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Lost a battle and was taken a captive");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
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
					"slave_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% was taken as an indebted after barely surviving a battle against your men. His spirit was broken and he was forced to fight for you, so that he may pay his debt to the Gilder.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Nomads",
			Text = "[img]gfx/ui/events/event_172.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use. | You hold the chain out to the nomad, sizing his head from a distance in the swing of its closed gate.%SPEECH_ON%Sometimes in the sands, a man may come across those he should not have trifled with. Sometimes he walks away.%SPEECH_OFF%You grasp the chain firmly.%SPEECH_ON%Sometimes he just walks.%SPEECH_OFF% | The sands shift and slide as the wounded nomad tries to escape. You easily put a boot on him and hold him down, your other hand sizing up his neck with the slave chain. | The nomad prays for forgiveness.%SPEECH_ON%By parting our shadows, the shine of the Gilder brighten the both of us!%SPEECH_OFF%You hold up a chain and tell him not every shadow is born a part of us.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take him as an indebted to the Gilder so that he may earn his salvation.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Lost a battle and was taken a captive");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
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
					"slave_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% was taken as an indebted after barely surviving a battle against your men. His spirit was broken and he was forced to fight for you, so that he may pay his debt to the Gilder.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CityState",
			Text = "[img]gfx/ui/events/event_172.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use. | %SPEECH_ON%The Gilder wouldn\'t have it.%SPEECH_OFF%He is the last of the southern troop, a wounded pitiful man begging for his life. You hold up the chain.%SPEECH_ON%Just because this is on you does not mean your path is shadowed, fellow traveler. Just means mine is a little bit brighter.%SPEECH_OFF% | %SPEECH_ON%Ah, please don\'t!%SPEECH_OFF%You have your boot on the last of the southern troop, and you are sizing him up to join the indebted. He begs for his life, or for freedom, and eventually to simply die free. You shake your head.%SPEECH_ON%Gold cannot live or die, traveler, it is merely weighed. Heavy. Or light. My considerations do not concern you. You beg about something you lost the moment you crossed paths with me.%SPEECH_OFF% | The last of the southern troop is at your feet. He\'s praying to the Gilder to bring light to his path. Unfortunately, the only one with say here is yourself, and you\'ve got a spot in chains for the man if you wish him to \'join\' the %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take him as an indebted to the Gilder so that he may earn his salvation.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Lost a battle and was taken a captive");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
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
					"slave_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% was taken as an indebted after barely surviving a battle against your men. His spirit was broken and he was forced to fight for you, so that he may pay his debt to the Gilder.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Barbarians",
			Text = "[img]gfx/ui/events/event_145.png[/img]{The surviving man scrambles away from you. He\'s muttering something. You can\'t hear it, but the language is clear nonetheless: he knows who you are, and what you are. | The battle over, you find one survivor in the field. He\'s a little scraped up but could be of use. | Ah, the last survivor. He\'s a large man, the barbarian, and could perhaps do well for you. In chains, of course. | The %companyname% rarely comes across stock such as these northern barbarians. With one last survivor left on the field, you ponder if taking him as an indebted would be to your benefit. | The last barbarian standing. He speaks to you in a language you\'d never have the time to learn. Grunts, growls, things which other languages would take for threats, but here you know he is articulating something of import. But, all you have to respond with is the chain, and this barbarian might just make a very good indebted for the %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Take him as an indebted to the Gilder so that he may earn his salvation.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.worsenMood(2.0, "Lost a battle and was taken a captive");
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "We have no use for him.",
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
					"slave_barbarian_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "%name% was taken as an indebted after barely surviving a battle against your men. His spirit was broken and he was forced to fight for you, so that he may pay his debt to the Gilder.";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
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
		local civilianBackgrounds = [
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
		];
		local rarity = this.Math.rand(1, 100);
		if (f.getType() == this.Const.FactionType.NobleHouse)
		{
			local nobleBackgrounds = [
				"adventurous_noble_background",
				"female_adventurous_noble_background",
				"bastard_background",
				"disowned_noble_background",
				"female_disowned_noble_background",
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
				return "Noble";
			}
			else{
				choice = nobleMilitaryBackgrounds;
			}
			this.m.ChosenBackground = choice[this.Math.rand(0, choice.len() - 1)]; // random noble or military background.
			return "NobleSoldier";
			// Pick out backgrounds
		}
		else if (f.getType() == this.Const.FactionType.Settlement)
		{
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
				choice = civilianBackgrounds;
			}
			this.m.ChosenBackground = choice[this.Math.rand(0, choice.len() - 1)]; // random civvie background.
			return "Civilians";
			// Select random from CharacterVillageBackgrounds or CharacterLaborerBackgrounds
		}
		else if (f.getType() == this.Const.FactionType.Bandits)
		{
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
			local barbarianBackgrounds = [
				"barbarian_background", // x40 (4/5 or 80%)
				"wildman_background", // rare (x3) (3/50 or 6%)
				"wildwoman_background", // rare (x2) (1/25 or  4%) - collective 10% of getting wildman
				"legend_berserker_background", // super rare (x3) (3/50 or 6%)
				"legend_druid_background", // even rarer (x1) (1/50 or 2%)
				"legend_vala_background", // as rare as Druid (x1) (1/50 or 2%)
			];
			if (rarity >  95){ // 5% vala or druid
				this.m.ChosenBackground = barbarianBackgrounds[this.Math.rand(4, 5)];
			}
			else if (rarity > 85) { // 10% berserker
				this.m.ChosenBackground = barbarianBackgrounds[3];
			}
			else if(rarity > 70) { // 15% wildman
				this.m.ChosenBackground = barbarianBackgrounds[this.Math.rand(1, 2)]
			}
			else{ // 70% regular barbarian
				this.m.ChosenBackground = barbarianBackgrounds[0];
			}
			return "Barbarians";
		}
		else if (f.getType() == this.Const.FactionType.OrientalCityState)
		{
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
			local tradingBackgrounds = [
				"peddler_background",
				"legend_trader_background",
			];
			local tradingGuardBackgrounds = [
				"caravan_hand_background",
			];
			if(rarity > 50){
				this.m.ChosenBackground = tradingBackgrounds[this.Math.rand(0, tradingBackgrounds.len() - 1)];
			}
			else{
				this.m.ChosenBackground = tradingGuardBackgrounds[this.Math.rand(0, tradingGuardBackgrounds.len() - 1)];
			}
			return "Trading";
		}
		else if (f.getType() ==  this.Const.FactionType.Zombies) {
			// no specific backgrounds; 5% necromancer, 95% zombie of mostly random background
			local zombieBackgrounds = [
				civilianBackgrounds, // Regular Zombies
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
				choice = zombieBackgrounds[1]
			}
			else{ // 50% civilian
				choice = zombieBackgrounds[0]
			}
			this.m.ChosenBackground = choice[this.Math.rand(0, choice.len() - 1)]; // random zombie background.
			return "Zombies";
		}
		else if (f.getType() ==  this.Const.FactionType.Undead) {
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

