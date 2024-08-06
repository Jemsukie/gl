package com.dchoc.toolkit.core.view.mng
{
   import com.dchoc.toolkit.core.view.display.layer.DCLayerSWF;
   
   public class DCViewMngSimple extends DCViewMng
   {
       
      
      private var mNumLayers:int;
      
      public function DCViewMngSimple(numLayers:int)
      {
         super();
         this.mNumLayers = numLayers;
      }
      
      override protected function buildDoAsyncStep(step:int) : void
      {
         var i:int = 0;
         if(step == 0)
         {
            for(i = 1; i < this.mNumLayers + 1; )
            {
               mLayers[i] = new DCLayerSWF();
               mLayerDictionary["layer" + i] = i;
               i++;
            }
         }
      }
      
      override protected function unloadDo() : void
      {
      }
   }
}
