package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.MapModel;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.geom.Vector3D;
   
   public class GoalCivil extends GoalTerrainUnit
   {
      
      public static const STATE_WALKING:int = 100;
      
      public static const STATE_FLEEING:int = 101;
      
      public static const STATE_JUMP_SCARED:int = 102;
      
      public static const STATE_SLEEPING:int = 103;
      
      public static const STATE_TALKING:int = 104;
      
      public static const STATE_JUMPING:int = 105;
      
      public static const STATE_IDLE:int = 106;
      
      public static const STATE_ALERTED:int = 107;
      
      public static const STATE_JUMPING_ANNOYED:int = 108;
      
      public static const STATE_JOY:int = 109;
      
      public static const STATE_RUN:int = 110;
      
      public static const STATE_GOING_HOME:int = 111;
      
      public static const STATE_GOING_ATTRACTION:int = 112;
      
      public static const STATE_USING_ATTRACTION:int = 113;
      
      public static const STATE_LEAVING_ATTRACTION:int = 114;
      
      private static const FLEE_REACTION_DISTANCE:int = 350;
      
      private static const FLEE_REACTION_DISTANCE_SQR:int = 122500;
      
      private static const FLEE_SENSE_INTERVAL:int = 1000;
      
      private static const FLEE_DISTANCE:int = 550;
      
      private static const TALK_SENSE_INTERVAL:int = 2000;
      
      private static const TALK_DISTANCE:int = 50;
      
      private static const TALK_WAITTIME:int = 45000;
      
      private static const TALK_PROBABILITY:Number = 0.2;
      
      private static const TALK_ICON_INTERVAL:int = 1500;
      
      private static const USE_ATTRACTION_PROBABILITY:Number = 0.2;
      
      private static const USE_ATTRACTION_INTERVAL:Number = 45000;
      
      private static const ATTRACTION_TIME:Number = 30000;
       
      
      private var mTimePerState:int;
      
      private var mHome:WorldItemObject = null;
      
      private var mTalkUnit:MyUnit;
      
      private var mTargetUnit:MyUnit;
      
      private var mDestinyViewPos:Vector3D;
      
      private var mOldState:int;
      
      private var mTimeInIdle:int;
      
      private var mTimeSinceTalk:int;
      
      private var mSenseTime:int;
      
      private var mAlerted:Boolean;
      
      private var mThreat:Vector3D;
      
      private var mEmoTime:int = 0;
      
      private var mAlreadyUsedEmote:Boolean;
      
      private var mTalkOffset:int = 0;
      
      private var mAnnoyment:int = 0;
      
      private var mConversations:Array;
      
      private var mCurrentConversation:int;
      
      private var mCurrentEmote:int;
      
      private var mConversationMaster:Boolean;
      
      private var mTotalLifeTime:int;
      
      private var mAttractionTimer:int;
      
      private var mCurrentAttraction:WorldItemObject;
      
      private var mNeedsToBeMadeVisible:Boolean;
      
      public function GoalCivil(unit:MyUnit)
      {
         this.mThreat = new Vector3D();
         super(unit,false,1);
         this.mDestinyViewPos = new Vector3D();
      }
      
      override public function activate() : void
      {
         super.activate();
         this.mOldState = mCurrentState = 100;
         this.mSenseTime = Math.random();
         this.mTimeInIdle = 0;
         this.mTimeSinceTalk = 0;
         this.mAlerted = false;
         this.mTimePerState = 1000;
         this.mAlreadyUsedEmote = false;
         this.mAnnoyment = 0;
         this.mTotalLifeTime = 0;
         this.mAttractionTimer = Math.random() * 45000;
         this.mCurrentAttraction = null;
         this.mNeedsToBeMadeVisible = false;
         this.mConversations = new Array(22);
         this.mConversations[0] = [9,11,3,17];
         this.mConversations[1] = [15,10,5,11,8];
         this.mConversations[2] = [1,2,4,undefined,11,13,17];
         this.mConversations[3] = [15,14,16];
         this.mConversations[4] = [7,3,11];
         this.mConversations[5] = [19,18,11,13];
         this.mConversations[6] = [18,16];
         this.mConversations[7] = [9,16];
         this.mConversations[8] = [1,2,6];
         this.mConversations[9] = [8,11,16,17];
         this.mConversations[10] = [5,3,7,10];
         this.mConversations[11] = [15,14,17];
         this.mConversations[12] = [8,2,13];
         this.mConversations[13] = [11,9,9,16];
         this.mConversations[14] = [11,9,17,17];
         this.mConversations[15] = [7,16,3,16,9,17];
         this.mConversations[16] = [5,10,11,15,8,16];
         this.mConversations[17] = [8,11,7,9];
         this.mConversations[18] = [15,14,3,16];
         this.mConversations[19] = [22,11,9,9];
         this.mConversations[20] = [20,1,13];
         this.mConversations[21] = [22,16];
         this.mCurrentEmote = 0;
         this.mCurrentConversation = 0;
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         mUnit.mEmoticon = 0;
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         if(this.mNeedsToBeMadeVisible)
         {
            this.mNeedsToBeMadeVisible = false;
            mUnit.getViewComponent().setVisible(true);
            mUnit.getViewComponent().fadeIn(null);
         }
         this.mTotalLifeTime += dt;
         this.mSenseTime += dt;
         this.mAttractionTimer += dt;
         if(this.mEmoTime > 0)
         {
            this.mEmoTime -= dt;
            if(this.mEmoTime <= 0 && mCurrentState != 104)
            {
               this.mEmoTime = 0;
               mUnit.mEmoticon = 0;
            }
         }
         if(this.mAlerted && this.mSenseTime > 1000 && mCurrentState != 101 && mCurrentState != 113)
         {
            this.checkFleeing();
         }
         else if(mCurrentState == 100 && this.mSenseTime > 2000 && this.canTalk() && Math.random() < 0.2 && !this.mAlerted)
         {
            this.checkTalking();
         }
         else if(mCurrentState == 104 && this.mEmoTime <= 0)
         {
            this.updateTalking();
         }
         else if(!this.mAlerted && mCurrentState == 100 && this.mAttractionTimer > 45000)
         {
            this.checkRides();
         }
         else if(mCurrentState == 114)
         {
            if(this.mCurrentAttraction == null || !this.mCurrentAttraction.isActive() || this.mCurrentAttraction.decorationIsDismountingAnimOver())
            {
               changeState(100);
            }
         }
         this.mTimePerState -= dt;
         if(this.mTimePerState <= 0)
         {
            switch(mCurrentState - 100)
            {
               case 0:
                  if(Math.random() < 0.1 && this.mTimeSinceTalk < 60000)
                  {
                     this.movePause();
                  }
                  else
                  {
                     changeState(100);
                  }
                  break;
               case 1:
                  changeState(100);
                  break;
               case 2:
                  changeState(101);
                  break;
               case 6:
                  this.mAnnoyment++;
                  if(this.mTimeInIdle > 30000)
                  {
                     changeState(103);
                     break;
                  }
               case 3:
                  if(Math.random() > 0.5)
                  {
                     this.mTimePerState = 5000 + Math.random() * 5000;
                  }
                  else
                  {
                     changeState(100);
                  }
                  break;
               case 4:
                  this.mTimeSinceTalk = 0;
                  changeState(100);
                  mUnit.mEmoticon = 0;
                  this.mEmoTime = 1000;
                  break;
               case 5:
                  changeState(100);
                  break;
               case 7:
                  break;
               case 8:
                  this.mTimePerState = 3000 + Math.random() * 1500;
                  changeState(110);
                  break;
               case 9:
                  changeState(100);
                  break;
               case 10:
                  this.movePause();
                  this.mTimePerState = 2000;
                  break;
               case 13:
                  if(!!this.mCurrentAttraction ? this.mCurrentAttraction.decorationCanBeDismounted() : true)
                  {
                     changeState(114);
                     break;
                  }
            }
         }
         if(mCurrentState == 106)
         {
            this.mTimeInIdle += dt;
         }
         else
         {
            this.mTimeInIdle = 0;
         }
         if(mCurrentState != 104)
         {
            this.mTimeSinceTalk += dt;
         }
         else
         {
            this.mTimeSinceTalk = 0;
         }
         this.setSpeed();
      }
      
      private function checkFleeing() : void
      {
         var targetUnit:MyUnit = null;
         var unit:MyUnit = null;
         var unitList:Vector.<MyUnit> = InstanceMng.getUnitScene().sceneGetListById(8);
         unitList.concat(InstanceMng.getUnitScene().sceneGetListById(10));
         for each(unit in unitList)
         {
            if(DCMath.distanceSqr(unit.mPosition,mUnit.mPosition) < 122500)
            {
               this.mThreat = unit.mPosition;
               changeState(101);
               break;
            }
         }
         this.mSenseTime = 0;
      }
      
      private function checkTalking() : void
      {
         var unit:MyUnit = null;
         var ugoal:GoalCivil = null;
         var unitState:int = 0;
         var dpos:Vector3D = null;
         var dmpos:Vector3D = null;
         var vdist:Vector3D = null;
         var dist:Number = NaN;
         this.mSenseTime = 0;
         var civilList:Vector.<MyUnit> = InstanceMng.getUnitScene().sceneGetListById(1);
         for each(unit in civilList)
         {
            if(unit !== mUnit)
            {
               if(((unitState = (ugoal = unit.getGoalComponent() as GoalCivil).mCurrentState) == 100 || unitState == 106) && ugoal.canTalk())
               {
                  dpos = new Vector3D(unit.mPositionDrawX,unit.mPositionDrawY,0);
                  dmpos = new Vector3D(mUnit.mPositionDrawX,mUnit.mPositionDrawY,0);
                  vdist = dpos.subtract(dmpos);
                  if((dist = vdist.length) < 50 && dist > 50 * 0.5)
                  {
                     if(Math.abs(vdist.x) > Math.abs(vdist.y * 4))
                     {
                        this.mTalkUnit = unit;
                        this.mCurrentConversation = Math.random() * this.mConversations.length;
                        this.mCurrentEmote = 0;
                        changeState(104);
                        ugoal.talkWithMe(mUnit,this.mCurrentConversation);
                        this.mConversationMaster = true;
                        break;
                     }
                  }
               }
            }
         }
      }
      
      private function updateTalking() : void
      {
         var dpos:Vector3D = null;
         var dmpos:Vector3D = null;
         var vdist:Vector3D = null;
         var ugoal:GoalCivil = null;
         var newIcon:int = 0;
         if(this.mTalkUnit.mIsAlive)
         {
            dpos = new Vector3D(this.mTalkUnit.mPositionDrawX,this.mTalkUnit.mPositionDrawY,0);
            dmpos = new Vector3D(mUnit.mPositionDrawX,mUnit.mPositionDrawY,0);
            vdist = dpos.subtract(dmpos);
            ugoal = this.mTalkUnit.getGoalComponent() as GoalCivil;
            if(ugoal.mCurrentState != 104 || vdist.length > 50)
            {
               this.mTimePerState = 1;
               mUnit.mEmoticon = 0;
               this.mEmoTime = 0;
            }
            else if(this.mConversationMaster)
            {
               this.mCurrentEmote++;
               if(this.mCurrentEmote < this.mConversations[this.mCurrentConversation].length)
               {
                  newIcon = int(this.mConversations[this.mCurrentConversation][this.mCurrentEmote]);
                  if(mUnit.mEmoticon == 0)
                  {
                     mUnit.mEmoticon = newIcon;
                     ugoal.sayThis(0);
                  }
                  else
                  {
                     mUnit.mEmoticon = 0;
                     ugoal.sayThis(newIcon);
                  }
               }
               else
               {
                  mUnit.mEmoticon = 0;
                  ugoal.sayThis(0);
               }
               this.mEmoTime = 1500;
            }
         }
         else
         {
            this.mTimePerState = 1;
            mUnit.mEmoticon = 0;
            this.mEmoTime = 0;
         }
      }
      
      private function checkRides() : void
      {
         var wio:WorldItemObject = null;
         this.mAttractionTimer = -Math.random() * 45000 * 2;
         if(Math.random() > 0.2)
         {
            return;
         }
         var wioList:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetAllItems();
         var candidates:Vector.<WorldItemObject> = new Vector.<WorldItemObject>(0);
         for each(wio in wioList)
         {
            if(wio.canBeRide())
            {
               candidates.push(wio);
            }
         }
         if(candidates.length > 0)
         {
            wio = candidates[uint(Math.random() * candidates.length)];
            if(wio != null)
            {
               this.goToRide(wio);
            }
         }
      }
      
      override protected function movePause() : void
      {
         super.movePause();
         this.mOldState = mCurrentState = 106;
         this.mTimePerState = 10000 + Math.random() * 10000;
      }
      
      public function startJump() : void
      {
         var voice:String = null;
         if(mCurrentState == 105 || mCurrentState == 101 || mCurrentState == 108 || mCurrentState == 110)
         {
            return;
         }
         moveStop("jump");
         this.mTimePerState = 400;
         this.mAnnoyment++;
         var random:int = Math.floor(Math.random() * 5) + 1;
         switch(random - 1)
         {
            case 0:
            case 1:
               voice = "Body_2.mp3";
               break;
            case 2:
               voice = "Body_3.mp3";
               break;
            case 3:
               voice = "Body_8.mp3";
               break;
            case 4:
               voice = "Body_9a.mp3";
         }
         SoundManager.getInstance().playSound(voice);
         if(this.mAnnoyment < 3)
         {
            this.mOldState = mCurrentState = 105;
         }
         else
         {
            this.mAnnoyment = 0;
            this.mOldState = mCurrentState = 108;
         }
      }
      
      override protected function moveResume() : void
      {
         super.moveResume();
      }
      
      override protected function enterState(newState:int) : void
      {
         var movement:UnitComponentMovement = null;
         var movcomp:UnitComponentMovement = null;
         super.enterState(newState);
         switch(newState - 100)
         {
            case 0:
               if(this.mTotalLifeTime < 300000)
               {
                  if(!(this.mOldState == 109 && this.mTimePerState > 0))
                  {
                     mUnit.getMovementComponent().goToReset();
                     if(mMoveMode == 0)
                     {
                        this.moveResume();
                     }
                     mMoveHasArrivedTask = 2;
                     if(this.setNewDestiny())
                     {
                        this.mTimePerState = 15000 + Math.random() * 10000;
                     }
                  }
                  break;
               }
               if(this.mHome != null && this.mHome.isActive())
               {
                  movcomp = mUnit.getMovementComponent();
                  if(movcomp != null)
                  {
                     movcomp.goToTarget(this.mHome,null,false,"unitEventPathEnded");
                  }
                  mCurrentState = 111;
                  this.mTimePerState = 1000000;
               }
               break;
            case 1:
               if(this.mOldState == 106 || this.mOldState == 103 || Math.random() < 0.25 && this.mOldState != 102)
               {
                  super.moveStop("jump");
                  this.mTimePerState = 250;
                  mCurrentState = 102;
                  break;
               }
               if(mMoveMode == 0)
               {
                  this.moveResume();
               }
               if(this.calculateNewDestiny())
               {
                  movement = mUnit.getMovementComponent();
                  if(movement != null)
                  {
                     movement.goToWorldPosition(this.mDestinyViewPos);
                  }
               }
               if(!this.mAlreadyUsedEmote)
               {
                  if(this.mOldState != 102)
                  {
                     mUnit.mEmoticon = Math.random() < 0.65 ? 6 : 13;
                  }
                  else
                  {
                     mUnit.mEmoticon = 0;
                  }
                  this.mEmoTime = 1000;
                  this.mAlreadyUsedEmote = true;
               }
               this.mTimePerState = 6000;
               break;
            case 3:
               mUnit.mEmoticon = 14;
               this.mEmoTime = 2000;
               super.moveStop("sleep");
               this.mTimePerState = 10000 + Math.random() * 20000;
               break;
            case 4:
               super.moveStop(this.mTalkUnit.mPositionDrawX > mUnit.mPositionDrawX ? "talk_left" : "talk_right");
               mUnit.mEmoticon = this.mConversations[this.mCurrentConversation][0];
               this.mEmoTime = 1500;
               this.mTimePerState = 1500 * this.mConversations[this.mCurrentConversation].length;
               break;
            case 7:
               this.mAlerted = true;
               mCurrentState = this.mOldState;
               break;
            case 9:
               moveStop("jump_roll");
               this.mTimePerState = 5000;
               mCurrentState = 109;
               this.mAlerted = false;
               this.mAlreadyUsedEmote = false;
               break;
            case 10:
               if(mMoveMode == 0)
               {
                  this.moveResume();
               }
               if(this.calculateNewDestiny())
               {
                  movement = mUnit.getMovementComponent();
                  if(movement != null)
                  {
                     movement.goToWorldPosition(this.mDestinyViewPos);
                  }
               }
               this.mTimePerState = 3500 + Math.random() * 2500;
               break;
            case 14:
               if(this.mCurrentAttraction != null && this.mCurrentAttraction.decorationCanBeDismounted())
               {
                  this.mCurrentAttraction.decorationSetDismounting();
                  break;
               }
         }
         this.mOldState = mCurrentState;
      }
      
      private function setNewDestiny() : Boolean
      {
         var movement:UnitComponentMovement = null;
         if(this.calculateNewDestiny())
         {
            movement = mUnit.getMovementComponent();
            if(movement != null)
            {
               if(this.mTargetUnit != null)
               {
                  movement.goToTarget(this.mTargetUnit,null,false,"unitEventPathEnded");
               }
               else
               {
                  movement.goToTarget(this.mDestinyViewPos,null,false,"unitEventPathEnded",false);
               }
               return true;
            }
         }
         return false;
      }
      
      private function calculateNewDestiny() : Boolean
      {
         var newTile:int = 0;
         var distance:Number = NaN;
         var threatDirection:Vector3D = null;
         threatDirection = null;
         var mapController:MapControllerPlanet = InstanceMng.getMapControllerPlanet();
         var newTilePos:Vector3D = new Vector3D();
         var maxDistance:int = 40 * InstanceMng.getMapViewPlanet().getTileViewHeight();
         var minDistance:int = 10 * InstanceMng.getMapViewPlanet().getTileViewHeight();
         var coor:DCCoordinate = MyUnit.smCoor;
         var count:int = 0;
         var mapModel:MapModel = InstanceMng.getMapModel();
         var headquarter:WorldItemObject = mapModel.mAstarStartItem;
         var hqPos:Vector3D = new Vector3D(headquarter.mViewCenterWorldX,headquarter.mViewCenterWorldY,0);
         this.mTargetUnit = null;
         if(mCurrentState != 101)
         {
            this.mDestinyViewPos.x = coor.x;
            this.mDestinyViewPos.y = coor.y;
            while(true)
            {
               newTile = Math.random() * mapController.mTilesCount;
               InstanceMng.getViewMngPlanet().tileIndexToWorldPos(newTile,coor,true);
               InstanceMng.getViewMngPlanet().logicPosToViewPos(coor);
               newTilePos.x = coor.x;
               newTilePos.y = coor.y;
               distance = newTilePos.subtract(hqPos).length;
               count++;
               if(count > 10)
               {
                  break;
               }
               if(distance < minDistance || distance > maxDistance)
               {
                  continue;
               }
               this.mDestinyViewPos.x = coor.x;
               this.mDestinyViewPos.y = coor.y;
               §§goto(addr240);
            }
            return false;
         }
         threatDirection = mUnit.mPosition;
         threatDirection = threatDirection.subtract(this.mThreat);
         threatDirection.normalize();
         threatDirection.scaleBy(550);
         this.mDestinyViewPos = mUnit.mPosition;
         this.mDestinyViewPos = this.mDestinyViewPos.add(threatDirection);
         coor.x = this.mDestinyViewPos.x;
         coor.y = this.mDestinyViewPos.y;
         InstanceMng.getViewMngPlanet().logicPosToViewPos(coor);
         this.mDestinyViewPos.x = coor.x;
         this.mDestinyViewPos.y = coor.y;
         addr240:
         return true;
      }
      
      override protected function moveGetAnimId() : String
      {
         return mCurrentState == 101 || mCurrentState == 110 ? "running" : "walking";
      }
      
      private function setSpeed() : void
      {
         var movcomp:UnitComponentMovement = mUnit.getMovementComponent();
         if(movcomp != null)
         {
            switch(mCurrentState)
            {
               case 110:
               case 101:
                  movcomp.setMaxSpeed(mUnit.mDef.getMaxSpeed() * 1.5);
                  mUnit.getViewComponent().setFrameRate(0);
                  break;
               case 111:
               case 100:
                  movcomp.setMaxSpeed(mUnit.mDef.getMaxSpeed() * 0.6);
                  mUnit.getViewComponent().setFrameRate(2);
                  break;
               case 112:
                  movcomp.setMaxSpeed(mUnit.mDef.getMaxSpeed() * 1.25);
                  mUnit.getViewComponent().setFrameRate(1);
                  break;
               case 108:
               case 105:
                  mUnit.getViewComponent().setFrameRate(0);
                  break;
               case 102:
               case 109:
               case "talk_left":
               case "talk_right":
                  mUnit.getViewComponent().setFrameRate(1);
                  break;
               default:
                  mUnit.getViewComponent().setFrameRate(2);
            }
         }
      }
      
      private function setTimePerState() : void
      {
         this.mTimePerState = 5000;
      }
      
      public function setHome(home:WorldItemObject) : void
      {
         this.mHome = home;
      }
      
      public function canTalk() : Boolean
      {
         return this.mTimeSinceTalk > 45000;
      }
      
      public function talkWithMe(unit:MyUnit, conversation:int) : void
      {
         this.mTalkUnit = unit;
         this.mCurrentConversation = conversation;
         this.mCurrentEmote = 0;
         this.mConversationMaster = false;
         changeState(104);
         mUnit.mEmoticon = 0;
         this.mEmoTime = 1500;
      }
      
      public function sayThis(newIcon:int) : void
      {
         if(!this.mConversationMaster)
         {
            mUnit.mEmoticon = newIcon;
            this.mEmoTime = 1500;
         }
      }
      
      public function goToRide(item:WorldItemObject) : void
      {
         var movcomp:UnitComponentMovement = mUnit.getMovementComponent();
         if(movcomp != null)
         {
            movcomp.goToTarget(item,null,false,"unitEventPathEnded");
         }
         this.mCurrentAttraction = item;
         mCurrentState = 112;
         this.mTimePerState = 1000000;
         mUnit.showEmoticon(8,1500);
      }
      
      override protected function exitState(state:int) : void
      {
         super.exitState(state);
         switch(state - 114)
         {
            case 0:
               if(this.mCurrentAttraction != null && this.mCurrentAttraction.isActive())
               {
                  mUnit.setPositionInViewSpace(this.mCurrentAttraction.mViewCenterWorldX + 10,this.mCurrentAttraction.mViewCenterWorldY + 10);
                  this.mCurrentAttraction = null;
               }
               this.mNeedsToBeMadeVisible = true;
               this.mAttractionTimer = 0;
         }
      }
      
      public function pathEnded() : void
      {
         if(mCurrentState == 100)
         {
            mUnit.getMovementComponent().resume();
            this.setNewDestiny();
         }
         else if(mCurrentState == 111)
         {
            mUnit.exitSceneStart(1);
         }
         else if(mCurrentState == 112)
         {
            if(this.mCurrentAttraction != null && this.mCurrentAttraction.isActive())
            {
               if(this.mCurrentAttraction.canBeRide())
               {
                  this.mOldState = mCurrentState = 113;
                  mUnit.getViewComponent().setVisible(false);
                  this.mTimePerState = 30000 + Math.random() * 30000;
                  this.mCurrentAttraction.decorationSetRiding();
               }
               else
               {
                  changeState(100);
               }
            }
         }
      }
      
      public function getCurrentAttraction() : WorldItemObject
      {
         return this.mCurrentAttraction;
      }
   }
}
