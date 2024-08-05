package com.dchoc.game.controller.tools
{
   import com.dchoc.game.controller.gui.GUIController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.ItemsMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.umbrella.UmbrellaMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.map.SpyCapsule;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class ToolSpy extends Tool
   {
      
      private static const SIZE_TILES_WIDTH:int = 26;
      
      private static const SIZE_TILES_HEIGHT:int = 26;
      
      private static const MODE_NONE:int = -1;
      
      private static const MODE_DROP_CAPSULE:int = 0;
      
      private static const MODE_SPY_BUILDING:int = 1;
      
      private static const MODE_CAPSULE_NOT_DROPPABLE:int = 2;
       
      
      private var mRadius:Number;
      
      private var mRadiusSqr:Number;
      
      private var mMode:int;
      
      private var mUiMouseXLast:int;
      
      private var mUiMouseYLast:int;
      
      private var mUiMouseTileXLast:int;
      
      private var mUiMouseTileYLast:int;
      
      private var mCapsules:Vector.<SpyCapsule>;
      
      public var dropDownHovering:Boolean = false;
      
      public var buttonHovering:Boolean = false;
      
      public function ToolSpy(id:int)
      {
         super(id);
         this.mRadius = 286;
         this.mRadiusSqr = this.mRadius * this.mRadius;
      }
      
      override protected function unloadDo() : void
      {
         super.unloadDo();
         this.capsulesUnload();
      }
      
      override protected function unbuildDo() : void
      {
         super.unbuildDo();
         this.capsulesUnbuild();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         super.logicUpdateDo(dt);
      }
      
      override protected function getTooltipTypeByActionUIId() : String
      {
         return GUIController.getTooltipWIOSpyByItem(mItemSelected);
      }
      
      override protected function itemSelectedActionDoMouseOver(item:WorldItemObject, tileIndex:int, actionCompleteMouseOver:Boolean) : void
      {
         item.spySetIsSpiableSelected(true);
      }
      
      override protected function itemSelectedActionUndoMouseOver(item:WorldItemObject, changeCursor:Boolean) : void
      {
         item.spySetIsSpiableSelected(false);
      }
      
      private function modeChangeCurrentMode(newMode:int, spyTypeToApply:int = -1) : void
      {
         if(!dropDownHovering && !buttonHovering)
         {
            if(newMode != this.mMode)
            {
               switch(this.mMode)
               {
                  case 0:
                     this.dropCapsuleEnable(false,spyTypeToApply);
                     break;
                  case 1:
                     this.spySetEnable(false);
               }
               this.mMode = newMode;
               switch(this.mMode)
               {
                  case 0:
                     this.dropCapsuleEnable(true,spyTypeToApply);
                     break;
                  case 1:
                     this.spySetEnable(true);
               }
            }
         }
      }
      
      private function modeGetModeFromPosition(tileX:int, tileY:int) : int
      {
         var returnValue:int = 2;
         var isInside:Boolean;
         if(isInside = isTileXYInMap(tileX,tileY))
         {
            if(this.capsulesIsInsideAnyCapsuleGetType(tileX,tileY) > -1)
            {
               returnValue = 1;
            }
            else
            {
               returnValue = 0;
            }
         }
         return returnValue;
      }
      
      private function modeMouseMoveCoors(x:int, y:int, tileX:int, tileY:int, undoPrevious:Boolean, doCurrent:Boolean) : void
      {
         switch(this.mMode)
         {
            case 0:
               this.dropCapsuleMouseMoveCoors(x,y,tileX,tileY,undoPrevious,doCurrent);
         }
      }
      
      private function modeMouseUpCoors(type:int, x:int, y:int, tileX:int, tileY:int) : void
      {
         switch(this.mMode)
         {
            case 0:
               this.dropCapsuleMouseUpCoors(type,x,y,tileX,tileY);
         }
      }
      
      public function dropCapsuleEnable(value:Boolean, spyTypeToApply:int = -1) : void
      {
         if(value)
         {
            itemSelectedSetIsAllowed(false);
         }
         else
         {
            this.capsuleApplyEffect(this.mUiMouseXLast,this.mUiMouseYLast,this.mUiMouseTileXLast,this.mUiMouseTileYLast,this.dropCapsuleSetWouldBeAffected,false,false,false,spyTypeToApply);
            InstanceMng.getMapViewPlanet().spyAreaSetIsVisible(false);
         }
      }
      
      private function dropCapsuleMouseMoveCoors(x:int, y:int, tileX:int, tileY:int, undoPrevious:Boolean, doCurrent:Boolean) : void
      {
         var coor:DCCoordinate = null;
         if(undoPrevious)
         {
         }
         if(doCurrent)
         {
            (coor = getCoor()).x = tileX;
            coor.y = tileY;
            coor.z = 0;
            InstanceMng.getViewMngPlanet().tileXYToWorldViewPos(coor);
            InstanceMng.getMapViewPlanet().spyAreaMove(coor.x,coor.y);
         }
      }
      
      private function dropCapsuleSetWouldBeAffected(item:WorldItemObject, args:Object) : void
      {
         var enabled:Boolean = Boolean(args[3]);
         item.spySetWouldBeAffected(enabled);
      }
      
      private function dropCapsuleMouseUpCoors(type:int, x:int, y:int, tileX:int, tileY:int) : void
      {
         var viewMng:ViewMngPlanet = null;
         var coor:DCCoordinate = null;
         var viewPosX:int = 0;
         var viewPosY:int = 0;
         var o:Object = null;
         var itemsMng:ItemsMng;
         if((itemsMng = InstanceMng.getItemsMng()).getSpyCapsules(type) > 0)
         {
            viewMng = InstanceMng.getViewMngPlanet();
            this.capsuleApplyEffect(x,y,tileX,tileY,this.dropCapsuleSetSpyIsEnabled,true,false,true);
            (coor = getCoor()).x = tileX;
            coor.y = tileY;
            viewMng.tileXYToWorldViewPos(coor,true);
            viewPosX = coor.x;
            viewPosY = coor.y;
            coor.x = tileX;
            coor.y = tileY;
            viewMng.tileXYToWorldPos(coor,true);
            this.capsulesAddCapsule(type,tileX,tileY,coor.x,coor.y,viewPosX,viewPosY);
            this.modeChangeCurrentMode(this.modeGetModeFromPosition(tileX,tileY));
            itemsMng.addItemAmount(itemsMng.getSpyCapsuleSkuFromSpyType(type),-1,true,true);
         }
         else
         {
            o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NOTIFY_SHOW_SPY_CAPSULES_SHOP");
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o,true);
         }
      }
      
      private function dropCapsuleSetSpyIsEnabled(item:WorldItemObject, args:Object) : void
      {
         var enabled:Boolean = Boolean(args[3]);
         item.spySetIsSpiable(enabled);
         if(enabled)
         {
            item.spyApplySpyStateType(InstanceMng.getToolsMng().getCurrentSpyType());
         }
      }
      
      public function spySetEnable(value:Boolean) : void
      {
         var mouseX:int = 0;
         var cursorId:int = value ? 22 : -1;
         InstanceMng.getUIFacade().getCursorFacade().setCursorId(cursorId);
         if(value)
         {
            itemSelectedSetIsAllowed(true,false);
            mouseX = this.mUiMouseXLast;
            this.mUiMouseXLast = -1;
            this.uiMouseMoveCoors(mouseX,this.mUiMouseYLast,this.mUiMouseTileXLast,this.mUiMouseTileYLast);
         }
      }
      
      override protected function uiEnableDo(forceAddListeners:Boolean = false) : void
      {
         super.uiEnableDo(forceAddListeners);
         this.mMode = -1;
         this.mUiMouseXLast = -1;
         this.mUiMouseYLast = -1;
      }
      
      override protected function uiDisableDo(forceRemoveListeners:Boolean = false) : void
      {
         super.uiDisableDo(forceRemoveListeners);
         this.modeChangeCurrentMode(-1);
      }
      
      override public function uiMouseMoveCoors(x:int, y:int, tileX:int, tileY:int) : void
      {
         if(x == this.mUiMouseXLast && y == this.mUiMouseYLast)
         {
            return;
         }
         var mode:int = 0;
         super.uiMouseMoveCoors(x,y,tileX,tileY);
         var spyTypeAlreadyOnThatTile:int;
         if((spyTypeAlreadyOnThatTile = this.capsulesIsInsideAnyCapsuleGetType(tileX,tileY)) > -1 || mItemSelected != null && mItemSelected.spyGetIsSpiable())
         {
            mode = 1;
         }
         else if(isTileXYInMap(tileX,tileY))
         {
            mode = 0;
         }
         else
         {
            mode = 2;
         }
         var hasChangedMode:*;
         if(hasChangedMode = mode != this.mMode)
         {
            this.modeChangeCurrentMode(mode,spyTypeAlreadyOnThatTile);
         }
         this.modeMouseMoveCoors(x,y,tileX,tileY,!hasChangedMode,true);
         this.mUiMouseXLast = x;
         this.mUiMouseYLast = y;
         this.mUiMouseTileXLast = tileX;
         this.mUiMouseTileYLast = tileY;
      }
      
      override public function uiMouseUpCoors(x:int, y:int, tileX:int, tileY:int) : void
      {
         this.modeMouseUpCoors(InstanceMng.getToolsMng().getCurrentSpyType(),x,y,tileX,tileY);
      }
      
      private function capsulesUnload() : void
      {
         this.mCapsules = null;
      }
      
      private function capsulesUnbuild() : void
      {
         var capsule:SpyCapsule = null;
         if(this.mCapsules != null)
         {
            while(this.mCapsules.length > 0)
            {
               capsule = this.mCapsules.shift();
               capsule.unload();
            }
         }
      }
      
      private function capsulesAddCapsule(spyType:int, tileX:int, tileY:int, worldPosX:Number, worldPosY:Number, viewPosX:int, viewPosY:int) : void
      {
         if(this.mCapsules == null)
         {
            this.mCapsules = new Vector.<SpyCapsule>(0);
         }
         var radius:Number = InstanceMng.getToolsMng().getCurrentSpyType() == 1 ? this.mRadius * 2 : this.mRadius;
         this.mCapsules.push(new SpyCapsule(spyType,tileX,tileY,worldPosX,worldPosY,viewPosX,viewPosY,radius));
      }
      
      public function removeAllCapsulesFromStage() : void
      {
         for each(var capsule in this.mCapsules)
         {
            capsule.removeFromStage();
         }
         var items:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetAllItems();
         for each(var item in items)
         {
            item.spySetIsSpiable(false);
            item.spySetSpyStateType(-1);
         }
      }
      
      private function capsulesIsInsideAnyCapsuleGetType(tileX:int, tileY:int) : int
      {
         var returnValue:int = -1;
         if(this.mCapsules == null)
         {
            return returnValue;
         }
         var coor:DCCoordinate = getCoor();
         var capsule:SpyCapsule = null;
         coor.x = tileX;
         coor.y = tileY;
         coor.z = 0;
         InstanceMng.getViewMngPlanet().tileXYToWorldPos(coor,true);
         for each(capsule in this.mCapsules)
         {
            if(capsule.isWorldPositionInsideArea(coor.x,coor.y))
            {
               returnValue = Math.max(returnValue,capsule.getType());
               capsule.setWillBeEnabled(true);
            }
            else if(capsule.getIsEnabled())
            {
               this.capsuleSetBuildingsSelection(capsule,false);
               capsule.setIsEnabled(false);
            }
         }
         for each(capsule in this.mCapsules)
         {
            if(capsule.getWillBeEnabled())
            {
               this.capsuleSetBuildingsSelection(capsule,true);
               capsule.setIsEnabled(true);
            }
         }
         return returnValue;
      }
      
      public function capsulesGetDroppedAmount() : int
      {
         return this.mCapsules == null ? 0 : int(this.mCapsules.length);
      }
      
      private function capsuleSetBuildingsSelection(capsule:SpyCapsule, value:Boolean) : void
      {
         this.capsuleApplyEffect(capsule.getWorldPosX(),capsule.getWorldPosY(),capsule.getTileX(),capsule.getTileY(),this.capsuleSetBuildingSelection,value,true,false,capsule.getType());
      }
      
      private function capsuleSetBuildingSelection(item:WorldItemObject, args:Object) : void
      {
         var enabled:Boolean = Boolean(args[3]);
         item.spySetIsSpiableSelectedArea(enabled);
      }
      
      private function capsuleApplyEffect(x:int, y:int, tileX:int, tileY:int, func:Function, enabled:Boolean, forceCheck:Boolean = false, checkUmbrella:Boolean = false, spyTypeToApply:int = -1) : void
      {
         var umbrellaMng:UmbrellaMng = null;
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         var coor:DCCoordinate;
         (coor = getCoor()).x = tileX;
         coor.y = tileY;
         coor.z = 0;
         viewMng.tileXYToWorldPos(coor,true);
         var worldPosX:Number = coor.x;
         var worldPosY:Number = coor.y;
         var spyType:* = InstanceMng.getToolsMng().getCurrentSpyType();
         if(spyTypeToApply > -1)
         {
            spyType = spyTypeToApply;
         }
         var width:int = 26;
         var height:int = 26;
         var radius:Number = this.mRadius;
         if(spyType == 1)
         {
            width *= 2;
            height *= 2;
            radius *= 2;
         }
         smMapController.mMapModel.tilesDataApplyFunc(tileX,tileY,width,height,true,this.capsuleApplyEffectOnTile,func,worldPosX,worldPosY,enabled,forceCheck,radius);
         if(Config.useUmbrella() && checkUmbrella)
         {
            if((umbrellaMng = InstanceMng.getUmbrellaMng()).isAreaProtected(worldPosX,worldPosY,radius))
            {
               umbrellaMng.deploySetIsAllowedToBeShown(true);
            }
         }
      }
      
      private function capsuleApplyEffectOnTile(tileData:TileData, args:Object) : void
      {
         var capsuleWorldPosX:Number = NaN;
         var capsuleWorldPosY:Number = NaN;
         var coor:DCCoordinate = null;
         var right:Number = NaN;
         var down:Number = NaN;
         if(tileData == null || args == null)
         {
            return;
         }
         var item:WorldItemObject;
         if((item = tileData.mBaseItem) == null)
         {
            return;
         }
         var func:Function = null;
         var radius:Number = this.mRadius;
         var forceCheck:Boolean = Boolean(args[4]);
         if(!item.spyGetIsSpiable() || forceCheck)
         {
            capsuleWorldPosX = Number(args[1]);
            capsuleWorldPosY = Number(args[2]);
            radius = Number(args[5]);
            coor = getCoor();
            item.getBoundingBoxCornerDownRightWorldPos(coor);
            right = coor.x;
            down = coor.y;
            item.getBoundingBoxCornerUpLeftWorldPos(coor);
            if(DCMath.intersectCircleRectangle(capsuleWorldPosX,capsuleWorldPosY,radius,coor.y,coor.x,down,right))
            {
               func = args[0];
               func(item,args);
            }
         }
      }
   }
}
