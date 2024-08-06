package com.dchoc.game.model.unit.components.view
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.UnitComponent;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import flash.display.DisplayObject;
   import flash.geom.Vector3D;
   
   public class UnitComponentView extends UnitComponent
   {
      
      protected static const HEADING_COMPONENT_KEY_DEFAULT:int = 0;
      
      private static const FADE_MODE_NONE:int = 0;
      
      private static const FADE_MODE_IN:int = 1;
      
      private static const FADE_MODE_OUT:int = 2;
      
      private static const FADE_DURATION_MS:int = 300;
       
      
      protected var mHeadingComponentKey:int;
      
      protected var mCurrentAnimationId:String;
      
      private var mFadeMode:int;
      
      private var mFadeEventOver:String;
      
      private var mFadeCurrentTime:int;
      
      public function UnitComponentView(unit:MyUnit, headingComponentKey:int = -1)
      {
         super(unit);
         this.mHeadingComponentKey = headingComponentKey == -1 ? 0 : headingComponentKey;
      }
      
      override public function reset(u:MyUnit) : void
      {
         super.reset(u);
         this.fadeEnd();
      }
      
      override protected function logicUpdateDo(dt:int, u:MyUnit) : void
      {
         if(this.mFadeMode != 0)
         {
            this.fadeLogicUpdate(dt);
         }
         var heading:Vector3D = mUnit.getHeading(this.mHeadingComponentKey);
         this.render(dt,heading);
      }
      
      protected function render(dt:int, heading:Vector3D) : void
      {
      }
      
      public function addEventListener(type:String, f:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         var d:DisplayObject;
         if((d = this.getDisplayObject()) != null)
         {
            d.addEventListener(type,f,useCapture,priority,useWeakReference);
         }
      }
      
      public function removeEventListener(type:String, f:Function, useCapture:Boolean = false) : void
      {
         var d:DisplayObject;
         if((d = this.getDisplayObject()) != null)
         {
            d.removeEventListener(type,f,useCapture);
         }
      }
      
      public function getDisplayObject() : DisplayObject
      {
         return null;
      }
      
      public function getDCDisplayObject() : DCDisplayObject
      {
         return null;
      }
      
      public function isInScreen() : Boolean
      {
         return true;
      }
      
      public function setAlpha(value:Number) : void
      {
         var d:DisplayObject = this.getDisplayObject();
         if(d != null)
         {
            d.alpha = value;
         }
      }
      
      public function setVisible(value:Boolean) : void
      {
         var d:DisplayObject = this.getDisplayObject();
         if(d != null)
         {
            d.visible = value;
         }
      }
      
      public function getVisible() : Boolean
      {
         var d:DisplayObject = this.getDisplayObject();
         return d != null && d.visible;
      }
      
      public function toggleVisibility() : void
      {
         this.setVisible(!this.getVisible());
      }
      
      public function setAnimationId(anim:String, frame:int = -1, play:Boolean = true, setAnim:Boolean = false, setCustomRenderData:Boolean = false, loop:Boolean = true) : void
      {
      }
      
      public function setRenderData(sku:String, className:String) : void
      {
      }
      
      public function setFrameRate(time:int) : void
      {
      }
      
      public function setLoopMode(value:Boolean) : void
      {
      }
      
      public function getCurrentRenderData() : DCBitmapMovieClip
      {
         return null;
      }
      
      public function isPlayingAnimId(anim:String) : Boolean
      {
         return this.mCurrentAnimationId == anim;
      }
      
      public function getCurrentAnimId() : String
      {
         return this.mCurrentAnimationId;
      }
      
      public function isPlayingAnyDeadAnim() : Boolean
      {
         return this.mCurrentAnimationId.indexOf("death") > -1;
      }
      
      public function stop() : void
      {
      }
      
      public function resume() : void
      {
      }
      
      private function fadeStart(mode:int, event:String = null) : void
      {
         this.mFadeMode = mode;
         this.mFadeCurrentTime = 300;
         this.mFadeEventOver = event;
      }
      
      private function fadeEnd() : void
      {
         this.mFadeEventOver = null;
         this.setAlpha(this.mFadeMode == 2 ? 0 : 1);
         this.fadeStart(0);
      }
      
      public function fadeReset() : void
      {
         this.fadeEnd();
         this.setAlpha(1);
      }
      
      public function fadeIn(event:String) : void
      {
         this.fadeStart(1,event);
      }
      
      public function fadeOut(event:String) : void
      {
         this.fadeStart(2,event);
      }
      
      private function fadeLogicUpdate(dt:int) : void
      {
         var alpha:Number = NaN;
         var tSoFar:int = 0;
         this.mFadeCurrentTime -= dt;
         if(this.mFadeCurrentTime < 0)
         {
            if(this.mFadeEventOver != null)
            {
               mUnit.sendEvent(this.mFadeEventOver);
            }
            this.fadeEnd();
         }
         else if(this.mFadeMode == 2)
         {
            this.setAlpha(this.mFadeCurrentTime / 300);
         }
         else
         {
            tSoFar = 300 - this.mFadeCurrentTime;
            this.setAlpha(tSoFar / 300);
         }
      }
      
      public function getFrameWidth() : int
      {
         return 0;
      }
      
      public function getFrameHeight() : int
      {
         return 0;
      }
      
      public function getBoundingBox() : DCBox
      {
         return null;
      }
      
      public function getSelected() : Boolean
      {
         return false;
      }
      
      public function setSelected(value:Boolean) : void
      {
      }
      
      public function setAreParticlesEnabled(value:Boolean) : void
      {
      }
   }
}
