package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.game.model.items.AlliancesRewardDef;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EAllianceRewardBox extends ESpriteContainer
   {
       
      
      private const COMING_SOON:String = "soon";
      
      private const TITLE:String = "title";
      
      private const STATE_TEXT:String = "state_text";
      
      private const BACKGROUND:String = "background";
      
      private var mAreaPrize:ELayoutArea;
      
      private var mReward:AlliancesRewardDef;
      
      private var mRewardItem:ItemObject;
      
      private var mUserAlliance:Alliance;
      
      private var mMyUser:AlliancesUser;
      
      public function EAllianceRewardBox()
      {
         super();
      }
      
      public function setInfo(info:AlliancesRewardDef) : void
      {
         var field:ETextField = null;
         var textProp:String = null;
         var value:int = 0;
         var container:ESpriteContainer = null;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("LayoutAllianceRewardBox");
         this.mUserAlliance = InstanceMng.getAlliancesController().getMyAlliance();
         this.mMyUser = InstanceMng.getAlliancesController().getMyUser();
         this.mAreaPrize = layoutFactory.getArea("area_prize");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var img:EImage = viewFactory.getEImage("box_with_border",null,false,this.mAreaPrize);
         setContent("background",img);
         eAddChild(img);
         var buttonArea:ELayoutArea = layoutFactory.getArea("btn");
         var button:EButton = viewFactory.getButtonByTextWidth(DCTextMng.getText(2834),buttonArea.width,"btn_accept",null,null,null,buttonArea);
         eAddChild(button);
         setContent("buttonReward",button);
         button.eAddEventListener("click",this.onGetReward);
         button.visible = false;
         if(info != null)
         {
            this.mReward = info;
            field = viewFactory.getETextField(null,layoutFactory.getTextArea("test_title"),"text_subheader");
            setContent("title",field);
            eAddChild(field);
            if(info.getReward()[0] == "soon")
            {
               (img = viewFactory.getEImage("alliance_council_happy",null,false)).alpha = 0.5;
               img.onSetTextureLoaded = this.centerImg;
               eAddChild(img);
               setContent("advisor",img);
               field.setText(DCTextMng.getText(2997));
               applySkinProp(null,"disabled");
            }
            else
            {
               this.mRewardItem = InstanceMng.getItemsMng().getItemObjectBySku(info.getRewardItemSku());
               img = viewFactory.getEImage(this.mRewardItem.mDef.getAssetId(),null,true,layoutFactory.getArea("icon_medal"));
               setContent("itemImg",img);
               eAddChild(img);
               field.setText(this.mRewardItem.mDef.getNameToDisplay());
               field = viewFactory.getETextField(null,layoutFactory.getTextArea("test_complete"),"text_subheader");
               eAddChild(field);
               setContent("state_text",field);
               if(InstanceMng.getAlliancesRewardsMng().userHasAlreadyReceivedRewardItem(info.getRewardItemSku()))
               {
                  (field = getContentAsETextField("state_text")).setText(DCTextMng.getText(2831));
                  img = viewFactory.getEImage("icon_check",null,true,layoutFactory.getArea("icon_tick"));
                  setContent("check",img);
                  eAddChild(img);
               }
               else if(InstanceMng.getAlliancesRewardDefMng().isPlayerEligibleForReward(info.mSku))
               {
                  img = viewFactory.getEImage("stripe_player",null,false,this.mAreaPrize);
                  setContent("background",img);
                  eAddChildAt(img,0);
                  (field = getContentAsETextField("state_text")).setText(DCTextMng.getText(2832));
                  field.unapplySkinProp(null,"text_subheader");
                  field.applySkinProp(null,"text_positive");
                  button.visible = true;
               }
               else
               {
                  (field = getContentAsETextField("state_text")).setText(DCTextMng.getText(2833));
                  field = viewFactory.getETextField(null,layoutFactory.getTextArea("test_victories"),"text_subheader");
                  eAddChild(field);
                  setContent("victoriesTitle",field);
                  field.setText(DCTextMng.getText(2844));
                  value = info.getConditionAmountBySku("alliancesBattlesWon");
                  field = viewFactory.getETextField(null,layoutFactory.getTextArea("test_victories_value"),"text_body");
                  if(this.mUserAlliance.getWarsWon() < value)
                  {
                     textProp = "text_negative";
                     field.applySkinProp(null,textProp);
                  }
                  eAddChild(field);
                  setContent("victoriesValue",field);
                  field.setText(DCTextMng.convertNumberToString(value,2,8));
                  value = info.getConditionAmountBySku("warPoints");
                  container = viewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_user_warpoints",DCTextMng.convertNumberToString(value,1,8),null,"text_body");
                  if(this.mMyUser.getScore() < value)
                  {
                     field = container.getContentAsETextField("text");
                     textProp = "text_negative";
                     field.applySkinProp(null,textProp);
                  }
                  eAddChild(container);
                  setContent("warpoints",container);
                  container.layoutApplyTransformations(layoutFactory.getArea("btn"));
               }
            }
         }
      }
      
      private function centerImg(img:EImage) : void
      {
         this.mAreaPrize.centerContent(img);
      }
      
      private function onGetReward(e:EEvent) : void
      {
         var button:EButton = null;
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var itemDef:ItemsDef = InstanceMng.getItemsDefMng().getDefBySku(this.mReward.getRewardItemSku()) as ItemsDef;
         var bodyText:String = DCTextMng.replaceParameters(2993,[itemDef.getNameToDisplay()]);
         InstanceMng.getNotificationsMng().guiOpenTradeInPopup(bodyText,this.mReward.getRewardObject(),false,this.reloadPopup);
      }
      
      private function reloadPopup(e:EEvent) : void
      {
         InstanceMng.getItemsMng().addItemAmount(this.mReward.getRewardItemSku(),1,true);
         InstanceMng.getUserDataMng().updateAlliances_GetReward(this.mReward.mSku);
         this.setInfo(this.mReward);
      }
   }
}
