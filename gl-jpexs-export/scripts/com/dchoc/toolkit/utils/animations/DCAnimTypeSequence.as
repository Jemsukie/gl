package com.dchoc.toolkit.utils.animations
{
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   
   public class DCAnimTypeSequence extends DCAnimType
   {
       
      
      private var mImpIdsSequence:Vector.<int>;
      
      private var mImpIdsSequenceLastId:int;
      
      private var mAnimMng:DCAnimMng;
      
      public function DCAnimTypeSequence(id:int, impIdsSequence:Vector.<int>, animMng:DCAnimMng)
      {
         super(id);
         this.mImpIdsSequence = impIdsSequence;
         this.mImpIdsSequenceLastId = this.mImpIdsSequence[this.mImpIdsSequence.length - 1];
         this.mAnimMng = animMng;
      }
      
      override public function unload() : void
      {
         super.unload();
         this.mImpIdsSequence = null;
      }
      
      override public function getImpId(item:DCItemAnimatedInterface, layerId:int) : int
      {
         var currentImp:DCAnimImp = null;
         var pos:int = 0;
         var returnValue:int = -1;
         var anim:DCDisplayObject;
         if((anim = item.viewLayersAnimGet(layerId)) == null)
         {
            returnValue = this.mImpIdsSequence[0];
         }
         else if((currentImp = this.mAnimMng.getImpFromId(item.viewLayersImpCurrentGet(layerId))) == null || currentImp.animHasEnded(item,layerId))
         {
            returnValue = item.viewLayersImpCurrentGet(layerId);
            if(returnValue != this.mImpIdsSequenceLastId)
            {
               pos = this.mImpIdsSequence.indexOf(returnValue);
               pos++;
               returnValue = this.mImpIdsSequence[pos];
            }
         }
         else
         {
            returnValue = -2;
         }
         return returnValue;
      }
   }
}
