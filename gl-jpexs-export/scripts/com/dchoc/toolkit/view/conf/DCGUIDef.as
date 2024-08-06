package com.dchoc.toolkit.view.conf
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class DCGUIDef extends DCDef
   {
       
      
      public var mTidTitleTooltip:String = "";
      
      public var mTidDescTooltip:String = "";
      
      public function DCGUIDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var data:String = null;
         super.doFromXml(info);
         var attribute:String = "tidTitleTooltip";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            data = EUtils.xmlReadString(info,attribute);
            this.setTidTitleTooltip(data);
            addToDictionary("TOOLTIP_TITLE",data);
         }
         attribute = "tidDescTooltip";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            data = EUtils.xmlReadString(info,attribute);
            this.setTidDescTooltip(data);
            addToDictionary("TOOLTIP_DESC",data);
         }
      }
      
      public function getTidTitleTooltip() : String
      {
         return this.mTidTitleTooltip;
      }
      
      public function getTidDescTooltip() : String
      {
         return this.mTidDescTooltip;
      }
      
      private function setTidTitleTooltip(value:String) : void
      {
         this.mTidTitleTooltip = value;
      }
      
      private function setTidDescTooltip(value:String) : void
      {
         this.mTidDescTooltip = value;
      }
   }
}
