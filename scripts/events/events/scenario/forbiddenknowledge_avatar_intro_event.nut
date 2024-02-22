this.forbiddenknowledge_avatar_intro_event <- this.inherit("scripts/events/event",  {
    m = {}, // code taken from Cabal origin format.
    function create(){
        this.m.ID = "event.forbiddenknowledge_avatar_intro_event";
        this.m.IsSpecial = true;
        this.m.Screens.push({
            ID = "A",
            Text = "[img]gfx/ui/events/event_forbiddenknowledge_origin.png[/img]You saw something you shouldn't have. The cave in the distance looked promising, a bright blue light called you there and like a moth to the flame you blindly followed it. Deep into the depths of the earth you followed that light. It felt like you were walking for hours, days, maybe years; you're really not sure. All you know is that when you got there you saw the book laying there, closed. You opened it. It's just a book, right? What's the worst that can happen? \n\nIn that moment, your mind was filled with knowledge that others have died gathering. You're still you - you think - but you have strange thoughts that aren't your own; after all, what is life but a pathway to death, and what is death but the opportunity for service? You need to get out there and become someone. You have your money, and most of your wits. Maybe you can use this power to do some good... or maybe just earn a few easy coins.",
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
			}
        });
    }
	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Forbidden Knowledge";
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