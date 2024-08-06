package com.dchoc.game.model.userdata
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.premiumShop.PopupPremiumShop;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class PendingTransaction
   {
      
      public static const SOURCE_CONTEST_ID:String = "contest";
      
      public static const SOURCE_CRM_ID:String = "crm";
      
      public static const SOURCE_PURCHASE_ID:String = "purchase";
      
      public static const SOURCE_PROMO_ADD_CREDIT_CARD_ID:String = "promoAddCreditCard";
      
      public static const SOURCE_UPSELLING_ID:String = "upSelling";
      
      public static const PARAM_KEY_RANK:String = "rank";
      
      public static const PARAM_KEY_ID:String = "id";
      
      public static const PARAM_KEY_SKU:String = "sku";
      
      public static const PARAM_ORIGIN_SKU:String = "origin";
       
      
      private var mId:SecureString;
      
      private var mType:SecureString;
      
      private var mAmount:SecureNumber;
      
      private var mItemSku:SecureString;
      
      private var mAppliedByServer:SecureBoolean;
      
      private var mNeedsToNotifyServerByAddItem:SecureBoolean;
      
      private var mReward:RewardObject;
      
      private var mRewardAsEntryString:SecureString;
      
      private var mSource:SecureString;
      
      private var mParams:SecureString;
      
      private var mParamsDictionary:Dictionary;
      
      public function PendingTransaction()
      {
         mId = new SecureString("PendingTransaction.mId");
         mType = new SecureString("PendingTransaction.mType");
         mAmount = new SecureNumber("PendingTransaction.mAmount");
         mItemSku = new SecureString("PendingTransaction.mItemSku");
         mAppliedByServer = new SecureBoolean("PendingTransaction.mAppliedByServer");
         mNeedsToNotifyServerByAddItem = new SecureBoolean("PendingTransaction.mNeedsToNotifyServerByAddItem");
         mRewardAsEntryString = new SecureString("PendingTransaction.mRewardAsEntryString");
         mSource = new SecureString("PendingTransaction.mSource");
         mParams = new SecureString("PendingTransaction.mParams");
         super();
      }
      
      public function fromXML(xml:XML) : void
      {
         this.mId.value = EUtils.xmlReadString(xml,"id");
         this.mType.value = EUtils.xmlReadString(xml,"type");
         if(GameConstants.currencyHasToDoWithItems(this.mType.value))
         {
            this.mItemSku.value = EUtils.xmlReadString(xml,"itemSku");
         }
         this.mAmount.value = EUtils.xmlReadNumber(xml,"amount");
         this.mAppliedByServer.value = EUtils.xmlReadBoolean(xml,"applied");
         this.mNeedsToNotifyServerByAddItem.value = EUtils.xmlReadBoolean(xml,"notifyServerByAddItem");
         this.mSource.value = EUtils.xmlReadString(xml,"source");
         if(this.mNeedsToNotifyServerByAddItem.value)
         {
            this.mAppliedByServer.value = true;
         }
         this.mReward = InstanceMng.getRuleMng().createRewardObjectFromParams(this.mType.value,this.mAmount.value,this.mItemSku.value,null,this.mSource.value == "crm" ? 0 : -1);
         this.mRewardAsEntryString.value = this.mItemSku.value != null && this.mItemSku.value != "" ? this.mItemSku.value : this.mType.value;
         this.mRewardAsEntryString.value += ":" + this.mAmount.value;
         this.mParams.value = EUtils.xmlReadString(xml,"params");
      }
      
      public function getRewardAsEntryString() : String
      {
         return this.mRewardAsEntryString.value;
      }
      
      public function hasBeenAppliedByServer() : Boolean
      {
         return this.mAppliedByServer.value;
      }
      
      public function needsToNotifyServerByAddItem() : Boolean
      {
         return this.mNeedsToNotifyServerByAddItem.value;
      }
      
      public function canBeApplied() : Boolean
      {
         return this.mReward != null && this.mReward.isValid();
      }
      
      public function getId() : String
      {
         return this.mId.value;
      }
      
      public function getType() : String
      {
         return this.mType.value;
      }
      
      public function getItemSku() : String
      {
         return this.mItemSku.value;
      }
      
      public function getAmount() : Number
      {
         return this.mAmount.value;
      }
      
      public function getSource() : String
      {
         return this.mSource.value;
      }
      
      private function expandParams() : void
      {
         var tokens:Array = null;
         var token:String = null;
         var words:Array = null;
         this.mParamsDictionary = new Dictionary(true);
         if(this.mParams.value != null)
         {
            tokens = this.mParams.value.split(",");
            for each(token in tokens)
            {
               words = token.split(":");
               this.mParamsDictionary[words[0]] = words[1];
            }
         }
      }
      
      public function getParamFromKey(key:String) : String
      {
         if(this.mParamsDictionary == null)
         {
            this.expandParams();
         }
         return this.mParamsDictionary[key] != undefined ? this.mParamsDictionary[key] : null;
      }
      
      public function process() : void
      {
         if(this.canBeApplied())
         {
            InstanceMng.getItemsMng().applyReward(this.mReward);
         }
      }
      
      public function canBeAccumulated() : Boolean
      {
         return this.mSource.value != "contest";
      }
      
      public function presentToTheUser(acceptFunction:Function = null) : DCIPopup
      {
         var advisor:String = null;
         DCDebug.traceCh("PendingTransaction","Presenting PT to the user. Applicable? " + this.canBeApplied());
         var popupSource:String = null;
         var popup:DCIPopup = null;
         var premiumShop:PopupPremiumShop = null;
         var returnValue:DCIPopup = null;
         if(this.canBeApplied())
         {
            if(Config.useContests() && this.mSource.value == "contest")
            {
               InstanceMng.getContestMng().rewardsGivePendingTransaction(this.mRewardAsEntryString.value,this);
            }
            else
            {
               this.process();
               popupSource = this.mSource.value == "purchase" ? "purchase" : "pending";
               advisor = String(this.mReward.getRewardType() == "badges" ? "alliance_council_happy" : null);
               returnValue = InstanceMng.getNotificationsMng().guiOpenTradeInPopup(popupSource,this.mReward,true,acceptFunction,false,null);
               if(this.mSource.value == "purchase")
               {
                  popup = InstanceMng.getPopupMng().getStackedPopupById("PopupPurchaseShop");
                  if(popup != null)
                  {
                     (premiumShop = popup as PopupPremiumShop).buyWithCreditsPerformed();
                  }
               }
            }
            if(this.mSource.value == "upSelling")
            {
               InstanceMng.getUpSellingMng().notifyOfferAccepted(this.getParamFromKey("sku"));
            }
         }
         return returnValue;
      }
   }
}
