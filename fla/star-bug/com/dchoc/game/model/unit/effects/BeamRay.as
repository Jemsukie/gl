package com.dchoc.game.model.unit.effects
{
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Point;
   
   public class BeamRay extends DCDisplayObject
   {
       
      
      private var mLaserSize:Number;
      
      private var mOrigin:Point;
      
      private var mDest:Point;
      
      private var mCanvas:Shape;
      
      private var mSegmentsCount:int;
      
      private var mRaysInfo:Vector.<Object>;
      
      public function BeamRay(filter:Array, blendMode:String)
      {
         super();
         this.mCanvas = new Shape();
         if(blendMode != null)
         {
            this.mCanvas.blendMode = blendMode;
         }
         this.mCanvas.filters = filter;
      }
      
      public function addRay(segments:int, size:Number, origin:Point, dest:Point, color1:uint = 8454143, color2:uint = 16777215, time:int = -1) : void
      {
         if(this.mRaysInfo == null)
         {
            this.mRaysInfo = new Vector.<Object>(0);
         }
         var o:Object = {
            "segments":segments,
            "size":size,
            "time":time,
            "color1":color1,
            "color2":color2,
            "origin":origin,
            "dest":dest
         };
         this.mRaysInfo.push(o);
      }
      
      public function getRaysCount() : int
      {
         if(this.mRaysInfo != null)
         {
            return this.mRaysInfo.length;
         }
         return 0;
      }
      
      private function drawLightning(x1:Number, y1:Number, x2:Number, y2:Number, displace:int, size:Number, color1:uint, color2:uint) : void
      {
         var mid_x:Number = NaN;
         var mid_y:Number = NaN;
         var graf:Graphics = this.mCanvas.graphics;
         if(displace < 5)
         {
            graf.lineStyle(size,color1);
            graf.moveTo(x1,y1);
            graf.lineTo(x2,y2);
            graf.endFill();
            if(size > 1)
            {
               graf.lineStyle(size / 2,color2);
               graf.moveTo(x1,y1);
               graf.lineTo(x2,y2);
               graf.endFill();
            }
         }
         else
         {
            mid_x = (x2 + x1) / 2;
            mid_y = (y2 + y1) / 2;
            mid_x += (Math.random() - 0.5) * displace;
            mid_y += (Math.random() - 0.5) * displace;
            this.drawLightning(x1,y1,mid_x,mid_y,displace / 2,size,color1,color2);
            this.drawLightning(x2,y2,mid_x,mid_y,displace / 2,size,color1,color2);
         }
      }
      
      public function logicUpdate(dt:int) : void
      {
         var ray:Object = null;
         var origin:Point = null;
         var dest:Point = null;
         var raysCount:int = 0;
         var i:int = 0;
         if(this.mRaysInfo != null)
         {
            this.mCanvas.graphics.clear();
            raysCount = int(this.mRaysInfo.length);
            for(i = 0; i < this.mRaysInfo.length; )
            {
               origin = (ray = this.mRaysInfo[i]).origin;
               dest = ray.dest;
               this.drawLightning(origin.x,origin.y,dest.x,dest.y,ray.segments,ray.size,ray.color1,ray.color2);
               if(ray.time >= 0)
               {
                  ray.time -= dt;
                  if(ray.time < 0)
                  {
                     raysCount--;
                     this.mRaysInfo.splice(i,1);
                     i--;
                     ray = null;
                  }
               }
               i++;
            }
         }
      }
      
      override public function getDisplayObject() : DisplayObject
      {
         return this.mCanvas;
      }
   }
}
