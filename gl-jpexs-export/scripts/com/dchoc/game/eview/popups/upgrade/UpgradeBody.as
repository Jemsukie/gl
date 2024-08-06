package com.dchoc.game.eview.popups.upgrade
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.EFillBar;
   import flash.display.DisplayObjectContainer;
   
   public class UpgradeBody extends ESpriteContainer
   {
      
      public static const FOOTER_TIMER:String = "timer";
      
      public static const FILLBAR:String = "fillBar";
      
      public static const BUTTON_INSTANT_UPGRADE:String = "ButtonInstantUpgrade";
      
      public static const BUTTON_INSTANT_UPGRADE_MINERALS:String = "ButtonInstantUpgradeMinerals";
      
      public static const BUTTON_CANCEL:String = "ButtonCancel";
      
      protected static const UPGRADE_BOX:String = "upgradeBox";
       
      
      protected var mViewFactory:ViewFactory;
      
      protected var mSkinSku:String;
      
      protected var mPopupUpgrade:EPopupUpgrade;
      
      protected var mUpgradingBox:ESpriteContainer;
      
      private var mOldChipsValue:Number;
      
      protected var mIsTutorial:Boolean;
      
      public function UpgradeBody(popupUpgrade:EPopupUpgrade, viewFactory:ViewFactory, skinSku:String)
      {
         super();
         this.mSkinSku = skinSku;
         this.mViewFactory = viewFactory;
         this.mPopupUpgrade = popupUpgrade;
         this.mIsTutorial = InstanceMng.getFlowStatePlanet().isTutorialRunning();
      }
      
      protected function setupUpgradingBox() : void
      {
         var button:EButton = null;
         if(this.mUpgradingBox == null)
         {
            this.mUpgradingBox = new ESpriteContainer();
         }
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("CurrentUpgradingUnit");
         var img:EImage = this.mViewFactory.getEImage("box_simple",this.mSkinSku,false,layoutFactory.getArea("bkg_box"));
         this.mUpgradingBox.eAddChild(img);
         this.mUpgradingBox.setContent("bottomBkg",img);
         img.applySkinProp(this.mSkinSku,"color_blue_box");
         var field:ETextField = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_title"),"text_subheader");
         field.setText(this.getUpgradingBoxTitle());
         this.mUpgradingBox.eAddChild(field);
         this.mUpgradingBox.setContent("title",field);
         img = this.mViewFactory.getEImage("circle",this.mSkinSku,false,layoutFactory.getArea("cbox_img"));
         this.mUpgradingBox.setContent("circle",img);
         this.mUpgradingBox.eAddChild(img);
         img = this.mViewFactory.getEImage(this.getIcon(),this.mSkinSku,true,layoutFactory.getArea("cbox_img"));
         this.mUpgradingBox.setContent("icon",img);
         this.mUpgradingBox.eAddChild(img);
         var fillBarArea:ELayoutArea = layoutFactory.getArea("cbox_bar");
         var fillBar:EFillBar;
         (fillBar = this.mViewFactory.createFillBar(0,fillBarArea.width,fillBarArea.height,0,null)).layoutApplyTransformations(fillBarArea);
         this.mUpgradingBox.setContent("fillbarbkg",fillBar);
         this.mUpgradingBox.eAddChild(fillBar);
         var OFFSET:Number = 6;
         fillBar = this.mViewFactory.createFillBar(1,fillBarArea.width - OFFSET,fillBarArea.height - OFFSET,this.getCostTime(),"color_capacity");
         this.mUpgradingBox.setContent("fillBar",fillBar);
         this.mUpgradingBox.eAddChild(fillBar);
         fillBar.layoutApplyTransformations(fillBarArea);
         this.mUpgradingBox.eAddChild(fillBar);
         fillBar.logicLeft += OFFSET / 2;
         fillBar.logicTop += OFFSET / 2;
         field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_time"),"text_title_3");
         this.mUpgradingBox.setContent("timer",field);
         this.mUpgradingBox.eAddChild(field);
         var buttonsArea:ELayoutArea = layoutFactory.getArea("btn_pay");
         this.upgradePayButton();
         buttonsArea = layoutFactory.getArea("btn_l_cancel");
         button = this.mViewFactory.getButtonByTextWidth(DCTextMng.getText(4),buttonsArea.width,"btn_cancel");
         this.mUpgradingBox.setContent("ButtonCancel",button);
         this.mUpgradingBox.eAddChild(button);
         button.eAddEventListener("click",this.onCancelUpgradeActivate);
         buttonsArea.centerContent(button);
         if(this.mIsTutorial)
         {
            button.setIsEnabled(false);
         }
         eAddChild(this.mUpgradingBox);
         setContent("upgradeBox",this.mUpgradingBox);
         this.printTimer();
         this.mOldChipsValue = this.getPayButtonValue();
      }
      
      protected function upgradePayButton() : void
      {
         var button:EButton = null;
         var content:ESpriteContainer = null;
         var field:ETextField = null;
         var MINERAL_CONTENT:String = "mineral_content";
         var layoutFactory:ELayoutAreaFactory;
         var buttonsArea:ELayoutArea = (layoutFactory = this.mViewFactory.getLayoutAreaFactory("CurrentUpgradingUnit")).getArea("btn_pay");
         var buttonCreated:Boolean = false;
         if(this.getPayChipsValue() > 0)
         {
            button = this.mUpgradingBox.getContentAsEButton("ButtonInstantUpgrade");
            if(button != null)
            {
               button.destroy();
            }
            button = this.mViewFactory.getButtonByTextWidth(this.getPayButtonText(),buttonsArea.width,"btn_common","icon_chip");
            this.mUpgradingBox.setContent("ButtonInstantUpgrade",button);
            buttonCreated = true;
         }
         else
         {
            button = this.mUpgradingBox.getContentAsEButton("ButtonInstantUpgradeMinerals");
            if(button == null)
            {
               button = this.mUpgradingBox.getContentAsEButton("ButtonInstantUpgrade");
               if(button != null)
               {
                  button.destroy();
               }
               button = this.mViewFactory.getButtonByTextWidth(this.getGreenButtonText(),buttonsArea.width,"btn_accept","icon_accelerate");
               this.mUpgradingBox.setContent("ButtonInstantUpgradeMinerals",button);
               buttonCreated = true;
               content = this.mViewFactory.getSingleEntryContainer("minerals:" + this.getPayMineralValue(),"ContainerItemVerticalL",this.mSkinSku);
               this.mViewFactory.readjustContentIconWithTextVertical(content as ESpriteContainer);
               content.layoutApplyTransformations(layoutFactory.getArea("mineral_box"));
               this.mUpgradingBox.eAddChild(content);
               this.mUpgradingBox.setContent(MINERAL_CONTENT,content);
            }
            else if((content = this.mUpgradingBox.getContentAsESpriteContainer(MINERAL_CONTENT)) != null)
            {
               (field = content.getContentAsETextField("text")).setText(this.getPayMineralValue().toString());
            }
         }
         this.mUpgradingBox.eAddChild(button);
         button.eAddEventListener("click",this.onAccelerateUpgradeActivate);
         buttonsArea.centerContent(button);
      }
      
      public function getInstantBuildButton() : DisplayObjectContainer
      {
         if(this.mUpgradingBox != null)
         {
            return this.mUpgradingBox.getContent("ButtonInstantUpgrade");
         }
         return null;
      }
      
      protected function getPayButtonText() : String
      {
         return DCTextMng.replaceParameters(200,["" + this.getPayButtonValue()]);
      }
      
      protected function getPayButtonValue() : Number
      {
         return 0;
      }
      
      protected function getPayChipsValue() : Number
      {
         return 0;
      }
      
      protected function getPayMineralValue() : Number
      {
         return 0;
      }
      
      protected function getIcon() : String
      {
         return null;
      }
      
      protected function printTimer() : void
      {
      }
      
      protected function getGreenButtonText() : String
      {
         return null;
      }
      
      protected function getCostTime() : Number
      {
         return 0;
      }
      
      protected function getUpgradingBoxTitle() : String
      {
         return null;
      }
      
      protected function onCancelUpgradeActivate(e:EEvent) : void
      {
      }
      
      protected function onInstantUpgradeActivate(e:EEvent) : void
      {
      }
      
      protected function onAccelerateUpgradeActivate(e:EEvent) : void
      {
      }
      
      protected function reload() : void
      {
      }
      
      protected function checkUpgradeOrActivateEnded() : Boolean
      {
         return false;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var value:Number = NaN;
         super.logicUpdate(dt);
         if(this.mUpgradingBox != null)
         {
            this.printTimer();
            value = this.getPayButtonValue();
            if(value != this.mOldChipsValue)
            {
               this.mOldChipsValue = value;
               this.upgradePayButton();
            }
            if(this.checkUpgradeOrActivateEnded())
            {
               this.reload();
            }
         }
      }
   }
}
