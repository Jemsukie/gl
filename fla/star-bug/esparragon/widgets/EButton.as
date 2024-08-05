package esparragon.widgets
{
   import esparragon.core.Esparragon;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class EButton extends ESpriteContainer
   {
      
      public static const BACKGROUND_SKU:String = "background";
      
      public static const BACKGROUND_UNSELECTED_SKU:String = "bkgUnselected";
      
      public static const TEXTFIELD_SKU:String = "textField";
      
      private static const ICON_SKU:String = "icon";
      
      private static var mFunnelLabel:String;
      
      private static var mSoundId:String;
       
      
      private var mSelected:Boolean;
      
      private var mUnselectedProp:String;
      
      private var mUnselectedTextProp:String;
      
      private var mRemoveTooltipOnMouseUp:Boolean;
      
      private var mShapeArea:ELayoutArea;
      
      public function EButton(image:EImage, text:ETextField = null, iconImg:EImage = null, soundId:String = null)
      {
         super();
         if(image != null)
         {
            this.setContent("background",image);
            this.eAddChild(image);
         }
         if(iconImg != null)
         {
            this.setContent("icon",iconImg);
            this.eAddChild(iconImg);
         }
         this.setTextField(text);
         this.setSoundId(soundId);
         mouseChildren = false;
         buttonMode = true;
         this.mSelected = true;
         this.mRemoveTooltipOnMouseUp = true;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         if(this.mShapeArea != null && getLayoutArea() != this.mShapeArea)
         {
            this.mShapeArea.destroy();
         }
         this.mShapeArea = null;
      }
      
      override protected function poolReturn() : void
      {
         Esparragon.poolReturnEButton(this);
      }
      
      public function setBackground(image:EImage) : void
      {
         var background:EImage = getContentAsEImage("background");
         if(background != null)
         {
            background.destroy();
         }
         setContent("background",image);
         eAddChildAt(image,0);
      }
      
      public function setIcon(image:EImage) : void
      {
         var icon:EImage = getContentAsEImage("icon");
         var iconArea:ELayoutArea = this.getContent("icon").getLayoutArea();
         if(icon != null)
         {
            icon.destroy();
         }
         image.mouseEnabled = false;
         image.mouseChildren = false;
         setContent("icon",image);
         eAddChildAt(image,1);
         this.getContent("icon").setLayoutArea(iconArea,true);
      }
      
      private function setTextField(textField:ETextField) : void
      {
         if(textField != null)
         {
            this.setContent("textField",textField);
            this.eAddChild(textField);
         }
      }
      
      public function setText(text:String) : void
      {
         var textField:ETextField = this.getTextField();
         if(textField != null)
         {
            textField.setText(text);
         }
      }
      
      public function setTextProp(prop:String) : void
      {
         this.mUnselectedTextProp = prop;
      }
      
      public function getTextProp() : String
      {
         return this.mUnselectedTextProp;
      }
      
      public function getTextField() : ETextField
      {
         return getContent("textField") as ETextField;
      }
      
      public function getIcon() : EImage
      {
         return getContent("icon") as EImage;
      }
      
      public function getBackground() : EImage
      {
         return getContent("background") as EImage;
      }
      
      public function setSoundId(value:String) : void
      {
         mSoundId = value;
      }
      
      public function getSoundId() : String
      {
         return mSoundId;
      }
      
      public function setFunnelLabel(value:String) : void
      {
         mFunnelLabel = value;
      }
      
      public function getFunnelLabel() : String
      {
         return mFunnelLabel;
      }
      
      public function setDefaultRemoveTooltipOnMouseUp(value:Boolean) : void
      {
         this.mRemoveTooltipOnMouseUp = value;
      }
      
      public function getDefaultRemoveTooltipOnMouseUp() : Boolean
      {
         return this.mRemoveTooltipOnMouseUp;
      }
      
      public function setUnselectedBkg(bkg:EImage) : void
      {
         setContent("bkgUnselected",bkg);
      }
      
      public function swapBkg(value:Boolean) : Boolean
      {
         var bkg:EImage = null;
         var field:ETextField = this.getTextField();
         if(this.mSelected != value)
         {
            bkg = getContent("bkgUnselected") as EImage;
            if(bkg == null)
            {
               return false;
            }
            this.mSelected = value;
            if(this.mSelected)
            {
               eRemoveChild(bkg);
               if(this.mUnselectedProp != null)
               {
                  bkg.unapplySkinProp(null,this.mUnselectedProp);
               }
               bkg = getContent("background") as EImage;
               eAddChildAt(bkg,0);
               if(this.mUnselectedTextProp != null && field != null)
               {
                  field.unapplySkinProp(null,this.mUnselectedTextProp);
               }
            }
            else
            {
               eAddChildAt(bkg,0);
               if(this.mUnselectedProp != null)
               {
                  bkg.applySkinProp(null,this.mUnselectedProp);
               }
               bkg = getContent("background") as EImage;
               eRemoveChild(bkg);
               if(this.mUnselectedTextProp != null && field != null)
               {
                  field.applySkinProp(null,this.mUnselectedTextProp);
               }
            }
            return true;
         }
         return false;
      }
      
      public function setUnselectedProp(prop:String) : void
      {
         this.mUnselectedProp = prop;
      }
      
      public function getUnselectedProp() : String
      {
         if(this.mUnselectedProp == null)
         {
            return "unselected_tab";
         }
         return this.mUnselectedProp;
      }
      
      public function setShapeArea(areaRef:ELayoutArea, areaToFit:ELayoutArea) : void
      {
         var thisButtonArea:* = areaRef;
         if(areaToFit != null && areaRef != null)
         {
            thisButtonArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(areaToFit);
            thisButtonArea.height = areaRef.height;
            thisButtonArea.width = areaRef.width;
            if(areaToFit.height > areaRef.height)
            {
               thisButtonArea.scaleY = areaRef.height / areaToFit.height;
            }
            else
            {
               thisButtonArea.scaleY = areaToFit.height / areaRef.height;
            }
            if(areaToFit.width > areaRef.width)
            {
               thisButtonArea.scaleX = areaRef.width / areaToFit.width;
            }
            else
            {
               thisButtonArea.scaleX = areaToFit.width / areaRef.width;
            }
            this.mShapeArea = thisButtonArea;
         }
         this.setLayoutArea(thisButtonArea,true);
      }
      
      override public function setLayoutArea(area:ELayoutArea, apply:Boolean = false) : void
      {
         var thisButtonArea:* = area;
         if(this.mShapeArea != null && this.mShapeArea != area)
         {
            thisButtonArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(area);
            thisButtonArea.scaleX = this.mShapeArea.scaleX;
            thisButtonArea.scaleY = this.mShapeArea.scaleY;
         }
         super.setLayoutArea(thisButtonArea,apply);
      }
   }
}
