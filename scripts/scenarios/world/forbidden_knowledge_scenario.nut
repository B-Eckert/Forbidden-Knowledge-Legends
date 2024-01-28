this.forbidden_knowledge_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", { // This code takes largely from the Random Solo Party origin & the Cabal.
	m = {},
	function create()
	{
		this.m.ID = "scenario.dse_forbidden_knowledge";
		this.m.Name = "Forbidden Knowledge";
		this.m.Description = "[p=c][img]gfx/ui/events/event_forbiddenknowledge_origin.png[/img][/p][p] You've learned something you shouldn't have from a book you shouldn't have read, but you're here now. It's your choice what you do with the knowledge you now possess.\n\n[color=#bcad8c]Random Character:[/color] Your background and equipment will be different each time you start.\n[color=#bcad8c]Avatar:[/color] If you die, it\'s game over.\n[color=#2fbd90]Cursed Knowledge:[/color] You have a few useful necromancy perks added to your perk tree. You can teach academics these secrets as well.[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 283;
		this.m.IsFixedLook = true;
		this.m.StartingBusinessReputation = 100;
		this.m.StartingRosterTier = this.Const.Roster.getTierForSize(6);
		this.m.RosterTierMax = this.Const.Roster.getTierForSize(27);
		this.setRosterReputationTiers(this.Const.Roster.createReputationTiers(this.m.StartingBusinessReputation));
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();

		for( local i = 0; i < 1; i = i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.setStartValuesEx(this.Const.CharacterBackgroundsRandom);
			i = ++i;
			i = i;
		}

		local bros = roster.getAll();
		bros[0].getSprite("miniboss").setBrush("bust_miniboss_undead");
		bros[0].m.PerkPoints = 3;
		bros[0].m.LevelUps = 3;
		bros[0].m.Level = 4;
		bros[0].setVeteranPerks(2);
		bros[0].getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		// Thank you LoneMind for the help <3
		/*bros[0].getBackground().addPerk(this.Const.Perks.PerkDefs.LegendBrinkOfDeath, 4, true);
		bros[0].getBackground().addPerk(this.Const.Perks.PerkDefs.LegendPossession, 2, false);
		bros[0].getBackground().addPerk(this.Const.Perks.PerkDefs.LegendRaiseUndead, 6, true);
		*/
		this.Const.Necromance.LearnNecromancy(bros[0])
		bros[0].getFlags().set("IsPlayerCharacter", true);
		this.World.Assets.addBusinessReputation(this.m.StartingBusinessReputation);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/smoked_ham_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/beer_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money * 3;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3)
			{
				break;
			}

			i = ++i;
			i = i;
		}

		local randomVillageTile = randomVillage.getTile();

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 1), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 1));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 1), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 1));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) == 0)
				{
				}
				else if (!tile.HasRoad)
				{
				}
				else
				{
					randomVillageTile = tile;
					break;
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(104);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.CivilianTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.forbiddenknowledge_avatar_intro_event");
		}, null);
	}

	function onInit()
	{
		this.starting_scenario.onInit();
		this.World.Flags.set("IsLegendsNecro", true);
	}


	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			if (bro.getFlags().has("IsPlayerCharacter"))
			{
				return true;
			}
		}

		return false;
	}

});