package com.dchoc.toolkit.core.debug
{
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.core.view.display.DCStage;
   import com.luaye.console.C;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.system.System;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class DCDebug
   {
      
      public static var DEBUG:Boolean = Config.DEBUG_CONSOLE;
      
      public static const TYPE_NORMAL:int = 0;
      
      public static const TYPE_ASSERT:int = 1;
      
      public static const TYPE_ERROR:int = 3;
      
      public static const CHANNEL_ASSERT:String = "ASSERT";
      
      public static const CHANNEL_ERROR:String = "ERROR";
      
      public static const CHANNEL_LOADING:String = "LOADING";
      
      public static const CHANNEL_SERVER:String = "SERVER";
      
      public static const CHANNEL_TOOLKIT:String = "TOOLKIT";
      
      public static const CHANNEL_MEMORY:String = "MEMORY";
      
      public static const CHANNEL_PROFILING:String = "PROFILING";
      
      public static const CHANNEL_ALLIANCES:String = "ALLIANCES";
      
      public static const CHANNEL_INVESTS:String = "INVESTS";
      
      public static const CHANNEL_QUICK_ATTACK:String = "quickAttack";
      
      public static const CHANNEL_HAPPENING:String = "HAPP";
      
      public static const CHANNEL_CONTEST:String = "CONTEST";
      
      public static const CHANNEL_BETS:String = "bets";
      
      public static const CHANNEL_VIEW_FACTORY:String = "VIEW_FACTORY";
      
      public static const CHANNEL_SPIL_AD:String = "spilAd";
      
      public static const CHANNEL_PAYMENTS:String = "payments";
      
      public static const CHANNEL_BATTLE_REPLAY:String = "BattleReplay";
      
      public static const CHANNEL_ATTACK_LOGIC:String = "AttackLogic";
      
      public static const CHANNEL_PENDING_TRANSACTION:String = "PendingTransaction";
      
      public static const CHANNEL_FLAGS:String = "Flags";
      
      public static const CHANNEL_SIG:String = "Sig";
      
      public static const CHANNEL_SIG_BATTLE:String = "SigBattle";
      
      public static const CHANNEL_SIG_WORLD:String = "SigWorld";
      
      public static const CHANNEL_BATTLE:String = "Battle";
      
      private static const TYPE_PREFIX:Array = ["","################## ASSERT: ","@@@@@@@@@@@@@@@@@@   TODO: ","!!!!!!!!!!!!!!!!!!  ERROR: "];
      
      private static const TYPE_CHANNEL:Array = [null,"ASSERT",null,"ERROR"];
      
      public static var allowConsoleVisible:Boolean = true;
      
      private static var smContext:InteractiveObject;
      
      private static var smStage:DCStage;
      
      private static var smFullWindow:Boolean;
      
      private static var smPrevConX:Number;
      
      private static var smPrevConY:Number;
      
      private static var smPrevConWidth:Number;
      
      private static var smPrevConHeight:Number;
      
      private static var smPopupBody:Sprite;
      
      private static var smPopupEnabled:Boolean;
      
      private static var smHaltApplication:Boolean;
      
      private static var pows:Object = {
         "b":0,
         "k":10,
         "m":20,
         "t":30
      };
      
      private static var digits:Object = {
         "b":0,
         "k":0,
         "m":2,
         "t":4
      };
       
      
      public function DCDebug()
      {
         super();
      }
      
      public static function startDebug(dcstage:DCStage, context:InteractiveObject) : void
      {
         smStage = dcstage;
         smContext = context;
         smPopupEnabled = false;
         smHaltApplication = false;
         smFullWindow = false;
      }
      
      public static function traceDisplayList(parent:DisplayObjectContainer) : void
      {
         var i:int = 0;
         var child:DisplayObject = null;
         if(DEBUG)
         {
            for(i = 0; i < parent.numChildren; )
            {
               child = parent.getChildAt(i);
               DCTextMng.println("child[" + i + "] = " + child + fullyQualifiedName(child));
               i++;
            }
         }
      }
      
      public static function startConsole(stage:DCStage) : void
      {
         if(DEBUG)
         {
            C.start(stage.getImplementation(),"gl");
            C.x = 0;
            C.y = 0;
            C.width = 500;
            C.height = 50;
            C.visible = Config.DEBUG_MODE;
         }
      }
      
      public static function trace(str:String, typeId:int = 0) : void
      {
         if(DEBUG)
         {
            if(TYPE_CHANNEL[typeId] == null)
            {
               DCTextMng.println(TYPE_PREFIX[typeId] + str);
               C.add(str);
            }
            else
            {
               traceCh(TYPE_CHANNEL[typeId],str);
            }
         }
      }
      
      public static function traceCh(channel:String, str:String, typeId:int = 0, throwException:Boolean = false) : void
      {
         if(DEBUG)
         {
            if(!Config.DEBUG_BATTLE && channel == "Battle" || !Config.DEBUG_FLAGS && channel == "Flags" || !Config.DEBUG_SIG && ["Sig","SigWorld","SigBattle"].indexOf(channel) > -1)
            {
               return;
            }
            DCTextMng.println(channel + "> " + TYPE_PREFIX[typeId] + str);
            C.ch(channel,str);
         }
         if(throwException)
         {
            throw Error(str);
         }
      }
      
      public static function setVisible(value:Boolean) : void
      {
         if(DEBUG)
         {
            C.visible = value && allowConsoleVisible;
         }
      }
      
      public static function getVisible() : Boolean
      {
         if(DEBUG)
         {
            return C.visible;
         }
         return false;
      }
      
      public static function getMemoryUsed(unit:String) : Number
      {
         System.gc();
         var p:uint = uint(pows[unit.toLowerCase()]);
         return System.totalMemory / Math.pow(2,p);
      }
      
      public static function getMemoryUsedAsString(unit:String) : String
      {
         var t:Number = getMemoryUsed(unit);
         var d:uint = uint(digits[unit.toLowerCase()]);
         return t.toFixed(d).toString();
      }
      
      public static function traceObject(obj:Object, prefix:String = "") : void
      {
         traceChObject(null,obj,prefix);
      }
      
      public static function traceChObject(channel:String, obj:Object, prefix:String = "") : void
      {
         var str:String = null;
         var arrayAry:Array = null;
         var arrayObj:Array = null;
         var param:String = null;
         var value:Object = null;
         var count:uint = 0;
         var index:uint = 0;
         if(DEBUG && obj != null)
         {
            try
            {
               if(!(obj is Array || obj.constructor != null && obj.constructor.toString().indexOf("Object") != -1))
               {
                  if(channel == null)
                  {
                     DCDebug.trace(prefix + "> " + obj);
                  }
                  else
                  {
                     DCDebug.traceCh(channel,prefix + "> " + obj);
                  }
                  return;
               }
               arrayAry = [];
               arrayObj = [];
               for(param in obj)
               {
                  value = obj[param];
                  if(obj[param] is Array)
                  {
                     arrayAry.push(param);
                  }
                  else if(value != null && value.constructor != null && value.constructor.toString().indexOf("Object") != -1)
                  {
                     arrayObj.push(param);
                  }
                  else
                  {
                     str = prefix + "- " + param + " = " + obj[param];
                     if(channel == null)
                     {
                        DCDebug.trace(str);
                     }
                     else
                     {
                        DCDebug.traceCh(channel,str);
                     }
                  }
               }
               for each(param in arrayObj)
               {
                  str = prefix + "+ " + param + "{}";
                  if(channel == null)
                  {
                     DCDebug.trace(str);
                  }
                  else
                  {
                     DCDebug.traceCh(channel,str);
                  }
                  traceChObject(channel,obj[param],prefix + "---- ");
               }
               for each(param in arrayAry)
               {
                  if((count = uint(obj[param].length)) == 0)
                  {
                     str = prefix + "+ " + param + "[]";
                     if(channel == null)
                     {
                        DCDebug.trace(str);
                     }
                     else
                     {
                        DCDebug.traceCh(channel,str);
                     }
                  }
                  else
                  {
                     index = 0;
                     while(index < count)
                     {
                        str = prefix + "+ " + param + "[" + index + "/" + count + "]";
                        if(channel == null)
                        {
                           DCDebug.trace(str);
                        }
                        else
                        {
                           DCDebug.traceCh(channel,str);
                        }
                        traceChObject(channel,obj[param][index],prefix + "---- ");
                        index++;
                     }
                  }
               }
            }
            catch(e:Error)
            {
               DCDebug.trace("*** traceChObject *** Error *** " + e.message);
            }
         }
      }
      
      public static function traceXML(xml:XML) : void
      {
         if(DEBUG)
         {
            DCDebug.traceCh("TOOLKIT","-*-*-*-*-*-*-*-*-*-*");
            DCDebug.traceCh("TOOLKIT",xml.toXMLString());
            DCDebug.traceCh("TOOLKIT","-*-*-*-*-*-*-*-*-*-*");
         }
      }
      
      public static function setFullWindow(value:Boolean) : void
      {
         if(DEBUG)
         {
            if(smFullWindow != value)
            {
               smFullWindow = value;
               setVisible(false);
               if(smFullWindow)
               {
                  smPrevConX = C.x;
                  smPrevConY = C.y;
                  smPrevConWidth = C.width;
                  smPrevConHeight = C.height;
                  C.x = 5;
                  C.y = 25;
                  C.width = smContext.stage.stageWidth - 10;
                  C.height = smContext.stage.stageHeight - 30;
               }
               else
               {
                  C.x = smPrevConX;
                  C.y = smPrevConY;
                  C.width = smPrevConWidth;
                  C.height = smPrevConHeight;
               }
               setVisible(true);
            }
         }
      }
      
      public static function getFullWindow() : Boolean
      {
         return smFullWindow;
      }
      
      public static function debugPopup(s:String, haltApplication:Boolean = false) : void
      {
         var a:Array = new Array(s);
         debugPopupArray(a,haltApplication);
      }
      
      public static function debugPopupArray(a:Array, haltApplication:Boolean = false) : void
      {
         var textY:int = 0;
         var s:String = null;
         var t:TextField = null;
         if(!smPopupEnabled)
         {
            smPopupEnabled = true;
            smHaltApplication = haltApplication;
            if(!smPopupBody)
            {
               smPopupBody = new Sprite();
               smPopupBody.x = 5;
               smPopupBody.y = 25;
               smPopupBody.graphics.lineStyle(0,8092571);
               smPopupBody.graphics.beginFill(11583696);
               smPopupBody.graphics.drawRoundRect(0,0,smContext.stage.stageWidth - 10,smContext.stage.stageHeight - 35,10,10);
               smPopupBody.graphics.endFill();
            }
            textY = 0;
            for each(s in a)
            {
               (t = new TextField()).text = s;
               t.x = 5;
               t.y = textY;
               t.width = smContext.stage.stageWidth - 20;
               t.wordWrap = true;
               t.height = t.textHeight + 4;
               textY += t.height;
               smPopupBody.addChild(t);
            }
            smStage.addChild(smPopupBody);
            smStage.addEventListener("keyDown",closePopup);
            smStage.addEventListener("click",closePopup);
         }
      }
      
      public static function closePopup(e:Event) : void
      {
         var numChildren:int = 0;
         var i:int = 0;
         if(smPopupEnabled)
         {
            smPopupEnabled = false;
            smHaltApplication = false;
            smStage.removeEventListener("keyDown",closePopup);
            smStage.removeEventListener("click",closePopup);
            smStage.removeChild(smPopupBody);
            numChildren = smPopupBody.numChildren;
            for(i = 0; i < numChildren; )
            {
               smPopupBody.removeChildAt(0);
               i++;
            }
         }
      }
      
      public static function isApplicationHalted() : Boolean
      {
         return smHaltApplication;
      }
      
      public static function traceStack(_depth:int) : void
      {
         var str:String = "";
         var strs:Array = null;
         var c1:int = 0;
         var e:Error;
         str = (e = new Error()).getStackTrace();
         strs = str.split("\n");
         while(c1 < _depth)
         {
            str += strs[c1] + "\n";
            c1 += 1;
         }
      }
      
      public static function fullyQualifiedName(param1:DisplayObject) : String
      {
         var fullChildName:* = param1.name;
         while(param1.parent)
         {
            param1 = param1.parent;
            fullChildName = param1.name + "." + fullChildName;
         }
         return fullChildName;
      }
      
      public static function millisToReadable(millis:Number) : String
      {
         var seconds:Number = NaN;
         var minutes:Number = NaN;
         var hours:Number = NaN;
         var days:* = 0;
         var out:String = null;
         var secondsRemainder:uint = 0;
         var minutesRemainder:uint = 0;
         var hoursRemainder:uint = 0;
         if(DEBUG)
         {
            try
            {
               out = "";
               seconds = millis / 1000;
               if((secondsRemainder = seconds % 60) > 0 || seconds == 0)
               {
                  out = secondsRemainder + " seg" + out;
               }
               if(seconds >= 60)
               {
                  if((minutesRemainder = (minutes = seconds / 60) % 60) > 0)
                  {
                     out = minutesRemainder + " min" + (out.length > 0 ? ", " + out : "");
                  }
                  if(minutes >= 60)
                  {
                     hours = minutes / 60;
                     if((hoursRemainder = hours % 24) > 0)
                     {
                        out = hoursRemainder + " hour" + (out.length > 0 ? ", " + out : "");
                     }
                     if(hours >= 24)
                     {
                        out = (days = hours / 24) + " day" + (out.length > 0 ? ", " + out : "");
                     }
                  }
               }
               return "(" + out + ")";
            }
            catch(e:Error)
            {
            }
         }
         return "";
      }
      
      public static function getMemoryAddress(obj:Object) : String
      {
         var memoryAddress:String = null;
         try
         {
            if(obj is ByteArray)
            {
               MovieClip(obj);
            }
            else
            {
               ByteArray(obj);
            }
         }
         catch(e:Error)
         {
            memoryAddress = String(e).replace(/.*([@|\$].*?) to .*$/gi,"$1");
         }
         return memoryAddress;
      }
   }
}
