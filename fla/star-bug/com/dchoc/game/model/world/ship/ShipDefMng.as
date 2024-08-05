package com.dchoc.game.model.world.ship
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.defs.SquadDef;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   import flash.utils.Dictionary;
   
   public class ShipDefMng extends DCDefMng
   {
      
      public static const TYPE_SQUADS_SKU:String = "squads";
      
      public static const TYPE_WARSMALL_ID:int = 0;
      
      public static const TYPE_BOTS:int = 1;
      
      public static const TYPE_GROUNDUNITS_ID:int = 2;
      
      public static const TYPE_MECHAUNITS_ID:int = 3;
      
      public static const TYPE_SQUAD_ID:int = 4;
      
      public static const TYPE_AMOUNT:int = 5;
      
      public static const TYPE_SKUS:Vector.<String> = new <String>["warSmallShips","botShips","groundUnits","mecaUnits","squads"];
      
      private static const RESOURCE_DEFS:Vector.<String> = new <String>["warSmallShipsDefinitions.xml","botShipsDefinitions.xml","groundUnitsDefinitions.xml","mecaUnitsDefinitions.xml","squadsDefinitions.xml"];
      
      private static const SIG_RESOURCE_DEFS:Vector.<String> = new <String>["groundUnitsDefinitions.xml","mecaUnitsDefinitions.xml","warSmallShipsDefinitions.xml","squadsDefinitions.xml"];
       
      
      private var mUpgradeCatalog:Dictionary;
      
      private var mPerfectDefs:Vector.<ShipDef>;
      
      public function ShipDefMng(directoryPath:String = null)
      {
         super(RESOURCE_DEFS,TYPE_SKUS,directoryPath,SIG_RESOURCE_DEFS);
      }
      
      public static function getUnitTypeFromType(typeId:int) : int
      {
         var returnValue:int = 0;
         switch(typeId)
         {
            case 0:
               returnValue = 2;
               break;
            case 1:
               returnValue = 8;
            case 2:
               returnValue = 6;
               break;
            case 3:
               returnValue = 7;
         }
         return returnValue;
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return type == "squads" ? new SquadDef() : new ShipDef();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 2;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.loadUpgradeCatalog();
         }
         super.loadDoStep(step);
      }
      
      override protected function unloadDo() : void
      {
         this.unloadUpgradeCatalog();
         super.unloadDo();
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 1 && InstanceMng.getAnimationsDefMng().isBuilt())
         {
            buildAdvanceSyncStep();
         }
         super.buildDoSyncStep(step);
      }
      
      public function getDefsFromTypes(types:String, ignoreUpgrades:Boolean = true, orderOn:String = null, allUnits:Boolean = false) : Vector.<DCDef>
      {
         var type:String = null;
         var v:Vector.<DCDef> = null;
         var def:ShipDef = null;
         var arr:Array = types.split(",");
         var vType:Vector.<String> = new Vector.<String>(0);
         for each(type in arr)
         {
            vType.push(type);
         }
         v = getDefs(vType);
         if(ignoreUpgrades == false)
         {
            return v;
         }
         arr.length = 0;
         for each(def in v)
         {
            if(def.getUpgradeId() == 0 && (def.mustBeShownInShop() || allUnits))
            {
               if(orderOn == null || orderOn == "shopOrder")
               {
                  def.mSortCriteria = def.getShopOrder();
               }
               else if(orderOn == "labOrder")
               {
               }
               arr.push(def);
            }
         }
         arr.sortOn("mSortCriteria",16);
         return DCUtils.array2VectorDCDef(arr);
      }
      
      public function getResourceFolder(sku:String) : String
      {
         var def:DCDef = getDefBySku(sku);
         var groups:String = getGroupsFromDef(def);
         var groupArr:Array;
         if((groupArr = groups.split(",")).indexOf(TYPE_SKUS[2]) != -1)
         {
            return "pngs_shop_soldiers/";
         }
         if(groupArr.indexOf(TYPE_SKUS[3]) != -1)
         {
            return "pngs_shop_mechas/";
         }
         return "pngs_shop_ships/";
      }
      
      public function getDefBySkuAndUpgradeId(sku:String, upgradeId:int) : ShipDef
      {
         var def:DCDef = getDefBySku(UnitDef.getIdFromSkuAndUpgradeId(sku,upgradeId));
         if(def == null)
         {
            return null;
         }
         return ShipDef(def);
      }
      
      public function getMaxUpgradeDefBySku(sku:String) : ShipDef
      {
         var upgrade:int = this.getMaxUpgradeLevel(sku);
         return this.getDefBySkuAndUpgradeId(sku,upgrade);
      }
      
      private function loadUpgradeCatalog() : void
      {
         if(this.mUpgradeCatalog == null)
         {
            this.mUpgradeCatalog = new Dictionary();
         }
      }
      
      private function unloadUpgradeCatalog() : void
      {
         this.mUpgradeCatalog = null;
      }
      
      public function getMaxUpgradeLevel(sku:String) : int
      {
         var levelUpgrades:int = 0;
         var def:DCDef = null;
         if(this.mUpgradeCatalog[sku] == null)
         {
            levelUpgrades = 0;
            do
            {
               levelUpgrades++;
               def = getDefBySku(sku + "_" + levelUpgrades);
            }
            while(def != null);
            
            this.mUpgradeCatalog[sku] = levelUpgrades - 1;
         }
         return this.mUpgradeCatalog[sku];
      }
      
      public function getDefsSorted(ignoreUpgrades:Boolean = true, allUnits:Boolean = false) : Vector.<DCDef>
      {
         var v:Vector.<DCDef> = this.getDefsFromTypes(TYPE_SKUS[2],ignoreUpgrades,null,allUnits);
         v = v.concat(this.getDefsFromTypes(TYPE_SKUS[3],ignoreUpgrades,null,allUnits));
         return v.concat(this.getDefsFromTypes(TYPE_SKUS[0],ignoreUpgrades,null,allUnits));
      }
      
      public function getPerfectDef(type:int) : ShipDef
      {
         if(this.mPerfectDefs == null)
         {
            this.mPerfectDefs = new Vector.<ShipDef>(5,true);
         }
         if(this.mPerfectDefs[type] == null)
         {
            this.mPerfectDefs[type] = this.createPerfectDef(type);
         }
         return this.mPerfectDefs[type];
      }
      
      private function createPerfectDef(type:int) : ShipDef
      {
         var i:int = 0;
         var def:ShipDef = null;
         var perfectDef:ShipDef = null;
         var defs:Vector.<DCDef> = this.getDefsFromTypes(TYPE_SKUS[type]);
         var l:int = int(defs.length);
         for(i = 0; i < l; )
         {
            defs[i] = this.getMaxUpgradeDefBySku(defs[i].mSku);
            i++;
         }
         var maxShotDamage:Number = 0;
         var maxMaxEnergy:Number = 0;
         var maxConstructionTime:Number = 0;
         var maxMaxSpeed:Number = 0;
         for each(def in defs)
         {
            if(def.getShotDamage() > maxShotDamage)
            {
               maxShotDamage = def.getShotDamage();
            }
            if(def.getMaxEnergy() > maxMaxEnergy)
            {
               maxMaxEnergy = def.getMaxEnergy();
            }
            if(def.getConstructionTime() > maxConstructionTime)
            {
               maxConstructionTime = def.getConstructionTime();
            }
            if(def.getMaxSpeed() > maxMaxSpeed)
            {
               maxMaxSpeed = def.getMaxSpeed();
            }
         }
         (perfectDef = new ShipDef()).setValues(maxShotDamage,maxMaxEnergy,maxConstructionTime,maxMaxSpeed);
         return perfectDef;
      }
   }
}
