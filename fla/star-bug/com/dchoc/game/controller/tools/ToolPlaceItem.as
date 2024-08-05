package com.dchoc.game.controller.tools
{
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.controller.shop.BuildingsBufferController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.BuildingBufferFacade;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.umbrella.UmbrellaMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.services.GameMetrics;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.services.metrics.DCMetrics;
   import flash.events.KeyboardEvent;
   
   public class ToolPlaceItem extends Tool
   {
      
      private static const ITEM_ATTACHED_LAYER_IDS:Array = [0,1,3];
      
      private static const ITEM_ATTACHED_LAYERS_COUNT:int = ITEM_ATTACHED_LAYER_IDS.length;
       
      
      private var mItem:WorldItemObject;
      
      private var mItemPreviousTileX:int;
      
      private var mItemPreviousTileY:int;
      
      private var mCurrentTileIndex:int;
      
      private var mEventSubcmd:String;
      
      private var mGridOffX:int;
      
      private var mGridOffY:int;
      
      private var mCursorTileOffX:int;
      
      private var mCursorTileOffY:int;
      
      private var mPlaceOnTilesIndex:Array;
      
      private var mCanKeepPlacing:Boolean;
      
      private var mCheckDifferentPosition:Boolean;
      
      private var mItemAttachedToCursor:Vector.<Boolean>;
      
      public function ToolPlaceItem(id:int, cursorId:int, actionUIId:int, eventSubcmd:String, itemSelectedIsAllowed:Boolean = false, checkDifferentPosition:Boolean = true)
      {
         super(id,true,cursorId,actionUIId,itemSelectedIsAllowed);
         this.mEventSubcmd = eventSubcmd;
         this.resetPlaceOnTileIndex();
         this.mItemAttachedToCursor = new Vector.<Boolean>(ITEM_ATTACHED_LAYERS_COUNT);
         this.mCheckDifferentPosition = checkDifferentPosition;
      }
      
      override protected function beginDo() : void
      {
         this.mItemPreviousTileX = -1;
         this.mItemPreviousTileY = -1;
         InstanceMng.getMapViewPlanet().drawMapBorder();
      }
      
      override protected function endDo() : void
      {
         super.endDo();
         if(this.moveIsEnabled() && !InstanceMng.getBuildingsBufferController().checkItemInBuffer(this.mItem))
         {
            this.placeItem(this.mItemPreviousTileX,this.mItemPreviousTileY);
            this.moveEnd();
         }
         if(InstanceMng.getBuildingsBufferController().checkItemInBuffer(this.mItem))
         {
            this.moveEnd();
         }
         InstanceMng.getMapViewPlanet().removeMapBorder();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var d:DCDisplayObject = null;
         var i:int = 0;
         super.logicUpdateDo(dt);
         if(this.mItem != null)
         {
            if(!this.moveIsEnabled())
            {
               this.mItem.logicUpdate(dt);
            }
            if(mCursorIsBegun)
            {
               for(i = 0; i < ITEM_ATTACHED_LAYERS_COUNT; )
               {
                  if(!this.mItemAttachedToCursor[i])
                  {
                     d = this.mItem.viewLayersAnimGet(ITEM_ATTACHED_LAYER_IDS[i]);
                     if(d != null)
                     {
                        InstanceMng.getViewMngPlanet().cursorItemToolAddToStage(d);
                        InstanceMng.getMapViewPlanet().drawAttachedToMouseItemBorder(null);
                        this.mItemAttachedToCursor[i] = true;
                     }
                  }
                  i++;
               }
            }
         }
      }
      
      public function setItemSku(sku:String) : void
      {
         this.attachItem(InstanceMng.getWorld().itemsCreateItemForToolPlace(sku));
      }
      
      private function attachItem(item:WorldItemObject) : void
      {
         this.mItem = item;
         if(this.mItem != null)
         {
            this.mCursorTileOffX = -this.mItem.getBaseCols() / 2;
            this.mCursorTileOffY = -this.mItem.getBaseRows() / 2;
         }
         else
         {
            this.mCursorTileOffX = 0;
            this.mCursorTileOffY = 0;
         }
      }
      
      private function transformCursorXToItemX(x:int) : int
      {
         return x;
      }
      
      private function transformCursorYToItemY(y:int) : int
      {
         return y;
      }
      
      public function setCanKeepPlacing(value:Boolean) : void
      {
         this.mCanKeepPlacing = value;
      }
      
      override public function isItemAttached() : Boolean
      {
         return this.mItem != null;
      }
      
      override public function getAttachedItem() : WorldItemObject
      {
         return this.mItem;
      }
      
      public function setPlaceOnTileIndex(tileIndex:int) : void
      {
         this.setPlaceOnTileIndexes([tileIndex]);
      }
      
      public function setPlaceOnTileIndexes(tileIndexes:Array) : void
      {
         this.mPlaceOnTilesIndex = tileIndexes;
      }
      
      private function checkPlaceOnTileIndex() : Boolean
      {
         return this.mPlaceOnTilesIndex != null && this.mPlaceOnTilesIndex.length > 0;
      }
      
      private function resetPlaceOnTileIndex() : void
      {
         this.mPlaceOnTilesIndex = null;
      }
      
      override protected function cursorDoBegin() : void
      {
         this.mCurrentTileIndex = -1;
         if(this.mItem != null)
         {
            smMapController.mMapViewPlanet.gridBegin();
            if(this.mItem.mDef.hasCupola())
            {
               this.mItem.viewSetDefenseCupola(true);
            }
         }
      }
      
      override protected function cursorDoEnd() : void
      {
         var d:DCDisplayObject = null;
         var i:int = 0;
         if(this.mItem != null)
         {
            smMapController.mMapViewPlanet.gridEnd();
            for(i = 0; i < ITEM_ATTACHED_LAYERS_COUNT; )
            {
               d = this.mItem.viewLayersAnimGet(ITEM_ATTACHED_LAYER_IDS[i]);
               if(d != null && this.mItemAttachedToCursor[i])
               {
                  InstanceMng.getViewMngPlanet().cursorItemToolRemoveFromStage(d);
                  this.mItemAttachedToCursor[i] = false;
                  if(InstanceMng.getPowerUpMng().unitsIsAnyPowerUpActiveByUnitSku(this.mItem.mDef.mSku,1))
                  {
                     this.mItem.viewSetPowerUp(false);
                  }
               }
               i++;
            }
            if(this.mItem.mDef.hasCupola())
            {
               this.mItem.viewSetDefenseCupola(false);
            }
            InstanceMng.getMapViewPlanet().removeAttachedToMouseItemBorder();
         }
      }
      
      override protected function cursorIsEnabled() : Boolean
      {
         return true;
      }
      
      override protected function cursorIsApplicable(tileX:int, tileY:int, checkTileInMap:Boolean = true) : Boolean
      {
         if(this.mItem != null)
         {
            tileX += this.mCursorTileOffX;
            tileY += this.mCursorTileOffY;
         }
         return super.cursorIsApplicable(tileX,tileY,checkTileInMap);
      }
      
      override protected function cursorDoIsApplicable(tile:TileData) : Boolean
      {
         var returnValue:* = false;
         if(this.mItem == null)
         {
            returnValue = true;
         }
         else
         {
            returnValue = tile != null;
            if(returnValue)
            {
               if(this.checkPlaceOnTileIndex())
               {
                  returnValue = this.mPlaceOnTilesIndex.indexOf(tile.mTileIndex) > -1;
               }
               else
               {
                  returnValue = smMapController.mMapModel.placeIsItemPlaceable(this.mItem,this.transformCursorXToItemX(tile.getCol()),this.transformCursorYToItemY(tile.getRow()));
               }
            }
         }
         return returnValue;
      }
      
      override protected function cursorMove(x:int, y:int, tileX:int, tileY:int) : void
      {
         var tileIndex:int = 0;
         var tilePosX:int = 0;
         var tilePosY:int = 0;
         var tile:TileData = null;
         var cursorVisible:Boolean = false;
         var gridId:int = 0;
         if(this.mItem == null)
         {
            return;
         }
         tileIndex = smMapController.getTileXYToIndex(tileX,tileY);
         setTransparentItemAlpha(1);
         mTransparentItem.length = 0;
         searchObstructionsToItem(this.mItem,tileX,tileY);
         if(tileIndex == this.mCurrentTileIndex)
         {
            return;
         }
         this.mCurrentTileIndex = tileIndex;
         tilePosX = tileX + this.mCursorTileOffX;
         tilePosY = tileY + this.mCursorTileOffY;
         tileIndex = smMapController.getTileXYToIndex(tilePosX,tilePosY);
         super.cursorMove(x,y,tilePosX,tilePosY);
         this.mItem.setTileXY(tilePosX,tilePosY);
         tile = smMapController.getTileDataFromTileXY(tilePosX,tilePosY);
         InstanceMng.getMapViewPlanet().drawHouseBorder(this.mItem,tilePosX,tilePosY);
         if(this.cursorDoIsApplicable(tile))
         {
            this.mItem.viewLayersTypeRequiredSet(4,26);
            InstanceMng.getMapViewPlanet().drawItemBorder(this.mItem,16777215);
         }
         else
         {
            this.mItem.viewLayersTypeRequiredSet(4,27);
            InstanceMng.getMapViewPlanet().drawItemBorder(this.mItem,16711680);
         }
         if(cursorVisible = InstanceMng.getMapControllerPlanet().isTileXYInMap(tileX,tileY))
         {
            gridId = this.cursorDoIsApplicable(tile) ? 0 : 0;
            smMapController.mMapViewPlanet.gridSet(gridId);
            if(this.mItem.mDef.mBaseRows % 2 == 0 && this.mItem.mDef.mBaseCols % 2 == 0)
            {
               this.mGridOffX = 0;
               this.mGridOffY = 16 / 2;
            }
            else if(this.mItem.mDef.mBaseRows % 2 != 0 && this.mItem.mDef.mBaseCols % 2 != 0)
            {
               this.mGridOffY = 0;
               this.mGridOffX = 0;
            }
            else if(this.mItem.mDef.mBaseRows % 2 == 0 && this.mItem.mDef.mBaseCols % 2 != 0)
            {
               this.mGridOffX = 32 / 4;
               this.mGridOffY = -4;
            }
            else if(this.mItem.mDef.mBaseRows % 2 != 0 && this.mItem.mDef.mBaseCols % 2 == 0)
            {
               this.mGridOffX = 32 / 4;
               this.mGridOffY = 16 / 4;
            }
            smMapController.mMapViewPlanet.gridSetXY(this.mItem.mViewCenterWorldX + this.mGridOffX,this.mItem.mViewCenterWorldY + this.mGridOffY);
         }
         else
         {
            smMapController.mMapViewPlanet.gridEnd();
         }
      }
      
      override protected function onMouseDoUpCoors(tileX:int, tileY:int) : Boolean
      {
         var item:WorldItemObject = null;
         if(this.mItem != null)
         {
            tileX += this.mCursorTileOffX;
            tileY += this.mCursorTileOffY;
         }
         var tile:TileData = smMapController.getTileDataFromTileXY(tileX,tileY);
         if(this.cursorDoIsApplicable(tile))
         {
            if(this.mItem == null)
            {
               item = tile.mBaseItem;
               this.uiMouseUpItem(item);
            }
            else
            {
               applyRequest(tile);
            }
         }
         return true;
      }
      
      override protected function uiMouseUpItem(item:WorldItemObject) : void
      {
         var notificationsMng:NotificationsMng = null;
         var notification:Notification = null;
         if(item == null)
         {
            return;
         }
         if(item.moveCanBeMoved())
         {
            this.moveBegin(item);
         }
         else
         {
            notificationsMng = InstanceMng.getNotificationsMng();
            notification = notificationsMng.createNotificationWIOCantBeMoved();
            notificationsMng.guiOpenNotificationMessage(notification);
         }
      }
      
      public function placeItem(tileX:int, tileY:int) : Object
      {
         var params:Object = null;
         var hqLevel:int = 0;
         var colonies:int = 0;
         var coins:int = 0;
         var cash:int = 0;
         if(!smMapController.mMapModel.placeIsItemPlaceable(this.mItem,tileX,tileY))
         {
            return null;
         }
         var subcmd:String = this.mEventSubcmd;
         this.mItem.setTileXY(tileX,tileY);
         var e:Object = {};
         if(this.moveIsEnabled())
         {
            this.mItem.moveEnd();
            if(InstanceMng.getBuildingsBufferController().isBufferOpen() || this.mCheckDifferentPosition && tileX == this.mItemPreviousTileX && tileY == this.mItemPreviousTileY)
            {
               subcmd = "RestoreItem";
            }
         }
         this.resetPlaceOnTileIndex();
         e.item = this.mItem;
         e.cmd = "WorldEventPlaceItem";
         e.subcmd = subcmd;
         e.tileX = this.transformCursorXToItemX(tileX);
         e.tileY = this.transformCursorYToItemY(tileY);
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorld(),e,true);
         if(e.subcmd == "MoveItem" || e.subcmd == "FlipItem")
         {
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),e,true);
         }
         else if(Config.USE_METRICS)
         {
            params = {};
            hqLevel = int(GameMetrics.getHQLevel());
            if(hqLevel > -1)
            {
               params.p3 = hqLevel + 1;
            }
            if((colonies = GameMetrics.getNumColonies()) > 0)
            {
               params.p2 = colonies;
            }
            coins = this.mItem.mDef.getConstructionCoins();
            cash = this.mItem.mDef.getConstructionCash();
            if(coins > 0)
            {
               DCMetrics.sendMetric("Spend GC","Buy Item","Building",this.mItem.mDef.getSkuTracking(),params,coins);
            }
            else if(cash > 0)
            {
               DCMetrics.sendMetric("Spend PC","Buy Item","Building",this.mItem.mDef.getSkuTracking(),params,cash);
            }
         }
         if(Config.USE_SOUNDS)
         {
            SoundManager.getInstance().playSound("build.mp3",1,0,0,1);
         }
         if(this.mItem.mDef.isABunker() && this.mItem.mShouldHighLight)
         {
            this.mItem.highlightAdd();
         }
         return e;
      }
      
      override protected function applyDo() : void
      {
         if(mApplyOnTile == null)
         {
            return;
         }
         if(smMapController.mMapModel.placeIsItemPlaceable(this.mItem,mApplyOnTile.getCol(),mApplyOnTile.getRow()))
         {
            cursorEnd();
            if(mTransaction != null)
            {
               mTransaction.setWorldItemObject(this.mItem);
               this.mItem.setTransaction(mTransaction);
               if(!mTransaction.getTransHasBeenPerformed())
               {
                  mTransaction.performAllTransactions();
               }
            }
            this.applyPlaceItem();
         }
      }
      
      private function applyPlaceItem() : void
      {
         var e:Object = null;
         var tempItem:WorldItemObject = null;
         var BBController:BuildingsBufferController = InstanceMng.getBuildingsBufferController();
         if(mApplyOnTile == null)
         {
            return;
         }
         e = this.placeItem(mApplyOnTile.getCol(),mApplyOnTile.getRow());
         if(e == null)
         {
            return;
         }
         if(this.moveIsEnabled())
         {
            tempItem = this.mItem;
            this.moveEnd();
            if(BBController.getBuildingAmount(tempItem.mDef.getSku()) >= 1)
            {
               this.moveBuildingForBuffer(BBController.getBuildingByTypeSku(tempItem));
               BBController.removeItem(this.mItem);
               InstanceMng.getUIFacade().getBuildingsBufferBar().reloadView();
               return;
            }
         }
         else if(InstanceMng.getRole().toolPlaceIsAllowedToKeepUsing(this.mItem.mDef) && this.mCanKeepPlacing)
         {
            if(mTransaction != null)
            {
               mTransaction.reset();
               InstanceMng.getApplication().mTransactionEventComesFrom = null;
            }
            this.setItemSku(this.mItem.mDef.mSku);
            cursorBegin();
         }
         else
         {
            InstanceMng.getToolsMng().setTool(0);
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),e);
         }
         InstanceMng.getTargetMng().updateProgress("placeItem",1);
      }
      
      protected function onItemAssignedToCursor(item:WorldItemObject) : void
      {
      }
      
      override public function moveBuildingForBuffer(item:WorldItemObject) : void
      {
         this.moveBegin(item,true);
      }
      
      protected function moveBegin(item:WorldItemObject, forBuffer:Boolean = false) : void
      {
         var umbrellaMng:UmbrellaMng = null;
         cursorEnd();
         itemSelectedSetIsAllowed(false);
         this.attachItem(item);
         smMapController.mMapModel.placeUnplaceItem(this.mItem);
         this.onItemAssignedToCursor(this.mItem);
         this.mItem.moveBegin(true,forBuffer);
         this.mItemPreviousTileX = smMapController.getTileRelativeXToTile(this.mItem.mTileRelativeX);
         this.mItemPreviousTileY = smMapController.getTileRelativeYToTile(this.mItem.mTileRelativeY);
         cursorBegin();
         if(Config.useUmbrella())
         {
            umbrellaMng = InstanceMng.getUmbrellaMng();
            if(umbrellaMng.isThereUmbrella() && item.mDef.isHeadQuarters())
            {
               umbrellaMng.moveUmbrellaBegin();
            }
         }
         InstanceMng.getUIFacade().getBuildingsBufferBar().updateButtons();
      }
      
      override public function moveEnd() : void
      {
         var umbrellaMng:UmbrellaMng = null;
         if(Config.useUmbrella())
         {
            umbrellaMng = InstanceMng.getUmbrellaMng();
            if(umbrellaMng.isThereUmbrella() && this.mItem.mDef.isHeadQuarters())
            {
               umbrellaMng.moveUmbrellaEnd();
            }
         }
         this.attachItem(null);
         mApplyOnTile = null;
         itemSelectedSetIsAllowed(true);
         this.mItemPreviousTileX = -1;
         this.mItemPreviousTileY = -1;
         smMapController.mMapViewPlanet.gridEnd();
         var bufferBar:BuildingBufferFacade = InstanceMng.getUIFacade().getBuildingsBufferBar();
         bufferBar.noLongerInitialState();
         bufferBar.updateButtons();
      }
      
      private function moveIsEnabled() : Boolean
      {
         return this.mItemPreviousTileX > -1;
      }
      
      override public function notify(e:Object) : Boolean
      {
         var returnValue:Boolean = false;
         if(e != null)
         {
            var _loc3_:* = e.cmd;
            if("mapToolsEventPlaceItem" === _loc3_)
            {
               this.applyDo();
               returnValue = true;
            }
         }
         if(!returnValue)
         {
            returnValue = super.notify(e);
         }
         return returnValue;
      }
      
      override public function onKeyDown(e:KeyboardEvent) : void
      {
         switch(int(e.keyCode) - 32)
         {
            case 0:
               InstanceMng.getApplication().lockUIReset();
               this.applyDo();
         }
      }
   }
}
