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
	Name = "Dragonslayerelf\'s Forbidden Knowledge Origins",
	Version = "1.2.7"
};

::mods_registerMod(::Mod_dseForbiddenKnowledgeOrigin.ID, ::Mod_dseForbiddenKnowledgeOrigin.Version, ::Mod_dseForbiddenKnowledgeOrigin.Name);
::mods_queue(::Mod_dseForbiddenKnowledgeOrigin.ID, "mod_legends,mod_msu", function() {
    ::Mod_dseForbiddenKnowledgeOrigin.Mod <- ::MSU.Class.Mod(::Mod_dseForbiddenKnowledgeOrigin.ID, ::Mod_dseForbiddenKnowledgeOrigin.Version, ::Mod_dseForbiddenKnowledgeOrigin.Name);

    local gt = this.getroottable();
    if (!("ForbiddenKnowledgeMod" in gt.Const)) {
        gt.Const.ForbiddenKnowledgeMod <- {};
    }
    gt.Const.Strings.PerkName.ForbiddenKnowledgeNecroticScythe <- "Necrotic Scythe";
    gt.Const.Strings.PerkName.ForbiddenKnowledgeHemomancy <- "Hemomancy";


    // =================== Perk Descriptions ========================
    gt.Const.Strings.PerkDescription.ForbiddenKnowledgeNecroticScythe <- "Infuse your scythe with a small portion of your necromantic magic. Scythes gain damage equal to a portion of your initiative, health and resolve. You gain an armor and direct damage multiplier based on your learn rate. Trained and knowledge potions don\'t count for this effect. Warscythes gain a smaller portion of this effect.\n\n[color=#288062]Fuelled by Death:[/color] Every kill you make with a scythe empowers your necromantic magic. You gain 25% less Fatigue on your next Necromancy ability per accumulated scythe kill, and spend one stored kill every time you benefit from this feature. If you have more than 4 kills, you instead spend 2 kills and the AP of your next Necromancy ability is reduced by 1 for every 2 kills more than 5 that you have.";
    gt.Const.Strings.PerkDescription.ForbiddenKnowledgeHemomancy <- "[color=#ad2828]Life Drain.[/color] Drain your foes\' vitality by sacrificing some of your own. Uses 25% of your hit points deal damage equal to 20-40% of your maximum HP, increasing with learning rate. Trained and knowledge potions don\'t count for this effect.\n\n[color=#ad2828]Bloodlet.[/color] Drain your own vitality to shed the weariness from yourself. Spend 20% of your hit points to recover 1.2x fatigue, increased by your learning rate.";

    // =================== Perk Def ========================
    local perkDefObjects = [
        {
            ID = "perk.forbiddenknowledge_necrotic_scythe",
            Script = "scripts/skills/perks/forbiddenknowledge_necrotic_scythe_perk",
            Name = this.Const.Strings.PerkName.ForbiddenKnowledgeNecroticScythe,
            Tooltip = this.Const.Strings.PerkDescription.ForbiddenKnowledgeNecroticScythe,
            Icon = "ui/perks/perk_necrotic_scythe_forbidden_knowledge.png",
            IconDisabled = "ui/perks/perk_necrotic_scythe_forbidden_knowledge_bw.png",
            Const = "ForbiddenKnowledgeNecroticScythe"
        },
        {
            ID = "perk.forbiddenknowledge_hemomancy",
            Script = "scripts/skills/perks/forbiddenknowledge_hemomancy_perk",
            Name = this.Const.Strings.PerkName.ForbiddenKnowledgeHemomancy,
            Tooltip = this.Const.Strings.PerkDescription.ForbiddenKnowledgeHemomancy,
            Icon = "ui/perks/perk_hemomancy_forbidden_knowledge.png",
            IconDisabled = "ui/perks/perk_hemomancy_forbidden_knowledge_bw.png",
            Const = "ForbiddenKnowledgeHemomancy"
        }
    ]

    // =================== Perk Def End ========================
    gt.Const.Perks.addPerkDefObjects(perkDefObjects);

    // =================== Perk Trees ========================
    gt.Const.Perks.ForbiddenKnowledgeNecromancerTree <- {
        ID = "ForbiddenKnowledgeNecromancerTree",
        Name = "Necromancer",
        Descriptions = [
            "Necromancer"
        ],
        Tree = [
            [this.Const.Perks.PerkDefs.LegendSpecialistReaper],  //1
            [this.Const.Perks.PerkDefs.LegendWither], //2
            [this.Const.Perks.PerkDefs.LegendPossession], //3
            [this.Const.Perks.PerkDefs.ForbiddenKnowledgeNecroticScythe], //4
            [this.Const.Perks.PerkDefs.LegendBrinkOfDeath], //5
            [this.Const.Perks.PerkDefs.LegendDeathtouch,  this.Const.Perks.PerkDefs.ForbiddenKnowledgeHemomancy], //6 <-- Hemomancy replaces Siphon
            [this.Const.Perks.PerkDefs.LegendRaiseUndead, this.Const.Perks.PerkDefs.LegendMiasma], //7
        ]
    }
    // =================== Perk Tree End ========================

    // =================== Hook Functions ========================
    this.Const.ForbiddenKnowledgeMod.hookRaiseDead();
    this.Const.ForbiddenKnowledgeMod.hookIsReallyKilled();
    this.Const.ForbiddenKnowledgeMod.hookOrientalsUnfriendly();
    this.Const.ForbiddenKnowledgeMod.hookEventManagerSpecialEvents();
    //this.Const.ForbiddenKnowledgeMod.hooksDestructionAbility(); // EXPERIMENTAL
    // ==================== Pure Hooks =======================
    // thank you Luft for this code - based on Red Court
    ::mods_hookExactClass("entity/world/locations/legendary/ancient_watchtower_location", function(o) {
        ::logInfo("Hooking big tower.")
	    local old_onSpawned = o.onSpawned; // get the old function
	    o.onSpawned = function()
	    {
	        old_onSpawned(); // let the old function run
	    	if (this.World.Assets.getOrigin().getID() == "scenario.dse_forbidden_knowledge_hated_lich" )
	   		{
                this.m.Name = "Your Ancient Spire"
	        	local tilePos = this.getTile().Pos;
	        	this.World.State.getPlayer().setPos(tilePos);
	        	this.World.setPlayerPos(tilePos);
	        	this.World.getCamera().setPos(tilePos);
	        	this.onDiscovered();
	        }
	    }
	});
});