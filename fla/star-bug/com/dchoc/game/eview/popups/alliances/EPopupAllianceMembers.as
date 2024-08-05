package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EPopupAllianceMembers extends EGamePopup
   {
       
      
      private const BODY:String = "Body";
      
      private var mAllianceController:AlliancesControllerStar;
      
      private var mAlliance:Alliance;
      
      private var mStripe:ESprite;
      
      public function EPopupAllianceMembers()
      {
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
         this.setupBackground();
      }
      
      private function setupBackground() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopL");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var img:EImage = mViewFactory.getEImage("pop_l",mSkinSku,false,layoutFactory.getArea("bg"));
         eAddChild(img);
         setBackground(img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_header");
         img.eAddChild(field);
         setTitle(field);
         field.setText(DCTextMng.getText(2899));
         var button:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         img.eAddChild(button);
         setCloseButton(button);
         button.eAddEventListener("click",this.onClosePopup);
         var body:ESprite = mViewFactory.getESprite(mSkinSku,layoutFactory.getArea("body"));
         img.eAddChild(body);
         setContent("Body",body);
      }
      
      public function setInfo(info:Alliance, stripe:ESprite) : void
      {
         if(info != null)
         {
            this.mStripe = stripe;
            this.mAllianceController.requestAllianceById(info.getId(),true,this.requestSuccess,null,false);
         }
      }
      
      private function requestSuccess(ae:AlliancesAPIEvent) : void
      {
         var button:EButton = null;
         var buttonText:String = null;
         this.mAlliance = ae.alliance;
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutBodyAllianceMembers");
         var body:ESprite = getContent("Body");
         var flag:ESprite = this.mAllianceController.getAllianceFlag(this.mAlliance.getLogo()[0],this.mAlliance.getLogo()[1],this.mAlliance.getLogo()[2],layoutFactory.getArea("flag"));
         body.eAddChild(flag);
         setContent("flag",flag);
         var field:ETextField;
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_name_alliance"),"text_subheader")).setText(DCTextMng.getText(2795));
         body.eAddChild(field);
         setContent("nameLabel",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_name_alliance_value"),"text_body")).setText(this.mAlliance.getName());
         body.eAddChild(field);
         setContent("nameValue",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_general"),"text_subheader")).setText(DCTextMng.getText(2796));
         body.eAddChild(field);
         setContent("generalLabel",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_general_value"),"text_body")).setText(this.mAlliance.getLeader().getName());
         body.eAddChild(field);
         setContent("generalValue",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_members"),"text_subheader")).setText(DCTextMng.getText(2797));
         body.eAddChild(field);
         setContent("text_members",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_members_value"),"text_body")).setText(this.mAlliance.getTotalMembers() + "/" + InstanceMng.getAlliancesSettingsDefMng().getMaxAllianceMembers());
         body.eAddChild(field);
         setContent("text_members_value",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_stats"),"text_subheader")).setText(DCTextMng.getText(2813));
         body.eAddChild(field);
         setContent("text_stats",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_stats_value"),"text_body")).setText(DCTextMng.convertNumberToString(this.mAlliance.getScore(),1,8));
         body.eAddChild(field);
         setContent("text_stats_value",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_victories"),"text_subheader")).setText(DCTextMng.getText(2800));
         body.eAddChild(field);
         setContent("text_victories",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_victories_value"),"text_body")).setText(DCTextMng.convertNumberToString(this.mAlliance.getWarsWon(),1,8));
         body.eAddChild(field);
         setContent("text_victories_value",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_defeats"),"text_subheader")).setText(DCTextMng.getText(2801));
         body.eAddChild(field);
         setContent("text_defeats",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_defeats_value"),"text_body")).setText(DCTextMng.convertNumberToString(this.mAlliance.getWarsLost(),1,8));
         body.eAddChild(field);
         setContent("text_defeats_value",field);
         var buttonArea:ELayoutArea = layoutFactory.getArea("btn_join");
         if(!this.mAllianceController.isMeInAnyAlliance())
         {
            if(this.mAllianceController.haveIRequestedForJoinAlliance(this.mAlliance.getId()))
            {
               buttonText = DCTextMng.getText(2988);
            }
            else
            {
               buttonText = DCTextMng.getText(2856);
            }
            button = mViewFactory.getButtonByTextWidth(buttonText,buttonArea.width,"btn_social");
            button.eAddEventListener("click",this.onJoinButtonClick);
         }
         else if(!Config.useAlliancesSuggested() && this.mAlliance.getId() != this.mAllianceController.getMyAlliance().getId())
         {
            buttonText = DCTextMng.getText(2852);
            if(this.mAlliance.isInAWar() || AlliancesConstants.canRoleDeclareWar(this.mAllianceController.getMyUser().getRole()))
            {
               button = mViewFactory.getButtonByTextWidth(buttonText,buttonArea.width,"btn_cant_attack");
               button.eAddEventListener("click",this.onDeclareWarRed);
            }
            else
            {
               button = mViewFactory.getButtonByTextWidth(buttonText,buttonArea.width,"btn_can_attack");
               button.eAddEventListener("click",this.onDeclareWarGreen);
            }
         }
         if(button != null)
         {
            body.eAddChild(button);
            setContent("actionButton",button);
            button.layoutApplyTransformations(buttonArea);
         }
         var scrollArea:EScrollArea = new EScrollArea();
         scrollArea.build(layoutFactory.getArea("area_members"),this.mAlliance.getTotalMembers(),ESpriteContainer,this.loadMemberStripes);
         mViewFactory.getEScrollBar(scrollArea);
         setContent("scrollArea",scrollArea);
         body.eAddChild(scrollArea);
      }
      
      private function loadMemberStripes(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var stripe:EAllianceMemberMyAlliance = null;
         if(rebuild)
         {
            (stripe = new EAllianceMemberMyAlliance("nobutton")).build();
            spriteReference.eAddChild(stripe);
            spriteReference.setContent("stripe",stripe);
         }
         (stripe = spriteReference.getChildAt(0) as EAllianceMemberMyAlliance).setInfo(this.mAlliance.getMemberByIndex(rowOffset));
      }
      
      private function onClosePopup(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
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
         this.onClosePopup(null);
         this.mAllianceController.throwErrorMessage(ae.getErrorTitle(),ae.getErrorMsg());
      }
      
      private function updateAlliances(e:EEvent) : void
      {
         this.onClosePopup(null);
         if(this.mStripe != null)
         {
            if(this.mStripe is EAllianceBoxJoin)
            {
               EAllianceBoxJoin(this.mStripe).setInfo(this.mAlliance);
            }
            if(this.mStripe is EAllianceBoxLeaderboard)
            {
               EAllianceBoxLeaderboard(this.mStripe).setInfo(this.mAlliance);
            }
         }
      }
      
      private function onDeclareWarGreen(e:EEvent) : void
      {
         this.onClosePopup(null);
         InstanceMng.getAlliancesController().createDeclareWarEvent(this.mAlliance.getId(),this.mAlliance.getName());
      }
      
      private function onDeclareWarRed(e:EEvent) : void
      {
         var bodyText:String = null;
         var title:String = DCTextMng.getText(2932);
         if(!AlliancesConstants.canRoleDeclareWar(this.mAllianceController.getMyUser().getRole()))
         {
            title = DCTextMng.getText(2930);
            bodyText = DCTextMng.getText(2931);
         }
         else if(InstanceMng.getAlliancesController().getMyAlliance().isInAWar())
         {
            bodyText = DCTextMng.getText(2933);
         }
         else
         {
            bodyText = DCTextMng.getText(2942);
         }
         InstanceMng.getNotificationsMng().guiOpenMessagePopup("cantdeclarewar",title,bodyText,"alliance_council_angry");
      }
   }
}
