local gt = this.getroottable();
if (!("ForbiddenKnowledgeMod" in gt.Const)) {
    gt.Const.ForbiddenKnowledgeMod <- {};
}
this.getroottable().Const.ForbiddenKnowledgeMod.hookEventManagerSpecialEvents <-  function(){
    ::mods_hookExactClass("events/event_manager", function(o) {
        local old_create = o.create;
		o.create <- function()
		{
            old_create();
            this.addSpecialEvent("event.forbiddenknowledge_lich_takes_minion");
		}
    });
}