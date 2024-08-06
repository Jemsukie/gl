package com.dchoc.game.eview.popups.upgrade
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.map.MapViewSolarSystem;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
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
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   
   public class UpgradeBodyInfoWIO extends UpgradeBodyInfo
   {
      
      private static const DELAY_BEFORE_OPENING_OFFER_POPUPS:int = 1000;
       
      
      private var mWIO:WorldItemObject;
      
      private var mDef:WorldItemDef;
      
      private var mNextDef:WorldItemDef;
      
      private var mMaxDef:WorldItemDef;
      
      private var mIsHigherInfo:Boolean;
      
      private var mIsUpgrading:Boolean;
      
      private var mIsUnlocking:Boolean;
      
      private var mPricesList:Vector.<Number>;
      
      private var mPricesDiscountList:Vector.<Number>;
      
      private var mSetTimeOutId:int;
      
      private var mCurrentPlanet:Planet;
      
      public function UpgradeBodyInfoWIO(popupUpgrade:EPopupUpgrade, viewFactory:ViewFactory, skinSku:String)
      {
         super(popupUpgrade,viewFactory,skinSku);
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.clearOfferInterval();
      }
      
      override public function setup(info:*) : void
      {
         this.mCurrentPlanet = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getCurrentPlanet();
         if(info != null)
         {
            if(info is WorldItemDef)
            {
               this.mDef = info as WorldItemDef;
               this.mNextDef = this.mDef;
               this.mMaxDef = this.mDef.getMaxDef();
            }
            else
            {
               this.mWIO = info as WorldItemObject;
               this.mDef = this.mWIO.mDef;
               this.mMaxDef = this.mDef.getMaxDef();
               if(this.mDef.getUpgradeId() == this.mMaxDef.getUpgradeId())
               {
                  this.mNextDef = this.mDef;
               }
               else
               {
                  this.mNextDef = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId(this.mDef.mSku,this.mDef.getUpgradeId() + 1);
               }
            }
            createTabs(this.mMaxDef.getUpgradeId() + 1);
            this.getPricesList();
            if(this.getIsUnlocking() || this.mWIO == null)
            {
               this.setPageId(null,0);
            }
            else
            {
               this.setPageId(null,this.mNextDef.getUpgradeId());
            }
         }
      }
      
      override protected function setupBottom() : void
      {
         var alertText:String = null;
         var alertIcon:String = null;
         var align:int = 0;
         var upgrade:int = 0;
         var levels:int = 0;
         var noDiscount:* = false;
         if(mBottomBoxes != null)
         {
            mBottomBoxes = null;
         }
         mBottomBoxes = [];
         var setRequirements:Boolean = false;
         var setCost:Boolean = false;
         var setChips:Boolean = false;
         var setDiscount:Boolean = false;
         var setDescription:Boolean = false;
         if(mPopupUpgrade.getEvent()["isLocked"])
         {
            mPopupUpgrade.setTitleText(DCTextMng.getText(676));
            this.setupUnlockDescription();
            align = 1;
         }
         else if(this.getIsUnlocking())
         {
            mPopupUpgrade.setTitleText(DCTextMng.getText(676));
            setupUpgradingBox();
            align = 1;
         }
         else if(this.mNextDef.getUpgradeId() > this.mDef.getUpgradeId())
         {
            mPopupUpgrade.setTitleText(DCTextMng.getText(679));
            if(this.getIsUpgrading())
            {
               setupUpgradingBox();
               align = 1;
            }
            else
            {
               setRequirements = true;
               upgrade = this.mNextDef.getUpgradeId();
               levels = upgrade - this.mDef.getUpgradeId();
               noDiscount = this.mPricesDiscountList[upgrade] == this.mPricesList[upgrade];
               if(levels == 1)
               {
                  setCost = true;
                  setChips = true;
               }
               else
               {
                  if(noDiscount)
                  {
                     setChips = true;
                  }
                  else
                  {
                     setDiscount = true;
                  }
                  setDescription = true;
               }
               align = 0;
            }
         }
         else
         {
            if(this.mDef.getUpgradeId() == this.mMaxDef.getUpgradeId())
            {
               alertText = DCTextMng.getText(590);
            }
            else
            {
               alertText = DCTextMng.getText(678);
            }
            alertIcon = "icon_check";
            align = 1;
         }
         if(this.mDef.isAWall())
         {
            setChips = false;
            setDiscount = false;
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
         }
         if(setDescription)
         {
            setupDescriptionBox();
         }
         mViewFactory.distributeSpritesInArea(mBottomArea,mBottomBoxes,align,1,-1,1,true);
      }
      
      private function setupUnlockDescription() : void
      {
         var missionId:String = this.mDef.getUnlockConditionParam();
         var mission:DCTarget = InstanceMng.getTargetMng().getTargetById(missionId);
         var container:ESpriteContainer = new ESpriteContainer();
         var layoutFactory:ELayoutAreaFactory;
         var area:ELayoutArea = (layoutFactory = mViewFactory.getLayoutAreaFactory("ContainerUnlock")).getArea("area_upgrade_units");
         var img:EImage = mViewFactory.getEImage("box_simple",mSkinSku,false,area);
         container.eAddChild(img);
         container.setContent("bottomBkg",img);
         img.applySkinProp(mSkinSku,"color_blue_box");
         var field:ETextField;
         (field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_subheader")).setText(DCTextMng.getText(431));
         container.eAddChild(field);
         container.setContent("title",field);
         var tid:String = mission.getDef().getMiniTargetBody(0);
         (field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_info"),"text_subheader")).setText(DCTextMng.getText(TextIDs[tid]));
         container.eAddChild(field);
         container.setContent("text",field);
         area = layoutFactory.getArea("btn_unlock");
         var button:EButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(434),area.width,"btn_social");
         container.eAddChild(button);
         container.setContent("Button",button);
         button.eAddEventListener("click",this.onUnlockBuilding);
         area.centerContent(button);
         setContent("UnlockReason",container);
         eAddChild(container);
         mBottomBoxes.push(container);
      }
      
      override public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         this.mNextDef = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId(this.mDef.mSku,id);
         if(this.mWIO != null)
         {
            this.mDef = this.mWIO.mDef;
         }
         destroyComponents();
         super.setup(null);
         if(mTabsHeaderView != null)
         {
            mTabsHeaderView.setPageId(id);
         }
         this.mIsUpgrading = this.getIsUpgrading();
         this.mIsUnlocking = this.getIsUnlocking();
      }
      
      private function getPricesList() : void
      {
         var count:int = 0;
         var currentLevel:int = 0;
         var nextDef:WorldItemDef = null;
         var i:int = 0;
         if(this.mWIO != null)
         {
            count = this.mMaxDef.getUpgradeId() + 1;
            currentLevel = this.mNextDef.getUpgradeId();
            this.mPricesList = new Vector.<Number>(count,true);
            this.mPricesDiscountList = new Vector.<Number>(count,true);
            for(i = 0; i < count; )
            {
               if(i < currentLevel)
               {
                  this.mPricesList[i] = 0;
                  this.mPricesDiscountList[i] = 0;
               }
               else
               {
                  nextDef = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId(this.mDef.mSku,i);
                  this.mPricesList[i] = Math.abs(InstanceMng.getRuleMng().getTransactionPremiumUpgradeRange(this.mDef,nextDef,this.mWIO,false).getTransCash());
                  this.mPricesDiscountList[i] = Math.abs(InstanceMng.getRuleMng().getTransactionPremiumUpgradeRange(this.mDef,nextDef,this.mWIO,true).getTransCash());
               }
               i++;
            }
         }
      }
      
      private function getCheckIfThereIsDiscount() : Boolean
      {
         var upgrade:int = this.mNextDef.getUpgradeId();
         return this.mPricesDiscountList[upgrade] < this.mPricesList[upgrade];
      }
      
      private function getUpgradeLevelWithDiscount() : int
      {
         var i:* = 0;
         var upgrade:int = this.mNextDef.getUpgradeId();
         var end:int = this.mMaxDef.getUpgradeId() + 1;
         for(i = upgrade; i < end; )
         {
            if(this.mPricesDiscountList[i] < this.mPricesList[i])
            {
               return i;
            }
            i++;
         }
         return -1;
      }
      
      override protected function getFillBars() : void
      {
         var text1:String = null;
         var text2:String = null;
         this.mIsHigherInfo = this.mNextDef.getUpgradeId() > this.mDef.getUpgradeId();
         if(this.mDef.isAMine())
         {
            this.getFillBarsMines();
            mViewFactory.distributeSpritesInArea(mInfoArea,mFillBars,1,1,1,mFillBars.length,true);
            return;
         }
         if(this.mIsHigherInfo)
         {
            text1 = GameConstants.convertNumberToStringUseDecimals(this.mDef.getMaxEnergy());
            text2 = GameConstants.convertNumberToStringUseDecimals(this.mNextDef.getMaxEnergy());
            this.createWIOFillBar(DCTextMng.getText(543),this.mMaxDef.getMaxEnergyProgressBar(),this.mDef.getMaxEnergyProgressBar(),this.mNextDef.getMaxEnergyProgressBar(),"icon_health",text1,text2);
         }
         else
         {
            text1 = GameConstants.convertNumberToStringUseDecimals(this.mNextDef.getMaxEnergy());
            this.createWIOFillBar(DCTextMng.getText(543),this.mMaxDef.getMaxEnergyProgressBar(),this.mNextDef.getMaxEnergyProgressBar(),0,"icon_health",text1);
         }
         switch(this.mDef.getTypeId())
         {
            case 0:
            case 1:
               this.getFillBarResources();
               break;
            case 2:
               this.getFillBarSilos();
               break;
            case 3:
               this.getFillBarShipyards();
               break;
            case 5:
               this.getFillBarsHQ();
               break;
            case 6:
               if(this.mDef.getUnitTypeId() != 5)
               {
                  this.getFillBarsDefenses();
               }
               break;
            case 7:
               this.getFillBarHangars();
               break;
            case 8:
               this.getFillBarBunkers();
         }
         mViewFactory.distributeSpritesInArea(mInfoArea,mFillBars,1,1,1,mFillBars.length,true);
      }
      
      private function getFillBarsDefenses() : void
      {
         var maxValue:Number = NaN;
         var currentValue:Number = NaN;
         var nextValue:Number = NaN;
         var field:ETextField = null;
         var text1:String = null;
         var text2:String = null;
         var layoutFactory:ELayoutAreaFactory = null;
         var specialContainer:ESpriteContainer = null;
         var img:EImage = null;
         var itemsContainer:ESpriteContainer = null;
         var offset:Number = NaN;
         var item:ESprite = null;
         if(this.mIsHigherInfo)
         {
            maxValue = this.mMaxDef.getShotDistance();
            currentValue = this.mDef.getShotDistance();
            nextValue = this.mNextDef.getShotDistance();
            text1 = this.mDef.getShotDistance().toString();
            text2 = this.mNextDef.getShotDistance().toString();
            this.createWIOFillBar(DCTextMng.getText(550),maxValue,currentValue,nextValue,"icon_range",text1,text2);
            if(this.mMaxDef.getShotDamage() > 0)
            {
               maxValue = this.mMaxDef.getShotDamage();
               currentValue = this.mDef.getShotDamage();
               nextValue = this.mNextDef.getShotDamage();
               text1 = DCTextMng.convertNumberToString(this.mDef.getShotDamage(),1,7);
               text2 = DCTextMng.convertNumberToString(this.mNextDef.getShotDamage(),1,7);
               this.createWIOFillBar(DCTextMng.getText(539),maxValue,currentValue,nextValue,"icon_damage",text1,text2);
            }
            maxValue = this.mMaxDef.getShotSpeed();
            currentValue = this.mDef.getShotSpeed();
            nextValue = this.mNextDef.getShotSpeed();
            this.createWIOFillBar(DCTextMng.getText(545),maxValue,currentValue,nextValue,"icon_rate");
         }
         else
         {
            maxValue = this.mMaxDef.getShotDistance();
            currentValue = this.mNextDef.getShotDistance();
            nextValue = 0;
            text1 = DCTextMng.convertNumberToString(this.mNextDef.getShotDistance(),1,7);
            this.createWIOFillBar(DCTextMng.getText(550),maxValue,currentValue,nextValue,"icon_range",text1);
            if(this.mMaxDef.getShotDamage() > 0)
            {
               maxValue = this.mMaxDef.getShotDamage();
               currentValue = this.mNextDef.getShotDamage();
               nextValue = 0;
               text1 = DCTextMng.convertNumberToString(this.mNextDef.getShotDamage(),1,7);
               this.createWIOFillBar(DCTextMng.getText(539),maxValue,currentValue,nextValue,"icon_damage",text1);
            }
            maxValue = this.mMaxDef.getShotSpeed();
            currentValue = this.mNextDef.getShotSpeed();
            nextValue = 0;
            this.createWIOFillBar(DCTextMng.getText(545),maxValue,currentValue,nextValue,"icon_rate");
         }
         if(this.mDef.shotEffectsNeedsToShowInfo())
         {
            layoutFactory = mViewFactory.getLayoutAreaFactory("SpecialInfoBox");
            specialContainer = new ESpriteContainer();
            mInfoBox.eAddChild(specialContainer);
            mInfoBox.setContent("SpecialInfo",specialContainer);
            specialContainer.setLayoutArea(layoutFactory.getContainerLayoutArea());
            img = mViewFactory.getEImage("generic_box",mSkinSku,false,layoutFactory.getArea("area_info"));
            specialContainer.eAddChild(img);
            specialContainer.setContent("background",img);
            field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_body_2");
            specialContainer.eAddChild(field);
            specialContainer.setContent("text",field);
            field.setText(this.mDef.getTextSpecial());
            itemsContainer = new ESpriteContainer();
            specialContainer.eAddChild(itemsContainer);
            specialContainer.setContent("specialItemsContainer",itemsContainer);
            offset = 0;
            if(this.mDef.shotEffectsSlowDownIsOn())
            {
               item = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_clock",GameConstants.getTimeTextFromMs(this.mNextDef.shotEffectsGetSlowDownTime()),mSkinSku,"text_body_2");
               itemsContainer.eAddChild(item);
               itemsContainer.setContent("specialItem1",item);
               item.logicLeft = 0;
               offset += item.width;
               if(this.mNextDef.shotEffectsGetSlowDownSpeedPercent() != 0)
               {
                  item = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_speed",this.getStringFromAbility(this.mNextDef.shotEffectsGetSlowDownSpeedPercent()),mSkinSku,"text_body_2");
                  itemsContainer.eAddChild(item);
                  itemsContainer.setContent("specialItem2",item);
                  item.logicLeft = offset;
                  offset += item.width;
               }
               if(this.mNextDef.shotEffectsGetSlowDownRatePercent())
               {
                  item = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_rate",this.getStringFromAbility(this.mNextDef.shotEffectsGetSlowDownRatePercent()),mSkinSku,"text_body_2");
                  itemsContainer.eAddChild(item);
                  itemsContainer.setContent("specialItem3",item);
                  item.logicLeft = offset;
               }
               itemsContainer.layoutApplyTransformations(layoutFactory.getArea("container_icon_text_xs"));
               mFillBars.push(specialContainer);
            }
         }
      }
      
      private function getFillBarsMines() : void
      {
         var maxValue:Number = NaN;
         var currentValue:Number = NaN;
         var nextValue:Number = NaN;
         var text1:String = null;
         var text2:String = null;
         if(this.mIsHigherInfo)
         {
            maxValue = this.mMaxDef.getShotDamage();
            currentValue = this.mDef.getShotDamage();
            nextValue = this.mNextDef.getShotDamage();
            text1 = DCTextMng.convertNumberToString(this.mDef.getShotDamage(),1,7);
            text2 = DCTextMng.convertNumberToString(this.mNextDef.getShotDamage(),1,7);
            this.createWIOFillBar(DCTextMng.getText(539),maxValue,currentValue,nextValue,"icon_damage",text1,text2);
         }
         else
         {
            maxValue = this.mMaxDef.getShotDamage();
            currentValue = this.mNextDef.getShotDamage();
            nextValue = 0;
            text1 = DCTextMng.convertNumberToString(this.mNextDef.getShotDamage(),1,7);
            this.createWIOFillBar(DCTextMng.getText(539),maxValue,currentValue,nextValue,"icon_damage",text1);
         }
      }
      
      private function getFillBarResources() : void
      {
         var icon1:String = null;
         var icon2:String = null;
         var maxValue:Number = NaN;
         var currentValue:Number = NaN;
         var nextValue:Number = NaN;
         var text1:String = null;
         var text2:String = null;
         switch(this.mDef.mTypeId)
         {
            case 0:
               icon1 = "icon_coins";
               icon2 = "icon_bag_coins";
               break;
            case 1:
               icon1 = "icon_minerals";
               icon2 = "icon_bag_minerals";
         }
         if(this.mIsHigherInfo)
         {
            maxValue = this.mMaxDef.getIncomePerMinuteProgressBar();
            currentValue = this.mDef.getIncomePerMinuteProgressBar();
            nextValue = this.mNextDef.getIncomePerMinuteProgressBar();
            text1 = this.mDef.getIncomePerMinute() + "/" + DCTextMng.getText(46);
            text2 = this.mNextDef.getIncomePerMinute() + "/" + DCTextMng.getText(46);
            this.createWIOFillBar(DCTextMng.getText(547),maxValue,currentValue,nextValue,icon1,text1,text2);
            maxValue = this.mMaxDef.getIncomeCapacityProgressBar();
            currentValue = this.mDef.getIncomeCapacityProgressBar();
            nextValue = this.mNextDef.getIncomeCapacityProgressBar();
            text1 = "+" + GameConstants.convertNumberToStringUseDecimals(this.mDef.getIncomeCapacity());
            text2 = "+" + GameConstants.convertNumberToStringUseDecimals(this.mNextDef.getIncomeCapacity());
            this.createWIOFillBar(DCTextMng.getText(548),maxValue,currentValue,nextValue,icon2,text1,text2);
         }
         else
         {
            maxValue = this.mMaxDef.getIncomePerMinuteProgressBar();
            currentValue = this.mNextDef.getIncomePerMinuteProgressBar();
            nextValue = 0;
            text1 = this.mNextDef.getIncomePerMinute() + "/" + DCTextMng.getText(46);
            this.createWIOFillBar(DCTextMng.getText(547),maxValue,currentValue,nextValue,icon1,text1);
            maxValue = this.mMaxDef.getIncomeCapacityProgressBar();
            currentValue = this.mNextDef.getIncomeCapacityProgressBar();
            nextValue = 0;
            text1 = "+" + GameConstants.convertNumberToStringUseDecimals(this.mNextDef.getIncomeCapacity());
            this.createWIOFillBar(DCTextMng.getText(548),maxValue,currentValue,nextValue,icon2,text1);
         }
      }
      
      private function getFillBarSilos() : void
      {
         var icon1:String = null;
         var maxValue:Number = NaN;
         var currentValue:Number = NaN;
         var nextValue:Number = NaN;
         var text1:String = null;
         if(this.mDef.getCoinsStorage() > 0)
         {
            icon1 = "icon_bag_coins";
         }
         else
         {
            icon1 = "icon_bag_minerals";
         }
         var text2:String = "";
         if(this.mIsHigherInfo)
         {
            maxValue = Math.max(this.mMaxDef.getCoinsStorageProgressBar(),this.mMaxDef.getMineralsStorageProgressBar());
            currentValue = Math.max(this.mDef.getCoinsStorageProgressBar(),this.mDef.getMineralsStorageProgressBar());
            nextValue = Math.max(this.mNextDef.getCoinsStorageProgressBar(),this.mNextDef.getMineralsStorageProgressBar());
            text1 = "+" + GameConstants.convertNumberToStringUseDecimals(Math.max(this.mDef.getCoinsStorage(),this.mDef.getMineralsStorage()));
            text2 = "+" + GameConstants.convertNumberToStringUseDecimals(Math.max(this.mNextDef.getCoinsStorage(),this.mNextDef.getMineralsStorage()));
         }
         else
         {
            maxValue = Math.max(this.mMaxDef.getCoinsStorageProgressBar(),this.mMaxDef.getMineralsStorageProgressBar());
            currentValue = Math.max(this.mNextDef.getCoinsStorageProgressBar(),this.mNextDef.getMineralsStorageProgressBar());
            nextValue = 0;
            text1 = "+" + GameConstants.convertNumberToStringUseDecimals(Math.max(this.mNextDef.getCoinsStorage(),this.mNextDef.getMineralsStorage()));
         }
         this.createWIOFillBar(DCTextMng.getText(549),maxValue,currentValue,nextValue,icon1,text1,text2);
      }
      
      private function getFillBarHangars() : void
      {
         var maxValue:Number = NaN;
         var currentValue:Number = NaN;
         var nextValue:Number = NaN;
         var text1:String = null;
         var text2:String = null;
         if(this.mIsHigherInfo)
         {
            maxValue = this.mMaxDef.getShipCapacityProgressBar();
            currentValue = this.mDef.getShipCapacityProgressBar();
            nextValue = this.mNextDef.getShipCapacityProgressBar();
            text1 = GameConstants.convertNumberToStringUseDecimals(this.mDef.getShipCapacity());
            text2 = GameConstants.convertNumberToStringUseDecimals(this.mNextDef.getShipCapacity());
            this.createWIOFillBar(DCTextMng.getText(548),maxValue,currentValue,nextValue,"icon_hangar",text1,text2);
         }
         else
         {
            maxValue = this.mMaxDef.getShipCapacityProgressBar();
            currentValue = this.mNextDef.getShipCapacityProgressBar();
            nextValue = 0;
            text1 = GameConstants.convertNumberToStringUseDecimals(this.mNextDef.getShipCapacity());
            this.createWIOFillBar(DCTextMng.getText(548),maxValue,currentValue,nextValue,"icon_hangar",text1,text2);
         }
      }
      
      private function getFillBarBunkers() : void
      {
         var maxValue:Number = NaN;
         var currentValue:Number = NaN;
         var nextValue:Number = NaN;
         var text1:String = null;
         var text2:String = null;
         if(this.mIsHigherInfo)
         {
            maxValue = this.mMaxDef.getShipCapacityProgressBar();
            currentValue = this.mDef.getShipCapacityProgressBar();
            nextValue = this.mNextDef.getShipCapacityProgressBar();
            text1 = GameConstants.convertNumberToStringUseDecimals(this.mDef.getShipCapacity());
            text2 = GameConstants.convertNumberToStringUseDecimals(this.mNextDef.getShipCapacity());
            this.createWIOFillBar(DCTextMng.getText(548),maxValue,currentValue,nextValue,"icon_hangar",text1,text2);
            maxValue = this.mMaxDef.getShotDistance();
            currentValue = this.mDef.getShotDistance();
            nextValue = this.mNextDef.getShotDistance();
            text1 = this.mDef.getShotDistance().toString();
            text2 = this.mNextDef.getShotDistance().toString();
            this.createWIOFillBar(DCTextMng.getText(550),maxValue,currentValue,nextValue,"icon_range",text1,text2);
         }
         else
         {
            maxValue = this.mMaxDef.getShipCapacityProgressBar();
            currentValue = this.mNextDef.getShipCapacityProgressBar();
            nextValue = 0;
            text1 = GameConstants.convertNumberToStringUseDecimals(this.mNextDef.getShipCapacity());
            this.createWIOFillBar(DCTextMng.getText(548),maxValue,currentValue,nextValue,"icon_hangar",text1,text2);
            maxValue = this.mMaxDef.getShotDistance();
            currentValue = this.mNextDef.getShotDistance();
            nextValue = 0;
            text1 = DCTextMng.convertNumberToString(this.mNextDef.getShotDistance(),1,7);
            this.createWIOFillBar(DCTextMng.getText(550),maxValue,currentValue,nextValue,"icon_range",text1);
         }
      }
      
      private function getFillBarShipyards() : void
      {
         var maxValue:Number = NaN;
         var currentValue:Number = NaN;
         var nextValue:Number = NaN;
         var text1:String = null;
         var text2:String = null;
         if(this.mIsHigherInfo)
         {
            maxValue = this.mMaxDef.getSlotsCapacitiesProgressBar();
            currentValue = this.mDef.getSlotsCapacitiesProgressBar();
            nextValue = this.mNextDef.getSlotsCapacitiesProgressBar();
            text1 = GameConstants.convertNumberToStringUseDecimals(this.mDef.getSlotsCapacitiesTotal());
            text2 = GameConstants.convertNumberToStringUseDecimals(this.mNextDef.getSlotsCapacitiesTotal());
         }
         else
         {
            maxValue = this.mMaxDef.getSlotsCapacitiesProgressBar();
            currentValue = this.mNextDef.getSlotsCapacitiesProgressBar();
            nextValue = 0;
            text1 = GameConstants.convertNumberToStringUseDecimals(this.mNextDef.getSlotsCapacitiesTotal());
         }
         this.createWIOFillBar(DCTextMng.getText(548),maxValue,currentValue,nextValue,"icon_slot",text1,text2);
      }
      
      private function getFillBarsHQ() : void
      {
         var offset:Number = NaN;
         var icon1:String = null;
         var maxValue:Number = NaN;
         var currentValue:Number = NaN;
         var nextValue:Number = NaN;
         var text1:String = null;
         var text2:String = "";
         if(this.mIsHigherInfo)
         {
            maxValue = this.mMaxDef.getCoinsStorageProgressBar();
            currentValue = this.mDef.getCoinsStorageProgressBar();
            nextValue = this.mNextDef.getCoinsStorageProgressBar();
            text1 = "+" + GameConstants.convertNumberToStringUseDecimals(this.mDef.getCoinsStorage());
            text2 = "+" + GameConstants.convertNumberToStringUseDecimals(this.mNextDef.getCoinsStorage());
            this.createWIOFillBar(DCTextMng.getText(549),maxValue,currentValue,nextValue,"icon_bag_both",text1,text2);
         }
         else
         {
            maxValue = this.mMaxDef.getCoinsStorageProgressBar();
            currentValue = this.mNextDef.getCoinsStorageProgressBar();
            nextValue = 0;
            text1 = "+" + GameConstants.convertNumberToStringUseDecimals(this.mNextDef.getCoinsStorage());
            this.createWIOFillBar(DCTextMng.getText(549),maxValue,currentValue,nextValue,"icon_bag_both",text1,text2);
         }
         if(InstanceMng.getUpSellingMng().canOfferBeStarted("HQLevelUp"))
         {
            this.mSetTimeOutId = setTimeout(this.openUpSellingOfferPopup,1000);
         }
         else if(InstanceMng.getUserInfoMng().getProfileLogin().getShowOfferNewPayerPromo() && InstanceMng.getNewPayerPromoDefMng().checkOfferForUpgradeHQ(this.mDef.getUpgradeId() + 2))
         {
            this.mSetTimeOutId = setTimeout(this.openOffersPopup,1000);
         }
         var container:ESpriteContainer = new ESpriteContainer();
         var buildingsLists:Array = InstanceMng.getRuleMng().getUpgradeHqLists(this.mNextDef.getUpgradeId() - 1);
         var unitsLists:String = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUpgradeHqLists(this.mNextDef.getUpgradeId() - 1);
         var buildMore:String = (buildMore = String(buildingsLists[0])).substr(0,buildMore.length - 1);
         var upgradeMore:String = (upgradeMore = String(buildingsLists[1])).substr(0,upgradeMore.length - 1);
         var content:ESpriteContainer = this.getHQUpgradesListBoxes(DCTextMng.getText(123),buildMore);
         container.eAddChild(content);
         container.setContent("buildMore",content);
         offset = content.width + 5;
         content = this.getHQUpgradesListBoxes(DCTextMng.getText(124),upgradeMore);
         container.eAddChild(content);
         container.setContent("upgradeMore",content);
         content.logicLeft = offset;
         mInfoBox.eAddChild(container);
         mInfoBox.setContent("hqInfo",container);
         mFillBars.push(container);
      }
      
      private function getHQUpgradesListBoxes(title:String, list:String) : ESpriteContainer
      {
         var i:int = 0;
         var container:ESpriteContainer = new ESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("HQInfoBox");
         var img:EImage = mViewFactory.getEImage("generic_box",mSkinSku,false,layoutFactory.getArea("area"));
         container.eAddChild(img);
         container.setContent("background",img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         container.eAddChild(field);
         container.setContent("text_title",field);
         field.setText(title);
         field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text"),"text_body_2");
         container.eAddChild(field);
         container.setContent("text",field);
         var listArr:Array;
         var count:int = int((listArr = list.split(",")).length);
         list = "";
         for(i = 0; i < count; )
         {
            list += listArr[i] + "\n";
            i++;
         }
         field.setText(list);
         return container;
      }
      
      private function createWIOFillBar(text:String, maxValue:Number, currentValue:Number, nextValue:Number, icon:String, text1:String = null, text2:String = null, format:int = 0) : void
      {
         var field:ETextField = null;
         var fillbar:ESpriteContainer = createFillBar(text,maxValue,currentValue,nextValue,icon,format);
         if(text1 != null)
         {
            if((field = fillbar.getContentAsETextField("text_value")) != null)
            {
               field.setText(text1);
            }
         }
         if(text2 != null)
         {
            if((field = fillbar.getContentAsETextField("text_revalue")) != null)
            {
               field.setText(text2);
            }
         }
      }
      
      override protected function setupRequirements() : void
      {
         var enoughLevel:* = false;
         var layoutFactory:ELayoutAreaFactory = null;
         var text:* = null;
         var textProp:String = null;
         var iconName:String = null;
         var itemNo:int = 0;
         super.setupRequirements();
         var neededLevel:int = this.mNextDef.getUnlockHQUpgradeIdRequired();
         layoutFactory = mViewFactory.getLayoutAreaFactory("ContainerRequirements");
         iconName = this.getBuildingIcon("wonders_headquarters",neededLevel);
         if(this.mNextDef.isHeadQuarters())
         {
            enoughLevel = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getPlanetsAmount() >= neededLevel;
            text = DCTextMng.replaceParameters(259,[""]);
         }
         else
         {
            enoughLevel = InstanceMng.getWorld().itemsGetHeadquarters().mDef.getUpgradeId() >= neededLevel;
            text = DCTextMng.getText(771) + " ";
            text = DCTextMng.replaceParameters(599,[text]);
         }
         textProp = "text_title_0";
         if(!enoughLevel)
         {
            textProp = "text_negative";
         }
         var img:EImage = mViewFactory.getEImage(iconName,mSkinSku,true,layoutFactory.getArea("icon_xxl"));
         mRequirementsBox.eAddChild(img);
         mRequirementsBox.setContent("requirements_item",img);
         if(mPopupUpgrade.getEvent()["items"])
         {
            itemNo = int(mPopupUpgrade.getEvent()["items"].length);
         }
         else
         {
            itemNo = 1;
         }
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_building"),"text_subheader");
         mRequirementsBox.eAddChild(field);
         field.setText(text);
         mRequirementsBox.setContent("requirementes_desc",field);
         field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_level"),textProp);
         mRequirementsBox.eAddChild(field);
         mRequirementsBox.setContent("requirements_level",field);
         if(this.mNextDef.isHeadQuarters() && neededLevel > 0)
         {
            field.setText(neededLevel + "");
         }
         else
         {
            field.setText(neededLevel + 1 + "");
         }
      }
      
      override protected function getBuildingIcon(sku:String, neededLevel:int) : String
      {
         if(this.mNextDef.isHeadQuarters())
         {
            return "planet_empty";
         }
         return super.getBuildingIcon(sku,neededLevel);
      }
      
      private function getStringFromAbility(value:Number) : String
      {
         var str:String = (value > 0 ? "-" : "") + value.toFixed();
         var dotIndex:int = str.indexOf(".");
         if(dotIndex > -1)
         {
            str = str.replace(".","");
         }
         return str + "%";
      }
      
      override protected function getCostTime() : Number
      {
         if(this.getIsUpgrading())
         {
            return this.mDef.getNextDef().getConstructionTime();
         }
         if(this.getIsUnlocking())
         {
            return this.mDef.getConstructionTime();
         }
         return this.mNextDef.getConstructionTime();
      }
      
      override protected function getCostCoins() : Number
      {
         var t:Transaction = null;
         if(mPopupUpgrade.getEvent()["transaction"] != null)
         {
            t = mPopupUpgrade.getEvent()["transaction"];
            return t.getTransCoins() * -1;
         }
         return 0;
      }
      
      override protected function getCostMinerals() : Number
      {
         var t:Transaction = null;
         if(mPopupUpgrade.getEvent()["transaction"] != null)
         {
            t = mPopupUpgrade.getEvent()["transaction"];
            return t.getTransMinerals() * -1;
         }
         return 0;
      }
      
      override protected function getCostItems() : Array
      {
         if(this.mNextDef != null)
         {
            return this.mNextDef.getUpgradeItemsNeeded();
         }
         return null;
      }
      
      override protected function getUnitImageName() : String
      {
         var suffix:String = null;
         var prefix:String = null;
         var assetId:String = this.mNextDef.getAssetId();
         if(this.mDef.getTypeId() == 6)
         {
            suffix = "_tooltip";
         }
         else
         {
            suffix = "_ready";
         }
         if(this.mDef.isHeadQuarters() && !this.mCurrentPlanet.isCapital())
         {
            prefix = "colony_";
            assetId = this.mNextDef.getAssetIdByKey("colony");
         }
         else
         {
            prefix = "";
         }
         if(this.mNextDef != null)
         {
            return prefix + assetId + suffix;
         }
         return null;
      }
      
      override protected function getIcon() : String
      {
         var suffix:String = null;
         var assetId:String = null;
         var prefix:String = null;
         if(this.getIsUpgrading())
         {
            assetId = this.mDef.getNextDef().getAssetId();
         }
         else
         {
            assetId = this.mDef.getAssetId();
         }
         if(this.mDef.getTypeId() == 6)
         {
            suffix = "_tooltip";
         }
         else
         {
            suffix = "_ready";
         }
         if(this.mDef.isHeadQuarters() && !this.mCurrentPlanet.isCapital())
         {
            prefix = "colony_";
            assetId = this.mDef.getNextDef().getAssetIdByKey("colony");
         }
         else
         {
            prefix = "";
         }
         return prefix + assetId + suffix;
      }
      
      override protected function getPayButtonValue() : Number
      {
         var value:Number = this.getPayChipsValue();
         if(value == 0)
         {
            value = this.getPayMineralValue();
         }
         return value;
      }
      
      override protected function getPayChipsValue() : Number
      {
         var transaction:Transaction = null;
         var items:Vector.<WorldItemObject> = null;
         if(this.getIsUpgrading())
         {
            transaction = InstanceMng.getRuleMng().getTransactionInstantUpgrade(this.cloneEvent());
         }
         else if(this.getIsUnlocking())
         {
            transaction = InstanceMng.getRuleMng().getTransactionInstantBuild(this.mWIO,this.cloneEvent());
         }
         else
         {
            items = mPopupUpgrade.getEvent().items;
            transaction = InstanceMng.getRuleMng().getTransactionPremiumUpgradeRange(this.mDef,this.mNextDef,this.mWIO,true,!!items ? int(items.length) : 1);
         }
         var chips:Number = 0;
         if(transaction != null)
         {
            chips = Math.abs(transaction.getTransCash());
         }
         return chips;
      }
      
      override protected function getPayMineralValue() : Number
      {
         var mineral:Number = 0;
         var transaction:Transaction = this.getInstantActionTransaction();
         if(transaction != null)
         {
            mineral = Math.abs(transaction.getTransMinerals());
         }
         return mineral;
      }
      
      private function getInstantActionTransaction() : Transaction
      {
         var transaction:Transaction = null;
         if(this.getIsUpgrading())
         {
            transaction = InstanceMng.getRuleMng().getTransactionInstantUpgrade(mPopupUpgrade.getEvent());
         }
         else if(this.getIsUnlocking())
         {
            transaction = InstanceMng.getRuleMng().getTransactionInstantBuild(this.mWIO,mPopupUpgrade.getEvent());
         }
         return transaction;
      }
      
      override protected function getName() : String
      {
         if(this.mNextDef != null)
         {
            return this.mNextDef.getNameToDisplay();
         }
         return null;
      }
      
      override protected function getDescription() : String
      {
         var upgrade:int = 0;
         var percentage:Number = NaN;
         var dif:Number = NaN;
         if(this.getCheckIfThereIsDiscount())
         {
            return DCTextMng.replaceParameters(681,[this.getName()]);
         }
         upgrade = this.getUpgradeLevelWithDiscount();
         if(upgrade == -1)
         {
            return DCTextMng.replaceParameters(681,[this.getName()]);
         }
         dif = upgrade - this.mDef.getUpgradeId();
         percentage = (dif - 1) * InstanceMng.getSettingsDefMng().getMinDiscountUpgrade();
         if(percentage > InstanceMng.getSettingsDefMng().getMaxDiscountUpgrade())
         {
            percentage = InstanceMng.getSettingsDefMng().getMaxDiscountUpgrade();
         }
         return DCTextMng.replaceParameters(680,["-" + percentage,"" + (upgrade + 1)]);
      }
      
      override protected function getDiscountText() : String
      {
         var percentage:Number = NaN;
         var dif:Number = this.mNextDef.getUpgradeId() - this.mDef.getUpgradeId();
         percentage = (dif - 1) * InstanceMng.getSettingsDefMng().getMinDiscountUpgrade();
         if(percentage > InstanceMng.getSettingsDefMng().getMaxDiscountUpgrade())
         {
            percentage = InstanceMng.getSettingsDefMng().getMaxDiscountUpgrade();
         }
         return DCTextMng.replaceParameters(1086,["-" + percentage]);
      }
      
      override protected function getRealPriceText() : String
      {
         var transaction:Transaction = InstanceMng.getRuleMng().getTransactionPremiumUpgradeRange(this.mDef,this.mNextDef,this.mWIO,false);
         var cash:Number = 0;
         if(transaction != null)
         {
            cash = Math.abs(transaction.getTransCash());
         }
         return cash.toString();
      }
      
      override protected function getTabProp(id:int) : String
      {
         if(id < this.mNextDef.getUpgradeId() && !this.getIsUnlocking())
         {
            return "old_tab";
         }
         return null;
      }
      
      override protected function getIsUpgrading() : Boolean
      {
         if(this.mWIO == null)
         {
            return false;
         }
         return this.mWIO.mDroidLabourId == 1;
      }
      
      override protected function getIsUnlocking() : Boolean
      {
         if(this.mWIO == null)
         {
            return false;
         }
         return this.mWIO.mDroidLabourId == 0;
      }
      
      override protected function printTimer() : void
      {
         var time:Number = this.mWIO.getTimeLeft();
         var timerField:ETextField = mUpgradingBox.getContentAsETextField("timer");
         var textToPrint:String = DCTextMng.convertTimeToStringColon(time,true);
         timerField.setText(textToPrint);
         var fillBar:EFillBar;
         (fillBar = mUpgradingBox.getContent("fillBar") as EFillBar).setValue(this.getCostTime() - time);
      }
      
      override protected function getUpgradingBoxTitle() : String
      {
         var text:String = null;
         if(this.getIsUpgrading())
         {
            text = DCTextMng.replaceParameters(602,[this.mDef.getUpgradeId() + 2 + ""]);
         }
         else
         {
            text = DCTextMng.getText(677);
         }
         return text;
      }
      
      override protected function checkUpgradeOrActivateEnded() : Boolean
      {
         return this.mIsUpgrading && !this.getIsUpgrading() || this.mIsUnlocking && !this.getIsUnlocking();
      }
      
      override protected function reload() : void
      {
         this.setPageId(null,this.mWIO.mDef.getNextDef().getUpgradeId());
         setTabProperties();
      }
      
      override protected function onStartUpgradeActivate(e:EEvent) : void
      {
         var event:Object = null;
         if(this.mWIO != null && this.mWIO.isAllowedToStartUpgrading())
         {
            event = this.cloneEvent();
            event.startUpgrade = true;
            event.item = this.mWIO;
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
         }
      }
      
      override protected function onInstantUpgradeActivate(e:EEvent) : void
      {
         var event:Object = this.cloneEvent();
         var items:Vector.<WorldItemObject> = event["items"];
         var t:Transaction = InstanceMng.getRuleMng().getTransactionPremiumUpgradeRange(this.mDef,this.mNextDef,this.mWIO,true,!!items ? int(items.length) : 1);
         event["button"] = "EventYesButtonPressed";
         event["startUpgrade"] = true;
         event["premiumUpgrade"] = true;
         event["premiumTransaction"] = t;
         event["item"] = this.mWIO;
         event["levelsToUpgrade"] = this.mNextDef.getUpgradeId() - this.mDef.getUpgradeId();
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
      }
      
      override protected function getGreenButtonText() : String
      {
         if(this.getIsUpgrading())
         {
            return DCTextMng.getText(2453);
         }
         return DCTextMng.getText(116);
      }
      
      private function doOpenOfferPopup() : Boolean
      {
         this.clearOfferInterval();
         return InstanceMng.getPopupMng().getPopupBeingShown() == mPopupUpgrade;
      }
      
      private function openUpSellingOfferPopup() : void
      {
         if(this.doOpenOfferPopup())
         {
            InstanceMng.getUpSellingMng().startOffer("HQLevelUp");
         }
      }
      
      private function openOffersPopup() : void
      {
         if(this.doOpenOfferPopup())
         {
            InstanceMng.getGUIController().guiOpenNewPayerPromoPopupFromWIODef(this.mNextDef);
         }
      }
      
      override protected function onCancelUpgradeActivate(e:EEvent) : void
      {
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),InstanceMng.getGUIControllerPlanet().createEventWIOCancelProcess(this.mWIO),true);
      }
      
      override protected function onAccelerateUpgradeActivate(e:EEvent) : void
      {
         var event:Object = InstanceMng.getGUIControllerPlanet().createEventWIOInstantFinish(this.mWIO);
         event["button"] = "EventYesButtonPressed";
         event["phase"] = "OUT";
         event["transaction"] = this.getInstantActionTransaction();
         event["popup"] = mPopupUpgrade;
         event["item"] = this.mWIO;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
         if(mIsTutorial)
         {
            InstanceMng.getUIFacade().closePopup(mPopupUpgrade);
         }
      }
      
      private function onUnlockBuilding(e:EEvent) : void
      {
         var starCoords:DCCoordinate = null;
         var starName:String = null;
         var starId:Number = NaN;
         var starType:int = 0;
         var mapViewSolarSystem:MapViewSolarSystem = null;
         InstanceMng.getGUIControllerPlanet().closeShopBar();
         var uInfo:UserInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
         var capital:Planet = uInfo.getCapital();
         if(uInfo != null && capital != null)
         {
            starCoords = capital.getParentStarCoords();
            starName = capital.getParentStarName();
            starId = capital.getParentStarId();
            starType = capital.getParentStarType();
            if((mapViewSolarSystem = InstanceMng.getMapViewSolarSystem()) != null)
            {
               mapViewSolarSystem.setNPCSkuToHighlight("npc_D");
            }
            InstanceMng.getApplication().goToSolarSystem(starCoords,starName,starId,starType);
         }
      }
      
      private function clearOfferInterval() : void
      {
         if(this.mSetTimeOutId > -1)
         {
            clearInterval(this.mSetTimeOutId);
            this.mSetTimeOutId = -1;
         }
      }
      
      private function cloneEvent() : Object
      {
         return EUtils.cloneObject(mPopupUpgrade.getEvent());
      }
   }
}
