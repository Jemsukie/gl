package com.dchoc.game.core.utils.animations
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.view.UnitComponentView;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.animations.DCAnimImp;
   import com.dchoc.toolkit.utils.animations.DCItemAnimatedInterface;
   import flash.display.DisplayObject;
   
   public class AnimImpBaseUnitReady extends DCAnimImp
   {
       
      
      public function AnimImpBaseUnitReady(id:int)
      {
         super(id);
      }
      
      override public function itemGetAnim(item:DCItemAnimatedInterface) : DCDisplayObject
      {
         var wio:WorldItemObject = WorldItemObject(item);
         return wio.mUnit.getViewComponent().getDCDisplayObject();
      }
      
      override public function itemIsAnimReady(item:DCItemAnimatedInterface) : Boolean
      {
         var unit:MyUnit = null;
         var c:UnitComponentView = null;
         var returnValue:Boolean = false;
         var wio:WorldItemObject;
         if((wio = WorldItemObject(item)) != null)
         {
            unit = wio.mUnit;
            if(unit != null)
            {
               c = wio.mUnit.getViewComponent();
               returnValue = c != null && c.isBuilt();
            }
         }
         return returnValue;
      }
      
      override public function itemAddToStage(layerId:int, item:DCItemAnimatedInterface) : void
      {
         var c:UnitComponentView = null;
         var displayObject:DisplayObject = null;
         var wio:WorldItemObject;
         if((wio = WorldItemObject(item)).mUnit != null)
         {
            c = wio.mUnit.getViewComponent();
            if(wio.mIsFlipped)
            {
               if(wio.mDef.needsFlipWithScale())
               {
                  displayObject = c.getDisplayObject();
                  if(displayObject != null)
                  {
                     displayObject.scaleX = -1;
                  }
               }
               else
               {
                  wio.mUnit.flip();
               }
            }
            if(c != null)
            {
               c.addToScene();
            }
         }
      }
      
      override public function itemRemoveFromStage(layerId:int, item:DCItemAnimatedInterface) : void
      {
         var c:UnitComponentView = null;
         var wio:WorldItemObject;
         if((wio = WorldItemObject(item)).mUnit != null)
         {
            c = wio.mUnit.getViewComponent();
            if(c != null)
            {
               c.removeFromScene();
            }
         }
      }
   }
}
