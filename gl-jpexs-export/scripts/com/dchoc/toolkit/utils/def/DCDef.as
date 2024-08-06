package com.dchoc.toolkit.utils.def
{
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class DCDef
   {
      
      public static const GROUP_KEY_DEFAULT:String = "default";
      
      public static const GROUP_KEY_NEW:String = "new";
      
      private static var smPaidCurrencyIdByKey:Dictionary;
      
      private static var smPaidCurrencyDefaultId:int;
       
      
      private var mSecureSku:SecureString;
      
      private var mSecureAssetId:SecureString;
      
      public var mTypeId:int;
      
      protected var mResourceName:String;
      
      private var mLevel:SecureInt;
      
      private var mFeedImg:SecureString;
      
      private var mGroups:Array;
      
      private var mGroupsDictionary:Dictionary;
      
      private var mDebug:SecureBoolean;
      
      protected var mAssetFile:String;
      
      private var mInstantBuildFactor:SecureInt;
      
      private var mInfo:SecureString;
      
      private var mEnvironment:SecureString;
      
      public var mTidDictionary:Dictionary;
      
      private var mSig:SecureString;
      
      private var mValidDateStartStr:SecureString;
      
      private var mValidDateEndStr:SecureString;
      
      private var mValidDateDurationStr:SecureString;
      
      private var mValidDateStartMillis:SecureNumber;
      
      private var mValidDateEndMillis:SecureNumber;
      
      private var mValidDateNeedsToCheckWhenCreating:SecureBoolean;
      
      private var mPaidCurrencyValues:Dictionary;
      
      public function DCDef()
      {
         mSecureSku = new SecureString("DCDef.mSecureSku");
         mSecureAssetId = new SecureString("DCDef.mSecureAssetId");
         mLevel = new SecureInt("DCDef.mLevel");
         mFeedImg = new SecureString("DCDef.mFeedImg");
         mDebug = new SecureBoolean("DCDef.mDebug");
         mInstantBuildFactor = new SecureInt("DCDef.mInstantBuildFactor");
         mInfo = new SecureString("DCDef.mInfo");
         mEnvironment = new SecureString("DCDef.mEnvironment");
         mSig = new SecureString("DCDef.mSig");
         mValidDateStartStr = new SecureString("DCDef.mValidDateStartStr");
         mValidDateEndStr = new SecureString("DCDef.mValidDateEndStr");
         mValidDateDurationStr = new SecureString("DCDef.mValidDateDurationStr");
         mValidDateStartMillis = new SecureNumber("DCDef.mValidDateStartMillis");
         mValidDateEndMillis = new SecureNumber("DCDef.mValidDateEndMillis");
         mValidDateNeedsToCheckWhenCreating = new SecureBoolean("DCDef.mValidDateNeedsToCheckWhenCreating");
         super();
         this.reset();
      }
      
      private static function paidCurrencyLoad() : void
      {
         var keyCurrency:String = null;
         smPaidCurrencyIdByKey = new Dictionary(true);
         var count:int = 0;
         for each(keyCurrency in Config.PAID_CURRENCY_KEYS)
         {
            smPaidCurrencyIdByKey[keyCurrency] = count;
            count++;
         }
         smPaidCurrencyDefaultId = smPaidCurrencyIdByKey["pc"];
      }
      
      public function reset() : void
      {
         this.mTypeId = -1;
         this.mSecureSku.value = "";
         this.mSecureAssetId.value = "";
         this.mResourceName = "";
         this.mLevel.value = 0;
         this.mFeedImg.value = "";
         this.mGroups = null;
         this.mGroupsDictionary = null;
         this.mDebug.value = false;
         this.mAssetFile = null;
         this.mInstantBuildFactor.value = 0;
         this.mInfo.value = "";
         this.mEnvironment.value = "";
         this.mTidDictionary = null;
         this.mSig.value = "";
         this.doReset();
      }
      
      protected function doReset() : void
      {
      }
      
      public function getOrder() : int
      {
         return this.getLevel();
      }
      
      public function getAssetFile() : String
      {
         return this.mAssetFile;
      }
      
      public function setAssetFile(value:String) : void
      {
         this.mAssetFile = value;
      }
      
      public function getAssetId() : String
      {
         return this.mSecureAssetId.value;
      }
      
      public function setAssetId(value:String) : void
      {
         this.mSecureAssetId.value = value;
      }
      
      public function getGroups() : Array
      {
         return this.mGroups;
      }
      
      private function setGroups(value:Array) : void
      {
         this.mGroups = value;
         this.setGroupsToDictionary(value);
      }
      
      public function addGroup(value:String) : void
      {
         if(this.mGroups == null)
         {
            this.mGroups = [];
         }
         if(this.mGroups.indexOf(value) == -1)
         {
            this.mGroups.push(value);
         }
         this.addGroupToDictionary(value);
      }
      
      private function setGroupsToDictionary(value:Array) : void
      {
         this.mGroupsDictionary = null;
         this.addGroupsToDictionary(value);
      }
      
      protected function addGroupToDictionary(group:String) : void
      {
         if(this.mGroupsDictionary == null)
         {
            this.mGroupsDictionary = new Dictionary();
         }
         this.mGroupsDictionary[group] = true;
      }
      
      protected function addGroupsToDictionary(groups:Array) : void
      {
         var group:String = null;
         for each(group in groups)
         {
            this.addGroupToDictionary(EUtils.trim(group));
         }
      }
      
      public function getGroupsCount() : int
      {
         return this.mGroups.length;
      }
      
      public function belongsToGroup(key:String) : Boolean
      {
         return this.mGroupsDictionary != null && this.mGroupsDictionary[key] == true;
      }
      
      public function isNew() : Boolean
      {
         return this.belongsToGroup("new");
      }
      
      public function getNameToDisplay() : String
      {
         return this.getTranslationFromDictionary("NAME");
      }
      
      public function getNameTID() : String
      {
         var returnValue:String = null;
         if(this.mTidDictionary != null)
         {
            return this.mTidDictionary["NAME"];
         }
         return returnValue;
      }
      
      public function getDescTID() : String
      {
         var returnValue:String = null;
         if(this.mTidDictionary != null)
         {
            return this.mTidDictionary["DESC"];
         }
         return returnValue;
      }
      
      public function getDescToDisplay() : String
      {
         return this.getTranslationFromDictionary("DESC");
      }
      
      public function getInfoToDisplay() : String
      {
         return this.getTranslationFromDictionary("INFO");
      }
      
      public function getTooltipTitleToDisplay() : String
      {
         return this.getTranslationFromDictionary("TOOLTIP_TITLE");
      }
      
      public function getTooltipDescToDisplay() : String
      {
         return this.getTranslationFromDictionary("TOOLTIP_DESC");
      }
      
      public function getSku() : String
      {
         return this.mSku;
      }
      
      public function setSku(value:String) : void
      {
         this.mSku = value;
      }
      
      public function getSkuToLoad() : String
      {
         return this.mSku;
      }
      
      public function getLevel() : int
      {
         return this.mLevel.value;
      }
      
      public function setLevel(value:int) : void
      {
         this.mLevel.value = value;
      }
      
      public function getFeedImg() : String
      {
         return this.mFeedImg.value;
      }
      
      public function setFeedImg(value:String) : void
      {
         this.mFeedImg.value = value;
      }
      
      public function needsToLoadResources() : Boolean
      {
         return true;
      }
      
      public function getTypeId() : int
      {
         return this.mTypeId;
      }
      
      public function setTypeId(typeId:int) : void
      {
         this.mTypeId = typeId;
      }
      
      public function isTypeId(typeId:int) : Boolean
      {
         return this.mTypeId == typeId;
      }
      
      public function getResourceName() : String
      {
         return this.mResourceName;
      }
      
      public function isAvailable(currentTime:Number) : Boolean
      {
         var returnValue:* = this.mEnvironment.value == "";
         if(returnValue)
         {
            returnValue = !this.validDateNeedsToCheckWhenCreating() || this.validDateIsValid(currentTime);
         }
         return returnValue;
      }
      
      private function setEnvironment(value:String) : void
      {
         this.mEnvironment.value = value;
      }
      
      public function set mSku(value:String) : void
      {
         this.mSecureSku.value = value;
      }
      
      public function get mSku() : String
      {
         return this.mSecureSku.value;
      }
      
      protected function getValueInInterval(attribute:String, index:int) : String
      {
         var str:String = null;
         var indexStr:String = null;
         var minIndex:int = 0;
         var maxIndex:int = 0;
         var min:String = null;
         var max:String = null;
         var arr:Array = attribute.split(",");
         for each(str in arr)
         {
            indexStr = String(str.split(":")[0]);
            minIndex = 0;
            maxIndex = 2147483647;
            min = String(indexStr.split("-")[0]);
            max = String(indexStr.split("-")[1]);
            if(min != "" && min != "X" && min != "x")
            {
               minIndex = int(min);
            }
            if(max != "" && max != "X" && max != "x")
            {
               maxIndex = int(max);
            }
            if(minIndex <= index && index <= maxIndex)
            {
               return str.split(":")[1];
            }
         }
         DCDebug.traceCh("ASSERT",attribute + " for HQLevel: " + index + " not found");
         return null;
      }
      
      protected function getValueInIntervalAsInt(attribute:String, index:int) : int
      {
         var valueAsString:String = this.getValueInInterval(attribute,index);
         if(valueAsString == null)
         {
            return -1;
         }
         return parseInt(valueAsString);
      }
      
      public function build() : void
      {
      }
      
      public function requestResources(resourceMng:DCResourceMng, directoryPath:String) : void
      {
         var sku:String = null;
         if(this.needsToLoadResources())
         {
            sku = this.getSkuToLoad();
            resourceMng.catalogAddResource(directoryPath + sku + ".swf",sku,"swf");
         }
      }
      
      public function fromXml(info:XML, key:String = "default") : Boolean
      {
         var returnValue:* = true;
         var attribute:String = "debug";
         if(!Config.DEBUG_MODE && EUtils.xmlIsAttribute(info,attribute))
         {
            returnValue = !EUtils.xmlReadBoolean(info,attribute);
         }
         if(returnValue)
         {
            attribute = "sku";
            if(EUtils.xmlIsAttribute(info,attribute))
            {
               this.setSku(EUtils.xmlReadString(info,attribute));
            }
            attribute = "assetFile";
            if(EUtils.xmlIsAttribute(info,attribute))
            {
               this.setAssetFile(EUtils.xmlReadString(info,attribute));
            }
            attribute = "assetId";
            if(EUtils.xmlIsAttribute(info,attribute))
            {
               this.setAssetId(EUtils.xmlReadString(info,attribute));
            }
            attribute = "level";
            if(EUtils.xmlIsAttribute(info,attribute))
            {
               this.setLevel(EUtils.xmlReadInt(info,attribute));
            }
            attribute = "feedImg";
            if(EUtils.xmlIsAttribute(info,attribute))
            {
               this.setFeedImg(EUtils.xmlReadString(info,attribute));
            }
            attribute = "groups";
            if(EUtils.xmlIsAttribute(info,attribute))
            {
               this.setGroups(EUtils.xmlReadString(info,attribute).split(","));
            }
            attribute = "resourceName";
            if(EUtils.xmlIsAttribute(info,attribute))
            {
               this.mResourceName = EUtils.xmlReadString(info,attribute);
            }
            attribute = "tidName";
            if(EUtils.xmlIsAttribute(info,attribute))
            {
               this.addToDictionary("NAME",EUtils.xmlReadString(info,attribute));
            }
            attribute = "tidDesc";
            if(EUtils.xmlIsAttribute(info,attribute))
            {
               this.addToDictionary("DESC",EUtils.xmlReadString(info,attribute));
            }
            attribute = "instantBuildFactor";
            if(EUtils.xmlIsAttribute(info,attribute))
            {
               this.mInstantBuildFactor.value = EUtils.xmlReadInt(info,attribute);
            }
            attribute = "tidInfo";
            if(EUtils.xmlIsAttribute(info,attribute))
            {
               this.addToDictionary("INFO",EUtils.xmlReadString(info,attribute));
            }
            attribute = "env";
            if(EUtils.xmlIsAttribute(info,attribute))
            {
               this.setEnvironment(EUtils.xmlReadString(info,attribute));
            }
            this.validDateFromXml(info);
            this.addGroup(key);
            this.doFromXml(info);
         }
         return returnValue;
      }
      
      private function validDateFromXml(info:XML) : void
      {
         var attribute:String = "startDate";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.validDateSetStartStr(EUtils.xmlReadString(info,attribute));
         }
         attribute = "expireDate";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.validDateSetEndStr(EUtils.xmlReadString(info,attribute));
         }
         attribute = "runningDuration";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.validDateSetDurationStr(EUtils.xmlReadString(info,attribute));
         }
         attribute = "validDateCheckWhenCreating";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mValidDateNeedsToCheckWhenCreating.value = EUtils.xmlReadBoolean(info,attribute);
         }
         if(this.mValidDateStartStr.value != null)
         {
            this.validDateSetStartMillisFromStr(this.mValidDateStartStr.value);
         }
         if(this.mValidDateEndStr.value != null)
         {
            this.validDateSetEndMillisFromStr(this.mValidDateEndStr.value);
         }
         else if(this.mValidDateDurationStr.value != null && this.mValidDateStartStr.value != null)
         {
            this.validDateSetDurationMillisFromStr(this.mValidDateDurationStr.value);
         }
         else
         {
            this.mValidDateEndMillis.value = 0;
         }
      }
      
      protected function validDateSetStartStr(value:String) : void
      {
         this.mValidDateStartStr.value = value;
      }
      
      private function validDateSetStartMillisFromStr(value:String) : void
      {
         this.mValidDateStartMillis.value = Date.parse(value + " UTC");
      }
      
      public function validDateGetStartMillis() : Number
      {
         return this.mValidDateStartMillis.value;
      }
      
      private function validDateSetEndStr(value:String) : void
      {
         this.mValidDateEndStr.value = value;
      }
      
      private function validDateSetEndMillisFromStr(value:String) : void
      {
         this.mValidDateEndMillis.value = Date.parse(value + " UTC");
      }
      
      public function validDateGetEndMillis() : Number
      {
         return this.mValidDateEndMillis.value;
      }
      
      public function validDataGetDurationMillis() : Number
      {
         return DCTimerUtil.daysToMs(Number(this.mValidDateDurationStr.value));
      }
      
      protected function validDateGetDurationStr() : String
      {
         return this.mValidDateDurationStr.value;
      }
      
      protected function validDateSetDurationStr(value:String) : void
      {
         this.mValidDateDurationStr.value = value;
      }
      
      private function validDateSetDurationMillisFromStr(value:String) : void
      {
         var durationMillis:Number = DCTimerUtil.daysToMs(Number(value));
         this.mValidDateEndMillis.value = this.mValidDateStartMillis.value + durationMillis;
      }
      
      public function validDateNeedsToCheckWhenCreating() : Boolean
      {
         return this.mValidDateNeedsToCheckWhenCreating.value;
      }
      
      public function validDateIsValid(currentTime:Number) : Boolean
      {
         var returnValue:* = currentTime >= this.mValidDateStartMillis.value;
         if(returnValue && this.mValidDateEndMillis.value > 0)
         {
            returnValue = currentTime < this.mValidDateEndMillis.value;
         }
         return returnValue;
      }
      
      public function validDateHasAnyDate() : Boolean
      {
         return this.mValidDateStartMillis.value > 0 || this.mValidDateEndMillis.value > 0;
      }
      
      public function validDateHasExpired(currentTime:Number) : Boolean
      {
         return this.mValidDateEndMillis.value > 0 && currentTime >= this.mValidDateEndMillis.value;
      }
      
      public function addToDictionary(key:String, value:String) : void
      {
         if(this.mTidDictionary == null)
         {
            this.mTidDictionary = new Dictionary();
         }
         this.mTidDictionary[key] = value;
      }
      
      public function getTranslationFromDictionary(_key:String) : String
      {
         var errorPrefix:String = this.mSku.toLocaleUpperCase();
         if(!this.mTidDictionary)
         {
            return errorPrefix + "_DICTIONARY_NOT_INITIALIZED";
         }
         var tid:String;
         if(!(tid = String(this.mTidDictionary[_key])))
         {
            return errorPrefix + "_" + _key + "_KEY_NOT_FOUND";
         }
         return DCTextMng.getText(TextIDs[tid]);
      }
      
      protected function doFromXml(info:XML) : void
      {
      }
      
      protected function paidCurrencyRead(key:String, info:XML) : void
      {
         var keyCurrency:String = null;
         var attributes:XMLList = null;
         var value:String = null;
         if(this.mPaidCurrencyValues == null)
         {
            this.mPaidCurrencyValues = new Dictionary(true);
            if(smPaidCurrencyIdByKey == null)
            {
               paidCurrencyLoad();
            }
         }
         var count:int = 0;
         if(this.mPaidCurrencyValues[key] == null)
         {
            this.mPaidCurrencyValues[key] = new Array(Config.PAID_CURRENCY_COUNT);
            for each(keyCurrency in Config.PAID_CURRENCY_KEYS)
            {
               if((attributes = info.attribute(key + "_" + keyCurrency)).length() > 0)
               {
                  value = attributes[0];
                  this.mPaidCurrencyValues[key][count] = Number(value);
               }
               else
               {
                  this.mPaidCurrencyValues[key][count] = -1;
               }
               count++;
            }
            if(this.mPaidCurrencyValues[key][smPaidCurrencyDefaultId] == -1)
            {
               this.mPaidCurrencyValues[key][smPaidCurrencyDefaultId] = 0;
            }
         }
         else
         {
            for each(keyCurrency in Config.PAID_CURRENCY_KEYS)
            {
               if((attributes = info.attribute(key + "_" + keyCurrency)).length() > 0)
               {
                  this.mPaidCurrencyValues[key][count] = parseFloat(attributes[0]);
               }
               count++;
            }
         }
      }
      
      public function paidCurrencyGet(key:String, currencyKey:String) : Number
      {
         var returnValue:int = 0;
         if(this.mPaidCurrencyValues[key] != null)
         {
            if(smPaidCurrencyIdByKey[currencyKey] != null)
            {
               returnValue = int(this.mPaidCurrencyValues[key][smPaidCurrencyIdByKey[currencyKey]]);
            }
         }
         return returnValue;
      }
      
      public function getSig(calculate:Boolean) : String
      {
         return calculate ? this.getSigDo() : this.mSig.value;
      }
      
      protected function getSigDo() : String
      {
         return "";
      }
      
      public function setSig(value:String) : void
      {
         this.mSig.value = value;
      }
   }
}
