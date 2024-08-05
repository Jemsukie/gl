package com.dchoc.game.model.unit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import flash.display.Shape;
   
   public class BombTail extends Particle
   {
      
      private static const POINT_LIFE_TIME:int = 700;
      
      private static const MAX_POINTS:int = 30;
      
      private static const POINT_TIME_INTERVAL:int = 30;
       
      
      private var mPoints:Vector.<Array>;
      
      private var mPointsLife:Vector.<int>;
      
      private var mPointsAlpha:Vector.<Number>;
      
      private var mCanvas:Shape;
      
      private var mPointsCount:int;
      
      private var mColor:uint;
      
      private var mPointInterval:int;
      
      public function BombTail(type:int)
      {
         super(type);
         this.mPoints = new Vector.<Array>(0);
         this.mPointsLife = new Vector.<int>(0);
         this.mPointsAlpha = new Vector.<Number>(0);
         this.mCanvas = new Shape();
         this.mCanvas.blendMode = "lighten";
         this.mPointsCount = 0;
         mCustomRenderData = new DCDisplayObjectSWF(this.mCanvas);
         this.mColor = 16711680;
      }
      
      public function setColor(color:uint) : void
      {
         this.mColor = color;
      }
      
      override public function activate(x:int, y:int, positionInQueue:int = 1, frameTicks:int = 2) : Boolean
      {
         mState = 1;
         this.mPointsLife.length = 0;
         this.mPoints.length = 0;
         this.mPointsAlpha.length = 0;
         this.mPointsCount = 0;
         ParticleMng.addParticleToVector(this);
         InstanceMng.getViewMngPlanet().worldItemAddWeaponsEffects(mCustomRenderData);
         return true;
      }
      
      override public function deactivate() : void
      {
         var i:int = 0;
         mState = 0;
         InstanceMng.getViewMngPlanet().worldItemRemoveWeaponsEffect(mCustomRenderData);
         this.mPointsLife.length = 0;
         this.mPointsAlpha.length = 0;
         for(i = 0; i < this.mPointsCount; )
         {
            this.mPoints[i] = null;
            i++;
         }
         this.mPoints.length = 0;
         this.mPointsCount = 0;
      }
      
      public function addPoint(x:Number, y:Number) : void
      {
         var lastIndex:int = 0;
         var i:int = 0;
         if(this.mPointInterval <= 0)
         {
            if(this.mPointsCount >= 30)
            {
               lastIndex = 30 - 1;
               for(i = 0; i < 30; )
               {
                  this.mPoints[i] = this.mPoints[i + 1];
                  this.mPointsLife[i] = this.mPointsLife[i + 1];
                  this.mPointsAlpha[i] = this.mPointsAlpha[i + 1];
                  i++;
               }
               this.mPoints[lastIndex] = null;
               this.mPoints[lastIndex] = [x,y];
               this.mPointsLife[lastIndex] = 700;
               this.mPointsAlpha[lastIndex] = 1;
            }
            else
            {
               this.mPoints.push([x,y]);
               this.mPointsLife.push(700);
               this.mPointsAlpha.push(1);
               this.mPointsCount++;
            }
            this.mPointInterval = 30;
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var i:int = 0;
         for(i = 0; i < this.mPointsCount; )
         {
            this.mPointsLife[i] -= dt;
            this.mPointsAlpha[i] = this.mPointsLife[i] / 700;
            if(this.mPointsAlpha[i] < 0)
            {
               this.mPointsAlpha[i] = 0;
            }
            if(this.mPointsLife[i] <= 0)
            {
               this.mPoints.splice(i,1);
               this.mPointsLife.splice(i,1);
               this.mPointsAlpha.splice(i,1);
               this.mPointsCount--;
               if(this.mPointsCount == 1)
               {
                  this.deactivate();
                  return;
               }
            }
            i++;
         }
         this.mCanvas.graphics.clear();
         var index:int = 0;
         for(i = 1; i < this.mPointsCount; )
         {
            this.mCanvas.graphics.lineStyle(4,this.mColor,this.mPointsAlpha[i - 1]);
            this.mCanvas.graphics.moveTo(this.mPoints[i][0],this.mPoints[i][1]);
            this.mCanvas.graphics.lineTo(this.mPoints[i - 1][0],this.mPoints[i - 1][1]);
            i++;
         }
         this.mPointInterval -= dt;
      }
   }
}
