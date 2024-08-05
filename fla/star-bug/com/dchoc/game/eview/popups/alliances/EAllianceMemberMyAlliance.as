package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EAllianceMemberMyAlliance extends ESpriteContainer
   {
      
      public static const TYPE_NO_BUTTON:String = "nobutton";
      
      public static const TYPE_BUTTON_SPY:String = "buttonSpy";
      
      public static const TYPE_BUTTON_ACTION:String = "buttonAction";
       
      
      private const PLAYER_NAME:String = "player_name";
      
      private const PLAYER_RANGE:String = "player_range";
      
      private const LAYOUT_FACTORY:String = "ContainerStripeSHigher";
      
      private var mUserIsAdmin:Boolean;
      
      private var mMember:AlliancesUser;
      
      private var mAllianceController:AlliancesControllerStar;
      
      private var mType:String;
      
      public function EAllianceMemberMyAlliance(type:String)
      {
         super();
         this.mType = type;
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
      }
      
      public function build() : void
      {
         var buttonText:String = null;
         var buttonArea:ELayoutArea = null;
         var button:EButton = null;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ContainerStripeSHigher");
         var field:ETextField = viewFactory.getETextField(null,layoutFactory.getTextArea("text_name"),"text_body_2");
         setContent("player_name",field);
         eAddChild(field);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_range"),"text_body_2");
         setContent("player_range",field);
         eAddChild(field);
         if(this.mType != "nobutton")
         {
            this.mUserIsAdmin = AlliancesConstants.canRoleDoActionsOverMembers(InstanceMng.getAlliancesController().getMyUser().getRole());
            if(this.mType == "buttonAction")
            {
               if(this.mUserIsAdmin)
               {
                  buttonText = DCTextMng.getText(2820);
               }
               else
               {
                  buttonText = DCTextMng.getText(2821);
               }
            }
            else
            {
               buttonText = DCTextMng.getText(144);
            }
            buttonArea = layoutFactory.getArea("btn");
            button = viewFactory.getButtonByTextWidth(buttonText,buttonArea.width,"btn_accept");
            setContent("actionButton",button);
            eAddChild(button);
            button.eAddEventListener("click",this.onActionButtonClick);
            button.layoutApplyTransformations(buttonArea);
            if(this.mType == "buttonAction")
            {
               button.visible = false;
            }
         }
      }
      
      public function setInfo(info:AlliancesUser) : void
      {
         var myUser:AlliancesUser = null;
         var viewFactory:ViewFactory = null;
         var layoutFactory:ELayoutAreaFactory = null;
         var itsMe:Boolean = false;
         var resource:String = null;
         var img:EImage = null;
         var field:ETextField = null;
         var boxes:Array = null;
         var points:String = null;
         var container:ESpriteContainer = null;
         var button:EButton = null;
         var myAlliance:Alliance = null;
         this.build();
         if(info != null)
         {
            this.mMember = info;
            myUser = this.mAllianceController.getMyUser();
            layoutFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ContainerStripeSHigher");
            if(itsMe = myUser != null && this.mMember.getId() == myUser.getId())
            {
               resource = "stripe_player";
            }
            else
            {
               resource = "stripe";
            }
            img = viewFactory.getEImage(resource,null,false,layoutFactory.getArea("stripe"));
            setContent("bkg",img);
            eAddChildAt(img,0);
            (img = viewFactory.getEImageProfileFromURL(info.getPictureUrl(),null,null)).layoutApplyTransformations(layoutFactory.getArea("img"));
            setContent("memeberPicture",img);
            eAddChild(img);
            (field = getContentAsETextField("player_name")).setText(info.getName());
            if(itsMe)
            {
               field.applySkinProp(null,"text_color_positive");
            }
            (field = getContentAsETextField("player_range")).setText(info.getRoleAsText());
            if(itsMe)
            {
               field.applySkinProp(null,"text_color_positive");
            }
            boxes = [];
            points = DCTextMng.convertNumberToString(this.mMember.getGameLevel(),-1,-1);
            container = viewFactory.getContentIconWithTextHorizontal("IconTextXSLarge","icon_score_level",points,null,"text_body_2");
            if(itsMe)
            {
               (field = container.getContentAsETextField("text")).applySkinProp(null,"text_color_positive");
            }
            setContent("playerLevel",container);
            eAddChild(container);
            boxes.push(container);
            points = DCTextMng.convertNumberToString(this.mMember.getScore(),1,8);
            container = viewFactory.getContentIconWithTextHorizontal("IconTextXSLarge","icon_user_warpoints",points,null,"text_body_2");
            if(itsMe)
            {
               (field = container.getContentAsETextField("text")).applySkinProp(null,"text_color_positive");
            }
            setContent("playerwarpoints",container);
            eAddChild(container);
            boxes.push(container);
            viewFactory.distributeSpritesInArea(layoutFactory.getArea("container_icons_text"),boxes,0,1,2,1,true);
            if(this.mType == "buttonAction")
            {
               button = getContentAsEButton("actionButton");
               myAlliance = InstanceMng.getAlliancesController().getMyAlliance();
               button.visible = myAlliance != null && myAlliance.getId() == info.getAllianceId() && !itsMe;
            }
         }
      }
      
      private function onActionButtonClick(e:EEvent) : void
      {
         var forceSpy:* = false;
         if(!this.mUserIsAdmin || this.mType == "buttonSpy")
         {
            forceSpy = this.mType == "buttonSpy";
            this.mAllianceController.visitUser(this.mMember.getId(),this.mMember.getName(),this.mMember.getPictureUrl(),forceSpy);
         }
         else
         {
            EPopupAlliances(this.mAllianceController.getPopupAlliance()).openActionsTooltip(this,this.mMember);
         }
      }
   }
}
