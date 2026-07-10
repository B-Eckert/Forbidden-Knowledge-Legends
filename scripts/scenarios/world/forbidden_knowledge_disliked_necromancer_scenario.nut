this.forbidden_knowledge_disliked_necromancer_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", { // This code takes largely from the Random Solo Party origin & the Cabal.
	m = {},
	function create()
	{
		this.m.ID = "scenario.dse_forbidden_knowledge_disliked_necromancer";
		this.m.Name = "(FB) Despised Necromancer";
		this.m.Description = "[p=c][img]gfx/ui/events/event_forbiddenknowledge_necro_origin.png[/img][/p][p] Long have you studied the dark arts. The foolish commoners don't trust you, they see you as a vile practicioner of magic staking out in the woods... but you know better, of course.\n\n[color=#bcad8c]Experienced Necromancer:[/color] You are an experienced necromancer. You start with a level 7 Necromancer Avatar and two random zombies.\n[color=#bcad8c]Avatar:[/color] If you die, it\'s game over.\n[color=#2fbd90]Immersed in Cursed Knowledge:[/color] You know the secrets of Necromancy. You can teach academics these secrets as well.\n[color=#bcad8c]Disliked and Misunderstood:[/color] You are disliked and misunderstood. You have negative relations with all villages and the Southerners and positive relations with the Undead. Nobles don't care about you. (You can still alt+click to attack undead parties.)[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 284;
		this.m.IsFixedLook = true;
		this.m.StartingBusinessReputation = 100;
		this.m.StartingRosterTier = this.Const.Roster.getTierForSize(12); // start at mid size
		this.m.RosterTierMax = this.Const.Roster.getTierForSize(27);
		this.setRosterReputationTiers(this.Const.Roster.createReputationTiers(this.m.StartingBusinessReputation));
		this.m.PermittedNecroRoster <- [
			"necromancer",
			"cultist",
			"assassin",
			"beggar",
			"cripple",
			"deserter",
			"gravedigger",
			"graverobber",
			"killer_on_the_run",
			"ratcatcher",
			"refugee",
			"thief",
			"vagabond",
			"legend_witch",
			"legend_death_summoner",
			"legend_necromancer",
			"legend_necrosavant",
			"legend_conjurer",
			"legend_warlock",
			"eunuch",
			"legend_cannibal",
			"legend_donkey",
			"slave",
			"slave_southern",
			"gladiator",
			"legend_gladiator_prizefighter",
			"legend_alchemist",
			"legend_husk",
			"anatomist",
			"crucified",
			"gambler"
		];
		//.slice(0, -11)
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();

		for( local i = 0; i < 1; i = i++ ) {
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
            // make a new background for Lich Lord
			bro.setStartValuesEx(["legend_necromancer_background"]);
		}
		for( local i = 0; i < 2; i = i++ ) {
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.setStartValuesEx(this.Const.CharacterBackgroundsRandom);
		}

		local bros = roster.getAll();
		bros[0].getSprite("miniboss").setBrush("bust_miniboss_undead");
		bros[0].m.PerkPoints = 6;
		bros[0].m.LevelUps = 6;
		bros[0].m.Level = 7;
		bros[0].setVeteranPerks(2);
		bros[0].getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		this.Const.Necromance.LearnNecromancy(bros[0]);
		local items =  bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand)); // starts wtih grim scythe which is silly
		items.equip(this.new("scripts/items/weapons/legend_scythe")); // give regular scythe for scythe perk
		bros[0].getSkills().add(this.new("scripts/skills/perks/perk_legend_brink_of_death"));
		bros[0].getFlags().set("IsPlayerCharacter", true);
		local undeadType = this.Math.rand(1, 100);
        if(undeadType > 25){
        	this.Const.Necromance.Zombify(bros[1]);
        }
        else {
        	this.Const.Necromance.Skeletonize(bros[1]);
        }
		undeadType = this.Math.rand(1, 100);
        if(undeadType > 25){
        	this.Const.Necromance.Zombify(bros[2]);
        }
        else {
        	this.Const.Necromance.Skeletonize(bros[2]);
        }
		this.World.Assets.addBusinessReputation(this.m.StartingBusinessReputation);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/smoked_ham_item"));
		this.World.Assets.addMoralReputation(10.0); // Cruel
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i++ ){
			randomVillage = this.World.EntityManager.getSettlements()[i];
			if (randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3) {
				break;
			}
		}
		local randomVillageTile = randomVillage.getTile();
		do {
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 1), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 1));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 1), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 1));

			if (this.World.isValidTileSquare(x, y)) {
				local tile = this.World.getTileSquare(x, y);
				if (!(tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.getDistanceTo(randomVillageTile) == 0 || !tile.HasRoad)) {
					randomVillageTile = tile;
					break;
				}
			}
		}
		while (1);
        // set relations - sampled from Risen Legion start.
        // PEOPLE WHO HATE YOU ======================================================================
		local oriental = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);
		foreach( n in oriental ) { n.setPlayerRelation(-40.0); }
        local settlers = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.Settlement);
		foreach( n in settlers ) { n.setPlayerRelation(-20.0); }
        local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		foreach( n in nobles ) { n.setPlayerRelation(50.0); }
        // PEOPLE WHO LOVE YOU =======================================================================
		local skellies = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.Undead);
		foreach( n in skellies ) { n.addPlayerRelation(400.0, "They are weak automata... I can pretend to be their superior."); }
        local zombies = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.Zombies);
		foreach( n in zombies ) { n.addPlayerRelation(400.0, "They envy my power... but they respect it."); }
        //fixRelations(); // this triggers them becoming nonhostile I believe. It doesn't override the relation number.
		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(104);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag ) {
			this.Music.setTrackList(["music/undead_01.ogg"], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.forbiddenknowledge_disliked_necro_intro_event");
		}, null);
	}

	function onInit() {
		this.starting_scenario.onInit();
		this.World.Flags.set("IsLegendsNecro", true);
		this.World.Assets.m.BuyPriceMult = 1.5;
		this.World.Assets.m.SellPriceMult = 0.5;
	}

	function onHiredByScenario( bro ) {
		bro.getBaseProperties().DailyWageMult *= 0; // No wage cost.
		bro.getSkills().update(); // ?
	}

	function onUpdateHiringRoster( _roster )
	{
		local garbage = [];
		local bros = _roster.getAll();
		foreach( i, bro in bros )
		{
			if (this.m.PermittedNecroRoster.find(bro.getBackground().getID()) == null && bro.getBackground().getID().find("horse") == null) {//delete noncrap or nonanimal recruits
				garbage.push(bro);
			}
		}
		foreach (g in garbage)
			_roster.remove(g);
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
});