package com.dchoc.game.model.unit.effects
{
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import flash.geom.Point;
   
   public class Lightnings extends UnitEffect
   {
      
      private static const RAY_LIVE_TIME:int = 300;
       
      
      protected var mBeamRay:BeamRay;
      
      protected var mWidth:int;
      
      protected var mHeight:int;
      
      protected var mMaxRays:int;
      
      public function Lightnings(type:int, maxRays:int = 2, filter:Array = null, blendMode:String = "lighten")
      {
         super(type);
         if(filter == null)
         {
            filter = [GameConstants.FILTER_GLOW_BLUE_LASER];
         }
         this.mBeamRay = new BeamRay(filter,blendMode);
         this.mMaxRays = maxRays;
      }
      
      override public function setData(drawX:int, drawY:int, width:int, height:int, boundingBox:DCBox) : void
      {
         var i:int = 0;
         this.mWidth = width;
         this.mHeight = height;
         if(mDisplayObject == null)
         {
            setDisplayObject(new DCDisplayObjectSWF(this.mBeamRay.getDisplayObject()));
         }
         mDisplayObject.x = drawX;
         mDisplayObject.y = drawY;
         mDisplayObject.mBoundingBox = boundingBox;
         for(i = 0; i < this.mMaxRays; )
         {
            this.createRay(i);
            i++;
         }
      }
      
      protected function createRay(idx:int) : void
      {
         var x:int = 0;
         var y:int = 0;
         var x2:int = 0;
         var y2:int = 0;
         var semiWidth:* = this.mWidth >> 1;
         var semiHeight:* = this.mHeight >> 1;
         var point1:Point = new Point();
         x = Math.random() * this.mWidth - semiWidth;
         y = Math.random() * this.mHeight - semiHeight;
         point1.x = x;
         point1.y = y;
         x2 = Math.random() * this.mWidth - semiWidth;
         y2 = Math.random() * this.mHeight - semiHeight;
         point1.x = x2;
         point1.y = y2;
         var time:int = Math.random() * 10 + Math.random() * 10 * 10 + (Math.random() * 4 + 1) * 300;
         this.mBeamRay.addRay(20,1,new Point(x,y),new Point(x2,y2),8454143,16777215,time);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var newRays:int = 0;
         var i:int = 0;
         this.mBeamRay.logicUpdate(dt);
         var raysCount:int;
         if((raysCount = this.mBeamRay.getRaysCount()) < this.mMaxRays)
         {
            newRays = this.mMaxRays - raysCount;
            for(i = 0; i < newRays; )
            {
               this.createRay(i);
               i++;
            }
         }
      }
   }
}
