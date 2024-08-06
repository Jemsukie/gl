package com.dchoc.game.model.unit.components.shot
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.geom.Vector3D;
   
   public class ShotRocket extends UnitComponentShot
   {
      
      public static const STATE_SHOT:int = 0;
      
      public static const STATE_END:int = 1;
       
      
      private var mBulletSku:String;
      
      private var mTarget:MyUnit;
      
      private var mState:int;
      
      private var mShotDone:Boolean;
      
      public function ShotRocket(sku:String = "default", waitForAnim:Boolean = false)
      {
         if(sku == "default")
         {
            sku = "b_rocket_001";
         }
         super(waitForAnim);
         this.mBulletSku = sku;
         this.mState = 1;
      }
      
      override protected function shootDo(u:MyUnit, target:MyUnit = null) : void
      {
         mUnit = u;
         this.mTarget = target;
         if(mWaitForAnim)
         {
            this.mState = 0;
         }
         else
         {
            this.shot();
         }
         this.mShotDone = false;
      }
      
      override public function isShotAllowed(u:MyUnit) : Boolean
      {
         return super.isShotAllowed(u) && this.mState == 1;
      }
      
      private function shot() : void
      {
         var TIME:int = 0;
         var GRAVITY:Number = NaN;
         var goalParams:Object = null;
         var coord:DCCoordinate = null;
         var renderData:DCBitmapMovieClip = null;
         var damage:Number = NaN;
         var newTime:* = 0;
         var vx:Number = NaN;
         var vy:Number = NaN;
         var angle:Number = NaN;
         var maxVel:Number = NaN;
         var sku:String = null;
         var shotDist:Number = NaN;
         var high:Number = NaN;
         var vectorDist:Vector3D = null;
         var dist:Number = NaN;
         var timeOffset:Number = NaN;
         var mov:UnitComponentMovement = null;
         if(this.mTarget != null && this.mTarget.mIsAlive)
         {
            TIME = 40;
            GRAVITY = 0.05;
            goalParams = {
               "affectsArea":true,
               "hasExploded":false
            };
            coord = MyUnit.smCoor;
            if((renderData = mUnit.getViewComponent().getCurrentRenderData()) != null)
            {
               coord.x = renderData.getCollBoxX();
               coord.y = renderData.getCollBoxY();
            }
            else
            {
               coord.x = 0;
               coord.y = 0;
            }
            coord.z = 0;
            coord = InstanceMng.getViewMngPlanet().viewPosToLogicPos(coord);
            damage = mUnit.mDef.getShotDamage();
            sku = this.mBulletSku;
            switch(this.mBulletSku)
            {
               case "b_bullet_001":
               case "b_fireball_001":
               case "b_tornado_001":
                  shotDist = InstanceMng.getPowerUpMng().unitsGetAmountForActivePowerUpByUnitSkuAndPowerUpType(mUnit.mDef.mSku,1,"turretsExtraRange",mUnit.mDef.getShotDistance());
                  angle = Math.atan2(this.mTarget.mPosition.y - (mUnit.mPosition.y + coord.y),this.mTarget.mPosition.x - (mUnit.mPosition.x + coord.x));
                  newTime = TIME;
                  if(this.mBulletSku == "b_tornado_001")
                  {
                     newTime = 300;
                  }
                  maxVel = shotDist / newTime;
                  goalParams.velocity = new Vector3D(Math.cos(angle) * maxVel,Math.sin(angle) * maxVel,0);
                  goalParams.affectsArea = true;
                  break;
               case "b_airbullet_001":
                  sku = "b_bullet_001";
                  high = -200;
                  dist = (vectorDist = new Vector3D(this.mTarget.mPosition.x - (mUnit.mPosition.x + coord.x),this.mTarget.mPosition.y - (mUnit.mPosition.y + coord.y))).length;
                  timeOffset = Math.sqrt(Math.abs(2 * high / GRAVITY));
                  maxVel = dist / timeOffset;
                  mov = mUnit.getMovementComponent();
                  goalParams.velocity = new Vector3D(maxVel,maxVel,0);
                  goalParams.positionZ = high;
                  goalParams.acceleration = new Vector3D(0,0,GRAVITY);
                  goalParams.affectsArea = true;
                  break;
               case "b_rock_001":
               case "b_bomb_001":
                  newTime = 150;
                  vx = this.mTarget.mPosition.x - (mUnit.mPosition.x + coord.x);
                  vy = this.mTarget.mPosition.y - (mUnit.mPosition.y + coord.y);
                  goalParams.velocity = new Vector3D(vx / newTime,vy / newTime,-GRAVITY * newTime * 0.5);
                  goalParams.acceleration = new Vector3D(0,0,GRAVITY);
                  goalParams.affectsArea = true;
                  break;
               case "b_rocket_002":
                  MyUnit.smUnitScene.bulletsShoot("b_rocket_001",damage,"unitGoalImpact",goalParams,mUnit,this.mTarget);
                  MyUnit.smUnitScene.bulletsShoot("b_rocket_001",damage,"unitGoalImpact",goalParams,mUnit,this.mTarget,1);
            }
            if(this.mBulletSku != "b_rocket_002")
            {
               if(mUnit.mDef.mSku == "groundUnits_001_005")
               {
                  shotDist = mUnit.mDef.getShotDistance();
                  angle = Math.atan2(this.mTarget.mPosition.y - (mUnit.mPosition.y + coord.y),this.mTarget.mPosition.x - (mUnit.mPosition.x + coord.x));
                  maxVel = shotDist / TIME;
                  goalParams.velocity = new Vector3D(Math.cos(angle) * maxVel,Math.sin(angle) * maxVel,-0.3 * maxVel);
                  goalParams.acceleration = new Vector3D(0,0,GRAVITY);
               }
               MyUnit.smUnitScene.bulletsShoot(sku,damage,"unitGoalImpact",goalParams,mUnit,this.mTarget);
            }
         }
      }
      
      override protected function logicUpdateDo(dt:int, u:MyUnit) : void
      {
         var renderData:DCBitmapMovieClip = null;
         var label:String = null;
         if(mWaitForAnim)
         {
            if(this.mState == 0)
            {
               if(mUnit.getViewComponent().isPlayingAnimId("shooting"))
               {
                  renderData = mUnit.getViewComponent().getCurrentRenderData();
                  if(renderData != null)
                  {
                     if((label = renderData.getCurrentLabel()) != null && label.indexOf("shoot") > -1)
                     {
                        if(!this.mShotDone)
                        {
                           this.shot();
                           this.mShotDone = true;
                        }
                     }
                  }
               }
               else
               {
                  this.mState = 1;
               }
            }
         }
      }
      
      public function getBulletSku() : String
      {
         return this.mBulletSku;
      }
   }
}
