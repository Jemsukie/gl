package esparragon.layout
{
   import avmplus.getQualifiedClassName;
   import flash.display.DisplayObject;
   import flash.text.TextField;
   
   public class ELayoutTextArea extends ELayoutArea
   {
       
      
      public var fontSize:Number = 12;
      
      public var hAlign:String;
      
      public var vAlign:String;
      
      public var autoScale:Boolean;
      
      public var bold:Boolean;
      
      public var fontColor:int;
      
      public var fontName:String;
      
      public var filterType:String;
      
      public function ELayoutTextArea(area:ELayoutTextArea = null)
      {
         super(area);
         if(area != null)
         {
            this.fontSize = area.fontSize;
            this.hAlign = area.hAlign;
            this.vAlign = "center";
            this.fontColor = area.fontColor;
            this.autoScale = true;
            this.bold = true;
            scaleX = scaleX < 0 ? -1 : 1;
            scaleY = scaleY < 0 ? -1 : 1;
            this.fontName = area.fontName;
            this.filterType = area.filterType;
         }
      }
      
      override public function parseFromDisplayObject(displayObject:DisplayObject, areaName:String) : void
      {
         var i:int = 0;
         var nameParts:Array = null;
         var suffix:String = null;
         super.parseFromDisplayObject(displayObject,areaName);
         var textField:TextField;
         var textFieldName:String = (textField = displayObject as TextField).name;
         if(textFieldName != "" && textField != null)
         {
            nameParts = textFieldName.split("$");
         }
         this.fontSize = Number(textField.defaultTextFormat.size);
         this.hAlign = textField.defaultTextFormat.align;
         this.vAlign = "center";
         this.fontColor = int(textField.defaultTextFormat.color);
         this.autoScale = true;
         this.bold = true;
         scaleX = scaleX < 0 ? -1 : 1;
         scaleY = scaleY < 0 ? -1 : 1;
         this.fontName = textField.defaultTextFormat.font;
         if(nameParts != null && nameParts.length > 1)
         {
            name = nameParts[0];
            this.fontName = nameParts[1];
            if(nameParts.length > 2)
            {
               this.filterType = nameParts[2];
            }
         }
         i = 0;
         while(i < textField.filters.length)
         {
            suffix = getQualifiedClassName(textField.filters[i]);
            suffix = (suffix = suffix.substr(suffix.lastIndexOf(":") + 1)).substr(0,suffix.indexOf("Filter"));
            this.fontName += " " + suffix;
            i++;
         }
      }
   }
}
