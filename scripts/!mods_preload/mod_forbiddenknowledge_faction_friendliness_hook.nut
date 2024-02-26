local gt = this.getroottable();
if (!("ForbiddenKnowledgeMod" in gt.Const)) {
    gt.Const.ForbiddenKnowledgeMod <- {};
}
this.getroottable().Const.ForbiddenKnowledgeMod.hookOrientalsUnfriendly <-  function(){
    ::mods_hookExactClass("factions/faction_manager", function(o) {
		o.makeOrientalsUnfriendlyToPlayer <- function()
		{
			for( local i = 0; i < this.m.Factions.len(); i = i )
			{
				if (this.m.Factions[i] == null)
				{
				}
				else if (this.m.Factions[i].getType() == this.Const.FactionType.OrientalCityState)
				{
					if (this.m.Factions[i].getPlayerRelation() > -80)
					{
						this.m.Factions[i].setPlayerRelation(-80.0);
						this.logInfo("Making southerners unfriendly");
					}
				}
				i = ++i;
			}
		}
    });
}
/*
    function makeOrientalsUnfriendlyToPlayer()
	{
		for( local i = 0; i < this.m.Factions.len(); i = i )
		{
			if (this.m.Factions[i] == null)
			{
			}
			else if (this.m.Factions[i].getType() == this.Const.FactionType.OrientalCityState)
			{
				if (this.m.Factions[i].getPlayerRelation() > -80)
				{
					this.m.Factions[i].setPlayerRelation(-80.0);
					this.logInfo("Making southerners unfriendly");
				}
			}

			i = ++i;
		}
	}
    */