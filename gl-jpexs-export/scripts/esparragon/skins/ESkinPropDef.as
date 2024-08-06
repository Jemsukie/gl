package esparragon.skins
{
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class ESkinPropDef
   {
      
      public static const SKU_ID:String = "sku";
       
      
      private var mSku:String;
      
      private var mValues:Dictionary;
      
      public function ESkinPropDef(def:ESkinPropDef = null)
      {
         var k:* = null;
         var defValues:Dictionary = null;
         super();
         this.mValues = new Dictionary(true);
         if(def != null)
         {
            this.mSku = def.mSku;
            defValues = def.getValues();
            for(k in defValues)
            {
               this.mValues[k] = defValues[k];
            }
         }
      }
      
      public function fromXml(info:XML) : void
      {
         var i:int = 0;
         var name:String = null;
         var value:String = null;
         for(var attributes:XMLList,i = (attributes = EUtils.xmlGetAttributesAsXMLList(info)).length() - 1; i > -1; )
         {
            name = String(attributes[i].name());
            value = info.attribute(name);
            if(name == "sku")
            {
               this.setSku(value);
            }
            else
            {
               this.mValues[name] = value;
            }
            i--;
         }
      }
      
      public function getSku() : String
      {
         return this.mSku;
      }
      
      private function setSku(value:String) : void
      {
         this.mSku = value;
      }
      
      public function hasKey(key:String) : Boolean
      {
         return this.mValues[key] != null;
      }
      
      public function setValue(key:String, value:String) : void
      {
         this.mValues[key] = value;
      }
      
      public function getValueAsColor(key:String) : uint
      {
         return this.mValues[key] != null ? uint(parseInt(String(this.mValues[key]),16)) : 0;
      }
      
      public function getValueAsNumber(key:String) : Number
      {
         return this.mValues[key] != null ? Number(this.mValues[key]) : 0;
      }
      
      public function getValueAsInt(key:String) : int
      {
         return this.mValues[key] != null ? int(this.mValues[key]) : 0;
      }
      
      public function getValueAsString(key:String) : String
      {
         return this.mValues[key] != undefined ? String(this.mValues[key]) : null;
      }
      
      public function getValues() : Dictionary
      {
         return this.mValues;
      }
      
      public function getValueAsBoolean(key:String) : Boolean
      {
         return this.mValues[key] != undefined ? this.mValues[key] == "1" : false;
      }
   }
}
