package net.jpauclair.ui
{
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class ToolTip extends Sprite
   {
      
      private static var mInstance:ToolTip = null;
       
      
      private var mText:TextField = null;
      
      public function ToolTip()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         var myformat:TextFormat = new TextFormat("_sans",11,16777215,true);
         var myglow:GlowFilter = new GlowFilter(3355443,1,2,2,3,2,false,false);
         this.visible = false;
         this.mText = new TextField();
         this.mText.width = 800;
         this.mText.selectable = false;
         this.mText.defaultTextFormat = myformat;
         this.mText.filters = [myglow];
         this.mText.x = 2;
         addChild(this.mText);
         mInstance = this;
      }
      
      public static function set Visible(isVisible:Boolean) : void
      {
         mInstance.visible = isVisible;
      }
      
      public static function SetToolTip(text:String, aX:int, aY:int) : void
      {
         mInstance.SetToolTipText(text);
         mInstance.x = aX;
         mInstance.y = aY;
      }
      
      public static function set Text(aText:String) : void
      {
         mInstance.SetToolTipText(aText);
      }
      
      public static function SetPosition(aX:int, aY:int) : void
      {
         mInstance.x = aX;
         mInstance.y = aY;
      }
      
      public function SetToolTipText(text:String) : void
      {
         this.mText.text = text;
         this.graphics.clear();
         this.graphics.beginFill(8947848,0.5);
         this.graphics.drawRect(0,0,this.mText.textWidth + 7,this.mText.textHeight + 4);
         this.graphics.endFill();
         this.graphics.beginFill(0,0.5);
         this.graphics.drawRect(1,1,this.mText.textWidth + 5,this.mText.textHeight + 2);
         this.graphics.endFill();
      }
   }
}
