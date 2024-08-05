package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.rule.AnimationsDef;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.unit.components.UnitComponent;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.unit.components.view.UnitComponentView;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.geom.Vector3D;
   
   public class UnitComponentGoal extends UnitComponent
   {
      
      protected static const STATE_RETREATING:int = -4;
      
      protected static const STATE_RETREATING_AFTER_WINNING:int = -5;
      
      protected static const STATE_PRERETREATING_AFTER_WINNING:int = -70;
      
      public static const STATE_BATTLE_USER_ACTION:int = -69;
      
      public static const TASKS_NONE:int = -1;
      
      public static const TASKS_EXIT_IMMEDIATELY:int = 0;
      
      public static const TASKS_EXIT_FADEOUT:int = 1;
      
      public static const TASKS_STOP:int = 2;
       
      
      protected var mIsDying:Boolean;
      
      public var mCurrentState:int;
      
      private var mEmoteUsed:Boolean;
      
      private var mEmoteCountdown:int;
      
      private var mRetreatTimer:int;
      
      public function UnitComponentGoal(unit:MyUnit)
      {
         super(unit);
      }
      
      override protected function buildDo(def:UnitDef, u:MyUnit) : void
      {
         super.buildDo(def,u);
         this.activate();
      }
      
      override public function reset(u:MyUnit) : void
      {
         this.mCurrentState = -1;
         this.mIsDying = false;
         this.mEmoteUsed = false;
         this.mEmoteCountdown = 2000 + Math.random() * 8000;
         this.mRetreatTimer = 10000;
      }
      
      public function activate() : void
      {
         this.reset(mUnit);
         mUnit.setLookingForATargetEnabled(true);
      }
      
      public function deactivate() : void
      {
      }
      
      public function changeState(state:int) : void
      {
         if(this.isAValidState(state))
         {
            if(this.mCurrentState > -1)
            {
               this.exitState(this.mCurrentState);
            }
            this.mCurrentState = state;
            this.enterState(state);
         }
      }
      
      protected function isAValidState(state:int) : Boolean
      {
         return !this.mIsDying;
      }
      
      protected function exitState(state:int) : void
      {
      }
      
      protected function enterState(newState:int) : void
      {
         var moveComp:UnitComponentMovement = null;
         switch(newState - -5)
         {
            case 0:
            case 1:
               moveComp = mUnit.getMovementComponent();
               if(moveComp != null)
               {
                  if(newState == -4)
                  {
                     moveComp.goToPosition(new Vector3D(0,0));
                  }
                  else
                  {
                     moveComp.stop();
                     newState = this.mCurrentState = -70;
                  }
               }
               mUnit.shotStop();
               mUnit.blockLiveBar(true);
         }
      }
      
      public function moveFollowPath(hasArrivedTask:int = 2) : void
      {
      }
      
      protected function moveStop(anim:String = "still", play:Boolean = true) : void
      {
      }
      
      override protected function logicUpdateDo(dt:int, u:MyUnit) : void
      {
         var moveComp:UnitComponentMovement = null;
         var emotes:Array = null;
         if(this.mIsDying)
         {
            if(!mUnit.getViewComponent().isPlayingAnyDeadAnim())
            {
               mUnit.markToBeReleasedFromScene();
            }
         }
         else
         {
            switch(this.mCurrentState)
            {
               case -4:
                  if(!this.mEmoteUsed && this.mEmoteCountdown > 0)
                  {
                     this.mEmoteCountdown -= dt;
                     if(this.mEmoteCountdown <= 0)
                     {
                        if(Math.random() < 0.5)
                        {
                           mUnit.showEmoticon(13,1500);
                        }
                        this.mEmoteUsed = true;
                     }
                  }
                  break;
               case -70:
                  if((moveComp = mUnit.getMovementComponent()) != null)
                  {
                     moveComp.setMaxSpeed(0.25);
                  }
                  if(!this.mEmoteUsed && this.mEmoteCountdown > 0)
                  {
                     this.mEmoteCountdown -= dt * 4;
                     if(this.mEmoteCountdown <= 0)
                     {
                        emotes = [10,1,16,3,2,undefined,21,20];
                        mUnit.showEmoticon(emotes[uint(Math.random() * (emotes.length - 1))],1500);
                        this.mEmoteUsed = true;
                     }
                  }
                  break;
               case -5:
                  this.logicUpdateRetreatingAfterWinning(dt);
                  break;
               default:
                  this.logicUpdateDoDo(dt,u);
            }
         }
      }
      
      protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
      }
      
      protected function logicUpdateRetreatingAfterWinning(dt:int) : void
      {
         var viewComp:UnitComponentView = null;
         if(mUnit.getMovementComponent() != null)
         {
            viewComp = mUnit.getViewComponent();
            if(viewComp != null && !viewComp.isInScreen())
            {
               mUnit.exitSceneStart();
            }
         }
      }
      
      protected function animSetId(animId:String, play:Boolean = true, loop:Boolean = true) : void
      {
         var animData:Object = null;
         var anims:Object = null;
         var viewComponent:UnitComponentView;
         if((viewComponent = mUnit.getViewComponent()) != null)
         {
            if((animData = mUnit.mDef.getAnimation(animId)) != null)
            {
               if(animId != null && animId.indexOf("death") > -1 && !mUnit.mDef.belongsToGroup("hasOwnDeathAnim"))
               {
                  viewComponent.setRenderData("deaths",animData.className);
                  viewComponent.setAnimationId(animId,0,play);
                  viewComponent.setFrameRate(2);
               }
               else
               {
                  viewComponent.setRenderData(mUnit.mDef.getAssetId(),animData.className);
                  this.animDoSetId(animId,play,loop);
                  if(animId != null && animId.indexOf("death") > -1)
                  {
                     viewComponent.setFrameRate(1);
                  }
               }
            }
         }
      }
      
      protected function animDoSetId(animId:String, play:Boolean = true, loop:Boolean = true) : void
      {
         var viewComponent:UnitComponentView;
         if((viewComponent = mUnit.getViewComponent()) != null)
         {
            viewComponent.setAnimationId(animId,-1,play,loop);
         }
      }
      
      protected function tasksPerform(id:int) : void
      {
         switch(id)
         {
            case 0:
               mUnit.exitSceneStart(0);
               break;
            case 1:
               mUnit.exitSceneStart(1);
               break;
            case 2:
               this.moveStop();
         }
      }
      
      public function die(type:String) : void
      {
         var renderData:DCBitmapMovieClip = null;
         var viewComp:UnitComponentView = mUnit.getViewComponent();
         var animDef:AnimationsDef;
         if((animDef = mUnit.mDef.getAnimationDef()) != null && animDef.getAnimation(type) != null && viewComp != null)
         {
            this.mIsDying = true;
            mUnit.mIsAlive = false;
            this.animSetId(type);
            viewComp.setLoopMode(false);
            mUnit.getMovementComponent().setMaxSpeed(0);
            mUnit.showEmoticon(21,500);
            if(type == "death005" || type == "death006")
            {
               renderData = viewComp.getCurrentRenderData();
               if(renderData != null)
               {
                  renderData.filters = null;
               }
            }
            if(mUnit.mDef.getAmmoSku() == "b_blast_001")
            {
               ParticleMng.addParticle(7,mUnit.mPositionDrawX,mUnit.mPositionDrawY);
               if(Config.USE_SOUNDS)
               {
                  SoundManager.getInstance().playSound("explode.mp3");
               }
            }
         }
         else
         {
            if(mUnit.getTypeId() == 7)
            {
               ParticleMng.addParticle(7,mUnit.mPositionDrawX,mUnit.mPositionDrawY);
               if(Config.USE_SOUNDS)
               {
                  SoundManager.getInstance().playSound("explode.mp3");
               }
            }
            else if(mUnit.getTypeId() == 2)
            {
               ParticleMng.addParticle(18,mUnit.mPositionDrawX,mUnit.mPositionDrawY,0);
               if(Config.USE_SOUNDS)
               {
                  SoundManager.getInstance().playSound("explode.mp3");
               }
            }
            mUnit.markToBeReleasedFromScene();
         }
      }
      
      public function goToItem(itemTo:WorldItemObject, itemFrom:WorldItemObject = null, changeState:Boolean = true) : void
      {
         mUnit.setGoalComponent(new GoalLookingForHangar(mUnit,itemFrom,itemTo,false,true,false));
      }
      
      protected function separateUnitsFromEachOther(checkMap:Boolean) : void
      {
         var coor:DCCoordinate = null;
         var tileIndex:int = 0;
         var tileData:TileData = null;
         if(false)
         {
            return;
         }
         var nearUnit:MyUnit;
         var data:Array;
         if((nearUnit = (data = mUnit.mData)[7]) == null || !nearUnit.mIsAlive)
         {
            return;
         }
         var nearUnitDistanceSqr:Number = Number(data[8]);
         var panicDistanceSqr:Number = mUnit.getPanicDistance() + nearUnit.getPanicDistance();
         panicDistanceSqr *= panicDistanceSqr;
         if(nearUnitDistanceSqr >= panicDistanceSqr)
         {
            return;
         }
         var uPosX:Number = mUnit.mPosition.x;
         var uPosY:Number = mUnit.mPosition.y;
         var angle:Number = Math.atan2(nearUnit.mPosition.y - uPosY,nearUnit.mPosition.x - uPosX);
         var offX:Number = -Math.cos(angle);
         var offY:Number = -Math.sin(angle);
         var force:Number = 1;
         if(nearUnitDistanceSqr > 0)
         {
            force = Math.min(22,panicDistanceSqr / nearUnitDistanceSqr);
         }
         force *= 0.2;
         offX *= force;
         offY *= force;
         uPosX += offX;
         uPosY += offY;
         var moveComp:UnitComponentMovement = mUnit.getMovementComponent();
         if(checkMap)
         {
            coor = MyUnit.smCoor;
            coor.x = uPosX;
            coor.y = uPosY;
            coor.z = 0;
            tileIndex = UnitScene.smViewMng.logicPosToTileIndex(coor);
            if((tileData = UnitScene.smMapModel.getTileDataFromIndex(tileIndex)) == null || UnitScene.smMapModel.logicTilesCanBeStepped(tileIndex))
            {
               mUnit.setPosition(uPosX,uPosY);
               moveComp.mOldPosition.x += offX;
               moveComp.mOldPosition.y += offY;
            }
         }
         else
         {
            mUnit.setPosition(uPosX,uPosY);
            moveComp.mOldPosition.x += offX;
            moveComp.mOldPosition.y += offY;
         }
      }
      
      override public function notify(e:Object) : void
      {
         switch(e.cmd)
         {
            case "battleArmyEvenRetreat":
               this.changeState(-4);
               break;
            case "battleArmyEventRetreatAfterWinning":
               this.changeState(-5);
         }
      }
   }
}
