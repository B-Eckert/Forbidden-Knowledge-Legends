this.forbiddenknowledge_disliked_necro_intro_event <- this.inherit("scripts/events/event",  {
    m = {}, // code taken from Cabal origin format.
    function create(){
        this.m.ID = "event.forbiddenknowledge_disliked_necro_intro_event";
        this.m.IsSpecial = true;
        this.m.Screens.push({
            ID = "A",
            Text = "[img]gfx/ui/events/event_forbiddenknowledge_necro_origin.png[/img] Secreted away in the depths of the world you have long studied ancient tomes of lore and gathered your dark power. You finally feel ready to set out upon the world and carve your path through it. With your thralls at your side and more to raise, you are sure to be unstoppable. You repeat the old mantra to yourself before you set out. Your master was weak, soon you'll be all powerful!",
            Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It is time to enact my will upon the world.",
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
		this.m.Title = "The Despised Necromancer";
		local zombieSites = [
            "location.undead_crypt",
            "location.undead_necromancers_lair"
        ]
		local randomCrypt;
		for( local i = 0; i != this.World.EntityManager.getLocations().len(); i = i )		{
			randomCrypt = this.World.EntityManager.getLocations()[i];
			//::logInfo("UNDEAD SETTLEMENT FINDER: The result of this function is: " + randomCrypt.getTypeID() + " which should have an undead settlement");
			if (zombieSites.find(randomCrypt.getTypeID()) != null) {
				//::logInfo("UNDEAD SETTLEMENT FINDER: Found undead settlement: " + randomCrypt.getTypeID() + " which will spawn our necro");
				break;
			}
			i = ++i;
			i = i;
		}

	    local tilePos = randomCrypt.getTile().Pos;
	    this.World.State.getPlayer().setPos(tilePos);
	    this.World.setPlayerPos(tilePos);
	    this.World.getCamera().setPos(tilePos);
	    randomCrypt.onDiscovered();

	}

	function onPrepareVariables( _vars ) {
	}

	function onClear()
	{
	}

});