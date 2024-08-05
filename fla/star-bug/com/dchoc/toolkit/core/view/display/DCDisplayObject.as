package com.dchoc.toolkit.core.view.display
{
   import com.dchoc.toolkit.core.view.display.layer.DCLayer;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class DCDisplayObject extends Sprite
   {
       
      
      protected var mLayerParent:DCLayer;
      
      public var mZDepth:Number;
      
      protected var mCoor:DCCoordinate;
      
      protected var mVisible:Boolean;
      
      protected var mFilters:Array;
      
      protected var mFlipHorizontal:Boolean;
      
      public var mIsOnScreen:Boolean;
      
      public var mBoundingBox:DCBox;
      
      public function DCDisplayObject()
      {
         super();
         this.mCoor = new DCCoordinate();
      }
      
      public function getDisplayObjectContent() : DisplayObject
      {
         return null;
      }
      
      public function getDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function getSortingBox() : DCBox
      {
         return this.mBoundingBox;
      }
      
      override public function get x() : Number
      {
         return -1;
      }
      
      override public function set x(value:Number) : void
      {
      }
      
      override public function get y() : Number
      {
         return -1;
      }
      
      override public function set y(value:Number) : void
      {
      }
      
      public function setXY(x:Number, y:Number, z:Number = 0) : void
      {
         if(this.mBoundingBox != null)
         {
            this.mBoundingBox.setXY(x,y);
            this.mBoundingBox.mZ = -z;
         }
         if(this.mLayerParent != null)
         {
            this.mLayerParent.childSetXY(this,x,y + z);
         }
         this.x = x;
         this.y = y + z;
      }
      
      override public function set scaleX(value:Number) : void
      {
         var matrix:Matrix = this.getDisplayObject().transform.matrix;
         matrix.scale(value,1);
      }
      
      override public function set scaleY(value:Number) : void
      {
         var matrix:Matrix = transform.matrix;
         matrix.scale(1,value);
      }
      
      public function getCurrentFrameWidth() : int
      {
         return -1;
      }
      
      public function getCurrentFrameHeight() : int
      {
         return -1;
      }
      
      public function getMaxWidth() : int
      {
         return -1;
      }
      
      public function getMaxHeight() : int
      {
         return -1;
      }
      
      public function setInk(color:uint, magnitude:Number) : void
      {
         var dsp:DisplayObject = this.getDisplayObject();
         dsp.transform.colorTransform = DCUtils.setInk(DCUtils.smColorTransformInit,color,magnitude);
      }
      
      public function resetFilters() : void
      {
         var dsp:DisplayObject = this.getDisplayObject();
         dsp.transform.colorTransform = DCUtils.smColorTransformInit;
      }
      
      public function get currentFrame() : int
      {
         return 0;
      }
      
      public function set currentFrame(value:int) : void
      {
      }
      
      public function get currentFrameLabel() : String
      {
         return null;
      }
      
      public function get totalFrames() : int
      {
         return 0;
      }
      
      public function isAnimationOver() : Boolean
      {
         return this.currentFrame >= this.totalFrames;
      }
      
      public function gotoAndStop(frameId:int) : void
      {
      }
      
      public function gotoAndPlay(frameId:int) : void
      {
      }
      
      public function nextFrame() : void
      {
      }
      
      public function setLayerParent(parent:DCLayer) : void
      {
         this.mLayerParent = parent;
      }
      
      public function getLayerParent() : DCLayer
      {
         return this.mLayerParent;
      }
      
      public function getZDepth() : int
      {
         return this.mZDepth;
      }
      
      public function setZDepth(value:int) : void
      {
         this.mZDepth = value;
      }
      
      public function hasEnded() : Boolean
      {
         return this.currentFrame == this.totalFrames;
      }
      
      public function setBoundingBoxSize() : void
      {
      }
      
      public function fillInfoSortingBox() : void
      {
      }
      
      public function getIndexInParent() : int
      {
         return 0;
      }
   }
}
