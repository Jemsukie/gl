package esparragon.display
{
   import esparragon.core.Esparragon;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutTextArea;
   import flash.geom.Rectangle;
   import flash.text.Font;
   import flash.text.TextField;
   
   public class ETextField extends ESprite
   {
      
      protected static const GUTTER:int = 4;
      
      protected static const UNICODE_FONT:String = "Arial Unicode MS";
      
      public static const MIN_FONT_SIZE:int = 10;
      
      public static const INPUT:String = "input";
      
      public static const DYNAMIC:String = "dynamic";
       
      
      protected var mFontNameDefault:String;
      
      public function ETextField()
      {
         super();
      }
      
      override protected function poolReturn() : void
      {
         Esparragon.poolReturnETextField(this);
      }
      
      public function setText(value:String) : void
      {
      }
      
      public function getText() : String
      {
         return null;
      }
      
      public function setBorder(value:Boolean) : void
      {
      }
      
      public function setVAlign(value:String) : void
      {
      }
      
      public function setHAlign(value:String) : void
      {
      }
      
      public function setAutoScale(value:Boolean) : void
      {
      }
      
      public function getAutoScale() : Boolean
      {
         return true;
      }
      
      protected function applyFontName(fontName:String) : void
      {
      }
      
      public function setFontName(fontName:String) : void
      {
      }
      
      public function getFontName() : String
      {
         return null;
      }
      
      public function setFontSize(fontSize:Number) : void
      {
      }
      
      public function getFontSize() : Number
      {
         return 0;
      }
      
      public function setTextColor(color:uint) : void
      {
      }
      
      public function rollbackTextColor() : void
      {
      }
      
      public function resetTextColor() : void
      {
      }
      
      public function getColor() : uint
      {
         return 0;
      }
      
      public function setKerning(value:Boolean) : void
      {
      }
      
      public function setBold(value:Boolean) : void
      {
      }
      
      public function setItalic(value:Boolean) : void
      {
      }
      
      public function setUnderline(value:Boolean) : void
      {
      }
      
      public function autoSize(value:Boolean) : void
      {
      }
      
      public function getStrBoundaries(str:String) : Rectangle
      {
         return null;
      }
      
      public function getTextField() : TextField
      {
         return null;
      }
      
      public function setMaxChars(value:int) : void
      {
      }
      
      public function setEditable(value:Boolean) : void
      {
      }
      
      public function setMultiline(value:Boolean) : void
      {
      }
      
      public function setWordWrap(value:Boolean) : void
      {
      }
      
      public function getFontSizeAfterScale() : Number
      {
         return 0;
      }
      
      private function applyTextProperties(textArea:ELayoutTextArea) : void
      {
         name = textArea.name;
         this.setFontSize(textArea.fontSize);
         this.setFontName(textArea.fontName);
         width = textArea.width;
         height = textArea.height;
         this.setHAlign(textArea.hAlign);
         this.setVAlign(textArea.vAlign);
         this.setAutoScale(textArea.autoScale);
         this.setTextColor(textArea.fontColor);
         this.setBold(false);
      }
      
      override public function layoutApplyTransformations(textArea:ELayoutArea) : void
      {
         this.applyTextProperties(textArea as ELayoutTextArea);
         super.layoutApplyTransformations(textArea);
      }
      
      protected function get textWidth() : Number
      {
         return 0;
      }
      
      public function get textWithMarginWidth() : Number
      {
         return this.textWidth + 4;
      }
      
      protected function get textHeight() : Number
      {
         return 0;
      }
      
      public function get textWithMarginHeight() : Number
      {
         return this.textHeight + 4;
      }
      
      protected function checkTextFieldGlyphs(text:String) : Boolean
      {
         var font:* = null;
         var textAux:String = null;
         var returnValue:Boolean = false;
         var allFonts:Array = Font.enumerateFonts(false);
         var defaultFont:String = this.mFontNameDefault;
         for(font in allFonts)
         {
            if(allFonts[font].fontName == defaultFont)
            {
               textAux = text.split("\r").join("");
               textAux = textAux.split("\n").join("");
               if(allFonts[font].hasGlyphs(textAux) && defaultFont != this.getFontName())
               {
                  this.applyFontName(this.mFontNameDefault);
                  returnValue = true;
               }
               else if(!allFonts[font].hasGlyphs(textAux) && this.getFontName() != "Arial Unicode MS")
               {
                  this.applyFontName("Arial Unicode MS");
                  returnValue = true;
               }
               return returnValue;
            }
         }
         return returnValue;
      }
      
      protected function isAnEmbeddedFont(fontName:String) : Boolean
      {
         var font:Font = null;
         var i:int = 0;
         var returnValue:* = false;
         var allFonts:Array;
         var length:int = int((allFonts = Font.enumerateFonts(false)).length);
         i = 0;
         while(i < length && !returnValue)
         {
            returnValue = (font = allFonts[i]).fontName == fontName;
            i++;
         }
         return returnValue;
      }
      
      override public function getLogicWidth() : Number
      {
         return width;
      }
      
      override public function getLogicHeight() : Number
      {
         return height;
      }
   }
}
