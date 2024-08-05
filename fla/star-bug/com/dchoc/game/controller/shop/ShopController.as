package com.dchoc.game.controller.shop
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.TopHudFacade;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.shop.PurchaseShopDef;
   import com.dchoc.game.model.shop.ShopDef;
   import com.dchoc.game.model.shop.ShopDefMng;
   import com.dchoc.game.model.shop.ShopProgress;
   import com.dchoc.game.model.shop.ShopProgressDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.utils.def.DCDef;
   import flash.utils.Dictionary;
   
   public class ShopController extends DCComponent implements INotifyReceiver
   {
       
      
      protected var mSku:String;
      
      private var mShopDefMng:ShopDefMng;
      
      private var mHudButtonIsAdded:Boolean;
      
      private var mHud:TopHudFacade;
      
      private var mProgressIsBuilt:Boolean;
      
      private var mShopProgressItems:Dictionary;
      
      private var mShopProgressItemsView:Vector.<ShopProgress>;
      
      private var mItemsBlinkingAlreadySeen:Vector.<String>;
      
      public function ShopController(sku:String, shopDefMng:ShopDefMng)
      {
         this.mItemsBlinkingAlreadySeen = new Vector.<String>(0);
         super();
         this.mSku = sku;
         this.mShopDefMng = shopDefMng;
         this.mProgressIsBuilt = false;
      }
      
      override protected function beginDo() : void
      {
         super.beginDo();
         MessageCenter.getInstance().registerObject(this);
      }
      
      override protected function endDo() : void
      {
         super.endDo();
         MessageCenter.getInstance().unregisterObject(this);
      }
      
      override protected function unloadDo() : void
      {
         this.mShopDefMng = null;
         this.mHud = null;
         this.mShopProgressItems = null;
         this.mShopProgressItemsView = null;
      }
      
      override protected function unbuildDo() : void
      {
         var k:* = null;
         var progress:ShopProgress = null;
         this.mHudButtonIsAdded = false;
         if(this.mShopProgressItemsView != null)
         {
            this.mShopProgressItemsView.length = 0;
         }
         if(this.mShopProgressItems != null)
         {
            for(k in this.mShopProgressItems)
            {
               progress = this.mShopProgressItems[k];
               if(progress != null)
               {
                  progress.destroy();
               }
               delete this.mShopProgressItems[k];
            }
         }
      }
      
      public function getSku() : String
      {
         return this.mSku;
      }
      
      public function getPurchaseShopDef() : PurchaseShopDef
      {
         return InstanceMng.getPurchaseShopDefMng().getDefBySku(this.getSku()) as PurchaseShopDef;
      }
      
      public function getShopDefs() : Vector.<DCDef>
      {
         return this.mShopDefMng.getDefs();
      }
      
      public function clickOnHudButton() : void
      {
         InstanceMng.getApplication().shopControllerOpenPopup(this.mSku);
      }
      
      private function checkIfAddHudButton() : Boolean
      {
         var returnValue:Boolean = false;
         var roleId:int = InstanceMng.getFlowState().getCurrentRoleId();
         var profileLogin:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         return profileLogin != null && profileLogin.isBuilt() && profileLogin.isTutorialCompleted() && roleId == 0 && InstanceMng.getApplication().viewGetMode() == 0 && !InstanceMng.getUnitScene().battleIsRunning(false,true);
      }
      
      public function needsToBlink() : Boolean
      {
         var k:* = null;
         var shopProgress:ShopProgress = null;
         var returnValue:Boolean = false;
         if(this.mProgressIsBuilt)
         {
            for(k in this.mShopProgressItems)
            {
               shopProgress = this.mShopProgressItems[k];
               if(shopProgress.needsToBlink())
               {
                  returnValue = true;
               }
            }
         }
         return returnValue;
      }
      
      public function queryBlinkEvents() : void
      {
         var k:* = null;
         var shopProgress:ShopProgress = null;
         if(this.mProgressIsBuilt)
         {
            for(k in this.mShopProgressItems)
            {
               shopProgress = this.mShopProgressItems[k];
               shopProgress.queryBlinkEvent();
            }
         }
      }
      
      protected function buildProgress() : void
      {
         var shopDef:ShopDef = null;
         var itemDefs:Vector.<ItemsDef> = null;
         var itemDef:ItemsDef = null;
         var shopProgressSku:String = null;
         var shopProgress:ShopProgress = null;
         var defs:Vector.<DCDef> = this.getShopDefs();
         for each(shopDef in defs)
         {
            itemDefs = shopDef.getTabContent();
            for each(itemDef in itemDefs)
            {
               shopProgressSku = ShopProgress.getShopProgressSkuByItemDef(itemDef);
               if(shopProgressSku != null && this.getShopProgressBySku(shopProgressSku) == null)
               {
                  this.setShopProgress(shopProgressSku,ShopProgress.getShopProgressByItemDef(itemDef));
               }
            }
         }
         if(this.mSku == "premium")
         {
            shopProgressSku = "onlineProtection";
            (shopProgress = new ShopProgress()).setup(shopProgressSku,InstanceMng.getShopProgressDefMng().getDefBySku(shopProgressSku) as ShopProgressDef);
            this.setShopProgress(shopProgressSku,shopProgress);
         }
      }
      
      protected function getShopProgressBySku(sku:String) : ShopProgress
      {
         return this.mShopProgressItems != null ? this.mShopProgressItems[sku] : null;
      }
      
      protected function setShopProgress(sku:String, value:ShopProgress) : void
      {
         if(this.mShopProgressItems == null)
         {
            this.mShopProgressItems = new Dictionary(true);
         }
         this.mShopProgressItems[sku] = value;
      }
      
      public function viewGetShopProgress() : Vector.<ShopProgress>
      {
         var k:* = null;
         var shopProgress:ShopProgress = null;
         if(this.mShopProgressItemsView == null)
         {
            this.mShopProgressItemsView = new Vector.<ShopProgress>(0);
         }
         else
         {
            this.mShopProgressItemsView.length = 0;
         }
         for(k in this.mShopProgressItems)
         {
            shopProgress = this.mShopProgressItems[k];
            if(shopProgress.needsToBeShownOnTooltip())
            {
               this.mShopProgressItemsView.push(shopProgress);
            }
         }
         return this.mShopProgressItemsView;
      }
      
      public function getBlinkingShopProgressSkus() : Vector.<String>
      {
         var item:ShopProgress = null;
         var result:Vector.<String> = new Vector.<String>(0);
         for each(item in this.mShopProgressItems)
         {
            if(item.needsToBlink() && this.mItemsBlinkingAlreadySeen.lastIndexOf(item.getSku()) < 0)
            {
               result.push(item.getSku());
            }
         }
         return result;
      }
      
      public function setUserSawBlinkingShopProgress(shopProgressSku:String) : void
      {
         if(this.mItemsBlinkingAlreadySeen.lastIndexOf(shopProgressSku) < 0)
         {
            this.mItemsBlinkingAlreadySeen.push(shopProgressSku);
            if(this.mShopProgressItems[shopProgressSku])
            {
               ShopProgress(this.mShopProgressItems[shopProgressSku]).setUserSawNotification(true);
            }
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var shopProgress:ShopProgress = null;
         var k:* = null;
         if(this.mHud == null)
         {
            this.mHud = InstanceMng.getTopHudFacade();
         }
         if(!this.mProgressIsBuilt && this.mShopDefMng != null && this.mShopDefMng.isBuilt())
         {
            this.buildProgress();
            this.mProgressIsBuilt = true;
         }
         var needsToBlink:Boolean = false;
         if(this.mProgressIsBuilt)
         {
            for(k in this.mShopProgressItems)
            {
               if((shopProgress = this.mShopProgressItems[k]).needsToBlink())
               {
                  needsToBlink = true;
               }
               shopProgress.logicUpdate();
            }
         }
      }
      
      public function getName() : String
      {
         return "shopController_" + this.getSku();
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["queryShopProgressBlink"];
      }
      
      public function onMessage(cmd:String, params:Dictionary) : void
      {
         var _loc3_:* = cmd;
         if("queryShopProgressBlink" === _loc3_)
         {
            this.queryBlinkEvents();
         }
      }
   }
}
