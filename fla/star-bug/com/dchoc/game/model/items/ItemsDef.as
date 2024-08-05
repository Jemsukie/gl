package com.dchoc.game.model.items
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.rule.PlatformSettingsDefMng;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class ItemsDef extends DCDef
   {
      
      private static const YES:String = "yes";
      
      public static const FIELD_PRICE_PC:String = "price";
      
      public static const FIELD_OFFER_PRICE:String = "offerPrice";
      
      public static const FREEGIFT:String = "FG";
      
      public static const WISHLIST:String = "WL";
      
      public static const ITEM_PARAMETER:int = 0;
      
      public static const ITEM_UPGRADE:int = 1;
      
      public static const ITEM_NPC:int = 2;
      
      public static const GIVING_CONDITION_MISSION_SKU:String = "skumission";
      
      public static const GIVING_CONDITION_LIST_SEQUENCE:String = "listSequence";
       
      
      private var mActionSku:SecureString;
      
      private var mAvailableList:SecureString;
      
      private var mFreeGiftLevelUnlocked:SecureInt;
      
      private var mMenu:SecureString;
      
      private var mUseFromInventory:SecureBoolean;
      
      private var mRemoveFromInventory:SecureBoolean;
      
      private var mItemAction:Array;
      
      private var mParameters:Array;
      
      private var mSequences:Array;
      
      private var mGivingCondition:SecureString;
      
      private var mItemName:SecureString;
      
      private var mItemType:SecureString;
      
      private var mTimeToGive:SecureInt;
      
      private var mMaxAmountInventory:SecureInt;
      
      private var mUseDroidsFromInventory:SecureInt;
      
      private var mOfferStartDate:SecureNumber;
      
      private var mOfferEndDate:SecureNumber;
      
      private var mOfferPrice:SecureInt;
      
      private var mShopAssetId:SecureString;
      
      private var mUseNow:SecureBoolean;
      
      private var mShowInInventory:SecureBoolean;
      
      private var mIsOffer:SecureBoolean;
      
      private var mOfferBkg:SecureString;
      
      private var mOfferTitle:SecureString;
      
      private var mOfferDesc:SecureString;
      
      private var mUseActionParams:Array = null;
      
      private var mUseActionType:SecureString;
      
      private var mCredits:SecureNumber;
      
      private var mEntry:Entry;
      
      private var mEntryPay:Entry;
      
      private var mEntryReward:Entry;
      
      private var mPosBuyAction:SecureString;
      
      private var mShopProgressSku:SecureString;
      
      private var mContestOwner:SecureString;
      
      private var mDoRandomSequence:SecureBoolean;
      
      private var mPlatformCreditsTag:Dictionary;
      
      private var mEmbassyTab:SecureInt;
      
      private var mPriceBadges:SecureInt;
      
      public function ItemsDef()
      {
         mActionSku = new SecureString("ItemsDef.mActionSku","");
         mAvailableList = new SecureString("ItemsDef.mAvailableList","");
         mFreeGiftLevelUnlocked = new SecureInt("ItemsDef.mFreeGiftLevelUnlocked");
         mMenu = new SecureString("ItemsDef.mMenu","");
         mUseFromInventory = new SecureBoolean("ItemsDef.mUseFromInventory");
         mRemoveFromInventory = new SecureBoolean("ItemsDef.mRemoveFromInventory");
         mGivingCondition = new SecureString("ItemsDef.mGivingCondition","");
         mItemName = new SecureString("ItemsDef.mItemName","");
         mItemType = new SecureString("ItemsDef.mItemType","");
         mTimeToGive = new SecureInt("ItemsDef.mTimeToGive");
         mMaxAmountInventory = new SecureInt("ItemsDef.mMaxAmountInventory",0);
         mUseDroidsFromInventory = new SecureInt("ItemsDef.mUseDroidsFromInventory");
         mOfferStartDate = new SecureNumber("ItemsDef.mOfferStartDate");
         mOfferEndDate = new SecureNumber("ItemsDef.mOfferEndDate");
         mOfferPrice = new SecureInt("ItemsDef.mOfferPrice");
         mShopAssetId = new SecureString("ItemsDef.mShopAssetId","");
         mUseNow = new SecureBoolean("ItemsDef.mUseNow");
         mShowInInventory = new SecureBoolean("ItemsDef.mShowInInventory");
         mIsOffer = new SecureBoolean("ItemsDef.mIsOffer");
         mOfferBkg = new SecureString("ItemsDef.mOfferBkg","");
         mOfferTitle = new SecureString("ItemsDef.mOfferTitle","");
         mOfferDesc = new SecureString("ItemsDef.mOfferDesc","");
         mUseActionType = new SecureString("ItemsDef.mUseActionType","");
         mCredits = new SecureNumber("ItemsDef.mCredits");
         mPosBuyAction = new SecureString("ItemsDef.mPosBuyAction");
         mShopProgressSku = new SecureString("ItemsDef.mShopProgressSku");
         mContestOwner = new SecureString("ItemsDef.mContestOwner");
         mDoRandomSequence = new SecureBoolean("ItemsDef.mDoRandomSequence");
         mEmbassyTab = new SecureInt("ItemsDef.mEmbassyTab");
         mPriceBadges = new SecureInt("ItemsDef.mEmbassyTab");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var length:int = 0;
         var i:int = 0;
         var name:String = null;
         var value:String = null;
         var def:DCDef = null;
         var key:String = null;
         var platformSku:String = null;
         var parameters:Array = null;
         var param:String = null;
         var index:int = 0;
         var seqs:Array = null;
         var seq:String = null;
         var seqArray:Array = null;
         var seqInt:Array = null;
         var attribute:String = "useAction";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mActionSku.value = EUtils.xmlReadString(info,attribute);
         }
         attribute = "useDroids";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mUseDroidsFromInventory.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "freeGiftWishlist";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mAvailableList.value = EUtils.xmlReadString(info,attribute);
         }
         attribute = "freeGiftLevelUnlocked";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mFreeGiftLevelUnlocked.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "menus";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mMenu.value = EUtils.xmlReadString(info,attribute);
         }
         attribute = "name";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mItemName.value = EUtils.xmlReadString(info,attribute);
         }
         attribute = "type";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mItemType.value = EUtils.xmlReadString(info,attribute);
         }
         attribute = "removeFromInventory";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mRemoveFromInventory.value = EUtils.xmlReadString(info,attribute) == "yes";
         }
         attribute = "itemAction";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mItemAction = EUtils.xmlReadString(info,attribute).split(",");
         }
         attribute = "timeToGive";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mTimeToGive.value = DCTimerUtil.hourToMs(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "maxAmountInventory";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mMaxAmountInventory.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "assetId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            setAssetId(EUtils.xmlReadString(info,attribute));
         }
         else if(this.getAssetId() == "")
         {
            setAssetId("gift_mineral");
         }
         var actionType:String = this.getActionType();
         this.mUseFromInventory.value = actionType != "" && actionType != "specialAttack" && actionType != "deployUnit";
         attribute = "parameters";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            parameters = EUtils.xmlReadString(info,attribute).split(",");
            index = 0;
            this.mParameters = [];
            for each(param in parameters)
            {
               this.mParameters.push(param.split(":"));
               if(this.mParameters[index].length == 2)
               {
                  this.mParameters[index][2] = "";
               }
               index++;
            }
         }
         attribute = "givenCondition";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            seqs = EUtils.xmlReadString(info,attribute).split(",");
            this.mSequences = [];
            for each(seq in seqs)
            {
               seqArray = seq.split(":");
               this.mGivingCondition.value = seqArray[0];
               if(this.mGivingCondition.value == "skumission")
               {
                  this.mSequences.push(seqArray[1]);
               }
               else
               {
                  length = int(seqArray.length);
                  seqInt = [];
                  for(i = 1; i < length; )
                  {
                     seqInt.push(seqArray[i]);
                     i++;
                  }
                  this.mSequences.push(seqInt);
               }
            }
         }
         paidCurrencyRead("price",info);
         attribute = "offerStartDate";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setOfferStartDate(EUtils.xmlReadString(info,attribute));
         }
         attribute = "offerEndDate";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setOfferEndDate(EUtils.xmlReadString(info,attribute));
         }
         attribute = "shopAssetId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShopAssetId(EUtils.xmlReadString(info,attribute));
         }
         attribute = "useNow";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUseNow(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "showInInventory";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShowInInventory(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "offer";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIsOffer(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "offerBkgId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setOfferBkg(EUtils.xmlReadString(info,attribute));
         }
         attribute = "offerTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setOfferTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "offerDesc";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setOfferDesc(EUtils.xmlReadString(info,attribute));
         }
         attribute = "posBuyAction";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPosBuyAction(EUtils.xmlReadString(info,attribute));
         }
         attribute = "shopProgressSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShopProgressSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "doRandom";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDoRandomSequence(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "embassyTab";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setEmbassyTab(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "priceBadges";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPriceBadges(EUtils.xmlReadInt(info,attribute));
         }
         var attributes:XMLList;
         length = (attributes = EUtils.xmlGetAttributesAsXMLList(info)).length();
         var platformSettingsDefMng:PlatformSettingsDefMng;
         var defs:Vector.<DCDef> = (platformSettingsDefMng = InstanceMng.getPlatformSettingsDefMng()).getDefs();
         param = "creditsTag";
         for each(def in defs)
         {
            platformSku = String(def.getSku());
            key = param + "_" + platformSku;
            for(i = 0; i < length; )
            {
               if((name = String(attributes[i].name())) == key)
               {
                  value = info.attribute(name);
                  this.setPlatformCreditsTag(platformSku,value);
                  break;
               }
               i++;
            }
         }
         paidCurrencyRead("offerPrice",info);
         attribute = "contestOwner";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setContestOwner(EUtils.xmlReadString(info,attribute));
         }
      }
      
      public function getActualItemSku() : String
      {
         var arr:Array = null;
         var returnValue:String = mSku;
         if(this.isUseActionTypeItem())
         {
            if(this.mActionSku.value != null)
            {
               arr = this.mActionSku.value.split(":");
               returnValue = String(arr[1]);
            }
         }
         return returnValue;
      }
      
      public function getMaxAmountInventory() : int
      {
         return this.mMaxAmountInventory.value;
      }
      
      public function setMaxAmountInventory(value:int) : void
      {
         this.mMaxAmountInventory.value = value;
      }
      
      public function hasMaxAmountInventory() : Boolean
      {
         return this.mMaxAmountInventory.value > 0;
      }
      
      public function getUseDroidsFromInventory() : int
      {
         return this.mUseDroidsFromInventory.value;
      }
      
      public function isInFreeGift() : Boolean
      {
         return this.mAvailableList.value.indexOf("FG") > -1;
      }
      
      public function isInWishList() : Boolean
      {
         return this.mAvailableList.value.indexOf("WL") > -1;
      }
      
      public function getMenusList() : Array
      {
         return this.mMenu.value.split(",");
      }
      
      public function getOriginalChipsCost() : int
      {
         return InstanceMng.getRuleMng().paidCurrencyGetField(this,"price").mAmount;
      }
      
      public function isUsableFromInventory() : Boolean
      {
         return this.mUseFromInventory.value;
      }
      
      public function isRemovableFromInventory() : Boolean
      {
         return Config.DEBUG_ITEMS ? true : this.mRemoveFromInventory.value;
      }
      
      public function isDroidPart() : Boolean
      {
         return this.mItemName.value.indexOf("droidPart") > -1;
      }
      
      public function getItemActionList() : Array
      {
         return this.mItemAction;
      }
      
      public function getParameters() : Array
      {
         return this.mParameters;
      }
      
      public function getSequences() : Array
      {
         return this.mSequences;
      }
      
      public function getItemType() : String
      {
         return this.mItemType.value;
      }
      
      public function getInventoryBoxType() : String
      {
         var returnValue:String = this.getActionType();
         if(returnValue == "")
         {
            returnValue = this.getItemType();
         }
         return returnValue;
      }
      
      public function getItemName() : String
      {
         return this.mItemName.value;
      }
      
      public function getGivingCondition() : String
      {
         return this.mGivingCondition.value;
      }
      
      public function shuffleSequences() : void
      {
      }
      
      public function getActionSku() : String
      {
         return this.mActionSku.value;
      }
      
      public function getActionType() : String
      {
         if(this.mActionSku.value != null && this.mActionSku.value != "")
         {
            this.mUseActionType.value = this.mActionSku.value.split(":")[0];
         }
         return this.mUseActionType.value;
      }
      
      public function isUseActionTypeItem() : Boolean
      {
         return this.getActionType() == "item";
      }
      
      public function getUseActionItemAmount() : int
      {
         var actionParam:String = null;
         var returnValue:int = 1;
         if(this.isUseActionTypeItem())
         {
            actionParam = String(this.getActionParam().split(":")[1]);
            if(actionParam && parseInt(actionParam) > 1)
            {
               returnValue = parseInt(actionParam);
            }
         }
         return returnValue;
      }
      
      public function getActionParams() : Array
      {
         var arr:Array = null;
         var arr2:Array = null;
         var i:int = 0;
         var returnValue:* = null;
         if(this.mActionSku.value != null && this.mActionSku.value != "")
         {
            arr = this.mActionSku.value.split(",");
            if((arr2 = arr[0].split(":")).length > 1)
            {
               arr[0] = arr2[1];
               for(i = 2; i < arr2.length; )
               {
                  arr[0] += ":" + arr2[i];
                  i++;
               }
               returnValue = arr;
            }
         }
         return returnValue;
      }
      
      public function getActionParam(index:int = 0) : String
      {
         var arr:Array = this.getActionParams();
         if(arr != null)
         {
            return arr[index];
         }
         return "";
      }
      
      public function getRewardSequence() : Array
      {
         return this.mSequences[0];
      }
      
      public function getTimeToGive() : int
      {
         return this.mTimeToGive.value;
      }
      
      override public function getInfoToDisplay() : String
      {
         var txt:String = super.getInfoToDisplay();
         if(mSku == "10000")
         {
            txt = DCTextMng.replaceParameters(txt,[InstanceMng.getSettingsDefMng().getSpyCapsulesForFreeItemsEntry().getAmount()]);
         }
         return txt;
      }
      
      private function setOfferStartDate(value:String) : void
      {
         this.mOfferStartDate.value = Date.parse(value + " UTC");
         var timer:Number = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
         DCDebug.traceCh("HAPP","< " + mSku + "> offer startDate millis = " + this.mOfferStartDate.value + " diff = " + (timer - this.mOfferStartDate.value));
      }
      
      public function getOfferStartDate() : Number
      {
         return this.mOfferStartDate.value;
      }
      
      private function setOfferEndDate(value:String) : void
      {
         this.mOfferEndDate.value = Date.parse(value + " UTC");
         DCDebug.traceCh("HAPP","< " + mSku + "> offer endDate millis = " + this.mOfferEndDate.value);
      }
      
      public function getOfferEndDate() : Number
      {
         return this.mOfferEndDate.value;
      }
      
      private function setOfferPrice(value:int) : void
      {
         this.mOfferPrice.value = value;
      }
      
      public function getOfferChipsCost() : int
      {
         return InstanceMng.getRuleMng().paidCurrencyGetField(this,"offerPrice").mAmount;
      }
      
      public function getChipsCost() : int
      {
         if(this.isOfferEnabled())
         {
            return this.getOfferChipsCost();
         }
         return this.getOriginalChipsCost();
      }
      
      public function isOfferEnabled() : Boolean
      {
         var timer:Number = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
         return timer >= this.mOfferStartDate.value && timer < this.mOfferEndDate.value;
      }
      
      private function setShopAssetId(value:String) : void
      {
         this.mShopAssetId.value = value;
      }
      
      public function getShopAssetId() : String
      {
         return this.mShopAssetId.value;
      }
      
      private function setUseNow(value:Boolean) : void
      {
         this.mUseNow.value = value;
      }
      
      public function getUseNow() : Boolean
      {
         return this.mUseNow.value;
      }
      
      private function setShowInInventory(value:Boolean) : void
      {
         this.mShowInInventory.value = value;
      }
      
      public function getShowInInventory() : Boolean
      {
         return Config.DEBUG_ITEMS || this.mShowInInventory.value;
      }
      
      private function setIsOffer(value:Boolean) : void
      {
         this.mIsOffer.value = value;
      }
      
      public function getIsOffer() : Boolean
      {
         return this.mIsOffer.value;
      }
      
      private function setOfferBkg(value:String) : void
      {
         this.mOfferBkg.value = value;
      }
      
      public function getOfferBkg() : String
      {
         return this.mOfferBkg.value;
      }
      
      private function setOfferTitle(value:String) : void
      {
         this.mOfferTitle.value = value;
      }
      
      public function getOfferTitle() : String
      {
         return DCTextMng.getText(TextIDs[this.mOfferTitle.value]);
      }
      
      private function setOfferDesc(value:String) : void
      {
         this.mOfferDesc.value = value;
      }
      
      public function getOfferDesc() : String
      {
         return DCTextMng.getText(TextIDs[this.mOfferDesc.value]);
      }
      
      public function getOfferParams() : Array
      {
         return this.getActionParams();
      }
      
      public function getIcon(forceThisItem:Boolean = false) : String
      {
         var itemSku:String = null;
         var itemDef:ItemsDef = null;
         if(this.getActionType() == "item" && !forceThisItem)
         {
            itemSku = String(this.getActionParam().split(":")[0]);
            itemDef = InstanceMng.getItemsDefMng().getDefBySku(itemSku) as ItemsDef;
            return itemDef.getAssetId();
         }
         return this.getAssetId();
      }
      
      override public function getAssetId() : String
      {
         var arr:Array = null;
         var asset:String = super.getAssetId();
         if(asset.indexOf("/") > -1)
         {
            arr = asset.split("/");
            return arr[arr.length - 1];
         }
         return asset;
      }
      
      public function getAmount() : String
      {
         var returnValue:String = "1";
         var tokens:Array = this.getActionParam().split(":");
         if(tokens.length > 1)
         {
            returnValue = String(this.getActionParam().split(":")[1]);
         }
         return returnValue;
      }
      
      private function setCredits(value:Number) : void
      {
         this.mCredits.value = value;
      }
      
      public function getCredits() : Number
      {
         return this.mCredits.value;
      }
      
      public function getCash() : int
      {
         return this.getChipsCost();
      }
      
      public function getEntryPay() : Entry
      {
         if(this.mEntryPay == null)
         {
            if(this.mCredits.value > 0)
            {
               this.mEntryPay = EntryFactory.createCreditsSingleEntry(this.mCredits.value,true);
            }
            else
            {
               this.mEntryPay = EntryFactory.createCashSingleEntry(this.getCash(),true);
            }
         }
         return this.mEntryPay;
      }
      
      public function getEntryReward() : Entry
      {
         if(this.mEntryReward == null)
         {
            this.mEntryReward = EntryFactory.createItemSingleEntry(mSku,1);
            this.mEntryReward.setParam("checkLimit",false);
         }
         return this.mEntryReward;
      }
      
      public function getEntry() : Entry
      {
         var vecSingleEntries:Vector.<Entry> = null;
         if(this.mEntry == null)
         {
            vecSingleEntries = new Vector.<Entry>(0);
            vecSingleEntries.push(this.getEntryReward());
            vecSingleEntries.push(this.getEntryPay());
            this.mEntry = EntryFactory.createEntryFromSingleEntries(vecSingleEntries);
         }
         return this.mEntry;
      }
      
      public function getTimeLeft() : Number
      {
         var returnValue:Number = -1;
         return InstanceMng.getApplication().timeLeftGet(this.mActionSku.value);
      }
      
      public function hasTimeLeft() : Boolean
      {
         var timeLeft:Number = this.getTimeLeft();
         return timeLeft > -1;
      }
      
      public function getTimeLeftSku() : String
      {
         return InstanceMng.getApplication().timeLeftGetSku(this.mActionSku.value);
      }
      
      private function setPosBuyAction(value:String) : void
      {
         this.mPosBuyAction.value = value;
      }
      
      public function getPosBuyAction() : String
      {
         return this.mPosBuyAction.value;
      }
      
      public function setShopProgressSku(value:String) : void
      {
         this.mShopProgressSku.value = value;
      }
      
      public function getShopProgressSku() : String
      {
         return this.mShopProgressSku.value;
      }
      
      private function setPlatformCreditsTag(platformSku:String, value:String) : void
      {
         if(this.mPlatformCreditsTag == null)
         {
            this.mPlatformCreditsTag = new Dictionary(true);
         }
         this.mPlatformCreditsTag[platformSku] = value;
      }
      
      public function getPlatformCreditsTag(platformSku:String) : String
      {
         return this.mPlatformCreditsTag == null ? null : this.mPlatformCreditsTag[platformSku];
      }
      
      private function setContestOwner(value:String) : void
      {
         this.mContestOwner.value = value;
      }
      
      public function getContestOwner() : String
      {
         return this.mContestOwner.value;
      }
      
      public function setDoRandomSequence(value:Boolean) : void
      {
         this.mDoRandomSequence.value = value;
      }
      
      public function getDoRandomSequence() : Boolean
      {
         return mDoRandomSequence.value;
      }
      
      public function setEmbassyTab(value:int) : void
      {
         this.mEmbassyTab.value = value;
      }
      
      public function getEmbassyTab() : int
      {
         return this.mEmbassyTab.value;
      }
      
      public function setPriceBadges(value:int) : void
      {
         this.mPriceBadges.value = value;
      }
      
      public function getPriceBadges() : int
      {
         return this.mPriceBadges.value;
      }
   }
}
