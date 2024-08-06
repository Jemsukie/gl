package com.dchoc.toolkit.core.target
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class DCTargetMng extends DCComponent
   {
      
      public static var smTargetDefMng:DCTargetDefMng;
       
      
      protected var mTargets:Array;
      
      protected var mTargetStates:Dictionary;
      
      protected var mTargetsXML:Dictionary;
      
      private var mNeedsPersistence:Boolean;
      
      public function DCTargetMng(needsPersistence:Boolean = false)
      {
         super();
         this.mNeedsPersistence = needsPersistence;
         if(DCTarget.smTargetMng == null)
         {
            DCTarget.smTargetMng = this;
         }
      }
      
      public static function unloadStatic() : void
      {
         smTargetDefMng = null;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 1;
         mBuildAsyncTotalSteps = 0;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         this.mTargetsXML = new Dictionary();
         this.mTargets = [];
         this.mTargetStates = new Dictionary();
      }
      
      override protected function unloadDo() : void
      {
         this.mTargetsXML = null;
         this.mTargets = null;
         this.mTargetStates = null;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0)
         {
            if(this.mNeedsPersistence)
            {
               if(mPersistenceData != null)
               {
                  this.fillTargetProgress(mPersistenceData);
                  buildAdvanceSyncStep();
               }
            }
            else
            {
               buildAdvanceSyncStep();
            }
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.mTargets.length = 0;
         this.mTargetStates.length = 0;
      }
      
      public function addTarget(target:DCTarget, stateId:int) : void
      {
         if(target != null)
         {
            if(smTargetDefMng != null)
            {
               smTargetDefMng.changeState(target,stateId);
            }
            if(this.mTargets[target.Id] == null)
            {
               this.mTargets[target.Id] = target;
            }
            this.mTargetStates[target.Id] = stateId;
            this.startProgress(target.Id);
         }
      }
      
      public function getTargetById(targetId:String) : DCTarget
      {
         return this.mTargets[targetId];
      }
      
      public function getTargetStateById(targetId:String) : int
      {
         return this.mTargetStates[targetId];
      }
      
      public function getAllTargets() : Array
      {
         return this.mTargets;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var target:DCTarget = null;
         for each(target in this.mTargets)
         {
            target.logicUpdate();
         }
      }
      
      override public function notify(e:Object) : Boolean
      {
         var _loc2_:* = e.type;
         if("EVENT_TARGET_CHANGE_STATE" !== _loc2_)
         {
            return false;
         }
         return this.notifyTargetChangeState(e);
      }
      
      protected function notifyTargetChangeState(e:Object) : Boolean
      {
         if(smTargetDefMng == null)
         {
            return false;
         }
         var state:int = int(e.cmd);
         var target:DCTarget = DCTarget(e.item);
         if(state == 2)
         {
            this.setTimeToFinish(target);
         }
         this.addTarget(target,state);
         if(state > 2)
         {
            this.endProgress(target.Id);
            this.deleteTarget(target);
         }
         return true;
      }
      
      protected function deleteTarget(target:DCTarget) : void
      {
         if(this.mTargets != null)
         {
            delete this.mTargets[target.Id];
         }
      }
      
      private function setTimeToFinish(target:DCTarget) : void
      {
         var initTime:Number = NaN;
         var targetDef:DCTargetDef = target.getDef();
         var time:Number = 0;
         if(targetDef.validDateHasAnyDate() && !targetDef.validDateHasExpired(InstanceMng.getUserDataMng().getServerCurrentTimemillis()))
         {
            time = targetDef.validDateGetEndMillis();
            target.setEndTime(time);
            return;
         }
         time = Number(target.getDef().getTimeToFinish());
         if(time != 0)
         {
            initTime = DCInstanceMng.getInstance().getApplication().getCurrentServerTimeMillis();
            target.setStartTime(initTime);
            target.setEndTime(initTime + time);
         }
      }
      
      public function startProgress(id:String) : void
      {
         var i:int = 0;
         var target:DCTarget = this.mTargets[id];
         var length:Number = 0;
         length = target.getDef().getNumMinitargetsFound();
         if(length == 0)
         {
            target.startProgress(0);
         }
         else
         {
            i = 0;
            while(i < length)
            {
               target.startProgress(i);
               i++;
            }
         }
      }
      
      public function getProgress(id:String, index:int = 0) : Number
      {
         var target:DCTarget = this.mTargets[id];
         return target.getProgress(index);
      }
      
      public function endProgress(id:String, index:int = 0) : void
      {
         var i:int = 0;
         var target:DCTarget = this.mTargets[id];
         var length:Number = 0;
         length = target.getDef().getNumMinitargetsFound();
         if(length == 0)
         {
            target.endProgress(0);
         }
         else
         {
            i = 0;
            while(i < length)
            {
               target.endProgress(i);
               i++;
            }
         }
      }
      
      public function updateProgress(type:String, amount:int, resourceType:String = "", accId:String = "", level:int = 0) : void
      {
         var target:DCTarget = null;
         for each(target in this.mTargets)
         {
            target.updateProgress(type,amount,resourceType,accId,level);
         }
      }
      
      public function persistenceGetTargetsData() : XML
      {
         var target:DCTarget = null;
         var targetDef:DCTargetDef = null;
         var amount:Number = NaN;
         var i:int = 0;
         var targetXML:XML = null;
         var targetsProgress:* = "";
         var xml:XML = EUtils.stringToXML("<Targets/>");
         for each(target in this.mTargets)
         {
            if(target.State > 1 && target.State < 3)
            {
               targetsProgress = target.Id + ":";
               targetDef = target.getDef();
               amount = targetDef.getNumMinitargetsFound();
               for(i = 0; i < amount; )
               {
                  targetsProgress += target.getProgress(i) + ",";
                  i++;
               }
               targetXML = EUtils.stringToXML("<Target progress=\"" + targetsProgress + "\"/>");
               xml.appendChild(targetXML);
            }
         }
         return xml;
      }
      
      public function persistenceGetTimedTargetsData() : XML
      {
         var target:DCTarget = null;
         var targetTime:Number = NaN;
         var targetXML:XML = null;
         var targetStr:* = null;
         var endTime:String = null;
         var xml:XML = EUtils.stringToXML("<Params/>");
         for each(target in this.mTargets)
         {
            targetTime = Number(target.getEndTime());
            if(target.State > 1 && targetTime != 0)
            {
               endTime = String(targetTime);
               if(isNaN(targetTime))
               {
                  endTime = "-1";
               }
               targetStr = "<Target sku=\"" + target.Id + "\" endTime=\"" + endTime + "\"/>";
               targetXML = EUtils.stringToXML(targetStr);
               xml.appendChild(targetXML);
            }
         }
         return xml;
      }
      
      public function fillTargetProgress(value:XML) : void
      {
         var targetsXML:XML = null;
         var targetProgressXML:XML = null;
         var dotArr:Array = null;
         var id:String = null;
         for each(targetsXML in value)
         {
            for each(targetProgressXML in EUtils.xmlGetChildrenList(targetsXML,"Target"))
            {
               if((id = String((dotArr = EUtils.xmlReadString(targetProgressXML,"progress").split(":"))[0])) != "" && dotArr[1] != null)
               {
                  this.mTargetsXML[id] = dotArr[1];
               }
            }
         }
      }
      
      public function addProgress(id:String) : void
      {
         var commaArr:Array = null;
         var amount:String = null;
         var amountNumber:Number = NaN;
         var target:DCTarget = this.getTargetById(id);
         var index:int = 0;
         if(this.mTargetsXML[id] != null)
         {
            commaArr = this.mTargetsXML[id].split(",");
            for each(amount in commaArr)
            {
               if(target != null)
               {
                  amountNumber = Number(amount);
                  if(target.getDef().getMiniTargetAmount(index) <= amountNumber)
                  {
                     amountNumber = target.getDef().getMiniTargetAmount(index);
                  }
                  target.addProgress(index,int(amountNumber));
                  index++;
               }
            }
         }
      }
      
      public function loadTargetProgressFromXML() : void
      {
         var target:DCTarget = null;
         var targetsXML:XML = null;
         var targetProgressXML:XML = null;
         var commaArr:Array = null;
         var dotArr:Array = null;
         var id:String = null;
         var amount:String = null;
         var index:int = 0;
         for each(targetsXML in mPersistenceData)
         {
            for each(targetProgressXML in EUtils.xmlGetChildrenList(targetsXML,"Target"))
            {
               if((id = String((dotArr = EUtils.xmlReadString(targetProgressXML,"progress").split(":"))[0])) != "" && dotArr[1] != null)
               {
                  target = this.getTargetById(id);
                  commaArr = dotArr[1].split(",");
                  index = 0;
                  for each(amount in commaArr)
                  {
                     if(amount != "")
                     {
                        if(target != null)
                        {
                           target.addProgress(index,int(amount));
                           index++;
                        }
                     }
                  }
               }
            }
         }
      }
   }
}
