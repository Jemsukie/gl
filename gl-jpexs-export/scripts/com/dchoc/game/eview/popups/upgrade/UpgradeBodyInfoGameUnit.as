package com.dchoc.game.eview.popups.upgrade
{
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.shop.Shipyard;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.utils.EUtils;
   import esparragon.widgets.EButton;
   import esparragon.widgets.EFillBar;
   import esparragon.widgets.paginator.EPaginatorComponent;
   
   public class UpgradeBodyInfoGameUnit extends UpgradeBodyInfo
   {
      
      private static const BUTTON_BACK:String = "ButtonBack";
      
      private static const TEXT_BACK:String = "TextBack";
       
      
      private var mGameUnit:GameUnit;
      
      private var mUnitDef:ShipDef;
      
      private var mNextDef:ShipDef;
      
      private var mMaxDef:ShipDef;
      
      private var mIsUnlocking:Boolean;
      
      private var mIsUpgrading:Boolean;
      
      public function UpgradeBodyInfoGameUnit(popupUpgrade:EPopupUpgrade, viewFactory:ViewFactory, skinSku:String)
      {
         super(popupUpgrade,viewFactory,skinSku);
      }
      
      override public function setup(info:*) : void
      {
         if(info != null)
         {
            this.mGameUnit = info as GameUnit;
            this.mMaxDef = this.mGameUnit.getMaxDef();
            this.mUnitDef = this.mGameUnit.mDef;
            if(this.mUnitDef.getUpgradeId() == this.mMaxDef.getUpgradeId())
            {
               this.mNextDef = this.mUnitDef;
            }
            else
            {
               this.mNextDef = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(this.mUnitDef.mSku,this.mUnitDef.getUpgradeId() + 1);
            }
            createTabs(this.mMaxDef.getUpgradeId() + 1);
            this.setupBackButton();
            if(this.mGameUnit.mIsUnlocked)
            {
               this.setPageId(null,this.mNextDef.getUpgradeId());
            }
            else
            {
               this.setPageId(null,0);
            }
            this.mIsUnlocking = this.getIsUnlocking();
         }
      }
      
      override protected function setupBottom() : void
      {
         var alertText:String = null;
         var alertIcon:String = null;
         var align:int = 0;
         var levels:int = 0;
         if(mBottomBoxes != null)
         {
            mBottomBoxes = null;
         }
         mBottomBoxes = [];
         var setRequirements:Boolean = false;
         var setCost:Boolean = false;
         var setChips:Boolean = false;
         var setDiscount:Boolean = false;
         if(!this.getIsUnlocked())
         {
            mPopupUpgrade.setTitleText(DCTextMng.getText(165));
            if(this.getIsUnlocking())
            {
               setupUpgradingBox();
               align = 1;
            }
            else if(this.mUnitDef == this.mNextDef)
            {
               if(this.checkIfShipyardIsBuild())
               {
                  setRequirements = true;
                  setCost = true;
                  setChips = true;
                  align = 0;
               }
               else
               {
                  alertText = DCTextMng.replaceParameters(278,[this.mUnitDef.getShipyardDef().getNameToDisplay()]);
                  alertIcon = "icon_warning";
                  align = 1;
               }
            }
            else
            {
               alertText = DCTextMng.getText(277);
               alertIcon = "icon_warning";
               align = 1;
            }
         }
         else if(this.mNextDef.getUpgradeId() > this.mUnitDef.getUpgradeId())
         {
            mPopupUpgrade.setTitleText(DCTextMng.getText(205));
            if(this.getIsUpgrading() || this.getIsUnlocking())
            {
               setupUpgradingBox();
               align = 1;
            }
            else if(this.getUpgradingUnit() != null)
            {
               alertText = DCTextMng.getText(290);
               alertIcon = "icon_warning";
               align = 1;
            }
            else
            {
               setRequirements = true;
               if((levels = this.mNextDef.getUpgradeId() - this.mUnitDef.getUpgradeId()) == 1)
               {
                  setCost = true;
                  setChips = true;
               }
               else
               {
                  setDiscount = true;
               }
               align = 0;
            }
         }
         else
         {
            if(this.mUnitDef.getUpgradeId() == this.mMaxDef.getUpgradeId())
            {
               alertText = DCTextMng.getText(590);
            }
            else
            {
               alertText = DCTextMng.getText(292);
            }
            alertIcon = "icon_check";
            align = 1;
         }
         if(setRequirements)
         {
            this.setupRequirements();
         }
         if(setChips)
         {
            setupCostWithChipsBox();
         }
         if(setCost)
         {
            setupCostBox();
         }
         if(alertText != null)
         {
            setupMessageBox(alertIcon,alertText);
         }
         if(setDiscount)
         {
            setupDiscountBox();
            setupDescriptionBox();
         }
         mViewFactory.distributeSpritesInArea(mBottomArea,mBottomBoxes,align,1,-1,1,true);
      }
      
      private function checkIfShipyardIsBuild() : Boolean
      {
         var i:int = 0;
         var shipyard:Shipyard = null;
         var shipyards:Array = InstanceMng.getShipyardController().getAllShipyards();
         var shipyardsCount:int = int(shipyards.length);
         var unitShipyardType:String = this.mUnitDef.getOwnerShipyardType();
         for(i = 0; i < shipyardsCount; )
         {
            if((shipyard = shipyards[i]) != null)
            {
               if(unitShipyardType == shipyard.getTypes())
               {
                  return true;
               }
            }
            i++;
         }
         return false;
      }
      
      override protected function getFillBars() : void
      {
         var dmgBar:ESpriteContainer = null;
         var field:ETextField = null;
         var layoutFactory:ELayoutAreaFactory = null;
         var specialContainer:ESpriteContainer = null;
         var itemsContainer:ESpriteContainer = null;
         var item:ESprite = null;
         var img:EImage = null;
         var offset:Number = NaN;
         var barsArea:ELayoutArea = null;
         if(this.mNextDef.getUpgradeId() > this.mUnitDef.getUpgradeId())
         {
            createFillBar(DCTextMng.getText(543),this.mMaxDef.getMaxEnergy(),this.mUnitDef.getMaxEnergy(),this.mNextDef.getMaxEnergy(),"icon_health");
            if(this.mUnitDef.getShotDamage() > 0)
            {
               dmgBar = createFillBar(DCTextMng.getText(539),this.mMaxDef.getShotDamage(),this.mUnitDef.getShotDamage(),this.mNextDef.getShotDamage(),"icon_damage");
               if(this.mUnitDef.getShotBurstLength() > 1)
               {
                  (field = dmgBar.getContentAsETextField("text_value")).setText(String(this.mUnitDef.getShotDamage()) + " X" + String(this.mUnitDef.getShotBurstLength()));
                  (field = dmgBar.getContentAsETextField("text_revalue")).setText(String(this.mNextDef.getShotDamage()) + " X" + String(this.mNextDef.getShotBurstLength()));
               }
            }
            else
            {
               createFillBar(DCTextMng.getText(712),-this.mMaxDef.getShotDamage(),-this.mUnitDef.getShotDamage(),-this.mNextDef.getShotDamage(),"icon_heal");
            }
            createFillBar(DCTextMng.getText(552),this.mMaxDef.getSpeed(),this.mUnitDef.getSpeed(),this.mNextDef.getSpeed(),"icon_speed");
            createFillBar(DCTextMng.getText(550),this.mMaxDef.getShotDistance(),this.mUnitDef.getShotDistance(),this.mNextDef.getShotDistance(),"icon_range");
            createFillBar(DCTextMng.getText(545),this.mMaxDef.getShotSpeed(),this.mUnitDef.getShotSpeed(),this.mNextDef.getShotSpeed(),"icon_rate");
            if(this.mUnitDef.getConstructionCoins() > 0)
            {
               createFillBar(DCTextMng.getText(627),this.mMaxDef.getConstructionCoins(),this.mUnitDef.getConstructionCoins(),this.mNextDef.getConstructionCoins(),"icon_bag_coins");
            }
            else
            {
               createFillBar(DCTextMng.getText(627),this.mMaxDef.getConstructionMineral(),this.mUnitDef.getConstructionMineral(),this.mNextDef.getConstructionMineral(),"icon_bag_minerals");
            }
            createFillBar(DCTextMng.getText(54),this.mMaxDef.getConstructionTime(),this.mUnitDef.getConstructionTime(),this.mNextDef.getConstructionTime(),"icon_clock",1);
         }
         else
         {
            createFillBar(DCTextMng.getText(543),this.mMaxDef.getMaxEnergy(),this.mNextDef.getMaxEnergy(),0,"icon_health");
            if(this.mUnitDef.getShotDamage() > 0)
            {
               dmgBar = createFillBar(DCTextMng.getText(539),this.mMaxDef.getShotDamage(),this.mNextDef.getShotDamage(),0,"icon_damage");
               if(this.mUnitDef.getShotBurstLength() > 1)
               {
                  (field = dmgBar.getContentAsETextField("text_value")).setText(String(this.mNextDef.getShotDamage()) + " X" + String(this.mNextDef.getShotBurstLength()));
               }
            }
            else
            {
               createFillBar(DCTextMng.getText(712),-this.mMaxDef.getShotDamage(),-this.mNextDef.getShotDamage(),0,"icon_heal");
            }
            createFillBar(DCTextMng.getText(552),this.mMaxDef.getSpeed(),this.mNextDef.getSpeed(),0,"icon_speed");
            createFillBar(DCTextMng.getText(550),this.mMaxDef.getShotDistance(),this.mNextDef.getShotDistance(),0,"icon_range");
            createFillBar(DCTextMng.getText(545),this.mMaxDef.getShotSpeed(),this.mNextDef.getShotSpeed(),0,"icon_rate");
            if(this.mUnitDef.getConstructionCoins() > 0)
            {
               createFillBar(DCTextMng.getText(627),this.mMaxDef.getConstructionCoins(),this.mNextDef.getConstructionCoins(),0,"icon_bag_coins");
            }
            else
            {
               createFillBar(DCTextMng.getText(627),this.mMaxDef.getConstructionMineral(),this.mNextDef.getConstructionMineral(),0,"icon_bag_minerals");
            }
            createFillBar(DCTextMng.getText(54),this.mMaxDef.getConstructionTime(),this.mNextDef.getConstructionTime(),0,"icon_clock",1);
         }
         var doNormalDistribution:Boolean = true;
         if(this.mNextDef.shotEffectsNeedsToShowInfo())
         {
            doNormalDistribution = false;
            layoutFactory = mViewFactory.getLayoutAreaFactory("SpecialInfoBox");
            specialContainer = mViewFactory.getESpriteContainer();
            itemsContainer = mViewFactory.getESpriteContainer();
            offset = 0;
            mInfoBox.eAddChild(specialContainer);
            mInfoBox.setContent("SpecialInfo",specialContainer);
            specialContainer.setLayoutArea(layoutFactory.getContainerLayoutArea());
            img = mViewFactory.getEImage("generic_box",mSkinSku,false,layoutFactory.getArea("area_info"));
            specialContainer.eAddChild(img);
            specialContainer.setContent("background",img);
            field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_body_2");
            specialContainer.eAddChild(field);
            specialContainer.setContent("text",field);
            field.setText(this.mNextDef.getTextSpecial());
            specialContainer.eAddChild(itemsContainer);
            specialContainer.setContent("specialItemsContainer",itemsContainer);
            if(this.mNextDef.shotEffectsBurnIsOn())
            {
               item = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_clock",DCTextMng.getText(4096) + " " + GameConstants.getTimeTextFromMs(this.mNextDef.shotEffectsGetBurnMaxDuration()),mSkinSku,"text_body_2");
               itemsContainer.eAddChild(item);
               itemsContainer.setContent("specialItem1",item);
               item.logicLeft = 0;
               offset += item.width;
               item = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_flame",this.mNextDef.shotEffectsGetBurnMinTemperature() + " - " + this.mNextDef.shotEffectsGetBurnMaxTemperature(),mSkinSku,"text_body_2");
               itemsContainer.eAddChild(item);
               itemsContainer.setContent("specialItem2",item);
               item.logicLeft = offset;
               itemsContainer.layoutApplyTransformations(layoutFactory.getArea("container_icon_text_xs"));
            }
            (barsArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(mInfoArea)).height = mInfoArea.height - specialContainer.getLogicHeight();
            mViewFactory.distributeSpritesInArea(barsArea,mFillBars,1,1,1,mFillBars.length,true);
            this.mFillBars.push(specialContainer);
            specialContainer.x = barsArea.x;
            specialContainer.y = barsArea.y + barsArea.height;
         }
         if(doNormalDistribution)
         {
            mViewFactory.distributeSpritesInArea(mInfoArea,mFillBars,1,1,1,mFillBars.length,true);
         }
      }
      
      override protected function setupRequirements() : void
      {
         var enoughLevel:* = false;
         var layoutFactory:ELayoutAreaFactory = null;
         var text:String = null;
         var box:ESpriteContainer = null;
         var previousDef:ShipDef = null;
         var itemBox:ESpriteContainer = null;
         var itemNeeded:ItemObject = null;
         var iconName:String = null;
         var img:EImage = null;
         var field:ETextField = null;
         super.setupRequirements();
         var neededLevel:int = this.mNextDef.getUnlockHQUpgradeIdRequired();
         var textProp:String = "text_title_0";
         var offset:Number = 0;
         if(this.mNextDef.needsItemForUnlocking())
         {
            box = new ESpriteContainer();
            neededLevel = (previousDef = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(this.mNextDef.mSku,this.mNextDef.getUpgradeId() - 1)).getUnlockHQUpgradeIdRequired();
            enoughLevel = InstanceMng.getWorld().itemsGetLabLevel() >= neededLevel;
            if(!enoughLevel)
            {
               textProp = "text_negative";
            }
            text = DCTextMng.replaceParameters(136,[neededLevel + 1 + ""]);
            itemBox = mViewFactory.getContentIconWithTextVertical("ContainerItemVerticalL",getBuildingIcon("labs_001_001",neededLevel),text,mSkinSku,textProp,true);
            mViewFactory.readjustContentIconWithTextVertical(itemBox);
            box.eAddChild(itemBox);
            box.setContent("lab",itemBox);
            itemBox.logicLeft = 0;
            offset += itemBox.width;
            enoughLevel = (itemNeeded = InstanceMng.getItemsMng().getItemObjectBySku(this.mNextDef.getUnlockItemSkuRequired())) != null && itemNeeded.quantity > 0;
            textProp = "text_title_0";
            if(!enoughLevel)
            {
               textProp = "text_negative";
            }
            itemBox = mViewFactory.getContentIconWithTextVertical("ContainerItemVerticalL",itemNeeded.mDef.getAssetId(),"x1",mSkinSku,textProp,true);
            mViewFactory.readjustContentIconWithTextVertical(itemBox);
            box.eAddChild(itemBox);
            box.setContent("alliance",itemBox);
            itemBox.logicLeft = offset;
            layoutFactory = mViewFactory.getLayoutAreaFactory("ContainerRequirements2Items");
            mRequirementsBox.setContent("RequirementsItemsBox",box);
            mRequirementsBox.eAddChild(box);
            box.layoutApplyTransformations(layoutFactory.getArea("icon_xxl"));
         }
         else
         {
            layoutFactory = mViewFactory.getLayoutAreaFactory("ContainerRequirements");
            if(this.mGameUnit.mIsUnlocked)
            {
               enoughLevel = InstanceMng.getWorld().itemsGetLabLevel() >= neededLevel;
               iconName = getBuildingIcon("labs_001_001",neededLevel);
               text = DCTextMng.replaceParameters(596,[""]);
            }
            else
            {
               enoughLevel = InstanceMng.getWorld().itemsGetHeadquarters().mDef.getUpgradeId() >= neededLevel;
               iconName = getBuildingIcon("wonders_headquarters",neededLevel);
               text = DCTextMng.getText(771) + "\n" + DCTextMng.replaceParameters(136,[""]);
            }
            textProp = "text_title_0";
            if(!enoughLevel)
            {
               textProp = "text_negative";
            }
            img = mViewFactory.getEImage(iconName,mSkinSku,true,layoutFactory.getArea("icon_xxl"));
            mRequirementsBox.eAddChild(img);
            mRequirementsBox.setContent("requirements_item",img);
            field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_building"),"text_subheader_1");
            mRequirementsBox.eAddChild(field);
            field.setText(text);
            mRequirementsBox.setContent("requirementes_desc",field);
            field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_level"),textProp);
            mRequirementsBox.eAddChild(field);
            mRequirementsBox.setContent("requirements_level",field);
            field.setText(neededLevel + 1 + "");
         }
      }
      
      private function setupBackButton() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupLayoutLabInfo");
         var button:EButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(81),0,"btn_back_bkg","btn_back",mSkinSku,"Inside");
         button.layoutApplyTransformations(layoutFactory.getArea("btn_back"));
         setContent("ButtonBack",button);
         eAddChild(button);
         button.eAddEventListener("click",this.onBack);
      }
      
      override protected function getCostTime() : Number
      {
         if(!this.mGameUnit.mIsUnlocked)
         {
            return this.mUnitDef.getCostTime();
         }
         if(this.getIsUpgrading())
         {
            return this.getUpgradingUnit().getNextDef().getCostTime();
         }
         return this.mNextDef.getCostTime();
      }
      
      override protected function getCostCoins() : Number
      {
         if(!this.mGameUnit.mIsUnlocked)
         {
            return this.mUnitDef.getCostCoins();
         }
         return this.mNextDef.getCostCoins();
      }
      
      override protected function getCostMinerals() : Number
      {
         if(!this.mGameUnit.mIsUnlocked)
         {
            return this.mUnitDef.getCostMineral();
         }
         return this.mNextDef.getCostMineral();
      }
      
      override protected function getCostItems() : Array
      {
         if(!this.mGameUnit.mIsUnlocked)
         {
            return this.mUnitDef.getUpgradeItemsNeeded();
         }
         return this.mNextDef.getUpgradeItemsNeeded();
      }
      
      override protected function getIsUnlocking() : Boolean
      {
         return !this.mGameUnit.mIsUnlocked && this.getUnlockingUnit() == this.mGameUnit;
      }
      
      private function getUpgradingUnit() : GameUnit
      {
         return InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUpgradingUnit();
      }
      
      private function getUnlockingUnit() : GameUnit
      {
         return InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUnlockingUnit();
      }
      
      override protected function getIsUpgrading() : Boolean
      {
         if(this.mGameUnit != null)
         {
            return this.getUpgradingUnit() == this.mGameUnit;
         }
         return false;
      }
      
      override protected function getIsUnlocked() : Boolean
      {
         if(this.mGameUnit != null)
         {
            return this.mGameUnit.mIsUnlocked;
         }
         return false;
      }
      
      override protected function getUnitImageName() : String
      {
         return this.mNextDef.getIcon();
      }
      
      override public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         this.mNextDef = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(this.mUnitDef.mSku,id);
         destroyComponents();
         super.setup(null);
         mTabsHeaderView.setPageId(id);
      }
      
      override protected function printTimer() : void
      {
         var upgradingUnit:GameUnit = this.mGameUnit;
         var timerField:ETextField = mUpgradingBox.getContentAsETextField("timer");
         var textToPrint:String = DCTextMng.convertTimeToStringColon(upgradingUnit.mTimeLeft,true);
         timerField.setText(textToPrint);
         var fillBar:EFillBar;
         (fillBar = mUpgradingBox.getContent("fillBar") as EFillBar).setValue(upgradingUnit.getNextDef().getCostTime() - upgradingUnit.mTimeLeft);
      }
      
      override protected function getIcon() : String
      {
         if(!this.mGameUnit.mIsUnlocked)
         {
            return this.mUnitDef.getIcon();
         }
         if(this.getIsUpgrading())
         {
            return this.getUpgradingUnit().getNextDef().getIcon();
         }
         return this.mNextDef.getIcon();
      }
      
      override protected function getPayButtonValue() : Number
      {
         var transaction:Transaction = null;
         var upgradingUnit:GameUnit = null;
         var chips:Number = 0;
         if(!this.mGameUnit.mIsUnlocked)
         {
            transaction = InstanceMng.getRuleMng().getTransactionSpeedUp(this.mUnitDef,this.cloneEvent());
         }
         else if(this.getIsUpgrading())
         {
            upgradingUnit = this.getUpgradingUnit();
            transaction = InstanceMng.getRuleMng().getTransactionSpeedUpUpgradeUnit(upgradingUnit.mDef.mSku);
         }
         else
         {
            transaction = InstanceMng.getRuleMng().getTransactionSpeedUpUpgradeUnitByRange(this.mUnitDef,this.mNextDef,true);
         }
         if(transaction != null)
         {
            chips = Math.abs(transaction.getTransCash());
         }
         return chips;
      }
      
      override protected function getName() : String
      {
         return this.mUnitDef.getNameToDisplay();
      }
      
      override protected function getDescription() : String
      {
         return this.mUnitDef.getDescToDisplay();
      }
      
      override protected function getDiscountText() : String
      {
         var percentage:Number = NaN;
         var dif:Number = this.mNextDef.getUpgradeId() - this.mUnitDef.getUpgradeId();
         percentage = (dif - 1) * InstanceMng.getSettingsDefMng().getMinDiscountUpgrade();
         if(percentage > InstanceMng.getSettingsDefMng().getMaxDiscountUpgrade())
         {
            percentage = InstanceMng.getSettingsDefMng().getMaxDiscountUpgrade();
         }
         return DCTextMng.replaceParameters(1086,["-" + percentage]);
      }
      
      override protected function getRealPriceText() : String
      {
         var upgradeTrans:Transaction = InstanceMng.getRuleMng().getTransactionSpeedUpUpgradeUnitByRange(this.mUnitDef,this.mNextDef,false);
         var cash:Number = 0;
         if(upgradeTrans != null)
         {
            cash = Math.abs(upgradeTrans.getTransCash());
         }
         return cash.toString();
      }
      
      private function checkUnitUnlockable() : Boolean
      {
         var notificationsMng:NotificationsMng = null;
         var notification:Notification = null;
         if(!this.mGameUnit.mIsUnlocked && InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUnlockingUnit() != null)
         {
            notificationsMng = InstanceMng.getNotificationsMng();
            notification = notificationsMng.createNotificationOnlyOneUnitCanBeActivatedSimultaneously();
            notificationsMng.guiOpenNotificationMessage(notification,false);
            return false;
         }
         return true;
      }
      
      override public function startUpgradeActivate(transaction:Transaction) : void
      {
         if(transaction.getTransHasBeenPerformed() || transaction.performAllTransactions())
         {
            this.mGameUnit.startUpgrade(transaction);
            this.setPageId(null,this.mGameUnit.getNextDef().getUpgradeId());
            this.mIsUnlocking = this.getIsUnlocking();
            this.mIsUpgrading = this.getIsUpgrading();
         }
      }
      
      override protected function reload() : void
      {
         this.setPageId(null,this.mGameUnit.getNextDef().getUpgradeId());
         this.mIsUnlocking = this.getIsUnlocking();
         this.mIsUpgrading = this.getIsUpgrading();
         setTabProperties();
      }
      
      override protected function getUpgradingBoxTitle() : String
      {
         var text:String = null;
         if(this.getIsUpgrading())
         {
            text = DCTextMng.replaceParameters(602,[this.mUnitDef.getUpgradeId() + 2 + ""]);
         }
         else
         {
            text = DCTextMng.getText(164);
         }
         return text;
      }
      
      override protected function getTabProp(id:int) : String
      {
         if(id < this.mNextDef.getUpgradeId() && this.mGameUnit.mIsUnlocked)
         {
            return "old_tab";
         }
         return null;
      }
      
      override protected function checkUpgradeOrActivateEnded() : Boolean
      {
         if((this.mIsUnlocking || this.getIsUpgrading()) && this.mGameUnit.mTimeLeft <= 0)
         {
            return true;
         }
         return false;
      }
      
      override protected function getPayChipsValue() : Number
      {
         return this.getPayButtonValue();
      }
      
      private function onBack(e:EEvent) : void
      {
         mPopupUpgrade.notify({"cmd":"NotifyLoadUnitsSelection"});
      }
      
      override protected function onCancelUpgradeActivate(e:EEvent) : void
      {
         var gameUnit:GameUnit = null;
         if(this.getIsUpgrading())
         {
            gameUnit = this.getUpgradingUnit();
         }
         else if(this.getIsUnlocking())
         {
            gameUnit = this.getUnlockingUnit();
         }
         InstanceMng.getGameUnitMngController().getGameUnitMngOwner().cancelCurrentAction(gameUnit);
         mPopupUpgrade.notify({
            "cmd":"NotifyUnitSelected",
            "unit":this.mGameUnit
         });
      }
      
      override protected function onAccelerateUpgradeActivate(e:EEvent) : void
      {
         var transaction:Transaction = null;
         var event:Object = this.cloneEvent();
         var upgradingUnit:GameUnit = this.getUpgradingUnit();
         if(this.getIsUpgrading())
         {
            event.itemDef = upgradingUnit.mDef;
            event.nextDef = upgradingUnit.getNextDef();
            transaction = InstanceMng.getRuleMng().getTransactionSpeedUpUpgradeUnit(event.itemDef.mSku);
            event.unlocking = false;
         }
         else
         {
            transaction = InstanceMng.getRuleMng().getTransactionSpeedUp(this.mUnitDef,event);
            event.unlocking = true;
            event.itemDef = this.mUnitDef;
            event.nextDef = this.mUnitDef;
         }
         event.accelerate = true;
         event.transaction = transaction;
         event.popup = mPopupUpgrade;
         event.isInfo = true;
         event.unit = this.mGameUnit;
         event.button = "EventYesButtonPressed";
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
      }
      
      override protected function onInstantUpgradeActivate(e:EEvent) : void
      {
         var transaction:Transaction = null;
         var event:Object = this.cloneEvent();
         if(this.checkUnitUnlockable() == false)
         {
            return;
         }
         if(this.mGameUnit.mIsUnlocked)
         {
            transaction = InstanceMng.getRuleMng().getTransactionSpeedUpUpgradeUnitByRange(this.mUnitDef,this.mNextDef,true);
            event.unlocking = false;
         }
         else
         {
            transaction = InstanceMng.getRuleMng().getTransactionSpeedUp(this.mUnitDef,event);
            event.unlocking = true;
         }
         event.transaction = transaction;
         event.itemDef = this.mUnitDef;
         event.nextDef = this.mNextDef;
         event.popup = mPopupUpgrade;
         event.isInfo = true;
         event.unit = this.mGameUnit;
         event.accelerate = false;
         event.button = "EventYesButtonPressed";
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
      }
      
      override protected function onStartUpgradeActivate(e:EEvent) : void
      {
         var event:Object = this.cloneEvent();
         if(this.checkUnitUnlockable() == false)
         {
            return;
         }
         var transaction:Transaction = InstanceMng.getRuleMng().getTransactionRequirements(event,this.mNextDef);
         transaction.setCloseOpenedPopups(false);
         event.transaction = transaction;
         event.itemDef = this.mNextDef;
         event.phase = "OUT";
         event.popup = mPopupUpgrade;
         event.sendResponseTo = InstanceMng.getGUIControllerPlanet();
         event.isInfo = true;
         event.button = "EVENT_BUTTON_RIGHT_PRESSED";
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
      }
      
      private function cloneEvent() : Object
      {
         return EUtils.cloneObject(mPopupUpgrade.getEvent());
      }
   }
}
