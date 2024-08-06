package com.dchoc.game.eview.skins
{
   import esparragon.skins.ESkinsMng;
   import flash.utils.Dictionary;
   
   public class SkinsMng extends ESkinsMng
   {
      
      private static const SKINS_SKUS:Vector.<String> = new <String>["skin_basic_blue","skin_water","skin_sand","skin_dark","skin_nature","skinDefault"];
      
      private static const SKIN_TITLE_IDS:Vector.<int> = new <int>[703,707,705,715,3696];
      
      private static const SKIN_DESC_IDS:Vector.<int> = new <int>[704,708,706,716,3697];
      
      private static const FOUNDATION_TITLES:Vector.<int> = new <int>[3861,3862];
      
      private static const FOUNDATION_SKUS:Vector.<String> = new <String>["wio_bases","wio_old_bases"];
      
      private static const FOUNDATION_ASSETS:Vector.<String> = new <String>["assets/flash/world_items/buildings/bases/bases.swf","assets/flash/world_items/buildings/bases/bases_dirt.swf"];
      
      private static var foundations:Dictionary = new Dictionary();
       
      
      public function SkinsMng()
      {
         var i:int = 0;
         super();
         for(i = 0; i < FOUNDATION_SKUS.length; )
         {
            foundations[FOUNDATION_SKUS[i]] = FOUNDATION_ASSETS[i];
            i++;
         }
      }
      
      public static function getValidFoundationSku(sku:String) : String
      {
         return FOUNDATION_SKUS.indexOf(sku) > -1 ? sku : "wio_bases";
      }
      
      public static function getFoundationAssetFromSku(sku:String) : String
      {
         return foundations[getValidFoundationSku(sku)];
      }
      
      public function getTitlesVector() : Vector.<int>
      {
         return SKIN_TITLE_IDS;
      }
      
      public function getDescsVector() : Vector.<int>
      {
         return SKIN_DESC_IDS;
      }
      
      public function getSkinsVector() : Vector.<String>
      {
         return SKINS_SKUS;
      }
      
      public function getFoundationTitlesVector() : Vector.<int>
      {
         return FOUNDATION_TITLES;
      }
      
      public function getFoundations() : Dictionary
      {
         return foundations;
      }
      
      public function getFoundationSkusVector() : Vector.<String>
      {
         return FOUNDATION_SKUS;
      }
      
      public function getFoundationAssetsVector() : Vector.<String>
      {
         return FOUNDATION_ASSETS;
      }
      
      public function init() : void
      {
         var initialSkinId:String = Config.useEsparragonGUI() ? "skin_basic_blue" : "skin_old";
         doInit(SKINS_SKUS,"skins","skinDefault",initialSkinId,"wio_bases","wio_bases",Config.OFFLINE_GAMEPLAY_MODE);
      }
      
      public function cycleSkin() : void
      {
         var currentSkinSku:String = getCurrentSkinSku();
         var index:int = SKINS_SKUS.indexOf(currentSkinSku);
         index = (index + 1) % (SKINS_SKUS.length - 1);
         var skinSku:String = SKINS_SKUS[index];
         if(Config.useEsparragonGUI() && skinSku == "skin_old")
         {
            index = (index + 1) % (SKINS_SKUS.length - 1);
            skinSku = SKINS_SKUS[index];
         }
         super.changeSkin(skinSku);
      }
   }
}
