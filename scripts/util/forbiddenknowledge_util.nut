// thank you lonemind for showing me how to do this
local gt = this.getroottable();

if (!("Necromance" in gt.Const)){
    gt.Const.Necromance <- {};
}

gt.Const.Necromance.Skeletonize <- function (_actor) {
    _actor.setMoraleState(gt.Const.MoraleState.Ignore);
    _actor.getFlags().add("PlayerSkeleton");
    _actor.getFlags().add("undead");
    _actor.getFlags().add("skeleton");
    local fleshlessSkill = gt.new("scripts/skills/traits/legend_fleshless_trait");
    _actor.getSkills().add(fleshlessSkill);
    _actor.getSkills().add(gt.new("scripts/skills/racial/skeleton_racial"));
    _actor.getSkills().add(gt.new("scripts/skills/perks/perk_nine_lives"));
    local body = _actor.getSprite("body");
    body.setBrush("bust_skeleton_body_0" + gt.Math.rand(1, 2));
    body.Saturation = 0.8;
    body.varySaturation(0.2);
    body.varyColor(0.025, 0.025, 0.025);

    if (_actor.getFlags().has("human"))
    {
        _actor.getSprite("injury_body").setBrush("bust_skeleton_body_injured");
    }

    if (this.isKindOf(_actor, "player"))
    {
        _actor.improveMood = function ( _change, _text = "" )
        {
        };
        _actor.worsenMood = function ( _change, _text = "" )
        {
        };
    }

    local head = _actor.getSprite("head");
    head.setBrush("bust_skeleton_head");
    head.Color = body.Color;
    head.Saturation = body.Saturation;
}

gt.Const.Necromance.Zombify <- function (_actor){
    _actor.setMoraleState(gt.Const.MoraleState.Ignore);
    _actor.getFlags().add("PlayerZombie");
    _actor.getFlags().add("undead");
    _actor.getFlags().add("zombie_minion");
    local rottenSkill = gt.new("scripts/skills/traits/legend_rotten_flesh_trait");
    _actor.getSkills().add(rottenSkill);
    _actor.getSkills().add(gt.new("scripts/skills/perks/perk_legend_zombie_bite"));
    _actor.getSkills().add(gt.new("scripts/skills/perks/perk_nine_lives"));
}

gt.Const.Necromance.LearnNecromancy <- function (_actor){
    _actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendBrinkOfDeath, 4, true);
    _actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendPossession, 2, false);
    _actor.getBackground().addPerk(this.Const.Perks.PerkDefs.LegendRaiseUndead, 6, true);
    _actor.getFlags().set("IsNecromancer", true);
}