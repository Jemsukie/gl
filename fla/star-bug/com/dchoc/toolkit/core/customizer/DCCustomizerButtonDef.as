package com.dchoc.toolkit.core.customizer
{
   import esparragon.utils.EUtils;
   
   public class DCCustomizerButtonDef
   {
      
      public static const TRACKING_ON_DISPLAY:String = "ondisplay";
      
      public static const TRACKING_ON_CLICK:String = "onclick";
       
      
      private var mLabel:String;
      
      private var mAction:String;
      
      private var mParams:Array;
      
      public function DCCustomizerButtonDef(info:XML)
      {
         var buttonParams:XML = null;
         var attribute:XML = null;
         var index:int = 0;
         var key:String = null;
         super();
         this.mLabel = EUtils.xmlReadString(info,"label");
         this.mAction = EUtils.xmlReadString(info,"action");
         this.mParams = [];
         for each(buttonParams in EUtils.xmlGetChildrenList(info,"params"))
         {
            for each(attribute in buttonParams.attributes())
            {
               index = 0;
               key = String(attribute.name());
               while(this.mParams[key] != null)
               {
                  index++;
                  key = String(attribute.name()) + index;
               }
               this.mParams[key] = String(attribute);
            }
         }
      }
      
      public function destroy() : void
      {
         this.mLabel = null;
         this.mAction = null;
         this.mParams.length = 0;
         this.mParams = null;
      }
      
      public function getLabel() : String
      {
         return this.mLabel;
      }
      
      public function getAction() : String
      {
         return this.mAction;
      }
      
      public function getParam(key:String) : String
      {
         return this.mParams[key];
      }
   }
}
