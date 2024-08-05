package com.dchoc.toolkit.core.text
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import esparragon.utils.EUtils;
   import flash.text.Font;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public class DCTextMng
   {
      
      private static const DEFAULT_EXPRESSION:String = "%U";
      
      public static const TEXT_LOADED:String = "TextLoaded";
      
      public static const MIN_FONT_SIZE:Number = 9;
      
      public static const MAX_CHAR_BUTTON:int = 25;
      
      public static const ARIAL_UNICODE_FONT:String = "Arial Unicode MS";
      
      public static const GUTTER:int = 4;
      
      public static const TRUNCATE_THOUSAND:int = 1;
      
      public static const TRUNCATE_MILLIONS:int = 2;
      
      private static var smTexts:Vector.<String>;
      
      private static var smLang:String;
      
      private static var smLangIsBuilt:Boolean;
      
      private static var smTimeTable:Array;
      
      public static var smChangeFont:Boolean;
      
      public static var smWordWrap:Boolean;
      
      public static var smAlign:String;
      
      public static const ALIGN_LEFT:String = "LEFT";
      
      public static const ALIGN_RIGHT:String = "RIGHT";
      
      public static const SPACE:String = " ";
      
      public static const BLANK:String = "";
      
      private static const ZERO:String = "0";
      
      private static const ARROBA:String = "@";
      
      public static const VERTICAL_ALIGN_TOP:int = 0;
      
      public static const VERTICAL_ALIGN_CENTER:int = 1;
      
      public static const VERTICAL_ALIGN_BOTTOM:int = 2;
      
      public static const NUMBER_FORMAT_NUMBER:int = 0;
      
      public static const NUMBER_FORMAT_TIME:int = 1;
      
      private static const TAG_ATTACKER_NAME:String = "%attackerName%";
      
      private static const TAG_ATTACKED_NAME:String = "%attackedName%";
      
      private static const TAG_USER_NAME:String = "%userName%";
      
      private static const TAG_TARGET_NAME:String = "%targetName%";
      
      private static const TAG_MISSION_NAME:String = "%missionName%";
      
      private static const TAG_USER_LEVEL:String = "%userLevel%";
      
      private static const TAG_TARGET_LEVEL:String = "%targetLevel%";
      
      private static const TAG_COIN_LOOT:String = "%coinLoot%";
      
      private static const TAG_MINERAL_LOOT:String = "%mineralLoot%";
      
      private static const TAG_WISHLIST_ITEMS:String = "%wishlistItems%";
      
      private static const TAG_ALLIANCE_USER_NAME:String = "%allianceUserName%";
      
      private static const TAG_ALLIANCE_TARGET_NAME:String = "%allianceTargetName%";
      
      private static const TAG_UNIT_NAME:String = "%unitName%";
      
      private static const TAG_BUILDING_NAME:String = "%buildingName%";
      
      private static const TAG_COLONY_AMOUNT:String = "%colonyAmount%";
      
      private static const TAG_UNIT_LEVEL:String = "%unitLevel%";
      
      private static const NUM_TAGS:int = 16;
      
      private static const TAGS_ARRAY:Array = new Array("%attackerName%","%attackedName%","%userName%","%targetName%","%missionName%","%userLevel%","%targetLevel%","%coinLoot%","%mineralLoot%","%wishlistItems%","%allianceUserName%","%allianceTargetName%","%unitName%","%buildingName%","%colonyAmount%","%unitLevel%");
      
      private static var smLangListIds:Array;
      
      private static var smLangListLoadingStr:Dictionary;
      
      private static var smLangListChangeFont:Dictionary;
      
      private static var smLangListWordWrap:Dictionary;
      
      private static var smLangListNativeText:Dictionary;
      
      private static var smLangListIsBuilt:Boolean;
      
      private static const HORIZONTAL_SCROLLING_DELAY:int = 40;
      
      private static const HORIZONTAL_SCROLLING_TURNOVER_DELAY:int = 2000;
      
      private static var smScrollTimer:int;
       
      
      public function DCTextMng()
      {
         super();
      }
      
      public static function load() : void
      {
         if(smTimeTable == null)
         {
            smTimeTable = [];
            smTimeTable["s"] = 1000;
            smTimeTable["m"] = 60 * smTimeTable["s"];
            smTimeTable["h"] = 60 * smTimeTable["m"];
            smTimeTable["d"] = 24 * smTimeTable["h"];
            smTimeTable["z"] = 1;
         }
         langListLoad();
      }
      
      public static function unload() : void
      {
         if(smTimeTable != null)
         {
            smTimeTable.splice(0,smTimeTable.length);
            smTimeTable = null;
         }
         langListUnload();
         smLangIsBuilt = false;
         smTexts = null;
         smLang = null;
         smChangeFont = false;
         smWordWrap = false;
         smAlign = null;
         smLangListChangeFont = null;
         smLangListIds = null;
         smLangListLoadingStr = null;
         smScrollTimer = 0;
      }
      
      public static function langListLoad() : void
      {
         if(smLangListIds == null)
         {
            smLangListIds = [];
            smLangListLoadingStr = new Dictionary(true);
            smLangListChangeFont = new Dictionary(true);
            smLangListWordWrap = new Dictionary(true);
            smLangListNativeText = new Dictionary();
         }
      }
      
      private static function langListUnload() : void
      {
         if(smLangListIds != null)
         {
            smLangListIds.splice(0,smLangListIds.length);
            smLangListIds = null;
         }
         smLangListLoadingStr = null;
         smLangListIsBuilt = false;
      }
      
      public static function langListBuild(xml:XML) : void
      {
         var attribute:String = null;
         var line:XML = null;
         var langId:String = null;
         for each(line in EUtils.xmlGetChildrenList(xml,"line"))
         {
            langId = EUtils.xmlReadString(line,"lang");
            smLangListIds.push(langId);
            smLangListLoadingStr[langId] = EUtils.xmlReadString(line,"text");
            smLangListChangeFont[langId] = false;
            smLangListWordWrap[langId] = true;
            smLangListNativeText[langId] = langId;
            attribute = "changeFont";
            if(EUtils.xmlIsAttribute(line,attribute))
            {
               smLangListChangeFont[langId] = EUtils.xmlReadBoolean(line,attribute);
            }
            attribute = "wordWrap";
            if(EUtils.xmlIsAttribute(line,attribute))
            {
               smLangListWordWrap[langId] = EUtils.xmlReadBoolean(line,attribute);
            }
            attribute = "nativeText";
            if(EUtils.xmlIsAttribute(line,attribute))
            {
               smLangListNativeText[langId] = EUtils.xmlReadString(line,attribute);
            }
         }
         smLangListIsBuilt = true;
      }
      
      public static function langListGetIds() : Array
      {
         return smLangListIds;
      }
      
      public static function langListGetNativeText() : Dictionary
      {
         return smLangListNativeText;
      }
      
      public static function langListIsBuilt() : Boolean
      {
         return smLangListIsBuilt;
      }
      
      public static function langListGetLoadingStr() : String
      {
         return smLangListLoadingStr[smLang];
      }
      
      public static function langGetDefaultLang() : String
      {
         return smLangListIds[0];
      }
      
      public static function langSetLang(lang:String = null) : void
      {
         if(lang == null)
         {
            lang = langGetDefaultLang();
         }
         else if(smLangListLoadingStr[lang] == null)
         {
            lang = langGetDefaultLang();
            if(Config.DEBUG_ASSERTS)
            {
               DCDebug.traceCh("TOOLKIT","TextManager.lang(): language " + lang + " is not available.",3);
            }
         }
         smLang = lang;
         smLangIsBuilt = false;
         smChangeFont = smLangListChangeFont[lang];
         smWordWrap = smLangListWordWrap[lang];
      }
      
      public static function get lang() : String
      {
         return smLang;
      }
      
      public static function langBuild(content:String) : void
      {
         var i:int = 0;
         var finalText:String = null;
         smTexts = new Vector.<String>(0);
         var text:Array;
         var textLength:int = int((text = content.split(/\n/)).length);
         for(i = 0; i < textLength; )
         {
            finalText = String(text[i]).replace(/(\\n |\\n)/g,"\n");
            smTexts.push(finalText);
            i++;
         }
         smLangIsBuilt = true;
      }
      
      public static function langIsBuilt() : Boolean
      {
         return smLangIsBuilt;
      }
      
      public static function checkTags(str:String) : String
      {
         var i:int = 0;
         var startIndex:int = 0;
         var currentTag:String = null;
         var text:String = null;
         for(i = 0; i < 16; )
         {
            currentTag = String(TAGS_ARRAY[i]);
            do
            {
               startIndex = str.indexOf(currentTag);
               if(startIndex > -1)
               {
                  if((text = getTextByTag(currentTag)) == null)
                  {
                     break;
                  }
                  str = str.replace(currentTag,text);
               }
            }
            while(startIndex > -1);
            
            i++;
         }
         return str;
      }
      
      public static function checkAndReplaceTargetName(str:String, wallName:String) : String
      {
         var startIndex:int = 0;
         var text:String = null;
         startIndex = str.indexOf("%targetName%");
         if(startIndex > -1)
         {
            str = str.replace("%targetName%",wallName);
         }
         return str;
      }
      
      public static function checkAndReplaceUserLevel(str:String, level:String) : String
      {
         var startIndex:int = 0;
         var text:String = null;
         startIndex = str.indexOf("%userLevel%");
         if(startIndex > -1)
         {
            str = str.replace("%userLevel%",level);
         }
         return str;
      }
      
      private static function getTextByTag(tag:String) : String
      {
         var alliance:Alliance = null;
         var gameUnit:GameUnit = null;
         switch(tag)
         {
            case "%attackerName%":
               return InstanceMng.getUserInfoMng().getAttacker().getPlayerName();
            case "%attackedName%":
               return InstanceMng.getUserInfoMng().getAttacked().getPlayerName();
            case "%userName%":
               return InstanceMng.getUserInfoMng().getProfileLogin().getPlayerName();
            case "%targetName%":
               return InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getPlayerName();
            case "%missionName%":
               return InstanceMng.getGUIControllerPlanet().getMissionName();
            case "%userLevel%":
               return InstanceMng.getUserInfoMng().getProfileLogin().getLevelFromScore().toString();
            case "%targetLevel%":
               return InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getLevelFromScore().toString();
            case "%coinLoot%":
               return InstanceMng.getUnitScene().getCoinsLooted().toString();
            case "%mineralLoot%":
               return InstanceMng.getUnitScene().getMineralsLooted().toString();
            case "%wishlistItems%":
               return InstanceMng.getItemsMng().getWishListNames();
            case "%allianceUserName%":
               alliance = InstanceMng.getAlliancesController().getMyAlliance();
               if(alliance != null)
               {
                  return alliance.getName();
               }
               break;
            case "%allianceTargetName%":
               alliance = InstanceMng.getAlliancesController().getEnemyAlliance();
               if(alliance != null)
               {
                  return alliance.getName();
               }
               break;
            case "%unitName%":
               if(gameUnit != null)
               {
                  return gameUnit.mDef.getNameToDisplay();
               }
               break;
            case "%unitLevel%":
               if(gameUnit != null)
               {
                  return (gameUnit.mDef.getUpgradeId() + 1).toString();
               }
               break;
            case "%buildingName%":
               return InstanceMng.getGUIControllerPlanet().getBuildingName();
            case "%colonyAmount%":
               return InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getColoniesAmount().toString();
         }
         return null;
      }
      
      public static function getText(tid:*) : String
      {
         var text:String = "";
         if(tid == null)
         {
            text = "";
         }
         if(tid is int)
         {
            if(tid == -1)
            {
               text = "";
            }
            else
            {
               if(tid >= smTexts.length)
               {
                  DCDebug.trace("ERROR: TID <" + tid + "> out of range for lang <" + smLang + ">.");
                  return "TID_MISSING_" + smLang + "_" + tid;
               }
               text = smTexts[tid];
            }
         }
         else if(tid is String)
         {
            text = tid as String;
         }
         return text;
      }
      
      public static function checkTextFieldGlyphs(field:TextField, text:String, defaultFont:String) : void
      {
         var font:* = null;
         var textAux:String = null;
         var format:TextFormat = null;
         var allFonts:Array = Font.enumerateFonts(false);
         for(font in allFonts)
         {
            if(allFonts[font].fontName == defaultFont)
            {
               (format = new TextFormat()).size = field.defaultTextFormat.size;
               textAux = text.split("\r").join("");
               if(allFonts[font].hasGlyphs(textAux))
               {
                  format.font = defaultFont;
                  field.setTextFormat(format);
                  field.embedFonts = true;
                  return;
               }
               changeFontName(field,"Arial Unicode MS");
               field.embedFonts = false;
               return;
            }
         }
      }
      
      public static function setTextColoured(field:TextField, tid:*, color:uint) : void
      {
         field.textColor = color;
         setText(field,tid);
      }
      
      public static function setText(field:TextField, tid:*, minFontSize:int = 0, autoWidth:Boolean = false, autoHeight:Boolean = false, reset:Boolean = false) : void
      {
         var str:String = null;
         var words:int = 0;
         var autoSize:String = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var w:Number = NaN;
         var h:Number = NaN;
         if(field != null)
         {
            field.gridFitType = "subpixel";
            if((str = getText(tid)) == null)
            {
               str = tid;
            }
            str = checkTags(str);
            if(field.text != str || reset)
            {
               if(field.scaleX != 1)
               {
                  field.scaleX = 1;
               }
               if(field.scaleY != 1)
               {
                  field.scaleY = 1;
               }
               field.text = str;
               if(smWordWrap && field.multiline)
               {
                  if((words = int(str.split(" ").length)) == 1)
                  {
                     field.multiline = false;
                     field.wordWrap = false;
                  }
               }
               checkTextFieldGlyphs(field,field.text,field.defaultTextFormat.font);
               changeColors(field);
               if(autoWidth || autoHeight)
               {
                  autoSize = field.autoSize;
                  x = field.x;
                  y = field.y;
                  w = field.width;
                  h = field.height;
                  field.autoSize = "center";
                  h = field.height;
                  w = field.width;
                  field.autoSize = autoSize;
                  field.x = x;
                  field.y = y;
                  field.width = w;
                  field.height = h;
               }
               else
               {
                  setTextScaled(field,minFontSize);
               }
            }
         }
      }
      
      public static function verticalAlignment(field:TextField, originalY:Number, type:int) : void
      {
         var textHeight:Number = NaN;
         if(field != null)
         {
            textHeight = field.textHeight + 4;
            switch(type)
            {
               case 0:
                  break;
               case 1:
                  field.y = originalY + (field.height - textHeight) / 2;
                  break;
               case 2:
                  field.y = originalY + field.height - textHeight;
            }
         }
      }
      
      public static function setButtonText(field:TextField, tid:*) : Boolean
      {
         var str:String = null;
         var textWidth:Number = NaN;
         var textLength:int = 0;
         var str2:String = null;
         var buttonHasToChangeSize:Boolean = false;
         if(field != null)
         {
            str = getText(tid);
            if(str == null)
            {
               str = tid;
            }
            if(field.text != str)
            {
               field.text = str;
               changeColors(field);
               checkTextFieldGlyphs(field,field.text,field.defaultTextFormat.font);
               if((textWidth = field.textWidth + 4) > field.width)
               {
                  textLength = str.length;
                  buttonHasToChangeSize = true;
                  if(textLength > 25)
                  {
                     str2 = str.substr(0,25);
                     field.text = str2;
                     field.width = textWidth;
                     field.text = str;
                     setTextScaled(field);
                  }
                  else
                  {
                     field.width = textWidth;
                  }
               }
            }
         }
         return buttonHasToChangeSize;
      }
      
      public static function trim(str:String, char:String = " ") : String
      {
         return trimBack(trimFront(str,char),char);
      }
      
      public static function trimFront(str:String, char:String) : String
      {
         char = stringToCharacter(char);
         if(str.charAt(0) == char)
         {
            str = trimFront(str.substring(1),char);
         }
         return str;
      }
      
      public static function trimBack(str:String, char:String) : String
      {
         char = stringToCharacter(char);
         if(str.charAt(str.length - 1) == char)
         {
            str = trimBack(str.substring(0,str.length - 1),char);
         }
         return str;
      }
      
      public static function stringToCharacter(str:String) : String
      {
         if(str.length == 1)
         {
            return str;
         }
         return str.slice(0,1);
      }
      
      public static function changeColors(field:TextField) : void
      {
         var i:int = 0;
         var colorStr:String = null;
         var color:Number = NaN;
         var startIndex:* = 0;
         var endIndex:int = 0;
         var colorSymbol:* = null;
         var colorNumber:Number = NaN;
         var format:TextFormat = null;
         var char:String = null;
         var currentFormat:TextFormat = null;
         var text:String = field.text;
         var htmlText:String = field.htmlText;
         var formats:Array = [];
         var length:int = text.length;
         var finalText:String = "";
         if(text == "")
         {
            formats = null;
            return;
         }
         i = 0;
         while(i < length)
         {
            if((char = text.charAt(i)) == "{")
            {
               colorNumber = Number(colorStr = text.substring(i + 1,i + 9));
               if(isNaN(colorNumber))
               {
                  finalText += char;
               }
               else
               {
                  color = int(colorNumber);
                  startIndex = i;
                  colorSymbol = char + colorStr + "}";
                  endIndex = (text = text.replace(colorSymbol,"")).indexOf("{/}");
                  text = text.replace("{/}","");
                  if(startIndex > -1 && endIndex > -1)
                  {
                     format = new TextFormat();
                     currentFormat = field.getTextFormat();
                     format.font = currentFormat.font;
                     format.color = int(color);
                     format.size = currentFormat.size;
                     formats.push(new Array(format,startIndex,endIndex));
                  }
                  i = -1;
                  length = text.length;
                  finalText = "";
               }
            }
            else
            {
               finalText += char;
            }
            i++;
         }
         if((length = int(formats.length)) > 0)
         {
            field.text = finalText;
            for(i = 0; i < length; )
            {
               format = formats[i][0];
               if((startIndex = int(formats[i][1])) < -1 || startIndex >= text.length)
               {
                  startIndex = -1;
               }
               if((endIndex = int(formats[i][2])) > text.length)
               {
                  endIndex = text.length;
               }
               field.setTextFormat(format,startIndex,endIndex);
               i++;
            }
         }
      }
      
      public static function setCapital(text:String) : String
      {
         var firstLetter:String = text.charAt();
         firstLetter = firstLetter.toUpperCase();
         return firstLetter + text.substr(1);
      }
      
      public static function replaceParametersInTemplate(text:String, params:Array) : String
      {
         var paramIndex:int = 0;
         var charIndex:int = -1;
         do
         {
            charIndex = text.indexOf("%U");
            if(charIndex > -1)
            {
               if((paramIndex = getParamIndex(charIndex,text)) == -1)
               {
                  text = text.replace("%U",params[0]);
               }
               else
               {
                  text = text.replace("%U" + paramIndex,params[paramIndex]);
               }
            }
         }
         while(charIndex > -1);
         
         return text;
      }
      
      public static function replaceParameters(obj:*, params:Array) : String
      {
         var text:String = getText(obj);
         if(text == null)
         {
            text = obj as String;
         }
         return replaceParametersInTemplate(text,params);
      }
      
      private static function getParamIndex(startIndex:int, text:String) : int
      {
         var char:String = null;
         startIndex += 2;
         var char0:int = "0".charCodeAt();
         var char9:int = "9".charCodeAt();
         var index:String = "";
         while((char = text.substr(startIndex,1)) != "" && char != null && char.charCodeAt() >= char0 && char.charCodeAt() <= char9)
         {
            index += char;
            startIndex++;
         }
         if(index == "")
         {
            return -1;
         }
         return int(index);
      }
      
      public static function restoreOriginalSize(field:TextField, size:Number) : void
      {
         var textLength:int = field.text.length;
         var currentFormat:TextFormat = field.defaultTextFormat;
         field.defaultTextFormat = new TextFormat(currentFormat.font,size);
         if(textLength != 0)
         {
            field.setTextFormat(field.defaultTextFormat,0,textLength);
         }
      }
      
      public static function restoreOriginalHeight(field:TextField, height:Number) : void
      {
         field.height = height;
      }
      
      public static function getTextWidth(field:TextField) : Number
      {
         var i:int = 0;
         var current:Number = NaN;
         var max:* = field.getLineMetrics(0).width;
         for(i = 0; i < field.numLines; )
         {
            current = field.getLineMetrics(i).width;
            if(current > max)
            {
               max = current;
            }
            i++;
         }
         return max;
      }
      
      public static function setTextScaled(text:TextField, minFontSize:int = 0) : void
      {
         var str:String = text.text;
         var menor:int = int(text.defaultTextFormat.size);
         var fieldWidth:Number = text.width;
         var fieldHeight:Number = text.height;
         var textWidth:Number = text.textWidth + 4;
         if(minFontSize == 0)
         {
            minFontSize = 9;
         }
         while(textWidth > fieldWidth)
         {
            menor--;
            changeFontSize(text,menor);
            textWidth = text.textWidth + 4;
            if(menor == minFontSize)
            {
               break;
            }
         }
         var textHeight:Number = text.textHeight + 4;
         while(textHeight > fieldHeight)
         {
            menor--;
            changeFontSize(text,menor);
            textHeight = text.textHeight + 4;
            if(menor == minFontSize)
            {
               break;
            }
         }
      }
      
      public static function changeFontSize(field:TextField, fontSize:int) : void
      {
         var currentFormat:TextFormat = field.defaultTextFormat;
         var format:TextFormat = new TextFormat(currentFormat.font,fontSize,currentFormat.color,currentFormat.bold,currentFormat.italic,currentFormat.underline,currentFormat.url,currentFormat.target,currentFormat.align,currentFormat.leftMargin,currentFormat.rightMargin,currentFormat.indent,currentFormat.leading);
         field.defaultTextFormat = format;
         field.text = field.text;
      }
      
      public static function changeFontName(field:TextField, fontName:String) : void
      {
         var currentFormat:TextFormat = field.defaultTextFormat;
         var format:TextFormat = new TextFormat(fontName,currentFormat.size,currentFormat.color,currentFormat.bold,currentFormat.italic,currentFormat.underline,currentFormat.url,currentFormat.target,currentFormat.align,currentFormat.leftMargin,currentFormat.rightMargin,currentFormat.indent,currentFormat.leading);
         field.defaultTextFormat = format;
         field.text = field.text;
      }
      
      public static function textDrawScrolling(text:TextField) : void
      {
         var offset:int = 0;
         var extra:int = 0;
         var TIME_1:int = 0;
         var TIME_2:int = 0;
         var TIME_3:int = 0;
         var TIME_4:int = 0;
         var totalScrollLength:* = 0;
         var time:int = 0;
         var stringWidth:Number = text.textWidth;
         if(stringWidth > text.width)
         {
            offset = 0;
            extra = stringWidth - text.width + 5;
            TIME_1 = 2000;
            totalScrollLength = TIME_4 = (TIME_3 = (TIME_2 = TIME_1 + extra * 40) + 2000) + extra * 40;
            if((time = smScrollTimer % totalScrollLength) < TIME_1)
            {
               offset = 0;
            }
            else if(time < TIME_2)
            {
               offset = -(time -= TIME_1) / 40;
            }
            else if(time < TIME_3)
            {
               offset = -extra;
            }
            else
            {
               time -= TIME_3;
               offset = -extra + time / 40;
            }
            text.scrollH = offset;
         }
      }
      
      public static function textResetTimer() : void
      {
         smScrollTimer = 0;
      }
      
      public static function textUpdate(deltaTime:int) : void
      {
         smScrollTimer += deltaTime;
      }
      
      public static function convertNumberToString(number:Number, truncate:int, maxDigits:int, forceFloor:Boolean = false) : String
      {
         var i:int = 0;
         var numberFigures:uint = 0;
         var numberText:String = "";
         var tail:String = "";
         var digits:int = number.toFixed(0).length;
         if(truncate == 1)
         {
            if(digits > maxDigits)
            {
               number = forceFloor ? Math.floor(number / 1000) : number / 1000;
               tail = "K";
               if(Math.abs(number).toFixed(0).length > maxDigits)
               {
                  number = forceFloor ? Math.floor(number / 1000) : number / 1000;
                  tail = "M";
               }
            }
         }
         if(truncate == 2)
         {
            if(digits > maxDigits)
            {
               number = forceFloor ? Math.floor(number / 1000000) : number / 1000000;
               tail = "M";
            }
         }
         if(number == 0)
         {
            numberText = "0";
         }
         else
         {
            numberText = number.toFixed(0);
         }
         var length:int = numberText.length;
         var returnNumber:String = "";
         for(i = length - 1; i >= 0; )
         {
            numberFigures++;
            if(uint(numberFigures + 1) == 4)
            {
               numberFigures = 1;
               returnNumber = getText(36) + returnNumber;
            }
            returnNumber = numberText.charAt(i) + returnNumber;
            i--;
         }
         return returnNumber + tail;
      }
      
      public static function convertNumberToStringWithDecimals(num:Number, fixed:int) : String
      {
         var str:String = null;
         var decimals:String = null;
         var i:int = 0;
         var decimalIndex:int;
         var numStr:String;
         if((decimalIndex = (numStr = num.toFixed(fixed)).indexOf(".")) > -1)
         {
            str = numStr.substring(0,decimalIndex);
            num = parseInt(str);
            str = convertNumberToString(num,2,10);
            for(i = (decimals = numStr.substr(decimalIndex + 1)).length - 1; i >= 0; )
            {
               if(decimals.charAt(i) != "0")
               {
                  break;
               }
               decimals = decimals.substr(0,i);
               i--;
            }
            if(decimals.length > 0)
            {
               str += getText(37) + decimals;
            }
            return str;
         }
         return numStr;
      }
      
      public static function convertNumberRanking(number:Number) : String
      {
         var length:int = 0;
         var i:int = 0;
         var numberFigures:uint = 0;
         var numberText:String = "";
         var tail:String = "";
         var maxDigits:int = 4;
         var digits:int;
         if((digits = number.toFixed(0).length) > maxDigits)
         {
            number /= 1000;
            tail = "K";
            number = int(numberText = number.toFixed(0));
            if(number >= 1000)
            {
               number /= 1000;
               if(number < 10)
               {
                  number *= 100;
                  number = int(numberText = number.toFixed(0));
                  number /= 100;
                  numberText = number.toFixed(2);
                  if(numberText.substr(numberText.length - 2) == "00")
                  {
                     numberText = numberText.substr(0,1);
                  }
               }
               else if(number < 100)
               {
                  numberText = number.toFixed(1);
                  if(numberText.substr(numberText.length - 1) == "0")
                  {
                     numberText = numberText.substr(0,2);
                  }
               }
               else
               {
                  numberText = int(number).toString();
               }
               tail = "M";
            }
            numberText = numberText.replace(/"."/g,getText(37));
         }
         var returnNumber:* = numberText;
         if(number >= 1000)
         {
            if(number == 0)
            {
               numberText = "0";
            }
            else
            {
               numberText = Math.round(number).toFixed(0);
            }
            length = numberText.length;
            returnNumber = "";
            for(i = length - 1; i >= 0; )
            {
               numberFigures++;
               if(numberFigures == 4)
               {
                  numberFigures = 1;
                  returnNumber = getText(36) + returnNumber;
               }
               returnNumber = numberText.charAt(i) + returnNumber;
               i--;
            }
         }
         return returnNumber + tail;
      }
      
      public static function convertTimeToString(time:Number, fixedText:Boolean, daysWithHours:Boolean = false) : String
      {
         var hour:int = 0;
         var hourText:String = null;
         var days:int = 0;
         var dayText:String = null;
         var min:int = 0;
         var minText:String = null;
         var secondsText:String = null;
         var finalText:String = null;
         var DAY:int = 86400;
         var seconds:int = time / 1000;
         if(time % 1000 > 0)
         {
            seconds++;
         }
         if(seconds >= DAY)
         {
            dayText = (days = seconds / DAY) + " " + getText(43);
            if(days == 1)
            {
               dayText = days + " " + getText(44);
            }
            if(daysWithHours)
            {
               if((hour = (seconds -= DAY * days) / 3600) > 0)
               {
                  if(hour == 1)
                  {
                     dayText += " " + hour + " " + getText(42);
                  }
                  else
                  {
                     dayText += " " + hour + " " + getText(41);
                  }
               }
            }
            return dayText;
         }
         min = seconds / 60;
         seconds %= 60;
         hour = min / 60;
         hourText = "" + hour;
         min %= 60;
         minText = "" + min;
         secondsText = "" + seconds;
         finalText = "";
         if(fixedText)
         {
            if(hour > 0)
            {
               finalText = hour + " " + getText(41);
               if(hour == 1)
               {
                  finalText = hour + " " + getText(42);
               }
               if(min == 0)
               {
                  return finalText;
               }
               return finalText + " " + minText + getText(40);
            }
            if(seconds == 0)
            {
               return minText + " " + getText(40);
            }
            if(min == 0)
            {
               return secondsText + " " + getText(38);
            }
            return minText + " " + getText(40) + " " + secondsText + " " + getText(38);
         }
         if(hour > 0)
         {
            finalText = hour + " " + getText(41);
            if(hour == 1)
            {
               finalText = hour + " " + getText(42);
            }
            if(min == 0)
            {
               return finalText;
            }
            return finalText + " " + minText + " " + getText(40);
         }
         return minText + " " + getText(40) + " " + secondsText + " " + getText(38);
      }
      
      public static function getMinutesString(time:Number) : String
      {
         time /= 60000;
         return "" + time;
      }
      
      public static function getStringFromTime(time:Number, useDays:Boolean = true, useHours:Boolean = true, useMinutes:Boolean = true, useSeconds:Boolean = true) : String
      {
         var DAY:int = 86400;
         var seconds:int = time / 1000;
         if(time % 1000 > 0)
         {
            seconds++;
         }
         var min:int = seconds / 60;
         seconds %= 60;
         var days:int;
         var hour:int;
         var dayText:* = (days = (hour = min / 60) / 24) + "d ";
         if(days < 10)
         {
            dayText = "0" + days + "d ";
         }
         var hourText:* = (hour %= 24) + "h ";
         if(hour < 10)
         {
            hourText = "0" + hour + "h ";
         }
         var minText:* = (min %= 60) + "m ";
         if(min < 10)
         {
            minText = "0" + min + "m ";
         }
         var secondsText:* = seconds + "s";
         if(seconds < 10)
         {
            secondsText = "0" + seconds + "s";
         }
         return "" + (useDays ? dayText : "") + (useHours ? hourText : "") + (useMinutes ? minText : "") + (useSeconds ? secondsText : "");
      }
      
      public static function convertTimeToStringColon(time:Number, useHours:Boolean = true, useHundredthSeconds:Boolean = false, battleTimeWithoutSeconds:Boolean = false, battleTimeOnlySeconds:Boolean = false) : String
      {
         var hour:int = 0;
         var hourText:String = null;
         var seconds:int = time / 1000;
         var hundredthSeconds:int;
         var hundredthSecondsText:String = (hundredthSeconds = time / 10 - seconds * 100) < 10 ? "0" + hundredthSeconds : "" + hundredthSeconds;
         if(time % 1000 > 0)
         {
            seconds++;
         }
         var min:int = seconds / 60;
         seconds %= 60;
         hour = min / 60;
         hourText = "" + hour;
         if(hour < 10)
         {
            hourText = "0" + hour;
         }
         min %= 60;
         var minText:String = "" + min;
         if(min < 10)
         {
            minText = "0" + min;
         }
         var secondsText:String = "" + seconds;
         if(seconds < 10)
         {
            secondsText = "0" + seconds;
         }
         var finalText:* = minText + ":" + secondsText;
         if(useHours)
         {
            finalText = hourText + ":" + finalText;
         }
         if(useHundredthSeconds)
         {
            finalText = finalText + ":" + hundredthSecondsText;
         }
         if(battleTimeWithoutSeconds)
         {
            finalText = hourText + ":" + minText + ":";
         }
         if(battleTimeOnlySeconds)
         {
            finalText = secondsText;
         }
         return finalText;
      }
      
      public static function getTimeUnits(time:Number) : String
      {
         var min:int = 0;
         var hour:int = 0;
         var hourText:String = null;
         var DAY:int = 86400;
         var seconds:int = time / 1000;
         if(time % 1000 > 0)
         {
            seconds++;
         }
         if(seconds >= DAY)
         {
            return int(seconds / DAY) + " " + getText(43);
         }
         min = seconds / 60;
         seconds %= 60;
         hour = min / 60;
         hourText = "" + hour;
         if(hour < 10)
         {
            hourText = "0" + hour;
         }
         return hour + " " + getText(41);
      }
      
      public static function convertStringToTime(timeStr:String) : int
      {
         var unit:String = timeStr.substr(timeStr.length - 1);
         var value:int = int(timeStr.substr(0,timeStr.length - 1));
         if(unit >= "0" && unit <= "9")
         {
            unit = "z";
         }
         return value * smTimeTable[unit];
      }
      
      public static function convertTimeToStringShortened(time:Number) : String
      {
         var HOUR:int;
         var MINUTE:int;
         var DAY:int = (HOUR = (MINUTE = 60) * 60) * 24;
         var hours:int = 0;
         var days:int = 0;
         var min:int = 0;
         var seconds:int = Math.ceil(time / 1000);
         if(seconds >= DAY)
         {
            if((days = Math.ceil(seconds / DAY)) == 1)
            {
               return days + " " + getText(44);
            }
            return days + " " + getText(43);
         }
         if(seconds >= HOUR)
         {
            hours = Math.ceil(seconds / HOUR);
            if(hours == 1)
            {
               return hours + " " + getText(42);
            }
            return hours + " " + getText(41);
         }
         if(seconds >= MINUTE)
         {
            if((min = Math.ceil(seconds / MINUTE)) == 1)
            {
               return min + " " + getText(39);
            }
            return min + " " + getText(40);
         }
         return seconds + " " + getText(38);
      }
      
      public static function isMail(arg:String) : Boolean
      {
         var parts:Array = null;
         var user:String = null;
         var domain:String = null;
         var domain_parts:Array = null;
         var extension:String = null;
         if(arg == "" || arg == null || arg == "null" || arg == "undefined")
         {
            return false;
         }
         if(arg.indexOf("@") == -1 || arg.indexOf("@") != arg.lastIndexOf("@"))
         {
            return false;
         }
         user = String((parts = arg.split("@"))[0]);
         domain = String(parts[1]);
         if(user.length < 1)
         {
            return false;
         }
         if(domain.indexOf(".") == -1 || domain.length < 1)
         {
            return false;
         }
         domain_parts = domain.split(".");
         extension = String(domain_parts[domain_parts.length - 1]);
         if(domain.length - extension.length < 4)
         {
            return false;
         }
         return !(extension.length < 2 || extension.length > 4);
      }
      
      public static function getStringAsBoolean(value:String) : Boolean
      {
         return value == "1";
      }
      
      public static function println(msg:String) : void
      {
      }
      
      public static function intFormat(n:int, minimumLength:int) : String
      {
         var v:String = n.toString();
         var stillNeed:int;
         return (stillNeed = minimumLength - v.length) < 0 ? v : (Math.pow(10,stillNeed) + v).substr(1);
      }
      
      public static function getTextsByTidPrefix(prefix:String, queryClass:Class, caseSensitive:Boolean = true) : Vector.<String>
      {
         var constName:String = null;
         var obj:XML = null;
         var constList:XMLList = describeType(queryClass).descendants("constant");
         var texts:Vector.<String> = new Vector.<String>(0);
         for each(obj in constList)
         {
            if((constName = EUtils.xmlReadString(obj,"name")).indexOf(prefix) == 0 || !caseSensitive && constName.toLowerCase().indexOf(prefix.toLowerCase()) == 0)
            {
               texts.push(getText(queryClass[constName]));
            }
         }
         return texts;
      }
      
      public static function getPlanetText(starType:String) : String
      {
         switch(starType)
         {
            case "0":
               return DCTextMng.getText(2770);
            case "1":
               return DCTextMng.getText(2771);
            case "2":
               return DCTextMng.getText(2774);
            case "3":
               return DCTextMng.getText(2775);
            case "4":
               return DCTextMng.getText(2773);
            case "5":
               return DCTextMng.getText(2772);
            default:
               return "";
         }
      }
      
      public static function getCountdownTimeLeft(timeMs:Number) : String
      {
         var returnValue:String = null;
         var daysLeft:int = 0;
         var timeLeft:Number;
         if((timeLeft = timeMs - InstanceMng.getUserDataMng().getServerCurrentTimemillis()) < 86400000)
         {
            if(timeLeft < 0)
            {
               timeLeft = 0;
            }
            returnValue = String(DCTextMng.convertTimeToStringColon(timeLeft));
         }
         else
         {
            daysLeft = Math.ceil(timeLeft / 86400000);
            returnValue = daysLeft.toString() + " " + getText(43);
         }
         return returnValue;
      }
      
      public static function getCountdownTime(timeMs:Number) : String
      {
         var returnValue:String = null;
         var daysLeft:int = 0;
         var timeLeft:*;
         if((timeLeft = timeMs) < 86400000)
         {
            if(timeLeft < 0)
            {
               timeLeft = 0;
            }
            returnValue = String(DCTextMng.convertTimeToStringColon(timeLeft));
         }
         else
         {
            daysLeft = Math.ceil(timeLeft / 86400000);
            returnValue = daysLeft.toString() + " " + getText(43);
         }
         return returnValue;
      }
      
      public static function stringTidToText(tid:String) : String
      {
         return getText(TextIDs[tid]);
      }
      
      public static function tidsToTexts(tids:Vector.<int>) : Vector.<String>
      {
         var i:int = 0;
         var length:int = int(tids.length);
         var returnValue:Vector.<String> = new Vector.<String>(0);
         for(i = 0; i < length; )
         {
            returnValue.push(getText(tids[i]));
            i++;
         }
         return returnValue;
      }
      
      public static function stringTidsToTexts(tids:Vector.<String>) : Vector.<String>
      {
         var i:int = 0;
         var length:int = int(tids.length);
         var returnValue:Vector.<String> = new Vector.<String>(0);
         for(i = 0; i < length; )
         {
            returnValue.push(stringTidToText(tids[i]));
            i++;
         }
         return returnValue;
      }
   }
}
