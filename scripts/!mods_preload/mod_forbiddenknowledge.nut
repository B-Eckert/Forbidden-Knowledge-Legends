/* since you are already using MSU bc it's a Legends dependency if you follow MSU conventions
here you no longer have to abbreviate your mods with the ugly zzz_modName for the zip name.
MSU will auto que your mod as it recognizes other MSU mods. mods_que now controls the mod(s)
ordering, so you can now name your zips the much nicer "mod_yourname.version#"
Modern Hooks has even more nuanced ordering as you can see in the newest Rotu
!mods_preload file. The below file is the non Modern Hooks / basic MSU version.
*/
// Credit to Abysscrane for the standardization of the hooks file.
::Mod_dseForbiddenKnowledgeOrigin <- {
	ID = "mod_dseForbiddenKnowledgeOrigin",
	Name = "Dragonslayerelf\'s Forbidden Knowledge Origin",
	Version = "1.1.1"
};

::mods_registerMod(::Mod_dseForbiddenKnowledgeOrigin.ID, ::Mod_dseForbiddenKnowledgeOrigin.Version, ::Mod_dseForbiddenKnowledgeOrigin.Name);
::mods_queue(::Mod_dseForbiddenKnowledgeOrigin.ID, "mod_legends,mod_msu", function() {
    ::Mod_dseForbiddenKnowledgeOrigin.Mod <- ::MSU.Class.Mod(::Mod_dseForbiddenKnowledgeOrigin.ID, ::Mod_dseForbiddenKnowledgeOrigin.Version, ::Mod_dseForbiddenKnowledgeOrigin.Name);
    // PERK STUFF

    // new perk names
    // Perk Names
    local gt = this.getroottable();

    gt.Const.Strings.PerkName.ForbiddenKnowledgeNecroticScythe <- "Necrotic Scythe";

    // Perk Descriptions
    gt.Const.Strings.PerkDescription.ForbiddenKnowledgeNecroticScythe <- "Infuse your scythe with a small portion of your necromantic magic. Scythes gain damage equal to a portion of your initiative, health and resolve. You gain an armor and direct damage multiplier based on your learn rate. Trained and knowledge potions don't count for this effect. Warscythes gain a smaller portion of this effect.\n\n[color=#288062]Fuelled by Death:[/color] Every kill you make with a scythe empowers your necromantic magic. You gain 25% less Fatigue on your next Necromancy ability per accumulated scythe kill, and spend one stored kill every time you benefit from this feature. If you have more than 4 kills, you instead spend 2 kills and the AP of your next Necromancy ability is reduced by 1 for every 2 kills more than 5 that you have.";

    local perkDefObjects = [
        {
            ID = "perk.forbiddenknowledge_necrotic_scythe",
            Script = "scripts/skills/perks/forbiddenknowledge_necrotic_scythe_perk",
            Name = this.Const.Strings.PerkName.ForbiddenKnowledgeNecroticScythe,
            Tooltip = this.Const.Strings.PerkDescription.ForbiddenKnowledgeNecroticScythe,
            Icon = "ui/perks/perk_necrotic_scythe_forbidden_knowledge.png",
            IconDisabled = "ui/perks/perk_necrotic_scythe_forbidden_knowledge_bw.png",
            Const = "ForbiddenKnowledgeNecroticScythe"
        }
    ]

    gt.Const.Perks.addPerkDefObjects(perkDefObjects);

    gt.Const.Perks.ForbiddenKnowledgeNecromancerTree <- {
        ID = "ForbiddenKnowledgeNecromancerTree",
        Name = "Necromancer",
        Descriptions = [
            "Necromancer"
        ],
        Tree = [
            [this.Const.Perks.PerkDefs.LegendSpecialistScytheSkill], //1
            [this.Const.Perks.PerkDefs.LegendWither], //2
            [this.Const.Perks.PerkDefs.LegendPossession, this.Const.Perks.PerkDefs.LegendSpecialistScytheDamage], //3
            [this.Const.Perks.PerkDefs.ForbiddenKnowledgeNecroticScythe], //4
            [this.Const.Perks.PerkDefs.LegendBrinkOfDeath], //5
            [this.Const.Perks.PerkDefs.LegendDeathtouch, this.Const.Perks.PerkDefs.LegendSiphon], //6
            [this.Const.Perks.PerkDefs.LegendRaiseUndead, this.Const.Perks.PerkDefs.LegendMiasma], //7
        ]
    }

    // HOOK INTO PLAYER CLASS TO OVERRIDE ISREALLYKILLED
    ::mods_hookExactClass("entity/tactical/player", function(o) { // ty Barcode, Abysscrane and LoneMind for this code <3 - Sampled from Rise of the Usurper
        //o = o[o.SuperName]; // maybe i dont need this?
        //local parentClass = ::mods_isClass(o, "player"); // guaranteed to return non-null here
        local old_isReallyKilled = o.isReallyKilled;
        o.isReallyKilled = function(_fatalityType){
            local value = old_isReallyKilled(_fatalityType);
            if(value == false){
                if (this.World.Assets.getOrigin().getID() == "scenario.dse_forbidden_knowledge")
                { // sampled from Risen Legion and Cabal Origin code - credit to legends team.
                    this.Tactical.getSurvivorRoster().remove(this);// to remove
                    if (this.m.CurrentProperties.SurvivesAsUndead && !this.World.Assets.m.IsSurvivalGuaranteed && this.Const.Necromance.CanChangeSprite(this))
                    {
                        local undeadType = this.Math.rand(1, 100);
                        if(undeadType > 25){
                            this.Const.Necromance.Zombify(this);
                        }
                        else {
                            this.Const.Necromance.Skeletonize(this);
                        }
                    }
                    this.Tactical.getSurvivorRoster().add(this);
                }
            }
            return value;
        }
    });

    // necromancy cleanup
    ::mods_hookExactClass("skills/actives/legend_raise_undead", function(o){
        ::logInfo("Raise Undead hook loaded.")
        //o = o[o.SuperName];
        local old_spawnUndead = o.spawnUndead;
        o.m.SpawnedUndead <- [];
        o.spawnUndead = function(_user, _tile){
            old_spawnUndead(_user, _tile);
            local zombie = _tile.getEntity();
            this.m.SpawnedUndead.push([zombie, _user]);
            ::logInfo("RAISE UNDEAD: " + zombie.getName() + " is being stored in the zombie log by " + _user.getName());
        }
       // local old_onCombatFinished = o.onCombatFinished; - DNE so no override
        o.onCombatFinished <- function() {
         //   old_onCombatFinished();
            while(this.m.SpawnedUndead.len() != 0){
                local pair = this.m.SpawnedUndead.pop();
                pair[0].kill(pair[1], this, this.Const.FatalityType.Kraken, true); // Nyarlathotep takes his toll and removes them.
                ::logInfo("RAISE UNDEAD: " + pair[1].getName() + " is terminating " + pair[0].getName());
            }
        }
    });
    // TO BE TESTED
    /* Commented out until I can figure out a bright idea for it to work.
    ::mods_hookExactClass("skills/actives/zombie_bite", function(o){
        ::logInfo("Zombie Bite hook loaded.")
        //o = o[o.SuperName];
        local old_onTargetKilled = o.onTargetKilled;
        o.m.SpawnedUndead <- [];
        o.onTargetKilled = function(_targetEntity, _skill){
            // applicable checks
            old_onTargetKilled(_targetEntity, _skill);
            if (_skill != this)
		    {
		    	return;
		    }
            if (!this.isKindOf(_targetEntity, "player") && !this.isKindOf(_targetEntity, "human"))
            {
                return;
            }
		    local actor = this.getContainer().getActor();

		    if (!this.isKindOf(actor.get(), "player"))
		    {
		    	return;
		    }
            ::logInfo("ZOMBIE BITE: Passed the checks.")
            if (_targetEntity.getTile().IsCorpseSpawned && !_targetEntity.getTile().Properties.get("Corpse").IsResurrectable)
		    {
                local corpse = _targetEntity.getTile().Properties.get("Corpse");
                if(corpse.Faction == this.Const.Faction.PlayerAnimals || corpse.Faction == actor.getFaction()){
                    ::logInfo("ZOMBIE BITE: Passed into the if statement...")
                    local addToZombieList = function(_data) {
                        local zombie = _data[0].getEntity();
                        _data[1].m.SpawnedUndead.push([zombie]);
                        ::logInfo("ZOMBIE BITE: " + zombie.getName() + " is being stored in the zombie log.");
                    }
                    ::logInfo("ZOMBIE BITE: Event scheduled.")
			        this.Time.scheduleEvent(this.TimeUnit.Rounds, this.Math.rand(1, 1), addToZombieList, [_targetEntity.getTile(), this]);
                }
		    }
        }
       // local old_onCombatFinished = o.onCombatFinished; - DNE so no override
        o.onCombatFinished <- function() {
         //   old_onCombatFinished();
            while(this.m.SpawnedUndead.len() != 0){
                local pair = this.m.SpawnedUndead.pop();
                pair[0].kill(pair[0], this, this.Const.FatalityType.Kraken, true); // Nyarlathotep takes his toll and removes them.
                ::logInfo("ZOMBIE BITE: " + pair[0].getName() + " is terminating " + pair[0].getName());
            }
        }
    });*/
});