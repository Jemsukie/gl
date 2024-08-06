package com.dchoc.game.eview.popups.options
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.display.Stage;
   
   public class EPopupChooseResolution extends EGamePopup
   {
       
      
      private const SKU_BAR_WIDTH:String = "barWidth";
      
      private const SKU_BAR_HEIGHT:String = "barHeight";
      
      private const MIN_WIDTH:int = 640;
      
      private const MAX_WIDTH:int = 3840;
      
      private const MIN_HEIGHT:int = 480;
      
      private const MAX_HEIGHT:int = 2160;
      
      private var mBars:Array;
      
      private var mResolution:Vector.<int>;
      
      private var mBodyArea:ELayoutArea;
      
      private var mProfile:Profile;
      
      private var mStage:Stage;
      
      private var mApplyCallback:Function;
      
      public function EPopupChooseResolution()
      {
         mBars = [];
         mResolution = new Vector.<int>(2);
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.mProfile = InstanceMng.getUserInfoMng().getProfileLogin();
         this.mStage = InstanceMng.getApplication().stageGetStage().getImplementation();
         this.setupBackground();
         setTitleText(DCTextMng.getText(4328));
         this.setupBody();
      }
      
      public function setApplyCallback(func:Function) : void
      {
         this.mApplyCallback = func;
      }
      
      private function setupBackground() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopS");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var bkg:EImage = mViewFactory.getEImage("pop_s",null,false,layoutFactory.getArea("bg"));
         setBackground(bkg);
         eAddChild(bkg);
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title"),"text_header");
         setTitle(field);
         bkg.eAddChild(field);
         var button:EButton = mViewFactory.getButtonClose(null,layoutFactory.getArea("btn_close"));
         setCloseButton(button);
         bkg.eAddChild(button);
         button.eAddEventListener("click",this.onCloseClick);
         this.mBodyArea = layoutFactory.getArea("body");
         mFooterArea = layoutFactory.getArea("footer");
      }
      
      private function setupBody() : void
      {
         var button:EButton = null;
         var optionBar:EOptionSlider = null;
         var layout:ELayoutArea = ELayoutAreaFactory.createLayoutArea(240,60);
         var toggled:Boolean = this.mProfile.getFullscreenResolution() != "" && this.mProfile.getFullscreenResolution().indexOf(",") > -1;
         var oldWidth:int = int(this.mStage.fullScreenWidth);
         var oldHeight:int = int(this.mStage.fullScreenHeight);
         if(toggled)
         {
            oldWidth = int(this.mProfile.getFullscreenResolution().split(",")[0]);
            oldHeight = int(this.mProfile.getFullscreenResolution().split(",")[1]);
         }
         optionBar = new EOptionSlider("barWidth",4330,this.onBarChanged,this.onBarToggled);
         optionBar.setBounds(640,3840);
         optionBar.init(layout);
         optionBar.setValue(oldWidth);
         optionBar.setToggled(toggled);
         setContent("barWidth",optionBar);
         eAddChild(optionBar);
         this.mBars.push(optionBar);
         optionBar = new EOptionSlider("barHeight",4331,this.onBarChanged,this.onBarToggled);
         optionBar.setBounds(480,2160);
         optionBar.init(layout);
         optionBar.setValue(oldHeight);
         optionBar.setToggled(toggled);
         setContent("barHeight",optionBar);
         eAddChild(optionBar);
         this.mBars.push(optionBar);
         mViewFactory.distributeSpritesInArea(this.mBodyArea,this.mBars,1,1,-1,1,true);
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(3969),0,"btn_accept");
         addButton("resetBtn",button);
         button.eAddEventListener("click",this.onResetClicked);
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(4319),0,"btn_accept");
         addButton("applyBtn",button);
         button.eAddEventListener("click",this.onApplyClicked);
      }
      
      private function onBarChanged(sku:String, value:int) : void
      {
         switch(sku)
         {
            case "barWidth":
               this.mResolution[0] = value;
               break;
            case "barHeight":
               this.mResolution[1] = value;
         }
      }
      
      private function onBarToggled(sku:String, value:Boolean) : void
      {
         var bar:EOptionSlider = null;
         bar = this.mBars[0];
         bar.setToggled(value);
         if(!value)
         {
            bar.setValue(this.mStage.fullScreenWidth,false);
         }
         bar = this.mBars[1];
         bar.setToggled(value);
         if(!value)
         {
            bar.setValue(this.mStage.fullScreenHeight,false);
         }
         this.mResolution[1] = value ? bar.getValue() : 0;
      }
      
      private function onResetClicked(e:EEvent) : void
      {
         var bar:EOptionSlider = null;
         bar = this.mBars[0];
         bar.setValue(this.mStage.fullScreenWidth);
         bar.setToggled(false);
         bar = this.mBars[1];
         bar.setValue(this.mStage.fullScreenHeight);
         bar.setToggled(false);
      }
      
      private function onApplyClicked(e:EEvent) : void
      {
         var result:String = "";
         if(this.mResolution[0] >= 640 && this.mResolution[1] >= 480 && this.mResolution[0] <= 3840 && this.mResolution[1] <= 2160)
         {
            result = this.mResolution[0] + "," + this.mResolution[1];
         }
         this.mApplyCallback(result);
         this.onCloseClick(null);
      }
      
      private function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
   }
}
