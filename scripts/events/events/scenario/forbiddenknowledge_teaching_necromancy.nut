this.forbiddenknowledge_teaching_necromancy <- this.inherit("scripts/events/event", { // thank you luft for the idea
	m = {
        Necromancer = null, // Player Character in the default scenario
		Scholar = null
	},
	function create()
	{
		this.m.ID = "event.forbiddenknowledge_teaching_necromancy";
		this.m.Title = "A Thirst for Knowledge";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay; // can happen every 60 days - 80 days is a long time if the taught necro dies
		this.m.Screens.push({
			ID = "A", // Initial premise, scholar wants to learn necromancy from you.
			Text = "[img]gfx/ui/events/event_forbidden_knowledge_teaching_necromancy_begging.png[/img]During your travels, %scholar% has taken an interest in your occult knowledge. You\'ve noticed them {taking a peek or two at the book that you glean your knowledge from, sneaking glances and reading a sentence or two over your shoulder | watching you in awe, mouth agape, as you conjure your magics and restore life to the dead | pondering the question of life and death, and the tenuous boundary between the two}. \n\nFinally, it seems %scholar_short% has mustered up the confidence to speak to you and ask you to share your knowledge. On one hand, having an apprentice to teach your ways would be very beneficial... but on the other hand, why share what is rightfully yours? The choice lies with you alone.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I will teach %scholar_short%.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 ? "B" : "C"; // 70/30 chance it goes terribly and they turn into a skeleton
					} // ALTER BACK LATER

				},
				{
					Text = "The knowledge is too dangerous to share.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Necromancer.getImagePath());
				this.Characters.push(_event.m.Scholar.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B", // The necromancy learning goes well with no side effects.
			Text = "[img]gfx/ui/events/event_forbiddenknowledge_teaching_necromancy.png[/img]{You both pore over the book together, and your unnatural insights paired with %scholar_short%\'s keen mind make for quick learning. Thankfully, in your line of work there is no shortage of bodies. You dig one up under the moonlight that night, instructing your student on the finer points of raising the dead, when suddenly, just as you were getting to the crux of your explanation, you hear a moaning noise behind you as the corpse rises and regards you, lifelessly. | You conduct a carefully-constructed lesson plan, introducing %scholar_short% to rites, incantations, and the basics of possession. Soon, you have him animating life into mice, then cats, then dogs, and then, you feel that %scholar_short% has learned enough to move onto a body. Under the cover of night, you unearth one and cross your arms, watching and waiting as, with pleasure, you notice the barest glimmer of life enter the body through no input of your own. | You hand over the book, watching over %scholar_short%\'s shoulder as he pores through the arcane knowledge. He seems to devour it voraciously, and as he reads he quickly begins asking a flurry of questions. Does the variety of creature the fat comes from affect the ritual? Does the recency or potency of the blood spilt matter? After a time, you begin to give him vaguer and vaguer answers until, at last, they find the resolve to attempt a ritual themselves. You oversee them as they unearth a body and, with little input from you, animate it with the barest glimmer of life.}\n\nYes... this one will do nicely.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{I can\'t wait to see their progress. | We\'ll see...}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
                // TODO: Replace this with gaining necromancy perks.  Possibly positive mood.
				this.Characters.push(_event.m.Necromancer.getImagePath());
				this.Characters.push(_event.m.Scholar.getImagePath());
				_event.m.Necromancer.improveMood(2.0, "Taught " + _event.m.Scholar.getName() + " necromancy");
				_event.m.Scholar.improveMood(2.0, "Was taught necromancy by " + _event.m.Necromancer.getName() + ".");

                _event.m.Scholar.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendBrinkOfDeath, 4, true);
                _event.m.Scholar.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendPossession, 2, false);
                _event.m.Scholar.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendRaiseUndead, 6, true);
                //		bros[0].getFlags().set("IsPlayerCharacter", true);
                _event.m.Scholar.getFlags().set("IsNecromancer", true);
				if (_event.m.Scholar.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push(
						{
							id = 10,
							icon = this.Const.MoodStateIcon[_event.m.Scholar.getMoodState()],
							text = _event.m.Scholar.getName() + this.Const.MoodStateEvent[_event.m.Scholar.getMoodState()]
						});
				}
                if (_event.m.Necromancer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push(
						{
							id = 10,
							icon = this.Const.MoodStateIcon[_event.m.Necromancer.getMoodState()],
							text = _event.m.Necromancer.getName() + this.Const.MoodStateEvent[_event.m.Necromancer.getMoodState()]
						});
				}
                // teach necromancy
			}

		});
		this.m.Screens.push({
			ID = "C", // The necromancy learning consumed them, causing them to turn into a skeleton. There's a 25% chance they actually retained the information.
			Text = "[img]gfx/ui/events/event_forbiddenknowledge_teaching_necromancy_bad_end.png[/img]You weren\'t quite sure what to expect, but it definitely wasn\'t this. {You showed them the book, and almost instantly %scholar_short% picked it up and began to eagerly attempt to read it. What %scholar_short% didn\'t notice was that his hand was enveloped in a green energy, that snaked up his arms, then his torso. The book clattered to the floor and shut as %scholar_short%\'s hands involuntarily let go of it. Their flesh began to slough off, and as they looked at you in fear their face lit up with a green flame and fell cleanly into a pile of slop on the ground, leaving just their exposed skull. | You agreed, and %scholar_short% jumped up and down with a giddy excitement. You brought them to your tent and showed them the book, mentioning how it had taught all that you knew. They nodded and sat down at your desk, picking up the book and leafing through the first page or two. They rapidly put it down and began holding their throat in anguish. As they turned to you, their face lit up in a green flame as you noticed a pile of red and tan ooze on the ground - what had formerly been their flesh. Their face fell away, leaving only an empty, hollow skull staring back. | You consented and came up with a rough lesson plan for them. Start small, maybe on rodents and small animals, before working their way up. To you, necromancy came oddly naturally, and %scholar_short% was clearly no natural. You asked another member of your company to bring you a dead rat for an unspecified reason and left %scholar_short% to peruse through the book at their leisure. When you returned, you were surprised to find a skeleton, idly sitting at your desk, a pile of red ooze covering your chair and the ground around it. It took you a second to realize that this was all that was left of %scholar_short%.} They seem a hollow shell of their previous selves, but unlife clings to those empty cavities in their skull.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A shame, they showed great promise.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Necromancer.getImagePath());
                // skeletonize
                _event.m.Scholar.m.MoraleState = this.Const.MoraleState.Ignore;
                _event.m.Scholar.getFlags().add("PlayerSkeleton");
                _event.m.Scholar.getFlags().add("undead");
                _event.m.Scholar.getFlags().add("skeleton");
                local fleshlessSkill = this.new("scripts/skills/traits/legend_fleshless_trait");
                _event.m.Scholar.getSkills().add(fleshlessSkill);
                _event.m.Scholar.getSkills().add(this.new("scripts/skills/racial/skeleton_racial"));
                _event.m.Scholar.getSkills().add(this.new("scripts/skills/perks/perk_nine_lives"));
                local actor = _event.m.Scholar;
                local body = actor.getSprite("body");
                body.setBrush("bust_skeleton_body_0" + this.Math.rand(1, 2));
                body.Saturation = 0.8;
                body.varySaturation(0.2);
                body.varyColor(0.025, 0.025, 0.025);

                if (actor.getFlags().has("human"))
                {
                    actor.getSprite("injury_body").setBrush("bust_skeleton_body_injured");
                }

                if (this.isKindOf(actor, "player"))
                {
                    actor.improveMood = function ( _change, _text = "" )
                    {
                    };
                    actor.worsenMood = function ( _change, _text = "" )
                    {
                    };
                }

                local head = actor.getSprite("head");
                head.setBrush("bust_skeleton_head");
                head.Color = body.Color;
                head.Saturation = body.Saturation;
                // skeletonize
				this.Characters.push(_event.m.Scholar.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/traits/fleshless_trait.png",
					text = _event.m.Scholar.getName() + " is now a skeleton."
				});
                if (this.Math.rand(1, 100) <= 25){ // ALTER BACK LATER
                    this.List.push(
						{
							id = 10,
							icon = "ui/perks/raisedead2_circle.png",
							text = _event.m.Scholar.getName() + " seems to have learned in spite of their condition."
						});
                    _event.m.Scholar.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendBrinkOfDeath, 4, true);
                    _event.m.Scholar.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendPossession, 2, false);
                    _event.m.Scholar.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendRaiseUndead, 6, true);
                    _event.m.Scholar.getFlags().set("IsNecromancer", true);
                }
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2 || this.World.Assets.getOrigin().getID() != "scenario.dse_forbidden_knowledge")
		{
			return;
		}

		local necromancer = null;
		local scholar_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				necromancer = bro;
			}
			else if ((bro.getBackground().getID() == "background.historian" || bro.getBackground().getID() == "background.legend_witch" || bro.getBackground().getID() == "background.legend_commander_witch") || bro.getBackground().getID() == "background.legend_alchemist" || bro.getBackground().getID() == "background.legend_astrologist" || bro.getBackground().getID() == "background.anatomist" || bro.getSkills().hasSkill("perk.legend_scholar") || bro.getSkills().hasSkill("trait.bright") || bro.getSkills().hasSkill("trait.ambitious"))
			{ // historians, witches, alchemists, anatomists, astrologists, and other smart people (scholars, ambitious & bright characters)
                // who neither hate undead nor fear them and aren't dumb, also aren't already undead
                if(!(bro.getSkills().hasSkill("trait.dumb") || bro.getSkills().hasSkill("trait.fear_undead") || bro.getSkills().hasSkill("trait.hate_undead") || bro.getSkills().hasSkill("trait.legend_fleshless") || bro.getSkills().hasSkill("trait.legend_rotten_flesh")))
                {
                    if(!bro.getFlags().get("IsNecromancer")){ //AND aren't already a necromancer.
                        scholar_candidates.push(bro);
                    }
                }
			}
		}

		if (necromancer == null || scholar_candidates.len() == 0)
		{
			return;
		}

		this.m.Necromancer = necromancer;
		this.m.Scholar = scholar_candidates[this.Math.rand(0, scholar_candidates.len() - 1)];
		this.m.Score = 6;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"necromancer",
			this.m.Necromancer.getName()
		]);
		_vars.push([
			"necromancer_short",
			this.m.Necromancer.getNameOnly()
		]);
		_vars.push([
			"scholar",
			this.m.Scholar.getName()
		]);
		_vars.push([
			"scholar_short",
			this.m.Scholar.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Necromancer = null;
		this.m.Scholar = null;
	}

});

