package com.dchoc.game.eview.behaviors
{
   import esparragon.behaviors.EBehavior;
   import esparragon.display.ESprite;
   
   public class BehaviorPropertyBlink extends EBehavior
   {
       
      
      private var mTTL:int;
      
      private var mTarget:ESprite;
      
      private var mIsApplied:Boolean;
      
      private var mPropSku:String;
      
      public function BehaviorPropertyBlink(propSku:String)
      {
         super();
         this.mPropSku = propSku;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         this.mTarget = target;
         this.mTTL = 0;
      }
      
      override protected function extendedUnperform(target:ESprite, params:Object) : void
      {
         if(this.mIsApplied)
         {
            this.mTarget.unapplySkinProp(null,this.mPropSku);
         }
         this.mTarget = null;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         if(hasPerformed())
         {
            this.mTTL += dt;
            if(this.mTTL > 1000 && !this.mIsApplied)
            {
               this.mIsApplied = true;
               this.mTarget.applySkinProp(null,this.mPropSku);
            }
            else if(this.mTTL > 2000 && this.mIsApplied)
            {
               this.mIsApplied = false;
               this.mTarget.unapplySkinProp(null,this.mPropSku);
               this.mTTL %= 2000;
            }
         }
      }
   }
}
