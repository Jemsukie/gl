package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.condition.DCCondition;
   import flash.utils.Dictionary;
   
   public class ConditionComposite extends Condition
   {
       
      
      public var mConditionsArray:Array;
      
      public var mConditionsNotifiedCatalog:Dictionary;
      
      public function ConditionComposite()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         this.mConditionsArray = [];
         this.mConditionsNotifiedCatalog = new Dictionary();
         mConditionId = "composite";
      }
      
      public function addCondition(condition:DCCondition, index:int = 0) : void
      {
         if(this.mConditionsArray == null)
         {
            this.mConditionsArray = [];
         }
         this.mConditionsArray.push(condition);
         this.mConditionsNotifiedCatalog[index] = false;
      }
      
      public function getConditionsArray() : Array
      {
         return this.mConditionsArray;
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var condition:DCCondition = null;
         var returnValue:Boolean = false;
         condition = this.mConditionsArray[index];
         if(this.mConditionsArray[index] != null)
         {
            returnValue = condition.check(target,index);
         }
         return returnValue;
      }
      
      override public function checkIfNeeded(type:String) : Boolean
      {
         var condition:DCCondition = null;
         var returnValue:Boolean = false;
         if(this.mConditionsArray != null)
         {
            for each(condition in this.mConditionsArray)
            {
               if(condition.checkIfNeeded(type))
               {
                  returnValue = true;
               }
            }
         }
         return returnValue;
      }
      
      override public function launchEventOnConditionAccomplished(target:DCTarget, index:int = 0) : void
      {
         var alreadyNotified:Boolean = false;
         var cond:DCCondition;
         if((cond = this.mConditionsArray[index]) != null)
         {
            alreadyNotified = Boolean(this.mConditionsNotifiedCatalog[index]);
            if(alreadyNotified == false)
            {
               InstanceMng.getTopHudFacade().showProgressIcon(target.Id);
               this.mConditionsNotifiedCatalog[index] = true;
               notifyTracking(target,index);
            }
         }
      }
      
      public function cleanCondition() : void
      {
         var index:int = 0;
         var length:int = int(this.mConditionsArray.length);
         for(index = 0; index < length; )
         {
            this.mConditionsNotifiedCatalog[index] = false;
            delete this.mConditionsArray[index];
            index++;
         }
      }
   }
}
