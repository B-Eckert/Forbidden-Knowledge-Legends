// placeholder
local gt = this.getroottable();
if (!("ForbiddenKnowledgeMod" in gt.Const)) {
    gt.Const.ForbiddenKnowledgeMod <- {};
}
gt.Const.ForbiddenKnowledgeMod.hookRaiseDead <-  function() {
    ::mods_hookExactClass("skills/actives/legend_raise_undead_skill", function(o){
        //o = o[o.SuperName];
        local old_spawnUndead = o.spawnUndead;
        o.m.SpawnedUndeadFB <- [];
        o.spawnUndead = function(_user, _tile){
            ::logInfo("RAISE UNDEAD: Storing zombie pair...");
            old_spawnUndead(_user, _tile);
            local zombie = _tile.getEntity();
            zombie.setMaster(_user);
            this.m.SpawnedUndeadFB.push([zombie, _user]);
            ::logInfo("RAISE UNDEAD: " + zombie.getName() + " is being stored in the zombie log by " + _user.getName());
        }
       // local old_onCombatFinished = o.onCombatFinished; - DNE so no override
        o.onCombatFinished <- function() {
         //   old_onCombatFinished();
            while(this.m.SpawnedUndeadFB.len() != 0){
                local pair = this.m.SpawnedUndeadFB.pop();
                ::logInfo("RAISE UNDEAD: " + pair[1].getName() + " is terminating " + pair[0].getName());
                //pair[0].setFaction(this.Const.Faction.Enemy);
                try {
                pair[0].kill(pair[1], this, this.Const.FatalityType.Smashed, true); // Nyarlathotep takes his toll and removes them.
                } catch (exception){
                    ::loginfo("RAISE UNDEAD EXECUTION FAILED: " + pair[1].getName() + " failed to terminate " + pair[0].getName() + " with error: " + exception);
                }
                //::logInfo("RAISE UNDEAD: " + pair[1].getName() + " has terminated " + pair[0].getName());
            }
        }
    });
    ::mods_hookExactClass("entity/tactical/enemies/zombie",  function(o){
        local old_onDeath = o.onDeath;
        o.setMaster <- function(_master){
            this.m.Master <- _master;
        }
        o.onDeath = function(_killer, _skill, _tile, _fatalityType){
            ::logInfo("Entered hooked on death for ZOMBIE");
            if (this.getFaction() == this.Const.Faction.PlayerAnimals && "Master" in this.m && this.m.Master != null) {
                ::logInfo("RAISE UNDEAD: Actor hook reporting that zombie is identified as player animal. Setting faction to enemy before it dies.")
                this.setFaction(this.Const.Faction.Enemy);
                _killer = this.m.Master;
            }
            old_onDeath(_killer, _skill, _tile,  _fatalityType);
        }
    });
}