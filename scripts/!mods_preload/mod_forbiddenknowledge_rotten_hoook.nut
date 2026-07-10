local gt = this.getroottable();
if (!("ForbiddenKnowledgeMod" in gt.Const)) {
    gt.Const.ForbiddenKnowledgeMod <- {};
}
gt.Const.ForbiddenKnowledgeMod.hookRotten <- function() {
	// alter Rotten Flesh to be -3 AP again.
    ::mods_hookExactClass("skills/traits/legend_rotten_flesh_trait", function(o){
        ::logInfo("Hooking rotten flesh.")
        local old_onUpdate = o.onUpdate;
        o.onUpdate = function(_properties){
            old_onUpdate(_properties);
            if(this.World.Assets.getOrigin() != null && this.Const.Necromance.IsFBOrigin(this.World.Assets.getOrigin().getID())){
                _properties.ActionPoints -= 1;
            }
        }

        local old_getTooltip = o.getTooltip;
        o.getTooltip = function() {
            local tooltip = old_getTooltip();
            if(this.World.Assets.getOrigin() != null && this.Const.Necromance.IsFBOrigin(this.World.Assets.getOrigin().getID())){
                tooltip[2] = { id = 7,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "-1 Action Points. Movement costs +1 Action Points per tile. Recovers hitpoints at only 10% of the normal rate. Requires 3 provisions a day." };
            }
            return tooltip;
        }
    });
}