package com.dchoc.game.controller.tools
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.map.MapViewPlanet;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import flash.display.Sprite;
   
   public class ToolWarCircle extends Tool
   {
      
      private static const CANCEL_ICON_SHOW_TIME_MS:int = 300;
      
      private static const TIME_BETWEEN_DEPLOYS:int = 20;
       
      
      private var mCancelIcon:Sprite;
      
      private var mCancelIconTime:int;
      
      private var mTimeLastClick:Number = 0;
      
      public function ToolWarCircle(id:int, cursorId:int = -1, actionId:int = -1)
      {
         super(id,true,cursorId,actionId,false);
      }
      
      override protected function unbuildDo() : void
      {
         if(mWhatToDrop != null)
         {
            mWhatToDrop.unbuild();
            mWhatToDrop = null;
         }
         this.mCancelIcon = null;
      }
      
      override public function checkUiDisable(tileX:int, tileY:int) : Boolean
      {
         return false;
      }
      
      override protected function cursorIsEnabled() : Boolean
      {
         return true;
      }
      
      override public function uiMouseUpCoors(x:int, y:int, tileX:int, tileY:int) : void
      {
         if(!smMapController.isTileXYInMap(tileX,tileY) && InstanceMng.getMapModel().isInDeployArea(tileX,tileY))
         {
            this.onMouseUpCoors(tileX,tileY);
         }
         else
         {
            super.uiMouseUpCoors(x,y,tileX,tileY);
         }
         if(!smMapController.mMapViewPlanet.isWarCircleOk())
         {
            if(this.mCancelIcon == null)
            {
               this.mCancelIcon = new Sprite();
               InstanceMng.getResourceMng().addImageResourceToLoad(this.mCancelIcon,InstanceMng.getResourceMng().getIconsFullPath("icon_cancel"));
            }
            if(this.mCancelIconTime == 0)
            {
               InstanceMng.getViewMngPlanet().cursorAddToStage(this.mCancelIcon);
            }
            this.mCancelIconTime = 300;
            this.mCancelIcon.x = x;
            this.mCancelIcon.y = y;
         }
      }
      
      override protected function cursorIsApplicable(tileX:int, tileY:int, checkTileInMap:Boolean = false) : Boolean
      {
         return super.cursorIsApplicable(tileX,tileY,false);
      }
      
      override protected function isCursorApplicableTileXY(tileX:int, tileY:int) : Boolean
      {
         if(InstanceMng.getMapModel().isInDeployArea(tileX,tileY))
         {
            return true;
         }
         return super.isCursorApplicableTileXY(tileX,tileY);
      }
      
      override protected function cursorDoIsApplicable(tile:TileData) : Boolean
      {
         var item:WorldItemObject = null;
         if(tile != null)
         {
            item = tile.mBaseItem;
         }
         return item == null || item != null && (item.mDef.mTypeId == 4 || item.mDef.mTypeId == 12 || item.mDef.isAMine()) || item != null && item.isCompletelyBroken();
      }
      
      override protected function cursorMove(x:int, y:int, tileX:int, tileY:int) : void
      {
         var diffX:int = 0;
         var diffY:int = 0;
         var viewMngPlanet:ViewMngPlanet;
         var viewPosX:int = (viewMngPlanet = InstanceMng.getViewMngPlanet()).screenToWorldX(x);
         var viewPosY:int = viewMngPlanet.screenToWorldY(y);
         var mapViewPlanet:MapViewPlanet;
         (mapViewPlanet = smMapController.mMapViewPlanet).updateWarCircle(viewPosX,viewPosY);
         var isOk:Boolean = false;
         if(smMapController.isTileXYInMap(tileX,tileY))
         {
            tileX = cursorCenterTile(tileX,mCursorTilesWidth);
            tileY = cursorCenterTile(tileY,mCursorTilesHeight);
            isOk = this.cursorIsApplicable(tileX,tileY);
         }
         else
         {
            isOk = InstanceMng.getMapModel().isInDeployArea(tileX,tileY);
         }
         mapViewPlanet.setDrawWarCircle(isOk);
         if(mWhatToDrop != null)
         {
            mWhatToDrop.move(viewPosX,viewPosY);
         }
         if(this.mCancelIconTime > 0 && this.mCancelIcon != null)
         {
            diffX = x - this.mCancelIcon.x;
            diffY = y - this.mCancelIcon.y;
            if(diffX * diffX + diffY * diffY > 9)
            {
               this.mCancelIconTime = 1;
            }
         }
      }
      
      override protected function uiEnableDo(forceAddListeners:Boolean = false) : void
      {
         smMapController.mMapViewPlanet.drawWarCircle();
         if(mWhatToDrop != null)
         {
            mWhatToDrop.uiEnable();
         }
         super.uiEnableDo(forceAddListeners);
      }
      
      override protected function uiDisableDo(forceRemoveListeners:Boolean = false) : void
      {
         smMapController.mMapViewPlanet.undrawWarCircle();
         if(mWhatToDrop != null)
         {
            mWhatToDrop.uiDisable();
         }
         super.uiDisableDo(forceRemoveListeners);
      }
      
      override protected function beginDo() : void
      {
         if(InstanceMng.getMapController().uiIsEnabled())
         {
            super.beginDo();
         }
      }
      
      override public function onMouseUpCoors(tileX:int, tileY:int) : void
      {
         if(!smMapController.isTileXYInMap(tileX,tileY) && InstanceMng.getMapModel().isInDeployArea(tileX,tileY))
         {
            tileX = cursorCenterTile(tileX,mCursorTilesWidth);
            tileY = cursorCenterTile(tileY,mCursorTilesHeight);
            this.onMouseDoUpCoors(tileX,tileY);
         }
         else
         {
            super.onMouseUpCoors(tileX,tileY);
         }
      }
      
      override protected function onMouseDoUpCoors(tileX:int, tileY:int) : Boolean
      {
         var timeCurrentClick:Number = NaN;
         var timeDiff:Number = NaN;
         if(smMapController.mMapViewPlanet.isWarCircleOk())
         {
            timeDiff = (timeCurrentClick = new Date().time) - this.mTimeLastClick;
            if(timeDiff > 20)
            {
               this.mTimeLastClick = timeCurrentClick;
               if(mWhatToDrop != null)
               {
                  mWhatToDrop.drop(tileX,tileY);
               }
            }
         }
         return false;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(mWhatToDrop != null)
         {
            mWhatToDrop.logicUpdate();
         }
         if(this.mCancelIconTime > 0)
         {
            this.mCancelIconTime -= dt;
            if(this.mCancelIconTime <= 0)
            {
               this.mCancelIconTime = 0;
               if(this.mCancelIcon != null)
               {
                  InstanceMng.getViewMngPlanet().cursorRemoveFromStage(this.mCancelIcon);
               }
            }
         }
      }
   }
}
