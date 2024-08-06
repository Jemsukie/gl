package com.dchoc.toolkit.utils.animations
{
   public class DCAnimTypePerAttribute extends DCAnimType
   {
       
      
      protected var mImpIdStart:int;
      
      protected var mAttributeSku:String;
      
      public function DCAnimTypePerAttribute(id:int, impIdStart:int, attributeSku:String)
      {
         super(id);
         this.mImpIdStart = impIdStart;
         this.mAttributeSku = attributeSku;
      }
      
      override public function unload() : void
      {
         super.unload();
         this.mAttributeSku = null;
      }
      
      override public function getImpId(item:DCItemAnimatedInterface, layerId:int) : int
      {
         return this.mImpIdStart + int(item.viewLayersGetAttribute(layerId,this.mAttributeSku));
      }
   }
}
