// unused placeholder
this.getroottable().Const.ForbiddenKnowledgeMod.hookZombieBite <-  function(){
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
                pair[0].setFaction(this.Const.Faction.Enemy);
                pair[0].kill(pair[0], this, this.Const.FatalityType.Kraken, true); // Nyarlathotep takes his toll and removes them.
                ::logInfo("ZOMBIE BITE: " + pair[0].getName() + " is terminating " + pair[0].getName());
            }
        }
    });
}