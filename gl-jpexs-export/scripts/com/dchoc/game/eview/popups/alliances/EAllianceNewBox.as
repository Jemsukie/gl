package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.game.model.alliances.AlliancesNew;
   import com.dchoc.game.model.alliances.AlliancesNewResultWar;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EAllianceNewBox extends ESpriteContainer
   {
       
      
      private var mViewFactory:ViewFactory;
      
      private var mAllianceController:AlliancesControllerStar;
      
      private var mMyAlliance:Alliance;
      
      private var mEnemyAlliance:Alliance;
      
      public function EAllianceNewBox()
      {
         super();
         this.mViewFactory = InstanceMng.getViewFactory();
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
      }
      
      public function setInfo(info:AlliancesNew) : void
      {
         var layoutFactory:ELayoutAreaFactory = null;
         var field:ETextField = null;
         var button:EButton = null;
         var logo:Array = null;
         var content:ESpriteContainer = null;
         var history:AlliancesNewResultWar = null;
         var text:String = null;
         layoutFactory = this.mViewFactory.getLayoutAreaFactory("ContainerStripeL");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var img:EImage = this.mViewFactory.getEImage("stripe",null,false,layoutFactory.getArea("stripe"));
         setContent("background",img);
         eAddChild(img);
         if(info != null)
         {
            (field = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text"),"text_body_2")).setText(info.getMessage());
            setContent("description",field);
            eAddChild(field);
            (field = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text_date"),"text_body_2")).setText(info.getTimeText());
            setContent("date",field);
            eAddChild(field);
            if((field = getContentAsETextField("warScore")) != null)
            {
               field.destroy();
            }
            if((field = getContentAsETextField("warScoreResult")) != null)
            {
               field.destroy();
            }
            button = getContentAsEButton("declareWar");
            if(button != null)
            {
               button.destroy();
            }
            if(info.getLogo() != null)
            {
               logo = info.getLogo().split(",");
            }
            switch(info.getType())
            {
               case 0:
                  content = this.mAllianceController.getAllianceFlag(logo[0],logo[1],logo[2],layoutFactory.getArea("icon"));
                  setContent("picture",content);
                  eAddChild(content);
                  break;
               case 1:
                  img = this.mViewFactory.getEImageProfileFromURL(info.getURL(),null,null);
                  img.setLayoutArea(layoutFactory.getArea("icon"),true);
                  setContent("picture",img);
                  eAddChild(img);
                  break;
               case 2:
                  content = this.mAllianceController.getAllianceFlag(logo[0],logo[1],logo[2],layoutFactory.getArea("icon"));
                  setContent("picture",content);
                  eAddChild(content);
                  if(info.getSubType() == 10 || info.getSubType() == 11)
                  {
                     if(!(history = info as AlliancesNewResultWar).hasIncompleteInformation())
                     {
                        (field = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title"),"text_body_2")).setText(DCTextMng.getText(2813));
                        setContent("warScore",field);
                        eAddChild(field);
                        text = DCTextMng.convertNumberToString(history.getMyScore(),1,8) + "vs" + DCTextMng.convertNumberToString(history.getEnemyScore(),1,8);
                        (field = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text_value"),"text_body_2")).setText(text);
                        setContent("warScoreResult",field);
                        eAddChild(field);
                        if(!Config.useAlliancesSuggested())
                        {
                           this.mAllianceController.requestAllianceById(history.getEnemyAllianceId(),false,this.requestAllianceEnemy,null,true);
                        }
                     }
                     break;
                  }
            }
         }
      }
      
      private function requestAllianceEnemy(ae:AlliancesAPIEvent) : void
      {
         var button:EButton = null;
         var layoutFactory:ELayoutAreaFactory;
         var buttonArea:ELayoutArea = (layoutFactory = this.mViewFactory.getLayoutAreaFactory("ContainerStripeL")).getArea("btn");
         var myUser:AlliancesUser = this.mAllianceController.getMyUser();
         this.mEnemyAlliance = ae.alliance;
         this.mMyAlliance = this.mAllianceController.getMyAlliance();
         if(AlliancesConstants.canRoleDeclareWar(myUser.getRole()) && this.mEnemyAlliance.canBeDeclaredAWarAgainst() && !this.mMyAlliance.isInAWar())
         {
            button = this.mViewFactory.getButtonByTextWidth(DCTextMng.getText(2852),buttonArea.width,"btn_can_attack",null,null);
            button.eAddEventListener("click",this.onDeclareWarGood);
         }
         else
         {
            button = this.mViewFactory.getButtonByTextWidth(DCTextMng.getText(2852),buttonArea.width,"btn_cant_attack",null,null);
            button.eAddEventListener("click",this.onDeclareWarBad);
         }
         eAddChild(button);
         setContent("declareWar",button);
         button.layoutApplyTransformations(buttonArea);
      }
      
      private function onDeclareWarGood(e:EEvent) : void
      {
         this.mAllianceController.createDeclareWarEvent(this.mEnemyAlliance.getId(),this.mEnemyAlliance.getName());
      }
      
      private function onDeclareWarBad(e:EEvent) : void
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
         else if(this.mEnemyAlliance.getPostWarShieldTimeLeft() > 0)
         {
            bodyText = AlliancesConstants.getErrorMsg(17);
         }
         else
         {
            bodyText = DCTextMng.getText(2942);
         }
         this.mAllianceController.throwErrorMessage(title,bodyText);
      }
   }
}
