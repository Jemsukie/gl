package com.dchoc.game.model.items
{
   import com.dchoc.game.controller.hangar.Hangar;
   import com.dchoc.game.controller.hangar.HangarController;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.inventory.EPopupInventory;
   import com.dchoc.game.model.powerups.PowerUpDef;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.unit.defs.DroidDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.display.EAbstractSprite;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class ItemsMng extends DCComponent
   {
      
      public static const LIST_MENU_INVENTORY:String = "inventory";
      
      public static const LIST_MENU_COLLECTABLE:String = "collectable";
      
      public static const LIST_MENU_CRAFTING:String = "crafting";
      
      public static const LIST_MENU_SPEEDUP:String = "speedup";
      
      public static const LIST_MENU_UPGRADE:String = "upgrade";
      
      public static const LIST_MENU_CONTEST:String = "contest";
      
      public static const LIST_MENU_INVENTORY_IDX:int = 2;
      
      public static const LIST_MENU_COLLECTABLE_IDX:int = 1;
      
      public static const LIST_MENU_CRAFTING_IDX:int = 0;
      
      public static const ACTION_COLLECTCOINS:String = "collectCoins";
      
      public static const ACTION_COLLECTMINERALS:String = "collectMinerals";
      
      public static const ACTION_HELPFRIEND:String = "help";
      
      public static const ACTION_RECYCLE:String = "recycle";
      
      public static const ACTION_DESTROY:String = "destroy";
      
      public static const ACTION_SPECIAL_ATTACK:String = "specialAttack";
      
      public static const REWARD_COINS:String = "exchangeCoins";
      
      public static const REWARD_MINERALS:String = "exchangeMinerals";
      
      public static const REWARD_XP:String = "exchangeXp";
      
      public static const USEACTION_WORLD_ITEM:String = "worldItem";
      
      public static const USEACTION_UNIT:String = "unit";
      
      public static const USEACTION_OPEN_MISTERY_GIFT:String = "misteryGift";
      
      public static const USEACTION_ADDCOINS:String = "coins";
      
      public static const USEACTION_ADDMINERALS:String = "minerals";
      
      public static const USEACTION_ADDEXPERIENCE:String = "experience";
      
      public static const USEACTION_ADDSCORE:String = "score";
      
      public static const USEACTION_ADDBADGES:String = "badges";
      
      public static const USEACTION_ADDCHIPS:String = "chips";
      
      public static const USEACTION_DROID_PART:String = "buildDroid";
      
      public static const USEACTION_WORKER:String = "worker";
      
      public static const USEACTION_POWERUP:String = "powerups";
      
      public static const USEACTION_DEPLOY_UNIT:String = "deployUnit";
      
      public static const USEACTION_ITEM:String = "item";
      
      public static const USEACTION_UMBRELLA:String = "umbrella";
      
      public static const USEACTION_COLONY_SHIELD:String = "shield";
      
      public static const USEACTION_UPGRADE_HQ:String = "upgradeHQ";
      
      public static const USEACTION_FILL_COINS_BAR:String = "fillCoinsBar";
      
      public static const USEACTION_FILL_MINERALS_BAR:String = "fillMineralsBar";
      
      public static const USEACTION_RECYCLE_OBSTACLES:String = "recycleObstacles";
      
      public static const INVENTORY_BOX_TYPE_WORLD_ITEM:String = "worldItem";
      
      public static const INVENTORY_BOX_TYPE_UNIT:String = "unit";
      
      public static const INVENTORY_BOX_TYPE_MISTERY_GIFT:String = "misteryGift";
      
      public static const INVENTORY_BOX_TYPE_DROID_PART:String = "buildDroid";
      
      public static const INVENTORY_BOX_TYPE_WORKER:String = "worker";
      
      public static const NUM_COLLECTABLES:int = 5;
      
      public static const NUM_CRAFTING:int = 4;
      
      public static const NUM_WISHLIST:int = 3;
      
      public static const ITEM_SKU_FRIENDSHIP_STONE:String = "400";
      
      public static const ITEM_SKU_SPYING_CAPSULES:String = "10000";
      
      public static const ITEM_SKU_ADVANCED_SPYING_CAPSULES:String = "10001";
      
      public static const ITEM_SKU_COINS:String = "5003";
      
      public static const ITEM_SKU_MINERALS:String = "5004";
      
      public static const ITEM_SKU_MERCENARIES:String = "7200";
      
      public static const ITEM_SKU_UMBRELLA:String = "40000";
      
      public static const ITEM_SKU_FILL_COINS_BAR:String = "5007";
      
      public static const ITEM_SKU_UPGRADE_HQ:String = "306";
      
      public static const ITEM_SKUS_CHIP_COLLECTABLES:Vector.<String> = new <String>["8000","8001"];
      
      public static const USE_ITEM_FROM_INVENTORY:String = "inventory";
      
      public static const USE_ITEM_FROM_SHOP:String = "shop";
      
      public static const USE_MULTIPLE_BOUND:int = 50;
       
      
      private var mItemsListLoaded:Boolean;
      
      private var mItemsCraftingLoaded:Boolean;
      
      private var mItemsList:Vector.<ItemObject>;
      
      private var mWishList:Vector.<ItemObject>;
      
      private var mItemsMenus:Dictionary;
      
      private var mItemsActionList:Dictionary;
      
      private var mCraftAutoBuild:Boolean = false;
      
      private var mCraftRewardsOwned:Dictionary;
      
      private var mUseItemsNow:Vector.<ItemObject>;
      
      private var mGuiPopupInventory:EPopupInventory;
      
      public function ItemsMng()
      {
         super();
      }
      
      override public function unload() : void
      {
         var menu:String = null;
         var item:ItemObject = null;
         for each(menu in this.mItemsMenus)
         {
            delete this.mItemsMenus[menu];
         }
         this.mItemsMenus = null;
         for each(menu in this.mItemsActionList)
         {
            delete this.mItemsActionList[menu];
         }
         this.mItemsActionList = null;
         for each(item in this.mItemsList)
         {
            item = null;
         }
         this.mItemsList = null;
         this.mWishList = null;
         this.mItemsListLoaded = false;
         this.mItemsCraftingLoaded = false;
         this.mCraftRewardsOwned = null;
         this.mUseItemsNow = null;
         this.guiUnload();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 2;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var item:ItemObject = null;
         var itemsList:XML = null;
         var itemsDefs:Vector.<DCDef> = null;
         var element:XML = null;
         var itemDef:DCDef = null;
         var wishListSkus:Array = null;
         var wishSku:String = null;
         var userData:UserDataMng = InstanceMng.getUserDataMng();
         if(step == 0)
         {
            if(userData.isFileLoaded(UserDataMng.KEY_ITEMS_LIST) && InstanceMng.getItemsDefMng().isBuilt() && InstanceMng.getCollectablesDefMng().isBuilt() && InstanceMng.getCraftingDefMng().isBuilt())
            {
               this.mItemsMenus = new Dictionary(true);
               this.mItemsActionList = new Dictionary(true);
               itemsList = userData.getFileXML(UserDataMng.KEY_ITEMS_LIST);
               itemsDefs = InstanceMng.getItemsDefMng().getDefs();
               this.mItemsList = new Vector.<ItemObject>(0);
               for each(itemDef in itemsDefs)
               {
                  (item = new ItemObject(itemDef as ItemsDef)).quantity = 0;
                  item.sequenceIndex = 0;
                  item.positionIndex = 0;
                  item.indexesCount = 0;
                  item.setTimeLeft(0);
                  this.addItem(item);
               }
               for each(element in EUtils.xmlGetChildrenList(itemsList,"Item"))
               {
                  if((item = this.getItemObjectBySku(EUtils.xmlReadString(element,"sku"))) != null)
                  {
                     item.quantity = EUtils.xmlReadInt(element,"quantity");
                     item.sequenceIndex = EUtils.xmlReadInt(element,"sequence");
                     item.positionIndex = EUtils.xmlReadInt(element,"position");
                     item.indexesCount = EUtils.xmlReadInt(element,"counter");
                     item.setTimeLeft(EUtils.xmlReadNumber(element,"timeLeft"));
                     if(Config.DEBUG_ITEMS)
                     {
                        DCDebug.traceCh("Items","sku=" + EUtils.xmlReadString(element,"sku") + " quantity=" + item.quantity + " seq= " + EUtils.xmlReadInt(element,"sequence") + " pos=" + item.positionIndex + " counter=" + item.indexesCount + " timeLeft=" + EUtils.xmlReadNumber(element,"timeLeft") + " asInt=" + EUtils.xmlReadInt(element,"timeLeft"));
                     }
                  }
               }
               wishListSkus = EUtils.xmlReadString(itemsList,"wishlist").split(",");
               this.mWishList = new Vector.<ItemObject>(0);
               for each(wishSku in wishListSkus)
               {
                  if((item = this.getItemObjectBySku(wishSku)) != null)
                  {
                     this.addItemToWishList(item);
                  }
               }
               this.mItemsListLoaded = true;
               buildAdvanceSyncStep();
            }
         }
         else if(step == 1)
         {
            if(this.mItemsListLoaded && !this.mItemsCraftingLoaded && InstanceMng.getRewardsDefMng().isBuilt() && InstanceMng.getSpecialAttacksDefMng().isBuilt())
            {
               this.craftingLoadRewards();
               this.mItemsCraftingLoaded = true;
               buildAdvanceSyncStep();
            }
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var item:ItemObject = null;
         if(this.mItemsList != null)
         {
            for each(item in this.mItemsList)
            {
               item.logicUpdate(dt);
            }
         }
      }
      
      public function addItem(item:ItemObject) : void
      {
         var menu:String = null;
         this.mItemsList.push(item);
         var menusList:Array = item.mDef.getMenusList();
         for each(menu in menusList)
         {
            if(this.mItemsMenus[menu] == null)
            {
               this.mItemsMenus[menu] = new Vector.<ItemObject>(0);
            }
            this.mItemsMenus[menu].push(item);
         }
         menusList = item.mDef.getItemActionList();
         for each(menu in menusList)
         {
            if(this.mItemsActionList[menu] == null)
            {
               this.mItemsActionList[menu] = new Vector.<ItemObject>(0);
            }
            this.mItemsActionList[menu].push(item);
         }
      }
      
      public function removeItem(item:ItemObject) : void
      {
         var menu:String = null;
         this.mItemsList.splice(this.mItemsList.indexOf(item),1);
         var menusList:Array = item.mDef.getMenusList();
         for each(menu in menusList)
         {
            if(this.mItemsMenus[menu] != null)
            {
               this.mItemsMenus[menu].splice(this.mItemsMenus[menu].indexOf(item,1));
               if(this.mItemsMenus[menu].length == 0)
               {
                  delete this.mItemsMenus[menu];
               }
            }
         }
         menusList = item.mDef.getItemActionList();
         for each(menu in menusList)
         {
            if(this.mItemsActionList[menu] != null)
            {
               this.mItemsActionList[menu].splice(this.mItemsActionList[menu].indexOf(item,1));
               if(this.mItemsActionList[menu].length == 0)
               {
                  delete this.mItemsActionList[menu];
               }
            }
         }
      }
      
      public function buyItem(sku:String) : void
      {
         var platformSku:String = null;
         var def:ItemsDef = InstanceMng.getItemsDefMng().getDefBySku(sku) as ItemsDef;
         if(def != null)
         {
            if(def.getCredits() > 0)
            {
               platformSku = InstanceMng.getPlatformSettingsDefMng().mPlatformSettingsDef.mSku;
               InstanceMng.getUserDataMng().purchaseItem(sku,def.getPlatformCreditsTag(platformSku));
            }
            else
            {
               this.notifyItemBought(sku);
            }
         }
      }
      
      public function notifyItemBought(sku:String, params:Object = null, hideStar:Boolean = false, onBuy:Function = null, onBuyParams:Object = null) : void
      {
         var def:ItemsDef;
         if((def = InstanceMng.getItemsDefMng().getDefBySku(sku) as ItemsDef) == null)
         {
            return;
         }
         var v:Vector.<Array>;
         (v = new Vector.<Array>(1,true))[0] = [sku,1];
         var o:Object;
         (o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_BUY_ITEMS_WITH_PREMIUM_CURRENCY")).fbPrice = 0;
         o.itemList = v;
         o.phase = "OUT";
         o.button = "EventYesButtonPressed";
         o.itemName = def.getItemName();
         o.itemSku = def.mSku;
         o.onBuy = onBuy;
         o.onBuyParams = onBuyParams;
         o.dontShowStar = hideStar;
         if(params != null)
         {
            if(params.hasOwnProperty("workerDef"))
            {
               o.workerDef = params.workerDef;
            }
         }
         o.transaction = InstanceMng.getRuleMng().getTransactionPack(o);
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
      }
      
      public function getMenuList(type:String) : Vector.<ItemObject>
      {
         return this.mItemsMenus[type];
      }
      
      public function getUnseenItemsAmount(type:String) : int
      {
         var item:ItemObject = null;
         var result:int = 0;
         var items:Vector.<ItemObject>;
         if(!(items = this.getMenuList(type)))
         {
            items = this.mItemsList;
         }
         for each(item in items)
         {
            result += item.mVisualStarIconAmount.value;
         }
         return result;
      }
      
      public function getInventoryItems() : Vector.<ItemObject>
      {
         var item:ItemObject = null;
         var items:Vector.<ItemObject> = this.getMenuList("inventory");
         var returnValue:Vector.<ItemObject> = new Vector.<ItemObject>(0);
         for each(item in items)
         {
            if(item.mDef.getShowInInventory())
            {
               if(item.quantity > 0)
               {
                  returnValue.push(item);
               }
               else if(Config.usePowerUps())
               {
                  if(item.mDef.getActionType() == "powerups" && InstanceMng.getPowerUpMng().getPowerUpTimeLeft(item.mDef.getActionParam()) > 0)
                  {
                     returnValue.push(item);
                  }
               }
            }
         }
         return returnValue;
      }
      
      public function getItemsDeployUnits() : Vector.<ItemObject>
      {
         var item:ItemObject = null;
         var items:Vector.<ItemObject> = this.getMenuList("inventory");
         var returnValue:Vector.<ItemObject> = new Vector.<ItemObject>(0);
         for each(item in items)
         {
            if(item.mDef.getActionType() == "deployUnit" && item.quantity > 0)
            {
               returnValue.push(item);
            }
         }
         return returnValue;
      }
      
      private function addItemToInventory(item:ItemObject, checkLimit:Boolean = true, showNewContent:Boolean = false) : Boolean
      {
         if(item.mDef.getMaxAmountInventory() > 0)
         {
            if(!checkLimit || checkLimit && item.mDef.getMaxAmountInventory() > item.quantity)
            {
               item.quantity++;
               if(showNewContent)
               {
                  item.mVisualStarIconAmount.value++;
               }
               return true;
            }
            return false;
         }
         item.quantity++;
         if(showNewContent)
         {
            item.mVisualStarIconAmount.value++;
         }
         return true;
      }
      
      public function removeItemFromInventory(item:ItemObject, used:Boolean, notifyServer:Boolean = true, amount:int = 1) : Boolean
      {
         var returnValue:Boolean = item != null && item.quantity > 0;
         amount = Math.abs(amount);
         if(returnValue)
         {
            item.quantity -= amount;
            if(item.mVisualStarIconAmount.value > item.quantity)
            {
               item.mVisualStarIconAmount.value = item.quantity;
            }
            if(notifyServer)
            {
               if(used)
               {
                  InstanceMng.getUserDataMng().updateSocialItem_useItem(item.mDef.mSku,amount);
               }
               else
               {
                  InstanceMng.getUserDataMng().updateSocialItem_removeItem(item.mDef.mSku,amount);
               }
               InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_USER_ITEMS_AMOUNT_INFO,{
                  "sku":item.mDef.mSku,
                  "amount":item.quantity
               });
            }
         }
         return returnValue;
      }
      
      public function sendItemToNeighbor(sku:String, toAccountId:String) : void
      {
         var item:ItemObject = this.getItemObjectBySku(sku);
         if(item != null)
         {
            DCDebug.traceCh("SocialWall","sendItemToNeighbor sku = " + sku + " to " + toAccountId + " amount left = " + item.quantity);
            InstanceMng.getUserDataMng().sendWishlistItem(sku,toAccountId);
         }
      }
      
      public function useItemFromInventory(item:ItemObject, particleAnchor:EAbstractSprite = null, from:String = "inventory", quantity:int = 1) : void
      {
         var wioSku:String = null;
         var transactionPack:Transaction = null;
         var params:Array = null;
         var useItemsNow:Vector.<ItemObject> = null;
         var itemTemp:ItemObject = null;
         var i:int = 0;
         var droidDef:DroidDef = null;
         var droidsToUse:int = 0;
         var amountOwned:int = 0;
         var amountAllowed:int = 0;
         var shipDef:ShipDef = null;
         var hc:HangarController = null;
         var coins:int = 0;
         var minerals:int = 0;
         var powerUpSku:String = null;
         var powerUpDef:PowerUpDef = null;
         var powerUpDefActive:PowerUpDef = null;
         var count:int = 0;
         var itemParams:Array = null;
         var itemSku:String = null;
         var sku:String = null;
         var allDroidsBought:String = null;
         var noSpaceText:String = null;
         var nearestAvailableHangar:Hangar = null;
         var hq:WorldItemObject = null;
         var hqIsRunning:Boolean = false;
         var NO_ERROR:int = 0;
         var ERROR_AT_HIGHEST_LEVEL:int = 0;
         var ERROR_UPGRADING_TO_HIGHEST_LEVEL:int = 0;
         var ERROR_WRONG_STATE:int = 0;
         var errorId:int = 0;
         var showError:Boolean = false;
         var textId:int = 0;
         var body:String = null;
         var removeItem:Boolean = false;
         var closePopup:Boolean = false;
         var itemUsed:Boolean = true;
         var userProfile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         params = item.mDef.getActionParams();
         var title:String = DCTextMng.getText(191);
         var actionType:String = item.mDef.getActionType();
         var itemMng:ItemsMng = this;
         var thisItem:ItemObject = item;
         if(this.canActionBePerformed(actionType))
         {
            switch(actionType)
            {
               case "worker":
                  droidDef = InstanceMng.getDroidDefMng().getCurrentDroidDef();
                  if(droidDef == null)
                  {
                     allDroidsBought = DCTextMng.replaceParameters(628,[InstanceMng.getDroidDefMng().getMaxAmountDroids()]);
                     this.guiOpenMessagePopup(title,allDroidsBought);
                  }
                  else
                  {
                     transactionPack = new Transaction();
                     transactionPack.addTransItem(item.mDef.mSku,-1);
                     InstanceMng.getShopsDrawer().buyWorkerPerformOps(1);
                     removeItem = true;
                     closePopup = true;
                  }
                  break;
               case "worldItem":
                  wioSku = item.mDef.getActionParam();
                  transactionPack = new Transaction();
                  droidsToUse = item.mDef.getUseDroidsFromInventory();
                  if(droidsToUse != 0)
                  {
                     transactionPack.setTransDroids(droidsToUse);
                  }
                  amountOwned = InstanceMng.getWorld().itemsAmountGet(wioSku);
                  amountAllowed = InstanceMng.getRuleMng().wioMaxNumPerCurrentHQUpgradeId(wioSku);
                  if(amountAllowed != 0)
                  {
                     transactionPack.setTransAmountOwned(amountOwned);
                     transactionPack.setTransAmountAllowed(amountAllowed);
                  }
                  transactionPack.addTransItem(item.mDef.mSku,-1);
                  transactionPack.computeAmountsLeftValues();
                  InstanceMng.getGUIControllerPlanet().shopBuy(wioSku,transactionPack,true);
                  closePopup = true;
                  break;
               case "unit":
                  wioSku = item.mDef.getActionParam();
                  shipDef = InstanceMng.getShipDefMng().getDefBySku(wioSku) as ShipDef;
                  hc = InstanceMng.getHangarControllerMng().getHangarController();
                  if(!hc.canAdd(shipDef.getSize()))
                  {
                     noSpaceText = DCTextMng.getText(380);
                     this.guiOpenMessagePopup(DCTextMng.getText(77),noSpaceText);
                  }
                  else
                  {
                     nearestAvailableHangar = hc.getHangarForDef(shipDef,true);
                     InstanceMng.getUnitScene().shipsPlaceShipWarOnHangar(shipDef.mSku,nearestAvailableHangar.getWIO());
                     transactionPack = new Transaction();
                     transactionPack.addTransItem(item.mDef.mSku,-1);
                     transactionPack.computeAmountsLeftValues();
                     InstanceMng.getUserDataMng().updateShips_giftUnitToHangar(wioSku,1,int(nearestAvailableHangar.getSid()),transactionPack);
                     removeItem = false;
                     closePopup = false;
                     this.removeItemFromInventory(item,true,false);
                  }
                  break;
               case "misteryGift":
                  if(item.mDef.getDoRandomSequence())
                  {
                     removeItem = true;
                     itemUsed = true;
                     MessageCenter.getInstance().sendMessage("lockInventoryItems");
                     InstanceMng.getApplication().lockUIWaitForMysteryCube(item.mDef.mSku);
                  }
                  else
                  {
                     removeItem = InstanceMng.getMisteryRewardDefMng().openBox(item);
                  }
                  break;
               case "coins":
                  coins = parseInt(item.mDef.getActionParam()) * quantity;
                  if(coins + userProfile.getCoins() > userProfile.getCoinsCapacity())
                  {
                     InstanceMng.getPopupMng().launchOverPopupText(particleAnchor,222,3000,"text_negative",true);
                  }
                  else
                  {
                     removeItem = false;
                     closePopup = false;
                     userProfile.addCoins(coins);
                     this.removeItemFromInventory(item,true,true,quantity);
                     InstanceMng.getPopupMng().launchOverPopupText(particleAnchor,"+" + DCTextMng.convertNumberToString(parseInt(item.mDef.getActionParam()),-1,-1),1000,"text_coins",true);
                  }
                  break;
               case "minerals":
                  minerals = parseInt(item.mDef.getActionParam()) * quantity;
                  if(minerals + userProfile.getMinerals() > userProfile.getMineralsCapacity())
                  {
                     InstanceMng.getPopupMng().launchOverPopupText(particleAnchor,222,3000,"text_negative",true);
                  }
                  else
                  {
                     removeItem = false;
                     closePopup = false;
                     userProfile.addMinerals(minerals);
                     this.removeItemFromInventory(item,true,true,quantity);
                     InstanceMng.getPopupMng().launchOverPopupText(particleAnchor,"+" + DCTextMng.convertNumberToString(parseInt(item.mDef.getActionParam()),-1,-1),1000,"text_minerals",true);
                  }
                  break;
               case "score":
                  removeItem = true;
                  closePopup = false;
                  InstanceMng.getUserInfoMng().getProfileLogin().addScore(parseInt(item.mDef.getActionParam()));
                  InstanceMng.getPopupMng().launchOverPopupText(particleAnchor,"+" + DCTextMng.convertNumberToString(parseInt(item.mDef.getActionParam()),-1,-1),1000,"text_score",true);
                  break;
               case "badges":
                  removeItem = true;
                  closePopup = false;
                  InstanceMng.getUserInfoMng().getProfileLogin().addBadges(parseInt(item.mDef.getActionParam()));
                  InstanceMng.getPopupMng().launchOverPopupText(particleAnchor,"+" + DCTextMng.convertNumberToString(parseInt(item.mDef.getActionParam()),-1,-1),1000,null,true);
                  break;
               case "experience":
                  removeItem = true;
                  closePopup = false;
                  InstanceMng.getUserInfoMng().getProfileLogin().addXp(parseInt(item.mDef.getActionParam()));
                  InstanceMng.getPopupMng().launchOverPopupText(particleAnchor,"+" + DCTextMng.convertNumberToString(parseInt(item.mDef.getActionParam()),-1,-1),1000,null,true);
                  break;
               case "chips":
                  removeItem = true;
                  closePopup = false;
                  InstanceMng.getUserInfoMng().getProfileLogin().addCash(parseInt(item.mDef.getActionParam()));
                  InstanceMng.getPopupMng().launchOverPopupText(particleAnchor,"+" + DCTextMng.convertNumberToString(parseInt(item.mDef.getActionParam()),-1,-1),1000,null,true);
                  break;
               case "powerups":
                  removeItem = true;
                  closePopup = false;
                  powerUpSku = item.mDef.getActionParam();
                  powerUpDef = InstanceMng.getPowerUpDefMng().getDefBySku(powerUpSku) as PowerUpDef;
                  powerUpDefActive = InstanceMng.getPowerUpMng().getPowerUpDefByType(powerUpDef.getType(),1);
                  if(InstanceMng.getPowerUpMng().isAnyPowerUpActive())
                  {
                     this.guiOpenMessagePopup(DCTextMng.getText(463),DCTextMng.getText(464));
                     removeItem = false;
                  }
                  else
                  {
                     InstanceMng.getPowerUpMng().powerUpActivate(item.mDef.getActionParam());
                     MessageCenter.getInstance().sendMessage("reloadInventory");
                  }
                  break;
               case "item":
                  count = int(params.length);
                  if(this.mUseItemsNow == null)
                  {
                     this.mUseItemsNow = new Vector.<ItemObject>(0);
                  }
                  else
                  {
                     this.mUseItemsNow.length = 0;
                  }
                  for(i = 0; i < count; )
                  {
                     itemParams = String(params[i]).split(":");
                     itemSku = String(itemParams[0]);
                     itemTemp = this.getItemObjectBySku(itemSku);
                     if(item != null)
                     {
                        this.addItemAmount(itemSku,itemParams[1],false);
                        if(itemTemp.mDef.getUseNow())
                        {
                           this.mUseItemsNow.push(itemTemp);
                        }
                     }
                     i++;
                  }
                  removeItem = true;
                  break;
               case "umbrella":
                  if(Config.useUmbrella())
                  {
                     if(InstanceMng.getUmbrellaMng().useUmbrella())
                     {
                        InstanceMng.getPopupMng().launchOverPopupText(particleAnchor,DCTextMng.getText(2578),500);
                        removeItem = true;
                     }
                     else
                     {
                        InstanceMng.getPopupMng().launchOverPopupText(particleAnchor,DCTextMng.getText(3976),500);
                        removeItem = false;
                     }
                  }
                  break;
               case "shield":
                  sku = String(params[0]);
                  if(InstanceMng.getRuleMng().checkIfThisColonyShieldTimeWillExceedMax(sku))
                  {
                     this.guiOpenMessagePopup(DCTextMng.getText(463),DCTextMng.getText(213));
                  }
                  else
                  {
                     removeItem = true;
                     InstanceMng.getRuleMng().addColonyShield(params[0]);
                  }
                  break;
               case "upgradeHQ":
                  removeItem = false;
                  if(InstanceMng.getApplication().viewGetMode() == 0 && InstanceMng.getFlowState().getCurrentRoleId() == 0)
                  {
                     hq = InstanceMng.getWorld().itemsGetHeadquarters();
                     hqIsRunning = false;
                     NO_ERROR = 0;
                     ERROR_AT_HIGHEST_LEVEL = 1;
                     ERROR_UPGRADING_TO_HIGHEST_LEVEL = 2;
                     ERROR_WRONG_STATE = 3;
                     errorId = ERROR_WRONG_STATE;
                     showError = true;
                     if(hq != null)
                     {
                        if(hq.canBeUpgraded())
                        {
                           if(hq.getNextDef().getUpgradeId() == InstanceMng.getWorldItemDefMng().getMaxUpgradeLevel(hq.mDef.mSku))
                           {
                              errorId = ERROR_UPGRADING_TO_HIGHEST_LEVEL;
                           }
                           else if(hq.mState.mStateId == 26)
                           {
                              closePopup = true;
                              removeItem = true;
                              InstanceMng.getWorld().actionOnItemMoveCameraAndApply(hq,0);
                              errorId = NO_ERROR;
                           }
                           else
                           {
                              errorId = ERROR_WRONG_STATE;
                           }
                        }
                        else
                        {
                           errorId = ERROR_AT_HIGHEST_LEVEL;
                        }
                     }
                     if(errorId != NO_ERROR)
                     {
                        switch(errorId)
                        {
                           case ERROR_AT_HIGHEST_LEVEL:
                              textId = 490;
                              break;
                           case ERROR_UPGRADING_TO_HIGHEST_LEVEL:
                              textId = 491;
                              break;
                           case ERROR_WRONG_STATE:
                              textId = 492;
                        }
                        this.guiOpenMessagePopup(DCTextMng.getText(463),DCTextMng.getText(textId),false);
                     }
                  }
                  break;
               case "fillCoinsBar":
                  removeItem = false;
                  InstanceMng.getNotificationsMng().guiOpenConfirmPopup("PopupConfirmInventoryUse",DCTextMng.getText(3063),DCTextMng.getText(3678),"orange_normal",DCTextMng.getText(1),null,function():void
                  {
                     InstanceMng.getUserInfoMng().getProfileLogin().refillCoins();
                     itemMng.removeItemFromInventory(thisItem,true);
                     itemMng.guiCloseInventoryPopup();
                  },null);
                  break;
               case "fillMineralsBar":
                  removeItem = false;
                  InstanceMng.getNotificationsMng().guiOpenConfirmPopup("PopupConfirmInventoryUse",DCTextMng.getText(3063),DCTextMng.getText(3678),"orange_normal",DCTextMng.getText(1),null,function():void
                  {
                     InstanceMng.getUserInfoMng().getProfileLogin().refillMinerals();
                     itemMng.removeItemFromInventory(thisItem,true);
                     itemMng.guiCloseInventoryPopup();
                  },null);
                  break;
               case "recycleObstacles":
                  if(InstanceMng.getWorld().itemsGetAllObstacles().length == 0)
                  {
                     removeItem = false;
                     InstanceMng.getNotificationsMng().guiOpenMessagePopup("NOTIFY_SHOW_BULLDOZER_WARNING",DCTextMng.getText(77),DCTextMng.getText(4054),"builder_worried");
                  }
                  else
                  {
                     removeItem = true;
                     InstanceMng.getMapModel().removeObstaclesFromScene();
                  }
                  break;
               default:
                  removeItem = true;
            }
            if(removeItem)
            {
               this.removeItemFromInventory(item,itemUsed,true,quantity);
            }
            if(this.mUseItemsNow != null)
            {
               while(this.mUseItemsNow.length > 0)
               {
                  itemTemp = this.mUseItemsNow.shift();
                  while(itemTemp.quantity > 0)
                  {
                     this.useItemFromInventory(itemTemp);
                  }
               }
            }
            if(closePopup)
            {
               this.guiCloseInventoryPopup();
            }
         }
         else
         {
            title = DCTextMng.getText(191);
            body = DCTextMng.getText(688);
            this.guiOpenMessagePopup(title,body);
         }
      }
      
      private function canActionBePerformed(actionType:String) : Boolean
      {
         var returnValue:Boolean = true;
         var roleId:int = InstanceMng.getRole().mId;
         var viewMode:int = InstanceMng.getApplication().viewGetMode();
         if(roleId != 0 || viewMode != 0)
         {
            switch(actionType)
            {
               case "misteryGift":
               case "coins":
               case "minerals":
               case "experience":
               case "chips":
               case "item":
               case "shield":
               case "fillCoinsBar":
               case "fillMineralsBar":
                  returnValue = true;
                  break;
               default:
                  returnValue = false;
            }
         }
         return returnValue;
      }
      
      public function incrementItemAmount(item:ItemObject, amount:int = 1, checkLimit:Boolean = true, showNewContent:Boolean = true) : Boolean
      {
         var i:int = 0;
         var ret:Boolean = true;
         if(item.ownsToMenu("inventory"))
         {
            for(i = 0; i < amount; ret &&= this.addItemToInventory(item,checkLimit,showNewContent),i++)
            {
            }
         }
         else
         {
            ret = true;
            item.quantity += amount;
            if(showNewContent)
            {
               item.mVisualStarIconAmount.value += amount;
            }
         }
         return ret;
      }
      
      public function getItemObjectBySku(sku:String) : ItemObject
      {
         var item:ItemObject = null;
         for each(item in this.mItemsList)
         {
            if(item.mDef.mSku == sku)
            {
               return item;
            }
         }
         return null;
      }
      
      public function getItemByIngameAction(action:String, sku:String, upgrade:int = 0, npcSku:String = "") : Vector.<ItemObject>
      {
         var itemObject:ItemObject = null;
         var length:int = 0;
         var paramsLength:int = 0;
         var params:Array = null;
         var npcs:Vector.<UserInfo> = null;
         var currentNpc:UserInfo = null;
         var i:int = 0;
         var j:int = 0;
         var itemsList:Vector.<ItemObject> = this.mItemsActionList[action];
         var returnItems:Vector.<ItemObject> = new Vector.<ItemObject>(0);
         if(itemsList != null)
         {
            length = int(itemsList.length);
            npcs = InstanceMng.getUserInfoMng().getNPCList(1);
            for(i = 0; i < length; )
            {
               if((params = (itemObject = itemsList[i]).mDef.getParameters()) != null)
               {
                  paramsLength = int(params.length);
                  for(j = 0; j < paramsLength; )
                  {
                     if(params[j][0] == sku && (params[j][1] != null && params[j][1] - 1 <= upgrade || params[j][1] == null) && (params[j][2] == npcSku || params[j][2] == "" || params[j][2] == null) && itemObject.getTimeLeft() == 0)
                     {
                        if(itemObject.canIGetOne())
                        {
                           this.pushItem(itemObject,returnItems);
                        }
                        break;
                     }
                     j++;
                  }
               }
               else if((itemObject = itemsList[i]).getTimeLeft() == 0 && itemObject.canIGetOne())
               {
                  this.pushItem(itemObject,returnItems);
               }
               i++;
            }
         }
         return returnItems;
      }
      
      private function pushItem(itemObject:ItemObject, returnItems:Vector.<ItemObject>) : void
      {
         returnItems.push(itemObject);
         if(itemObject.mDef.getUseNow())
         {
            this.useItemFromInventory(itemObject);
         }
      }
      
      public function getCollectionItemsParticleByAction(sku:String, action:String, x:Number, y:Number, upgrade:int = 0, npcSku:String = "") : void
      {
         var itemCollectable:ItemObject = null;
         var particlesLength:int = 0;
         var currentParticleIndex:int = 0;
         var collectable:Vector.<ItemObject>;
         if((collectable = this.getItemByIngameAction(action,sku,upgrade,npcSku)) != null)
         {
            particlesLength = int(collectable.length);
            currentParticleIndex = 0;
            for each(itemCollectable in collectable)
            {
               ParticleMng.addParticleGift(itemCollectable,x,y,particlesLength,currentParticleIndex);
               currentParticleIndex++;
            }
         }
      }
      
      public function getCollectibleItemsParticleByCatalog(skuCatalog:Dictionary, x:int, y:int) : void
      {
         var sku:String = null;
         for each(sku in skuCatalog)
         {
            this.getCollectibleItemsParticle(sku,x,y);
         }
      }
      
      public function getCollectibleItemsParticle(sku:String, x:int, y:int) : void
      {
         var itemObject:ItemObject;
         if((itemObject = this.getItemObjectBySku(sku)) != null)
         {
            this.addItemToInventory(itemObject);
            ParticleMng.addParticleGift(itemObject,x,y);
         }
      }
      
      public function getCollections() : Vector.<Array>
      {
         var i:int = 0;
         var def:CollectablesDef = null;
         var collections:Vector.<Array> = new Vector.<Array>(0);
         var collDefs:Vector.<DCDef>;
         var length:int = int((collDefs = InstanceMng.getCollectablesDefMng().getDefs()).length);
         var currentTime:Number = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
         for(i = 0; i < length; )
         {
            def = CollectablesDef(collDefs[i]);
            if(def.isAvailable(currentTime) && def.validDateIsValid(currentTime))
            {
               collections.push(this.getCollection(collDefs[i].mSku));
            }
            i++;
         }
         return collections;
      }
      
      public function getCollection(sku:String) : Array
      {
         var i:int = 0;
         var items:Array = [];
         var collDef:CollectablesDef;
         var itemsSku:Array = (collDef = InstanceMng.getCollectablesDefMng().getDefBySku(sku) as CollectablesDef).getCollectionList();
         items.push(collDef.mSku);
         for(i = 0; i < 5; )
         {
            items.push(this.getItemObjectBySku(itemsSku[i]));
            i++;
         }
         return items;
      }
      
      public function getCollectionByCollectableSku(sku:String) : Vector.<ItemObject>
      {
         var collDef:CollectablesDef = null;
         var itemsList:Array = null;
         var itemName:String = null;
         var collDefs:Vector.<DCDef> = InstanceMng.getCollectablesDefMng().getDefs();
         var items:Vector.<ItemObject> = new Vector.<ItemObject>(0);
         for each(collDef in collDefs)
         {
            itemsList = collDef.getCollectionList();
            if(itemsList.indexOf(sku) > -1)
            {
               for each(itemName in itemsList)
               {
                  items.push(this.getItemObjectBySku(itemName));
               }
            }
         }
         return items;
      }
      
      public function getCollectionIdByCollectableSku(sku:String) : String
      {
         var collDef:CollectablesDef = null;
         var itemsList:Array = null;
         var collDefs:Vector.<DCDef> = InstanceMng.getCollectablesDefMng().getDefs();
         var items:Vector.<ItemObject> = new Vector.<ItemObject>(0);
         for each(collDef in collDefs)
         {
            itemsList = collDef.getCollectionList();
            if(itemsList.indexOf(sku) > -1)
            {
               return collDef.mSku;
            }
         }
         return null;
      }
      
      public function getCollectionIdByCollectableRewardSku(sku:String) : String
      {
         var collDef:CollectablesDef = null;
         var itemsList:Array = null;
         var collDefs:Vector.<DCDef> = InstanceMng.getCollectablesDefMng().getDefs();
         var items:Vector.<ItemObject> = new Vector.<ItemObject>(0);
         for each(collDef in collDefs)
         {
            if(sku == collDef.getReward()[1])
            {
               return collDef.mSku;
            }
         }
         return null;
      }
      
      public function isTheSameCollection(collectionId:String, itemSku:String) : Boolean
      {
         var i:int = 0;
         var item:ItemObject = null;
         if(collectionId == null)
         {
            return true;
         }
         var collection:Array = this.getCollection(collectionId);
         for(i = 1; i <= 5; )
         {
            item = collection[i];
            if(item.mDef.mSku == itemSku)
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      public function getCollectionReward(sku:String) : RewardObject
      {
         var collDef:CollectablesDef = InstanceMng.getCollectablesDefMng().getDefBySku(sku) as CollectablesDef;
         return new RewardObject(collDef.getReward());
      }
      
      public function isCollectionRewardApplicable(sku:String) : Boolean
      {
         var i:int = 0;
         var item:ItemObject = null;
         var itemsCount:int = 0;
         var items:Array = this.getCollection(sku);
         for(i = 1; i <= 5; )
         {
            item = items[i];
            if(item.quantity > 0)
            {
               itemsCount++;
            }
            i++;
         }
         return itemsCount >= 5;
      }
      
      public function getCollectionBulkAmount(sku:String) : int
      {
         var i:int = 0;
         var items:Array = this.getCollection(sku);
         var item:ItemObject = null;
         var amt:int = int(items[1].quantity);
         for(i = 2; i <= 5; )
         {
            item = items[i];
            if(item.quantity < amt)
            {
               amt = item.quantity;
            }
            i++;
         }
         return amt;
      }
      
      public function getCraftingBulkAmount(sku:String) : int
      {
         var i:int = 0;
         var items:Array = this.getCrafting(sku);
         var item:ItemObject = null;
         var amt:int = int(items[1].quantity);
         for(i = 2; i <= 4; )
         {
            item = items[i];
            if(item.quantity < amt)
            {
               amt = item.quantity;
            }
            i++;
         }
         return amt;
      }
      
      public function isUseMultipleApplicable(itemObject:ItemObject) : Boolean
      {
         return (itemObject.mDef.getActionType() == "coins" || itemObject.mDef.getActionType() == "minerals") && itemObject.quantity >= 50;
      }
      
      public function applyReward(rewardObj:RewardObject) : void
      {
         var item:ItemObject = rewardObj.getItem();
         var userProfile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         switch(rewardObj.mSku)
         {
            case "coins":
               userProfile.addCoins(rewardObj.getAmount());
               break;
            case "minerals":
               userProfile.addMinerals(rewardObj.getAmount());
               break;
            case "item":
               this.addItemAmount(item.mDef.mSku,rewardObj.getAmount(),false);
               if(item.mDef.getUseNow())
               {
                  this.useItemFromInventory(item);
               }
               break;
            case "chips":
               userProfile.addCash(rewardObj.getAmount());
               break;
            case "badges":
               userProfile.addBadges(rewardObj.getAmount());
         }
      }
      
      public function applyCollectionReward(sku:String) : void
      {
         var i:int = 0;
         var collDef:CollectablesDef = InstanceMng.getCollectablesDefMng().getDefBySku(sku) as CollectablesDef;
         var rewardObj:RewardObject = new RewardObject(collDef.getReward());
         this.applyReward(rewardObj);
         var item:ItemObject = rewardObj.getItem();
         var items:Array = this.getCollection(sku);
         for(i = 1; i <= 5; )
         {
            item = items[i];
            item.quantity--;
            i++;
         }
         InstanceMng.getUserDataMng().updateSocialItem_applyCollectable(collDef.mSku);
         InstanceMng.getTargetMng().updateProgress("completeCollection",1,sku);
      }
      
      public function getCraftingGroups() : Vector.<Array>
      {
         var i:int = 0;
         var craftings:Vector.<Array> = new Vector.<Array>(0);
         var craftDefs:Vector.<DCDef> = InstanceMng.getCraftingDefMng().getDefs();
         var length:int = int(craftDefs.length);
         for(i = 0; i < length; )
         {
            craftings.push(this.getCrafting(craftDefs[i].mSku));
            i++;
         }
         return craftings;
      }
      
      public function getCraftingGroupsRewards() : Vector.<RewardObject>
      {
         var i:int = 0;
         var craftings:Vector.<RewardObject> = new Vector.<RewardObject>(0);
         var craftDefs:Vector.<DCDef> = InstanceMng.getCraftingDefMng().getDefs();
         var length:int = int(craftDefs.length);
         for(i = 0; i < length; )
         {
            craftings.push(this.getCraftingReward(craftDefs[i].mSku));
            i++;
         }
         return craftings;
      }
      
      public function getRewardsFromSpecialAttacksDefs(specialAttackType:String = "-99") : Vector.<RewardObject>
      {
         var i:int = 0;
         var rewardDefs:Vector.<DCDef> = null;
         if(specialAttackType == "-99")
         {
            specialAttackType = "showInLeftBar";
         }
         var rewards:Vector.<RewardObject> = new Vector.<RewardObject>(0);
         if(specialAttackType == "showInLeftBar")
         {
            rewardDefs = InstanceMng.getSpecialAttacksDefMng().getDefsShowInLeftBar();
         }
         else if(specialAttackType == "showInMercenariesBar")
         {
            rewardDefs = InstanceMng.getSpecialAttacksDefMng().getDefsShowInMercenariesBar();
         }
         else
         {
            if(specialAttackType != "showInTopBar")
            {
               return null;
            }
            rewardDefs = InstanceMng.getSpecialAttacksDefMng().getDefsShowInTopBar();
         }
         var length:int = int(rewardDefs.length);
         for(i = 0; i < length; )
         {
            rewards.push(this.getRewardFromSpecialAttackDef(rewardDefs[i] as SpecialAttacksDef));
            i++;
         }
         return rewards;
      }
      
      public function getCrafting(sku:String) : Array
      {
         var i:int = 0;
         var items:Array = [];
         var craftDef:CraftingDef = InstanceMng.getCraftingDefMng().getDefBySku(sku) as CraftingDef;
         var itemsSku:Array = craftDef.getCraftingList();
         items.push(craftDef.mSku);
         for(i = 0; i < 4; )
         {
            items.push(this.getItemObjectBySku(itemsSku[i][0]));
            i++;
         }
         return items;
      }
      
      public function getCraftingReward(sku:String) : RewardObject
      {
         var craftDef:CraftingDef = InstanceMng.getCraftingDefMng().getDefBySku(sku) as CraftingDef;
         return new RewardObject(craftDef.getReward());
      }
      
      public function getRewardFromSpecialAttackDef(def:SpecialAttacksDef) : RewardObject
      {
         var rewardObject:RewardObject = this.mCraftRewardsOwned[def.mSku];
         if(rewardObject == null)
         {
            rewardObject = new RewardObject(null,def);
         }
         return rewardObject;
      }
      
      public function isCraftingRewardApplicable(sku:String) : Boolean
      {
         var i:int = 0;
         var item:ItemObject = null;
         var itemsCount:int = 0;
         var items:Array = this.getCrafting(sku);
         var craftDef:CraftingDef;
         var itemsSku:Array = (craftDef = InstanceMng.getCraftingDefMng().getDefBySku(sku) as CraftingDef).getCraftingList();
         var index:int = 0;
         for(i = 1; i <= 4; )
         {
            item = items[i];
            if(item.quantity >= itemsSku[index][1])
            {
               itemsCount++;
            }
            index++;
            i++;
         }
         return itemsCount >= 4;
      }
      
      private function craftingLoadRewards() : void
      {
         var group:Array = null;
         var groupSku:String = null;
         var rewardObject:RewardObject = null;
         var i:int = 0;
         if(this.mCraftRewardsOwned == null)
         {
            this.mCraftRewardsOwned = new Dictionary();
         }
         for each(group in this.getCraftingGroups())
         {
            groupSku = String(group[0]);
            rewardObject = this.mCraftRewardsOwned[groupSku];
            if(rewardObject == null)
            {
               rewardObject = this.getCraftingReward(groupSku);
               this.mCraftRewardsOwned[groupSku] = rewardObject;
            }
            if(this.mCraftAutoBuild)
            {
               for(i = rewardObject.getAmountOwned(); i > 0; )
               {
                  this.applyCraftingReward(groupSku);
                  i--;
               }
            }
         }
      }
      
      private function craftingCompletedIfItemAdded(groupSku:String, itemSku:String) : Boolean
      {
         var i:int = 0;
         var item:ItemObject = null;
         var group:Array;
         if((group = this.getCrafting(groupSku)) == null)
         {
            return false;
         }
         var myItem:ItemObject;
         if((myItem = this.getItemObjectBySku(itemSku)) == null)
         {
            return false;
         }
         var craftDef:CraftingDef;
         var craftDefList:Array = (craftDef = InstanceMng.getCraftingDefMng().getDefBySku(groupSku) as CraftingDef).getCraftingList();
         for(i = group.length - 1; i > 0; )
         {
            item = group[i] as ItemObject;
            if(item.quantity < craftDefList[i - 1][1])
            {
               return false;
            }
            i--;
         }
         return true;
      }
      
      public function craftingAddItemToInventory(itemSku:String, groupSku:String = null) : void
      {
         var lastAmount:int = 0;
         var craftDef:CraftingDef = null;
         var item:ItemObject;
         if((item = this.getItemObjectBySku(itemSku)) == null)
         {
            return;
         }
         var craftingGroup:Array;
         if((craftingGroup = groupSku == null ? this.getCraftingGroupByCraftItemSku(item.mDef.mSku) : this.getCrafting(groupSku)) == null)
         {
            return;
         }
         var craftSku:String = String(craftingGroup[0]);
         var reward:RewardObject = this.mCraftRewardsOwned[craftSku];
         if(reward != null && this.mCraftAutoBuild)
         {
            lastAmount = reward.getAmountOwned();
            craftDef = InstanceMng.getCraftingDefMng().getDefBySku(craftSku) as CraftingDef;
            reward.updateAmountOwned(craftDef,craftingGroup);
            if(reward.getAmountOwned() > lastAmount)
            {
               this.applyCraftingReward(craftSku);
            }
         }
      }
      
      public function getCraftingGroupFromReward(sku:String) : Array
      {
         var group:Array = null;
         for each(group in this.getCraftingGroups())
         {
            try
            {
               if(this.getCraftingReward(group[0]).mSku == sku)
               {
                  return group;
               }
            }
            catch(e:Error)
            {
               DCDebug.trace("ItemsMng.getCraftingGroupFromReward for sku=" + sku + " has failed for crafting group with sku=" + group[0],3);
            }
         }
         return null;
      }
      
      public function getCraftingGroupByCraftItemSku(sku:String, returnFirst:Boolean = true) : Array
      {
         var group:Array = null;
         var item:ItemObject = null;
         var i:int = 0;
         var groups:Array = null;
         for each(group in this.getCraftingGroups())
         {
            for(i = group.length - 1; i > 0; )
            {
               item = group[i] as ItemObject;
               if(item.mDef.mSku == sku)
               {
                  if(returnFirst)
                  {
                     return group;
                  }
                  if(groups == null)
                  {
                     groups = [];
                  }
                  groups.push(group);
               }
               i--;
            }
         }
         return groups;
      }
      
      public function getCraftingIdByItemRewardSku(sku:String) : String
      {
         var craftDef:CraftingDef = null;
         var craftDefs:Vector.<DCDef> = InstanceMng.getCraftingDefMng().getDefs();
         for each(craftDef in craftDefs)
         {
            if(sku == craftDef.getReward()[1])
            {
               return craftDef.mSku;
            }
         }
         return null;
      }
      
      public function applyCraftingReward(sku:String) : void
      {
         var i:int = 0;
         var definition:Array = null;
         var craftDef:CraftingDef = InstanceMng.getCraftingDefMng().getDefBySku(sku) as CraftingDef;
         var rewardObj:RewardObject;
         if((rewardObj = this.mCraftRewardsOwned[sku] as RewardObject) == null)
         {
            rewardObj = new RewardObject(craftDef.getReward());
            this.mCraftRewardsOwned[sku] = rewardObj;
         }
         var amountToAdd:int = rewardObj.getAmount();
         var item:ItemObject = rewardObj.getItem();
         if(item != null)
         {
            item.quantity += amountToAdd;
            item.mVisualStarIconAmount.value += amountToAdd;
         }
         var items:Array = this.getCrafting(sku);
         var definitions:Array = craftDef.getCraftingList();
         var transaction:Transaction = new Transaction();
         for(i = 1; i <= 4; )
         {
            item = items[i];
            definition = definitions[i - 1];
            item.quantity -= definition[1];
            transaction.addTransItem(item.mDef.mSku,-definition[1]);
            i++;
         }
         InstanceMng.getUserDataMng().updateSocialItem_applyCrafting(craftDef.mSku,transaction);
         InstanceMng.getTargetMng().updateProgress("completeCrafting",1,sku);
      }
      
      public function hasCraftingPending() : Boolean
      {
         var craftingGroup:Array = null;
         for each(craftingGroup in this.getCraftingGroups())
         {
            if(this.isCraftingRewardApplicable(craftingGroup[0]))
            {
               return true;
            }
         }
         return false;
      }
      
      public function getItemMenuByCraftingOrCollection(cSku:String, isCrafting:Boolean = true) : String
      {
         var def:DCDef = null;
         var rewardObject:RewardObject = null;
         var item:ItemObject = null;
         if(isCrafting)
         {
            def = InstanceMng.getCraftingDefMng().getDefBySku(cSku);
            rewardObject = new RewardObject(CraftingDef(def).getReward());
         }
         else
         {
            def = InstanceMng.getCollectablesDefMng().getDefBySku(cSku);
            rewardObject = new RewardObject(CollectablesDef(def).getReward());
         }
         if(rewardObject != null)
         {
            item = rewardObject.getItem();
            if(item != null)
            {
               return item.mDef.getMenusList()[0];
            }
         }
         return null;
      }
      
      public function getItemMenuIndexByMenuName(menu:String) : int
      {
         switch(menu)
         {
            case "inventory":
               return 2;
            case "collectable":
               return 1;
            case "crafting":
               return 0;
            default:
               return 0;
         }
      }
      
      public function isInWishlist(item:ItemObject) : Boolean
      {
         var i:int = 0;
         for(i = 0; i < this.mWishList.length; )
         {
            if(item.mDef.getActualItemSku() == this.mWishList[i].mDef.getActualItemSku())
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      public function addItemToWishList(item:ItemObject) : Boolean
      {
         if(this.isInWishlist(item))
         {
            this.guiOpenWishlistErrorPopup(246);
            return false;
         }
         if(this.mWishList.length >= 3)
         {
            this.guiOpenWishlistErrorPopup(193);
            return false;
         }
         this.mWishList.push(item);
         if(this.mItemsListLoaded)
         {
            InstanceMng.getUserDataMng().updateSocialItem_addItemToWishList(item.mDef.mSku);
         }
         return true;
      }
      
      public function canAddItemToWishList(item:ItemObject) : Boolean
      {
         return this.mWishList.indexOf(item) == -1 && this.mWishList.length < 3;
      }
      
      public function removeItemFromWishList(item:ItemObject) : void
      {
         var index:int = this.mWishList.indexOf(item);
         if(index >= 0)
         {
            this.removeItemFromWishListByIndex(index);
         }
      }
      
      public function removeItemFromWishListByIndex(index:int) : void
      {
         InstanceMng.getUserDataMng().updateSocialItem_removeItemFromWishList(this.mWishList[index].mDef.mSku);
         this.mWishList.splice(index,1);
      }
      
      public function getWishList() : Vector.<ItemObject>
      {
         return this.mWishList;
      }
      
      public function getWishListNames() : String
      {
         var item:ItemObject = null;
         var names:String = "";
         for each(item in this.mWishList)
         {
            names += item.mDef.getNameToDisplay() + ", ";
         }
         return names.substr(0,names.length - 2);
      }
      
      public function addItemAmount(sku:String, amount:int, notifyServer:Boolean = true, useItem:Boolean = false, checkLimit:Boolean = true, showStar:Boolean = true) : void
      {
         var added:Boolean = false;
         var item:ItemObject = this.getItemObjectBySku(sku);
         if(amount < 0)
         {
            this.removeItemFromInventory(item,useItem,notifyServer,Math.abs(amount));
         }
         else if((added = this.incrementItemAmount(item,amount,checkLimit,showStar)) && item.mDef.getShowInInventory())
         {
            InstanceMng.getApplication().showInventoryStar(item);
         }
      }
      
      public function getArrayVectorForSpecialAttacks(specialAttackType:String = "-99") : Vector.<Array>
      {
         var reward:RewardObject = null;
         if(specialAttackType == "-99")
         {
            specialAttackType = "showInLeftBar";
         }
         var v:Vector.<RewardObject> = this.getRewardsFromSpecialAttacksDefs(specialAttackType);
         var info:Vector.<Array> = new Vector.<Array>(0);
         for each(reward in v)
         {
            info.push([reward]);
         }
         return info;
      }
      
      public function getAmountSpecialAttacksOwned() : int
      {
         var reward:RewardObject = null;
         var v:Vector.<RewardObject> = this.getCraftingGroupsRewards();
         var amount:int = 0;
         for each(reward in v)
         {
            amount += reward.getAmountOwned();
         }
         return amount;
      }
      
      public function investGetItemsAmount() : int
      {
         var returnValue:int = 0;
         return InstanceMng.getItemsMng().getItemObjectBySku("400").quantity;
      }
      
      public function getSpyCapsulesMaxAmount() : int
      {
         var itemDef:ItemsDef = ItemsDef(InstanceMng.getItemsDefMng().getDefBySku("10000"));
         return itemDef.getMaxAmountInventory();
      }
      
      public function getSpyCapsuleSkuFromSpyType(type:int) : String
      {
         var sku:String = "10000";
         switch(type)
         {
            case 0:
               sku = "10000";
               break;
            case 1:
               sku = "10001";
         }
         return sku;
      }
      
      public function getSpyCapsules(type:int = 0) : int
      {
         var returnValue:int = 0;
         return InstanceMng.getItemsMng().getItemObjectBySku(this.getSpyCapsuleSkuFromSpyType(type)).quantity;
      }
      
      public function getMercenaries() : int
      {
         var returnValue:int = 0;
         return InstanceMng.getItemsMng().getItemObjectBySku("7200").quantity;
      }
      
      private function guiUnload() : void
      {
         this.mGuiPopupInventory = null;
      }
      
      public function guiOpenMessagePopup(titleText:String, bodyText:String, closeOpenedPopup:Boolean = true) : void
      {
         InstanceMng.getNotificationsMng().guiOpenMessagePopup("PopupInventoryCantUseItem",titleText,bodyText,"orange_normal",null,closeOpenedPopup);
      }
      
      public function guiOpenInventoryPopup(tab:String = null) : DCIPopup
      {
         if(tab == null)
         {
            tab = "inventory";
         }
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         this.mGuiPopupInventory = uiFacade.getPopupFactory().getInventoryPopup(tab) as EPopupInventory;
         uiFacade.enqueuePopup(this.mGuiPopupInventory);
         return this.mGuiPopupInventory;
      }
      
      public function guiCloseInventoryPopup() : void
      {
         if(this.mGuiPopupInventory != null)
         {
            if(this.mGuiPopupInventory.isPopupBeingShown())
            {
               InstanceMng.getUIFacade().closePopup(this.mGuiPopupInventory);
            }
            this.mGuiPopupInventory = null;
         }
         if(Config.useUmbrella())
         {
            InstanceMng.getUmbrellaMng().notifyCloseInventoryPopup();
         }
      }
      
      public function guiGetInventoryPopup() : EPopupInventory
      {
         return this.mGuiPopupInventory;
      }
      
      public function guiOpenWishlistErrorPopup(tid:int) : DCIPopup
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popup:DCIPopup = uiFacade.getPopupFactory().getAddItemToWishlistErrorPopup(tid);
         uiFacade.enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenPopupGetItem() : void
      {
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getPopupGetItem();
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
   }
}
