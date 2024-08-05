package com.dchoc.game.controller.tools
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.gameunit.GameUnitMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.unit.components.goal.UnitComponentGoal;
   import com.dchoc.game.model.world.ship.ShipDefMng;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.events.KeyboardEvent;
   
   public class ToolDebugUnits extends Tool
   {
      
      public static const MODE_GENERATE_UNIT:int = 0;
      
      public static const MODE_MOVE_UNIT:int = 1;
      
      public static const MODE_FLEE_UNIT:int = 2;
      
      private static const UNITS_COUNT:int = 1;
       
      
      private var mMode:int;
      
      private var mUnits:Array;
      
      private var mFaction:int = 0;
      
      private var mUnitDefs:Vector.<DCDef>;
      
      private var mCurrentUnitSku:String;
      
      private var mCurrentUnitType:int = -1;
      
      private var mIsBlockingKeys:Boolean;
      
      public function ToolDebugUnits(id:int)
      {
         super(id,true,-1,-1,true,true);
         this.setMode(0);
      }
      
      override protected function beginDo() : void
      {
         InstanceMng.getHangarControllerMng().getHangarController().battlePrepareUnitsInHangars();
         InstanceMng.getBunkerController().battlePrepareUnitsInHangars();
         InstanceMng.getUnitScene().battleSetHappeningSku("doomsday");
      }
      
      override protected function endDo() : void
      {
         InstanceMng.getUnitScene().battleSetHappeningSku(null);
      }
      
      public function setMode(mode:int) : void
      {
         this.mMode = mode;
      }
      
      override protected function cursorIsEnabled() : Boolean
      {
         return true;
      }
      
      override protected function cursorDoIsApplicable(tile:TileData) : Boolean
      {
         return tile != null && tile.mBaseItem == null;
      }
      
      private function soldiersMouseUp(faction:int, tileX:int, tileY:int) : void
      {
         var u:MyUnit = null;
         var c:UnitComponentGoal = null;
         switch(this.mMode)
         {
            case 0:
               this.createUnits(this.getCurrentUnitSku(),faction,tileX,tileY);
               break;
            case 2:
               (c = (u = MyUnit(this.mUnits[0])).getGoalComponent()).notify({"cmd":"battleArmyEventRetreatAfterWinning"});
         }
      }
      
      private function createUnits(sku:String, faction:int, tileX:int, tileY:int) : void
      {
         var coor:DCCoordinate = null;
         var i:int = 0;
         var u:MyUnit = null;
         var gameUnitMng:GameUnitMng = null;
         coor = MyUnit.smCoor;
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         coor.x = tileX;
         coor.y = tileY;
         viewMng.tileXYToWorldViewPos(coor,true);
         var unitScene:UnitScene = InstanceMng.getUnitScene();
         if(faction == 0)
         {
            gameUnitMng = InstanceMng.getGameUnitMngController().getGameUnitMngOwner();
         }
         else
         {
            gameUnitMng = InstanceMng.getGameUnitMngController().getGameUnitMng();
         }
         var upgradeId:int = gameUnitMng.getCurrentUpgradeIdBySku(sku);
         var wave:String = unitScene.wavesGetStringFromAttack(1,sku,upgradeId);
         var units:Vector.<MyUnit> = unitScene.wavesCreateAttackWave(wave,coor.x,coor.y,faction);
         if(this.mUnits == null)
         {
            this.mUnits = new Array(1);
         }
         if(units != null)
         {
            for(i = 0; i < 1; )
            {
               u = units[i];
               this.mUnits[i] = u;
               i++;
            }
         }
      }
      
      override public function uiMouseUpCoors(x:int, y:int, tileX:int, tileY:int) : void
      {
         var coor:DCCoordinate;
         (coor = MyUnit.smCoor).x = x;
         coor.y = y;
         var viewMng:ViewMngPlanet;
         (viewMng = InstanceMng.getViewMngPlanet()).screenToTileXY(coor);
         this.soldiersMouseUp(this.mFaction,coor.x,coor.y);
      }
      
      public function toggleFaction() : void
      {
         this.mFaction = (this.mFaction + 1) % 2;
      }
      
      private function setCurrentUnitType(type:int) : void
      {
         if(type != this.mCurrentUnitType)
         {
            this.mCurrentUnitType = type;
            this.mUnitDefs = InstanceMng.getShipDefMng().getDefsFromTypes(ShipDefMng.TYPE_SKUS[this.mCurrentUnitType],true,"shopOrder");
            this.setCurrentUnitSku(0);
         }
      }
      
      private function setCurrentUnitSku(index:int) : void
      {
         var def:DCDef = null;
         if(this.mCurrentUnitType == -1)
         {
            this.setCurrentUnitType(2);
         }
         if(index < this.mUnitDefs.length)
         {
            def = this.mUnitDefs[index];
            this.mCurrentUnitSku = def.mSku;
         }
      }
      
      private function getCurrentUnitSku() : String
      {
         if(this.mCurrentUnitSku == null)
         {
            this.setCurrentUnitSku(0);
         }
         return this.mCurrentUnitSku;
      }
      
      override public function onKeyDown(e:KeyboardEvent) : void
      {
         var unitIds:Array = null;
         var unitId:int = 0;
         var u:MyUnit = null;
         var digitCode:int = 0;
         this.mIsBlockingKeys = true;
         switch(e.keyCode)
         {
            case 112:
               this.setCurrentUnitType(2);
               break;
            case 113:
               this.setCurrentUnitType(0);
               break;
            case 114:
               this.setCurrentUnitType(3);
               break;
            case 32:
               unitIds = [8,10,2];
               for each(unitId in unitIds)
               {
                  for each(u in InstanceMng.getUnitScene().mSceneUnits[unitId])
                  {
                     if(u != null)
                     {
                        u.shotDie("death001");
                     }
                  }
               }
               break;
            default:
               digitCode = e.keyCode - 49;
               if(digitCode >= 0 && digitCode <= 9)
               {
                  this.setCurrentUnitSku(digitCode);
               }
               else
               {
                  this.mIsBlockingKeys = false;
               }
         }
      }
      
      override public function isBlockingKeys() : Boolean
      {
         return this.mIsBlockingKeys;
      }
   }
}
