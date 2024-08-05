package com.dchoc.game.eview.popups
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.skins.SkinsMng;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.tooltips.ETooltip;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.world.item.RefineryStage;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.Playout;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import mx.utils.StringUtil;
   
   public class ERefineryPopup extends EGamePopup
   {
       
      
      private var mStages:Vector.<RefineryStage>;
      
      private var mIntervalId:int;
      
      private var mRefineButtons:Vector.<EButton>;
      
      private var mCollectButton:EButton;
      
      private var mLayout:Playout;
      
      private var mItem:WorldItemObject;
      
      public function ERefineryPopup(wio:WorldItemObject)
      {
         var cost:Number = NaN;
         var duration:Number = NaN;
         var sku:String = null;
         super();
         this.mItem = wio;
         this.mStages = new Vector.<RefineryStage>(0);
         var pieces:Array = wio.mDef.getRefineryStages().split(",");
         while(pieces.length >= 3)
         {
            cost = parseFloat(StringUtil.trim(pieces.shift()));
            duration = parseFloat(StringUtil.trim(pieces.shift()));
            sku = StringUtil.trim(pieces.shift());
            this.mStages.push(new RefineryStage(cost,duration,sku));
         }
         this.mIntervalId = -1;
         this.mRefineButtons = new Vector.<EButton>(0);
      }
      
      public static function isRefiningSomething() : Boolean
      {
         return getCurrentSku() != null;
      }
      
      public static function getCurrentSku() : String
      {
         var result:String = InstanceMng.getUserInfoMng().getProfileLogin().getRefiningSku();
         if(result === "")
         {
            result = null;
         }
         return result;
      }
      
      public static function getRemainingTime() : Number
      {
         var endTime:Number = InstanceMng.getUserInfoMng().getProfileLogin().getRefiningTime();
         var currentTime:Number = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
         return endTime - currentTime;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         if(this.mIntervalId != -1)
         {
            clearInterval(this.mIntervalId);
         }
      }
      
      private function configureButtons() : void
      {
         var i:int = 0;
         for(i = 0; i < 3; )
         {
            if(i < this.mStages.length)
            {
               this.configureButton(i);
            }
            i++;
         }
         this.configureCollectButton();
      }
      
      private function configureCollectButton() : void
      {
         var remainingTime:Number = 0;
         if(isRefiningSomething())
         {
            remainingTime = getRemainingTime();
            if(remainingTime <= 0)
            {
               this.mCollectButton.setText(DCTextMng.getText(1053));
               this.mCollectButton.setIsEnabled(true);
            }
            else
            {
               this.mCollectButton.setIsEnabled(false);
               this.mCollectButton.setText(DCTextMng.convertTimeToStringColon(remainingTime));
            }
         }
         else
         {
            this.mCollectButton.setText(DCTextMng.getText(1053));
            this.mCollectButton.setIsEnabled(false);
         }
      }
      
      public function build(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         var i:int = 0;
         var textField:ETextField = null;
         super.setup(popupId,viewFactory,skinId);
         var popupLayoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupLayoutHangarEmpty");
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopL");
         var content:ESprite = mViewFactory.getESprite(skinId);
         setFooterArea(layoutFactory.getArea("footer"));
         var area:ELayoutArea = layoutFactory.getArea("bg");
         var bkg:ESprite = mViewFactory.getEImage("pop_l",mSkinSku,false,area);
         setLayoutArea(area,true);
         setBackground(bkg);
         eAddChild(bkg);
         var title:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         setTitle(title);
         setTitleText(DCTextMng.getText(1047));
         bkg.eAddChild(getTitle());
         bkg.eAddChild(content);
         content.layoutApplyTransformations(layoutFactory.getArea("body"));
         setContent("CONTENT",content);
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(closeButton);
         setCloseButton(closeButton);
         setCloseButtonVisible(true);
         closeButton.eAddEventListener("click",notifyPopupMngClose);
         this.mLayout = new Playout(new Rectangle(0,0,575,375)).pixels(125).top().pixels(125).left().translate(10,0).scale(1.5,1.5).setName("advisor").parent.pixels(20).left().translate(0,-20).setName("speechArrow").parent.middle().setName("speechBox").parent.parent.pixels(5).top().parent.debug(content).fractionHeight(0.15).bottom().setName("footer").parent.fractionHeight(0.33).top().setName("row-0").parent.top().setName("row-1").parent.top().setName("row-2").parent.root();
         for(i = 0; i < 3; )
         {
            if(i < this.mStages.length)
            {
               this.formatRow(i,this.mLayout.find("row-" + i),content);
            }
            i++;
         }
         this.mLayout.find("footer").pixels(this.mLayout.find("row-2").find("button").asRectangle().x).left().parent.translate(0,6).setName("collectButton");
         this.createCollectButton(this.mLayout,content);
         this.configureButtons();
         this.mIntervalId = setInterval(this.configureButtons,1000);
         var speechArrow:EImage = mViewFactory.getEImage("speech_arrow",mSkinSku,false,this.mLayout.find("speechArrow").asArea(true),"speech_color");
         content.eAddChild(speechArrow);
         var speechBubble:ESprite = this.roundedRect(this.mLayout.find("speechBox").asRectangle(),10);
         content.eAddChild(speechBubble);
         var txtSpeech:ETextField;
         (txtSpeech = viewFactory.getETextField(mSkinSku,this.mLayout.find("speechBox").asTextArea(),"text_body_3")).setText(DCTextMng.getText(1049));
         content.eAddChild(txtSpeech);
         var skinsMng:SkinsMng = InstanceMng.getSkinsMng();
         skinsMng.applyPropToSprite(skinsMng.getCurrentSkinSku(),"speech_color",speechBubble);
         var advisor:EImage = mViewFactory.getEImage("scientist_happy",mSkinSku,true,this.mLayout.find("advisor").asArea(true));
         content.eAddChild(advisor);
      }
      
      private function createCollectButton(layout:Playout, content:ESprite) : void
      {
         var popup:ERefineryPopup = null;
         var collected:Boolean = false;
         var skinsMng:SkinsMng = InstanceMng.getSkinsMng();
         this.mCollectButton = mViewFactory.getButton("btn_accept",skinsMng.getCurrentSkinSku(),"M",DCTextMng.getText(1053),null,layout.find("collectButton").asArea(true));
         popup = this;
         collected = false;
         this.mCollectButton.addEventListener("click",function(e:Event):void
         {
            if(!collected)
            {
               collected = true;
               InstanceMng.getTargetMng().updateProgress("completeRefining",1,getCurrentSku());
               InstanceMng.getUserDataMng().completeRefining();
               InstanceMng.getPopupMng().closePopup(popup);
            }
         });
         content.eAddChild(this.mCollectButton);
      }
      
      private function roundedRect(rl:Rectangle, radius:int) : ESprite
      {
         var result:ESprite = new ESprite();
         result.graphics.clear();
         result.graphics.beginFill(16777215);
         result.graphics.lineStyle(0);
         result.graphics.drawRoundRect(rl.x,rl.y,rl.width,rl.height,radius,radius);
         result.graphics.endFill();
         return result;
      }
      
      private function configureButton(i:int) : void
      {
         var btnRefine:EButton = this.mRefineButtons[i];
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var canAfford:* = profile.getMinerals() >= this.getMineralsForStage(i);
         var isActive:Boolean = isRefiningSomething();
         btnRefine.setIsEnabled(canAfford && !isActive);
      }
      
      private function getMineralsForStage(i:int) : Number
      {
         return this.mStages[i].mCostMinerals.value;
      }
      
      private function formatRow(i:int, layout:Playout, content:ESprite) : void
      {
         var skinsMng:SkinsMng;
         var txtDescription:ETextField;
         var line1:String;
         var line2:String;
         var btnRefine:EButton;
         var that:ERefineryPopup;
         var txtReward:ETextField;
         var stage:RefineryStage = null;
         var image:EImage = null;
         var def:ItemsDef = null;
         var tooltip:ETooltip = null;
         layout = layout.pixels(5).top().parent.fractionWidth(0.66).left().dup().setName("panel").parent.fractionWidth(0.6).left().setName("description").parent.middle().translate(15,13.5).setName("button").parent.parent.middle().translate(20,0).fractionWidth(0.5).left().setName("rewardText").parent.middle().setName("icon").parent.parent;
         var rectangle:Rectangle = layout.find("panel").asRectangle();
         var rect:ESprite = this.roundedRect(rectangle,10);
         content.eAddChild(rect);
         skinsMng = InstanceMng.getSkinsMng();
         skinsMng.applyPropToSprite(skinsMng.getCurrentSkinSku(),"area_color",rect);
         stage = this.mStages[i];
         txtDescription = mViewFactory.getETextField(mSkinSku,layout.find("description").asTextArea(),"text_body_3");
         line1 = DCTextMng.replaceParametersInTemplate(DCTextMng.getText(1051),[DCTextMng.convertNumberToString(stage.mCostMinerals.value,-1,-1)]);
         line2 = DCTextMng.replaceParametersInTemplate(DCTextMng.getText(1052),[DCTextMng.getCountdownTime(stage.mTimeMinutes.value * 60000)]);
         txtDescription.setText(line1 + "\n" + line2);
         content.eAddChild(txtDescription);
         btnRefine = mViewFactory.getButton("btn_accept",skinsMng.getCurrentSkinSku(),"M",DCTextMng.getText(1050),null,layout.find("button").asArea(true));
         that = this;
         btnRefine.addEventListener("click",function(e:Event):void
         {
            var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
            var udm:UserDataMng = InstanceMng.getUserDataMng();
            udm.startRefining(i,stage.mRewardSku,stage.mTimeMinutes.value,getMineralsForStage(i));
            InstanceMng.getWorldItemObjectController().setItemClientState(mItem,32,true);
            configureButtons();
         });
         this.mRefineButtons.push(btnRefine);
         content.eAddChild(btnRefine);
         txtReward = mViewFactory.getETextField(mSkinSku,layout.find("rewardText").asTextArea(),"text_body_3");
         txtReward.setText(DCTextMng.getText(1054));
         content.eAddChild(txtReward);
         image = mViewFactory.getEImage(null,mSkinSku,true,layout.find("icon").asArea(true));
         def = InstanceMng.getItemsDefMng().getDefBySku(stage.mRewardSku) as ItemsDef;
         InstanceMng.getViewFactory().setTextureToImage(def.getAssetId(),InstanceMng.getSkinsMng().getCurrentSkinSku(),image);
         content.eAddChild(image);
         tooltip = null;
         image.addEventListener("mouseOver",function(e:Event):void
         {
            if(tooltip != null)
            {
               ETooltipMng.getInstance().removeTooltip(tooltip);
               tooltip = null;
            }
            var info:ETooltipInfo = ETooltipMng.getInstance().createTooltipInfoFromText(def.getNameToDisplay(),image);
            tooltip = ETooltipMng.getInstance().showTooltip(info);
         });
         image.addEventListener("mouseOut",function(e:Event):void
         {
            if(tooltip != null)
            {
               ETooltipMng.getInstance().removeTooltip(tooltip);
               tooltip = null;
            }
         });
      }
   }
}
