local gt = this.getroottable();
if (!("ForbiddenKnowledgeMod" in gt.Const)) {
    gt.Const.ForbiddenKnowledgeMod <- {};
}
this.getroottable().Const.ForbiddenKnowledgeMod.hooksDestructionAbility <-  function(){
    ::logInfo("Beginning destruction hooks...")
    ::mods_hookExactClass("entity/world/settlement", function(o) {
		::logInfo("Hooking settlement.")
        local old_onInit = o.onInit;
		o.onInit <- function()
		{
            old_onInit();
            /*if (this.getroottable().World.Assets.getOrigin().getID() != null && "scenario.dse_forbidden_knowledge_hated_lich") {
                return;
            }*/
            if (!this.isSouthern())
            {
                ::logInfo("Making northern settlements attackable.")
                // allow heinous nonsense

                this.m.IsAttackable = true;
                this.m.IsDespawningDefenders = false;
                this.m.CombatLocation.ForceLineBattle = true;
                this.m.CombatLocation.AdditionalRadius = 5;
                //this.m.IsDestructible = this.World.Assets.isPermanentDestruction(); // does nothing actually
                // this.m.OnDestroyed = "event.location.forbiddenknowledge_town_destroyed";
                // note to self: figure out how to feed location data to the event so you can choose necropolis or destroyed
                local difficulty = (this.m.IsMilitary ? 2 : 1) + 1;
                this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Walls;
                this.setDefenderSpawnList(this.m.IsMilitary ? this.Const.World.Spawn.Noble : this.Const.World.Spawn.Militia); // nobles if not military if is
        		this.m.Resources = 500 * (this.m.IsMilitary ? 2 : 1) * this.m.Size;
                // 500 is the biggest, i think a big fort would have 750
                // big fort = 750, ismilitary = true so /2, then size 3 so /3, 250/2 = 125
                // base everything else around that
            }
            else if (this.isSouthern()) {
                ::logInfo("Making southern settlements attackable.")
                // allow heinous nonsense

                this.m.IsAttackable = true;
                this.m.IsDespawningDefenders = false;
                this.m.CombatLocation.ForceLineBattle = true;
                this.m.CombatLocation.AdditionalRadius = 5;
                this.m.IsDestructible = this.World.Assets.isPermanentDestruction(); // maybe does something?
                // this.m.OnDestroyed = "event.location.forbiddenknowledge_town_destroyed";
                // note to self: figure out how to feed location data to the event so you can choose necropolis or destroyed
                local difficulty = 3;
                this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Walls;
                this.setDefenderSpawnList(this.Const.World.Spawn.Southern); // nobles if not military if is
        		this.m.Resources = 1000 * this.m.Size;
                // 500 is the biggest, i think a big fort would have 750
                // big fort = 750, ismilitary = true so /2, then size 3 so /3, 250/2 = 125
                // base everything else around that
            }
		}
        o.onDropLootForPlayer <- function( _lootTable )
        {
            this.location.onDropLootForPlayer(_lootTable);
            this.dropMoney(this.Math.rand(1000 * this.m.Size, 3000 * this.m.Size), _lootTable);
            this.dropArmorParts(this.Math.rand(15 * this.m.Size, 30 * this.m.Size), _lootTable);
            this.dropAmmo(this.Math.rand(10 * this.m.Size, 30 * this.m.Size), _lootTable);
            this.dropMedicine(this.Math.rand(10 * this.m.Size, 25 * this.m.Size), _lootTable);
            this.dropFood(this.Math.rand(this.m.Size * 4, this.m.Size * 8), [
                "bread_item",
                "beer_item",
                "dried_fruits_item",
                "ground_grains_item",
                "roots_and_berries_item",
                "pickled_mushrooms_item",
                "smoked_ham_item",
                "mead_item",
                "cured_venison_item",
                "goat_cheese_item"
            ], _lootTable);
            local pillaged = [];
            local iteratedItems = 0;
            foreach( building in this.m.Buildings )
		    {
			    if (building != null)
			    {
    				if (building.getStash() != null)
	    			{
                        local limitHit = 999
		    			for (local i = 0; i < this.m.Size * 6 && building.getStash().getItems().len() !=  0; i++) {
                            local itemID = building.getStash().getItems().remove(this.Math.rand(0, building.getStash().getItems().len() - 1)).getID();
                            if (itemID !=  null && itemID != ""){
                                local firstPart = itemID.slice(0, itemID.find("."));
                                local lastPart = itemID.slice(itemID.find(".") + 1);
                                if (firstPart == "weapon" || firstPart == "helmet" || firstPart == "shield" || firstPart ==  "tool"){
                                    firstPart = firstPart + "s";
                                }
                                if (firstPart == "loot" || firstPart == "tool" || firstPart == "supplies" || firstPart == "trade" || firstPart == "special" || firstPart == "misc" || firstPart ==  "accessory"){
                                    lastPart = lastPart + "_item";
                                }
                                itemID = firstPart + "/" + lastPart;
                                pillaged.push(itemID);
                                iteratedItems++;
                            } // remove size*6 items
                        }
		    		}
	    		}
	    	}
    		this.dropTreasure(this.Math.rand(this.m.Size < iteratedItems ? this.m.Size : iteratedItems, this.m.Size * 3 < iteratedItems ? this.m.Size*3 : iteratedItems), pillaged, _lootTable); // and drop the pillaged items as treasure
            this.dropTreasure(this.Math.rand(this.m.Size, this.m.Size+1), [ // then drop regular treasure
                "loot/silverware_item",
                "loot/silver_bowl_item",
                "loot/signet_ring_item",
                "loot/white_pearls_item",
                "loot/golden_chalice_item",
                "loot/gemstones_item",
                "loot/jeweled_crown_item",
                "loot/ornate_tome_item",
                "loot/silverware_item",
                "loot/silver_bowl_item",
                "loot/signet_ring_item",
                "loot/white_pearls_item",
                "loot/golden_chalice_item",
                "loot/gemstones_item",
                "loot/jeweled_crown_item",
                "loot/ornate_tome_item",
            ], _lootTable);
        }
        o.onCombatLost <-  function() {
            this.destroy();
        }
    });
}

/* Necropolis Conversion Code
if (this.World.Assets.isPermanentDestruction() && !e.isSouthern())
{
    local news = this.World.Statistics.createNews();
    news.set("City", e.getName());
    this.World.Statistics.addNews("crisis_undead_town_destroyed", news);
    this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnTownDestroyed);
    local tile = e.getTile();
    local name = e.getName();
    local sprite = e.m.Sprite;
    e.setActive(false, false);
    e.fadeOutAndDie();
    this.World.EntityManager.updateSettlementHeat();
    local n = this.World.spawnLocation("scripts/entity/world/locations/undead_necropolis_location", tile.Coords);
    n.setName(name);
    n.setSprite(sprite);
    n.onSpawned();
    n.setBanner(_entity.getBanner());
    this.World.FactionManager.getFaction(_entity.getFaction()).addSettlement(n, false);
}
*/

/* City Destruction Code
if (this.World.Assets.isPermanentDestruction() && !e.isSouthern())
{
    local news = this.World.Statistics.createNews();
    news.set("City", e.getName());
    this.World.Statistics.addNews("crisis_greenskins_town_destroyed", news);
    this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnTownDestroyed);
    e.setActive(false);
    e.getTile().spawnDetail(e.m.Sprite + "_ruins", this.Const.World.ZLevel.Object - 3, 0, false);
    e.fadeOutAndDie();
    this.World.EntityManager.updateSettlementHeat();
}
*/

/* Necropolis Code v2
if (this.World.Assets.isPermanentDestruction())
{
    ::logInfo("Necropolizing Settlement.")
    this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnTownDestroyed);
    local tile = this.getTile();
    local name = this.getName();
    local sprite = this.m.Sprite;
    this.setActive(false, false);
    this.fadeOutAndDie();
    //this.World.EntityManager.updateSettlementHeat();
    local n = this.World.spawnLocation("scripts/entity/world/locations/undead_necropolis_location", tile.Coords);
    this.setName(name);
    this.setSprite(sprite);
    this.onSpawned();
    // random faction
    local entities = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.Undead);
    local entity = entities[this.Math.rand(0, entities.len() - 1)].getID();
    // end of random faction
    this.setBanner(entity.getBanner());
    this.World.FactionManager.getFaction(entity.getFaction()).addSettlement(n, false);
}
*/