package com.dchoc.game.model.unit.effects
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import esparragon.utils.EUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   
   public class Stun extends UnitEffect
   {
      
      private static const NUM_STAR_POINTS:int = 5;
       
      
      private var mUnit:MyUnit;
      
      private var mBuilt:Boolean;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var mCanvas:Shape;
      
      private var mNumStars:int;
      
      private var mStarPointThetaOffset:Number;
      
      private var mThetas:Vector.<Number>;
      
      public function Stun(effectType:int, unitRef:MyUnit)
      {
         super(effectType);
         this.mUnit = unitRef;
         this.mCanvas = new Shape();
         this.mCanvas.blendMode = "lighten";
         this.mCanvas.filters = [new GlowFilter(16776960,1,3,3,2,1)];
         this.mNumStars = DCMath.randomNumber(5,7);
         this.mStarPointThetaOffset = Math.random() * 6.283185307179586 / 5;
         this.mThetas = new Vector.<Number>(0);
         this.mBuilt = false;
      }
      
      override public function setBmp(bmp:Bitmap) : void
      {
         var i:int = 0;
         var theta:Number = NaN;
         var bmpData:BitmapData = null;
         mBmp = bmp;
         if(mBmp != null)
         {
            bmpData = mBmp.bitmapData.clone();
            bmpData = EUtils.cropBitmapData(bmpData);
            this.mWidth = bmpData.width;
            this.mHeight = bmpData.height >> 1;
            for(i = 0; i < this.mNumStars; )
            {
               theta = 6.283185307179586 / this.mNumStars * i;
               this.mThetas[i] = theta;
               i++;
            }
            this.mBuilt = true;
         }
      }
      
      override public function setData(drawX:int, drawY:int, width:int, height:int, boundingBox:DCBox) : void
      {
         this.mWidth = width;
         this.mHeight = height;
         if(mDisplayObject == null)
         {
            setDisplayObject(new DCDisplayObjectSWF(this.mCanvas));
         }
         mDisplayObject.x = drawX;
         mDisplayObject.y = drawY;
         mDisplayObject.mBoundingBox = boundingBox;
      }
      
      private function getPointForTheta(theta:Number) : Point
      {
         var semiWidth:Number = this.mWidth >> 1;
         var semiHeight:Number = this.mHeight >> 1;
         var x:Number = semiWidth * Math.cos(theta);
         var y:Number = semiHeight * Math.sin(theta) - this.mHeight;
         return new Point(x,y);
      }
      
      private function drawStarAtPoint(point:Point) : void
      {
         var i:int = 0;
         var theta:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         var pointStart:Point = null;
         var pointAcrossIndexA:int = 0;
         var pointAcrossIndexB:int = 0;
         var pointAcrossA:Point = null;
         var pointAcrossB:Point = null;
         var SIZE:int = 7;
         var originX:Number = point.x;
         var originY:Number = point.y;
         var points:Vector.<Point> = new Vector.<Point>();
         for(i = 0; i < 5; )
         {
            theta = this.mStarPointThetaOffset + 6.283185307179586 / 5 * i;
            x = originX + SIZE * Math.cos(theta);
            y = originY + SIZE * Math.sin(theta);
            points.push(new Point(x,y));
            i++;
         }
         var g:Graphics = this.mCanvas.graphics;
         for(i = 0; i < 5; )
         {
            pointStart = points[i];
            pointAcrossIndexA = (i - 1 + Math.ceil(5 / 2)) % 5;
            pointAcrossIndexB = (i + 1 + Math.floor(5 / 2)) % 5;
            pointAcrossA = points[pointAcrossIndexA];
            pointAcrossB = points[pointAcrossIndexB];
            g.moveTo(pointStart.x,pointStart.y);
            g.lineTo(pointAcrossA.x,pointAcrossA.y);
            g.moveTo(pointStart.x,pointStart.y);
            g.lineTo(pointAcrossB.x,pointAcrossB.y);
            i++;
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var i:int = 0;
         if(!this.mBuilt)
         {
            return;
         }
         var g:Graphics = this.mCanvas.graphics;
         g.clear();
         g.lineStyle(1,16776960);
         for(i = 0; i < this.mThetas.length; )
         {
            this.mThetas[i] += 6.283185307179586 / (this.mNumStars * 5);
            if(this.mThetas[i] >= 6.283185307179586)
            {
               this.mThetas[i] -= 6.283185307179586;
            }
            this.drawStarAtPoint(this.getPointForTheta(this.mThetas[i]));
            i++;
         }
      }
   }
}
