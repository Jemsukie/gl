package com.dchoc.game.eview.popups.options
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.inventory.EInventoryItemView;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.widgets.EButton;
   
   public class ESkinItemView extends EInventoryItemView
   {
      
      public static const SKIN_BTN:String = "shareButton";
       
      
      private var mGroupSku:String;
      
      private var nextSkin:String;
      
      private var setButton:EButton;
      
      public function ESkinItemView()
      {
         super();
      }
      
      public function buildSkinItem(nextSkinSku:String, skinTitle:String, skinDesc:String, layoutName:String = null) : void
      {
         this.setNextSkin(nextSkinSku);
         if(layoutName == null)
         {
            layoutName = "SkinInventoryBox";
         }
         mViewFactory = InstanceMng.getViewFactory();
         mSkinSku = InstanceMng.getSkinsMng().getCurrentSkinSku();
         mLayout = mViewFactory.getLayoutAreaFactory(layoutName);
         setLayoutArea(mLayout.getAreaWrapper());
         this.createBkg();
         this.createImage();
         this.createSkinTitle(skinTitle);
         this.createSkinDesc(skinDesc);
         this.createActionButton();
      }
      
      override protected function createBkg() : void
      {
         var image:EImage = mViewFactory.getEImage("box_inventory",mSkinSku,true,mLayout.getArea("container_box_skin"));
         eAddChild(image);
         setContent("container_box_skin",image);
      }
      
      override protected function createImage() : void
      {
         var image:EImage = mViewFactory.getEImage(this.getNextSkin() + "_pres",mSkinSku,true,mLayout.getArea("img_skin"));
         eAddChild(image);
         setContent("img_skin",image);
      }
      
      override protected function createActionButton() : void
      {
         var buttonArea:ELayoutArea = mLayout.getArea("ibtn_xs");
         this.setButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(710),buttonArea.width,"btn_social");
         eAddChild(this.setButton);
         setContent("ibtn_xs",this.setButton);
         this.setButton.eAddEventListener("click",this.changeSkinTo);
         this.setButton.layoutApplyTransformations(buttonArea);
         this.updateActionButton();
      }
      
      protected function createSkinDesc(SkinDesc:String) : void
      {
         var skinDesc:ETextField = mViewFactory.getETextField(mSkinSku,mLayout.getTextArea("skin_desc"));
         skinDesc.setText(SkinDesc);
         skinDesc.applySkinProp(mSkinSku,"text_title_3");
         eAddChild(skinDesc);
         setContent("skin_desc",skinDesc);
      }
      
      private function setNextSkin(nextSkinSet:String) : void
      {
         this.nextSkin = nextSkinSet;
      }
      
      private function getNextSkin() : String
      {
         return this.nextSkin;
      }
      
      protected function createSkinTitle(SkinTitle:String) : void
      {
         var skinTitle:ETextField = mViewFactory.getETextField(mSkinSku,mLayout.getTextArea("skin_title"));
         skinTitle.setText(SkinTitle);
         skinTitle.applySkinProp(mSkinSku,"text_title_3");
         eAddChild(skinTitle);
         setContent("skin_title",skinTitle);
      }
      
      private function updateActionButton() : void
      {
         if(this.setButton)
         {
            this.setButton.setIsEnabled(InstanceMng.getSkinsMng().getCurrentSkinSku() != this.getNextSkin());
         }
      }
      
      protected function changeSkinTo(evt:EEvent) : void
      {
         InstanceMng.getSkinsMng().changeSkin(this.getNextSkin());
         InstanceMng.getUserInfoMng().getProfileLogin().setSkin(this.getNextSkin());
         this.updateActionButton();
      }
   }
}
