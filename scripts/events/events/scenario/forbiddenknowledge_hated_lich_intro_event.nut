this.forbiddenknowledge_hated_lich_intro_event <- this.inherit("scripts/events/event",  {
    m = {}, // code taken from Cabal origin format.
    function create(){
        this.m.ID = "event.forbiddenknowledge_hated_lich_intro_event";
        this.m.IsSpecial = true;
        this.m.Screens.push({
            ID = "A",
            Text = "[img]gfx/ui/events/forbidden_knowledge_lich_origin.png[/img]Long have you studied in the deep, dark places of the world. Long have you gathered scrolls, books, tomes, tablets, and all sorts of ancient scribblings of the ancients who invented Necromancy. You've passed on the rites to become a necrosavant, that would be too easy, and you have strived and sought for something greater. You have achieved that greatness, but in the process you have forsaken every bond that you've ever known to become something truly great. You are a Lich now, a mighty undead creature beyond the comprehension of mortals.",
            Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let's see what chaos I can unleash.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}
        });
    }
	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The Hated Lich";
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