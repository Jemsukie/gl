package com.dchoc.toolkit.core.component
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class DCComponentUI extends DCComponent
   {
       
      
      protected var mLocked:Boolean;
      
      protected var mUiEnabled:Boolean;
      
      protected var mParentRef:*;
      
      public function DCComponentUI()
      {
         super();
      }
      
      override protected function beginDo() : void
      {
         super.beginDo();
         this.uiEnable();
      }
      
      override protected function endDo() : void
      {
         super.endDo();
         this.uiDisable();
      }
      
      public function lock() : void
      {
         this.mLocked = true;
      }
      
      public function unlock(exception:Object = null) : void
      {
         this.mLocked = false;
      }
      
      public function isLocked() : Boolean
      {
         return this.mLocked;
      }
      
      public function uiEnable(forceAddListeners:Boolean = false) : void
      {
         if(this.mLocked)
         {
            return;
         }
         if(!this.mUiEnabled)
         {
            this.mUiEnabled = true;
            this.uiEnableDo(forceAddListeners);
         }
      }
      
      public function uiDisable(force:Boolean = false, forceRemoveListeners:Boolean = false) : void
      {
         if(this.mLocked)
         {
            return;
         }
         if(this.mUiEnabled || force)
         {
            this.mUiEnabled = false;
            this.uiDisableDo(forceRemoveListeners);
         }
         else
         {
            this.uiDisableErr();
         }
      }
      
      public function uiIsEnabled() : Boolean
      {
         return this.mUiEnabled && !this.mLocked;
      }
      
      public function uiIsDisabled() : Boolean
      {
         return !this.mUiEnabled || this.mLocked;
      }
      
      public function setParentRef(parentRef:*) : void
      {
         this.mParentRef = parentRef;
      }
      
      public function getParentRef() : *
      {
         return this.mParentRef;
      }
      
      protected function uiEnableDo(forceAddListeners:Boolean = false) : void
      {
      }
      
      protected function uiDisableDo(forceRemoveListeners:Boolean = false) : void
      {
      }
      
      protected function uiDisableErr() : void
      {
      }
      
      public function addMouseEvents() : void
      {
      }
      
      public function removeMouseEvents() : void
      {
      }
      
      public function onResize(stageWidth:int, stageHeight:int) : void
      {
      }
      
      public function onKeyUp(e:KeyboardEvent) : void
      {
      }
      
      public function onKeyDown(e:KeyboardEvent) : void
      {
      }
      
      public function onMouseDown(e:MouseEvent) : void
      {
      }
      
      public function onMouseDownCoors(x:int, y:int) : void
      {
      }
      
      public function onMouseUp(e:MouseEvent) : void
      {
      }
      
      public function onMouseUpCoors(x:int, y:int) : void
      {
      }
      
      public function onMouseMove(e:MouseEvent) : void
      {
      }
      
      public function onMouseMoveCoors(x:int, y:int) : void
      {
      }
      
      public function onMouseOut(e:MouseEvent) : void
      {
      }
      
      public function onMouseLeave(e:Event) : void
      {
      }
      
      public function onMouseClick(e:MouseEvent) : void
      {
      }
      
      public function onMouseOver(e:MouseEvent) : void
      {
      }
      
      public function onMouseWheel(e:MouseEvent) : void
      {
      }
      
      public function onMouseOverCoors(x:int, y:int) : void
      {
      }
      
      public function onZoomSet(value:Number) : void
      {
      }
      
      public function onZoomMove(off:Number) : void
      {
      }
   }
}
