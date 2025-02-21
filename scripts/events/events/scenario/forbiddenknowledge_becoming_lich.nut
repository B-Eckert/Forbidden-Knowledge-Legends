this.forbiddenknowledge_becoming_lich <- this.inherit("scripts/events/event", { // thank you luft for the idea
	m = {
        Necromancer = null, // Player Character in the default scenario
        Victims = [],
        Sacrifice1 = null,
        Sacrifice2 = null
	},
	function create()
	{
		this.m.ID = "event.forbiddenknowledge_becoming_lich";
		this.m.Title = "To Become Something More";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay; // 120 feels right
		this.m.Screens.push({
			ID = "A", // Initial premise, a necromancer wishes to become a lich.
			Text = "[img]gfx/ui/events/event_forbiddenknowledge_necromancer_lichdom_request.png[/img]During your travels, %necro% has been studying something that they reckon is... amazing. The ability to transcend death is something that a necromancer inflicts onto others in most situations, but %necro_s% claims they can transform into something more. %necro_s% has found an obscure rite hidden in the lost pieces of lore that they\'ve been collecting over the course of the entire journey, the rite to become a lich. They only need your approval, as well as a few... willing sacrifices.\n\nAt length, %necro_s% explains that they need two powerful souls to bind their essence to their body. Those who are used as binding agents will not survive the process. That, with all the souls he has slain in the battles that have passed, should be enough to complete the ritual. Time is short, the Dead Moon passes through the sky even as they speak. They may not get this opportunity for another few months or more.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Go ahead with it. Let\'s choose your two sacrifices...",
					function getResult( _event )
					{
						return "B";
					}
				},
				{
					Text = "No, the cost is too great.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Necromancer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B", // The necromancy learning goes well with no side effects.
			Text = "[img]gfx/ui/events/event_forbiddenknowledge_necromancer_lichdom_request.png[/img]You think about which brothers would do well as victims... %victim1% is a mighty warrior, and would likely have a strong soul. As would %victim2%, %victim3%, and %victim4% though, come to think of it. It\'s a difficult decision to part with any of the brothers in your company, but you know that their lives would only make %necro_s% even stronger. Who to choose, you wonder?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%victim1% {is strong enough | will do | is no longer needed | shall serve | will die | shall serve their purpose | will do nicely}.",
					function getResult( _event )
					{
                        _event.m.Sacrifice1 = _event.m.Victims[0];
                        _event.m.Victims.remove(0);
						return "C";
					}
				},
                {
					Text = "%victim2% {is strong enough | will do | is no longer needed | shall serve | will die | shall serve their purpose | will do nicely}.",
					function getResult( _event )
					{
                        _event.m.Sacrifice1 = _event.m.Victims[1];
                        _event.m.Victims.remove(1);
						return "C";
					}
				},
                {
					Text = "%victim3% {is strong enough | will do | is no longer needed | shall serve | will die | shall serve their purpose | will do nicely}.",
					function getResult( _event )
					{
                        _event.m.Sacrifice1 = _event.m.Victims[2];
                        _event.m.Victims.remove(2);
						return "C";
					}
				},
                {
					Text = "%victim4% {is strong enough | will do | is no longer needed | shall serve | will die | shall serve their purpose | will do nicely}.",
					function getResult( _event )
					{
                        _event.m.Sacrifice1 = _event.m.Victims[3];
                        _event.m.Victims.remove(3);
						return "C";
					}
				},
                {
					Text = "I can\'t go through with this. No.",
					function getResult( _event )
					{
                        return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Necromancer.getImagePath());
			}

		});
        this.m.Screens.push({
			ID = "C", // The necromancy learning goes well with no side effects.
			Text = "[img]gfx/ui/events/event_forbiddenknowledge_necromancer_lichdom_request.png[/img]You think about which brothers would do well as victims... %victim1% is a mighty warrior, and would likely have a strong soul. As would %victim2% and %victim3%, though, come to think of it. It\'s a difficult decision to part with any of the brothers in your company, but you know that their lives would only make %necro_s% even stronger. Who to choose, you wonder?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%victim1% {is strong enough | will do | is no longer needed | shall serve | will die | shall serve their purpose | will do nicely}.",
					function getResult( _event )
					{
                        _event.m.Sacrifice2 = _event.m.Victims[0]
						return "D";
					}
				},
                {
					Text = "%victim2% {is strong enough | will do | is no longer needed | shall serve | will die | shall serve their purpose | will do nicely}.",
					function getResult( _event )
					{
                        _event.m.Sacrifice2 = _event.m.Victims[1]
						return "D";
					}
				},
                {
					Text = "%victim3% {is strong enough | will do | is no longer needed | shall serve | will die | shall serve their purpose | will do nicely}.",
					function getResult( _event )
					{
                        _event.m.Sacrifice2 = _event.m.Victims[2]
						return "D";
					}
				},
                {
					Text = "I can\'t go through with this. No.",
					function getResult( _event )
					{
                        return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Necromancer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D", // The ritual is successful. You become a lich.
			Text = "[img]gfx/ui/events/event_fobiddenknowledge_lichdom_ritual.png[/img]You had to lie to them to get them to go along with it, but they trust you with their lives. They are led to a remote spot in the wilderness where %necro% stands at a podium, their book of necromantic secrets in front of them. The two sacrifices walk towards %necro_s%, not knowing that this would be their demise. Magic shoots from the book on the podium and snags them like a rope around their neck, pulling them closer to the podium as the book floats into the air and %necro_s% begins chanting words, accursed words that are painful to hear. The sacrifices' skin melts from their form as the magic absorbs their life essence. Loud, ghastly screams fill the night as they writhe in pain, becoming a vaguely humanoid shape that glows with a green, repulsive energy. Even as %necro_s%\'s flesh falls away and their bones lie bare under the moonlight, they still chant from a nonexistant throat to dark gods, Davkul and all those vile things that grant foolish mortals power from beyond. Their eyes turn into small green orbs of flame that illuminate the night. Then, it\'s over. The screaming stops, the chanting stops, and all that\'s left is the still-animated bones of %necro_s% and that unnatural intelligence that shines in their fiery eyes.\n\nYou return to camp. When the others ask what happened to them, you tell them that they were killed by %necro_s%\'s ambition, but you know better...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%necro% has certainly become powerful...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
                _event.m.Necromancer.getSkills().add(this.new("scripts/skills/traits/forbiddenknowledge_lich_trait"));
                this.Characters.push(_event.m.Necromancer.getImagePath());
                // who becomes skeletons
                local skeletons = [false, false];
                skeletons[0] = this.Math.rand(1, 100) <= 10;
                skeletons[1] = this.Math.rand(1, 100) <= 10;
                // abstraction of repeated function
                // kill 1 & 2 or make them skeletons
                if(!skeletons[0] || !this.Const.Necromance.CanChangeSprite(_event.m.Sacrifice1)){
                    local dead = _event.m.Sacrifice1;
                    ::Legends.addFallen(dead, "Sacrificed to " + _event.m.Necromancer.getName() + "\'s ambition.");
                    this.List.push({
                        id = 13,
                        icon = "ui/icons/kills.png",
                        text = _event.m.Sacrifice1.getName() + " has died"
                    });
                    _event.m.Sacrifice1.getItems().transferToStash(this.World.Assets.getStash());
                    this.World.getPlayerRoster().remove(_event.m.Sacrifice1);
                }
                else{
                    this.Const.Necromance.Skeletonize(_event.m.Sacrifice1);
                    this.List.push({
                        id = 10,
                        icon = "ui/perks/align_joints_circle.png",
                        text = _event.m.Sacrifice1.getName() + " has persisted in spite of the ritual and become a skeleton."
                    });
                }
                // sacrifice2
                if(!skeletons[1] || !this.Const.Necromance.CanChangeSprite(_event.m.Sacrifice2)){
                    local dead = _event.m.Sacrifice2;
                    ::Legends.addFallen(dead, "Sacrificed to " + _event.m.Necromancer.getName() + "\'s ambition.");
                    this.List.push({
                        id = 13,
                        icon = "ui/icons/kills.png",
                        text = _event.m.Sacrifice2.getName() + " has died"
                    });
                    _event.m.Sacrifice2.getItems().transferToStash(this.World.Assets.getStash());
                    this.World.getPlayerRoster().remove(_event.m.Sacrifice2);
                }
                else{
                    this.Const.Necromance.Skeletonize(_event.m.Sacrifice2);
                    this.List.push({
                        id = 10,
                        icon = "ui/perks/align_joints_circle.png",
                        text = _event.m.Sacrifice2.getName() + " has persisted in spite of the ritual and become a skeleton."
                    });
                }
				this.List.push({
					id = 10,
					icon = "ui/traits/lich_forbiddenknowledge_trait.png",
					text = _event.m.Necromancer.getName() + " is now a lich."
				});

			}
		});
	}

	function onUpdateScore()
	{
        ::logInfo("LICH: Doing condition check for lichdom...");
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 5 || !this.Const.Necromance.IsFBOrigin(this.World.Assets.getOrigin().getID()))
		{
			return;
		}

		local necromancer = null;
		local victim_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().has("IsPlayerCharacter") && bro.getFlags().has("IsNecromancer") && this.World.Assets.getOrigin().getID() == "scenario.dse_forbidden_knowledge" && this.Const.Necromance.CanChangeSprite(bro) && !bro.getFlags().has("PlayerLich"))
			{
                if(bro.getLifetimeStats().Kills >= 200 && bro.getLevel() >= 11 && !bro.getFlags().has("undead")){
                    necromancer = bro;
                }
			}
			else if (bro.getFlags().has("IsNecromancer") && bro.getLifetimeStats().Kills >= 250 && bro.getLevel() >= 11 && !bro.getFlags().has("PlayerLich") && this.Const.Necromance.CanChangeSprite(bro)) { // player necromancer has priority
                if(necromancer == null){
                    necromancer = bro;
                }
			}
			else if (bro.getLevel() >= 6 && !bro.getFlags().has("undead")){
                victim_candidates.push(bro);
            }
		}

		if (necromancer == null || victim_candidates.len() < 4) // at least 4 sacrificial bros to choose from
		{
			return;
		}

		this.m.Necromancer = necromancer;

        local randIndex = this.Math.rand(0, victim_candidates.len()-4);
		this.m.Victims = victim_candidates.slice(randIndex, randIndex+4); // random 4
		this.m.Score = 150; // Once the condition is reached, it should be high priority. (150)
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"necro",
			this.m.Necromancer.getName()
		]);
		_vars.push([
			"necro_s",
			this.m.Necromancer.getNameOnly()
		]);
        foreach(index, bro in this.m.Victims){
            _vars.push([
                "victim" + (index+1),
                bro.getName()
            ]);
            _vars.push([
                "victim" + (index+1) + "_s",
                bro.getNameOnly()
            ]);
        }
    }

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Necromancer = null;
		this.m.Victims = [];
	}

});

