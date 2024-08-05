package com.dchoc.game.eview.widgets.smallStructures
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.umbrella.UmbrellaMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   
   public class IconBarUmbrella extends IconBar
   {
       
      
      private var mUmbrellasAmount:int;
      
      private var mUmbrellaMng:UmbrellaMng;
      
      public function IconBarUmbrella()
      {
         super();
      }
      
      override protected function reset() : void
      {
         super.reset();
         this.mUmbrellasAmount = -1;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var newUmbrellasAmount:int = 0;
         super.logicUpdate(dt);
         if(this.mUmbrellaMng == null)
         {
            this.mUmbrellaMng = InstanceMng.getUmbrellaMng();
         }
         if(this.mUmbrellaMng != null && this.mUmbrellaMng.isRunning())
         {
            newUmbrellasAmount = this.mUmbrellaMng.getUmbrellasAmount();
            if(newUmbrellasAmount != this.mUmbrellasAmount)
            {
               this.setUmbrellasAmount(newUmbrellasAmount);
            }
            setBarMaxValue(this.mUmbrellaMng.getOneUmbrellaMaxEnergy());
            setBarCurrentValue(this.mUmbrellaMng.getOneUmbrellaCurrentEnergy());
         }
      }
      
      private function setUmbrellasAmount(value:int) : void
      {
         this.mUmbrellasAmount = value;
         var str:String = DCTextMng.replaceParameters(3363,[this.mUmbrellasAmount]);
         updateText(str);
      }
      
      override protected function getBarFillColor() : String
      {
         var colors:Array = GameConstants.UNIT_ENERGY_BAR_COLORS;
         var colorsLength:int = int(colors.length);
         var color:int = colorsLength * mBarCurrent / mBarMax;
         if(color >= colorsLength)
         {
            color = colorsLength - 1;
         }
         return colors[color];
      }
   }
}
