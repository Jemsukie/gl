package com.dchoc.game.model.contest
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class ContestDef extends DCDef
   {
       
      
      private var mIcon:String;
      
      private var mProgressIcon:String;
      
      private var mProgressText:String;
      
      private var mConditionsText:Array;
      
      private var mConditionsIcon:Array;
      
      private var mAdvisor:String;
      
      private var mTitle:String;
      
      private var mMissionText:String;
      
      public function ContestDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var i:int = 0;
         var attribName:String = null;
         super.doFromXml(info);
         var attribute:String = "icon";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIcon(EUtils.xmlReadString(info,attribute));
         }
         attribute = "progressIcon";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setProgressIcon(EUtils.xmlReadString(info,attribute));
         }
         attribute = "progressText";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setProgressText(EUtils.xmlReadString(info,attribute));
         }
         attribute = "advisor";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAdvisor(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidName";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "missionTabDescTid";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMissionText(EUtils.xmlReadString(info,attribute));
         }
         var attributes:XMLList;
         var numAttributes:int = (attributes = info.attributes()).length();
         for(i = 0; i < numAttributes; )
         {
            if((attribName = String(attributes[i].name())).indexOf("conditionTid") > -1)
            {
               if(this.mConditionsText == null)
               {
                  this.mConditionsText = [];
               }
               this.mConditionsText.push(attributes[i].valueOf().toString());
            }
            if(attribName.indexOf("conditionIcon") > -1)
            {
               if(this.mConditionsIcon == null)
               {
                  this.mConditionsIcon = [];
               }
               this.mConditionsIcon.push(attributes[i].valueOf().toString());
            }
            i++;
         }
      }
      
      private function setIcon(value:String) : void
      {
         this.mIcon = value;
      }
      
      public function getIcon() : String
      {
         return this.mIcon;
      }
      
      public function getConditionTid(idx:int = 0) : String
      {
         if(this.mConditionsText != null)
         {
            return this.mConditionsText[idx];
         }
         return null;
      }
      
      public function getConditionIcon(idx:int = 0) : String
      {
         if(this.mConditionsIcon != null)
         {
            return this.mConditionsIcon[idx];
         }
         return null;
      }
      
      public function getNumConditions() : int
      {
         if(this.mConditionsText == null)
         {
            return 0;
         }
         return this.mConditionsText.length;
      }
      
      private function setProgressIcon(value:String) : void
      {
         this.mProgressIcon = value;
      }
      
      public function getProgressIcon() : String
      {
         return this.mProgressIcon;
      }
      
      private function setProgressText(value:String) : void
      {
         this.mProgressText = value;
      }
      
      public function getProgressText() : String
      {
         return this.mProgressText;
      }
      
      private function setAdvisor(value:String) : void
      {
         this.mAdvisor = value;
      }
      
      public function getAdvisor() : String
      {
         return this.mAdvisor;
      }
      
      private function setTitle(value:String) : void
      {
         this.mTitle = value;
      }
      
      public function getTitle() : String
      {
         return this.mTitle;
      }
      
      private function setMissionText(value:String) : void
      {
         this.mMissionText = value;
      }
      
      public function getMissionText() : String
      {
         return this.mMissionText;
      }
   }
}
