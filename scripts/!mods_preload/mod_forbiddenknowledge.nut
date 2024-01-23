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
	Version = "1.0.3"
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
                            this.m.MoraleState = this.Const.MoraleState.Ignore;
                            this.getFlags().add("PlayerZombie");
                            this.getFlags().add("undead");
                            this.getFlags().add("zombie_minion");
                            local rottenSkill = this.new("scripts/skills/traits/legend_rotten_flesh_trait");
                            this.m.Skills.add(rottenSkill);
                            this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_zombie_bite"));
                            this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
                        }
                        else {
                            this.m.MoraleState = this.Const.MoraleState.Ignore;
                            this.getFlags().add("PlayerSkeleton");
                            this.getFlags().add("undead");
                            this.getFlags().add("skeleton");
                            local fleshlessSkill = this.new("scripts/skills/traits/legend_fleshless_trait");
                            this.m.Skills.add(fleshlessSkill);
                            this.m.Skills.add(this.new("scripts/skills/racial/skeleton_racial"));
                            this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
                            local actor = this;
                            local body = actor.getSprite("body");
                            body.setBrush("bust_skeleton_body_0" + this.Math.rand(1, 2));
                            body.Saturation = 0.8;
                            body.varySaturation(0.2);
                            body.varyColor(0.025, 0.025, 0.025);

                            if (actor.getFlags().has("human"))
                            {
                                actor.getSprite("injury_body").setBrush("bust_skeleton_body_injured");
                            }

                            if (this.isKindOf(actor, "player"))
                            {
                                actor.improveMood = function ( _change, _text = "" )
                                {
                                };
                                actor.worsenMood = function ( _change, _text = "" )
                                {
                                };
                            }

                            local head = actor.getSprite("head");
                            head.setBrush("bust_skeleton_head");
                            head.Color = body.Color;
                            head.Saturation = body.Saturation;
                        }
                    }
                    this.Tactical.getSurvivorRoster().add(this);
                }
            }
            return value;
        }
    });
});