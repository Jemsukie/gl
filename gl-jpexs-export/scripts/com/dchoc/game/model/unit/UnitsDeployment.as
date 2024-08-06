package com.dchoc.game.model.unit
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.MapModel;
   import com.dchoc.toolkit.core.media.SoundManager;
   
   public class UnitsDeployment
   {
      
      private static const DEPLOY_NONE:uint = 0;
      
      private static const DEPLOY_WAIT_FOR_THE_CAMERA:uint = 1;
      
      private static const DEPLOY_START:uint = 2;
      
      private static const DEPLOY_DROPPING:uint = 3;
      
      private static const DEPLOY_CLOSE:uint = 4;
      
      private static const DEPLOY_END:uint = 5;
      
      public static const DEPLOY_TYPE_NONE:int = -1;
      
      public static const DEPLOY_TYPE_USER_ATTACK:int = 0;
      
      public static const DEPLOY_TYPE_NPC_ATTACK:int = 1;
      
      public static const DEPLOY_TYPE_TUTORIAL_ATTACK:int = 2;
      
      public static const DEPLOY_TYPE_UNITS_RETURNING_TO_HANGAR:int = 3;
      
      private static var smMapModel:MapModel;
      
      private static var smUnitScene:UnitScene;
       
      
      private var mDeployX:Number;
      
      private var mDeployY:Number;
      
      private var mDropDone:Boolean;
      
      private var mDropWaitTime:int;
      
      private var mDeployWaveString:String;
      
      private var mDeployType:int;
      
      private var mDeployParams:Object;
      
      public var mIsActive:Boolean;
      
      private var mCurrentState:int;
      
      public var mWarpGateIndex:int;
      
      private var mCameraTargetX:int;
      
      private var mCameraTargetY:int;
      
      public function UnitsDeployment()
      {
         super();
         if(smMapModel == null)
         {
            smMapModel = InstanceMng.getMapModel();
            smUnitScene = InstanceMng.getUnitScene();
         }
      }
      
      public static function unloadStatic() : void
      {
         smMapModel = null;
         smUnitScene = null;
      }
      
      public function getIsWaveLaunched() : Boolean
      {
         return this.mCurrentState != 0;
      }
      
      public function copyFrom(another:UnitsDeployment) : void
      {
         this.mDeployX = another.mDeployX;
         this.mDeployY = another.mDeployY;
         this.mDropDone = another.mDropDone;
         this.mDropWaitTime = another.mDropWaitTime;
         this.mDeployWaveString = another.mDeployWaveString;
         this.mDeployType = another.mDeployType;
         this.mDeployParams = another.mDeployParams;
         this.mIsActive = another.mIsActive;
         this.mCurrentState = another.mCurrentState;
      }
      
      public function startDeployUnits(x:Number, y:Number, waveToDeploy:String = "", deployType:int = -1, deployParams:Object = null, waitForTheCamera:Boolean = false) : void
      {
         var mapController:MapControllerPlanet = null;
         this.mDeployX = x;
         this.mDeployY = y;
         this.mDeployWaveString = waveToDeploy;
         this.mDeployType = deployType;
         this.mDeployParams = deployParams;
         this.changeState(waitForTheCamera ? 1 : 2);
         this.mIsActive = true;
         if(waitForTheCamera)
         {
            mapController = InstanceMng.getMapControllerPlanet();
            this.mCameraTargetX = mapController.cameraGetTargetX();
            this.mCameraTargetY = mapController.cameraGetTargetY();
         }
      }
      
      private function changeState(newState:int) : void
      {
         switch(newState)
         {
            case 0:
               this.mWarpGateIndex = -1;
               this.mIsActive = false;
               break;
            case 2:
               this.mWarpGateIndex = smUnitScene.mWarpGateMng.openWarpGate(this.mDeployX,this.mDeployY);
               if(this.mWarpGateIndex == -1)
               {
                  newState = 0;
                  break;
               }
               this.mDropWaitTime = 300;
               this.mDropDone = false;
               if(Config.USE_SOUNDS)
               {
                  SoundManager.getInstance().playSound("warp.mp3");
               }
               break;
         }
         this.mCurrentState = newState;
      }
      
      public function deployLogicUpdate(dt:int) : void
      {
         switch(this.mCurrentState - 1)
         {
            case 0:
               if(!smMapModel.mMapController.cameraIsThisPosTheTargetPos(this.mCameraTargetX,this.mCameraTargetY) || smMapModel.mMapController.cameraHasReachedTheTarget())
               {
                  this.changeState(2);
               }
               break;
            case 1:
               if(smUnitScene.mWarpGateMng.getWarpGateState(this.mWarpGateIndex) == 2)
               {
                  this.changeState(3);
               }
               break;
            case 2:
               if(!this.mDropDone)
               {
                  this.dropUnit();
               }
               else
               {
                  this.mDropWaitTime -= dt;
                  if(this.mDropWaitTime <= 0)
                  {
                     this.changeState(4);
                  }
               }
               break;
            case 3:
               if(smUnitScene.mWarpGateMng.getWarpGateState(this.mWarpGateIndex) == 0)
               {
                  this.changeState(0);
                  break;
               }
         }
      }
      
      private function dropUnit() : void
      {
         smUnitScene.deployDropUnits(this.mDeployX,this.mDeployY,this.mDeployWaveString,this.mDeployType,this.mDeployParams);
         this.mDropDone = true;
      }
      
      public function forceEnd() : void
      {
         if(this.mIsActive && !this.mDropDone)
         {
            this.dropUnit();
         }
         this.changeState(0);
      }
   }
}
