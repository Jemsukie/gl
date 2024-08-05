package com.dchoc.game.model.world.item
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class WorldItemDefMng extends DCDefMng
   {
      
      public static const TYPE_RESOURCES_COINS_ID:int = 0;
      
      public static const TYPE_RESOURCES_MINERALS_ID:int = 1;
      
      public static const TYPE_RESOURCES_SILOS_ID:int = 2;
      
      public static const TYPE_SHIPYARDS_ID:int = 3;
      
      public static const TYPE_DECORATIONS_ID:int = 4;
      
      public static const TYPE_WONDERS_ID:int = 5;
      
      public static const TYPE_DEFENSES_ID:int = 6;
      
      public static const TYPE_HANGARS_ID:int = 7;
      
      public static const TYPE_BUNKERS_ID:int = 8;
      
      public static const TYPE_LABS_ID:int = 9;
      
      public static const TYPE_DROIDS_ID:int = 10;
      
      public static const TYPE_EXPANSIONS_ID:int = 11;
      
      public static const TYPE_OBSTACLES_ID:int = 12;
      
      public static const TYPES_COUNT:int = 14;
      
      public static const TYPE_SKUS:Vector.<String> = new <String>["resourcesCoins","resourcesMinerals","resourcesSilos","shipyards","decoration","wonders","defenses","hangars","bunkers","labs","droids","expansion","obstacles","protectionTime"];
      
      public static const TYPES_ITEM_COUNT:int = 10;
      
      public static const TYPES_LAB_GROUP_LABORATORY:String = "laboratory";
      
      public static const TYPES_LAB_GROUP_EMBASSY:String = "embassy";
      
      public static const TYPES_LAB_GROUP_OBSERVATORY:String = "observatory";
      
      public static const TYPES_LAB_GROUP_REFINERY:String = "refinery";
      
      public static const TYPES_BUNKER_GROUP_WARP:String = "warp";
      
      public static const GROUP_HOUSES_ID:String = "0";
      
      public static const GROUP_DEFENSES_ID:String = "1";
      
      public static const GROUP_ATTACK_ID:String = "2";
      
      public static const GROUP_MINES_ID:String = "3";
      
      public static const GROUP_DECORATIONS_ID:String = "4";
      
      public static const GROUP_LABORATORIES_ID:String = "5";
      
      public static const GROUP_BUILDERS_ID:String = "6";
      
      public static const FLAFOLDER_HOUSES:String = "houses";
      
      public static const FLAFOLDER_MINERALS:String = "minerals";
      
      public static var TYPE_GROUPS:Vector.<Vector.<String>>;
      
      private static const RESOURCE_DEFS:Vector.<String> = new <String>["resourcesCoinsDefinitions.xml","resourcesMineralsDefinitions.xml","resourcesSilosDefinitions.xml","shipyardDefinitions.xml","decorationDefinitions.xml","wonderDefinitions.xml","defensesDefinitions.xml","hangarsDefinitions.xml","bunkersDefinitions.xml","laboratoriesDefinitions.xml","droidsDefinitions.xml","expansionDefinitions.xml","obstaclesDefinitions.xml","protectionTimeDefinitions.xml"];
      
      private static const SIG_RESOURCE_DEFS:Vector.<String> = new <String>["defensesDefinitions.xml"];
      
      private static const BUNKER_UPGRADE_1_ID:int = 0;
      
      private static const BUNKER_UPGRADE_2_ID:int = 1;
      
      private static const SHIPYARD_BARRACK_ID:int = 2;
      
      private static const SHIPYARD_MECHAS_ID:int = 3;
      
      private static const TILES_BUNKER_UPGRADE_1:Array = [[5,3],[3,5]];
      
      private static const TILES_BUNKER_UPGRADE_2:Array = [[7,3],[0,2]];
      
      private static const SHIPYARD_BARRACK:Array = [[2,3]];
      
      private static const SHIPYARD_MECHAS:Array = [[8,4]];
      
      private static const WIO_TILES:Array = [TILES_BUNKER_UPGRADE_1,1,SHIPYARD_BARRACK,SHIPYARD_MECHAS];
       
      
      private var mMapControllerPlanet:MapControllerPlanet;
      
      private var mViewMngPlanet:ViewMngPlanet;
      
      private var mVector:Vector3D;
      
      public var mPathRoadHQTileOffX:Vector.<int>;
      
      public var mPathRoadHQTileOffY:Vector.<int>;
      
      public var mPathRoadHQTileOffCount:int;
      
      private var mPathRoadHQDoorTileIndex:int;
      
      private var mUpgradeCatalog:Dictionary;
      
      private var mBasesSizes:Vector.<String>;
      
      public function WorldItemDefMng(directoryPath:String = null)
      {
         var i:int = 0;
         var v:Vector.<String> = null;
         super(RESOURCE_DEFS,TYPE_SKUS,directoryPath,SIG_RESOURCE_DEFS);
         TYPE_GROUPS = new Vector.<Vector.<String>>();
         for(i = 0; i < 14; )
         {
            v = new <String>[TYPE_SKUS[i]];
            TYPE_GROUPS.push(v);
            i++;
         }
      }
      
      public static function getFolderAssets(def:WorldItemDef) : String
      {
         return "";
      }
      
      override protected function buildCheckSyncStepCanBeAdvanced() : Boolean
      {
         return InstanceMng.getSettingsDefMng().isBuilt();
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new WorldItemDef();
      }
      
      public function getMaxDefUnlockedAtHqUpgradeId(defSku:String, hqUpgradeId:int) : WorldItemDef
      {
         var def:WorldItemDef = null;
         var maxDef:* = null;
         var ok:Boolean = true;
         var upgradeId:int = 0;
         while(ok)
         {
            def = this.getDefBySkuAndUpgradeId(defSku,upgradeId);
            if(def == null)
            {
               ok = false;
            }
            else if(def.getUnlockHQUpgradeIdRequired() <= hqUpgradeId)
            {
               maxDef = def;
            }
            else
            {
               ok = false;
            }
            upgradeId++;
         }
         return maxDef;
      }
      
      public function getAllBaseDefs() : Vector.<DCDef>
      {
         var def:DCDef = null;
         var v:Vector.<DCDef> = getDefs(TYPE_SKUS);
         var ret:Vector.<DCDef> = new Vector.<DCDef>(0);
         for each(def in v)
         {
            if(def.getLevel() == 0)
            {
               ret.push(def);
            }
         }
         return ret;
      }
      
      public function getDefsFromTypes(types:String) : Vector.<DCDef>
      {
         var type:String = null;
         var typesArr:Array = types.split(",");
         var v:Vector.<String> = new Vector.<String>(0);
         for each(type in typesArr)
         {
            v.push(type);
         }
         return getDefs(v);
      }
      
      public function getDefsFromTypeId(id:int) : Vector.<DCDef>
      {
         return getDefs(TYPE_GROUPS[id]);
      }
      
      override public function getDefsWithCondition(thisFunction:Function, params:Object, groups:Vector.<String> = null, isValid:Function = null) : Vector.<DCDef>
      {
         var def:DCDef = null;
         var returnValue:Vector.<DCDef> = new Vector.<DCDef>(0);
         for each(def in getDefs(TYPE_SKUS))
         {
            if(thisFunction(def,params))
            {
               returnValue.push(def);
            }
         }
         return returnValue;
      }
      
      public function getDefBySkuAndUpgradeId(sku:String, upgradeId:int) : WorldItemDef
      {
         return WorldItemDef(getDefBySku(UnitDef.getIdFromSkuAndUpgradeId(sku,upgradeId)));
      }
      
      override protected function buildDefs() : void
      {
         super.buildDefs();
         this.pathRoadHQBuild();
      }
      
      override protected function unbuildDo() : void
      {
         this.pathRoadHQUnbuild();
         super.unbuildDo();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 2;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 1 && InstanceMng.getAnimationsDefMng().isBuilt())
         {
            this.mMapControllerPlanet = InstanceMng.getMapControllerPlanet();
            this.mViewMngPlanet = InstanceMng.getViewMngPlanet();
            if(this.mVector == null)
            {
               this.mVector = new Vector3D();
            }
            buildAdvanceSyncStep();
         }
         super.buildDoSyncStep(step);
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
         this.mBasesSizes = null;
         this.mMapControllerPlanet = null;
         this.mViewMngPlanet = null;
         this.mVector = null;
      }
      
      private function pathRoadHQBuild() : void
      {
         var def:WorldItemDef = null;
         var i:int = 0;
         var j:int = 0;
         var numCols:int = 0;
         var numRows:int = 0;
         var numSemiCols:int = 0;
         if(this.mPathRoadHQTileOffX == null)
         {
            this.mPathRoadHQTileOffX = new Vector.<int>(0);
            this.mPathRoadHQTileOffY = new Vector.<int>(0);
            def = WorldItemDef(getDefBySku("wonders_headquarters"));
            numCols = def.getBaseCols();
            numRows = def.getBaseRows();
            numSemiCols = numCols / 2;
            for(i = 0; i < numCols; )
            {
               for(j = 0; j < numRows; )
               {
                  if(i == 0 || i == numCols - 1 || (j == 0 || j == numRows - 1))
                  {
                     this.mPathRoadHQTileOffX.push(i);
                     this.mPathRoadHQTileOffY.push(j);
                     if(i == numSemiCols && j == numRows - 1)
                     {
                        this.mPathRoadHQDoorTileIndex = this.mPathRoadHQTileOffX.length - 1;
                     }
                  }
                  j++;
               }
               i++;
            }
            this.mPathRoadHQTileOffCount = this.mPathRoadHQTileOffX.length;
         }
      }
      
      private function pathRoadHQUnbuild() : void
      {
         this.mPathRoadHQTileOffX = null;
         this.mPathRoadHQTileOffY = null;
      }
      
      public function pathRoadHQContainsTileRelative(tileRelativeX:int, tileRelativeY:int) : Boolean
      {
         var returnValue:Boolean = false;
         var i:int = 0;
         while(i < this.mPathRoadHQTileOffCount && !returnValue)
         {
            returnValue = tileRelativeX == this.mPathRoadHQTileOffX[i] && tileRelativeY == this.mPathRoadHQTileOffY[i];
            i++;
         }
         return returnValue;
      }
      
      public function pathRoadHQGetARandomTileIndex() : int
      {
         return DCMath.randomNumber(0,this.mPathRoadHQTileOffCount - 1);
      }
      
      public function pathRoadHQGetDoorTileIndex() : int
      {
         return this.mPathRoadHQDoorTileIndex;
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
      
      public function getMaxUpgradeLevel(itemSku:String) : int
      {
         var levelUpgrades:int = 0;
         var def:DCDef = null;
         if(this.mUpgradeCatalog[itemSku] == null)
         {
            levelUpgrades = 0;
            do
            {
               levelUpgrades++;
               def = getDefBySku(itemSku + "_" + levelUpgrades);
            }
            while(def != null);
            
            this.mUpgradeCatalog[itemSku] = levelUpgrades - 1;
         }
         return this.mUpgradeCatalog[itemSku];
      }
      
      public function basesRegister(cols:int, rows:int) : void
      {
         if(this.mBasesSizes == null)
         {
            this.mBasesSizes = new Vector.<String>(0);
         }
         var base:String = cols + "x" + rows;
         var pos:int = this.mBasesSizes.indexOf(base);
         if(pos == -1)
         {
            this.mBasesSizes.push(base);
         }
      }
      
      public function basesGetSizes() : Vector.<String>
      {
         return this.mBasesSizes;
      }
      
      public function isTileXYStepable(item:WorldItemObject, col:int, row:int) : Boolean
      {
         var arr:Array = null;
         var indexRow:int = 0;
         var indexCol:int = 0;
         var i:int = 0;
         var returnValue:*;
         var tilesArr:Array;
         if(returnValue = (tilesArr = this.getTilesArray(item)) != null)
         {
            returnValue = false;
            if(item.mIsFlipped)
            {
               indexRow = 0;
               indexCol = 1;
            }
            else
            {
               indexRow = 1;
               indexCol = 0;
            }
            i = tilesArr.length - 1;
            while(i > -1 && !returnValue)
            {
               arr = tilesArr[i];
               if(row == arr[indexRow])
               {
                  returnValue = col == arr[indexCol] || col == arr[indexCol] + 1 || col == arr[indexCol] - 1;
               }
               else if(col == arr[indexCol])
               {
                  returnValue = row == arr[indexRow] || row == arr[indexRow] + 1;
               }
               i--;
            }
         }
         return returnValue;
      }
      
      private function getTilesArray(item:WorldItemObject) : Array
      {
         var def:WorldItemDef = null;
         var shipyardType:int = 0;
         var returnValue:Array = null;
         if(item != null)
         {
            if((def = item.mDef).isABunker())
            {
               returnValue = def.getAssetId() == "bunker_001_02" ? TILES_BUNKER_UPGRADE_2 : TILES_BUNKER_UPGRADE_1;
            }
            else if(def.isAShipyard())
            {
               shipyardType = InstanceMng.getShipyardController().getShipyardType(def.getShipsFiles());
               switch(shipyardType - 1)
               {
                  case 0:
                     returnValue = SHIPYARD_BARRACK;
                     break;
                  case 1:
                     returnValue = SHIPYARD_MECHAS;
               }
            }
         }
         return returnValue;
      }
      
      public function getTileIndexToGo(item:WorldItemObject, u:MyUnit = null) : int
      {
         var tileX:int = 0;
         var tileY:int = 0;
         var id:* = 0;
         var indexRow:int = 0;
         var indexCol:int = 0;
         var distanceSqr:Number = NaN;
         var minDistanceSqr:* = NaN;
         var thisTileX:int = 0;
         var thisTileY:int = 0;
         var arr:Array = null;
         var coor:DCCoordinate = null;
         var i:int = 0;
         var returnValue:int = -1;
         var tilesArr:Array;
         if((tilesArr = this.getTilesArray(item)) != null)
         {
            tileX = int(this.mMapControllerPlanet.getTileRelativeXToTile(item.mTileRelativeX));
            tileY = int(this.mMapControllerPlanet.getTileRelativeYToTile(item.mTileRelativeY));
            if(item.mIsFlipped)
            {
               indexRow = 0;
               indexCol = 1;
            }
            else
            {
               indexRow = 1;
               indexCol = 0;
            }
            if(u != null)
            {
               minDistanceSqr = 1.7976931348623157e+308;
               coor = MyUnit.smCoor;
               for(i = tilesArr.length - 1; i > -1; )
               {
                  arr = tilesArr[i];
                  coor.x = tileX + arr[indexCol];
                  coor.y = tileY + arr[indexRow];
                  this.mViewMngPlanet.tileXYToWorldPos(coor,true);
                  this.mVector.x = coor.x;
                  this.mVector.y = coor.y;
                  this.mVector.z = 0;
                  if((distanceSqr = DCMath.distanceSqr(u.mPosition,this.mVector)) < minDistanceSqr)
                  {
                     minDistanceSqr = distanceSqr;
                     id = i;
                  }
                  i--;
               }
               tileX += tilesArr[id][indexCol];
               tileY += tilesArr[id][indexRow];
            }
            else
            {
               id = 0;
               tileX += tilesArr[id][indexCol];
               tileY += tilesArr[id][indexRow];
            }
            returnValue = this.mMapControllerPlanet.getTileXYToIndex(tileX,tileY);
         }
         return returnValue;
      }
      
      public function getMaxUpgradeDefBySku(sku:String) : WorldItemDef
      {
         var upgrade:int = this.getMaxUpgradeLevel(sku);
         return this.getDefBySkuAndUpgradeId(sku,upgrade);
      }
      
      public function checkIsLocked(def:WorldItemDef) : Boolean
      {
         var levelPlayer:int = 0;
         var level:int = 0;
         var isLocked:* = false;
         switch(def.getUnlockCondition())
         {
            case "level":
               levelPlayer = InstanceMng.getUserInfoMng().getProfileLogin().getLevel();
               level = def.getLevel();
               if(levelPlayer < level)
               {
                  isLocked = true;
               }
               break;
            case "mission":
               isLocked = InstanceMng.getMissionsMng().isMissionEnded(def.getUnlockConditionParam()) == false;
         }
         return isLocked;
      }
   }
}
