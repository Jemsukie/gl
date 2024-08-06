package esparragon.utils
{
   public class EVAlign
   {
      
      public static const TOP:String = "top";
      
      public static const CENTER:String = "center";
      
      public static const BOTTOM:String = "bottom";
       
      
      public function EVAlign()
      {
         super();
      }
      
      public static function isValid(vAlign:String) : Boolean
      {
         return vAlign == "top" || vAlign == "center" || vAlign == "bottom";
      }
   }
}
