package com.dchoc.game.controller.role
{
   import com.dchoc.game.controller.world.item.actionsUI.ActionUI;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class Role
   {
      
      public static const ROLE_OWNER:int = 0;
      
      public static const ROLE_VISITOR:int = 1;
      
      public static const ROLE_SPY:int = 2;
      
      public static const ROLE_ATTACKING:int = 3;
      
      public static const ROLE_EDITOR:int = 4;
      
      public static const ROLE_TUTORIAL:int = 5;
      
      public static const ROLE_DEFENDING:int = 6;
      
      public static const ROLE_REPLAY:int = 7;
      
      public static const ROLE_LIST:Vector.<int> = new <int>[0,1,2,3,4,5,6,7];
      
      public static const ROLE_NAMES:Vector.<String> = new <String>["Owner","Visitor","Spy","Attacking","Editor","Tutorial","Defending","Replay"];
      
      public static const ROLE_COUNT:int = ROLE_LIST.length;
       
      
      public var mId:int;
      
      private var mToolCursorSize:int;
      
      public function Role(id:int)
      {
         super();
         this.mId = id;
         this.reset();
      }
      
      public static function doesPlanetBelongToUser(roleId:int) : Boolean
      {
         return roleId != 3 && roleId != 3 && roleId != 1 && roleId != 7 && roleId != 2;
      }
      
      public function reset() : void
      {
         this.mToolCursorSize = -1;
      }
      
      public function isDestroyToolAllowed() : Boolean
      {
         return true;
      }
      
      public function isBuildToolAllowed() : Boolean
      {
         return true;
      }
      
      public function isAttackingAllowed() : Boolean
      {
         return false;
      }
      
      public function isTutorialCompletedUpdateable() : Boolean
      {
         return true;
      }
      
      public function hasToBeChargedOnTransactions() : Boolean
      {
         return true;
      }
      
      public function hasToShowMissions() : Boolean
      {
         return true;
      }
      
      public function hudWorldNameProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function hudPlayerNameProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function hudRankProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function hudCashProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function hudCoinsProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function hudMineralsProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function hudMaxMineralsProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function hudMaxCoinsProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function hudDroidsProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function hudMaxDroidsProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function hudXpProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function hudScoreProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function hudLevelProfileIdAllowed() : int
      {
         return 0;
      }
      
      public function toolIsItemSelectedAllowed(actionUI:ActionUI, item:WorldItemObject) : Boolean
      {
         var returnValue:* = item != null;
         if(returnValue)
         {
            returnValue = InstanceMng.getMapControllerPlanet().toolExceptionIsAllowed(actionUI,item);
         }
         return returnValue;
      }
      
      public function toolSetCursorSize(value:int) : void
      {
         this.mToolCursorSize = value;
      }
      
      public function toolGetCursorSize() : int
      {
         return this.mToolCursorSize;
      }
      
      public function toolSetTileIsAllowed(typeToolId:int, typeTileId:int) : Boolean
      {
         var returnValue:* = false;
         switch(typeToolId)
         {
            case 0:
               returnValue = typeTileId == 1;
               break;
            case 1:
               returnValue = typeTileId == 2147483647;
         }
         return returnValue;
      }
      
      public function toolPlaceIsAllowedToKeepUsing(def:WorldItemDef) : Boolean
      {
         return def.getBaseSize() == 1 && InstanceMng.getRuleMng().isANewItemAllowedToBePlaced(def);
      }
      
      public function toolMoveCanBeAppliedToItem(item:WorldItemObject) : Boolean
      {
         return item.mDef.getTypeId() != 12;
      }
      
      public function actionUIIsAllowed(actionId:int, tile:TileData) : Boolean
      {
         var item:WorldItemObject = null;
         var returnValue:*;
         if(returnValue = tile != null)
         {
            item = tile.mBaseItem;
            if(item == null)
            {
               return this.actionUIIsAllowedOnTile(actionId,tile.getTypeId());
            }
            returnValue = item.actionUIIsAllowed(actionId) && this.actionUIIsAllowedOnItem(actionId,item);
         }
         return returnValue;
      }
      
      protected function actionUIIsAllowedOnTile(actionId:int, typeTileId:int) : Boolean
      {
         var returnValue:Boolean = false;
         if(!0)
         {
         }
         return returnValue;
      }
      
      public function actionUIIsAllowedOnItem(actionId:int, item:WorldItemObject) : Boolean
      {
         var returnValue:Boolean = true;
         switch(actionId - 7)
         {
            case 0:
               returnValue = item.mDef.canBeDemolished();
         }
         return returnValue;
      }
      
      public function moveMapIsAllowed() : Boolean
      {
         return false;
      }
      
      public function wioShowCupola(item:WorldItemObject) : Boolean
      {
         return this.mId == 0;
      }
   }
}
