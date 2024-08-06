package com.dchoc.game.controller.world.item.actionsUI
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   import esparragon.utils.EUtils;
   
   public class ActionUI
   {
       
      
      protected var mActionId:int;
      
      private var mCursorId:int;
      
      protected var mEventTarget:DCComponent;
      
      protected var mEventOnClick:Object;
      
      private var mTooltipType:String;
      
      private var mClickCheckTime:Boolean;
      
      private var mClickCheckRepairTime:Boolean;
      
      private var mTicksForNextMouseClick:int;
      
      public function ActionUI(actionId:int, cursorId:int = -1, eventTarget:DCComponent = null, eventOnClick:Object = null, tooltipType:String = null, clickCheckTime:Boolean = false, clickCheckRepairTime:Boolean = false)
      {
         super();
         this.mActionId = actionId;
         this.mCursorId = cursorId == -1 ? -1 : cursorId;
         this.mEventTarget = eventTarget;
         this.mEventOnClick = eventOnClick;
         this.mTooltipType = tooltipType;
         this.mClickCheckTime = clickCheckTime;
         this.mClickCheckRepairTime = clickCheckRepairTime;
         this.mTicksForNextMouseClick = 0;
      }
      
      public function unload() : void
      {
         this.mEventTarget = null;
         this.mEventOnClick = null;
         this.mTooltipType = null;
         this.mTicksForNextMouseClick = 0;
      }
      
      public function getActionId(item:WorldItemObject) : int
      {
         return this.mActionId;
      }
      
      private function getEventOnClick(item:WorldItemObject) : Object
      {
         return EUtils.cloneObject(this.mEventOnClick);
      }
      
      public function getCursorId(item:WorldItemObject) : int
      {
         return this.mCursorId;
      }
      
      protected function setCursor(item:WorldItemObject) : void
      {
         InstanceMng.getGUIControllerPlanet().cursorSetId(this.getCursorId(item));
      }
      
      public function getTooltipType() : String
      {
         return this.mTooltipType;
      }
      
      public function setTooltipType(value:String) : void
      {
         this.mTooltipType = value;
      }
      
      public function doMouseOver(item:WorldItemObject, tileIndex:int, completeMouseOver:Boolean = true) : void
      {
         this.setCursor(item);
         if(item != null && this.isAllowedOnItem(item))
         {
            if(completeMouseOver && this.mActionId != 25 && InstanceMng.getRole().actionUIIsAllowedOnItem(this.mActionId,item))
            {
               item.viewSetSelected(true);
               this.doDoMouseOver(item);
            }
         }
      }
      
      protected function doDoMouseOver(item:WorldItemObject) : void
      {
      }
      
      public function undoMouseOver(item:WorldItemObject) : void
      {
         if(item != null && this.isAllowedOnItem(item))
         {
            item.viewSetSelected(false);
         }
      }
      
      public function mouseClick(item:WorldItemObject, tileIndex:int) : Boolean
      {
         var eventOnClick:Object = null;
         var returnValue:* = false;
         if(this.mEventTarget != null && this.mTicksForNextMouseClick == 0)
         {
            this.mTicksForNextMouseClick = 3;
            eventOnClick = this.getEventOnClick(item);
            if((returnValue = eventOnClick != null) && this.mClickCheckTime && item != null)
            {
               returnValue = item.getTimeLeft(this.mClickCheckRepairTime) > 500;
            }
            if(returnValue)
            {
               eventOnClick.item = item;
               eventOnClick.tileIndex = tileIndex;
               InstanceMng.getNotifyMng().addEvent(this.mEventTarget,eventOnClick,true);
            }
         }
         return returnValue;
      }
      
      protected function isAllowedOnItem(item:WorldItemObject) : Boolean
      {
         return true;
      }
      
      public function logicUpdate(dt:int) : void
      {
         if(this.mTicksForNextMouseClick > 0)
         {
            this.mTicksForNextMouseClick--;
         }
      }
   }
}
