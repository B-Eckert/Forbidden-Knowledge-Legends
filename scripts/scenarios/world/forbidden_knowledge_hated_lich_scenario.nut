this.forbidden_knowledge_hated_lich_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", { // This code takes largely from the Random Solo Party origin & the Cabal.
	m = {},
	function create()
	{
		this.m.ID = "scenario.dse_forbidden_knowledge_hated_lich";
		this.m.Name = "The Hated Lich";
		this.m.Description = "[p=c][img]gfx/ui/events/forbidden_knowledge_lich_origin.png[/img][/p][p] Long have you studied with the magics and powers you have access to. Long have you pored over ancient tomes and manuals of forgotten lore to get to the point you're at now. Long have you decieved and lied to get the souls of the powerful. It is time to unleash your strength upon the world.\n\n[color=#bcad8c]Powerful Lich:[/color] You are a powerful lich. You start with a level 11 Avatar with the Lich trait.\n[color=#bcad8c]Avatar:[/color] If you die, it\'s game over.\n[color=#2fbd90]Immersed in Cursed Knowledge:[/color] You know the secrets of Necromancy. You can teach academics these secrets as well.\n[color=#bcad8c]Hated and Feared:[/color] You are hated and feared. You have negative relations with all of the city states and positive relations with the Undead. You can only gain allies by recruiting minions after battles. You can have up to 27 in your roster. (You can still alt+click to attack undead parties.)[/p]";
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
			bro.setStartValuesEx(["legend_necromancer_background"]);
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
		local items =  bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand)); // starts wtih grim scythe which is silly
		items.equip(this.new("scripts/items/weapons/legend_scythe")); // give regular scythe for scythe perk
        // lich trait
		bros[0].getSkills().add(this.new("scripts/skills/traits/forbiddenknowledge_lich_trait"));
		bros[0].getSkills().add(this.new("scripts/skills/perks/perk_legend_brink_of_death"));
		bros[0].getFlags().set("IsPlayerCharacter", true);
		this.World.Assets.addBusinessReputation(this.m.StartingBusinessReputation);

		this.World.Assets.addMoralReputation(-500.0);
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
		foreach( n in skellies ) { n.addPlayerRelation(400.0, "They are weak automata... I can pretend to be their superior."); }
        local zombies = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.Zombies);
		foreach( n in zombies ) { n.addPlayerRelation(400.0, "They envy my power... but they respect it."); }
        //fixRelations(); // this triggers them becoming nonhostile I believe. It doesn't override the relation number.
		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(104);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(["music/undead_01.ogg"], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.forbiddenknowledge_hated_lich_intro_event");
		}, null);
		this.World.Flags.set("HasLegendCampGathering", true);
		this.World.Flags.set("HasLegendCampCrafting", true);
		this.World.Flags.set("HasLegendCampFletching", true);
		this.World.Flags.set("HasLegendCampHealing", true);
		this.World.Flags.set("HasLegendCampHunting", true);
		this.World.Flags.set("HasLegendCampScouting", true);
		this.World.Flags.set("HasLegendCampScraping", true);
		this.World.Flags.set("HasLegendCampTraining", true);
	}

	function onInit()
	{
		this.starting_scenario.onInit();
		this.World.Flags.set("IsLegendsNecro", true);
		this.World.Assets.m.BuyPriceMult = 1.5;
		this.World.Assets.m.SellPriceMult = 0.5;
	}

	function onHiredByScenario( bro )
	{
		bro.getBaseProperties().DailyWageMult *= 0; // No wage cost.
		bro.getSkills().update(); // ?
	}

	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			if (bro.getFlags().has("IsPlayerCharacter"))
			{
				//fixRelations();
				return true;
			}
		}
		return false;
	}
    function fixRelations(){
        // FRIENDLY UNDEAD
        this.World.FactionManager.makeZombiesFriendlyToPlayer();
        this.World.FactionManager.makeUndeadFriendlyToPlayer();
        // ANGRY PEOPLE
        this.World.FactionManager.makeNoblesUnfriendlyToPlayer();
        this.World.FactionManager.makeSettlementsUnfriendlyToPlayer();
    	this.World.FactionManager.makeOrientalsUnfriendlyToPlayer();
    }
});