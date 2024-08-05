package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EAllianceBoxLeaderboard extends ESpriteContainer
   {
       
      
      private const RANK:String = "rank";
      
      private const NAME:String = "name";
      
      private const MEMBERS:String = "members";
      
      private const VICTORIES:String = "victories";
      
      private const DECLARE_WAR_BUTTON_GREEN:String = "declareWarButtonGreen";
      
      private const DECLARE_WAR_BUTTON_RED:String = "declareWarButtonRed";
      
      private var mAlliance:Alliance;
      
      private var mAllianceController:AlliancesControllerStar;
      
      public function EAllianceBoxLeaderboard()
      {
         super();
      }
      
      public function build() : void
      {
         var buttonArea:ELayoutArea = null;
         var button:EButton = null;
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("StripeAlliancesLeaderBoard");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var field:ETextField = viewFactory.getETextField(null,layoutFactory.getTextArea("text_number"),"text_subheader");
         eAddChild(field);
         setContent("rank",field);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_name"),"text_leaderboard");
         eAddChild(field);
         setContent("name",field);
         viewFactory.setTextFieldClickableBehaviors(field);
         field.eAddEventListener("click",this.onAllianceClick);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_value"),"text_leaderboard");
         eAddChild(field);
         setContent("victories",field);
         if(!Config.useAlliancesSuggested())
         {
            buttonArea = layoutFactory.getArea("btn");
            button = viewFactory.getButtonByTextWidth(DCTextMng.getText(2852),buttonArea.width,"btn_can_attack",null,null);
            eAddChild(button);
            setContent("declareWarButtonGreen",button);
            button.layoutApplyTransformations(buttonArea);
            button.eAddEventListener("click",this.onDeclareWarGreen);
            button = viewFactory.getButtonByTextWidth(DCTextMng.getText(2852),buttonArea.width,"btn_cant_attack",null,null);
            eAddChild(button);
            setContent("declareWarButtonRed",button);
            button.layoutApplyTransformations(buttonArea);
            button.eAddEventListener("click",this.onDeclareWarRed);
         }
      }
      
      public function setInfo(info:Alliance) : void
      {
         var viewFactory:ViewFactory = null;
         var layoutFactory:ELayoutAreaFactory = null;
         var itsMyAlli:* = false;
         var resource:String = null;
         var bkg:EImage = null;
         var img:ESprite = null;
         var field:ETextField = null;
         var totalWars:int = 0;
         var level:String = null;
         var content:ESpriteContainer = null;
         var allianceScore:String = null;
         var tooltipText:String = null;
         if(info != null)
         {
            this.mAlliance = info;
            layoutFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("StripeAlliancesLeaderBoard");
            if(itsMyAlli = this.mAlliance.getId() == this.mAllianceController.getMyAlliance().getId())
            {
               resource = "stripe_player";
            }
            else if(info.getRank() == 1)
            {
               resource = "stripe_1";
            }
            else if(info.getRank() == 2)
            {
               resource = "stripe_2";
            }
            else if(info.getRank() == 3)
            {
               resource = "stripe_3";
            }
            else
            {
               resource = "stripe";
            }
            bkg = viewFactory.getEImage(resource,null,false,layoutFactory.getArea("stripe"));
            eAddChildAt(bkg,0);
            setContent("bkg",bkg);
            img = AlliancesControllerStar(InstanceMng.getAlliancesController()).getAllianceFlag(info.getLogo()[0],info.getLogo()[1],info.getLogo()[2],layoutFactory.getArea("img_profile"));
            eAddChild(img);
            setContent("flag",img);
            img.buttonMode = true;
            img.mouseChildren = false;
            viewFactory.setButtonBehaviors(img);
            img.eAddEventListener("click",this.onAllianceClick);
            (field = getContentAsETextField("rank")).setText(info.getRank().toString());
            (field = getContentAsETextField("name")).setText(info.getName());
            if(itsMyAlli)
            {
               field.applySkinProp(null,"text_color_positive");
            }
            else
            {
               field.applySkinProp(null,"text_leaderboard");
            }
            totalWars = info.getWarsLost() + info.getWarsWon();
            (field = getContentAsETextField("victories")).setText(info.getWarsWon() + "/" + totalWars);
            if(itsMyAlli)
            {
               field.applySkinProp(null,"text_color_positive");
            }
            else
            {
               field.applySkinProp(null,"text_leaderboard");
            }
            level = InstanceMng.getAlliancesLevelDefMng().getLevelFromScore(this.mAlliance.getScore());
            (content = viewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_alliance_level",level,null,"text_body")).getContent("text").applySkinProp(null,"stroke_color");
            layoutFactory.getArea("icon_text").centerContent(content);
            eAddChild(content);
            setContent("levelIcon",content);
            allianceScore = DCTextMng.convertNumberToString(this.mAlliance.getScore(),1,8);
            if(Config.useAlliancesSuggested())
            {
               content = viewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_user_warpoints",allianceScore,null,"text_body");
               layoutFactory.getArea("btn").centerContent(content);
               content.logicLeft = layoutFactory.getArea("btn").x;
               eAddChild(content);
               setContent("allianceScore",content);
               ETooltipMng.getInstance().createTooltipInfoFromText(DCTextMng.getText(2813),content,null,true,false);
            }
            else
            {
               tooltipText = DCTextMng.replaceParameters(3039,[allianceScore]);
               ETooltipMng.getInstance().createTooltipInfoFromText(tooltipText,content,null,true,false);
               if(this.mAlliance.getId() == this.mAllianceController.getMyAlliance().getId())
               {
                  getContent("declareWarButtonGreen").visible = false;
                  getContent("declareWarButtonRed").visible = false;
               }
               else if(AlliancesConstants.canRoleDeclareWar(this.mAllianceController.getMyUser().getRole()) && !this.mAllianceController.getMyAlliance().isInAWar() && this.mAlliance.canBeDeclaredAWarAgainst())
               {
                  getContent("declareWarButtonGreen").visible = true;
                  getContent("declareWarButtonRed").visible = false;
               }
               else
               {
                  getContent("declareWarButtonGreen").visible = false;
                  getContent("declareWarButtonRed").visible = true;
               }
            }
         }
      }
      
      private function onDeclareWarGreen(e:EEvent) : void
      {
         this.mAllianceController.createDeclareWarEvent(this.mAlliance.getId(),this.mAlliance.getName());
      }
      
      private function onDeclareWarRed(e:EEvent) : void
      {
         var bodyText:String = null;
         var title:String = DCTextMng.getText(2932);
         if(!AlliancesConstants.canRoleDeclareWar(InstanceMng.getAlliancesController().getMyUser().getRole()))
         {
            title = DCTextMng.getText(2930);
            bodyText = DCTextMng.getText(2931);
         }
         else if(InstanceMng.getAlliancesController().getMyAlliance().isInAWar())
         {
            bodyText = DCTextMng.getText(2933);
         }
         else if(this.mAlliance.getPostWarShieldTimeLeft() > 0)
         {
            bodyText = AlliancesConstants.getErrorMsg(17);
         }
         else
         {
            bodyText = DCTextMng.getText(2942);
         }
         this.mAllianceController.throwErrorMessage(title,bodyText);
      }
      
      private function onAllianceClick(e:EEvent) : void
      {
         this.mAllianceController.guiOpenPopupAllianceMembers(this.mAlliance,this);
      }
   }
}
