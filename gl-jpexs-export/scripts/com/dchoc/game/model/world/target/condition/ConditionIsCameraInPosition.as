package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class ConditionIsCameraInPosition extends Condition
   {
      
      private static const MAX_CHECK:int = 10;
       
      
      private var mOldPosX:int = -1;
      
      private var mOldPosY:int = -1;
      
      private var mNumChecks:int = 0;
      
      public function ConditionIsCameraInPosition()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var conditionExtraPars:String = null;
         var infoCoords:Array = null;
         var camCoords:DCCoordinate = null;
         var coords:DCCoordinate = new DCCoordinate();
         conditionExtraPars = target.getDef().getConditionParameterSku();
         infoCoords = conditionExtraPars.split(",");
         coords.x = infoCoords[0];
         coords.y = infoCoords[1];
         camCoords = InstanceMng.getMapControllerPlanet().getCameraCenteredCoordinates();
         var x:int = Math.round(camCoords.x);
         var y:int = Math.round(camCoords.y);
         var areTheSame:Boolean;
         if((areTheSame = x == coords.x && y == coords.y) == false)
         {
            if(this.mOldPosX == x && this.mOldPosY == y)
            {
               this.mNumChecks++;
               if(this.mNumChecks == 10)
               {
                  areTheSame = true;
               }
            }
            else
            {
               this.mNumChecks = 0;
            }
            this.mOldPosX = x;
            this.mOldPosY = y;
         }
         return areTheSame;
      }
   }
}
