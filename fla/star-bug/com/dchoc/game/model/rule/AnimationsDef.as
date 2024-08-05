package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class AnimationsDef extends DCDef
   {
       
      
      private var mAnimations:Dictionary;
      
      private var mAnimationLoaded:Dictionary;
      
      public var mDefaultAnim:String = "";
      
      private var mAnimationsCount:int;
      
      public function AnimationsDef()
      {
         super();
         this.mAnimations = new Dictionary(true);
         this.mAnimationLoaded = new Dictionary(true);
         this.mAnimationsCount = 0;
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var animDef:XML = null;
         var anim:Object = null;
         var name:String = null;
         this.mDefaultAnim = EUtils.xmlReadString(info,"defaultAnim");
         for each(animDef in EUtils.xmlGetChildrenList(info,"Anim"))
         {
            anim = {};
            anim.frameWidth = EUtils.xmlReadInt(animDef,"frameWidth");
            anim.frameHeight = EUtils.xmlReadInt(animDef,"frameHeight");
            anim.rows = EUtils.xmlReadInt(animDef,"rows");
            anim.cols = EUtils.xmlReadInt(animDef,"cols");
            anim.anglesCount = EUtils.xmlReadInt(animDef,"angleCount");
            anim.frameCount = EUtils.xmlReadInt(animDef,"frameCount");
            anim.className = EUtils.xmlReadString(animDef,"className");
            anim.isAnimated = EUtils.xmlReadBoolean(animDef,"animated");
            name = EUtils.xmlReadString(animDef,"name");
            this.mAnimations[name] = anim;
            if(name.indexOf("death") == -1)
            {
               this.mAnimationLoaded[name] = false;
               this.mAnimationsCount++;
            }
         }
      }
      
      public function getAnimation(sku:String = null) : Object
      {
         if(sku == null)
         {
            sku = this.mDefaultAnim;
         }
         return this.mAnimations[sku];
      }
      
      public function setAnimationLoaded(sku:String) : void
      {
         if(sku.indexOf("death") == -1 && !this.mAnimationLoaded[sku])
         {
            this.mAnimationsCount--;
            this.mAnimationLoaded[sku] = true;
         }
      }
      
      public function getAnimationsCount() : int
      {
         return this.mAnimationsCount;
      }
      
      public function getAreAllAnimationsLoaded() : Boolean
      {
         return this.mAnimationsCount <= 0;
      }
   }
}
