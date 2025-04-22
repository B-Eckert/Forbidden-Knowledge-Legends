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
			Text = "[img]gfx/ui/events/event_forbidden_knowledge_teaching_necromancy_begging.png[/img]During your travels, %scholar% has taken an interest in %necro%\'s occult knowledge. You\'ve noticed them {taking a peek or two at the book that %necro_s% gleans their knowledge from, sneaking glances and reading a sentence or two over their shoulder | watching %necro_s% in awe, mouth agape, as %necro_s% conjures their magics and restores life to the dead | pondering the question of life and death, and the tenuous boundary between the two}. \n\nFinally, it seems %scholar_short% has mustered up the confidence to speak to %necro_s% and ask them to share their knowledge. On one hand, having an apprentice to teach would be very beneficial... but on the other hand, why share?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%necro_s% will teach %scholar_short%.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 70 || !this.Const.Necromance.CanChangeSprite(_event.m.Scholar) ? "B" : "C"; // 70/30 chance it goes terribly and they turn into a skeleton unless they're a donkey or inhuman, in which case the 30% doesnt trigger because bones
					}
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
			Text = "[img]gfx/ui/events/event_forbiddenknowledge_teaching_necromancy.png[/img]{They both pore over the book together, and %necro_s%\'s unnatural insights paired with %scholar_short%\'s keen mind make for quick learning. Thankfully, in this line of work there is no shortage of bodies. %necro_s% digs one up under the moonlight that night and instructs their student on the finer points of raising the dead. Suddenly, just as they were getting to the crux of their explanation, they hear a moaning noise behind them as the corpse rises and groans. | %necro_s% conducts a carefully-constructed lesson plan, introducing %scholar_short% to rites, incantations, and the basics of possession. Soon, %scholar_short% is animating the corpses of mice, then cats, then dogs. After some time, %necro_s% feels that %scholar_short% has learned enough to move onto a real body. Under the cover of night, %necro_s% unearths a body and crosses their arms expectantly, watching and waiting. %necro_s% notices the barest glimmer of life enter the body through no input of their own. | %necro_s% hands over their book of accursed secrets, watching over %scholar_short%\'s shoulder as they pore through the arcane knowledge. They seem to devour it voraciously, and as they read they quickly begin asking a flurry of questions. Does the variety of creature the fat comes from affect the ritual? Does the recency or potency of the blood spilt matter? After some time, %necro_s% begins to give him vaguer and vaguer answers until, at last, they attempt a ritual. %necro_s% oversees them as they unearth a body and, with little input from %necro_s%, animate it with the barest glimmer of life.}\n\nAs %scholar_short% learns the secrets, pigment is drained from their skin and their eyes gloss over with the pale white color of death. They look like they have aged a thousand years in ten minutes. However, %scholar_short% has joined the ranks of those who are masters over such a simple thing as death. Yes... this one will do nicely.",
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
				this.Const.Necromance.LearnNecromancy(_event.m.Scholar); // learn necromancy so theres time for the aesthetic update to do
                // TODO: Replace this with gaining necromancy perks.  Possibly positive mood.
				_event.m.Necromancer.improveMood(2.0, "Taught " + _event.m.Scholar.getName() + " necromancy");
				_event.m.Scholar.improveMood(2.0, "Was taught necromancy by " + _event.m.Necromancer.getName() + ".");

				this.Characters.push(_event.m.Necromancer.getImagePath());
				this.Characters.push(_event.m.Scholar.getImagePath());

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
			Text = "[img]gfx/ui/events/event_forbiddenknowledge_teaching_necromancy_bad_end.png[/img]%necro% wasn\'t quite sure what to expect, but it definitely wasn\'t this. {%necro_s% showed them the book and almost instantly %scholar_short% picked it up and began to eagerly flip through the pages. What %scholar_short% didn\'t notice was that their hand was enveloped in a green energy that snaked up their arms, wrapping around their torso like a posionous snake preparing for the kill. The book clattered to the floor and shut as %scholar_short%\'s eyes widened in shock. Their flesh began to slough off, and as they looked at %necro_s% in fear their face lit up with a green flame. Their skin and flesh fell cleanly into a pile of slop on the ground, leaving just their exposed skull. | %necro_s% agreed, and %scholar_short% jumped up and down with a giddy excitement. %necro_s% brought %scholar_short% to their tent and showed them the book, mentioning how it had taught them all that they knew. %scholar_short% nodded and sat down at their desk, picking up the book and leafing through the first page or two. They rapidly put it down and began holding their throat in anguish. As they turned, their face lit up in a green flame and %necro_s% noticed a pile of red and tan ooze slopped onto the ground - what had formerly been their flesh. Their face fell away, leaving only an empty, hollow skull staring back. | %necro_s% consented and came up with a rough lesson plan for them. Start small, maybe on rodents and small animals, before working their way up. To %necro_s%, necromancy came oddly naturally, and %scholar_short% was clearly no natural. %necro_s% asked another member of the company to bring them a dead rat for an unspecified reason and left %scholar_short% to peruse through the book at their leisure. When %necro_s% returned, they were surprised to find a skeleton, idly sitting at their desk. A pile of red ooze covered %necro_s%\'s chair and the ground around it. After a moment, they realized that this was all that was left of %scholar_short%.} %scholar_short% seems a hollow shell of their previous selves, but unlife clings to those empty cavities in their skull.",
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
                this.Const.Necromance.Skeletonize(_event.m.Scholar);
				// skeletonize
				this.Characters.push(_event.m.Scholar.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/perks/align_joints_circle.png",
					text = _event.m.Scholar.getName() + " is now a skeleton."
				});
                if (this.Math.rand(1, 100) <= 25){
                    this.List.push(
						{
							id = 10,
							icon = "ui/perks/obituary.png",
							text = _event.m.Scholar.getName() + " seems to have learned in spite of their condition."
						});
					this.Const.Necromance.LearnNecromancy(_event.m.Scholar);
                }
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2 || !this.Const.Necromance.IsFBOrigin(this.World.Assets.getOrigin().getID()))
		{
			return;
		}

		local necromancer = null;
		local scholar_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getFlags().has("IsPlayerCharacter") && bro.getFlags().has("IsNecromancer"))
			{
				necromancer = bro;
			}
			else if(bro.getFlags().has("IsNecromancer")){ // player necromancer has priority
				if(necromancer == null){
					necromancer = bro;
				}
			}
			else if (this.Const.Necromance.CanLearnNecromancy(bro) && this.Const.Necromance.CanChangeSprite(bro)) {
                scholar_candidates.push(bro);
			}
		}

		if (necromancer == null || scholar_candidates.len() == 0)
		{
			return;
		}

		this.m.Necromancer = necromancer;
		this.m.Scholar = scholar_candidates[this.Math.rand(0, scholar_candidates.len() - 1)];
		this.m.Score = 75; // make it a lil higher priority ALTER
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

