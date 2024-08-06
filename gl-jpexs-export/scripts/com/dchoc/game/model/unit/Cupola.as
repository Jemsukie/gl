package com.dchoc.game.model.unit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.gskinner.geom.ColorMatrix;
   import esparragon.display.EImage;
   import flash.filters.ColorMatrixFilter;
   
   public class Cupola
   {
      
      public static const STATE_NONE:int = 0;
      
      public static const STATE_OPENING:int = 1;
      
      public static const STATE_EFFECT_COLOR:int = 2;
      
      public static const STATE_OPEN:int = 3;
      
      public static const STATE_CLOSING:int = 4;
      
      private static const TIME_OPENING:int = 1500;
      
      public static const TIME_CLOSING:int = 1500;
      
      public static const EVENT_CHANGE_STATE:String = "cupolaChangeState";
      
      private static const EFFECT_TIME_TOTAL:int = 800;
      
      private static const EFFECT_TIME_FIRST_PART:int = 200;
      
      private static const EFFECT_TIME_SECOND_PART:int = 600;
      
      private static const BRIGHTNESS_STEPS_AMOUNT:int = 10;
      
      private static var smBrightnessFilters:Vector.<Array>;
       
      
      private var mAssetSku:String;
      
      private var mAssetDO:EImage;
      
      private var mRadius:int;
      
      private var mScaleOpenX:Number;
      
      private var mScaleOpenY:Number;
      
      private var mScaleCurrentX:Number;
      
      private var mScaleCurrentY:Number;
      
      private var mViewPosX:int;
      
      private var mViewPosY:int;
      
      private var mState:int;
      
      private var mStateRequired:int;
      
      private var mNeedsToAddToStage:Boolean;
      
      private var mTime:int;
      
      private var mTimeTarget:int;
      
      private var mNotifier:DCComponent;
      
      private var vf:Number;
      
      private var a:Number;
      
      public function Cupola()
      {
         super();
         this.reset();
      }
      
      private static function brightnessGetFilter(brightness:Number) : Array
      {
         var colorMatrix:ColorMatrix = null;
         var colorFilter:ColorMatrixFilter = null;
         if(smBrightnessFilters == null)
         {
            smBrightnessFilters = new Vector.<Array>(10);
         }
         var index:int;
         if((index = brightness * 10 / 100 - 1) < 0)
         {
            index = 0;
         }
         else if(index >= 10)
         {
            index = 10 - 1;
         }
         if(smBrightnessFilters[index] == null)
         {
            colorMatrix = new ColorMatrix();
            colorMatrix.adjustBrightness(brightness);
            colorFilter = new ColorMatrixFilter(colorMatrix.toArray());
            smBrightnessFilters[index] = [colorFilter];
         }
         return smBrightnessFilters[index];
      }
      
      public function setup(assetSku:String, radius:int, height:int, viewPosX:int, viewPosY:int, notifier:DCComponent = null) : void
      {
         if(this.mAssetSku != assetSku)
         {
            this.destroy();
            this.mAssetSku = assetSku;
         }
         this.mRadius = radius;
         this.mScaleOpenX = this.mRadius / height;
         this.mScaleOpenY = this.mScaleOpenX;
         this.setViewPosition(viewPosX,viewPosY);
         if(notifier != null)
         {
            this.mNotifier = notifier;
         }
         this.reset();
      }
      
      public function reset() : void
      {
         this.setState(0);
      }
      
      public function destroy() : void
      {
         this.setState(0);
         if(this.mAssetDO != null)
         {
            this.mAssetDO.destroy();
         }
         this.mAssetSku = null;
      }
      
      public function setViewPosition(viewPosX:int, viewPosY:int) : void
      {
         this.mViewPosX = viewPosX;
         this.mViewPosY = viewPosY;
         this.updateViewPosition();
      }
      
      public function setState(state:int) : void
      {
         var oldState:int = this.mState;
         this.mState = state;
         if(this.mState != 0)
         {
            if(this.mAssetDO == null)
            {
               this.mAssetDO = InstanceMng.getViewFactory().getEImage(this.mAssetSku,null,false);
            }
            if(this.mAssetDO.parent == null)
            {
               this.mNeedsToAddToStage = true;
            }
         }
         else
         {
            if(this.mAssetDO != null && this.mAssetDO.parent != null)
            {
               InstanceMng.getViewMngPlanet().cupolaRemoveFromStage(this.mAssetDO);
            }
            this.mNeedsToAddToStage = false;
         }
         if(this.mAssetDO != null)
         {
            this.mAssetDO.resetColor();
         }
         switch(this.mState - 1)
         {
            case 0:
               this.mTimeTarget -= 800;
               this.mTime = this.mTimeTarget;
               this.mScaleCurrentX = 0;
               this.mScaleCurrentY = 0;
               break;
            case 1:
               this.mTime = 800;
               break;
            case 2:
               this.mScaleCurrentX = this.mScaleOpenX;
               this.mScaleCurrentY = this.mScaleOpenY;
               break;
            case 3:
               this.mTimeTarget -= 800;
               this.mTime = this.mTimeTarget;
               this.mAssetDO.applySkinProp(null,"HUE_red");
         }
         if(this.mNotifier != null)
         {
            this.mNotifier.notify({
               "cmd":"cupolaChangeState",
               "cupola":this,
               "state":this.mState,
               "oldState":oldState
            });
         }
      }
      
      public function playOpening(time:int = 1500) : void
      {
         this.mTimeTarget = time;
         this.setState(1);
      }
      
      public function playOpen() : void
      {
         this.setState(3);
      }
      
      public function playClosing(time:int = 1500) : void
      {
         this.mTimeTarget = time;
         this.mStateRequired = 4;
         this.setState(2);
      }
      
      public function isAvailable() : Boolean
      {
         return this.mState == 0;
      }
      
      public function isOpen() : Boolean
      {
         return this.mState == 3;
      }
      
      public function logicUpdate(dt:int) : void
      {
         var timeSpent:int = 0;
         var brightness:Number = NaN;
         this.mTime -= dt;
         if(this.mNeedsToAddToStage)
         {
            if(this.mAssetDO != null)
            {
               if(this.mAssetDO.getTexture() != null)
               {
                  this.updateViewPosition();
                  InstanceMng.getViewMngPlanet().cupolaAddToStage(this.mAssetDO);
               }
            }
         }
         switch(this.mState - 1)
         {
            case 0:
               this.scaleLogicUpdate();
               this.updateViewPosition();
               if(this.mTime <= 0)
               {
                  this.mStateRequired = 3;
                  this.setState(2);
               }
               break;
            case 1:
               timeSpent = 800 - this.mTime;
               brightness = timeSpent * timeSpent;
               if(timeSpent <= 200)
               {
                  this.a = 0.00005;
                  this.vf = this.a * 200;
                  brightness = this.vf * timeSpent / 2;
               }
               else
               {
                  this.a = 0.000005555555555555556;
                  this.vf = this.a * 600;
                  timeSpent -= 200;
                  brightness = this.vf * timeSpent / 2;
                  brightness = 1 - brightness;
               }
               brightness *= 100;
               if(brightness < 0)
               {
                  brightness = 0;
               }
               else if(brightness > 100)
               {
                  brightness = 100;
               }
               this.mAssetDO.setFilters(brightnessGetFilter(brightness));
               if(this.mTime <= 0)
               {
                  this.setState(this.mStateRequired);
               }
               break;
            case 3:
               this.scaleLogicUpdate();
               this.mScaleCurrentX = this.mScaleOpenX - this.mScaleCurrentX;
               this.mScaleCurrentY = this.mScaleOpenY - this.mScaleCurrentY;
               this.updateViewPosition();
               if(this.mTime <= 0)
               {
                  this.setState(0);
                  break;
               }
         }
      }
      
      private function updateViewPosition() : void
      {
         if(this.mAssetDO != null)
         {
            this.mAssetDO.scaleX = this.mScaleCurrentX;
            this.mAssetDO.scaleY = this.mScaleCurrentY;
            this.mAssetDO.x = this.mViewPosX - (this.mAssetDO.width >> 1);
            this.mAssetDO.y = this.mViewPosY - (this.mAssetDO.height >> 1);
         }
      }
      
      private function scaleLogicUpdate() : void
      {
         if(this.mTime < 0)
         {
            this.mTime = 0;
         }
         if(this.mAssetDO != null)
         {
            if(this.mScaleCurrentX != this.mScaleOpenX)
            {
               if(this.mTime <= 0)
               {
                  this.mScaleCurrentX = this.mScaleOpenX;
               }
               else
               {
                  this.mScaleCurrentX = this.mScaleOpenX * (this.mTimeTarget - this.mTime) / this.mTimeTarget;
               }
            }
            if(this.mScaleCurrentY != this.mScaleOpenY)
            {
               if(this.mTime <= 0)
               {
                  this.mScaleCurrentY = this.mScaleOpenY;
               }
               else
               {
                  this.mScaleCurrentY = this.mScaleOpenY * (this.mTimeTarget - this.mTime) / this.mTimeTarget;
               }
            }
         }
      }
   }
}
