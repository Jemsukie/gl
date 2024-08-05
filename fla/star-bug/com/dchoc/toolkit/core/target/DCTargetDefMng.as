package com.dchoc.toolkit.core.target
{
   import com.dchoc.toolkit.core.target.action.DCAction;
   import com.dchoc.toolkit.core.target.condition.DCCondition;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   import flash.utils.Dictionary;
   
   public class DCTargetDefMng extends DCDefMng
   {
       
      
      protected var mConditionCatalog:Dictionary;
      
      protected var mActionCatalog:Dictionary;
      
      public function DCTargetDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function loadDoStep(step:int) : void
      {
         super.loadDoStep(step);
         if(step == 0)
         {
            this.mActionCatalog = new Dictionary();
            this.mConditionCatalog = new Dictionary();
            DCTargetMng.smTargetDefMng = this;
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mActionCatalog = null;
         this.mConditionCatalog = null;
         super.unloadDo();
      }
      
      public function changeState(target:DCTarget, stateId:int) : void
      {
         var strId:String = null;
         var cond:DCCondition = null;
         var arrowCond:String = null;
         var condHideArrow:DCCondition = null;
         if(target != null)
         {
            if(target.State == 2)
            {
               this.triggerTargetAction(target,false);
            }
            target.setState(stateId);
            if(stateId > 2)
            {
               target.setCondition(null);
               return;
            }
            strId = target.getConditionType();
            cond = this.getCondition(strId);
            target.setCondition(cond);
            if((arrowCond = target.getDef().getHideArrowCondition()) != null)
            {
               condHideArrow = this.getCondition(arrowCond);
               target.setConditionHideArrow(condHideArrow);
            }
            if(target.State == 2)
            {
               target.setActionId(target.getDef().getPreAction());
               this.triggerTargetAction(target,true);
               target.setActionId(target.getDef().getPostAction());
            }
         }
      }
      
      protected function requestCondition(conditionId:String) : void
      {
      }
      
      protected function requestAction(actionId:String) : void
      {
      }
      
      protected function filterConditionId(conditionId:String) : String
      {
         return conditionId;
      }
      
      public function getCondition(conditionId:String) : DCCondition
      {
         if(conditionId == null)
         {
            return null;
         }
         conditionId = this.filterConditionId(conditionId);
         if(this.mConditionCatalog[conditionId] == null)
         {
            this.requestCondition(conditionId);
         }
         return this.mConditionCatalog[conditionId];
      }
      
      public function setCondition(conditionId:String, condition:DCCondition) : void
      {
         if(this.mConditionCatalog[conditionId] == null)
         {
            this.mConditionCatalog[conditionId] = condition;
         }
      }
      
      public function getAction(actionId:String) : DCAction
      {
         if(this.mActionCatalog[actionId] == null)
         {
            this.requestAction(actionId);
         }
         return this.mActionCatalog[actionId];
      }
      
      public function triggerTargetAction(target:DCTarget, isPreaction:Boolean) : void
      {
         if(target.getActionId() == null || target.getActionId() == "")
         {
            return;
         }
         var action:DCAction = this.getAction(target.getActionId());
         if(action != null)
         {
            action.execute(target,isPreaction);
         }
      }
   }
}
