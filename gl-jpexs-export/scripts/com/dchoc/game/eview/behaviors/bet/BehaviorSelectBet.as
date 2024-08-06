package com.dchoc.game.eview.behaviors.bet
{
   import com.dchoc.game.core.instance.InstanceMng;
   import esparragon.behaviors.EBehavior;
   import esparragon.display.ESprite;
   
   public class BehaviorSelectBet extends EBehavior
   {
       
      
      private var mSku:String;
      
      public function BehaviorSelectBet(sku:String)
      {
         super();
         this.mSku = sku;
      }
      
      override public function destroy() : void
      {
         this.mSku = null;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         InstanceMng.getBetMng().requestBet(this.mSku);
      }
   }
}
