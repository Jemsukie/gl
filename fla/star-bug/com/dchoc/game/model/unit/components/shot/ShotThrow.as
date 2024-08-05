package com.dchoc.game.model.unit.components.shot
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.math.DCMath;
   import flash.display.Sprite;
   import flash.geom.Vector3D;
   
   public class ShotThrow extends UnitComponentShot
   {
      
      private static const SHOT_IMPACT:int = 0;
      
      private static const SHOT_END:int = 1;
       
      
      private var mState:int;
      
      private var mTarget:MyUnit;
      
      private var mRenderer:DCBitmapMovieClip;
      
      private var mAngle:Number;
      
      private var mRendererContainer:Sprite;
      
      private var mDCRendererContainer:DCDisplayObject;
      
      private var mSku:String;
      
      public function ShotThrow(sku:String)
      {
         super();
         this.mState = 1;
         this.mSku = sku;
         this.loadFlame();
      }
      
      private function loadFlame() : void
      {
         var assetName:String = "flamethrower";
         if(this.mSku == "b_poke_001")
         {
            assetName = "vomit";
         }
         this.mRenderer = InstanceMng.getEResourcesMng().getDCDisplayObject("units_effects","legacy",assetName,3) as DCBitmapMovieClip;
         if(this.mRenderer != null)
         {
            this.mRendererContainer = new Sprite();
            this.mRendererContainer.addChild(this.mRenderer.getDisplayObject());
            this.mDCRendererContainer = new DCDisplayObjectSWF(this.mRendererContainer);
            this.mRenderer.x = 0;
            this.mRenderer.y = 0;
         }
      }
      
      override protected function shootDo(u:MyUnit, target:MyUnit = null) : void
      {
         var flameX:Number = NaN;
         var flameY:Number = NaN;
         var renderData:DCBitmapMovieClip = null;
         var origin:Vector3D = null;
         var dest:Vector3D = null;
         var dist:Vector3D = null;
         var scale:int = 0;
         var rendererWidth:int = 0;
         var collBoxX:Number = NaN;
         var collBoxY:Number = NaN;
         if(this.mRenderer == null)
         {
            this.loadFlame();
         }
         if(this.mRenderer != null && target != null)
         {
            this.mState = 0;
            mUnit = u;
            this.mTarget = target;
            flameX = mUnit.mPositionDrawX;
            flameY = mUnit.mPositionDrawY;
            if((renderData = mUnit.getViewComponent().getCurrentRenderData()) != null)
            {
               collBoxX = mUnit.getViewComponent().getCurrentRenderData().getCollBoxX();
               collBoxY = mUnit.getViewComponent().getCurrentRenderData().getCollBoxY();
               flameX += renderData.getCollBoxX();
               flameY += renderData.getCollBoxY();
            }
            InstanceMng.getViewMngPlanet().worldItemAddWeaponsEffects(this.mDCRendererContainer);
            origin = new Vector3D(flameX,flameY);
            dist = (dest = new Vector3D(this.mTarget.mPositionDrawX,this.mTarget.mPositionDrawY)).subtract(origin);
            scale = 1;
            rendererWidth = this.mRenderer.getMaxWidth();
            if(dist.length > rendererWidth)
            {
               scale = dist.length / rendererWidth;
            }
            this.mRendererContainer.scaleX = scale;
            this.mAngle = Math.atan2(dist.y,dist.x);
            this.mRendererContainer.rotation = DCMath.rad2Degree(this.mAngle);
            this.mDCRendererContainer.setXY(flameX,flameY);
         }
      }
      
      override protected function logicUpdateDo(dt:int, u:MyUnit) : void
      {
         var params:Object = null;
         if(this.mState == 0)
         {
            if(this.mRenderer != null)
            {
               this.mRenderer.gotoAndStop(this.mRenderer.currentFrame + 1);
               if(this.mRenderer.totalFrames == this.mRenderer.currentFrame)
               {
                  this.stopShot();
                  if(this.mTarget != null && this.mTarget.mIsAlive)
                  {
                     this.mTarget.shotHit(mUnit.mDef.getShotDamage(),MyUnit.shotCreateUnitInfoObject(mUnit),false,"death006");
                     if(this.mUnit.mDef.shotEffectsBurnIsOn())
                     {
                        params = {};
                        params["attacker"] = this.mUnit;
                        InstanceMng.getUnitScene().effectsSwitch(this.mTarget,4,true,params);
                     }
                  }
                  this.mRenderer.gotoAndStop(1);
                  return;
               }
            }
         }
         if(this.mTarget != null && !this.mTarget.mIsAlive || mUnit != null && !mUnit.mIsAlive)
         {
            this.stopShot();
         }
      }
      
      override public function stopShot() : void
      {
         this.mState = 1;
         if(this.mRenderer != null)
         {
            InstanceMng.getViewMngPlanet().worldItemRemoveWeaponsEffect(this.mDCRendererContainer);
         }
      }
      
      override protected function unbuildDo(u:MyUnit) : void
      {
         this.stopShot();
         if(this.mRendererContainer != null && this.mRenderer != null)
         {
            this.mRendererContainer.removeChild(this.mRenderer.getDisplayObject());
         }
         this.mRenderer = null;
         this.mRendererContainer = null;
         this.mDCRendererContainer = null;
      }
      
      override public function isShotAllowed(u:MyUnit) : Boolean
      {
         return super.isShotAllowed(u) && this.mState == 1;
      }
   }
}
