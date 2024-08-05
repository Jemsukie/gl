package com.dchoc.game.eview.widgets.hud
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class EHudProfileBasicView extends ESpriteContainer
   {
      
      public static const PLAYER_NAME:String = "text_name";
      
      public static const IMAGE:String = "img";
      
      public static const LEVEL:String = "container_icon_text";
       
      
      public function EHudProfileBasicView()
      {
         super();
         this.build();
      }
      
      final private function build() : void
      {
         var s:ESprite = null;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ProfileBasic");
         var thumbnailURL:String = null;
         var playerName:String = "";
         s = viewFactory.getEImage("box_profile",null,false,layoutFactory.getArea("container_box"),null);
         this.eAddChild(s);
         this.setContent("container_box",s);
         s = viewFactory.getEImageProfileFromURL(thumbnailURL,null,null);
         s.setLayoutArea(layoutFactory.getArea("img"),true);
         this.eAddChild(s);
         this.setContent("img",s);
         s = viewFactory.getETextField(null,layoutFactory.getTextArea("text_name"),"text_title_3");
         this.eAddChild(s);
         this.setContent("text_name",s);
      }
      
      public function setUserInfo(userInfo:UserInfo) : void
      {
         var viewFactory:ViewFactory = null;
         var layoutFactory:ELayoutAreaFactory = null;
         var s:ESprite = null;
         var playerName:String = null;
         var thumbnailURL:String = null;
         var level:String = null;
         var levelContainer:ESpriteContainer = null;
         var img:EImage = null;
         var area:ELayoutArea = null;
         if(userInfo)
         {
            playerName = userInfo.getPlayerFirstName();
            thumbnailURL = userInfo.getThumbnailURL();
            level = userInfo.getLevel().toString();
            layoutFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ProfileBasic");
            (s = viewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_score_level",level,null,"text_score",true,false)).setLayoutArea(layoutFactory.getArea("container_icon_text"),true);
            this.eAddChild(s);
            this.setContent("container_icon_text",s);
            getContentAsETextField("text_name").setText(playerName);
            (levelContainer = getContentAsESpriteContainer("container_icon_text")).getContentAsETextField("text").setText(level);
            levelContainer.getContentAsETextField("text").autoSize(true);
            levelContainer.layoutApplyTransformations(levelContainer.getLayoutArea());
            DCDebug.traceCh("players","player name: " + playerName + " is npc: " + userInfo.mIsNPC.value);
            img = getContentAsEImage("img");
            area = img.getLayoutArea();
            if(userInfo.mIsNPC.value)
            {
               img = viewFactory.getEImage(userInfo.getThumbnailURL(),null,false);
            }
            else
            {
               img = viewFactory.getEImageProfileFromURL(userInfo.getThumbnailURL(),null,null);
            }
            setContent("img",img);
            eAddChild(img);
            img.setLayoutArea(area,true);
         }
      }
      
      public function setBasicUserInfo(userName:String, userPic:String, level:String) : void
      {
         var playerName:String = String(userName.split(" ")[0]);
         getContentAsETextField("text_name").setText(playerName);
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ProfileBasic");
         var s:ESprite;
         (s = viewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_score_level",level,null,"text_score",true,false)).setLayoutArea(layoutFactory.getArea("container_icon_text"),true);
         this.eAddChild(s);
         this.setContent("container_icon_text",s);
         var levelContainer:ESpriteContainer = getContentAsESpriteContainer("container_icon_text");
         if(level != null)
         {
            levelContainer.getContentAsETextField("text").setText(level);
            levelContainer.getContentAsETextField("text").autoSize(true);
            levelContainer.layoutApplyTransformations(levelContainer.getLayoutArea());
         }
         else
         {
            levelContainer.visible = false;
         }
         if(userPic.indexOf("npc") > -1)
         {
            InstanceMng.getViewFactory().setTextureToImage(userPic,null,getContentAsEImage("img"));
         }
         else
         {
            InstanceMng.getViewFactory().setTextureToImageFromURL(userPic,getContentAsEImage("img"),null,null);
         }
      }
   }
}
