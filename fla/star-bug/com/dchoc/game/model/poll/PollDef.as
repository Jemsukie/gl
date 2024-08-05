package com.dchoc.game.model.poll
{
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class PollDef extends DCDef
   {
       
      
      private var mTidBody:String;
      
      private var mTidsOptions:Vector.<String>;
      
      private var mBarColors:Vector.<uint>;
      
      private var mVisibleResult:Boolean = false;
      
      public function PollDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = null;
         attribute = "viewResult";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setVisibleResult(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "tidBody";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidBody(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidsOptions";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setArrayTidsOptions(EUtils.xmlReadString(info,attribute));
         }
         attribute = "barColors";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setArrayBarColors(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setVisibleResult(value:Boolean) : void
      {
         this.mVisibleResult = value;
      }
      
      public function getVisibleResult() : Boolean
      {
         return this.mVisibleResult;
      }
      
      private function setTidBody(value:String) : void
      {
         this.mTidBody = value;
      }
      
      public function getTextBody() : String
      {
         return DCTextMng.getText(TextIDs[this.mTidBody]);
      }
      
      private function setArrayTidsOptions(value:String) : void
      {
         this.mTidsOptions = Vector.<String>(value.split(","));
      }
      
      public function getOptionText(index:int) : String
      {
         return DCTextMng.getText(TextIDs[this.mTidsOptions[index]]);
      }
      
      private function setArrayBarColors(value:String) : void
      {
         this.mBarColors = new Vector.<uint>(0);
         for each(var rawColor in value.split(","))
         {
            this.mBarColors.push(uint(parseInt(rawColor,16)));
         }
      }
      
      public function getBarColor(index:int) : uint
      {
         return this.mBarColors[index];
      }
      
      public function getNumOptions() : int
      {
         return this.mTidsOptions.length;
      }
   }
}
