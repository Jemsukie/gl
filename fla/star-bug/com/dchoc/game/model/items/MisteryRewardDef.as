package com.dchoc.game.model.items
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class MisteryRewardDef extends DCDef
   {
       
      
      private var mRewardType:String = "";
      
      private var mAmount:String = "0";
      
      public function MisteryRewardDef()
      {
         super();
      }
      
      override public function fromXml(info:XML, key:String = "default") : Boolean
      {
         var attribute:String = "type";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mRewardType = EUtils.xmlReadString(info,attribute);
         }
         attribute = "amount";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mAmount = EUtils.xmlReadString(info,attribute);
         }
         return super.fromXml(info,key);
      }
      
      public function getType() : String
      {
         return this.mRewardType;
      }
      
      public function getAmount() : String
      {
         return this.mAmount;
      }
   }
}
