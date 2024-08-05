package com.dchoc.game.model.unit.effects
{
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import esparragon.utils.EUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class LightningsShield extends Lightnings
   {
      
      private static const MAX_RAYS:int = 2;
       
      
      private var mOffsetY:Number = 0;
      
      private var mBData:BitmapData;
      
      private var mBounds:Rectangle;
      
      public function LightningsShield(type:int, filter:Array = null)
      {
         super(type,5,[GameConstants.FILTER_GLOW_BLUE_ROUGH],null);
      }
      
      override public function setBmp(bmp:Bitmap) : void
      {
         var bmpData:BitmapData = null;
         var i:int = 0;
         mBmp = bmp;
         if(mBmp != null)
         {
            bmpData = mBmp.bitmapData;
            this.mBData = EUtils.cropBitmapData(bmpData);
            this.mBounds = bmpData.getColorBoundsRect(4278190080,0,false);
            mWidth = this.mBData.width;
            mHeight = this.mBData.height;
            this.mOffsetY = mBmp.height - mHeight;
            for(i = 0; i < mMaxRays; )
            {
               this.createRay(i);
               i++;
            }
         }
      }
      
      override public function setData(drawX:int, drawY:int, width:int, height:int, boundingBox:DCBox) : void
      {
         mWidth = width;
         mHeight = height;
         if(mDisplayObject == null)
         {
            setDisplayObject(new DCDisplayObjectSWF(mBeamRay.getDisplayObject()));
         }
         mDisplayObject.x = drawX;
         mDisplayObject.y = drawY;
         mDisplayObject.mBoundingBox = boundingBox;
      }
      
      override protected function createRay(idx:int) : void
      {
         var semiWidth:* = 0;
         var semiHeight:* = 0;
         var part:Number = NaN;
         var x1:Number = NaN;
         var y1:Number = NaN;
         var x2:Number = NaN;
         var y2:Number = NaN;
         var y:Number = NaN;
         var color:* = 0;
         if(this.mBData != null)
         {
            semiWidth = mWidth >> 1;
            semiHeight = mHeight >> 1;
            part = mHeight / mMaxRays;
            y1 = (y = part * idx) + Math.random() * part;
            y2 = y + Math.random() * part;
            for(x1 = 0; x1 < mWidth; )
            {
               if(this.mBData.getPixel32(x1,y1) != 0)
               {
                  break;
               }
               x1++;
            }
            for(x2 = mWidth - 1; x2 >= 0; )
            {
               if(this.mBData.getPixel32(x2,y2) != 0)
               {
                  break;
               }
               x2--;
            }
            color = 11123432;
            mBeamRay.addRay(20,2,new Point(x1 + this.mBounds.x - mBmp.width / 2,y1 + this.mBounds.y - mBmp.height / 2 - this.mOffsetY),new Point(x2 + this.mBounds.x - mBmp.width / 2,y2 + this.mBounds.y - mBmp.height / 2 - this.mOffsetY),color,16777215,300);
         }
      }
   }
}
