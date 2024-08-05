package esparragon.layout
{
   import esparragon.layout.behaviors.ELayoutBehavior;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   
   public class ELayoutAreaFactoriesMng
   {
       
      
      private var mCatalog:Dictionary;
      
      protected var mColorsToBehaviors:Dictionary;
      
      public function ELayoutAreaFactoriesMng()
      {
         super();
      }
      
      public function destroy() : void
      {
         var k:* = null;
         var factory:ELayoutAreaFactory = null;
         var key:* = null;
         var behavior:ELayoutBehavior = null;
         if(this.mCatalog != null)
         {
            for(k in this.mCatalog)
            {
               factory = this.mCatalog[k] as ELayoutAreaFactory;
               factory.destroy();
               delete this.mCatalog[k];
            }
            this.mCatalog = null;
         }
         if(this.mColorsToBehaviors != null)
         {
            for(key in this.mColorsToBehaviors)
            {
               behavior = this.mColorsToBehaviors[key];
               behavior.destroy();
               delete this.mColorsToBehaviors[key];
            }
            this.mColorsToBehaviors = null;
         }
      }
      
      public function createFactoryFromDisplayObjectContainer(displayObjectContainer:DisplayObjectContainer) : ELayoutAreaFactory
      {
         return new ELayoutAreaFactory(displayObjectContainer,this.mColorsToBehaviors);
      }
      
      protected function createFactory(sku:String) : ELayoutAreaFactory
      {
         return null;
      }
      
      protected function addFactoryToCatalog(sku:String, factory:ELayoutAreaFactory) : void
      {
         if(this.mCatalog == null)
         {
            this.mCatalog = new Dictionary();
         }
         this.mCatalog[sku] = factory;
      }
      
      public function getFactory(sku:String) : ELayoutAreaFactory
      {
         var factory:ELayoutAreaFactory = null;
         if(this.mCatalog == null || this.mCatalog[sku] == null)
         {
            factory = this.createFactory(sku);
            if(factory == null)
            {
               throw new Error("[ELayoutAreaFactoryMng.getFactory] sku \'" + sku + "\' not defined. Please, add its definition in createFactory() method. \'");
            }
            this.addFactoryToCatalog(sku,factory);
         }
         return this.mCatalog[sku];
      }
      
      protected function addColorBehavior(color:uint, behavior:ELayoutBehavior) : void
      {
         if(this.mColorsToBehaviors == null)
         {
            this.mColorsToBehaviors = new Dictionary();
         }
         this.mColorsToBehaviors[color] = behavior;
      }
      
      public function getColoBehavior(color:uint) : ELayoutBehavior
      {
         if(this.mColorsToBehaviors != null)
         {
            return this.mColorsToBehaviors[color];
         }
         return null;
      }
   }
}
