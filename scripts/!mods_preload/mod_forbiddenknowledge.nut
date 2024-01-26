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
	Version = "1.0.4"
};

::mods_registerMod(::Mod_dseForbiddenKnowledgeOrigin.ID, ::Mod_dseForbiddenKnowledgeOrigin.Version, ::Mod_dseForbiddenKnowledgeOrigin.Name);
::mods_queue(::Mod_dseForbiddenKnowledgeOrigin.ID, "mod_legends,mod_msu", function() {
    // does nothing for now
    ::Mod_dseForbiddenKnowledgeOrigin.Mod <- ::MSU.Class.Mod(::Mod_dseForbiddenKnowledgeOrigin.ID, ::Mod_dseForbiddenKnowledgeOrigin.Version, ::Mod_dseForbiddenKnowledgeOrigin.Name);

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
                    if (this.m.CurrentProperties.SurvivesAsUndead && !this.World.Assets.m.IsSurvivalGuaranteed && !this.getFlags().has("PlayerZombie") && !this.getFlags().has("PlayerSkeleton"))
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
            ::logInfo(zombie.getName() + " is being stored in the zombie log by " + _user.getName());
        }
       // local old_onCombatFinished = o.onCombatFinished; - DNE so no override
        o.onCombatFinished <- function() {
         //   old_onCombatFinished();
            while(this.m.SpawnedUndead.len() != 0){
                local pair = this.m.SpawnedUndead.pop();
                pair[0].kill(pair[1], this, this.Const.FatalityType.Kraken, true); // Nyarlathotep takes his toll and removes them.
                ::logInfo(pair[1].getName() + " is terminating " + pair[0].getName());
            }
        }
    });
});