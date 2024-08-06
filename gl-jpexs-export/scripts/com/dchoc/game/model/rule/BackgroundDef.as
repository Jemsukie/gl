package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class BackgroundDef extends DCDef
   {
       
      
      private var mObstacleSku:String = "";
      
      private var mBackgroundAsset:String = "";
      
      private var mSolarSystemType:String = "";
      
      private var mAnimations:Vector.<Object>;
      
      private var mDeployAreas:Array;
      
      private var mAlliancesAnim:String;
      
      public function BackgroundDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "obstaclesSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setObstaclesSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "backgroundAsset";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBackgroundAsset(EUtils.xmlReadString(info,attribute));
         }
         attribute = "solarSystemType";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSolarSystemType(EUtils.xmlReadString(info,attribute));
         }
         attribute = "animations";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAnimations(EUtils.xmlReadString(info,attribute));
         }
         attribute = "deployAreas";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDeployAreas(EUtils.xmlReadString(info,attribute));
         }
         attribute = "allianceAnim";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAllianceAnimation(EUtils.xmlReadString(info,attribute));
         }
      }
      
      public function getObstaclesSku() : String
      {
         return this.mObstacleSku;
      }
      
      public function getBackgroundAsset() : String
      {
         return this.mBackgroundAsset;
      }
      
      public function getSolarSystemType() : String
      {
         return this.mSolarSystemType;
      }
      
      public function getAnimations() : Vector.<Object>
      {
         return this.mAnimations;
      }
      
      public function getAnimationTimeByName(value:String) : Number
      {
         var obj:Object = null;
         var returnValue:Number = -1;
         if(this.mAnimations != null && value != null)
         {
            for each(obj in this.mAnimations)
            {
               if(obj != null && obj.name == value)
               {
                  returnValue = Number(obj.time);
               }
            }
         }
         return returnValue;
      }
      
      public function getDeployAreas() : Array
      {
         return this.mDeployAreas;
      }
      
      public function getAllianceAnimation() : String
      {
         return this.mAlliancesAnim;
      }
      
      private function setObstaclesSku(value:String) : void
      {
         this.mObstacleSku = value;
      }
      
      private function setBackgroundAsset(value:String) : void
      {
         this.mBackgroundAsset = value;
      }
      
      private function setSolarSystemType(value:String) : void
      {
         this.mSolarSystemType = value;
      }
      
      private function setAnimations(value:String) : void
      {
         var i:int = 0;
         var animObj:Object = null;
         var animProperties:Array = null;
         if(this.mAnimations == null)
         {
            this.mAnimations = new Vector.<Object>(0);
         }
         var animsArr:Array;
         if((animsArr = value.split(",")) != null)
         {
            for(i = 0; i < animsArr.length; )
            {
               if(animsArr[i] != null)
               {
                  animProperties = String(animsArr[i]).split(":");
                  if(animProperties != null)
                  {
                     (animObj = {}).name = animProperties[0];
                     animObj.time = animProperties[1];
                     this.mAnimations.push(animObj);
                  }
               }
               i++;
            }
         }
      }
      
      private function setAllianceAnimation(value:String) : void
      {
         this.mAlliancesAnim = value;
      }
      
      private function setDeployAreas(value:String) : void
      {
         var i:int = 0;
         var aux:int = 0;
         var rect:Array = null;
         var j:int = 0;
         if(this.mDeployAreas == null)
         {
            this.mDeployAreas = [];
         }
         var parseAreas:Array = value.split(":");
         for(i = 0; i < parseAreas.length; )
         {
            parseAreas[i] = EUtils.trim(parseAreas[i]);
            rect = parseAreas[i].split(",");
            for(j = 0; j < rect.length; )
            {
               rect[j] = Number(rect[j]);
               j++;
            }
            if(rect[2] < rect[0])
            {
               aux = int(rect[0]);
               rect[0] = rect[2];
               rect[2] = aux;
            }
            if(rect[3] < rect[1])
            {
               aux = int(rect[1]);
               rect[1] = rect[3];
               rect[3] = aux;
            }
            this.mDeployAreas.push(rect);
            i++;
         }
      }
   }
}
