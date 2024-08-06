package com.dchoc.game.view.dc.map
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.gskinner.geom.ColorMatrix;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   
   public class SpyCapsule
   {
      
      private static const STATE_NONE:int = 0;
      
      private static const STATE_INSTALLING:int = 1;
      
      private static const STATE_WORKING:int = 2;
      
      private static const STATE_NOT_WORKING:int = 3;
       
      
      private var mType:int;
      
      private var mDO:DisplayObjectContainer;
      
      private var mState:int;
      
      private var mTileX:int;
      
      private var mTileY:int;
      
      private var mWorldPosX:Number;
      
      private var mWorldPosY:Number;
      
      private var mRadius:int;
      
      private var mRadiusSqr:int;
      
      private var mViewPosX:int;
      
      private var mViewPosY:int;
      
      private var mWillBeEnabled:Boolean = false;
      
      private var mIsEnabled:Boolean = false;
      
      public function SpyCapsule(type:int, tileX:int, tileY:int, worldPosX:Number, worldPosY:Number, viewPosX:int, viewPosY:int, radius:int)
      {
         super();
         this.mType = type;
         this.mTileX = tileX;
         this.mTileY = tileY;
         this.mWorldPosX = worldPosX;
         this.mWorldPosY = worldPosY;
         this.mViewPosX = viewPosX;
         this.mViewPosY = viewPosY;
         this.setRadius(radius);
         this.setIsEnabled(true);
         this.changeState(2);
      }
      
      public static function addCapsuleToAnim(container:DisplayObjectContainer, spyType:int, filters:Array = null) : void
      {
         var thisClass:Class = null;
         var spyCapsule:MovieClip = null;
         if(container == null)
         {
            return;
         }
         var className:String = spyType == 1 ? "advanced_spy_capsule_sprites" : "spy_capsule_sprites";
         if((thisClass = InstanceMng.getResourceMng().getSWFClass("assets/flash/gui/spy_capsule.swf",className)) == null)
         {
            return;
         }
         spyCapsule = new thisClass();
         var offset:int = 270;
         if(spyType == 1)
         {
            offset *= 2;
         }
         spyCapsule.y -= offset;
         spyCapsule.filters = filters;
         container.addChild(spyCapsule);
      }
      
      public function unload() : void
      {
         this.changeState(0);
      }
      
      private function getDisplayObject(swfName:String, clipName:String, filters:Array = null) : DCDisplayObject
      {
         var clip:DisplayObject = null;
         var returnValue:DCDisplayObject = null;
         var thisClass:Class;
         if((thisClass = InstanceMng.getResourceMng().getSWFClass(swfName,clipName)) != null)
         {
            (clip = new (InstanceMng.getResourceMng().getSWFClass(swfName,clipName))()).filters = filters;
            returnValue = new DCDisplayObjectSWF(clip);
         }
         return returnValue;
      }
      
      private function addToStage() : void
      {
         if(this.mDO != null)
         {
            this.mDO.x = this.mViewPosX;
            this.mDO.y = this.mViewPosY;
            InstanceMng.getViewMngPlanet().addSpyCapsuleToStage(this.mDO);
         }
      }
      
      public function removeFromStage() : void
      {
         InstanceMng.getViewMngPlanet().removeSpyCapsuleFromStage(this.mDO);
      }
      
      private function changeState(newState:int) : void
      {
         var filter:ColorMatrix = null;
         var innerDO:DCDisplayObject = null;
         switch(this.mState - 1)
         {
            case 0:
            case 1:
            case 2:
               this.removeFromStage();
         }
         var filtersToApply:Array = [];
         if(this.mType == 1)
         {
            filter = new ColorMatrix();
            filter.adjustColor(0,0,0,-115);
            filtersToApply.push(new ColorMatrixFilter(filter.toArray()));
         }
         this.mDO = new MovieClip();
         this.mState = newState;
         switch(this.mState - 1)
         {
            case 0:
               innerDO = this.getDisplayObject("assets/flash/_esparragon/gui/layouts/gui_old.swf","shield_creation");
               this.mDO.addChildAt(innerDO,0);
               this.addToStage();
               break;
            case 1:
               innerDO = this.getDisplayObject("assets/flash/gui/spy_capsule.swf","spy_capsule_scanning",filtersToApply);
               if(innerDO != null)
               {
                  this.mDO.addChildAt(innerDO,0);
                  if(this.mType == 1)
                  {
                     innerDO.scaleX = 2;
                     innerDO.scaleY = 2;
                  }
                  addCapsuleToAnim(this.mDO,this.mType,[this.mType == 1 ? GameConstants.FILTER_SPY_CAPSULE_ADVANCED_SELECTED : GameConstants.FILTER_SPY_CAPSULE_SELECTED]);
               }
               this.addToStage();
               break;
            case 2:
               innerDO = this.getDisplayObject("assets/flash/gui/spy_capsule.swf","spy_capsule_still",filtersToApply);
               if(innerDO != null)
               {
                  this.mDO.addChildAt(innerDO,0);
                  if(this.mType == 1)
                  {
                     innerDO.scaleX = 2;
                     innerDO.scaleY = 2;
                  }
                  addCapsuleToAnim(this.mDO,this.mType,[this.mType == 1 ? GameConstants.FILTER_SPY_CAPSULE_ADVANCED_NOT_SELECTED : GameConstants.FILTER_SPY_CAPSULE_NOT_SELECTED]);
               }
               this.addToStage();
         }
      }
      
      public function getType() : int
      {
         return this.mType;
      }
      
      public function isRectInsideArea(top:Number, left:Number, bottom:Number, right:Number) : Boolean
      {
         return DCMath.intersectCircleRectangle(this.mWorldPosX,this.mWorldPosY,this.mRadius,top,left,bottom,right);
      }
      
      public function isWorldPositionInsideArea(worldPosX:Number, worldPosY:Number) : Boolean
      {
         var dx:Number = this.mWorldPosX - worldPosX;
         var dy:Number = this.mWorldPosY - worldPosY;
         return dx * dx + dy * dy <= this.mRadiusSqr;
      }
      
      public function getTileX() : int
      {
         return this.mTileX;
      }
      
      public function getTileY() : int
      {
         return this.mTileY;
      }
      
      public function getWorldPosX() : int
      {
         return this.mWorldPosX;
      }
      
      public function getWorldPosY() : int
      {
         return this.mWorldPosY;
      }
      
      public function getWillBeEnabled() : Boolean
      {
         return this.mWillBeEnabled;
      }
      
      public function setWillBeEnabled(value:Boolean) : void
      {
         this.mWillBeEnabled = value;
      }
      
      public function getIsEnabled() : Boolean
      {
         return this.mIsEnabled;
      }
      
      public function setIsEnabled(value:Boolean) : void
      {
         if(this.mIsEnabled != value)
         {
            this.mIsEnabled = value;
            if(value)
            {
               this.setWillBeEnabled(false);
               this.changeState(2);
            }
            else
            {
               this.changeState(3);
            }
         }
      }
      
      private function setRadius(value:Number) : void
      {
         this.mRadius = value;
         this.mRadiusSqr = value * value;
      }
   }
}
