package esparragon.behaviors
{
   import esparragon.core.Esparragon;
   import flash.utils.Dictionary;
   
   public class EBehaviorsMng
   {
      
      private static const CHANNEL_BEHAVIORS:String = "E_BEHAVIORS";
      
      public static const DISABLE:String = "Disable";
      
      public static const ENABLE:String = "Enable";
      
      public static const DISABLE_BASIC:String = "Disable_basic";
       
      
      private var mSharedSkuToBehaviors:Dictionary;
      
      private var mSharedBehaviorsToSku:Dictionary;
      
      public function EBehaviorsMng()
      {
         super();
      }
      
      public function poolReturnBehavior(value:EBehavior) : void
      {
         if(value != null && !this.isBehaviorShared(value))
         {
            value.destroy();
         }
      }
      
      public function destroy() : void
      {
         var k:* = null;
         var behavior:EBehavior = null;
         if(this.mSharedSkuToBehaviors != null)
         {
            for(k in this.mSharedSkuToBehaviors)
            {
               behavior = this.mSharedSkuToBehaviors[k] as EBehavior;
               behavior.destroy();
               delete this.mSharedSkuToBehaviors[k];
            }
            this.mSharedSkuToBehaviors = null;
         }
         this.mSharedBehaviorsToSku = null;
      }
      
      protected function sharedAddBehavior(sku:String, value:EBehavior) : void
      {
         var behavior:EBehavior = null;
         if(value != null)
         {
            if(this.mSharedSkuToBehaviors == null)
            {
               this.mSharedSkuToBehaviors = new Dictionary(true);
            }
            if(this.mSharedSkuToBehaviors[sku] != null)
            {
               behavior = this.mSharedSkuToBehaviors[sku];
               behavior.destroy();
            }
            this.mSharedSkuToBehaviors[sku] = value;
            if(this.mSharedBehaviorsToSku == null)
            {
               this.mSharedBehaviorsToSku = new Dictionary(true);
            }
            this.mSharedBehaviorsToSku[value] = sku;
         }
      }
      
      protected function sharedIsBehaviorBySku(sku:String) : Boolean
      {
         return this.mSharedSkuToBehaviors != null && this.mSharedSkuToBehaviors[sku] != null;
      }
      
      protected function isBehaviorShared(behavior:EBehavior) : Boolean
      {
         return this.mSharedBehaviorsToSku != null && this.mSharedBehaviorsToSku[behavior] != null;
      }
      
      protected function sharedGetBehavior(sku:String) : EBehavior
      {
         var returnValue:EBehavior = null;
         if(!this.sharedIsBehaviorBySku(sku))
         {
            Esparragon.traceMsg("[EBehaviorsMng.getBehavior] sku \'" + sku + "\' requested but not defined.\'");
         }
         else
         {
            returnValue = this.mSharedSkuToBehaviors[sku];
         }
         return returnValue;
      }
   }
}
