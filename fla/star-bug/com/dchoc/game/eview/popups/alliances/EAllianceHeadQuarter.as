package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.game.model.rule.AlliancesLevelDef;
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
   import esparragon.widgets.EFillBar;
   
   public class EAllianceHeadQuarter extends ESpriteContainer
   {
       
      
      private const STATUS_COLOR_RED:uint = parseInt("0xD00202",16);
      
      private const STATUS_COLOR_GREEN:uint = parseInt("0x306001",16);
      
      private const FIELD_STATUS:String = "statusValue";
      
      private var mUserAlliance:Alliance;
      
      private var mAllianceController:AlliancesControllerStar;
      
      public function EAllianceHeadQuarter()
      {
         super();
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
      }
      
      override protected function extendedDestroy() : void
      {
         var container:ESprite = getContent("progressBar");
         ETooltipMng.getInstance().destroyTooltipFromContainer(container);
         super.extendedDestroy();
      }
      
      public function build() : void
      {
         var textStatus:String = null;
         var value:Number = NaN;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("LayoutBodyAllianceHeadQuarter");
         this.mUserAlliance = InstanceMng.getAlliancesController().getMyAlliance();
         var img:EImage = viewFactory.getEImage("generic_box",null,false,layoutFactory.getArea("area_info"));
         setContent("infoBkg",img);
         eAddChild(img);
         var field:ETextField;
         (field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_title_info"),"text_header")).setText(DCTextMng.getText(2794));
         setContent("titleInfo",field);
         eAddChild(field);
         var flag:ESpriteContainer = AlliancesControllerStar(InstanceMng.getAlliancesController()).getAllianceFlag(this.mUserAlliance.getLogo()[0],this.mUserAlliance.getLogo()[1],this.mUserAlliance.getLogo()[2],layoutFactory.getArea("img"));
         setContent("flag",flag);
         eAddChild(flag);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_name_alliance"),"text_header");
         setContent("labelAllianceName",field);
         eAddChild(field);
         field.setText(DCTextMng.getText(2795));
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_name_alliance_value"),"text_body_2");
         setContent("AllianceNameValue",field);
         eAddChild(field);
         field.setText(this.mUserAlliance.getName());
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_general"),"text_header");
         setContent("labelGeneral",field);
         eAddChild(field);
         field.setText(DCTextMng.getText(2796));
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_general_value"),"text_body_2");
         setContent("generalValue",field);
         eAddChild(field);
         field.setText(this.mUserAlliance.getLeader().getName());
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_members"),"text_header");
         setContent("labelmembers",field);
         eAddChild(field);
         field.setText(DCTextMng.getText(2797));
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_members_value"),"text_body_2");
         setContent("membersValue",field);
         eAddChild(field);
         field.setText(this.mUserAlliance.getTotalMembers() + "/" + InstanceMng.getAlliancesSettingsDefMng().getMaxAllianceMembers());
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_stats"),"text_header");
         setContent("labelstatus",field);
         eAddChild(field);
         field.setText(DCTextMng.getText(3042));
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_stats_value"),"text_body_2");
         setContent("statusValue",field);
         eAddChild(field);
         switch(this.mUserAlliance.getAllianceState())
         {
            case 0:
               textStatus = DCTextMng.getText(3043);
               break;
            case 2:
               textStatus = DCTextMng.getText(3044);
               field.setTextColor(this.STATUS_COLOR_GREEN);
         }
         field.setText(textStatus);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_description_value"),"text_body_2");
         setContent("descriptionField",field);
         eAddChild(field);
         field.setText(this.mUserAlliance.getDescription());
         var buttonArea:ELayoutArea = layoutFactory.getArea("btn_cancel");
         var button:EButton = viewFactory.getButtonByTextWidth(DCTextMng.getText(2806),buttonArea.width,"btn_cancel");
         setContent("leaveButton",button);
         eAddChild(button);
         button.layoutApplyTransformations(buttonArea);
         button.eAddEventListener("click",this.onLeaveAlliance);
         if(AlliancesConstants.canRoleInvitePeople(this.mAllianceController.getMyUser().getRole()))
         {
            buttonArea = layoutFactory.getArea("btn_invite");
            button = viewFactory.getButtonByTextWidth(DCTextMng.getText(2810),buttonArea.width,"btn_social",null,null,null,buttonArea);
            setContent("invite",button);
            eAddChild(button);
            button.eAddEventListener("click",this.onInvite);
            if(this.mAllianceController.getMyAlliance().isInAWar())
            {
               button.setIsEnabled(false);
            }
            button.visible = false;
         }
         if(AlliancesConstants.canRoleDoActionsOverMembers(this.mAllianceController.getMyUser().getRole()))
         {
            button = viewFactory.getButtonImage("btn_edit",null,layoutFactory.getArea("icon_edit"));
            setContent("editButton",button);
            eAddChild(button);
            button.eAddEventListener("click",this.onEditClick);
         }
         img = viewFactory.getEImage("generic_box",null,false,layoutFactory.getArea("area_alliance_stadistics"));
         setContent("statisticsBkg",img);
         eAddChild(img);
         (field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_alliance"),"text_header")).setText(DCTextMng.getText(2798));
         setContent("titleStatitstics",field);
         eAddChild(field);
         var container:ESpriteContainer = this.getProgressBar();
         setContent("progressBar",container);
         eAddChild(container);
         container.setLayoutArea(layoutFactory.getArea("icon_bar_xs"),true);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_position"),"text_header");
         setContent("text_position",field);
         eAddChild(field);
         field.setText(DCTextMng.getText(2799));
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_position_value"),"text_body_2");
         setContent("text_position_value",field);
         eAddChild(field);
         field.setText((this.mUserAlliance.getRank() + 1).toString());
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_victories"),"text_header");
         setContent("warsWonTitle",field);
         eAddChild(field);
         field.setText(DCTextMng.getText(2800));
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_victories_value"),"text_body_2");
         setContent("warsWonValue",field);
         eAddChild(field);
         field.setText(DCTextMng.convertNumberToString(this.mUserAlliance.getWarsWon(),1,8));
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_defeats"),"text_header");
         setContent("warslostTitle",field);
         eAddChild(field);
         field.setText(DCTextMng.getText(2801));
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_defeats_value"),"text_body_2");
         setContent("warslostValue",field);
         eAddChild(field);
         field.setText(DCTextMng.convertNumberToString(this.mUserAlliance.getWarsLost(),1,8));
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_ratio"),"text_header");
         setContent("ratioTitle",field);
         eAddChild(field);
         field.setText(DCTextMng.getText(2843));
         var total:Number;
         if((total = this.mUserAlliance.getWarsLost() + this.mUserAlliance.getWarsWon()) > 0)
         {
            value = this.mUserAlliance.getWarsWon() * 100 / total;
         }
         else
         {
            value = 0;
         }
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_ratio_value"),"text_body_2");
         setContent("ratioValue",field);
         eAddChild(field);
         field.setText(DCTextMng.convertNumberToStringWithDecimals(value,2) + "%");
         img = viewFactory.getEImage("generic_box",null,false,layoutFactory.getArea("area_player_stadistics"));
         setContent("playerStatsBkg",img);
         eAddChild(img);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_player"),"text_header");
         setContent("playerStatsTitle",field);
         eAddChild(field);
         field.setText(DCTextMng.getText(2803));
         var user:AlliancesUser = InstanceMng.getAlliancesController().getMyUser();
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_name"),"text_body_2");
         setContent("playerName",field);
         eAddChild(field);
         field.setText(user.getName());
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_range"),"text_body_2");
         setContent("playerPosition",field);
         eAddChild(field);
         field.setText(user.getRoleAsText());
         var boxes:Array = [];
         var points:String = InstanceMng.getUserInfoMng().getProfileLogin().getLevel().toString();
         container = viewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_score_level",points,null,"text_body_2");
         setContent("playerLevel",container);
         eAddChild(container);
         boxes.push(container);
         points = DCTextMng.convertNumberToString(user.getScore(),1,8);
         container = viewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_user_warpoints",points,null,"text_body_2");
         setContent("playerwarpoints",container);
         eAddChild(container);
         boxes.push(container);
         viewFactory.distributeSpritesInArea(layoutFactory.getArea("icon_text_xs"),boxes,0,1,1,2,true);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_title_members"),"text_header");
         setContent("text_title_members",field);
         eAddChild(field);
         field.setText(DCTextMng.getText(2807));
         var scrollArea:EScrollArea;
         (scrollArea = new EScrollArea()).build(layoutFactory.getArea("area_members"),this.mUserAlliance.getTotalMembers(),ESpriteContainer,this.loadMemberStripes);
         viewFactory.getEScrollBar(scrollArea);
         setContent("scrollArea",scrollArea);
         eAddChild(scrollArea);
      }
      
      private function getProgressBar() : ESpriteContainer
      {
         var OFFSET:int = 6;
         var viewFactory:ViewFactory;
         var container:ESpriteContainer = (viewFactory = InstanceMng.getViewFactory()).getESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("ProductionBar");
         var allianceLevel:String = InstanceMng.getAlliancesLevelDefMng().getLevelFromScore(this.mUserAlliance.getScore());
         var fillbarArea:ELayoutArea = layoutFactory.getArea("bar");
         var fillbar:EFillBar = viewFactory.createFillBar(0,fillbarArea.width,fillbarArea.height,0,"color_fill_bkg");
         container.setContent("fillbarBkg",fillbar);
         container.eAddChild(fillbar);
         fillbar.layoutApplyTransformations(fillbarArea);
         var levelDef:AlliancesLevelDef = InstanceMng.getAlliancesLevelDefMng().getDefBySku(allianceLevel) as AlliancesLevelDef;
         fillbar = viewFactory.createFillBar(1,fillbarArea.width - OFFSET,fillbarArea.height - OFFSET,levelDef.getMaxScore() - levelDef.getMinScore(),"color_yellow");
         container.setContent("fillbar",fillbar);
         container.eAddChild(fillbar);
         fillbarArea.centerContent(fillbar);
         fillbar.setValue(this.mUserAlliance.getScore() - levelDef.getMinScore());
         var icon:EImage = viewFactory.getEImage("icon_alliance_level",null,true,layoutFactory.getArea("icon"));
         container.setContent("icon",icon);
         container.eAddChild(icon);
         var field:ETextField;
         (field = viewFactory.getETextField(null,layoutFactory.getTextArea("text"),"text_title_3")).setText(allianceLevel);
         container.setContent("allianceLevel",field);
         container.eAddChild(field);
         container.mouseChildren = false;
         var score:Number = this.mUserAlliance.getScore();
         var nextScore:Number = InstanceMng.getAlliancesLevelDefMng().getMaxScoreByScore(score);
         var text:String = DCTextMng.replaceParameters(3021,[DCTextMng.convertNumberToString(score,-1,-1),DCTextMng.convertNumberToString(nextScore,-1,-1)]);
         ETooltipMng.getInstance().createTooltipInfoFromText(text,container,null,true,false);
         return container;
      }
      
      private function printShieldText() : void
      {
         var textStatus:String = null;
         var field:ETextField = null;
         if(this.mUserAlliance != null)
         {
            textStatus = DCTextMng.replaceParameters(3045,[DCTextMng.convertTimeToStringColon(this.mUserAlliance.getPostWarShieldTimeLeft())]);
            field = getContentAsETextField("statusValue");
            if(field != null)
            {
               field.setTextColor(this.STATUS_COLOR_RED);
               field.setText(textStatus);
            }
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mUserAlliance != null && this.mUserAlliance.getAllianceState() == 1)
         {
            this.printShieldText();
         }
         var scrollArea:EScrollArea = getContent("scrollArea") as EScrollArea;
         if(scrollArea != null)
         {
            if(scrollArea.getScrollBar().hasDraggedThisStep())
            {
               this.closeActionsTooltip();
            }
         }
      }
      
      private function closeActionsTooltip() : void
      {
         EPopupAlliances(this.mAllianceController.getPopupAlliance()).closeActionsTooltip();
      }
      
      private function loadMemberStripes(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var stripe:EAllianceMemberMyAlliance = null;
         if(rebuild)
         {
            (stripe = new EAllianceMemberMyAlliance("buttonAction")).build();
            spriteReference.eAddChild(stripe);
            spriteReference.setContent("stripe",stripe);
         }
         (stripe = spriteReference.getChildAt(0) as EAllianceMemberMyAlliance).setInfo(this.mUserAlliance.getMemberByIndex(rowOffset));
      }
      
      private function leaveAlliance(e:EEvent) : void
      {
         this.mAllianceController.leaveMyAlliance(this.onLeaveSuccess,this.onLeaveFailed);
      }
      
      private function onLeaveAlliance(e:EEvent) : void
      {
         this.closeActionsTooltip();
         var title:String = DCTextMng.getText(3003);
         var body:String = DCTextMng.getText(2871);
         var button:EButton = InstanceMng.getViewFactory().getButtonCancel(null,null,DCTextMng.getText(2806));
         InstanceMng.getNotificationsMng().guiOpenMessagePopupWithButton("leaveAlliance",title,body,button,"alliance_council_happy",this.leaveAlliance,false,true);
      }
      
      private function onLeaveSuccess(ae:AlliancesAPIEvent) : void
      {
         EPopupAlliances(this.mAllianceController.getPopupAlliance()).reloadPopup();
      }
      
      private function onLeaveFailed(ae:AlliancesAPIEvent) : void
      {
         this.mAllianceController.throwErrorMessage(ae.getErrorTitle(),ae.getErrorMsg());
      }
      
      private function onEditClick(e:EEvent) : void
      {
         this.closeActionsTooltip();
         this.mAllianceController.guiOpenEditAlliancePopup();
      }
      
      private function onInvite(e:EEvent) : void
      {
         this.closeActionsTooltip();
         InstanceMng.getAlliancesController().inviteFriends(true);
      }
   }
}
