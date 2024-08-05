package com.dchoc.game.model.items
{
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class AlliancesRewardDef extends RewardsDef
   {
      
      public static const CONDITION_BATTLES_WON:String = "alliancesBattlesWon";
      
      public static const CONDITION_WAR_POINTS:String = "warPoints";
       
      
      private var mRewardArr:Array;
      
      private var mConditionsCatalog:Dictionary;
      
      private var mRewardObject:RewardObject;
      
      public function AlliancesRewardDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "reward";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mRewardArr = EUtils.xmlReadString(info,attribute).split(":");
            this.mRewardObject = new RewardObject(this.mRewardArr);
         }
         attribute = "conditions";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setConditions(EUtils.xmlReadString(info,attribute));
         }
      }
      
      public function getReward() : Array
      {
         return this.mRewardArr;
      }
      
      public function isRewardItem() : Boolean
      {
         return this.mRewardArr[0] == "item";
      }
      
      public function getRewardItemSku() : String
      {
         if(this.isRewardItem() == false)
         {
            return null;
         }
         return this.mRewardArr[1];
      }
      
      public function getConditionsCatalog() : Dictionary
      {
         return this.mConditionsCatalog;
      }
      
      public function getConditionAmountBySku(sku:String) : int
      {
         var returnValue:int = -1;
         if(this.mConditionsCatalog != null)
         {
            returnValue = int(this.mConditionsCatalog[sku]);
         }
         return returnValue;
      }
      
      public function setConditions(value:String) : void
      {
         var i:int = 0;
         var condName:String = null;
         var condAmount:String = null;
         if(this.mConditionsCatalog == null)
         {
            this.mConditionsCatalog = new Dictionary();
         }
         var condsArrAux:Array = [];
         condsArrAux = value.split(",");
         var cond:Array = [];
         for(i = 0; i < condsArrAux.length; )
         {
            if((cond = String(condsArrAux[i]).split(":")) != null)
            {
               condName = String(cond[0]);
               condAmount = String(cond[1]);
               if(condName != null && condAmount != null)
               {
                  this.mConditionsCatalog[condName] = condAmount;
               }
            }
            i++;
         }
      }
      
      public function getRewardObject() : RewardObject
      {
         return this.mRewardObject;
      }
   }
}
