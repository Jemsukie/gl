package com.dchoc.toolkit.core.target.action
{
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.DCTargetDef;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class DCAction extends DCComponent
   {
       
      
      public function DCAction()
      {
         super();
      }
      
      public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         return false;
      }
      
      override public function logicUpdate(dt:int) : void
      {
      }
      
      protected function getTargetCoordinates(targetDef:DCTargetDef, isPreaction:Boolean) : DCCoordinate
      {
         var coords:DCCoordinate = new DCCoordinate();
         if(isPreaction)
         {
            coords.x = targetDef.getPreactionTargetCoordX();
            coords.y = targetDef.getPreactionTargetCoordY();
            coords.z = targetDef.getPreactionTargetRotation();
         }
         else
         {
            coords.x = targetDef.getPostactionTargetCoordX();
            coords.y = targetDef.getPostactionTargetCoordY();
            coords.z = targetDef.getPostactionTargetRotation();
         }
         return coords;
      }
   }
}
