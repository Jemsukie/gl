package com.dchoc.game.model.unit.effects
{
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import flash.display.Bitmap;
   
   public class UnitEffect
   {
       
      
      protected var mDisplayObject:DCDisplayObject;
      
      protected var mType:int;
      
      protected var mNeedsToBeAddedToStage:Boolean;
      
      protected var mNeedsToBeRemovedFromStage:Boolean;
      
      protected var mIsBuilt:Boolean;
      
      protected var mBmp:Bitmap;
      
      public function UnitEffect(type:int)
      {
         super();
         this.mType = type;
         this.mNeedsToBeAddedToStage = false;
         this.mNeedsToBeRemovedFromStage = false;
         this.mIsBuilt = false;
      }
      
      public function unload() : void
      {
         this.mDisplayObject = null;
      }
      
      public function getType() : int
      {
         return this.mType;
      }
      
      public function getNeedsToBeAddedToStage() : Boolean
      {
         return this.mNeedsToBeAddedToStage;
      }
      
      public function setNeedsToBeAddedToStage(value:Boolean) : void
      {
         this.mNeedsToBeAddedToStage = value;
      }
      
      public function getNeedsToBeRemovedFromStage() : Boolean
      {
         return this.mNeedsToBeRemovedFromStage;
      }
      
      public function setNeedsToBeRemovedFromStage(value:Boolean) : void
      {
         this.mNeedsToBeRemovedFromStage = value;
      }
      
      public function setDisplayObject(value:DCDisplayObject) : void
      {
         this.mDisplayObject = value;
      }
      
      public function getDisplayObject() : DCDisplayObject
      {
         return this.mDisplayObject;
      }
      
      public function getEffectNeedsDisplayObject() : Boolean
      {
         return true;
      }
      
      public function setIsBuilt(value:Boolean) : void
      {
         this.mIsBuilt = value;
      }
      
      public function isBuilt() : Boolean
      {
         return this.mDisplayObject != null;
      }
      
      public function logicUpdate(dt:int) : void
      {
      }
      
      public function updatePosition(x:Number, y:Number) : void
      {
         if(this.mDisplayObject != null)
         {
            this.mDisplayObject.x = x;
            this.mDisplayObject.y = y;
         }
      }
      
      public function setData(drawX:int, drawY:int, width:int, height:int, boundingBox:DCBox) : void
      {
      }
      
      public function setBmp(bmp:Bitmap) : void
      {
         this.mBmp = bmp;
      }
      
      public function getBmp() : Bitmap
      {
         return this.mBmp;
      }
   }
}
