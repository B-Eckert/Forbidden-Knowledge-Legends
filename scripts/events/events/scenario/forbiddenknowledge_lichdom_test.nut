this.forbiddenknowledge_lichdom_test <- this.inherit("scripts/events/event",  {
    m = {
        Necromancer = null
    }, // code taken from Cabal origin format.
    function create(){
        this.m.ID = "event.forbiddenknowledge_lichdom_test";
        this.m.Screens.push({
            ID = "A",
            Text = "[img]gfx/ui/events/event_forbiddenknowledge_necro_origin.png[/img]MWAHAHAHAH, YOU HAVE BECOME THE SOY SKELETOR!",
            Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let's see what the world has for me.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
                this.Const.Necromance.AchieveLichdom(_event.m.Necromancer);
                this.List.push({
					id = 10,
					icon = "ui/perks/align_joints_circle.png",
					text = _event.m.Necromancer.getName() + " is now SKELETOR."
				});
			}
        });
    }
	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 1 || this.World.Assets.getOrigin().getID() != "scenario.dse_forbidden_knowledge")
		{
			return;
		}

		local necromancer = null;

		foreach( bro in brothers )
		{
			if (bro.getFlags().get("IsPlayerCharacter") && this.World.Assets.getOrigin().getID() != "scenario.dse_forbidden_knowledge")
			{
				necromancer = bro;
			}
			else if(bro.getFlags().get("IsNecromancer")){
				necromancer = bro;
			}
		}

		if (necromancer == null)
		{
			return;
		}

		this.m.Necromancer = necromancer;
		this.m.Score = 9001; // ITS OVER 9000
	}

	function onPrepare()
	{
		this.m.Title = "Lichdom";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"home",
			this.World.Flags.get("HomeVillage")
		]);
	}

	function onClear()
	{
	}

});