package com.dchoc.game.eview.popups.messages
{
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class EPopupMessageIcons extends EPopupMessage
   {
      
      private static const ICONS_CONTAINER:String = "iconsContainer";
      
      private static const HELP_TEXT:String = "text_title";
       
      
      private var mIcons:Array;
      
      public function EPopupMessageIcons(layoutName:String = null, layoutAreaFactoryName:String = null, layoutBackgroundResourceName:String = null)
      {
         if(layoutName == null)
         {
            layoutName = "PopNotificationsIcons";
         }
         if(layoutAreaFactoryName == null)
         {
            layoutAreaFactoryName = "PopM";
         }
         if(layoutBackgroundResourceName == null)
         {
            layoutBackgroundResourceName = "pop_m";
         }
         super(layoutName,layoutAreaFactoryName,layoutBackgroundResourceName);
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.destroyIcons();
      }
      
      private function destroyIcons() : void
      {
         var icon:ESprite = null;
         if(this.mIcons != null)
         {
            while(this.mIcons.length > 0)
            {
               icon = this.mIcons.shift();
               icon.destroy();
            }
            this.mIcons = null;
         }
      }
      
      public function setupIcons(icons:Array, cols:int = -1) : void
      {
         var container:ESprite = null;
         var icon:ESprite = null;
         var layoutFactory:ELayoutAreaFactory = null;
         var rows:int = 0;
         var area:ELayoutArea = null;
         var body:ESprite = null;
         if(this.mIcons != null)
         {
            this.destroyIcons();
         }
         this.mIcons = icons;
         if(this.mIcons != null && this.mIcons.length > 0)
         {
            container = mViewFactory.getESprite(mSkinSku);
            setContent("iconsContainer",container);
            for each(icon in this.mIcons)
            {
               container.eAddChild(icon);
            }
            layoutFactory = mViewFactory.getLayoutAreaFactory(mLayoutName);
            rows = cols == -1 ? 1 : -1;
            area = layoutFactory.getArea("container_text_icon");
            mViewFactory.distributeSpritesInArea(area,icons,1,1,cols,rows,false,10);
            container.logicLeft = area.x;
            container.logicTop = area.y;
            (body = getContent("Body")).eAddChild(container);
         }
      }
      
      protected function setText(text:String) : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory(mLayoutName);
         var textField:ETextField = getContentAsETextField("text_title");
         if(!textField)
         {
            textField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title"),"text_body");
            getContent("Body").eAddChild(textField);
            setContent("text_title",textField);
         }
         textField.setText(text);
      }
   }
}
