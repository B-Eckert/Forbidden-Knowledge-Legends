this.forbidden_knowledge_hated_lich <- this.inherit("scripts/scenarios/world/starting_scenario", { // This code takes largely from the Random Solo Party origin & the Cabal.
	m = {},
	function create()
	{
		this.m.ID = "scenario.dse_forbidden_knowledge_hated_lich";
		this.m.Name = "Forbidden Knowledge: Hated Lich";
		this.m.Description = "[p=c][img]gfx/ui/events/event_forbiddenknowledge_become_lich.png[/img][/p][p] Long have you studied with the magics and powers you have access to. Long have you pored over ancient tomes and manuals of forgotten lore to get to the point you're at now. Long have you decieved and lied to get the souls of the powerful. It is time to unleash your strength upon the world.\n\n[color=#bcad8c]Powerful Lich:[/color] You are a powerful lich. You start with a level 11 Avatar with the Lich trait.\n[color=#bcad8c]Avatar:[/color] If you die, it\'s game over.\n[color=#2fbd90]Immersed in Cursed Knowledge:[/color] You know the secrets of Necromancy. You can teach academics these secrets as well.[/p]\n[color=#bcad8c]Hated and Feared:[/color] You are hated and feared. You have negative relations with all of the city states and positive relations with the Undead. You can only gain allies by recruiting willing captives to lord over. You can have up to 27 in your roster.";
		this.m.Difficulty = 4;
		this.m.Order = 284;
		this.m.IsFixedLook = true;
		this.m.StartingBusinessReputation = 100;
		this.m.StartingRosterTier = this.Const.Roster.getTierForSize(27); // start at max size
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
            // make a new background for Lich Lord
			bro.setStartValuesEx(this.Const.CharacterBackgroundsRandom);
			i = ++i;
			i = i;
		}

		local bros = roster.getAll();
		bros[0].getSprite("miniboss").setBrush("bust_miniboss_undead");
		bros[0].m.PerkPoints = 10;
		bros[0].m.LevelUps = 10;
		bros[0].m.Level = 11;
		bros[0].setVeteranPerks(10);
		bros[0].getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		this.Const.Necromance.LearnNecromancy(bros[0]);
        // lich trait
		bros[0].getSkills().add(this.new("scripts/skills/traits/forbiddenknowledge_lich_trait"));
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
        // set relations - sampled from Risen Legion start.
        // PEOPLE WHO HATE YOU ======================================================================
        local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		foreach( n in nobles ) { n.addPlayerRelation(-400.0, "They hate us for our strength..."); }
		local oriental = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);
		foreach( n in oriental ) { n.addPlayerRelation(-400.0, "They hate us for our heresies..."); }
        local settlers = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.Settlement);
		foreach( n in settlers ) { n.addPlayerRelation(-400.0, "They hate what they do not understand..."); }
        // PEOPLE WHO LOVE YOU =======================================================================
		local skellies = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.Undead);
		foreach( n in skellies ) { n.addPlayerRelation(400.0, "They are weak automata..."); }
        local zombies = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.Zombies);
		foreach( n in zombies ) { n.addPlayerRelation(400.0, "They envy my power... but they respect it."); }
        fixRelations(); // this triggers them becoming nonhostile I believe. It doesn't override the relation number.
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
        fixRelations();
		return false;
	}
    function fixRelations(){
        // FRIENDLY UNDEAD
        this.World.FactionManager.makeZombiesFriendlyToPlayer();
        this.World.FactionManager.makeUndeadFriendlyToPlayer();
        // ANGRY PEOPLE
        this.World.FactionManager.makeNoblesUnfriendlyToPlayer();
        this.World.FactionManager.makeSettlementsUnfriendlyToPlayer();
        // this.World.FactionManager.makeOrientalsUnfriendlyToPlayer();
    }
});