package com.dchoc.toolkit.core.target.condition
{
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class DCCondition
   {
      
      public static const UNLOCK_BYTARGETIDS:String = "targets";
      
      public static const UNLOCK_BYLEVEL:String = "level";
      
      public static const UNLOCK_NOT_ALLOWED:String = "notAllowed";
       
      
      public var mConditionId:String;
      
      public var mConditionAlreadyNotified:Boolean;
      
      public function DCCondition()
      {
         super();
      }
      
      public function check(target:DCTarget, index:int = 0) : Boolean
      {
         return true;
      }
      
      public function launchEventOnConditionAccomplished(target:DCTarget, index:int = 0) : void
      {
      }
      
      public function getConditionId() : String
      {
         return this.mConditionId;
      }
      
      public function setConditionId(conditionId:String) : void
      {
         this.mConditionId = conditionId;
      }
      
      public function checkIfNeeded(type:String) : Boolean
      {
         return type == this.mConditionId;
      }
      
      public function getConditionAlreadyNotified() : Boolean
      {
         return this.mConditionAlreadyNotified;
      }
      
      public function setConditionAlreadyNotified(value:Boolean) : void
      {
         this.mConditionAlreadyNotified = value;
      }
   }
}
