package com.dchoc.game.model.unit.components.shot
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import flash.display.Shape;
   import flash.geom.Vector3D;
   
   public class BulletSniper extends Bullet
   {
      
      private static const SHOT_NONE:int = 0;
      
      private static const SHOT_START:int = 1;
      
      private static const SHOT_DRAW_PATH:int = 2;
      
      private static const SHOT_TIME:int = 200;
       
      
      private var mRay:Shape;
      
      private var mDCRay:DCDisplayObject;
      
      private var mTimer:int;
      
      private var mBulletDef:UnitDef;
      
      public function BulletSniper(u:MyUnit, target:MyUnit, collId:int = 0, bulletDef:UnitDef = null)
      {
         super(u,target,collId);
         this.mTimer = 0;
         this.mBulletDef = bulletDef;
         this.changeState(1);
         if(Config.USE_SOUNDS)
         {
            if(this.mBulletDef.mSku == "b_sniper_001")
            {
               SoundManager.getInstance().playSound("laser.mp3");
            }
            else if(this.mBulletDef.mSku == "b_sniper_003")
            {
               SoundManager.getInstance().playSound("photon_1.mp3");
            }
            else
            {
               SoundManager.getInstance().playSound("photon_2.mp3");
            }
         }
      }
      
      override public function unbuild() : void
      {
         var viewMng:ViewMngPlanet = null;
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
         mState = 0;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         if(mState > 0)
         {
            if(mTarget != null && !mTarget.getIsAlive() || mTarget == null)
            {
               this.unbuild();
            }
            this.mTimer += dt;
            if(mState == 1)
            {
               if(this.mTimer > 100)
               {
                  this.changeState(2);
               }
            }
            else if(this.mTimer >= 200)
            {
               this.changeState(0);
            }
         }
      }
      
      override protected function changeState(newState:int) : void
      {
         var viewMng:ViewMngPlanet = null;
         var origin:Vector3D = null;
         var dest:Vector3D = null;
         var vectorDist:Vector3D = null;
         var rayDist:Number = NaN;
         var startOffset:Number = NaN;
         var angle:Number = NaN;
         var color:int = 0;
         var thick:Number = NaN;
         var alpha:Number = NaN;
         var cosAngle:Number = NaN;
         var sinAngle:Number = NaN;
         var death:String = null;
         var rand:int = 0;
         var impactEffect:int = 0;
         switch(newState)
         {
            case 0:
               if(this.mDCRay != null)
               {
                  if((viewMng = InstanceMng.getViewMngPlanet()).contains(this.mDCRay))
                  {
                     viewMng.worldItemRemoveWeaponsEffect(this.mDCRay);
                  }
               }
               if((death = mUnit.mDef.getDeathType()) == "deathrandom")
               {
                  death = "death001";
                  switch((rand = Math.random() * 3) - 1)
                  {
                     case 0:
                        death = "death002";
                        break;
                     case 1:
                        death = "death004";
                  }
               }
               if(mTarget.mIsAlive && mUnit.mIsAlive)
               {
                  impactEffect = -1;
                  if(this.mBulletDef.mSku == "b_sniper_003")
                  {
                     impactEffect = 24;
                  }
                  else if(this.mBulletDef.mSku == "b_sniper_002")
                  {
                     impactEffect = 25;
                  }
                  mTarget.shotHit(mUnit.mDef.getShotDamage(),MyUnit.shotCreateUnitInfoObject(mUnit),true,death,impactEffect);
               }
               break;
            case 1:
               origin = new Vector3D(mUnit.mPositionDrawX + mCollIdX,mUnit.mPositionDrawY + mCollIdY);
               vectorDist = (dest = new Vector3D(mTarget.mPositionDrawX,mTarget.mPositionDrawY)).subtract(origin);
               if(this.mBulletDef.getDrawShotParticle())
               {
                  ParticleMng.addParticle(8,origin.x,origin.y);
               }
               if(this.mRay == null)
               {
                  this.mRay = new Shape();
               }
               rayDist = vectorDist.length / 3;
               startOffset = (vectorDist.length - rayDist) / 4;
               angle = Math.atan2(vectorDist.y,vectorDist.x);
               this.mRay.graphics.clear();
               color = parseInt(this.mBulletDef.getTailColor(),16);
               thick = this.mBulletDef.getLineThickness();
               alpha = 1;
               if(thick > 2)
               {
                  this.mRay.filters = [GameConstants.FILTER_GLOW_BLUE_LASER];
                  alpha = 0.9;
                  this.mRay.blendMode = "lighten";
               }
               this.mRay.graphics.lineStyle(thick,color,alpha);
               cosAngle = Math.cos(angle);
               sinAngle = Math.sin(angle);
               origin.x += cosAngle * startOffset;
               origin.y += sinAngle * startOffset;
               dest.x = origin.x + cosAngle * rayDist;
               dest.y = origin.y + sinAngle * rayDist;
               this.mRay.graphics.moveTo(origin.x,origin.y);
               this.mRay.graphics.lineTo(dest.x,dest.y);
               this.mRay.graphics.endFill();
               if(this.mDCRay == null)
               {
                  this.mDCRay = new DCDisplayObjectSWF(this.mRay);
               }
               break;
            case 2:
               if(this.mDCRay != null)
               {
                  if(!(viewMng = InstanceMng.getViewMngPlanet()).contains(this.mDCRay))
                  {
                     viewMng.worldItemAddWeaponsEffects(this.mDCRay);
                  }
               }
         }
         mState = newState;
      }
   }
}
