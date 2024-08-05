package com.dchoc.game.model.unit.components.shot
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   public class ShotLaser extends UnitComponentShot
   {
      
      public static const SHOT_NONE:int = 0;
      
      private static const SHOT_START:int = 1;
      
      private static const SHOT_TIME:int = 1000;
       
      
      public var mState:int;
      
      private var mRay:Shape;
      
      private var mDCRay:DCDisplayObject;
      
      private var mTarget:MyUnit;
      
      private var mLaserSize:int;
      
      private var mShotTimer:int;
      
      private var mDamage:int;
      
      private var mUnitInfoObject:Object;
      
      public function ShotLaser()
      {
         super();
         this.mState = 0;
      }
      
      override protected function shootDo(u:MyUnit, target:MyUnit = null) : void
      {
         if(target != null)
         {
            mUnit = u;
            this.mTarget = target;
            if(this.mState != 0)
            {
               this.stopShot();
            }
            this.changeState(1);
            this.mShotTimer = 0;
            this.mDamage = mUnit.mDef.getShotDamage();
            this.mUnitInfoObject = MyUnit.shotCreateUnitInfoObject(mUnit);
            this.mTarget.shotHit(this.mDamage,this.mUnitInfoObject,false,"death005");
         }
      }
      
      override public function isShotAllowed(u:MyUnit) : Boolean
      {
         return super.isShotAllowed(u);
      }
      
      override protected function logicUpdateDo(dt:int, u:MyUnit) : void
      {
         var renderData:DCBitmapMovieClip = null;
         var dest:Vector3D = null;
         var origin:Point = null;
         var i:int = 0;
         if(this.mState == 1)
         {
            if(this.mTarget == null || !this.mTarget.getIsAlive())
            {
               this.stopShot();
               return;
            }
            this.mShotTimer += dt;
            if(this.mShotTimer >= 1000)
            {
               this.stopShot();
            }
            else
            {
               this.mLaserSize = 3;
               renderData = mUnit.getViewComponent().getCurrentRenderData();
               dest = new Vector3D(this.mTarget.mPositionDrawX,this.mTarget.mPositionDrawY - (InstanceMng.getMapViewPlanet().getTileViewHeight() >> 1) + this.mTarget.mPosition.z,0);
               if(renderData != null)
               {
                  origin = new Point(renderData.x + renderData.getCollBoxX(),renderData.y + renderData.getCollBoxY());
               }
               else
               {
                  origin = new Point(mUnit.mPositionDrawX,mUnit.mPositionDrawY);
               }
               this.mRay.graphics.clear();
               i = 0;
               while(i < 3)
               {
                  if(i == 0)
                  {
                     this.mLaserSize = 4;
                     this.drawLightning(origin.x,origin.y,dest.x,dest.y,10);
                  }
                  else
                  {
                     this.mLaserSize = 1;
                     this.drawLightning(origin.x,origin.y,dest.x,dest.y,30);
                  }
                  i++;
               }
            }
         }
      }
      
      private function changeState(newState:int) : void
      {
         var viewMng:ViewMngPlanet = null;
         switch(newState)
         {
            case 0:
               if(this.mDCRay != null)
               {
                  viewMng = InstanceMng.getViewMngPlanet();
                  if(viewMng.contains(this.mDCRay))
                  {
                     viewMng.worldItemRemoveWeaponsEffect(this.mDCRay);
                  }
                  this.mRay = null;
                  this.mDCRay = null;
               }
               this.mShotTimer = 0;
               setWaitTimeToShot(mUnit);
               break;
            case 1:
               if(this.mRay == null)
               {
                  this.mLaserSize = 3;
                  this.mRay = new Shape();
                  this.mDCRay = new DCDisplayObjectSWF(this.mRay);
                  if(this.mDCRay != null)
                  {
                     viewMng = InstanceMng.getViewMngPlanet();
                     if(!viewMng.contains(this.mDCRay))
                     {
                        viewMng.worldItemAddWeaponsEffects(this.mDCRay);
                     }
                  }
                  break;
               }
         }
         this.mState = newState;
      }
      
      private function drawLightning(x1:Number, y1:Number, x2:Number, y2:Number, displace:int) : void
      {
         var color:int = 0;
         var mid_x:Number = NaN;
         var mid_y:Number = NaN;
         var graf:Graphics = this.mRay.graphics;
         if(displace < 5)
         {
            color = 8454143;
            if(mUnit.mDef.isHealer())
            {
               color = 16215276;
               if(mUnit.mDef.getSkuTracking() == "mender_7")
               {
                  color = 6704627;
               }
            }
            if(mUnit.mDef.getSku() == "groundUnits_mayan_golem_forest")
            {
               color = 6749952;
            }
            this.mRay.graphics.lineStyle(this.mLaserSize,color);
            graf.moveTo(x1,y1);
            graf.lineTo(x2,y2);
            this.mRay.graphics.endFill();
            if(mUnit.mDef.getSku() == "mecaUnits_006_000")
            {
               color = 6749952;
            }
            this.mRay.graphics.lineStyle(this.mLaserSize,color);
            graf.moveTo(x1,y1);
            graf.lineTo(x2,y2);
            this.mRay.graphics.endFill();
            if(this.mLaserSize > 1)
            {
               this.mRay.graphics.lineStyle(this.mLaserSize / 2,16777215);
               graf.moveTo(x1,y1);
               graf.lineTo(x2,y2);
               this.mRay.graphics.endFill();
            }
         }
         else
         {
            mid_x = (x2 + x1) / 2;
            mid_y = (y2 + y1) / 2;
            mid_x += (Math.random() - 0.5) * displace;
            mid_y += (Math.random() - 0.5) * displace;
            this.drawLightning(x1,y1,mid_x,mid_y,displace / 2);
            this.drawLightning(x2,y2,mid_x,mid_y,displace / 2);
         }
      }
      
      override public function stopShot() : void
      {
         this.changeState(0);
      }
   }
}
