package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.shot.ShotLaser;
   import com.dchoc.game.model.unit.components.shot.UnitComponentShot;
   import com.dchoc.game.model.unit.components.view.UnitComponentView;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import flash.geom.Vector3D;
   
   public class GoalDefense extends UnitComponentGoal
   {
      
      private static const STATE_READY_FOR_SHOOT:int = 0;
      
      private static const STATE_SHOOTING:int = 1;
      
      private static const STATE_LOADING_WEAPON:int = 2;
      
      private static const STATE_START:int = 0;
      
      private static const STATE_END:int = 2;
       
      
      private var mHeading:Vector3D;
      
      private var mNeedLoadWeapon:Boolean;
      
      public function GoalDefense(unit:MyUnit)
      {
         super(unit);
      }
      
      override protected function load() : void
      {
         this.mHeading = new Vector3D(1,0,0);
      }
      
      override public function unload() : void
      {
         this.mHeading = null;
      }
      
      override public function activate() : void
      {
         super.activate();
         changeState(0);
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         var unitNearestIsEnemy:Boolean = false;
         var spinTarget:Number = NaN;
         var shootAllowed:* = false;
         var diff:Number = NaN;
         var label:String = null;
         var viewComponent:UnitComponentView = null;
         var shotComp:UnitComponentShot = null;
         var renderData:DCBitmapMovieClip = null;
         var data:Array;
         var unitNearest:MyUnit = (data = u.mData)[3];
         this.mNeedLoadWeapon = u.mDef.getAnimation("load") != null;
         switch(mCurrentState)
         {
            case 0:
               unitNearestIsEnemy = unitNearest != null && unitNearest.mFaction == 0;
               spinTarget = Number(data[19]);
               if(unitNearestIsEnemy && unitNearest.mIsAlive)
               {
                  u.spinSetTargetAngle(spinTarget);
                  if(u.getShotComponent().isShotAllowed(u))
                  {
                     if(u.mDef.mSku == "df_001_007")
                     {
                        changeState(2);
                     }
                     shootAllowed = u.mData[19] == -1;
                     if(!shootAllowed)
                     {
                        diff = u.mData[18] - u.mData[19];
                        shootAllowed = Math.abs(diff) < 0.1;
                     }
                     if(shootAllowed)
                     {
                        if(u.mData[19] != -1)
                        {
                           u.spinSetAngle(u.mData[19],true);
                        }
                        if(this.mNeedLoadWeapon)
                        {
                           changeState(2);
                        }
                        else
                        {
                           changeState(1);
                        }
                     }
                  }
               }
               break;
            case 1:
               if(u.mDef.getAmmoSku() == "b_laser_001")
               {
                  shotComp = u.getShotComponent();
                  if(ShotLaser(shotComp).mState == 0)
                  {
                     changeState(0);
                  }
               }
               else if((renderData = (viewComponent = mUnit.getViewComponent()).getCurrentRenderData()) == null)
               {
                  u.shotShoot(unitNearest);
               }
               else if(!viewComponent.isPlayingAnimId("shooting"))
               {
                  changeState(0);
               }
               else if((label = renderData.getCurrentLabel()) != null && label.indexOf("shoot") > -1)
               {
                  u.shotShoot(unitNearest);
               }
               break;
            case 2:
               if(!(viewComponent = u.getViewComponent()).isBuilt() || !viewComponent.isPlayingAnimId("load"))
               {
                  if(unitNearest != null && unitNearest.mIsAlive)
                  {
                     changeState(1);
                     break;
                  }
                  changeState(0);
                  break;
               }
         }
      }
      
      override protected function enterState(newState:int) : void
      {
         var data:Array = mUnit.mData;
         var unitNearest:MyUnit = data[3];
         switch(newState)
         {
            case 0:
               animSetId("still");
               break;
            case 1:
               animSetId("shooting");
               if(mUnit.mDef.getAmmoSku() == "b_laser_001")
               {
                  mUnit.shotShoot(unitNearest);
                  mUnit.getViewComponent().setLoopMode(true);
               }
               else
               {
                  mUnit.getViewComponent().setLoopMode(false);
               }
               break;
            case 2:
               animSetId("load");
               mUnit.getViewComponent().setLoopMode(false);
         }
      }
      
      override public function getHeading() : Vector3D
      {
         return this.mHeading;
      }
      
      override protected function isAValidState(state:int) : Boolean
      {
         return state >= 0 && state <= 2;
      }
   }
}
