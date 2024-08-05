package esparragon.resources
{
   import esparragon.utils.EUtils;
   
   public class EAsset
   {
      
      private static const ATTRIBUTE_ID:String = "id";
      
      private static const ATTRIBUTE_GROUP_ID:String = "groupId";
      
      private static const ATTRIBUTE_SRC:String = "src";
      
      private static const ATTRIBUTE_TYPE:String = "type";
      
      private static const ATTRIBUTE_EMBEDDED_SKU:String = "embeddedSku";
      
      private static const ATTRIBUTE_CROP:String = "crop";
      
      private static const ATTRIBUTE_IS_GENERATED:String = "generated";
      
      private static const ATTRIBUTES_MANDATORY:Array = ["id","src","type"];
      
      private static const ATTRIBUTES_OPTIONAL:Array = ["groupId","embeddedSku","crop","generated"];
      
      private static var ATTRIBUTES_MANDATORY_SO_FAR:Vector.<Boolean> = new Vector.<Boolean>(ATTRIBUTES_MANDATORY.length);
       
      
      private var mId:String;
      
      private var mGroupId:String;
      
      private var mUrl:String;
      
      private var mType:String;
      
      private var mEmbeddedSku:String;
      
      private var mNeedsToBeCropped:Boolean;
      
      private var mIsGenerated:Boolean;
      
      public function EAsset(assetId:String, groupId:String)
      {
         super();
         this.mId = assetId;
         this.mGroupId = groupId;
         this.mEmbeddedSku = null;
         this.mType = null;
         this.mUrl = null;
      }
      
      public function clone(asset:EAsset) : void
      {
         this.mId = asset.getId();
         this.mUrl = asset.getUrl();
         this.mType = asset.getType();
         this.mEmbeddedSku = asset.getEmbeddedSku();
         this.mNeedsToBeCropped = asset.needsToBeCropped();
      }
      
      public function fromXml(xml:XML, groupId:String, loaderMng:ELoaderMng) : void
      {
         var index:int = 0;
         var attr:XML = null;
         var name:String = null;
         var attributeNamesMissing:* = null;
         for(index = ATTRIBUTES_MANDATORY_SO_FAR.length - 1; index > -1; )
         {
            ATTRIBUTES_MANDATORY_SO_FAR[index] = false;
            index--;
         }
         var attributeNamesNotSuppored:* = null;
         var attributes:XMLList = EUtils.xmlGetAttributesAsXMLList(xml);
         for each(attr in attributes)
         {
            name = String(attr.name());
            if((index = ATTRIBUTES_MANDATORY.indexOf(name)) > -1)
            {
               ATTRIBUTES_MANDATORY_SO_FAR[index] = true;
               this.setValue(name,xml);
            }
            else if((index = ATTRIBUTES_OPTIONAL.indexOf(name)) > -1)
            {
               this.setValue(name,xml);
            }
            else
            {
               name = EUtils.getNameInBrackets(name);
               if(attributeNamesNotSuppored == null)
               {
                  attributeNamesNotSuppored = name;
               }
               else
               {
                  attributeNamesNotSuppored += ", " + name;
               }
            }
         }
         attributeNamesMissing = null;
         for(index = ATTRIBUTES_MANDATORY_SO_FAR.length - 1; index > -1; )
         {
            if(!ATTRIBUTES_MANDATORY_SO_FAR[index])
            {
               name = EUtils.getNameInBrackets(ATTRIBUTES_MANDATORY[index]);
               if(attributeNamesMissing == null)
               {
                  attributeNamesMissing = name;
               }
               else
               {
                  attributeNamesMissing += ", " + name;
               }
            }
            index--;
         }
         if(attributeNamesMissing != null)
         {
            loaderMng.errorLogAssetMandatoryAttributesMissingInGroup(this.getGroupId(),this.getId(),attributeNamesMissing);
         }
         if(attributeNamesNotSuppored != null)
         {
            loaderMng.errorLogAssetAttributesNotSupportedInGroup(this.getGroupId(),this.getId(),attributeNamesNotSuppored);
         }
      }
      
      private function setValue(attributeName:String, xml:XML) : void
      {
         switch(attributeName)
         {
            case "id":
               this.setId(EUtils.xmlReadString(xml,attributeName));
               break;
            case "groupId":
               this.setGroupId(EUtils.xmlReadString(xml,attributeName));
               break;
            case "src":
               this.setUrl(EUtils.xmlReadString(xml,attributeName));
               break;
            case "type":
               this.setType(EUtils.xmlReadString(xml,attributeName));
               break;
            case "embeddedSku":
               this.setEmbeddedSku(EUtils.xmlReadString(xml,attributeName));
               break;
            case "crop":
               this.setNeedsToBeCropped(EUtils.xmlReadBoolean(xml,attributeName));
               break;
            case "generated":
               this.setIsGenerated(EUtils.xmlReadBoolean(xml,attributeName));
         }
      }
      
      public function destroy() : void
      {
         this.mId = null;
         this.mGroupId = null;
         this.mUrl = null;
         this.mType = null;
         this.mEmbeddedSku = null;
         this.mNeedsToBeCropped = false;
      }
      
      public function getId() : String
      {
         return this.mId;
      }
      
      private function setId(value:String) : void
      {
         this.mId = value;
      }
      
      public function getGroupId() : String
      {
         return this.mGroupId;
      }
      
      public function setGroupId(value:String) : void
      {
         this.mGroupId = value;
      }
      
      public function getUrl() : String
      {
         return this.mUrl;
      }
      
      public function setUrl(value:String) : void
      {
         this.mUrl = value;
      }
      
      public function getType() : String
      {
         return this.mType;
      }
      
      public function setType(value:String) : void
      {
         this.mType = value;
      }
      
      public function isEmbedded() : Boolean
      {
         return this.mEmbeddedSku != null;
      }
      
      public function getEmbeddedSku() : String
      {
         return this.mEmbeddedSku;
      }
      
      public function setEmbeddedSku(value:String) : void
      {
         this.mEmbeddedSku = value;
      }
      
      public function needsToBeCropped() : Boolean
      {
         return this.mNeedsToBeCropped;
      }
      
      private function setNeedsToBeCropped(value:Boolean) : void
      {
         this.mNeedsToBeCropped = value;
      }
      
      public function getIsGenerated() : Boolean
      {
         return this.mIsGenerated;
      }
      
      private function setIsGenerated(value:Boolean) : void
      {
         this.mIsGenerated = value;
      }
   }
}
