package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class PopupSkinDef extends DCDef
   {
       
      
      private var mContainersPath:String = "";
      
      private var mResourcePopupId:String = "";
      
      private var mResourceContainerId:String = "";
      
      public function PopupSkinDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "containers";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setContainerPath(EUtils.xmlReadString(info,attribute));
         }
         attribute = "resourcePopupId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setResourcePopupId(EUtils.xmlReadString(info,attribute));
         }
         attribute = "resourceContainerId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setResourceContainerId(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setContainerPath(value:String) : void
      {
         this.mContainersPath = value;
      }
      
      public function getContainersPath() : String
      {
         return this.mContainersPath;
      }
      
      private function setResourcePopupId(value:String) : void
      {
         this.mResourcePopupId = value;
      }
      
      public function getResourcePopupId() : String
      {
         return this.mResourcePopupId;
      }
      
      private function setResourceContainerId(value:String) : void
      {
         this.mResourceContainerId = value;
      }
      
      public function getResourceContainerId() : String
      {
         return this.mResourceContainerId;
      }
   }
}
