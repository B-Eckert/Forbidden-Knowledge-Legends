local gt = this.getroottable();
if (!("ForbiddenKnowledgeMod" in gt.Const)) {
    gt.Const.ForbiddenKnowledgeMod <- {};
}
this.getroottable().Const.ForbiddenKnowledgeMod.hooksDestructionAbility <-  function(){
    ::logInfo("Beginning destruction hooks...")
    ::mods_hookExactClass("entity/world/settlement", function(o) {
		::logInfo("Hooking settlement.")
        local old_onInit = o.onInit;
        // note if miltary set m here not in function
        o.onInit <- function(){
            old_onInit();
            if("SettlementAttackableSpecial" in this.m && this.m.SettlementAttackableSpecial){
                if(!this.isSouthern()){
                    this.m.Resources = 50 * (this.m.IsMilitary ? 7 : 1) * this.m.Size + (this.m.IsMilitary ? 200 : 100);
                    this.m.setDefenderSpawnList(this.m.IsMilitary ? this.Const.World.Spawn.Noble : this.Const.World.Spawn.Militia); // nobles if not military if is
                }
                else if (this.isSouthern()) {
                    this.m.Resources = 250 * this.m.Size;
                    this.m.setDefenderSpawnList(this.Const.World.Spawn.Southern); // nobles if not military if is
                }
            }
        }
        o.makeSettlementAttackable <- function()
		{
            //old_onInit();
            /*if (this.getroottable().World.Assets.getOrigin().getID() != null && "scenario.dse_forbidden_knowledge_hated_lich") {
                return;
            }*/
            this.m.SettlementAttackableSpecial <- true;
            if (!this.isSouthern())
            {
                ::logInfo("Making northern settlements attackable.")
                // allow heinous nonsense

                this.m.IsAttackable = true;
                this.m.IsDespawningDefenders = false;
                this.m.CombatLocation.ForceLineBattle = true;
                this.m.CombatLocation.AdditionalRadius = 5;
                this.m.IsDestructible = this.World.Assets.isPermanentDestruction();
                // this.m.OnDestroyed = "event.location.forbiddenknowledge_town_destroyed";
                // note to self: figure out how to feed location data to the event so you can choose necropolis or destroyed
                this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Walls;
                this.setDefenderSpawnList(this.m.IsMilitary ? this.Const.World.Spawn.Noble : this.Const.World.Spawn.Militia); // nobles if not military if is
                this.m.Resources = 50 * (this.m.IsMilitary ? 7 : 1) * this.m.Size + (this.m.IsMilitary ? 200 : 100);
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
                this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Walls;
                this.setDefenderSpawnList(this.Const.World.Spawn.Southern); // nobles if not military if is
        		this.m.Resources = 250 * this.m.Size;
                // 500 is the biggest, i think a big fort would have 750
                // big fort = 750, ismilitary = true so /2, then size 3 so /3, 250/2 = 125
                // base everything else around that
            }

            // ATTACHED
            /*foreach(location in this.getActiveAttachedLocations()) {
                location.makeAttachedLocationAttackable();
            }*/
		}
        /*local old_buildAttachedLocation = o.buildAttachedLocation;
        o.buildAttachedLocation <- function(_num, _script, _terrain, _nearbyTerrain, _additionalDistance = 0, _mustBeNearRoad = false, _clearTile = true, _force = false) {
            local locationSize = this.getActiveAttachedLocations().len();
            old_buildAttachedLocation(_num, _script, _terrain, _nearbyTerrain, _additionalDistance, _mustBeNearRoad, _clearTile,  _force)
            if (locationSize < this.getActiveAttachedLocations().len()){
                this.getActiveAttachedLocations()[locationSize].makeAttachedLocationAttackable();
            }
        }*/

        o.onDropLootForPlayer <- function( _lootTable )
        {
            if("SettlementAttackableSpecial" in this.m && this.m.SettlementAttackableSpecial){
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
        }
        o.onCombatLost <-  function() {
            if("SettlementAttackableSpecial" in this.m && this.m.SettlementAttackableSpecial){
                this.destroy();
            }
        }
        local old_onSerialize = o.onSerialize;
        local old_onDeserialize = o.onDeserialize;

        o.onSerialize <- function(_out){
            old_onSerialize(_out);
            if("SettlementAttackableSpecial" in this.m){
                _out.writeBool(this.m.SettlementAttackableSpecial);
            }
            else {
                _out.writeBool(false);
            }
        }
        o.onDeserialize <- function(_in){
            old_onDeserialize(_in);
            this.m.SettlementAttackableSpecial <- _in.readBool();
        }
    });

    // Attached Location Hook WIP
/*
    ::mods_hookExactClass("entity/world/attached_location", function(o){
        local old_onInit = o.onInit;
        // note if miltary set m here not in function
        o.m.LocationAttackableSpecial <- false;
        o.onInit <- function(){
            old_onInit();
            // Note: How to tell if an attached location is attached to a military or nonmilitary institution? Militia or not militia?
            if(this.m.LocationAttackableSpecial){
                this.m.IsAttackable = true;
                this.m.IsDespawningDefenders = false;
                this.m.CombatLocation.ForceLineBattle = true;
                this.m.CombatLocation.AdditionalRadius = 5;
                this.m.CombatLocation.Fortification = this.m.IsMilitary ? this.Const.Tactical.FortificationType.Walls : this.Const.Tactical.FortificationType.None;
                this.m.IsDestructible = this.World.Assets.isPermanentDestruction();
                if (this.m.Settlement !=  null && this.m.Settlement.isSouthern()) {
                    if (this.m.IsMilitary){
                        this.setDefenderSpawnList(this.m.Settlement.isMilitary() ? this.Const.World.Spawn.Noble : this.Const.World.Spawn.Militia); // nobles if not military if is
                    }
                    else if(this.m.IsMilitary){
                        this.setDefenderSpawnList(this.Const.World.Spawn.Noble)
                    }
                    else{
                        this.setDefenderSpawnList(this.Const.World.Spawn.Peasants)
                    }
                }
                else if (this.m.Settlement !=  null && this.m.Settlement.isSouthern()) {
                    if(this.m.IsMilitary){
                        this.setDefenderSpawnList(this.Const.World.Spawn.Southern); // nobles if not military if is
                    }
                    else {
                        this.setDefenderSpawnList(this.Const.World.Spawn.PeasantsSouthern);
                    }
                }
                else {
                    ::logInfo("ATTACHED LOCATION INIT HOOK: The settlement is null. Defender spawn list will be set to mercenaries.")
                    this.setDefenderSpawnList(this.Const.World.Spawn.Mercenaries);
                }
                // give resources to defend itself
                if (this.m.Settlement !=  null){
                    this.setResources(this.m.Settlement.getSize() * 50)
                }
                else {
                    this.setResources(100);
                }
            }
        }

        o.makeAttachedLocationAttackable <- function(){
            this.m.LocationAttackableSpecial = true;
            //this.onInit();
            this.m.IsAttackable = true;
                this.m.IsDespawningDefenders = false;
                this.m.CombatLocation.ForceLineBattle = true;
                this.m.CombatLocation.AdditionalRadius = 5;
                this.m.CombatLocation.Fortification = this.m.IsMilitary ? this.Const.Tactical.FortificationType.Walls : this.Const.Tactical.FortificationType.None;
                this.m.IsDestructible = this.World.Assets.isPermanentDestruction();
                if (this.m.Settlement !=  null && this.m.Settlement.isSouthern()) {
                    if (this.m.IsMilitary){
                        this.setDefenderSpawnList(this.m.Settlement.isMilitary() ? this.Const.World.Spawn.Noble : this.Const.World.Spawn.Militia); // nobles if not military if is
                    }
                    else{
                        this.setDefenderSpawnList(this.Const.World.Spawn.Peasants)
                    }
                }
                else if (this.m.Settlement !=  null && this.m.Settlement.isSouthern()) {
                    if(this.m.IsMilitary){
                        this.setDefenderSpawnList(this.Const.World.Spawn.Southern); // nobles if not military if is
                    }
                    else {
                        this.setDefenderSpawnList(this.Const.World.Spawn.PeasantsSouthern);
                    }
                }
                else {
                    ::logInfo("ATTACHED LOCATION INIT HOOK: The settlement is null. Defender spawn list will be set to mercenaries.")
                    this.setDefenderSpawnList(this.Const.World.Spawn.Mercenaries);
                }
                // give resources to defend itself
                if (this.m.Settlement !=  null){
                    this.setResources(this.m.Settlement.getSize() * 50)
                }
                else {
                    this.setResources(100);
                }
        }

        o.onCombatLost <- function(){
            if(this.m.LocationAttackableSpecial){
                this.setActive(false);
                this.spawnFireAndSmoke();
            }
        }

        o.onDropLootForPlayer <- function(_lootTable) {
            if(this.m.LocationAttackableSpecial){
                local shopBuildingList = [
                    "armorsmith",
                    "fletcher",
                    "kennel",
                    "marketplace",
                    "weaponsmith"
                ]
                local shopOrientalBuildingList = [
                    "armorsmith_oriental",
                    "alchemist",
                    "marketplace_oriental",
                    "weaponsmith_oriental"
                ]
                local shopItemsRaw = [];
                if (this.m.Settlement !=  null && this.m.Settlement.isSouthern()){
                    foreach(building in shopOrientalBuildingList){
                        this.onUpdateShopList("building." + building, shopItemsRaw);
                    }
                }
                else {
                    foreach(building in shopBuildingList){
                        this.onUpdateShopList("building." + building, shopItemsRaw);
                    }
                }
                local shopItems = [];
                foreach(shopItemEntry in shopItemsRaw){
                    if ((this.Math.rand(1, 100) / 100.0) <= shopItemEntry.P) {
                        shopItems.push(shopItemEntry.S)
                    }
                }
                local itemAmount = this.Math.rand(1, 4) * (this.m.Settlement == null ? 2 : this.m.Settlement.getSize() * 2);
                if (shopItems.len() !=  0){
                    this.dropTreasure(itemAmount, shopItems, _lootTable);
                }
            }
        }

        local old_onSerialize = o.onSerialize;
        local old_onDeserialize = o.onDeserialize;

        o.onSerialize <- function(_out){
            old_onSerialize(_out);
            if("LocationAttackableSpecial" in this.m){
                _out.writeBool(this.m.LocationAttackableSpecial);
            }
            else {
                _out.writeBool(false);
            }
        }
        o.onDeserialize <- function(_in){
            old_onDeserialize(_in);
            this.m.LocationAttackableSpecial <- _in.readBool();
        }
    });
*/
}

/* Attached Location Tidbits
When Razed:
.setActive(false);
.spawnFireAndSmoke();

note: Pass relevant marketplace ID into location onUpdateShopList and then
you will get back whatever loot the attached location should drop.

o.onCombatLost <- {When Razed see above}

See also raze_attached_location contract for guidance.
*/

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