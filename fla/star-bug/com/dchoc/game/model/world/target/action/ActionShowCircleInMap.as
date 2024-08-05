package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.gui.highlights.Highlight;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class ActionShowCircleInMap extends DCAction
   {
       
      
      public function ActionShowCircleInMap()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var componentName:String = null;
         var item:WorldItemObject = null;
         var items:Vector.<WorldItemObject> = null;
         var coords:DCCoordinate = new DCCoordinate();
         if(isPreaction)
         {
            componentName = target.getDef().getPreactionTargetSid();
         }
         else
         {
            componentName = target.getDef().getPostactionTargetSid();
         }
         if(componentName == "")
         {
            coords = getTargetCoordinates(target.getDef(),isPreaction);
            this.placeCircleFromCoords(coords);
         }
         else if(componentName == "last")
         {
            items = InstanceMng.getWorld().itemsGetAllItems();
            item = items[items.length - 1];
         }
         else
         {
            item = InstanceMng.getWorld().itemsGetItemBySid(componentName);
         }
         this.placeCircleFromCoords(coords,item);
         return true;
      }
      
      public function placeCircleFromCoords(coords:DCCoordinate, item:WorldItemObject = null) : Highlight
      {
         var w:int = 0;
         var h:int = 0;
         var x:int = coords.x;
         var y:int = coords.y;
         var multiplier:int = int(coords.z != 0 ? int(coords.z) : 1);
         w = 117 * multiplier;
         h = 90 * multiplier;
         if(item != null)
         {
            coords.x = item.mViewCenterWorldX;
            coords.y = item.mViewCenterWorldY;
            x = coords.x;
            y = coords.y - 40;
            w = item.mBoundingBox.getWidth();
            h = item.mBoundingBox.getHeight() * 2 + 38;
         }
         return InstanceMng.getViewMngPlanet().addHighlightFromCoords(x,y,w,h);
      }
   }
}
