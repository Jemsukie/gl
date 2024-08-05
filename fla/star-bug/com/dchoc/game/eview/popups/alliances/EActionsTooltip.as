package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EActionsTooltip extends ESpriteContainer
   {
       
      
      private var mMember:AlliancesUser;
      
      private var mIsVisitor:Boolean;
      
      private var mAllianceController:AlliancesControllerStar;
      
      private var mArea:ELayoutArea;
      
      private var mMemberBox:EAllianceMemberMyAlliance;
      
      private var mMyAlliance:Alliance;
      
      public function EActionsTooltip(memberBox:EAllianceMemberMyAlliance, member:AlliancesUser)
      {
         super();
         this.mMember = member;
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
         this.mMemberBox = memberBox;
         this.mMyAlliance = this.mAllianceController.getMyAlliance();
      }
      
      public function build() : void
      {
         var area:ELayoutArea = null;
         var img:EImage = null;
         var buttonText:String = null;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("BtnM");
         var OFFSET:int = 5;
         area = layoutFactory.getArea("base");
         var buttonW:Number;
         var areaW:Number = (buttonW = area.width) + OFFSET * 2;
         var areaH:Number = area.height * 4 + OFFSET * 6;
         area = ELayoutAreaFactory.createLayoutArea(areaW,areaH);
         this.mArea = area;
         var arrowarea:ELayoutArea;
         (arrowarea = ELayoutAreaFactory.createLayoutArea(15,15)).x = area.x + (area.width - arrowarea.width) / 2;
         arrowarea.y = area.y + area.height - 3;
         arrowarea.rotation = -90;
         arrowarea.addBehavior(viewFactory.getColorBehavior(16711680));
         img = viewFactory.getEImage("speech_arrow_1",null,false,arrowarea);
         eAddChild(img);
         setContent("arrow",img);
         img = viewFactory.getEImage("box_with_border",null,false,area);
         eAddChild(img);
         setContent("background",img);
         var buttons:Array = [];
         this.mIsVisitor = AlliancesConstants.getVisitRoleId(this.mMember.getId()) == 1;
         if(this.mIsVisitor)
         {
            buttonText = DCTextMng.getText(2821);
         }
         else
         {
            buttonText = DCTextMng.getText(144);
         }
         var button:EButton = viewFactory.getButtonByTextWidth(buttonText,buttonW,"btn_social");
         eAddChild(button);
         setContent("visitButton",button);
         button.eAddEventListener("click",this.onVisitButton);
         buttons.push(button);
         button = viewFactory.getButtonByTextWidth(DCTextMng.getText(2823),buttonW,"btn_accept");
         eAddChild(button);
         setContent("promoteButton",button);
         button.eAddEventListener("click",this.onPromoteButton);
         buttons.push(button);
         button = viewFactory.getButtonByTextWidth(DCTextMng.getText(2824),buttonW,"btn_cancel");
         eAddChild(button);
         setContent("demoteButton",button);
         button.eAddEventListener("click",this.onDemoteButton);
         buttons.push(button);
         if(this.mMember.getRole() == "REGULAR")
         {
            button.setIsEnabled(false);
         }
         button = viewFactory.getButtonByTextWidth(DCTextMng.getText(2822),buttonW,"btn_cancel");
         eAddChild(button);
         setContent("KickButton",button);
         button.eAddEventListener("click",this.onKickButton);
         buttons.push(button);
         if(this.mMyAlliance.isInAWar())
         {
            button.applySkinProp(null,"btn_cant_do_action");
         }
         viewFactory.distributeSpritesInArea(area,buttons,1,1,1,buttons.length);
      }
      
      private function onVisitButton(e:EEvent) : void
      {
         this.closeActions();
         this.mAllianceController.visitUser(this.mMember.getId(),this.mMember.getName(),this.mMember.getPictureUrl());
      }
      
      private function onDemoteButton(e:EEvent) : void
      {
         this.closeActions();
         this.mAllianceController.demote(this.mMember,this.onPromoteSuccess,this.onFail);
      }
      
      private function onPromoteButton(e:EEvent) : void
      {
         var button:EButton = null;
         var bodyText:String = null;
         this.closeActions();
         if(this.mMember.getRole() == "ADMIN")
         {
            button = InstanceMng.getViewFactory().getButtonByTextWidth(DCTextMng.getText(2823),0,"btn_accept");
            bodyText = DCTextMng.replaceParameters(3064,[this.mMember.getName().split(" ")]);
            InstanceMng.getNotificationsMng().guiOpenMessagePopupWithButton("promoteToGeneral",DCTextMng.getText(3063),bodyText,button,"alliance_council_angry",this.doPromote,false,true);
         }
         else
         {
            this.mAllianceController.promote(this.mMember,this.onPromoteSuccess,this.onFail);
         }
      }
      
      private function doPromote(e:EEvent) : void
      {
         this.mAllianceController.promote(this.mMember,this.onPromoteGeneralSuccess,this.onFail);
      }
      
      private function onKickButton(e:EEvent) : void
      {
         var button:EButton = null;
         this.closeActions();
         if(this.mMyAlliance.isInAWar())
         {
            this.mAllianceController.throwErrorMessage(DCTextMng.getText(3006),DCTextMng.getText(3007));
         }
         else
         {
            button = InstanceMng.getViewFactory().getButtonByTextWidth(DCTextMng.getText(2822),0,"btn_cancel");
            InstanceMng.getNotificationsMng().guiOpenMessagePopupWithButton("kickUser",DCTextMng.getText(3008),DCTextMng.getText(3009),button,"alliance_council_angry",this.doKick,false,true);
         }
      }
      
      private function onPromoteSuccess(ae:AlliancesAPIEvent) : void
      {
         this.reloadAlliances();
      }
      
      private function onPromoteGeneralSuccess(ae:AlliancesAPIEvent) : void
      {
         EPopupAlliances(this.mAllianceController.getPopupAlliance()).setTabPage(0);
      }
      
      private function doKick(e:EEvent) : void
      {
         this.mAllianceController.kickUser(this.mMember,this.onKickSuccess,this.onFail);
      }
      
      private function onKickSuccess(ae:AlliancesAPIEvent) : void
      {
         EPopupAlliances(this.mAllianceController.getPopupAlliance()).setTabPage(0);
      }
      
      private function onFail(ae:AlliancesAPIEvent) : void
      {
         this.closeActions();
         this.mAllianceController.throwErrorMessage(ae.getErrorTitle(),ae.getErrorMsg());
      }
      
      private function closeActions() : void
      {
         EPopupAlliances(this.mAllianceController.getPopupAlliance()).closeActionsTooltip();
      }
      
      private function reloadAlliances() : void
      {
         this.mMemberBox.setInfo(this.mMember);
      }
   }
}
