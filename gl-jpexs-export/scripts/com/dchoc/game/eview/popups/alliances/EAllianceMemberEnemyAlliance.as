package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EAllianceMemberEnemyAlliance extends ESpriteContainer
   {
       
      
      private const PLAYER_NAME:String = "player_name";
      
      private const PLAYER_RANGE:String = "player_range";
      
      private const LAYOUT_FACTORY:String = "ContainerStripeSHigher";
      
      private var mMember:AlliancesUser;
      
      private var mAllianceController:AlliancesControllerStar;
      
      public function EAllianceMemberEnemyAlliance()
      {
         super();
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
      }
      
      public function build() : void
      {
         var buttonText:String = null;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ContainerStripeSHigher");
         var field:ETextField = viewFactory.getETextField(null,layoutFactory.getTextArea("text_name"),"text_body_2");
         setContent("player_name",field);
         eAddChild(field);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_range"),"text_body_2");
         setContent("player_range",field);
         eAddChild(field);
         buttonText = DCTextMng.getText(144);
         var buttonArea:ELayoutArea = layoutFactory.getArea("btn");
         var button:EButton = viewFactory.getButtonByTextWidth(buttonText,buttonArea.width,"btn_accept");
         setContent("actionButton",button);
         eAddChild(button);
         button.eAddEventListener("click",this.onActionButtonClick);
         button.layoutApplyTransformations(buttonArea);
      }
      
      public function setInfo(info:AlliancesUser) : void
      {
         var viewFactory:ViewFactory = null;
         var layoutFactory:ELayoutAreaFactory = null;
         var myUser:AlliancesUser = null;
         var itsMe:Boolean = false;
         var resource:String = null;
         var img:EImage = null;
         var field:ETextField = null;
         var boxes:Array = null;
         var points:String = null;
         var container:ESpriteContainer = null;
         this.build();
         if(info != null)
         {
            this.mMember = info;
            layoutFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ContainerStripeSHigher");
            itsMe = (myUser = this.mAllianceController.getMyUser()) != null && this.mMember.getId() == myUser.getId();
            resource = "stripe";
            img = viewFactory.getEImage(resource,null,false,layoutFactory.getArea("stripe"));
            setContent("bkg",img);
            eAddChildAt(img,0);
            (img = viewFactory.getEImageProfileFromURL(info.getPictureUrl(),null,null)).layoutApplyTransformations(layoutFactory.getArea("img"));
            setContent("memeberPicture",img);
            eAddChild(img);
            (field = getContentAsETextField("player_name")).setText(info.getName());
            (field = getContentAsETextField("player_range")).setText(info.getRoleAsText());
            boxes = [];
            points = DCTextMng.convertNumberToString(this.mMember.getGameLevel(),-1,-1);
            container = viewFactory.getContentIconWithTextHorizontal("IconTextXSLarge","icon_score_level",points,null,"text_body_2");
            setContent("playerLevel",container);
            eAddChild(container);
            boxes.push(container);
            points = DCTextMng.convertNumberToString(info.getCurrentWarScore(),1,8);
            container = viewFactory.getContentIconWithTextHorizontal("IconTextXSLarge","icon_user_warpoints",points,null,"text_body_2");
            setContent("playerwarpoints",container);
            eAddChild(container);
            boxes.push(container);
            viewFactory.distributeSpritesInArea(layoutFactory.getArea("container_icons_text"),boxes,0,1,2,1,true);
         }
      }
      
      private function onActionButtonClick(e:EEvent) : void
      {
         this.mAllianceController.visitUser(this.mMember.getId(),this.mMember.getName(),this.mMember.getPictureUrl(),true);
      }
   }
}
