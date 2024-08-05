package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class EAllianceWarMember extends ESpriteContainer
   {
       
      
      private const PLAYER_NAME:String = "player_name";
      
      private const PLAYER_RANGE:String = "player_range";
      
      private const LAYOUT_FACTORY:String = "ContainerStripeXS";
      
      public function EAllianceWarMember()
      {
         super();
      }
      
      public function build() : void
      {
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ContainerStripeXS");
         var img:EImage = viewFactory.getEImage("stripe",null,false,layoutFactory.getArea("stripe_xs_base"));
         setContent("bkg",img);
         eAddChild(img);
         var field:ETextField = viewFactory.getETextField(null,layoutFactory.getTextArea("text_name"),"text_body_2");
         setContent("player_name",field);
         eAddChild(field);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_range"),"text_body_2");
         setContent("player_range",field);
         eAddChild(field);
      }
      
      public function setInfo(info:AlliancesUser) : void
      {
         var viewFactory:ViewFactory = null;
         var layoutFactory:ELayoutAreaFactory = null;
         var img:EImage = null;
         var field:ETextField = null;
         var boxes:Array = null;
         var points:String = null;
         var container:ESpriteContainer = null;
         this.build();
         if(info != null)
         {
            layoutFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ContainerStripeXS");
            (img = viewFactory.getEImageProfileFromURL(info.getPictureUrl(),null,null)).layoutApplyTransformations(layoutFactory.getArea("img"));
            setContent("memeberPicture",img);
            eAddChild(img);
            (field = getContentAsETextField("player_name")).setText(info.getName());
            (field = getContentAsETextField("player_range")).setText(info.getRoleAsText());
            boxes = [];
            points = info.getGameLevel().toString();
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
   }
}
