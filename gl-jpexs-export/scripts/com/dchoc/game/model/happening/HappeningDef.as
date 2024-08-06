package com.dchoc.game.model.happening
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class HappeningDef extends DCDef
   {
       
      
      private var mCountdownDuration:SecureNumber;
      
      private var mCountdownStartDateMillis:SecureNumber;
      
      private var mExtraDurationToSell:SecureNumber;
      
      private var mOverDateMillis:SecureNumber;
      
      private var mType:SecureString;
      
      private var mTypeSku:SecureString;
      
      private var mArrTidsCountdownInfoTitle:Array;
      
      private var mArrTidsCountdownInfoBody:Array;
      
      private var mTidCountdownInfoButton:String;
      
      private var mArrIllustrationsCountdownInfo:Array;
      
      private var mArrTidsStoryTitle:Array;
      
      private var mArrTidsStoryBody:Array;
      
      private var mArrIllustrationsStory:Array;
      
      private var mTidSkipTitle:String;
      
      private var mTidSkipBody:String;
      
      private var mTidSkipQuestion:String;
      
      private var mTidFinishTitle:String;
      
      private var mTidFinishBody:String;
      
      private var mTidFinishQuestion:String;
      
      private var mPrimaryItemSku:String;
      
      private var mGiftItemsSku:Array;
      
      private var mGiftItemsPrice:Array;
      
      private var mGiftItemsPriceTids:Array;
      
      private var mShopItemsSku:Array;
      
      private var mPopupAssets:String;
      
      private var mContainerAssets:String;
      
      private var mRewardIconImage:String;
      
      private var mRewardIconName:String;
      
      private var mRewardIconDesc:String;
      
      private var mRewardIconInfo:String;
      
      private var mReward:SecureString;
      
      private var mRewardCost:SecureString;
      
      private var mRewardImage:String;
      
      private var mInitialKit:Array;
      
      private var mInitialKitEntry:SecureString;
      
      private var mInitialKitTidTitle:String;
      
      private var mInitialKitTidBody:String;
      
      private var mShopTidTitle:String;
      
      private var mAdvisorId:String;
      
      private var mBannerId:String;
      
      private var mGiftBarId:String;
      
      private var mGiftFrameId:String;
      
      private var mGiftAssetId:String;
      
      private var mShopTidBody:String;
      
      private var mShopTidCountDown:String;
      
      private var mShopTidButton:String;
      
      private var mShopTidButton2:String;
      
      private var mShopTidBody2:String;
      
      private var mTidBuyRewardAfterCompletedTitle:String;
      
      private var mTidIconAfterCompleted:String;
      
      private var mTidFinishIncompleteTitle:String;
      
      private var mTidFinishIncompleteBody:String;
      
      private var mSounds:Dictionary;
      
      private var mPopupSkin:String;
      
      private var mColorDecoration:String;
      
      private var mColorSecondary:String;
      
      private var mColorSpeechBubble:String;
      
      private var mColorStroke:String;
      
      private var mColorBkgBar:String;
      
      private var mUrlTrailer:String;
      
      private var mNpcEnemySku:String;
      
      private var mHudIcon:String;
      
      private var mTidHappeningName:String;
      
      public function HappeningDef()
      {
         mCountdownDuration = new SecureNumber("HappeningDef.mCountdownDuration");
         mCountdownStartDateMillis = new SecureNumber("HappeningDef.mCountdownStartDateMillis");
         mExtraDurationToSell = new SecureNumber("HappeningDef.mExtraDurationToSell");
         mOverDateMillis = new SecureNumber("HappeningDef.mOverDateMillis");
         mType = new SecureString("HappeningDef.mType");
         mTypeSku = new SecureString("HappeningDef.mTypeSku");
         mReward = new SecureString("HappeningDef.mReward");
         mRewardCost = new SecureString("HappeningDef.mRewardCost");
         mInitialKitEntry = new SecureString("HappeningDef.mInitialKitEntry");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "countdownDuration";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCountdownDuration(DCTimerUtil.daysToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "extraDurationToSell";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setExtraDurationToSell(DCTimerUtil.daysToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "overDate";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setOverDate(EUtils.xmlReadString(info,attribute));
         }
         attribute = "type";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setType(EUtils.xmlReadString(info,attribute));
         }
         attribute = "typeSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTypeSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidsCountdownInfoTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setArrayTidsCountdownInfoTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidsCountdownInfoBody";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setArrayTidsCountdownInfoBody(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidCountdownInfoButton";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidCountdownInfoButton(EUtils.xmlReadString(info,attribute));
         }
         attribute = "illustrationsCountdownInfo";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setArrayIllustrationsCountdownInfo(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidsStoryTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setArrayTidsStoryTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidsStoryBody";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setArrayTidsStoryBody(EUtils.xmlReadString(info,attribute));
         }
         attribute = "illustrationsStory";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setArrayIllustrationsStory(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidSkipTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidSkipTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidSkipBody";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidSkipBody(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidFinishTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidFinishTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidFinishBody";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidFinishBody(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidFinishQuestion";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidFinishQuestion(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidEventName";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidHappeningName(EUtils.xmlReadString(info,attribute));
         }
         attribute = "primaryItemSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPrimaryItemSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "giftItemSkus";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setGiftItemsSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "giftItemPrices";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setGiftItemsPrice(EUtils.xmlReadString(info,attribute));
         }
         attribute = "giftItemPricesTids";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setGiftItemsPriceTids(EUtils.xmlReadString(info,attribute));
         }
         attribute = "shopItemSkus";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShopItemsSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "popupAssets";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPopupAssets(EUtils.xmlReadString(info,attribute));
         }
         attribute = "containerAssets";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setContainerAssets(EUtils.xmlReadString(info,attribute));
         }
         attribute = "rewardIconImage";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRewardIconImage(EUtils.xmlReadString(info,attribute));
         }
         attribute = "rewardTidName";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRewardIconName(EUtils.xmlReadString(info,attribute));
         }
         attribute = "rewardTidDesc";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRewardIconDesc(EUtils.xmlReadString(info,attribute));
         }
         attribute = "rewardTidInfo";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRewardIconInfo(EUtils.xmlReadString(info,attribute));
         }
         attribute = "reward";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setReward(EUtils.xmlReadString(info,attribute));
         }
         attribute = "rewardCost";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRewardCost(EUtils.xmlReadString(info,attribute));
         }
         attribute = "rewardImage";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRewardImage(EUtils.xmlReadString(info,attribute));
         }
         attribute = "initialkitItemSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setInitialKitItems(EUtils.xmlReadString(info,attribute));
         }
         attribute = "sounds";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSounds(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidShopTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShopTidTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "advisorId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAdvisorId(EUtils.xmlReadString(info,attribute));
         }
         attribute = "bannerId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBannerId(EUtils.xmlReadString(info,attribute));
         }
         attribute = "giftBarId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setGiftBarId(EUtils.xmlReadString(info,attribute));
         }
         attribute = "giftFrameId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setGiftFrameId(EUtils.xmlReadString(info,attribute));
         }
         attribute = "giftAssetId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setGiftAssetId(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidShopBody";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShopTidBody(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidShopBody2";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShopTidBody2(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidShopCountdown";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShopTidCountdown(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidShopButton";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShopTidButton(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidShopButton2";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShopTidButton2(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidInitialkitTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setInitialKitTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidInitialkitBody";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setInitialKitBody(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidFinishIncompleteTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidFinishIncompleteTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidFinishIncompleteBody";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidFinishIncompleteBody(EUtils.xmlReadString(info,attribute));
         }
         attribute = "popupSkin";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPopupSkin(EUtils.xmlReadString(info,attribute));
         }
         attribute = "buyRewardAfterCompletedTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidBuyRewardAfterCompletedTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidIconAfterCompleted";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidIconAfterCompleted(EUtils.xmlReadString(info,attribute));
         }
         attribute = "colorDecoration";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setColorDecoration(EUtils.xmlReadString(info,attribute));
         }
         attribute = "colorSecondary";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setColorSecondary(EUtils.xmlReadString(info,attribute));
         }
         attribute = "colorSpeechBubble";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setColorSpeechBubble(EUtils.xmlReadString(info,attribute));
         }
         attribute = "colorStroke";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setColorStroke(EUtils.xmlReadString(info,attribute));
         }
         attribute = "colorBkgBar";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setColorBkgBar(EUtils.xmlReadString(info,attribute));
         }
         attribute = "urlTrailer";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUrlTrailer(EUtils.xmlReadString(info,attribute));
         }
         attribute = "npcEnemySku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setNpcEnemySku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "hudIcon";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setHudIcon(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function addSound(key:String, params:Array) : void
      {
         if(this.mSounds == null)
         {
            this.mSounds = new Dictionary();
         }
         this.mSounds[key] = params;
      }
      
      private function setSounds(value:String) : void
      {
         var token:String = null;
         var params:Array = null;
         var tokens:Array = value.split(",");
         for each(token in tokens)
         {
            params = token.split(":");
            if(params.length < 3)
            {
               DCDebug.traceCh("ASSERT","params not found for sound <" + token + "> in happeningDefinitions.xml");
            }
            else
            {
               this.addSound(params[0],params);
            }
         }
      }
      
      public function getSounds() : Dictionary
      {
         return this.mSounds;
      }
      
      public function getSoundKey(key:String) : String
      {
         var params:Array = null;
         var returnValue:String = null;
         if(this.mSounds != null)
         {
            params = this.mSounds[key];
            if(params != null)
            {
               returnValue = String(params[1]);
            }
         }
         return returnValue;
      }
      
      private function setCountdownDuration(value:Number) : void
      {
         this.mCountdownDuration.value = value;
         this.mCountdownStartDateMillis.value = validDateGetStartMillis() - this.mCountdownDuration.value;
      }
      
      public function getCountdownStartDateMillis() : Number
      {
         return this.mCountdownStartDateMillis.value;
      }
      
      private function setExtraDurationToSell(value:Number) : void
      {
         this.mExtraDurationToSell.value = value;
      }
      
      public function getExtraDurationToSell() : Number
      {
         return this.mExtraDurationToSell.value;
      }
      
      private function setOverDate(value:String) : void
      {
         this.mOverDateMillis.value = Date.parse(value + " UTC");
         DCDebug.traceCh("HAPP","[" + mSku + "] overDate millis = " + this.mOverDateMillis.value);
      }
      
      public function getOverDateMillis() : Number
      {
         return this.mOverDateMillis.value;
      }
      
      public function checkIsOver(currentMS:Number) : Boolean
      {
         return currentMS >= this.mOverDateMillis.value;
      }
      
      public function getType() : String
      {
         return this.mType.value;
      }
      
      private function setType(value:String) : void
      {
         this.mType.value = value;
      }
      
      public function getTypeSku() : String
      {
         return this.mTypeSku.value;
      }
      
      private function setTypeSku(value:String) : void
      {
         this.mTypeSku.value = value;
      }
      
      public function getArrayCountdownInfoTitle() : Vector.<String>
      {
         var tid:String = null;
         var arr:Vector.<String> = new Vector.<String>(0);
         for each(tid in this.mArrTidsCountdownInfoTitle)
         {
            arr.push(DCTextMng.getText(TextIDs[tid]));
         }
         return arr;
      }
      
      private function setArrayTidsCountdownInfoTitle(value:String) : void
      {
         this.mArrTidsCountdownInfoTitle = value.split(",");
      }
      
      public function getArrayCountdownInfoBody() : Vector.<String>
      {
         var tid:String = null;
         var arr:Vector.<String> = new Vector.<String>(0);
         for each(tid in this.mArrTidsCountdownInfoBody)
         {
            arr.push(DCTextMng.getText(TextIDs[tid]));
         }
         return arr;
      }
      
      private function setArrayTidsCountdownInfoBody(value:String) : void
      {
         this.mArrTidsCountdownInfoBody = value.split(",");
      }
      
      public function getTidCountdownInfoButton() : String
      {
         return this.mTidCountdownInfoButton;
      }
      
      private function setTidCountdownInfoButton(value:String) : void
      {
         this.mTidCountdownInfoButton = value;
      }
      
      public function getArrayIllustrationsCountdownInfo() : Vector.<String>
      {
         var id:String = null;
         var arr:Vector.<String> = new Vector.<String>(0);
         for each(id in this.mArrIllustrationsCountdownInfo)
         {
            arr.push(id);
         }
         return arr;
      }
      
      private function setArrayIllustrationsCountdownInfo(value:String) : void
      {
         this.mArrIllustrationsCountdownInfo = value.split(",");
      }
      
      public function getArrayTextsStoryTitle() : Vector.<String>
      {
         var tid:String = null;
         var arr:Vector.<String> = new Vector.<String>(0);
         for each(tid in this.mArrTidsStoryTitle)
         {
            arr.push(DCTextMng.getText(TextIDs[tid]));
         }
         return arr;
      }
      
      private function setArrayTidsStoryTitle(value:String) : void
      {
         this.mArrTidsStoryTitle = value.split(",");
      }
      
      public function getArrayTextsStoryBody() : Vector.<String>
      {
         var text:String = null;
         var i:int = 0;
         var length:int = 0;
         var tid:String = null;
         var timeOver:Number = NaN;
         var timeLeft:Number = NaN;
         var daysLeft:int = 0;
         var arr:Vector.<String> = new Vector.<String>(0);
         if(this.mArrTidsStoryBody != null)
         {
            i = 0;
            length = int(this.mArrTidsStoryBody.length);
            for(i = 0; i < length; )
            {
               tid = String(this.mArrTidsStoryBody[i]);
               text = DCTextMng.getText(TextIDs[tid]);
               text = DCTextMng.checkTags(text);
               if(i == 0)
               {
                  timeLeft = (timeOver = validDateGetEndMillis()) - InstanceMng.getUserDataMng().getServerCurrentTimemillis();
                  daysLeft = 1;
                  if((daysLeft = Math.ceil(timeLeft / 86400000)) < 1)
                  {
                     daysLeft = 1;
                  }
                  text = DCTextMng.replaceParameters(text,["" + daysLeft]);
               }
               arr.push(text);
               i++;
            }
         }
         return arr;
      }
      
      private function setArrayTidsStoryBody(value:String) : void
      {
         this.mArrTidsStoryBody = value.split(",");
      }
      
      public function getArrayIllustrationsStory() : Vector.<String>
      {
         var id:String = null;
         var arr:Vector.<String> = new Vector.<String>(0);
         for each(id in this.mArrIllustrationsStory)
         {
            arr.push(id);
         }
         return arr;
      }
      
      private function setArrayIllustrationsStory(value:String) : void
      {
         this.mArrIllustrationsStory = value.split(",");
      }
      
      public function getTidSkipTitle() : String
      {
         return this.mTidSkipTitle;
      }
      
      private function setTidSkipTitle(value:String) : void
      {
         this.mTidSkipTitle = value;
      }
      
      public function getTidSkipBody() : String
      {
         return this.mTidSkipBody;
      }
      
      private function setTidSkipBody(value:String) : void
      {
         this.mTidSkipBody = value;
      }
      
      public function getTidFinishTitle() : String
      {
         return this.mTidFinishTitle;
      }
      
      private function setTidFinishTitle(value:String) : void
      {
         this.mTidFinishTitle = value;
      }
      
      public function getTidFinishBody() : String
      {
         return this.mTidFinishBody;
      }
      
      private function setTidFinishBody(value:String) : void
      {
         this.mTidFinishBody = value;
      }
      
      public function getTidFinishQuestion() : String
      {
         return this.mTidFinishQuestion;
      }
      
      private function setTidFinishQuestion(value:String) : void
      {
         this.mTidFinishQuestion = value;
      }
      
      public function getTidHappeningName() : String
      {
         return this.mTidHappeningName;
      }
      
      private function setTidHappeningName(value:String) : void
      {
         this.mTidHappeningName = value;
      }
      
      private function setPrimaryItemSku(value:String) : void
      {
         this.mPrimaryItemSku = value;
      }
      
      public function getPrimaryItemSku() : String
      {
         return this.mPrimaryItemSku;
      }
      
      private function setGiftItemsSku(value:String) : void
      {
         this.mGiftItemsSku = value.split(",");
      }
      
      public function getGiftItemsSku() : Array
      {
         return this.mGiftItemsSku;
      }
      
      public function getNumGifts() : int
      {
         return this.mGiftItemsSku.length;
      }
      
      private function setGiftItemsPrice(value:String) : void
      {
         this.mGiftItemsPrice = value.split(",");
      }
      
      public function getGiftItemsPrice() : Array
      {
         return this.mGiftItemsPrice;
      }
      
      public function getGiftItemPriceBySku(sku:String) : int
      {
         var i:int = 0;
         for(i = 0; i < this.getNumGifts(); )
         {
            if(this.mGiftItemsSku[i] == sku)
            {
               return this.mGiftItemsPrice[i];
            }
            i++;
         }
         return 0;
      }
      
      private function setGiftItemsPriceTids(value:String) : void
      {
         this.mGiftItemsPriceTids = value.split(",");
      }
      
      public function getGiftItemsPriceTids() : Array
      {
         return this.mGiftItemsPriceTids;
      }
      
      private function setShopItemsSku(value:String) : void
      {
         this.mShopItemsSku = value.split(",");
      }
      
      public function getShopItemsSku() : Array
      {
         return this.mShopItemsSku;
      }
      
      private function setPopupAssets(value:String) : void
      {
         this.mPopupAssets = value;
      }
      
      public function getPopupAssets() : String
      {
         return this.mPopupAssets;
      }
      
      public function getPopupAssetsFullPath() : String
      {
         return "assets/flash/" + this.mPopupAssets;
      }
      
      private function setContainerAssets(value:String) : void
      {
         this.mContainerAssets = value;
      }
      
      public function getContainerAssets() : String
      {
         return this.mContainerAssets;
      }
      
      public function getContainerAssetsFullPath() : String
      {
         return "assets/flash/" + this.mContainerAssets;
      }
      
      private function setRewardIconImage(value:String) : void
      {
         this.mRewardIconImage = value;
      }
      
      public function getRewardIconImage() : String
      {
         return this.mRewardIconImage;
      }
      
      private function setRewardIconName(value:String) : void
      {
         this.mRewardIconName = value;
      }
      
      public function getRewardIconName() : String
      {
         return DCTextMng.getText(TextIDs[this.mRewardIconName]);
      }
      
      private function setRewardIconDesc(value:String) : void
      {
         this.mRewardIconDesc = value;
      }
      
      public function getRewardIconDesc() : String
      {
         return DCTextMng.getText(TextIDs[this.mRewardIconDesc]);
      }
      
      private function setRewardIconInfo(value:String) : void
      {
         this.mRewardIconInfo = value;
      }
      
      public function getRewardIconInfo() : String
      {
         return DCTextMng.getText(TextIDs[this.mRewardIconInfo]);
      }
      
      private function setReward(value:String) : void
      {
         this.mReward.value = value;
      }
      
      public function getReward() : String
      {
         return this.mReward.value;
      }
      
      private function setRewardCost(value:String) : void
      {
         this.mRewardCost.value = value;
      }
      
      public function getRewardCost() : String
      {
         return this.mRewardCost.value;
      }
      
      private function setRewardImage(value:String) : void
      {
         this.mRewardImage = value;
      }
      
      public function getRewardImage() : String
      {
         return this.mRewardImage;
      }
      
      private function setInitialKitItems(value:String) : void
      {
         this.mInitialKitEntry.value = value;
         this.mInitialKit = value.split(",");
      }
      
      public function getInitialKitItems() : Array
      {
         return this.mInitialKit;
      }
      
      public function getInitialKitEntry() : String
      {
         return this.mInitialKitEntry.value;
      }
      
      private function setInitialKitTitle(value:String) : void
      {
         this.mInitialKitTidTitle = value;
      }
      
      public function getInitialKitTitle() : String
      {
         return DCTextMng.getText(TextIDs[this.mInitialKitTidTitle]);
      }
      
      private function setInitialKitBody(value:String) : void
      {
         this.mInitialKitTidBody = value;
      }
      
      public function getInitialKitBody() : String
      {
         return DCTextMng.getText(TextIDs[this.mInitialKitTidBody]);
      }
      
      private function setShopTidTitle(value:String) : void
      {
         this.mShopTidTitle = value;
      }
      
      public function getShopTextTitle() : String
      {
         return DCTextMng.getText(TextIDs[this.mShopTidTitle]);
      }
      
      private function setAdvisorId(value:String) : void
      {
         this.mAdvisorId = value;
      }
      
      public function getAdvisorId() : String
      {
         return this.mAdvisorId;
      }
      
      private function setBannerId(value:String) : void
      {
         this.mBannerId = value;
      }
      
      public function getBannerId() : String
      {
         return this.mBannerId;
      }
      
      private function setGiftBarId(value:String) : void
      {
         this.mGiftBarId = value;
      }
      
      public function getGiftBarId() : String
      {
         return this.mGiftBarId;
      }
      
      private function setGiftFrameId(value:String) : void
      {
         this.mGiftFrameId = value;
      }
      
      public function getGiftFrameId() : String
      {
         return this.mGiftFrameId;
      }
      
      private function setGiftAssetId(value:String) : void
      {
         this.mGiftAssetId = value;
      }
      
      public function getGiftAssetId() : String
      {
         return this.mGiftAssetId;
      }
      
      private function setShopTidBody(value:String) : void
      {
         this.mShopTidBody = value;
      }
      
      public function getShopTextBody() : String
      {
         return DCTextMng.getText(TextIDs[this.mShopTidBody]);
      }
      
      private function setShopTidCountdown(value:String) : void
      {
         this.mShopTidCountDown = value;
      }
      
      public function getShopCountDownText() : String
      {
         return DCTextMng.getText(TextIDs[this.mShopTidCountDown]);
      }
      
      private function setShopTidButton(value:String) : void
      {
         this.mShopTidButton = value;
      }
      
      public function getShopTextButton() : String
      {
         return DCTextMng.getText(TextIDs[this.mShopTidButton]);
      }
      
      private function setShopTidButton2(value:String) : void
      {
         this.mShopTidButton2 = value;
      }
      
      public function getShopTextButton2() : String
      {
         return DCTextMng.getText(TextIDs[this.mShopTidButton2]);
      }
      
      private function setShopTidBody2(value:String) : void
      {
         this.mShopTidBody2 = value;
      }
      
      public function getShopTidBody2Tid() : int
      {
         return TextIDs[this.mShopTidBody2];
      }
      
      private function setPopupSkin(value:String) : void
      {
         this.mPopupSkin = value;
      }
      
      public function getPopupSkin() : String
      {
         return this.mPopupSkin;
      }
      
      private function setTidBuyRewardAfterCompletedTitle(value:String) : void
      {
         this.mTidBuyRewardAfterCompletedTitle = value;
      }
      
      public function getTidBuyRewardAfterCompletedTitle() : String
      {
         return this.mTidBuyRewardAfterCompletedTitle;
      }
      
      private function setTidIconAfterCompleted(value:String) : void
      {
         this.mTidIconAfterCompleted = value;
      }
      
      public function getTidFinishIncompleteTitle() : String
      {
         return this.mTidFinishIncompleteTitle;
      }
      
      private function setTidFinishIncompleteTitle(value:String) : void
      {
         this.mTidFinishIncompleteTitle = value;
      }
      
      public function getTidFinishIncompleteBody() : String
      {
         return this.mTidFinishIncompleteBody;
      }
      
      private function setTidFinishIncompleteBody(value:String) : void
      {
         this.mTidFinishIncompleteBody = value;
      }
      
      public function getTidIconAfterCompleted() : String
      {
         return this.mTidIconAfterCompleted;
      }
      
      public function setColorDecoration(value:String) : void
      {
         this.mColorDecoration = value;
      }
      
      public function getColorDecoration() : String
      {
         return this.mColorDecoration;
      }
      
      public function setColorSecondary(value:String) : void
      {
         this.mColorSecondary = value;
      }
      
      public function getColorSecondary() : String
      {
         return this.mColorSecondary;
      }
      
      public function setColorSpeechBubble(value:String) : void
      {
         this.mColorSpeechBubble = value;
      }
      
      public function getColorSpeechBubble() : String
      {
         return this.mColorSpeechBubble;
      }
      
      public function setColorStroke(value:String) : void
      {
         this.mColorStroke = value;
      }
      
      public function getColorStroke() : String
      {
         return this.mColorStroke;
      }
      
      public function setColorBkgBar(value:String) : void
      {
         this.mColorBkgBar = value;
      }
      
      public function getColorBkgBar() : String
      {
         return this.mColorBkgBar;
      }
      
      public function setUrlTrailer(value:String) : void
      {
         this.mUrlTrailer = value;
      }
      
      public function getUrlTrailer() : String
      {
         return this.mUrlTrailer;
      }
      
      private function setNpcEnemySku(value:String) : void
      {
         this.mNpcEnemySku = value;
      }
      
      public function getNpcEnemySku() : String
      {
         return this.mNpcEnemySku;
      }
      
      private function setHudIcon(value:String) : void
      {
         this.mHudIcon = value;
      }
      
      public function getHudIcon() : String
      {
         return this.mHudIcon;
      }
   }
}
