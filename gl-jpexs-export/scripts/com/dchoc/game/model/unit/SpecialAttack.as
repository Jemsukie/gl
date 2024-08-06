package com.dchoc.game.model.unit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.SpecialAttacksDef;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   
   public class SpecialAttack
   {
      
      protected static const TYPE_BULLETS:int = 0;
      
      protected static const TYPE_DROP:int = 1;
      
      protected static const STATE_WAITING_FOR_BEING_LAUNCHED:int = 0;
      
      protected static const STATE_WAITING_FOR_END_IMPACT:int = 1;
      
      protected static const STATE_END:int = 2;
      
      protected static const DROP_STATE_PRE_FALLING:int = 100;
      
      protected static const DROP_STATE_FALLING:int = 101;
      
      protected static const DROP_STATE_POST_FALLING:int = 102;
       
      
      private var mType:SecureInt;
      
      protected var mState:SecureInt;
      
      protected var mSpecialAttackDef:SpecialAttacksDef;
      
      protected var mTime:SecureInt;
      
      protected var mLaunchX:SecureInt;
      
      protected var mLaunchY:SecureInt;
      
      protected var mBulletType:String;
      
      private var mBullets:Vector.<MyUnit>;
      
      private var mFeatureSku:String;
      
      protected var mDropAnim:DCDisplayObject;
      
      protected var mDropCraterAdded:SecureBoolean;
      
      protected var mId:SecureInt;
      
      public function SpecialAttack(featureSku:String, time:int, launchX:int, launchY:int, specialAttackDef:SpecialAttacksDef, type:int = 0)
      {
         mType = new SecureInt("SpecialAttack.mType");
         mState = new SecureInt("SpecialAttack.mState",-1);
         mTime = new SecureInt("SpecialAttack.mTime");
         mLaunchX = new SecureInt("SpecialAttack.mLaunchX");
         mLaunchY = new SecureInt("SpecialAttack.mLaunchY");
         mDropCraterAdded = new SecureBoolean("SpecialAttack.mDropCraterAdded");
         mId = new SecureInt("SpecialAttack.mId",-1);
         super();
         this.mTime.value = time;
         this.mLaunchX.value = launchX;
         this.mLaunchY.value = launchY;
         this.mSpecialAttackDef = specialAttackDef;
         this.changeState(0);
         this.mType.value = type;
         this.mFeatureSku = featureSku;
      }
      
      public function unbuild() : void
      {
         this.changeState(2);
         this.mBullets = null;
         this.dropUnbuild();
      }
      
      public function getLaunchX() : int
      {
         return this.mLaunchX.value;
      }
      
      public function getLaunchY() : int
      {
         return this.mLaunchY.value;
      }
      
      public function setSpecialAttackDef(value:SpecialAttacksDef) : void
      {
         this.mSpecialAttackDef = value;
      }
      
      public function getSpecialAttackDef() : SpecialAttacksDef
      {
         return this.mSpecialAttackDef;
      }
      
      public function getUnits() : Vector.<MyUnit>
      {
         return null;
      }
      
      public function setUnits(value:Vector.<MyUnit>) : void
      {
      }
      
      public function isOver() : Boolean
      {
         return this.mState.value == 2;
      }
      
      protected function exitState(state:int) : void
      {
         this.dropExitState(state);
      }
      
      protected function enterState(state:int) : void
      {
         this.dropEnterState(state);
      }
      
      protected function changeState(newState:int) : void
      {
         if(newState != this.mState.value)
         {
            this.exitState(this.mState.value);
            this.mState.value = newState;
            this.enterState(this.mState.value);
         }
      }
      
      public function logicUpdate(dt:int) : void
      {
         var length:int = 0;
         var bullet:MyUnit = null;
         var i:int = 0;
         switch(this.mState.value)
         {
            case 0:
               if(this.mTime.value <= 0)
               {
                  this.launchAttack();
               }
               break;
            case 1:
               length = 0;
               if(this.mBullets != null)
               {
                  length = int(this.mBullets.length);
                  for(i = 0; i < length; )
                  {
                     if(!(bullet = this.mBullets[i]).mSecureIsInScene.value && !bullet.mIsAlive)
                     {
                        this.mBullets.splice(i,1);
                        length--;
                     }
                     else
                     {
                        i++;
                     }
                  }
               }
               if(length == 0)
               {
                  this.changeState(2);
                  break;
               }
         }
         this.dropLogicUpdate(dt);
      }
      
      protected function launchAttack() : void
      {
         switch(this.mType.value)
         {
            case 0:
               this.mBullets = this.launchUnits();
               this.changeState(1);
               break;
            case 1:
               this.changeState(100);
         }
      }
      
      protected function launchUnits() : Vector.<MyUnit>
      {
         var returnValue:Vector.<MyUnit> = null;
         if(this.mSpecialAttackDef != null)
         {
            returnValue = InstanceMng.getUnitScene().waveAddBulletsToScene(this.mSpecialAttackDef.getBulletTypes(),this.mLaunchX.value,this.mLaunchY.value,this.mId.value);
         }
         return returnValue;
      }
      
      public function getHasToDisableBattleEndButton() : Boolean
      {
         return this.mSpecialAttackDef == null ? false : this.mSpecialAttackDef.getHasToDisableBattleEndButton();
      }
      
      private function dropUnbuild() : void
      {
         this.mDropAnim = null;
      }
      
      protected function dropExitState(state:int) : void
      {
         switch(state - 101)
         {
            case 0:
            case 1:
               if(this.mDropAnim != null)
               {
                  InstanceMng.getViewMngPlanet().removeDropOnMapFromStage(this.mDropAnim);
                  this.mDropAnim = null;
                  break;
               }
         }
      }
      
      protected function dropEnterState(state:int) : void
      {
         var skuClip:String = null;
         switch(state - 100)
         {
            case 0:
               if(this.mFeatureSku != null)
               {
                  InstanceMng.getResourceMng().featureLoadResources(this.mFeatureSku);
               }
               this.mTime.value = 2000;
               break;
            case 1:
               this.mDropAnim = this.dropFallingGetAnim();
               if(this.mDropAnim == null)
               {
                  this.changeState(this.dropGetNextState(state));
               }
               else
               {
                  this.mDropAnim.x = this.mLaunchX.value;
                  this.mDropAnim.y = this.mLaunchY.value;
                  InstanceMng.getViewMngPlanet().addDropOnMapToStage(this.mDropAnim);
               }
               break;
            case 2:
               this.launchUnits();
               this.mDropAnim = this.dropPostFallingGetAnim();
               if(this.mDropAnim == null)
               {
                  this.changeState(this.dropGetNextState(state));
                  break;
               }
               skuClip = this.dropPostFallingGetClipSku();
               this.mDropAnim.x = this.mLaunchX.value;
               this.mDropAnim.y = this.mLaunchY.value;
               InstanceMng.getViewMngPlanet().addDropOnMapToStage(this.mDropAnim);
               break;
         }
         this.onEnterStateSoundFX(state);
      }
      
      protected function dropGetNextState(state:int) : int
      {
         var returnValue:int = 2;
         switch(state - 101)
         {
            case 0:
               returnValue = 102;
               break;
            case 1:
               returnValue = 2;
         }
         return returnValue;
      }
      
      protected function dropLogicUpdate(dt:int) : void
      {
         switch(this.mState.value - 100)
         {
            case 0:
               if(InstanceMng.getResourceMng().isResourceLoaded(this.dropFallingGetResourceSku()))
               {
                  this.changeState(101);
               }
               else
               {
                  this.mTime.value -= dt;
                  if(this.mTime.value <= 0)
                  {
                     this.changeState(this.dropGetNextState(101));
                  }
               }
               break;
            case 1:
               if(this.mDropAnim.isAnimationOver())
               {
                  this.changeState(this.dropGetNextState(this.mState.value));
               }
               break;
            case 2:
               if(this.dropCheckIfCraterHasToBePlaced())
               {
                  this.dropAddCrater();
                  this.mDropCraterAdded.value = true;
               }
               if(this.mDropAnim.isAnimationOver())
               {
                  this.changeState(2);
                  break;
               }
         }
      }
      
      protected function dropCheckIfCraterHasToBePlaced() : Boolean
      {
         return !this.mDropCraterAdded.value && this.dropCheckIfCraterHasToBePlacedDo();
      }
      
      protected function dropCheckIfCraterHasToBePlacedDo() : Boolean
      {
         return true;
      }
      
      protected function onEnterStateSoundFX(state:int) : void
      {
      }
      
      protected function dropFallingGetResourceSku() : String
      {
         var returnValue:String = null;
         if(this.mFeatureSku != null)
         {
            return InstanceMng.getResourceMng().featureGetResourceSkuSuffix(this.mFeatureSku,"_falling");
         }
         return returnValue;
      }
      
      protected function dropFallingGetClipSku() : String
      {
         var returnValue:String = null;
         if(this.mFeatureSku != null)
         {
            return InstanceMng.getResourceMng().featureGetClipSkuSuffix(this.mFeatureSku,"_falling");
         }
         return returnValue;
      }
      
      protected function dropPostFallingGetResourceSku() : String
      {
         var returnValue:String = null;
         if(this.mFeatureSku != null)
         {
            returnValue = InstanceMng.getResourceMng().featureGetResourceSkuSuffix(this.mFeatureSku,"_post_falling");
         }
         return returnValue;
      }
      
      protected function dropPostFallingGetClipSku() : String
      {
         var returnValue:String = null;
         if(this.mFeatureSku != null)
         {
            returnValue = InstanceMng.getResourceMng().featureGetClipSkuSuffix(this.mFeatureSku,"_post_falling");
         }
         return returnValue;
      }
      
      protected function dropFallingGetAnim() : DCDisplayObject
      {
         var returnValue:DCDisplayObject = null;
         var resourceSku:String = this.dropFallingGetResourceSku();
         if(resourceSku != null)
         {
            returnValue = InstanceMng.getResourceMng().getDCDisplayObject(resourceSku,this.dropFallingGetClipSku(),true);
         }
         return returnValue;
      }
      
      protected function dropPostFallingGetAnim() : DCDisplayObject
      {
         var returnValue:DCDisplayObject = null;
         var resourceSku:String = this.dropPostFallingGetResourceSku();
         if(resourceSku != null)
         {
            returnValue = InstanceMng.getResourceMng().getDCDisplayObject(resourceSku,this.dropPostFallingGetClipSku(),true);
         }
         return returnValue;
      }
      
      protected function dropCraterGetExpendableSku() : String
      {
         return null;
      }
      
      protected function dropAddCrater() : void
      {
         var expendableSku:String = this.dropCraterGetExpendableSku();
         if(expendableSku != null)
         {
            InstanceMng.getWorld().expendablesAddItem(expendableSku,this.mLaunchX.value,this.mLaunchY.value);
         }
      }
      
      public function getBullets() : Vector.<MyUnit>
      {
         return this.mBullets;
      }
      
      public function setId(id:int) : void
      {
         this.mId.value = id;
      }
      
      public function getId() : int
      {
         return this.mId.value;
      }
   }
}
