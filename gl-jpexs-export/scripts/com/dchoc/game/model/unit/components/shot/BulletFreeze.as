package com.dchoc.game.model.unit.components.shot
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.display.Sprite;
   import flash.geom.Vector3D;
   
   public class BulletFreeze extends Bullet
   {
      
      private static const TIME_TO_ARRIVE:int = 500;
       
      
      private var mBullet:DCBitmapMovieClip;
      
      private var mContainer:DCDisplayObject;
      
      private var mSprCont:Sprite;
      
      private var mSpeedX:Number;
      
      private var mSpeedY:Number;
      
      private var mDest:Vector3D;
      
      private var mDirection:Vector3D;
      
      private var mPosition:Vector3D;
      
      private var mShotDist:Number;
      
      private var mCoor:DCCoordinate;
      
      public function BulletFreeze(u:MyUnit, target:MyUnit, collId:int = 0)
      {
         super(u,target,collId);
         this.mCoor = MyUnit.smCoor;
         this.mBullet = InstanceMng.getEResourcesMng().getDCDisplayObject("units_effects","legacy","bullet_freeze",3) as DCBitmapMovieClip;
         this.mSprCont = new Sprite();
         this.mSprCont.addChild(this.mBullet.getDisplayObject());
         this.mPosition = new Vector3D(mUnit.mPosition.x + mLogicCollX,mUnit.mPosition.y + mLogicCollY);
         this.mDest = new Vector3D(mTarget.mPosition.x,mTarget.mPosition.y);
         this.mDirection = this.mDest.subtract(this.mPosition);
         this.mDirection.normalize();
         this.mShotDist = InstanceMng.getPowerUpMng().unitsGetAmountForActivePowerUpByUnitSkuAndPowerUpType(mUnit.mDef.mSku,1,"turretsExtraRange",mUnit.mDef.getShotDistance());
         var speed:Number = this.mShotDist / 500;
         this.mCoor.x = this.mDirection.x;
         this.mCoor.y = this.mDirection.y;
         this.mCoor = InstanceMng.getViewMngPlanet().logicPosToViewPos(this.mCoor);
         var angle:Number = Math.atan2(this.mDirection.y,this.mDirection.x);
         this.mSpeedX = Math.cos(angle) * speed;
         this.mSpeedY = Math.sin(angle) * speed;
         var origin:Vector3D = new Vector3D(mUnit.mPositionDrawX + mCollIdX,mUnit.mPositionDrawY + mCollIdY);
         var dest:Vector3D;
         var direct:Vector3D = (dest = new Vector3D(mTarget.mPositionDrawX,mTarget.mPositionDrawY)).subtract(origin);
         var viewAngle:Number = Math.atan2(direct.y,direct.x);
         var frame:int = this.calculateBulletFrame(this.mPosition,this.mDest);
         this.mBullet.gotoAndStop(frame);
         var offsetX:Number = this.mSprCont.width;
         var offsetY:Number = this.mSprCont.height;
         this.mSprCont.rotation = DCMath.rad2Degree(viewAngle);
         this.mContainer = new DCDisplayObjectSWF(this.mSprCont);
         this.mCoor.x = this.mPosition.x;
         this.mCoor.y = this.mPosition.y;
         this.mCoor = InstanceMng.getViewMngPlanet().logicPosToViewPos(this.mCoor);
         this.mBullet.x = 0;
         this.mBullet.y = 0;
         this.mSprCont.x = this.mCoor.x + offsetX;
         this.mSprCont.y = this.mCoor.y + offsetY;
         InstanceMng.getViewMngPlanet().worldItemAddWeaponsEffects(this.mContainer);
         if(Config.USE_SOUNDS)
         {
            SoundManager.getInstance().playSound("freeze.mp3");
         }
      }
      
      private function calculateBulletFrame(origin:Vector3D, dest:Vector3D) : int
      {
         this.mDirection = dest.subtract(origin);
         var totalFrames:int = this.mBullet.totalFrames;
         var part:Number = this.mShotDist / totalFrames;
         var dist:Number = this.mDirection.length;
         var frame:*;
         if((frame = totalFrames - dist / part + 1) > totalFrames)
         {
            frame = totalFrames;
         }
         else if(frame <= 0)
         {
            frame = 1;
         }
         return frame;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         this.mPosition.x += this.mSpeedX * dt;
         this.mPosition.y += this.mSpeedY * dt;
         this.mDirection = this.mDest.subtract(this.mPosition);
         var dist:Number = this.mDirection.length;
         this.mCoor = MyUnit.smCoor;
         this.mCoor.x = this.mPosition.x;
         this.mCoor.y = this.mPosition.y;
         this.mCoor = InstanceMng.getViewMngPlanet().logicPosToViewPos(this.mCoor);
         this.mSprCont.x = this.mCoor.x;
         this.mSprCont.y = this.mCoor.y;
         if(dist < mTarget.getBoundingRadius() + mUnit.getBoundingRadius())
         {
            mAlive = false;
            mTarget.shotHit(mUnit.mDef.getShotDamage(),MyUnit.shotCreateUnitInfoObject(mUnit));
            ParticleMng.addParticle(20,mTarget.mPositionDrawX,mTarget.mPositionDrawY);
            InstanceMng.getViewMngPlanet().worldItemRemoveWeaponsEffect(this.mContainer);
            return;
         }
         var frame:int = this.calculateBulletFrame(this.mPosition,this.mDest);
         if(frame != this.mBullet.currentFrame)
         {
            this.mBullet.gotoAndStop(frame);
         }
      }
      
      override public function unbuild() : void
      {
         this.mSprCont.removeChild(this.mBullet.getDisplayObject());
         this.mSprCont = null;
         this.mContainer = null;
         this.mBullet = null;
         this.mDest = null;
         this.mPosition = null;
         this.mDirection = null;
      }
   }
}
