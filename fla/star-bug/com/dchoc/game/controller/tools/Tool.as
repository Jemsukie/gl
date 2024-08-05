package com.dchoc.game.controller.tools
{
   import com.dchoc.game.controller.gui.GUIController;
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.controller.world.item.actionsUI.ActionUI;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.tooltips.ETooltip;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.unit.components.goal.GoalCivil;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class Tool extends DCComponentUI
   {
      
      public static const CURSOR_COLLISION_AREA:int = 10;
      
      protected static var smMapController:MapControllerPlanet;
      
      private static var smTooltipsEnabled:Boolean;
      
      private static var smMatrix:Matrix;
      
      private static var smPointZero:Point;
      
      private static var smMousePoint:Point;
      
      private static const SEARCH_FOR_SELECTION_OFF:Array = [[0,0],[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7],[8,8],[9,9],[1,0],[0,1],[1,1],[2,1]];
      
      private static const SEARCH_FOR_SELECTION_OFF_COUNT:int = SEARCH_FOR_SELECTION_OFF.length;
      
      private static const TOOLTIP_WIDTH:int = 80;
      
      private static const TOOLTIP_HEIGHT:int = 50;
      
      private static const TOOLTIP_WAITING_TIME_BEFORE_APPEARING_MS:int = 750;
      
      private static const TOOLTIP_NO_WAIT_TIME_MS:int = 1;
       
      
      protected var mSelection:Vector.<WorldItemObject>;
      
      public var mIsSelectionDone:Boolean = false;
      
      public var mId:int;
      
      protected var mCursorId:int;
      
      protected var mActionId:int;
      
      protected var mActionUI:ActionUI;
      
      protected var mCursorAsAWhole:Boolean;
      
      protected var mTransparentItem:Array;
      
      private var mCoor:DCCoordinate;
      
      private var mViewMngr:ViewMngPlanet;
      
      protected var mTransaction:Transaction;
      
      protected var mCursorArea:Bitmap;
      
      protected var mCursorCenterTileIsEnabled:Boolean;
      
      protected var mCursorIsBegun:Boolean;
      
      protected var mCursorTilesWidth:int;
      
      protected var mCursorTilesHeight:int;
      
      private var mCursorDrawTileIsEnabled:Boolean;
      
      private var mCursorMap:Vector.<int>;
      
      private var mItemSelectedIsEnabled:Boolean;
      
      private var mItemSelectedIsAllowed:Boolean;
      
      protected var mItemSelected:WorldItemObject;
      
      private var mItemSelectedAction:ActionUI;
      
      private var mItemSelectedTooltipTimer:Number;
      
      private var mItemUnderCursorOld:WorldItemObject;
      
      private var mItemSelectedActionMouseOverIsAllowed:Boolean;
      
      private var mCurrentETooltip:ETooltip;
      
      protected var mApplyOnTile:TileData;
      
      protected var mWhatToDrop:WhatToDrop;
      
      public function Tool(id:int, cursorAsAWhole:Boolean = false, cursorId:int = -1, actionId:int = -1, itemSelectedIsAllowed:Boolean = true, cursorDrawTileIsEnabled:Boolean = false)
      {
         super();
         this.mId = id;
         this.itemSelectedSetIsAllowed(itemSelectedIsAllowed);
         if(cursorId == -1)
         {
            cursorId = -1;
         }
         if(actionId == -1)
         {
            actionId = 25;
         }
         this.mCursorId = cursorId;
         this.mActionId = actionId;
         this.mCursorAsAWhole = cursorAsAWhole;
         this.mCursorDrawTileIsEnabled = cursorDrawTileIsEnabled;
         this.mTransparentItem = [];
         this.mCursorArea = new Bitmap(new BitmapData(10,10,false,16711680));
         smPointZero = new Point();
         this.mCursorCenterTileIsEnabled = true;
      }
      
      public static function setMapController(value:MapControllerPlanet) : void
      {
         smMapController = value;
      }
      
      public static function unloadStatic() : void
      {
         smMapController = null;
         tooltipsEnabled = false;
         smMatrix = null;
         smPointZero = null;
         smMousePoint = null;
      }
      
      public static function set tooltipsEnabled(value:Boolean) : void
      {
         smTooltipsEnabled = value;
      }
      
      public static function get tooltipsEnabled() : Boolean
      {
         return smTooltipsEnabled;
      }
      
      public function checkUiDisable(tileX:int, tileY:int) : Boolean
      {
         return !this.isTileXYInMap(tileX,tileY);
      }
      
      protected function isTileXYInMap(tileX:int, tileY:int) : Boolean
      {
         return smMapController.isTileXYInMap(tileX,tileY);
      }
      
      override protected function unloadDo() : void
      {
         if(this.cursorIsEnabled())
         {
            this.cursorUnload();
         }
         this.mActionUI = null;
         this.mViewMngr = null;
      }
      
      override protected function beginDo() : void
      {
         super.beginDo();
         this.mCursorIsBegun = false;
         if(this.mItemSelectedIsEnabled)
         {
            this.itemSelectedBegin();
         }
      }
      
      override protected function endDo() : void
      {
         super.endDo();
         if(this.mItemSelectedIsEnabled)
         {
            this.itemSelectedEnd();
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var tooltipInfo:ETooltipInfo = null;
         var tooltipType:String = null;
         if(this.mItemSelectedTooltipTimer > 0)
         {
            this.mItemSelectedTooltipTimer -= dt;
            if(this.mItemSelectedTooltipTimer <= 0)
            {
               if(tooltipsEnabled)
               {
                  if(Config.useEsparragonTooltips())
                  {
                     tooltipType = this.getTooltipTypeByActionUIId();
                     if(tooltipType)
                     {
                        tooltipInfo = ETooltipMng.getInstance().createTooltipForUIAction(this.getTooltipTypeByActionUIId(),this.mItemSelected,false);
                        this.mCurrentETooltip = ETooltipMng.getInstance().showTooltip(tooltipInfo);
                     }
                  }
               }
               this.mItemSelectedTooltipTimer = 0;
            }
         }
      }
      
      public function getCursorActionArea() : Bitmap
      {
         return this.mCursorArea;
      }
      
      public function getCursorId() : int
      {
         return this.mCursorId;
      }
      
      public function setTransaction(transaction:Transaction) : void
      {
         this.mTransaction = transaction;
         if(this.mWhatToDrop != null)
         {
            this.mWhatToDrop.setTransaction(this.mTransaction);
         }
      }
      
      override protected function uiEnableDo(forceAddListeners:Boolean = false) : void
      {
         InstanceMng.getGUIControllerPlanet().cursorSetId(this.getCursorId());
         if(this.cursorIsEnabled())
         {
            this.cursorBegin();
         }
      }
      
      override protected function uiDisableDo(forceRemoveListeners:Boolean = false) : void
      {
         if(this.mItemSelectedIsEnabled)
         {
            this.itemSelectedEnd();
         }
         this.setTransparentItemAlpha(1);
         if(this.cursorIsEnabled())
         {
            this.cursorEnd();
         }
         smMapController.mMapViewPlanet.mapCursorDisable();
         InstanceMng.getGUIControllerPlanet().cursorSetId(-1);
      }
      
      public function getToolActionId(item:WorldItemObject) : int
      {
         return this.mActionUI.getActionId(item);
      }
      
      public function uiMouseMoveCoors(x:int, y:int, tileX:int, tileY:int) : void
      {
         var tile:TileData = null;
         var nextAction:ActionUI = null;
         var item:WorldItemObject = null;
         var actionCompleteMouseOver:Boolean = false;
         var toolActionId:int = 0;
         var isInside:Boolean = this.isTileXYInMap(tileX,tileY);
         this.mCursorArea.x = x - 10 / 2;
         this.mCursorArea.y = y - 10 / 2;
         if(this.mItemSelectedIsEnabled)
         {
            tile = smMapController.getTileDataFromTileXY(tileX,tileY);
            nextAction = null;
            item = null;
            if((item = this.searchSelectableItem(x,y,tileX,tileY)) == null && isInside)
            {
               item = tile.mBaseItem;
            }
            if(item != null && item.itemOnTopGetIsEnabled())
            {
               item = null;
            }
            if(item == null || item != this.mItemUnderCursorOld)
            {
               this.setTransparentItemAlpha(1);
               this.mTransparentItem.length = 0;
            }
            if(item != null)
            {
               this.mItemUnderCursorOld = item;
               this.searchObstructionsToItem(item,tileX,tileY);
               if(this.mActionUI == null)
               {
                  this.mActionUI = InstanceMng.getWorldItemObjectController().actionsUIGetAction(this.mActionId);
               }
               toolActionId = this.getToolActionId(item);
               if(InstanceMng.getToolsMng().getCurrentToolId() != 15 || item.mDef.isAWall())
               {
                  nextAction = InstanceMng.getWorldItemObjectController().actionsUIGetPreferredAction(toolActionId,item.getActionUIId());
               }
               if(!this.isActionAllowedOnItem(item,nextAction))
               {
                  nextAction = null;
               }
            }
            if(!InstanceMng.getRole().toolIsItemSelectedAllowed(nextAction,item))
            {
               item = null;
               nextAction = null;
            }
            actionCompleteMouseOver = false;
            if(this.mItemSelectedAction != nextAction || this.mItemSelected != item)
            {
               if(this.mItemSelectedAction != null)
               {
                  this.itemSelectedActionUndoMouseOver(this.mItemSelected,true);
                  this.itemSelectedCloseTooltip();
               }
               this.mItemSelectedAction = nextAction;
               if(this.mItemSelectedAction != null && item != null)
               {
                  actionCompleteMouseOver = true;
                  this.mItemSelectedTooltipTimer = DCTimerUtil.secondToMs(InstanceMng.getSettingsDefMng().mSettingsDef.getWIOTooltipTimeOut());
               }
            }
            if(this.mItemSelectedAction != null)
            {
               if(!isInside)
               {
                  tileX = int(smMapController.getTileRelativeXToTile(item.mTileRelativeX));
                  tileY = int(smMapController.getTileRelativeYToTile(item.mTileRelativeY));
                  tile = smMapController.getTileDataFromTileXY(tileX,tileY);
               }
               this.itemSelectedActionDoMouseOver(item,tile.mTileIndex,actionCompleteMouseOver);
            }
            this.mItemSelected = item;
            if(this.cursorIsEnabled())
            {
               if(this.mItemSelected != null)
               {
                  this.cursorEnd();
               }
               else
               {
                  this.cursorBegin();
               }
            }
         }
         if(this.cursorIsEnabled())
         {
            this.cursorMove(x,y,tileX,tileY);
         }
      }
      
      protected function itemSelectedActionDoMouseOver(item:WorldItemObject, tileIndex:int, actionCompleteMouseOver:Boolean) : void
      {
         if(this.mItemSelectedActionMouseOverIsAllowed)
         {
            this.mItemSelectedAction.doMouseOver(item,tileIndex,actionCompleteMouseOver);
         }
      }
      
      protected function itemSelectedActionUndoMouseOver(item:WorldItemObject, changeCursor:Boolean) : void
      {
         if(this.mItemSelectedActionMouseOverIsAllowed)
         {
            if(changeCursor)
            {
               InstanceMng.getGUIControllerPlanet().cursorSetId(this.getCursorId());
            }
            this.mItemSelectedAction.undoMouseOver(item);
         }
      }
      
      protected function isActionAllowedOnItem(item:WorldItemObject, nextAction:ActionUI) : Boolean
      {
         var actionUIId:int = 0;
         var returnValue:* = nextAction == null;
         if(!returnValue)
         {
            actionUIId = nextAction.getActionId(item);
            returnValue = InstanceMng.getRole().actionUIIsAllowedOnItem(actionUIId,item) && item.actionUIIsAllowed(actionUIId);
         }
         return returnValue;
      }
      
      public function uiMouseDownCoors(tileX:int, tileY:int) : void
      {
         onMouseDownCoors(tileX,tileY);
         this.updateItemSelectedAction();
      }
      
      protected function updateItemSelectedAction() : void
      {
         var newAction:ActionUI = null;
         var toolActionId:int = 0;
         if(this.mItemSelectedIsEnabled && this.mItemSelected != null)
         {
            newAction = null;
            if(this.mActionUI == null)
            {
               this.mActionUI = InstanceMng.getWorldItemObjectController().actionsUIGetAction(this.mActionId);
            }
            toolActionId = this.getToolActionId(this.mItemSelected);
            newAction = InstanceMng.getWorldItemObjectController().actionsUIGetPreferredAction(toolActionId,this.mItemSelected.getActionUIId());
            if(!this.isActionAllowedOnItem(this.mItemSelected,newAction))
            {
               newAction = null;
            }
            if(this.mItemSelectedAction != newAction)
            {
               if(this.mItemSelectedAction != null)
               {
                  this.itemSelectedActionUndoMouseOver(this.mItemSelected,true);
                  this.itemSelectedCloseTooltip();
               }
               this.mItemSelectedAction = newAction;
            }
         }
      }
      
      public function uiMouseUpCoors(x:int, y:int, tileX:int, tileY:int) : void
      {
         var item:WorldItemObject = null;
         var unitScene:UnitScene = null;
         var newSelectUnit:MyUnit = null;
         var goal:GoalCivil = null;
         var goOn:Boolean = true;
         if(this.mItemSelected)
         {
            if((item = this.searchSelectableItem(x,y,tileX,tileY)) != null)
            {
               goOn = item.mDef.playAction();
               if(item.mDef.getCanBeRide() && !item.decorationIsBeingRidden())
               {
                  InstanceMng.getTrafficMng().civilsSendCivilToRide(item);
                  goOn = false;
               }
               if(this.isActionAllowedOnItem(item,this.mItemSelectedAction))
               {
                  goOn = false;
                  this.uiMouseUpItem(item);
               }
            }
         }
         if(goOn && this.isTileXYInMap(tileX,tileY))
         {
            this.onMouseUpCoors(tileX,tileY);
            if(!(newSelectUnit = (unitScene = InstanceMng.getUnitScene()).getSelectableUnit(x,y,1)))
            {
               return;
            }
            if(!(goal = newSelectUnit.getGoalComponent() as GoalCivil))
            {
               return;
            }
            goal.startJump();
         }
         this.updateItemSelectedAction();
      }
      
      protected function uiMouseUpItem(item:WorldItemObject) : void
      {
         if(this.mItemSelectedAction != null)
         {
            this.mItemSelectedAction.mouseClick(this.mItemSelected,-1);
         }
      }
      
      protected function searchObstructionsToItem(item:WorldItemObject, tileX:int, tileY:int) : void
      {
         var obstructive:WorldItemObject = null;
         var dcDsp:DCDisplayObject = null;
         var obstructivePoint:Point = null;
         var obstructiveBmpData:BitmapData = null;
         var itemBmpData:BitmapData = null;
         var itemDsp:DisplayObject = null;
         var j:int = 0;
         var i:int = 0;
         var l:int = 0;
         var obstructiveDsp:DisplayObject = null;
         var addObstructive:Boolean = false;
         var MOVEMENT:Vector.<Vector.<int>> = new <Vector.<int>>[new <int>[1,1],new <int>[0,1],new <int>[1,0]];
         var LAYERS:Vector.<int> = new <int>[5,1];
         var TILES_COUNT:int = 10;
         var itemDcDsp:DCDisplayObject = item.viewLayersAnimGet(1);
         var itemPoint:Point = new Point(0,0);
         if(InstanceMng.getFlowState().getCurrentRoleId() == 0 && itemDcDsp != null)
         {
            itemDsp = itemDcDsp.getDisplayObjectContent();
            for(j = 0; j < MOVEMENT.length; )
            {
               tileX = smMapController.getTileRelativeXToTile(item.mTileRelativeX) + item.getBaseCols() / 2;
               tileY = smMapController.getTileRelativeYToTile(item.mTileRelativeY) + item.getBaseRows() / 2;
               for(i = 0; i < TILES_COUNT; )
               {
                  if(this.isTileXYInMap(tileX,tileY))
                  {
                     if((obstructive = smMapController.getTileDataFromTileXY(tileX,tileY).mBaseItem) != null && obstructive != item && this.mTransparentItem.indexOf(obstructive) < 0)
                     {
                        for each(l in LAYERS)
                        {
                           if((dcDsp = obstructive.viewLayersAnimGet(l)) != null)
                           {
                              obstructiveDsp = dcDsp.getDisplayObjectContent();
                              if(itemDsp.parent != null && obstructiveDsp.parent != null && obstructiveDsp.hitTestObject(itemDsp))
                              {
                                 addObstructive = true;
                                 if(l == 1)
                                 {
                                    obstructivePoint = new Point(0,0);
                                    obstructiveBmpData = this.createHitTestBitmapData(obstructiveDsp,obstructivePoint);
                                    if(itemBmpData == null)
                                    {
                                       itemBmpData = this.createHitTestBitmapData(itemDsp,itemPoint);
                                    }
                                    addObstructive = itemBmpData.hitTest(itemPoint,255,obstructiveBmpData,obstructivePoint,255);
                                    obstructiveBmpData.dispose();
                                 }
                                 if(addObstructive)
                                 {
                                    this.mTransparentItem.push(obstructive);
                                 }
                              }
                           }
                        }
                     }
                  }
                  tileX += MOVEMENT[j][0];
                  tileY += MOVEMENT[j][1];
                  i++;
               }
               j++;
            }
            if(itemBmpData != null)
            {
               itemBmpData.dispose();
            }
            this.setTransparentItemAlpha(0.4);
         }
      }
      
      private function createHitTestBitmapData(dsp:DisplayObject, point:Point) : BitmapData
      {
         var bmpd:BitmapData = new BitmapData(dsp.width,dsp.height,true,0);
         var doFlip:Boolean = dsp.parent.scaleX < 0 && dsp.scaleX < 0;
         var scaleX:Number = dsp.parent.scaleX * dsp.scaleX;
         if(doFlip)
         {
            scaleX *= -1;
         }
         var scaleY:Number = dsp.parent.scaleY * dsp.scaleY;
         var tX:Number = 0;
         var tY:Number = 0;
         if(scaleX < 0)
         {
            tX = -scaleX * dsp.width;
         }
         if(scaleY < 0)
         {
            tY = -scaleY * dsp.height;
         }
         var newPoint:Point = dsp.localToGlobal(point);
         point.x = int(newPoint.x - tX);
         point.y = int(newPoint.y - tY);
         if(smMatrix == null)
         {
            smMatrix = new Matrix();
         }
         smMatrix.identity();
         smMatrix.scale(scaleX,scaleY);
         smMatrix.translate(tX,tY);
         bmpd.draw(dsp,smMatrix);
         return bmpd;
      }
      
      protected function setTransparentItemAlpha(value:Number) : void
      {
         var item:WorldItemObject = null;
         if(this.mTransparentItem != null)
         {
            for each(item in this.mTransparentItem)
            {
               item.setLayersAlpha(value);
            }
         }
      }
      
      protected function searchSelectableItem(x:Number, y:Number, tileX:int, tileY:int) : WorldItemObject
      {
         var i:int = 0;
         var tile:TileData = null;
         var item:WorldItemObject = null;
         var tileCheckX:int = 0;
         var tileCheckY:int = 0;
         for(i = 0; i < SEARCH_FOR_SELECTION_OFF_COUNT; )
         {
            tileCheckX = tileX + SEARCH_FOR_SELECTION_OFF[i][0];
            tileCheckY = tileY + SEARCH_FOR_SELECTION_OFF[i][1];
            if(this.isTileXYInMap(tileCheckX,tileCheckY))
            {
               if((item = (tile = smMapController.getTileDataFromTileXY(tileCheckX,tileCheckY)).mBaseItem) != null)
               {
                  if(i == 0 || this.checkMouseCollision(item,x,y))
                  {
                     return item;
                  }
               }
            }
            i++;
         }
         return null;
      }
      
      private function checkMouseCollision(item:WorldItemObject, x:Number, y:Number) : Boolean
      {
         var dsp:DisplayObject = null;
         var layer:int = 0;
         var bmpData:BitmapData = null;
         var LAYERS:Array = new Array(5,1,0);
         for each(layer in LAYERS)
         {
            if(item.viewLayersAnimGet(layer) != null)
            {
               if((dsp = item.viewLayersAnimGet(layer).getDisplayObjectContent()) != null && dsp.parent != null && dsp.hitTestObject(this.mCursorArea))
               {
                  smPointZero.x = 0;
                  smPointZero.y = 0;
                  if(smMousePoint == null)
                  {
                     smMousePoint = new Point();
                  }
                  smMousePoint.x = this.mCursorArea.x;
                  smMousePoint.y = this.mCursorArea.y;
                  if((bmpData = this.createHitTestBitmapData(dsp,smPointZero)).hitTest(smPointZero,255,this.mCursorArea.bitmapData,smMousePoint,255))
                  {
                     bmpData.dispose();
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      override public function onMouseUpCoors(tileX:int, tileY:int) : void
      {
         var tile:TileData = null;
         var i:int = 0;
         var j:int = 0;
         tileX = this.cursorCenterTile(tileX,this.mCursorTilesWidth);
         tileY = this.cursorCenterTile(tileY,this.mCursorTilesHeight);
         var continueProcess:* = true;
         if(this.mItemSelectedAction != null)
         {
            continueProcess = !this.mItemSelectedAction.mouseClick(this.mItemSelected,smMapController.getTileXYToIndex(tileX,tileY));
         }
         if(continueProcess)
         {
            if(this.cursorIsEnabled())
            {
               continueProcess = this.cursorIsApplicable(tileX,tileY);
               if(continueProcess)
               {
                  for(i = 0; i < this.mCursorTilesHeight; )
                  {
                     for(j = 0; j < this.mCursorTilesWidth; )
                     {
                        if(!this.mCursorAsAWhole)
                        {
                           tile = smMapController.getTileDataFromTileXY(tileX + j,tileY + i);
                           continueProcess = this.cursorDoIsApplicable(tile);
                        }
                        if(continueProcess)
                        {
                           continueProcess = this.onMouseDoUpCoors(tileX + j,tileY + i);
                        }
                        if(!continueProcess)
                        {
                           break;
                        }
                        j++;
                     }
                     i++;
                  }
               }
            }
            else
            {
               this.onMouseDoUpCoors(tileX,tileY);
            }
         }
      }
      
      protected function onMouseDoUpCoors(tileX:int, tileY:int) : Boolean
      {
         return true;
      }
      
      public function cursorSetSize(tilesWidth:int, tilesHeight:int) : void
      {
         var index:int = 0;
         var i:int = 0;
         var j:int = 0;
         if(this.cursorIsEnabled())
         {
            this.mCursorMap = new Vector.<int>(0);
            this.mCursorTilesWidth = tilesWidth;
            this.mCursorTilesHeight = tilesHeight;
            for(i = 0; i < this.mCursorTilesHeight; )
            {
               index = i * this.mCursorTilesWidth;
               for(j = 0; j < this.mCursorTilesWidth; )
               {
                  this.mCursorMap[index + j] = 0;
                  j++;
               }
               i++;
            }
         }
      }
      
      protected function cursorUnload() : void
      {
         this.mCursorMap = null;
      }
      
      public function cursorBegin() : void
      {
         if(!this.mCursorIsBegun)
         {
            this.cursorDoBegin();
            this.mCursorIsBegun = true;
         }
      }
      
      protected function cursorDoBegin() : void
      {
         smMapController.mMapViewPlanet.mapCursorEnable(this.mCursorTilesWidth,this.mCursorTilesHeight);
      }
      
      public function cursorEnd() : void
      {
         if(this.mCursorIsBegun)
         {
            this.cursorDoEnd();
            this.mCursorIsBegun = false;
         }
      }
      
      protected function cursorDoEnd() : void
      {
         smMapController.mMapViewPlanet.mapCursorDisable();
      }
      
      protected function cursorSetTile(tileX:int, tileY:int, allowed:Boolean) : void
      {
         var index:int = tileY * this.mCursorTilesWidth + tileX;
         this.mCursorMap[index] = allowed ? 0 : 1;
      }
      
      protected function cursorIsEnabled() : Boolean
      {
         return false;
      }
      
      protected function isCursorApplicableTileXY(tileX:int, tileY:int) : Boolean
      {
         var tile:TileData = smMapController.getTileDataFromTileXY(tileX,tileY);
         return tile != null && this.cursorDoIsApplicable(tile);
      }
      
      protected function cursorIsApplicable(tileX:int, tileY:int, checkTileInMap:Boolean = true) : Boolean
      {
         var i:int = 0;
         var j:int = 0;
         var tile:TileData = null;
         var returnValue:Boolean;
         if((returnValue = this.cursorIsEnabled()) && checkTileInMap)
         {
            returnValue = this.isTileXYInMap(tileX,tileY);
         }
         if(returnValue)
         {
            if(this.mCursorAsAWhole)
            {
               i = 0;
               while(i < this.mCursorTilesHeight && returnValue)
               {
                  j = 0;
                  while(j < this.mCursorTilesWidth && returnValue)
                  {
                     returnValue = this.isCursorApplicableTileXY(tileX + j,tileY + i);
                     j++;
                  }
                  i++;
               }
            }
            else
            {
               returnValue = false;
            }
            for(i = 0; i < this.mCursorTilesHeight; )
            {
               for(j = 0; j < this.mCursorTilesWidth; )
               {
                  if(!this.mCursorAsAWhole)
                  {
                     tile = smMapController.getTileDataFromTileXY(tileX + j,tileY + i);
                     returnValue = this.cursorDoIsApplicable(tile);
                  }
                  this.cursorSetTile(j,i,returnValue);
                  j++;
               }
               i++;
            }
         }
         return returnValue;
      }
      
      protected function cursorDoIsApplicable(tile:TileData) : Boolean
      {
         return false;
      }
      
      protected function cursorCenterTile(tile:int, tileSize:int) : int
      {
         if(this.mCursorCenterTileIsEnabled && tileSize > 1)
         {
            tile -= Math.round(tileSize / 2) - 1;
         }
         return tile;
      }
      
      public function cursorSetCenterTileIsEnabled(value:Boolean) : void
      {
         this.mCursorCenterTileIsEnabled = value;
      }
      
      protected function cursorMove(x:int, y:int, tileX:int, tileY:int) : void
      {
         tileX = this.cursorCenterTile(tileX,this.mCursorTilesWidth);
         tileY = this.cursorCenterTile(tileY,this.mCursorTilesHeight);
         this.cursorIsApplicable(tileX,tileY);
         if(this.mCursorDrawTileIsEnabled)
         {
            smMapController.mMapViewPlanet.mapCursorSetTiles(this.mCursorMap,tileX,tileY);
         }
      }
      
      protected function cursorIsVisible(tileIndex:int) : Boolean
      {
         return false;
      }
      
      public function itemSelectedSetIsAllowed(itemSelectedIsAllowed:Boolean, actionMouseOverIsAllowed:Boolean = true) : void
      {
         this.mItemSelectedIsAllowed = itemSelectedIsAllowed;
         this.itemSelectedSetIsEnabled(itemSelectedIsAllowed);
         if(!itemSelectedIsAllowed)
         {
            this.itemSelectedEnd();
         }
         this.mItemSelectedActionMouseOverIsAllowed = actionMouseOverIsAllowed;
      }
      
      public function itemSelectedSetIsEnabled(value:Boolean) : void
      {
         this.mItemSelectedIsEnabled = this.mItemSelectedIsAllowed && value;
      }
      
      private function itemSelectedBegin() : void
      {
         this.mItemUnderCursorOld = null;
         this.mItemSelected = null;
         this.mItemSelectedAction = null;
         this.mItemSelectedTooltipTimer = 0;
         this.mCurrentETooltip = null;
      }
      
      private function itemSelectedEnd() : void
      {
         if(this.mItemSelected != null)
         {
            if(this.mItemSelectedAction != null)
            {
               this.itemSelectedActionUndoMouseOver(this.mItemSelected,false);
            }
            this.itemSelectedCloseTooltip();
            this.mItemSelected = null;
            this.mItemSelectedAction = null;
         }
      }
      
      private function itemSelectedCloseTooltip() : void
      {
         this.mItemSelectedTooltipTimer = 0;
         if(this.mCurrentETooltip)
         {
            ETooltipMng.getInstance().removeTooltip(this.mCurrentETooltip);
            this.mCurrentETooltip = null;
         }
      }
      
      protected function getTooltipTypeByActionUIId() : String
      {
         var returnValue:String = null;
         var action:ActionUI = InstanceMng.getWorldItemObjectController().actionsUIGetAction(this.mItemSelected.getActionUIId());
         return action.getTooltipType();
      }
      
      protected function getCoor() : DCCoordinate
      {
         if(this.mCoor == null)
         {
            this.mCoor = new DCCoordinate();
         }
         return this.mCoor;
      }
      
      protected function getViewMng() : ViewMngPlanet
      {
         if(this.mViewMngr == null)
         {
            this.mViewMngr = InstanceMng.getViewMngPlanet();
         }
         return this.mViewMngr;
      }
      
      public function setTooltipsEnabled(state:Boolean) : void
      {
         tooltipsEnabled = state;
         if(state == false)
         {
            this.itemSelectedEnd();
         }
      }
      
      public function isBlockingKeys() : Boolean
      {
         return false;
      }
      
      protected function applyRequest(tile:TileData) : void
      {
         var infoPack:Object = null;
         var onlyCash:Boolean = false;
         var enoughResources:Boolean = false;
         var guiController:GUIController = null;
         var o:Object = null;
         this.mApplyOnTile = tile;
         if(this.mTransaction != null)
         {
            if((infoPack = this.mTransaction.getTransInfoPackage()) == null)
            {
               infoPack = {};
            }
            infoPack.cmd = "EventServerTransOK";
            infoPack.sendResponseTo = this;
            this.mTransaction.setTransInfoPackage(infoPack);
            infoPack.transaction = this.mTransaction;
            this.mTransaction.computeAmountsLeftValues();
            onlyCash = this.mTransaction.checkIfOnlyCashTransaction();
            enoughResources = this.mTransaction.checkIfEnoughResources();
            if(onlyCash && this.mTransaction.mDifferenceCash.value < 0)
            {
               InstanceMng.getToolsMng().setTool(0);
               guiController = InstanceMng.getGUIController();
               o = guiController.createNotifyEvent("EventPopup","NotifyBuyGold",guiController,null,null,null,null,this.mTransaction);
               InstanceMng.getNotifyMng().addEvent(guiController,o,true);
            }
            else if(enoughResources)
            {
               InstanceMng.getApplication().transactionWait(this.mTransaction,this);
            }
         }
         else
         {
            this.applyDo();
         }
      }
      
      protected function applyDo() : void
      {
      }
      
      override public function notify(e:Object) : Boolean
      {
         var returnValue:Boolean = false;
         if(e != null)
         {
            switch(e.cmd)
            {
               case "EventServerTransOK":
                  this.applyDo();
                  returnValue = true;
                  break;
               case "EventServerTransCancel":
                  if(this.mTransaction != null)
                  {
                     this.mTransaction.reset();
                  }
            }
         }
         return returnValue;
      }
      
      public function whatToDropSetup(value:WhatToDrop) : void
      {
         this.mWhatToDrop = value;
      }
      
      public function destroySelection() : void
      {
      }
      
      public function isSelectionMade() : Boolean
      {
         return false;
      }
      
      public function getMultipleSelection() : Vector.<WorldItemObject>
      {
         return this.mSelection;
      }
      
      public function getLowestLevelWalls() : Vector.<WorldItemObject>
      {
         return null;
      }
      
      public function isItemAttached() : Boolean
      {
         return false;
      }
      
      public function getAttachedItem() : WorldItemObject
      {
         return null;
      }
      
      public function moveEnd() : void
      {
      }
      
      public function moveBuildingForBuffer(item:WorldItemObject) : void
      {
      }
      
      public function forceEnd() : void
      {
      }
   }
}
