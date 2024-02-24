local gt = this.getroottable();
if (!("ForbiddenKnowledgeMod" in gt.Const)) {
    gt.Const.ForbiddenKnowledgeMod <- {};
}
gt.Const.ForbiddenKnowledgeMod.hookIsReallyKilled <-  function() {
    ::mods_hookExactClass("entity/tactical/player", function(o) { // ty Barcode, Abysscrane and LoneMind for this code <3 - Sampled from Rise of the Usurper
        //o = o[o.SuperName]; // maybe i dont need this?
        //local parentClass = ::mods_isClass(o, "player"); // guaranteed to return non-null here
        local old_isReallyKilled = o.isReallyKilled;
        o.isReallyKilled = function(_fatalityType){
            local value = old_isReallyKilled(_fatalityType);
            if(value == false){
                if (this.Const.Necromance.IsFBOrigin(this.World.Assets.getOrigin().getID()))
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
}