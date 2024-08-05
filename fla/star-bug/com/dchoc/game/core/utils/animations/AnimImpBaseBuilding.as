package com.dchoc.game.core.utils.animations
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.animations.DCItemAnimatedInterface;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class AnimImpBaseBuilding extends AnimImpSWFStar
   {
      
      private static const LAYER_BACK:int = 0;
      
      private static const LAYER_ITEM:int = 1;
      
      private static const LAYER_FRONT:int = 2;
      
      private static const LAYER_COUNT:int = 3;
      
      private static var smResourcesToCombine:Array = new Array(3);
       
      
      public function AnimImpBaseBuilding(id:int, format:int)
      {
         super(id,1,null,"ready",null,true,true,true,0,null,format);
      }
      
      override public function itemIsAnimReady(item:DCItemAnimatedInterface) : Boolean
      {
         var wio:WorldItemObject = null;
         var resourceMng:ResourceMng;
         var returnValue:Boolean = (resourceMng = InstanceMng.getResourceMng()).isResourceLoaded(InstanceMng.getSkinsMng().getCurrentFoundationAsset());
         if(returnValue)
         {
            wio = WorldItemObject(item);
            if(wio.mServerStateId == 2)
            {
               returnValue = super.itemIsAnimReady(item);
            }
         }
         return returnValue;
      }
      
      override protected function itemGetDef(worldItem:WorldItemObject) : WorldItemDef
      {
         return worldItem.mDef;
      }
      
      override public function itemGetAnim(item:DCItemAnimatedInterface) : DCDisplayObject
      {
         var wio:WorldItemObject = WorldItemObject(item);
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         var prefSku:*;
         var animSku:* = (prefSku = "construction_" + wio.mDef.getBaseCols() + "x" + wio.mDef.getBaseRows() + "_") + "back";
         var anim:DCDisplayObject = resourceMng.getDCDisplayObject(InstanceMng.getSkinsMng().getCurrentFoundationAsset(),animSku);
         var dcBitmapMovieClip:DCBitmapMovieClip;
         if((dcBitmapMovieClip = DCBitmapMovieClip(anim)) != null)
         {
            smResourcesToCombine[0] = dcBitmapMovieClip.getAnimation();
         }
         else
         {
            smResourcesToCombine[0] = null;
         }
         animSku = prefSku + "front";
         anim = resourceMng.getDCDisplayObject(InstanceMng.getSkinsMng().getCurrentFoundationAsset(),animSku);
         if((dcBitmapMovieClip = DCBitmapMovieClip(anim)) != null)
         {
            smResourcesToCombine[2] = dcBitmapMovieClip.getAnimation();
         }
         else
         {
            smResourcesToCombine[2] = null;
         }
         if(wio.mServerStateId == 2)
         {
            anim = super.itemGetAnim(item);
            dcBitmapMovieClip = DCBitmapMovieClip(anim);
            smResourcesToCombine[1] = dcBitmapMovieClip.getAnimation();
         }
         else
         {
            smResourcesToCombine[1] = null;
         }
         var bitmapData:BitmapData = resourceMng.generateCombinedBitmapData(smResourcesToCombine);
         var bitmap:Bitmap = new Bitmap(bitmapData);
         return new DCDisplayObjectSWF(bitmap);
      }
   }
}
