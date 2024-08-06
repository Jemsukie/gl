package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EAllianceBoxJoin extends ESpriteContainer
   {
       
      
      private const RANK:String = "rank";
      
      private const NAME:String = "name";
      
      private const MEMBERS:String = "members";
      
      private const VICTORIES:String = "victories";
      
      private var mAlliance:Alliance;
      
      private var mAllianceController:AlliancesControllerStar;
      
      public function EAllianceBoxJoin()
      {
         super();
      }
      
      public function build() : void
      {
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var layoutFactory:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("StripeAlliancesLeaderBoard");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var bkg:EImage = viewFactory.getEImage("stripe",null,false,layoutFactory.getArea("stripe"));
         eAddChild(bkg);
         setContent("bkg",bkg);
         var field:ETextField = viewFactory.getETextField(null,layoutFactory.getTextArea("text_number"),"text_subheader");
         eAddChild(field);
         setContent("rank",field);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_name"),"text_body_2");
         eAddChild(field);
         setContent("name",field);
         viewFactory.setTextFieldClickableBehaviors(field);
         field.eAddEventListener("click",this.onAllianceClick);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_value"),"text_body_2");
         eAddChild(field);
         setContent("members",field);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_victories"),"text_body_2");
         eAddChild(field);
         setContent("victories",field);
      }
      
      public function setInfo(info:Alliance) : void
      {
         var viewFactory:ViewFactory = null;
         var layoutFactory:ELayoutAreaFactory = null;
         var img:ESprite = null;
         var field:ETextField = null;
         var totalWars:int = 0;
         var buttonArea:ELayoutArea = null;
         var buttonText:String = null;
         var button:EButton = null;
         if(info != null)
         {
            this.mAlliance = info;
            layoutFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("StripeAlliancesLeaderBoard");
            img = AlliancesControllerStar(InstanceMng.getAlliancesController()).getAllianceFlag(info.getLogo()[0],info.getLogo()[1],info.getLogo()[2],layoutFactory.getArea("img_profile"));
            eAddChild(img);
            setContent("flag",img);
            img.buttonMode = true;
            img.mouseChildren = false;
            viewFactory.setButtonBehaviors(img);
            img.eAddEventListener("click",this.onAllianceClick);
            (field = getContentAsETextField("rank")).setText(info.getRank().toString());
            (field = getContentAsETextField("name")).setText(info.getName());
            (field = getContentAsETextField("members")).setText(info.getTotalMembers() + "/" + InstanceMng.getAlliancesSettingsDefMng().getMaxAllianceMembers());
            totalWars = info.getWarsLost() + info.getWarsWon();
            (field = getContentAsETextField("victories")).setText(info.getWarsWon() + "/" + totalWars);
            buttonArea = layoutFactory.getArea("btn");
            if(this.mAllianceController.haveIRequestedForJoinAlliance(info.getId()))
            {
               buttonText = DCTextMng.getText(2988);
            }
            else
            {
               buttonText = DCTextMng.getText(2856);
            }
            button = viewFactory.getButtonByTextWidth(buttonText,buttonArea.width,"btn_social",null,null);
            eAddChild(button);
            setContent("joinbutton",button);
            button.layoutApplyTransformations(buttonArea);
            button.eAddEventListener("click",this.onJoinButtonClick);
         }
      }
      
      private function onJoinButtonClick(e:EEvent) : void
      {
         var level:int = 0;
         if(this.mAlliance != null)
         {
            level = parseInt(InstanceMng.getAlliancesLevelDefMng().getLevelFromScore(this.mAlliance.getScore()));
            if(InstanceMng.getUserInfoMng().getProfileLogin().getLevel() < level)
            {
               this.mAllianceController.joinRequirementFailedNotification(level);
               return;
            }
            if(this.mAllianceController.haveIRequestedForJoinAlliance(this.mAlliance.getId()))
            {
               this.mAllianceController.joinAlliance(this.mAlliance.getId(),this.onRemindSuccess,this.onJoinFail,true);
            }
            else
            {
               this.mAllianceController.joinAlliance(this.mAlliance.getId(),this.onJoinSuccess,this.onJoinFail,true);
            }
         }
      }
      
      private function onAllianceClick(e:EEvent) : void
      {
         this.mAllianceController.guiOpenPopupAllianceMembers(this.mAlliance,this);
      }
      
      private function onRemindSuccess(ae:AlliancesAPIEvent) : void
      {
         var bodyText:String = null;
         var title:String = null;
         bodyText = DCTextMng.getText(3019);
         title = DCTextMng.getText(2988);
         InstanceMng.getNotificationsMng().guiOpenMessagePopup("allianceRemind",title,bodyText,"alliance_council_happy",this.updateAlliances,false);
      }
      
      private function onJoinSuccess(ae:AlliancesAPIEvent) : void
      {
         var bodyText:String = null;
         var title:String = null;
         bodyText = DCTextMng.getText(3018);
         title = DCTextMng.getText(2856);
         InstanceMng.getNotificationsMng().guiOpenMessagePopup("allianceJoin",title,bodyText,"alliance_council_happy",this.updateAlliances,false);
      }
      
      private function onJoinFail(ae:AlliancesAPIEvent) : void
      {
         this.mAllianceController.throwErrorMessage(ae.getErrorTitle(),ae.getErrorMsg());
      }
      
      private function updateAlliances(e:EEvent) : void
      {
         this.setInfo(this.mAlliance);
      }
   }
}
