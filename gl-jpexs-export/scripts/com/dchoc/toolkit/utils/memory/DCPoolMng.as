package com.dchoc.toolkit.utils.memory
{
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class DCPoolMng extends DCComponent
   {
       
      
      public function DCPoolMng()
      {
         super();
      }
      
      public function animIsReady(fileSku:String, animSku:String) : Boolean
      {
         var resourceMng:DCResourceMng;
         var returnValue:Boolean = (resourceMng = DCInstanceMng.getInstance().getResourceMng()).isResourceLoaded(fileSku);
         if(!returnValue)
         {
            resourceMng.requestResource(fileSku);
         }
         return returnValue;
      }
      
      public function animGet(fileSku:String, animSku:String) : *
      {
         var rVal:DCDisplayObject = null;
         var sp:Sprite = null;
         var bmp:Bitmap = null;
         if(animSku == null || animSku.length == 0)
         {
            sp = new Sprite();
            bmp = new Bitmap(DCInstanceMng.getInstance().getResourceMng().getImageFromCatalog(fileSku));
            sp.addChild(bmp);
            rVal = new DCDisplayObjectSWF(sp);
         }
         else
         {
            rVal = DCInstanceMng.getInstance().getResourceMng().getDCDisplayObject(fileSku,animSku);
         }
         return rVal;
      }
      
      public function animRelease(fileSku:String, animSku:String, anim:*) : void
      {
         anim = null;
      }
   }
}
