package com.dchoc.game.eview.popups
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.items.MisteryRewardDef;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   
   public class EPopupDailyReward extends EGamePopup
   {
      
      protected static const BODY:String = "body";
      
      protected static const ILLUSTRATION:String = "illustration";
      
      protected static const REWARD_BOX_SKU:int = 1200;
       
      
      private var mRaysImage:EImage;
      
      private var mCurrentRewardBox:ESpriteContainer;
      
      public function EPopupDailyReward()
      {
         super();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mRaysImage = null;
         if(this.mCurrentRewardBox != null)
         {
            this.mCurrentRewardBox.destroy();
            this.mCurrentRewardBox = null;
         }
      }
      
      public function getRewardBox(entryStr:String, valueStr:String = null) : ESpriteContainer
      {
         var shine:EImage;
         var field:ETextField;
         var entry:Entry = EntryFactory.createEntryFromEntrySet(entryStr,false);
         var assetId:String = this.mViewFactory.getResourceIdFromEntry(entry);
         var espc:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("BoxReward");
         var layout:ELayoutArea = layoutFactory.getArea("container_box");
         var img:EImage = this.mViewFactory.getEImage("box_with_border",mSkinSku,false,layout);
         espc.eAddChild(img);
         espc.setContent("background",img);
         shine = this.mViewFactory.getEImage("shine_base",this.mSkinSku,false);
         shine.onSetTextureLoaded = function():void
         {
            shine.scaleLogicX = layout.width / shine.getLogicWidth();
            shine.scaleLogicY = layout.height / shine.getLogicHeight();
         };
         espc.eAddChild(shine);
         espc.setContent("shine",shine);
         img = this.mViewFactory.getEImage(assetId,mSkinSku,true,layoutFactory.getArea("icon"));
         img.scaleLogicX = 1.5;
         img.scaleLogicY = 1.5;
         espc.eAddChild(img);
         espc.setContent("icon",img);
         if(valueStr != null)
         {
            field = this.mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_value"));
            espc.eAddChild(field);
            espc.setContent("amount",field);
            field.setText(valueStr);
            field.applySkinProp(mSkinSku,"text_title_1");
         }
         return espc;
      }
      
      protected function centerRays(image:EImage) : void
      {
         this.mRaysImage.setPivotLogicXY(0.5,0.5);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mRaysImage)
         {
            this.mRaysImage.rotation += dt / 30;
         }
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         var layoutFactory:ELayoutAreaFactory;
         var bkg:EImage;
         var field:ETextField;
         var body:ESprite;
         var img:EImage;
         var area:ELayoutArea = null;
         var button:EButton = null;
         super.setup(popupId,viewFactory,skinId);
         layoutFactory = this.mViewFactory.getLayoutAreaFactory("PopXL");
         bkg = this.mViewFactory.getEImage("pop_xl",mSkinSku,false,layoutFactory.getArea("bg"));
         eAddChild(bkg);
         setBackground(bkg);
         field = this.mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         bkg.eAddChild(field);
         setTitle(field);
         button = this.mViewFactory.getButtonByTextWidth(DCTextMng.getText(1053),0,"btn_accept");
         bkg.eAddChild(button);
         button.eAddEventListener("click",onCollectClick);
         button.setIsEnabled(InstanceMng.getDailyRewardMng().isClaimable());
         area = layoutFactory.getArea("footer");
         area.centerContent(button);
         button = this.mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(button);
         setCloseButton(button);
         button.eAddEventListener("click",notifyPopupMngClose);
         body = this.mViewFactory.getESprite(mSkinSku,layoutFactory.getArea("body"));
         bkg.eAddChild(body);
         setContent("body",body);
         img = this.mViewFactory.getEImage(null,mSkinSku,true);
         this.mViewFactory.setTextureToImage("illus_daily_reward",mSkinSku,img);
         setContent("illustration",img);
         body.eAddChild(img);
         img.onSetTextureLoaded = function():void
         {
            img.scaleLogicX = body.getLogicWidth() / img.getLogicWidth();
            img.scaleLogicY = img.scaleLogicX;
            img.logicY = -10;
         };
      }
      
      public function build(cubeSku:String, cubeRewards:Array, pos:int, claimed:Boolean) : void
      {
         var i:int = 0;
         var check:EImage = null;
         var valueStr:String = null;
         var reward:RewardObject = null;
         var rewardDef:MisteryRewardDef = null;
         var rewardBox:ESpriteContainer = null;
         var rewardBoxes:Array = [];
         var field:ETextField = null;
         var body:ESprite = getContent("body");
         setTitleText(DCTextMng.getText(3680));
         var currentRewardText:String = DCTextMng.getText(3683);
         var currentReward:RewardObject = InstanceMng.getRuleMng().createRewardObjectFromMisteryRewardSku("" + cubeRewards[pos],false);
         this.mCurrentRewardBox = this.getRewardBox(currentReward.getEntryStr(),DCTextMng.convertNumberToString(currentReward.getAmount(),1,8));
         body.eAddChild(this.mCurrentRewardBox);
         this.mCurrentRewardBox.logicLeft = 284;
         this.mCurrentRewardBox.logicY = this.mCurrentRewardBox.getLogicHeight();
         if(InstanceMng.getDailyRewardMng().isClaimable())
         {
            currentRewardText = DCTextMng.getText(3684);
            this.mRaysImage = this.mViewFactory.getEImage("shine",mSkinSku,false);
            this.mRaysImage.onSetTextureLoaded = this.centerRays;
            this.mRaysImage.logicX = this.mCurrentRewardBox.width / 2;
            this.mRaysImage.logicY = this.mCurrentRewardBox.height / 2;
            this.mRaysImage.setPivotLogicXY(0.5,0.5);
            this.mCurrentRewardBox.eAddChildAt(this.mRaysImage,1);
            setContent("shine",this.mRaysImage);
         }
         if(pos == 0 && int(cubeSku) == 1200)
         {
            currentRewardText = DCTextMng.getText(3682);
         }
         var tfLayoutArea:ELayoutTextArea = this.mViewFactory.getLayoutAreaFactory("PopMissionComplete").getTextArea("text_info");
         (field = this.mViewFactory.getETextField(mSkinSku,tfLayoutArea,"text_title_2")).setText(currentRewardText);
         field.setVAlign("top");
         field.logicX = body.getLogicWidth() * 0.5 - field.getLogicWidth() * 0.5;
         field.logicY = this.mCurrentRewardBox.logicY - field.getLogicHeight();
         body.eAddChild(field);
         for(i = 0; i < cubeRewards.length; )
         {
            reward = InstanceMng.getRuleMng().createRewardObjectFromMisteryRewardSku("" + cubeRewards[i],false);
            if((rewardDef = InstanceMng.getMisteryRewardDefMng().getDefBySku("" + cubeRewards[i]) as MisteryRewardDef).getAmount().indexOf("p") > -1)
            {
               valueStr = rewardDef.getAmount().substr(0,rewardDef.getAmount().length - 1) + "%";
            }
            else
            {
               valueStr = DCTextMng.convertNumberToString(reward.getAmount(),1,8);
            }
            rewardBox = this.getRewardBox(reward.getEntryStr(),valueStr);
            if(i < pos)
            {
               (check = this.mViewFactory.getEImage("icon_check",null,true)).logicX = rewardBox.getLogicWidth() / 5;
               rewardBox.setContent("box-" + i + "-check",check);
               rewardBox.eAddChild(check);
            }
            if(i == pos)
            {
               if(claimed)
               {
                  rewardBox.applySkinProp(mSkinSku,"disabled");
               }
               else
               {
                  rewardBox.applySkinProp(mSkinSku,"glow_green_high");
               }
            }
            if(i > pos)
            {
               rewardBox.applySkinProp(mSkinSku,"disabled");
            }
            body.eAddChild(rewardBox);
            setContent("box-" + i,rewardBox);
            rewardBoxes.push(rewardBox);
            i++;
         }
         this.mViewFactory.distributeSpritesInArea(body.getLayoutArea(),rewardBoxes,1,1,-1,1,false,5);
         for each(var box in rewardBoxes)
         {
            box.logicTop = body.getLogicHeight() - box.getLogicHeight();
         }
         (field = this.mViewFactory.getETextField(mSkinSku,tfLayoutArea,"text_title_2")).setText(DCTextMng.replaceParameters(3681,["" + InstanceMng.getUserInfoMng().getProfileLogin().getDailyLoginStreak()]));
         field.setVAlign("top");
         field.logicX = body.getLogicWidth() * 0.5 - field.getLogicWidth() * 0.5;
         field.logicY = box.logicY - box.getLogicHeight() / 2;
         body.eAddChild(field);
      }
      
      private function onCollectClick(e:Object) : void
      {
         InstanceMng.getDailyRewardMng().tryToClaim();
         super.notifyPopupMngClose(e);
      }
   }
}
