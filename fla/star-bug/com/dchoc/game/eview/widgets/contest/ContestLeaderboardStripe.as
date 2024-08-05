package com.dchoc.game.eview.widgets.contest
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.contest.ContestUser;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class ContestLeaderboardStripe extends ESpriteContainer
   {
      
      private static const POSITION:String = "position";
      
      private static const USER_NAME:String = "userName";
      
      private static const USER_PHOTO:String = "userPhoto";
      
      private static const ENTRY_CONTAINER:String = "entryContainer";
      
      private static const BACKGROUND:String = "background";
       
      
      private var mViewFactory:ViewFactory;
      
      private var mSkinSku:String;
      
      private var mContestUser:ContestUser;
      
      private var mTextProp:String;
      
      public function ContestLeaderboardStripe(viewFactory:ViewFactory, skinSku:String)
      {
         super();
         this.mViewFactory = viewFactory;
         this.mSkinSku = skinSku;
      }
      
      public function setup(contestUser:ContestUser, textureName:String) : void
      {
         this.mContestUser = contestUser;
         this.mTextProp = "text_title_2";
         if(this.mContestUser.getIsMe())
         {
            this.mTextProp = "text_positive";
         }
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("StripeContestLeaderboard");
         var bkg:EImage = this.mViewFactory.getEImage(textureName,this.mSkinSku,false,layoutFactory.getArea("stripe"));
         eAddChild(bkg);
         setLayoutArea(layoutFactory.getArea("stripe"));
         setContent("background",bkg);
         var field:ETextField;
         (field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_number"))).setText(contestUser.getRank().toString());
         eAddChild(field);
         setContent("position",field);
         field.applySkinProp(this.mSkinSku,this.mTextProp);
         (field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_name"))).setText(contestUser.getName());
         eAddChild(field);
         setContent("userName",field);
         field.applySkinProp(this.mSkinSku,this.mTextProp);
         var pict:EImage;
         (pict = this.mViewFactory.getEImageProfileFromURL(contestUser.getPicUrl(),this.mSkinSku,null)).layoutApplyTransformations(layoutFactory.getArea("img_profile"));
         pict.applySkinProp(this.mSkinSku,"stroke_color");
         eAddChild(pict);
         setContent("userPhoto",pict);
         var container:ESpriteContainer = this.mViewFactory.getContentIconWithTextHorizontal("IconTextS",InstanceMng.getContestMng().getProgressIcon(),contestUser.getScore().toString(),this.mSkinSku);
         var area:ELayoutArea = layoutFactory.getArea("container_icon_text_m");
         this.mViewFactory.distributeSpritesInArea(area,[container],2,1,1,1);
         eAddChild(container);
         setContent("entryContainer",container);
         (field = container.getContent("text") as ETextField).applySkinProp(this.mSkinSku,this.mTextProp);
         container.logicLeft += area.x;
         container.logicTop += area.y;
      }
      
      public function getIsMe() : Boolean
      {
         return this.mContestUser != null && this.mContestUser.getIsMe();
      }
   }
}
