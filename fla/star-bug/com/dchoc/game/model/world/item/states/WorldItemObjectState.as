package com.dchoc.game.model.world.item.states
{
   import com.dchoc.game.controller.world.item.actionsUI.ActionUI;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   
   public class WorldItemObjectState
   {
      
      public static const ANIM_KEEP_CURRENT_ID:int = -2;
      
      public static const ANIM_EMPTY_ID:int = -1;
      
      public static const ANIM_CONDITION_NONE:int = -1;
      
      public static const ANIM_CONDITION_END:int = 0;
       
      
      public var mStateId:int;
      
      protected var mAnimConditionId:int;
      
      protected var mAnimLayerId:int;
      
      private var mActionUIId:int;
      
      private var mActionUI:ActionUI;
      
      private var mOverEvent:String;
      
      protected var mWaitingTimeMS:Number;
      
      protected var mViewLayersAnimIds:Array;
      
      private var mCountdownAllowed:Boolean;
      
      public function WorldItemObjectState(stateId:int, overEvent:String, waitingTimeMS:Number = 0, actionUIId:int = -1, baseAnimId:int = -2, iconAnimId:int = -1, animConditionId:int = -1, barAnimId:int = -1)
      {
         super();
         this.mStateId = stateId;
         this.viewLayersPopulateAnimIds();
         this.mViewLayersAnimIds[1] = baseAnimId;
         this.mViewLayersAnimIds[5] = iconAnimId;
         this.mViewLayersAnimIds[7] = barAnimId;
         this.setActionUIId(actionUIId);
         this.mWaitingTimeMS = waitingTimeMS;
         this.mOverEvent = overEvent;
         this.mAnimConditionId = animConditionId;
         this.mAnimLayerId = 5;
         this.mCountdownAllowed = true;
      }
      
      public function unload() : void
      {
         this.mViewLayersAnimIds = null;
         this.mOverEvent = null;
      }
      
      public function hasCountdown() : Boolean
      {
         return this.mCountdownAllowed && this.mWaitingTimeMS > 0;
      }
      
      public function setCountdownEnabled(value:Boolean) : void
      {
         this.mCountdownAllowed = value;
      }
      
      public function dispatchEvent(wItem:WorldItemObject) : void
      {
         if(this.mOverEvent != null && !wItem.mEventDispatched)
         {
            InstanceMng.getNotifyMng().addEvent(WorldItemObject.smWorldItemObjectController,{
               "type":0,
               "cmd":this.mOverEvent,
               "item":wItem
            });
            wItem.mEventDispatched = true;
         }
      }
      
      protected function viewLayersPopulateAnimIds() : void
      {
         var i:int = 0;
         this.mViewLayersAnimIds = new Array(8);
         for(i = 0; i < 8; )
         {
            this.mViewLayersAnimIds[i] = -1;
            i++;
         }
         this.viewLayersDoPopulateAnimIds();
      }
      
      protected function viewLayersDoPopulateAnimIds() : void
      {
      }
      
      public function viewLayersGetAnim(layerId:int) : int
      {
         return this.mViewLayersAnimIds[layerId];
      }
      
      public function beginView(item:WorldItemObject) : void
      {
         var i:int = 0;
         this.changeViewLayersAnimIds(item);
         var visible:* = !item.needsToBeHidden();
         for(i = 0; i < 8; )
         {
            if(visible)
            {
               if(this.viewLayersGetAnim(i) > -2)
               {
                  item.viewRequestAnim(i,this.viewLayersGetAnim(i));
               }
            }
            else
            {
               item.viewRequestAnim(i,-1);
            }
            i++;
         }
         if(Config.usePowerUps())
         {
            if(InstanceMng.getPowerUpMng().unitsIsAnyPowerUpActiveByUnitSku(item.mDef.mSku,1))
            {
               item.viewSetPowerUp(true);
            }
         }
      }
      
      public function begin(item:WorldItemObject, resetState:Boolean = false) : void
      {
         this.beginView(item);
         this.beginDo(item,resetState);
      }
      
      protected function changeViewLayersAnimIds(item:WorldItemObject) : void
      {
         var id:int = 0;
         if(item.mDef.needsGround())
         {
            if(item.isCompletelyBroken())
            {
               id = 32;
            }
            else if(item.viewExtraUsesTurretPedestal())
            {
               id = 33;
            }
            else
            {
               id = 31;
            }
         }
         else
         {
            id = -1;
         }
         this.mViewLayersAnimIds[0] = id;
         if(item.mDef.getAnimOnBase() != null && !item.needsRepairs())
         {
            this.mViewLayersAnimIds[3] = 38;
            item.viewLayersTypeCurrentSet(3,-1);
         }
         else
         {
            this.mViewLayersAnimIds[3] = -1;
         }
      }
      
      protected function beginDo(item:WorldItemObject, resetState:Boolean = false) : void
      {
         if(this.mWaitingTimeMS > 0)
         {
            item.mTimeMax.value = this.mWaitingTimeMS;
            if(resetState)
            {
               item.mTime.value = this.mWaitingTimeMS;
            }
         }
      }
      
      public function end(item:WorldItemObject) : void
      {
      }
      
      public function logicUpdate(item:WorldItemObject, dt:int) : void
      {
         var doTransition:Boolean = false;
         var anim:DCDisplayObject = null;
         if(this.mAnimConditionId != -1)
         {
            doTransition = false;
            if((anim = item.viewLayersAnimGet(this.mAnimLayerId)) != null && item.viewLayersTypeRequiredGet(this.mAnimLayerId) == item.viewLayersTypeCurrentGet(this.mAnimLayerId))
            {
               switch(this.mAnimConditionId)
               {
                  case 0:
                     doTransition = anim.isAnimationOver();
               }
            }
            if(doTransition)
            {
               this.dispatchEvent(item);
            }
         }
      }
      
      public function pauseToReceiveAttack(item:WorldItemObject) : void
      {
         this.notify(item,{"cmd":"battleEventHasStarted"});
         this.logicUpdate(item,0);
      }
      
      public function resumeFromReceivingAttack(item:WorldItemObject) : void
      {
         this.notify(item,{"cmd":"battleEventHasFinished"});
      }
      
      public function getActionUIId(item:WorldItemObject) : int
      {
         if(item.mDef.isAllowedToBeRepaired() && InstanceMng.getRole().mId == 0 && item.canBeBroken() && item.getEnergyPercent() < 100)
         {
            return 8;
         }
         return this.mActionUI.getActionId(item);
      }
      
      public function getActionUI() : ActionUI
      {
         return this.mActionUI;
      }
      
      public function setActionUIId(id:int) : void
      {
         this.mActionUIId = id == -1 ? 25 : id;
         this.mActionUI = WorldItemObject.smWorldItemObjectController.actionsUIGetAction(this.mActionUIId);
      }
      
      public function notify(item:WorldItemObject, e:Object) : Boolean
      {
         return false;
      }
      
      public function actionUIIsAllowed(actionId:int) : Boolean
      {
         return actionId <= this.mActionUIId;
      }
      
      public function getTimeMax() : Number
      {
         return this.mWaitingTimeMS;
      }
      
      public function mustBeRun(item:WorldItemObject) : Boolean
      {
         return !item.isPaused();
      }
      
      public function moveCanBeMoved() : Boolean
      {
         return true;
      }
      
      public function connectionSwapState(item:WorldItemObject, value:Boolean) : void
      {
      }
   }
}
