package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class AnimationsDefMng extends DCDefMng
   {
       
      
      public function AnimationsDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new AnimationsDef();
      }
      
      override protected function buildDefs() : void
      {
         var i:int = 0;
         var animationDefObj:AnimationsDef = null;
         var animationDefVector:Vector.<DCDef> = getDefs();
         for(i = animationDefVector.length - 1; i > 0; )
         {
            animationDefObj = AnimationsDef(animationDefVector[i]);
            i--;
         }
      }
   }
}
