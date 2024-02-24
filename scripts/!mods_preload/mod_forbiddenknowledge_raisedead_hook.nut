// placeholder
local gt = this.getroottable();
if (!("ForbiddenKnowledgeMod" in gt.Const)) {
    gt.Const.ForbiddenKnowledgeMod <- {};
}
gt.Const.ForbiddenKnowledgeMod.hookRaiseDead <-  function() {
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
}