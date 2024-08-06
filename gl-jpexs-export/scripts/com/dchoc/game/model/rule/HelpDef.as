package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class HelpDef extends DCDef
   {
       
      
      private var mTitles:Vector.<String>;
      
      private var mTexts:Vector.<String>;
      
      private var mTips:Vector.<String>;
      
      private var mStates:Vector.<int>;
      
      private var mAdvisor:String;
      
      public function HelpDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "titles";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mTitles = EUtils.array2VectorString(EUtils.xmlReadString(info,attribute).split(","));
         }
         attribute = "texts";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mTexts = EUtils.array2VectorString(EUtils.xmlReadString(info,attribute).split(","));
         }
         attribute = "tips";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mTips = EUtils.array2VectorString(EUtils.xmlReadString(info,attribute).split(","));
         }
         attribute = "states";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mStates = EUtils.array2VectorInt(EUtils.xmlReadString(info,attribute).split(","));
         }
         attribute = "advisor";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mAdvisor = EUtils.xmlReadString(info,attribute);
         }
      }
      
      public function getTitle(idx:int = 0) : String
      {
         if(this.mTitles == null)
         {
            return null;
         }
         return DCTextMng.getText(TextIDs[this.mTitles[idx]]);
      }
      
      public function getText(idx:int = 0) : String
      {
         if(this.mTexts == null)
         {
            return null;
         }
         return DCTextMng.getText(TextIDs[this.mTexts[idx]]);
      }
      
      public function getTip(idx:int = 0) : String
      {
         if(this.mTips == null)
         {
            return null;
         }
         return DCTextMng.getText(TextIDs[this.mTips[idx]]);
      }
      
      public function getState(idx:int = 0) : int
      {
         if(this.mStates == null)
         {
            return -1;
         }
         return this.mStates[idx];
      }
      
      public function getPagesCount() : int
      {
         if(this.mTitles == null)
         {
            return 0;
         }
         return this.mTitles.length;
      }
      
      public function getAdvisor() : String
      {
         return this.mAdvisor;
      }
   }
}
