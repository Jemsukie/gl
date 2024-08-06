package com.dchoc.game.model.unit.effects
{
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import esparragon.utils.EUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Point;
   
   public class ArcShield extends UnitEffect
   {
      
      private static const MAX_ARCS:int = 5;
       
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var mOffsetY:Number;
      
      private var mCanvas:Shape;
      
      private var mPointsOrigin:Vector.<Point>;
      
      private var mPointsDest:Vector.<Point>;
      
      private var mPointsControl:Vector.<Point>;
      
      private var mSpeed:Number = 5;
      
      private var mBuilt:Boolean;
      
      public function ArcShield(type:int)
      {
         super(type);
         this.mCanvas = new Shape();
         this.mCanvas.blendMode = "lighten";
         this.mCanvas.filters = [GameConstants.FILTER_GLOW_GREEN_HIGH];
         this.mPointsOrigin = new Vector.<Point>(5,true);
         this.mPointsDest = new Vector.<Point>(5,true);
         this.mPointsControl = new Vector.<Point>(5,true);
         this.mBuilt = false;
      }
      
      override public function setBmp(bmp:Bitmap) : void
      {
         var bmpData:BitmapData = null;
         var i:int = 0;
         mBmp = bmp;
         if(mBmp != null)
         {
            bmpData = mBmp.bitmapData.clone();
            bmpData = EUtils.cropBitmapData(bmpData);
            this.mWidth = bmpData.width;
            this.mHeight = bmpData.height;
            this.mOffsetY = mBmp.height - this.mHeight;
            for(i = 0; i < 5; )
            {
               this.createArc(i);
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
      
      private function createArc(idx:int) : void
      {
         var semiWidth:Number = this.mWidth >> 1;
         var part:Number = this.mHeight / 5;
         var y:Number = part * idx - this.mOffsetY;
         this.mPointsOrigin[idx] = new Point(-semiWidth,y);
         this.mPointsDest[idx] = new Point(semiWidth,y);
         this.mPointsControl[idx] = new Point(0,y + 30);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var i:int = 0;
         if(!this.mBuilt)
         {
            return;
         }
         var o:Point = null;
         var d:Point = null;
         var c:Point = null;
         var g:Graphics;
         (g = this.mCanvas.graphics).clear();
         g.lineStyle(2,65280);
         var topY:Number = -(this.mHeight / 2) - this.mOffsetY;
         for(i = 0; i < 5; )
         {
            o = this.mPointsOrigin[i];
            g.moveTo(o.x,o.y);
            o.y -= this.mSpeed;
            d = this.mPointsDest[i];
            c = this.mPointsControl[i];
            g.curveTo(c.x,c.y,d.x,d.y);
            d.y -= this.mSpeed;
            c.y -= this.mSpeed;
            if(d.y <= topY)
            {
               d.y = topY + this.mHeight;
               c.y = topY + this.mHeight + 30;
               o.y = d.y;
            }
            i++;
         }
      }
   }
}
