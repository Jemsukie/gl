package com.dchoc.toolkit.view.gui.popups
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DCPopup extends DCContent implements DCIPopup
   {
      
      public static const EVENT_CLOSE:String = "EventClose";
      
      public static const EVENT_ACCEPT:String = "EventAccept";
       
      
      protected const ZOOM_SPEED:Number = 0.1;
      
      public var mBody:DCContent;
      
      public var mEvent:Object;
      
      public var mPopupType:String;
      
      protected var mMinScale:Number;
      
      protected var mIsBeingShown:Boolean = false;
      
      protected var mSoundAttached:String;
      
      protected var mIsStackable:Boolean;
      
      protected var mShowEffect:int;
      
      protected var mCloseEffect:int;
      
      protected var mVerticalOffset:int = 0;
      
      protected var mBkgCurrentSku:String = "normal";
      
      protected var mBkgRequestedSku:String = "normal";
      
      private var mAccept:Boolean;
      
      private var mShowAnim:Boolean;
      
      private var mShowDarkBackground:Boolean;
      
      public function DCPopup(box:DisplayObjectContainer = null)
      {
         super(box);
         this.mMinScale = 0.75;
      }
      
      public function poolReturn() : void
      {
      }
      
      public function destroyESprites() : void
      {
      }
      
      public function configureEffects(show:int, close:int) : void
      {
         this.mShowEffect = show;
         this.mCloseEffect = close;
      }
      
      public function getSkinSku() : String
      {
         return null;
      }
      
      public function setPopupType(popupType:String) : void
      {
         this.mPopupType = popupType;
      }
      
      public function getPopupType() : String
      {
         return this.mPopupType;
      }
      
      public function isPopupBeingShown() : Boolean
      {
         return this.mIsBeingShown;
      }
      
      public function setIsBeingShown(value:Boolean) : void
      {
         this.mIsBeingShown = value;
      }
      
      public function setIsStackable(value:Boolean) : void
      {
         this.mIsStackable = value;
      }
      
      public function isStackable() : Boolean
      {
         return this.mIsStackable;
      }
      
      public function setShowAnim(value:Boolean) : void
      {
         this.mShowAnim = value;
      }
      
      public function getShowAnim() : Boolean
      {
         return this.mShowAnim;
      }
      
      public function setShowDarkBackground(value:Boolean) : void
      {
         this.mShowDarkBackground = value;
      }
      
      public function getShowDarkBackground() : Boolean
      {
         return this.mShowDarkBackground;
      }
      
      protected function startShowAnim() : void
      {
         this.showEffect();
      }
      
      public function startCloseEffect() : void
      {
         this.closeEffect();
      }
      
      override public function resize() : void
      {
         var boxTop:int = 0;
         var boxBottom:int = 0;
         var stageW:int = DCInstanceMng.getInstance().getApplication().stageGetWidth();
         var stageH:int = DCInstanceMng.getInstance().getApplication().stageGetHeight();
         mBox.x = stageW / 2;
         mBox.y = stageH / 2;
         var finalOffsetY:int = 0;
         if(this.mVerticalOffset != 0)
         {
            boxTop = mBox.y - mBox.height / 2;
            boxBottom = mBox.y + mBox.height / 2;
            if(mBox.y - mBox.height / 2 > this.mVerticalOffset)
            {
               finalOffsetY = 0;
            }
            else
            {
               finalOffsetY = stageH - boxBottom;
            }
            mBox.y += finalOffsetY;
         }
      }
      
      public function show(showAnim:Boolean = true) : void
      {
         this.mAccept = false;
         if(showAnim)
         {
            this.startShowAnim();
         }
         if(mIsEnabled && mLocked == false)
         {
            this.addMouseEvents();
         }
         this.setIsBeingShown(true);
      }
      
      protected function showEffect() : void
      {
         mBox.scaleX = this.mMinScale;
         mBox.scaleY = this.mMinScale;
         mBox.addEventListener("enterFrame",this.zoomIn);
      }
      
      protected function closeEffect() : void
      {
      }
      
      protected function zoomIn(e:Event) : void
      {
         if(mBox.scaleX < 1)
         {
            mBox.scaleX += 0.1;
            mBox.scaleY += 0.1;
            if(mBox.scaleX >= 1)
            {
               mBox.scaleX = 1;
               mBox.scaleY = 1;
               mBox.removeEventListener("enterFrame",this.zoomIn);
            }
         }
      }
      
      public function close() : void
      {
         this.mShowEffect = -1;
         this.mCloseEffect = -1;
         this.removeMouseEvents();
         uiDisable();
         this.setIsBeingShown(false);
      }
      
      override public function addMouseEvents() : void
      {
         mBox.addEventListener("click",this.onMouseClick,false,0,true);
         mBox.addEventListener("rollOver",this.onMouseOver,false,0,true);
         mBox.addEventListener("rollOut",this.onMouseOut,false,0,true);
         mBox.addEventListener("mouseDown",this.onMouseDown,false,0,true);
         mBox.addEventListener("mouseUp",this.onMouseUp,false,0,true);
         mBox.addEventListener("mouseMove",onMouseMove,false,0,true);
      }
      
      override public function removeMouseEvents() : void
      {
         mBox.removeEventListener("click",this.onMouseClick);
         mBox.removeEventListener("rollOver",this.onMouseOver);
         mBox.removeEventListener("rollOut",this.onMouseOut);
         mBox.removeEventListener("mouseDown",this.onMouseDown);
         mBox.removeEventListener("mouseUp",this.onMouseUp);
         mBox.removeEventListener("mouseMove",onMouseMove);
      }
      
      override public function onMouseClick(e:MouseEvent) : void
      {
      }
      
      override public function onMouseOver(e:MouseEvent) : void
      {
         uiEnable();
      }
      
      override public function onMouseOut(e:MouseEvent) : void
      {
         uiDisable();
      }
      
      override public function onMouseDown(e:MouseEvent) : void
      {
      }
      
      override public function onMouseUp(e:MouseEvent) : void
      {
      }
      
      public function notifyPopupMngClose(e:Object) : void
      {
         InstanceMng.getPopupMng().closePopup(this);
      }
      
      public function lockPopup(componentId:String = null) : void
      {
      }
      
      public function unlockPopup() : void
      {
      }
      
      public function setSoundAttached(sound:String) : void
      {
         this.mSoundAttached = sound;
      }
      
      public function getSoundAttached() : String
      {
         return this.mSoundAttached;
      }
      
      public function getBkgRequestedSku() : String
      {
         return this.mBkgRequestedSku;
      }
      
      public function setBkgRequestedSku(value:String) : void
      {
         this.mBkgRequestedSku = value;
      }
      
      public function getBkgCurrentSku() : String
      {
         return this.mBkgCurrentSku;
      }
      
      public function setBkgCurrentSku(value:String) : void
      {
         this.mBkgCurrentSku = value;
      }
      
      public function getEvent() : Object
      {
         return this.mEvent;
      }
      
      public function setEvent(e:Object) : void
      {
         this.mEvent = e;
      }
      
      public function refresh() : void
      {
      }
   }
}
