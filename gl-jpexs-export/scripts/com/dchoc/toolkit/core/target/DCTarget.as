package com.dchoc.toolkit.core.target
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.target.condition.DCCondition;
   import esparragon.utils.EUtils;
   
   public class DCTarget
   {
      
      public static const EVENT_TARGET_CHANGE_STATE:String = "EVENT_TARGET_CHANGE_STATE";
      
      public static const EVENT_SHOW_POPUP:String = "EVENT_SHOW_POPUP";
      
      public static const EVENT_SHOW_ANIM:String = "EVENT_SHOW_ANIM";
      
      public static const STATE_LOCKED:int = 0;
      
      public static const STATE_READY_TO_START:int = 1;
      
      public static const STATE_AVAILABLE:int = 2;
      
      public static const STATE_COMPLETED:int = 3;
      
      public static const STATE_DEAD:int = 4;
      
      public static const STATES_COUNT:int = 5;
      
      public static var smTargetMng:DCTargetMng;
       
      
      protected var mId:String;
      
      protected var mTargetDef:DCTargetDef;
      
      protected var mStateId:int;
      
      protected var mCondition:DCCondition;
      
      protected var mNotifyTo:DCTargetProviderInterface;
      
      protected var mChangeStateEventObject:Object;
      
      protected var mActionId:String;
      
      protected var mProgress:Array;
      
      protected var mStartTime:Number;
      
      protected var mEndTime:Number = -1;
      
      protected var mConditionHideArrow:DCCondition;
      
      public function DCTarget(targetDef:DCTargetDef, stateId:int, componentCreator:DCTargetProviderInterface)
      {
         super();
         this.mId = targetDef.mSku;
         this.mTargetDef = targetDef;
         this.mStateId = stateId;
         this.mNotifyTo = componentCreator;
         this.mChangeStateEventObject = {};
         this.mChangeStateEventObject.type = "EVENT_TARGET_CHANGE_STATE";
         this.mChangeStateEventObject.item = this;
         this.mProgress = [];
      }
      
      public static function unloadStatic() : void
      {
         smTargetMng = null;
      }
      
      public function get Id() : String
      {
         return this.mId;
      }
      
      public function get State() : int
      {
         return this.mStateId;
      }
      
      public function setState(value:int) : void
      {
         this.mStateId = value;
      }
      
      public function setCondition(value:DCCondition) : void
      {
         this.mCondition = value;
      }
      
      public function getDef() : DCTargetDef
      {
         return this.mTargetDef;
      }
      
      public function getActionId() : String
      {
         return this.mActionId;
      }
      
      public function setActionId(value:String) : void
      {
         this.mActionId = value;
      }
      
      public function getCondition() : DCCondition
      {
         return this.mCondition;
      }
      
      public function setConditionHideArrow(value:DCCondition) : void
      {
         this.mConditionHideArrow = value;
      }
      
      public function isDone() : Boolean
      {
         return this.mStateId > 2;
      }
      
      public function logicUpdate() : void
      {
         var i:int = 0;
         var max:int = 0;
         var def:DCTargetDef = this.getDef();
         var allConditionsOk:Boolean = true;
         if((this.mStateId == 0 || this.mStateId >= 2) && this.mCondition != null && def != null)
         {
            max = def.getNumMinitargetsFound();
            for(i = 0; i < max; )
            {
               if(!this.mCondition.check(this,i))
               {
                  allConditionsOk = false;
               }
               else
               {
                  this.mCondition.launchEventOnConditionAccomplished(this,i);
               }
               i++;
            }
            if(this.checkTimeToFinish(allConditionsOk))
            {
               return;
            }
            if(max == 0)
            {
               if(!this.mCondition.check(this,0))
               {
                  allConditionsOk = false;
               }
            }
            if(allConditionsOk)
            {
               this.changeState(this.mStateId + 1);
            }
         }
         this.checkIfArrowNeedsToBeHidden();
      }
      
      protected function checkIfArrowNeedsToBeHidden() : void
      {
      }
      
      protected function checkTimeToFinish(allConditionsOk:Boolean = true) : Boolean
      {
         var timeToFinish:Number = NaN;
         var currTime:Number = NaN;
         var returnValue:Boolean = false;
         if(this.mStateId > 1)
         {
            timeToFinish = this.getEndTime();
            currTime = DCInstanceMng.getInstance().getApplication().getCurrentServerTimeMillis();
            if(timeToFinish != -1)
            {
               if(currTime >= timeToFinish)
               {
                  DCInstanceMng.getInstance().getApplication().startResetTargetEvents(this.Id);
                  returnValue = true;
               }
            }
         }
         return returnValue;
      }
      
      public function resetTarget() : void
      {
         var i:int = 0;
         var length:int = int(this.mProgress.length);
         for(i = 0; i < length; )
         {
            smTargetMng.endProgress(this.Id);
            smTargetMng.startProgress(this.Id);
            i++;
         }
      }
      
      public function changeState(stateId:int) : void
      {
         if(this.mNotifyTo.isThisStateUseful(stateId) == false || this.mTargetDef.isThisStateUseful(stateId) == false)
         {
            stateId++;
         }
         DCDebug.traceCh("TOOLKIT"," > " + this + "(" + this.mId + ") condition met:" + this.mCondition + " -> change to state " + stateId);
         if(stateId > 4)
         {
            return;
         }
         this.mChangeStateEventObject.cmd = stateId;
         if(smTargetMng != null)
         {
            smTargetMng.notify(this.mChangeStateEventObject);
         }
         if(this.mNotifyTo != null)
         {
            this.mChangeStateEventObject.target = this;
            this.mNotifyTo.notify(this.mChangeStateEventObject);
         }
      }
      
      public function getConditionType() : String
      {
         if(this.mStateId == 0)
         {
            return this.mTargetDef.getConditionUnlocked();
         }
         return this.mTargetDef.getConditionAccomplished();
      }
      
      public function isThisConditionUseful(type:String, paramSku:String, accId:String = "", level:int = 0) : Array
      {
         var i:int = 0;
         var returnValue:Array = [];
         var targetDef:DCTargetDef;
         var max:int = (targetDef = this.getDef()).getNumMinitargetsFound();
         var paramSkusEquals:* = false;
         var accIdEquals:Boolean = false;
         var progressFromEquals:Boolean = false;
         var levelCorrect:Boolean = false;
         if(max != 0)
         {
            for(i = 0; i < max; )
            {
               if(type == targetDef.getMiniTargetTypes(i) && (targetDef.isMiniTargetProgressAbsolute(i) || this.mStateId > 1))
               {
                  paramSkusEquals = targetDef.containsTargetSku(i,paramSku);
                  accIdEquals = this.checkTargetAccount(accId,targetDef.getMiniTargetNPC(i));
                  progressFromEquals = this.checkTargetProgressDoneFrom(targetDef.getMiniTargetDoneFrom(i));
                  levelCorrect = this.checkTargetLevel(level,i);
                  if((paramSku == "" && accId == "" || paramSku == "" && accIdEquals || accId == "" && paramSkusEquals || paramSkusEquals && accIdEquals) && progressFromEquals && levelCorrect)
                  {
                     returnValue.push(i);
                  }
               }
               i++;
            }
         }
         else if(type == targetDef.getConditionAccomplished())
         {
            accIdEquals = this.checkTargetAccount(accId,targetDef.getMiniTargetNPC(0));
            paramSkusEquals = paramSku == targetDef.getConditionParameterSku();
            levelCorrect = this.checkTargetLevel(level,0);
            if(paramSku != "")
            {
               if(accId != "")
               {
                  if(paramSkusEquals && accIdEquals && levelCorrect)
                  {
                     returnValue.push(i);
                  }
               }
               else if(accId == "")
               {
                  if(paramSkusEquals && levelCorrect)
                  {
                     returnValue.push(i);
                  }
               }
            }
            else
            {
               returnValue.push(i);
            }
         }
         return returnValue;
      }
      
      protected function checkTargetAccount(accId:String, userList:String) : Boolean
      {
         return true;
      }
      
      protected function checkTargetProgressDoneFrom(location:String) : Boolean
      {
         return true;
      }
      
      protected function checkTargetLevel(level:int, index:int) : Boolean
      {
         return true;
      }
      
      public function updateProgress(type:String, amount:Number, resourceType:String, accId:String = "", level:int = 0, confirmNotifyServer:Boolean = true, indices:Array = null) : void
      {
         var usefulIndices:* = null;
         var index:int = 0;
         var amountNeeded:Number = NaN;
         var amountAux:* = NaN;
         var difference:Number = NaN;
         var info:Object = null;
         var updateServer:Boolean = false;
         var finalAmountToBeAdded:* = 0;
         var numMiniTargetsFound:int = 0;
         if(this.mProgress == null)
         {
            this.mProgress = [];
         }
         if(!indices)
         {
            usefulIndices = this.isThisConditionUseful(type,resourceType,accId,level);
         }
         else
         {
            usefulIndices = indices;
         }
         if(usefulIndices != null)
         {
            for each(index in usefulIndices)
            {
               amountAux = amount;
               amountNeeded = (numMiniTargetsFound = this.getDef().getNumMinitargetsFound()) != 0 ? this.getDef().getMiniTargetAmount(index) : this.getDef().getAmount();
               if(this.mProgress[index] == null)
               {
                  if(amountAux > amountNeeded)
                  {
                     finalAmountToBeAdded = amountNeeded;
                  }
                  this.mProgress[index] = finalAmountToBeAdded;
                  updateServer = true;
               }
               else
               {
                  finalAmountToBeAdded = (difference = amountNeeded - (this.mProgress[index] + amountAux)) >= 0 ? amountAux : amountNeeded - this.mProgress[index];
                  this.mProgress[index] += finalAmountToBeAdded;
                  updateServer = true;
               }
               if(updateServer && confirmNotifyServer)
               {
                  (info = {}).sku = this.mId;
                  info.index = index;
                  info.amount = finalAmountToBeAdded;
                  DCInstanceMng.getInstance().getApplication().updateTargetProgressOnServer(info);
               }
            }
         }
      }
      
      public function getProgress(index:int) : Number
      {
         return this.mProgress[index];
      }
      
      public function startProgress(index:int) : void
      {
         if(this.mProgress[index] == null)
         {
            this.mProgress[index] = 0;
         }
      }
      
      public function addProgress(index:int, amount:int) : void
      {
         this.mProgress[index] = amount;
      }
      
      public function endProgress(index:int) : void
      {
         if(this.mProgress[index] != null)
         {
            delete this.mProgress[index];
         }
      }
      
      public function getProgressArray() : Array
      {
         return this.mProgress;
      }
      
      public function setStartTime(value:Number) : void
      {
         this.mStartTime = value;
      }
      
      public function getStartTime() : Number
      {
         return this.mStartTime;
      }
      
      public function setEndTime(value:Number) : void
      {
         this.mEndTime = value;
      }
      
      public function getEndTime() : Number
      {
         return this.mEndTime;
      }
      
      public function setXMLParams(info:XML) : void
      {
         var time:Number = EUtils.xmlReadNumber(info,"endTime");
         if(time == 0)
         {
            time = -1;
         }
         this.setEndTime(time);
      }
   }
}
