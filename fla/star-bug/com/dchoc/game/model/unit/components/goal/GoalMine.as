package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   
   public class GoalMine extends UnitComponentGoal
   {
      
      private static const STATE_WAITING:int = 0;
      
      private static const STATE_EXPLODING:int = 1;
      
      private static const STATE_EXPLODED:int = 2;
       
      
      public function GoalMine(unit:MyUnit)
      {
         super(unit);
      }
      
      override public function activate() : void
      {
         changeState(0);
      }
      
      public function hasBeenActivated() : Boolean
      {
         return mCurrentState != 0;
      }
      
      private function getAnimBase(u:MyUnit) : DCDisplayObject
      {
         var worldItem:WorldItemObject = u.mData[35];
         return worldItem.viewLayersAnimGet(1);
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         var data:Array = null;
         var unitNearest:MyUnit = null;
         var unitNearestIsEnemy:Boolean = false;
         var unitNearestDistanceSqr:Number = NaN;
         var distanceShotSqr:Number = NaN;
         var newState:int = 0;
         var anim:DCDisplayObject = null;
         var unitItem:WorldItemObject = null;
         switch(mCurrentState)
         {
            case 0:
               unitNearest = (data = u.mData)[1];
               unitNearestIsEnemy = unitNearest != null && unitNearest.mFaction != u.mFaction;
               unitNearestDistanceSqr = Number(data[2]);
               if(unitNearestIsEnemy)
               {
                  distanceShotSqr = unitNearest.getBoundingRadius() + 46;
                  distanceShotSqr *= distanceShotSqr;
                  if(unitNearestDistanceSqr < distanceShotSqr)
                  {
                     newState = 2;
                     if(u.mDef.belongsToGroup("mineExploAnim"))
                     {
                        if(this.getAnimBase(u) != null)
                        {
                           newState = 1;
                        }
                     }
                     else
                     {
                        ParticleMng.startModularParticles(mUnit.mData[35]);
                     }
                     SoundManager.getInstance().playSound("explode.mp3");
                     changeState(newState);
                  }
               }
               break;
            case 1:
               if((anim = this.getAnimBase(u)) == null || anim.currentFrame > anim.totalFrames >> 1)
               {
                  changeState(2);
               }
               break;
            case 2:
               if(u.mDef.belongsToGroup("mineExploAnim"))
               {
                  if((unitItem = u.mData[35]).viewIsAnimInLayerOver(1))
                  {
                     InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorld(),{
                        "cmd":"WorldEventDemolishItem",
                        "item":unitItem,
                        "notifyServer":false
                     },true);
                  }
                  break;
               }
         }
      }
      
      override protected function enterState(newState:int) : void
      {
         var goalParams:Object = null;
         var worldItem:WorldItemObject = mUnit.mData[35];
         loop0:
         switch(newState - 1)
         {
            case 0:
               switch(mUnit.mDef.getAnimationDefSku())
               {
                  case "mineFlying":
                     worldItem.viewSetBase(39);
                     break loop0;
                  case "minePumpkin":
                     worldItem.viewSetBase(43);
               }
               break;
            case 1:
               goalParams = {
                  "affectsArea":true,
                  "hasExploded":true,
                  "hasUnitEffect":mUnit.mDef.shotEffectsStunIsOn()
               };
               if(mUnit.mDef.shotEffectsStunIsOn())
               {
                  goalParams.freeze = {
                     "durationMs":mUnit.mDef.shotEffectsGetStunDuration(),
                     "moveMultiplier":0.001,
                     "fireRateMultiplier":0,
                     "viewType":"stun"
                  };
               }
               MyUnit.smUnitScene.bulletsShoot("b_rocket_001",mUnit.mDef.getShotDamage(),"unitGoalImpact",goalParams,mUnit,null,0,false,false);
               if(worldItem != null)
               {
                  InstanceMng.getUserDataMng().updateBattle_itemMineExploded(int(worldItem.mSid));
                  if(!mUnit.mDef.belongsToGroup("mineExploAnim"))
                  {
                     InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorld(),{
                        "cmd":"WorldEventDemolishItem",
                        "item":worldItem,
                        "notifyServer":false
                     },true);
                  }
               }
         }
      }
      
      override public function notify(e:Object) : void
      {
         switch(e.cmd)
         {
            case "battleArmyEventRetreatAfterWinning":
            case "battleArmyEventFinish":
               if(mCurrentState == 1)
               {
                  changeState(2);
               }
         }
      }
   }
}
