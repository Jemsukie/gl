package com.dchoc.game.model.shop
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsDef;
   import flash.utils.Dictionary;
   
   public class ShopProgress
   {
      
      public static const UMBRELLA_SKU:String = "umbrella";
      
      public static const SHIELD_SKU:String = "shield";
      
      public static const ONLINE_PROTECTION_SKU:String = "onlineProtection";
       
      
      private var mShopProgressDef:ShopProgressDef;
      
      private var mNeedsToBeCalculated:Boolean;
      
      private var mNeedsToBlink:Boolean;
      
      private var mId:String;
      
      private var mUserSawNotification:Boolean;
      
      public function ShopProgress()
      {
         super();
      }
      
      private static function getItemDef(itemDef:ItemsDef) : ItemsDef
      {
         if(itemDef.isUseActionTypeItem())
         {
            itemDef = InstanceMng.getItemsDefMng().getDefBySku(itemDef.getActualItemSku()) as ItemsDef;
         }
         return itemDef;
      }
      
      public static function getShopProgressIdByItemDef(itemDef:ItemsDef) : String
      {
         itemDef = getItemDef(itemDef);
         var returnValue:String = null;
         var sku:String = getShopProgressSkuByItemDef(itemDef);
         if(sku != null)
         {
            returnValue = itemDef.getActionSku();
         }
         return returnValue;
      }
      
      public static function getShopProgressSkuByItemDef(itemDef:ItemsDef) : String
      {
         return itemDef.getShopProgressSku();
      }
      
      public static function getShopProgressByItemDef(itemDef:ItemsDef) : ShopProgress
      {
         var shopProgressDef:ShopProgressDef = null;
         itemDef = getItemDef(itemDef);
         var returnValue:ShopProgress = null;
         var sku:String = getShopProgressSkuByItemDef(itemDef);
         if(sku != null)
         {
            shopProgressDef = InstanceMng.getShopProgressDefMng().getDefBySku(sku) as ShopProgressDef;
            if(ShopProgressDef != null)
            {
               returnValue = new ShopProgress();
               returnValue.setup(getShopProgressIdByItemDef(itemDef),shopProgressDef);
            }
         }
         return returnValue;
      }
      
      public function destroy() : void
      {
         this.mShopProgressDef = null;
      }
      
      public function setup(id:String, shopProgressDef:ShopProgressDef) : void
      {
         this.mId = id;
         this.mShopProgressDef = shopProgressDef;
         this.mNeedsToBeCalculated = true;
         this.mNeedsToBlink = false;
         this.mUserSawNotification = false;
      }
      
      public function getCurrentAmount() : Number
      {
         var itemObject:ItemObject = null;
         var returnValue:Number = 0;
         if(this.mShopProgressDef.getType() == "countDown")
         {
            returnValue = InstanceMng.getApplication().timeLeftGet(this.mId);
         }
         else
         {
            var _loc3_:* = this.mShopProgressDef.getSku();
            if("umbrella" === _loc3_)
            {
               if(Config.useUmbrella())
               {
                  returnValue = InstanceMng.getUmbrellaMng().getUmbrellasAmount();
                  itemObject = InstanceMng.getItemsMng().getItemObjectBySku("40000");
                  if(itemObject != null)
                  {
                     returnValue += itemObject.quantity;
                  }
               }
            }
         }
         return returnValue;
      }
      
      protected function calculateIfNeedsToBlink(forceSend:Boolean) : void
      {
         var needsToBlink:Boolean = false;
         var params:Dictionary = null;
         if((this.mNeedsToBeCalculated || forceSend) && this.mShopProgressDef != null)
         {
            needsToBlink = this.mShopProgressDef.needsToBlink(this.getCurrentAmount());
            if(needsToBlink && this.mShopProgressDef.mSku == "onlineProtection")
            {
               if(InstanceMng.getApplication().timeLeftGet("shield") > 0)
               {
                  needsToBlink = false;
               }
            }
            this.mNeedsToBeCalculated = false;
            if(this.mNeedsToBlink != needsToBlink || forceSend)
            {
               params = new Dictionary();
               params["sku"] = this.getSku();
               params["value"] = needsToBlink;
               MessageCenter.getInstance().sendMessage("shopProgressBlink",params);
               this.mNeedsToBlink = needsToBlink;
            }
         }
      }
      
      public function setUserSawNotification(value:Boolean) : void
      {
         this.mUserSawNotification = value;
         this.calculateIfNeedsToBlink(true);
      }
      
      public function getType() : String
      {
         return this.mShopProgressDef.getType();
      }
      
      public function getSku() : String
      {
         return this.mShopProgressDef.mSku;
      }
      
      public function getAssetId() : String
      {
         return this.mShopProgressDef.getAssetId();
      }
      
      public function needsToBlink() : Boolean
      {
         if(this.mNeedsToBeCalculated)
         {
            this.calculateIfNeedsToBlink(false);
         }
         return this.mNeedsToBlink;
      }
      
      public function queryBlinkEvent() : void
      {
         this.calculateIfNeedsToBlink(true);
      }
      
      public function needsToBeShownOnTooltip() : Boolean
      {
         var returnValue:* = false;
         switch(this.mShopProgressDef.getShowOnTooltip())
         {
            case "whenRunning":
               returnValue = this.getCurrentAmount() > 0;
               break;
            case "whenBlinking":
               returnValue = this.needsToBlink();
               break;
            case "always":
               returnValue = true;
         }
         return returnValue;
      }
      
      public function logicUpdate() : void
      {
         this.mNeedsToBeCalculated = true;
      }
   }
}
