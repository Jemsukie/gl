package com.dchoc.game.model.unit
{
   import flash.display.Shape;
   
   public class FireWork
   {
       
      
      private const NUM_EXP:int = 50;
      
      private const TIME_LIVE:int = 500;
      
      private const CIRCLE_RADIUS:Number = 2;
      
      private const BASE_TAIL_WIDTH:Number = 2;
      
      private const BASE_SPEED:Number = 0.5;
      
      private const SPEED_RANGE:Number = 7;
      
      private const WHITENING:Number = 48;
      
      private var mAngle:Array;
      
      private var mSpeed:Array;
      
      private var mAlpha:Array;
      
      private var mDist:Array;
      
      private var mColor:Array;
      
      private var mTailFactor:Number;
      
      private var time:int;
      
      private var mXinit:Number;
      
      private var mYinit:Number;
      
      private var x:Number;
      
      private var y:Number;
      
      public function FireWork(xinit:Number, yinit:Number, color:uint, color2:uint)
      {
         this.mAngle = [];
         this.mSpeed = [];
         this.mAlpha = [];
         this.mDist = [];
         this.mColor = [];
         super();
         this.resetFireWork(xinit,yinit,color,color2);
      }
      
      public function resetFireWork(newx:Number, newy:Number, color:uint, color2:uint) : void
      {
         var i:int = 0;
         var colorIn:* = 0;
         var r:uint = 0;
         var g:uint = 0;
         var b:uint = 0;
         var doubleColor:* = Math.random() > 0.7;
         this.mXinit = newx;
         this.mYinit = newy;
         this.x = this.mXinit;
         this.y = this.mYinit;
         this.mTailFactor = 1;
         this.time = 500 + Math.random() * 500;
         for(i = 0; i < 50; )
         {
            this.mAngle[i] = Math.random() * 360;
            this.mSpeed[i] = 0.5 + Math.random() * 7;
            this.mAlpha[i] = 0.3 + Math.random() * 0.4;
            this.mDist[i] = 0;
            if(doubleColor)
            {
               colorIn = i % 2 == 0 ? color : color2;
            }
            else
            {
               colorIn = color;
            }
            r = uint((colorIn & 16711680) >> 16);
            g = uint((colorIn & 65280) >> 8);
            b = uint(colorIn & 255);
            r += Math.random() * 48;
            g += Math.random() * 48;
            b += Math.random() * 48;
            if(r > 255)
            {
               r = 255;
            }
            if(g > 255)
            {
               g = 255;
            }
            if(b > 255)
            {
               b = 255;
            }
            this.mColor[i] = (r << 16) + (g << 8) + b;
            i++;
         }
      }
      
      public function logicUpdate(dt:int, canvas:Shape) : void
      {
         var i:int = 0;
         var speed:Number = NaN;
         var alpha:Number = NaN;
         var angle:int = 0;
         var radians:Number = NaN;
         var px:Number = NaN;
         var py:Number = NaN;
         var tailFactor:Number = NaN;
         var tailSteps:int = 0;
         var j:int = 0;
         var ox:Number = NaN;
         var oy:Number = NaN;
         this.time -= dt;
         if(this.time > 0)
         {
            for(i = 0; i < 50; )
            {
               speed = this.time * 6 / 500;
               alpha = Number(this.mAlpha[i]);
               if(this.time < 500 / 2)
               {
                  alpha *= this.time / (500 / 2);
               }
               speed = this.mSpeed[i] + speed * this.mSpeed[i] * 0.1;
               this.mDist[i] += speed;
               radians = (angle = int(this.mAngle[i])) * (3.141592653589793 / 180);
               px = this.mXinit + this.mDist[i] * Math.cos(radians);
               py = this.mYinit + this.mDist[i] * Math.sin(radians);
               tailFactor = this.mTailFactor * 4;
               tailSteps = 2;
               for(j = 1; j <= tailSteps; )
               {
                  ox = this.mXinit + (this.mDist[i] - this.mDist[i] / (tailFactor * j)) * Math.cos(radians);
                  oy = this.mYinit + (this.mDist[i] - this.mDist[i] / (tailFactor * j)) * Math.sin(radians);
                  canvas.graphics.lineStyle(2 + j * 0.5,this.mColor[i],alpha / (tailSteps + 1 - j));
                  canvas.graphics.moveTo(ox,oy);
                  canvas.graphics.lineTo(px,py);
                  j++;
               }
               canvas.graphics.beginFill(this.mColor[i],alpha + 0.5);
               canvas.graphics.drawCircle(px,py,2);
               canvas.graphics.endFill();
               i++;
            }
         }
      }
      
      public function get isAlive() : Boolean
      {
         return this.time > 0;
      }
   }
}
