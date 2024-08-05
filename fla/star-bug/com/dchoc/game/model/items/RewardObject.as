package com.dchoc.game.model.items
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.text.DCTextMng;
   
   public class RewardObject
   {
      
      private static const REWARD_TYPE:int = 0;
      
      private static const REWARD_PARAM:int = 1;
      
      private static const REWARD_ITEM_AMOUNT:int = 2;
      
      public static const REWARD_TYPE_COINS:String = "coins";
      
      public static const REWARD_TYPE_MINERALS:String = "minerals";
      
      public static const REWARD_TYPE_ITEM:String = "item";
      
      public static const REWARD_TYPE_SPECIAL_ATTACK:String = "specialAttack";
      
      public static const REWARD_TYPE_CHIPS:String = "chips";
      
      public static const REWARD_TYPE_BADGES:String = "badges";
      
      public static const FROM_CRM:int = 0;
       
      
      public var mSku:String;
      
      private var mAmount:SecureInt;
      
      private var mText:SecureString;
      
      private var mDesc:SecureString;
      
      private var mInfo:SecureString;
      
      private var mAssetId:SecureString;
      
      private var mItem:ItemObject;
      
      private var mSpecialAttackDef:SpecialAttacksDef;
      
      private var mRewardIsValid:SecureBoolean;
      
      private var mEntryStr:SecureString;
      
      private var mRewardArray:Array;
      
      public function RewardObject(reward:Array, specialAttackDef:SpecialAttacksDef = null, from:int = -1)
      {
         mAmount = new SecureInt("RewardObject.mAmount");
         mText = new SecureString("RewardObject.mText");
         mDesc = new SecureString("RewardObject.mDesc");
         mInfo = new SecureString("RewardObject.mInfo");
         mAssetId = new SecureString("RewardObject.mAssetId");
         mRewardIsValid = new SecureBoolean("RewardObject.mRewardIsValid");
         mEntryStr = new SecureString("RewardObject.mEntryStr");
         super();
         this.mRewardArray = reward;
         this.mSku = specialAttackDef == null ? reward[0] : "specialAttack";
         this.loadData(reward,specialAttackDef,from);
      }
      
      public static function belongsToSpecialGroup(item:ItemObject) : Boolean
      {
         if(item == null)
         {
            return false;
         }
         return item != null && ["coins","minerals"].indexOf(item.mDef.getActionType()) > -1;
      }
      
      private function loadData(reward:Array, specialAttackDef:SpecialAttacksDef = null, from:int = -1) : void
      {
         var def:RewardsDef = InstanceMng.getRewardsDefMng().getDefBySku(this.mSku) as RewardsDef;
         this.mRewardIsValid.value = def != null;
         if(this.mRewardIsValid.value)
         {
            switch(def.mSku)
            {
               case "coins":
               case "minerals":
               case "chips":
               case "badges":
                  this.mAmount.value = int(reward[1]);
                  this.mText.value = def.getNameToDisplay();
                  this.mAssetId.value = def.getAssetId();
                  this.mDesc.value = def.getDescToDisplay();
                  this.mInfo.value = def.getInfoToDisplay();
                  this.mEntryStr.value = def.mSku + ":" + this.mAmount.value;
                  break;
               case "item":
                  this.mItem = InstanceMng.getItemsMng().getItemObjectBySku(reward[1]) as ItemObject;
                  this.mRewardIsValid.value = this.mItem != null;
                  if(this.mRewardIsValid.value)
                  {
                     if(reward.length > 2)
                     {
                        this.mAmount.value = reward[2];
                     }
                     else
                     {
                        this.mAmount.value = 1;
                     }
                     this.mText.value = this.mItem.mDef.getNameToDisplay();
                     this.mAssetId.value = this.mItem.mDef.getAssetId();
                     this.mDesc.value = this.mItem.mDef.getDescToDisplay();
                     this.mInfo.value = this.mItem.mDef.getInfoToDisplay();
                     this.mSpecialAttackDef = InstanceMng.getSpecialAttacksDefMng().getDefFromItemDef(this.mItem.mDef);
                     this.mEntryStr.value = this.mItem.mDef.mSku + ":" + this.mAmount.value;
                  }
                  break;
               case "specialAttack":
                  this.mSpecialAttackDef = specialAttackDef == null ? InstanceMng.getSpecialAttacksDefMng().getDefBySku(reward[1]) as SpecialAttacksDef : specialAttackDef;
                  this.mAmount.value = 1;
                  this.mText.value = this.mSpecialAttackDef.getNameToDisplay();
                  this.mAssetId.value = this.mSpecialAttackDef.getAssetId();
                  this.mDesc.value = this.mSpecialAttackDef.getDescToDisplay();
                  this.mInfo.value = this.mSpecialAttackDef.getInfoToDisplay();
                  this.mItem = InstanceMng.getItemsMng().getItemObjectBySku(this.mSpecialAttackDef.getItemSku()) as ItemObject;
                  if(this.mItem != null)
                  {
                     this.mEntryStr.value = this.mItem.mDef.mSku + ":" + this.mAmount.value;
                  }
            }
         }
         switch(from)
         {
            case 0:
               this.mDesc.value = DCTextMng.replaceParameters(437,[this.mText.value]);
               this.mText.value = DCTextMng.getText(436);
         }
      }
      
      public function isValid() : Boolean
      {
         return this.mRewardIsValid.value;
      }
      
      public function getRewardType() : String
      {
         return this.mSku;
      }
      
      public function overrideTitle(text:String) : void
      {
         this.mText.value = DCTextMng.getText(text);
      }
      
      public function overrideDescription(text:String) : void
      {
         this.mDesc.value = DCTextMng.getText(text);
      }
      
      public function updateAmountOwned(craftDef:CraftingDef, craftColl:Array) : void
      {
         var itemObject:ItemObject = null;
         var amountNeeded:int = 0;
         var amountTimesCanBeUsed:int = 0;
         if(this.mSpecialAttackDef == null)
         {
            return;
         }
         var minValue:int = 2147483647;
         var l:int = 4;
         var i:int = 1;
         while(i <= l && minValue > 0)
         {
            itemObject = ItemObject(craftColl[i]);
            amountTimesCanBeUsed = int((amountNeeded = int(craftDef.getCraftingList()[i - 1][1])) <= 0 ? 0 : int(Math.floor(itemObject.quantity / amountNeeded)));
            minValue = Math.min(minValue,amountTimesCanBeUsed);
            i++;
         }
         this.addAmountOwned(minValue);
      }
      
      public function getAmount() : int
      {
         return this.mAmount.value;
      }
      
      public function getText() : String
      {
         return this.mText.value;
      }
      
      public function getStringToDisplay() : String
      {
         return this.mItem == null ? "" : this.mItem.getTooltipDescriptionText();
      }
      
      public function getAssetId() : String
      {
         if(!this.mRewardIsValid.value)
         {
            this.loadData(mRewardArray);
         }
         return this.mAssetId.value;
      }
      
      public function getItem() : ItemObject
      {
         return this.mItem;
      }
      
      public function getDesc() : String
      {
         return this.mDesc.value;
      }
      
      public function getInfo() : String
      {
         return this.mInfo.value;
      }
      
      public function getSpecialAttackDef() : SpecialAttacksDef
      {
         return this.mSpecialAttackDef;
      }
      
      public function getAmountOwned() : int
      {
         return this.mItem == null ? 0 : this.mItem.quantity;
      }
      
      public function addAmountOwned(amount:int) : void
      {
         if(this.mItem)
         {
            InstanceMng.getItemsMng().addItemAmount(this.mItem.mDef.mSku,amount,false,false,true,true);
         }
      }
      
      public function getItemActionParam() : String
      {
         if(this.mItem == null)
         {
            return "";
         }
         return this.mItem.mDef.getActionParam();
      }
      
      public function getEntryStr() : String
      {
         return this.mEntryStr.value;
      }
   }
}
