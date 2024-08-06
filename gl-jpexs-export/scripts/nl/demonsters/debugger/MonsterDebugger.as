package nl.demonsters.debugger
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.AsyncErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.net.LocalConnection;
   import flash.system.System;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.describeType;
   
   public class MonsterDebugger
   {
      
      private static var instance:MonsterDebugger = null;
      
      public static const COLOR_NORMAL:uint = 1118481;
      
      public static const COLOR_ERROR:uint = 16711680;
      
      public static const COLOR_WARNING:uint = 16724736;
       
      
      private var lineOut:LocalConnection;
      
      private var lineIn:LocalConnection;
      
      private const LINE_OUT:String = "_debuggerRed";
      
      private const LINE_IN:String = "_debuggerBlue";
      
      private const ALLOWED_DOMAIN:String = "*";
      
      private const COMMAND_HELLO:String = "HELLO";
      
      private const COMMAND_HELLO_RESPONSE:String = "HELLO_RESPONSE";
      
      private const COMMAND_ROOT:String = "ROOT";
      
      private const COMMAND_BASE:String = "BASE";
      
      private const COMMAND_TRACE:String = "TRACE";
      
      private const COMMAND_INSPECT:String = "INSPECT";
      
      private const COMMAND_GET_OBJECT:String = "GET_OBJECT";
      
      private const COMMAND_GET_DISPLAYOBJECT:String = "GET_DISPLAYOBJECT";
      
      private const COMMAND_GET_PROPERTIES:String = "GET_PROPERTIES";
      
      private const COMMAND_GET_FUNCTIONS:String = "GET_FUNCTIONS";
      
      private const COMMAND_SET_PROPERTY:String = "SET_PROPERTY";
      
      private const COMMAND_CALL_METHOD:String = "CALL_METHOD";
      
      private const COMMAND_SHOW_HIGHLIGHT:String = "SHOW_HIGHLIGHT";
      
      private const COMMAND_HIDE_HIGHLIGHT:String = "HIDE_HIGHLIGHT";
      
      private const COMMAND_CLEAR_TRACES:String = "CLEAR_TRACES";
      
      private const COMMAND_MONITOR:String = "MONITOR";
      
      private const COMMAND_SNAPSHOT:String = "SNAPSHOT";
      
      private const COMMAND_NOTFOUND:String = "NOTFOUND";
      
      private const TYPE_VOID:String = "void";
      
      private const TYPE_ARRAY:String = "Array";
      
      private const TYPE_BOOLEAN:String = "Boolean";
      
      private const TYPE_NUMBER:String = "Number";
      
      private const TYPE_OBJECT:String = "Object";
      
      private const TYPE_VECTOR:String = "Vector";
      
      private const TYPE_STRING:String = "String";
      
      private const TYPE_INT:String = "int";
      
      private const TYPE_UINT:String = "uint";
      
      private const TYPE_XML:String = "XML";
      
      private const TYPE_XMLLIST:String = "XMLList";
      
      private const TYPE_XMLNODE:String = "XMLNode";
      
      private const TYPE_XMLVALUE:String = "XMLValue";
      
      private const TYPE_XMLATTRIBUTE:String = "XMLAttribute";
      
      private const TYPE_METHOD:String = "MethodClosure";
      
      private const TYPE_FUNCTION:String = "Function";
      
      private const TYPE_BYTEARRAY:String = "ByteArray";
      
      private const TYPE_WARNING:String = "Warning";
      
      private const ACCESS_VARIABLE:String = "variable";
      
      private const ACCESS_CONSTANT:String = "constant";
      
      private const ACCESS_ACCESSOR:String = "accessor";
      
      private const ACCESS_METHOD:String = "method";
      
      private const PERMISSION_READWRITE:String = "readwrite";
      
      private const PERMISSION_READONLY:String = "readonly";
      
      private const PERMISSION_WRITEONLY:String = "writeonly";
      
      private const ICON_DEFAULT:String = "iconDefault";
      
      private const ICON_ROOT:String = "iconRoot";
      
      private const ICON_WARNING:String = "iconWarning";
      
      private const ICON_VARIABLE:String = "iconVariable";
      
      private const ICON_VARIABLE_READONLY:String = "iconVariableReadonly";
      
      private const ICON_VARIABLE_WRITEONLY:String = "iconVariableWriteonly";
      
      private const ICON_XMLNODE:String = "iconXMLNode";
      
      private const ICON_XMLVALUE:String = "iconXMLValue";
      
      private const ICON_XMLATTRIBUTE:String = "iconXMLAttribute";
      
      private const ICON_FUNCTION:String = "iconFunction";
      
      protected const HIGHLIGHT_COLOR:uint = 16776960;
      
      protected const HIGHLIGHT_BORDER:int = 4;
      
      protected const MAX_PACKAGE_BYTES:int = 40000;
      
      protected const MAX_BUFFER_SIZE:int = 500;
      
      protected const VERSION:Number = 2.51;
      
      protected const FPS_UPDATE:int = 500;
      
      protected var root:Object = null;
      
      protected var highlight:Sprite = null;
      
      protected var buffer:Array;
      
      protected var monitor:Timer;
      
      protected var monitorTime:Number;
      
      protected var monitorStart:Number;
      
      protected var monitorFrames:uint;
      
      protected var monitorSprite:Sprite;
      
      protected var isEnabled:Boolean = true;
      
      protected var isConnected:Boolean = false;
      
      public var logger:Function;
      
      public function MonsterDebugger(target:Object = null)
      {
         this.buffer = new Array();
         super();
         if(instance == null)
         {
            instance = this;
            this.lineOut = new LocalConnection();
            this.lineOut.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.asyncErrorHandler,false,0,true);
            this.lineOut.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler,false,0,true);
            this.lineOut.addEventListener(StatusEvent.STATUS,this.statusHandler,false,0,true);
            this.lineIn = new LocalConnection();
            this.lineIn.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.asyncErrorHandler,false,0,true);
            this.lineIn.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler,false,0,true);
            this.lineIn.addEventListener(StatusEvent.STATUS,this.statusHandler,false,0,true);
            this.lineIn.allowDomain(this.ALLOWED_DOMAIN);
            this.lineIn.client = this;
            this.monitorTime = new Date().time;
            this.monitorStart = new Date().time;
            this.monitorFrames = 0;
            this.monitorSprite = new Sprite();
            this.monitorSprite.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler,false,0,true);
            this.monitor = new Timer(this.FPS_UPDATE);
            this.monitor.addEventListener(TimerEvent.TIMER,this.monitorHandler,false,0,true);
            this.monitor.start();
            try
            {
               this.lineIn.connect(this.LINE_IN);
            }
            catch(error:ArgumentError)
            {
            }
         }
         instance.root = target;
         instance.send({
            "text":this.COMMAND_HELLO,
            "version":this.VERSION
         });
      }
      
      public static function inspect(target:Object) : void
      {
         var object:* = undefined;
         var xml:XML = null;
         var obj:Object = null;
         if(instance != null && target != null)
         {
            instance.root = target;
            object = instance.getObject("",0);
            if(object != null)
            {
               xml = XML(instance.parseObject(object,"",false,1,2));
               obj = {
                  "text":instance.COMMAND_INSPECT,
                  "xml":xml
               };
               if(instance.isConnected)
               {
                  instance.send(obj);
               }
               else
               {
                  instance.sendToBuffer(obj);
               }
               if(instance.isDisplayObject(object))
               {
                  xml = XML(instance.parseDisplayObject(object,"",false,1,2));
                  obj = {
                     "text":instance.COMMAND_BASE,
                     "xml":xml
                  };
                  if(instance.isConnected)
                  {
                     instance.send(obj);
                  }
                  else
                  {
                     instance.sendToBuffer(obj);
                  }
               }
            }
         }
      }
      
      public static function snapshot(target:DisplayObject, color:uint = 1118481) : void
      {
         if(instance == null)
         {
            instance = new MonsterDebugger(null);
         }
         if(MonsterDebugger.enabled)
         {
            instance.snapshotInternal(target,color);
         }
      }
      
      public static function trace(target:Object, object:*, color:uint = 1118481, functions:Boolean = false, depth:int = 4) : void
      {
         if(instance == null)
         {
            instance = new MonsterDebugger(target);
         }
         if(MonsterDebugger.enabled)
         {
            instance.traceInternal(target,object,color,functions,depth);
         }
      }
      
      public static function clearTraces() : void
      {
         if(instance == null)
         {
            instance = new MonsterDebugger(null);
         }
         if(MonsterDebugger.enabled)
         {
            instance.clearTracesInternal();
         }
      }
      
      public static function get enabled() : Boolean
      {
         if(instance == null)
         {
            instance = new MonsterDebugger(null);
         }
         return instance.isEnabled;
      }
      
      public static function set enabled(value:Boolean) : void
      {
         if(instance == null)
         {
            instance = new MonsterDebugger(null);
         }
         instance.isEnabled = value;
      }
      
      public function onReceivedData(data:ByteArray) : void
      {
         var object:* = undefined;
         var method:Function = null;
         var xml:XML = null;
         var command:Object = null;
         var bounds:Rectangle = null;
         if(this.isEnabled)
         {
            data.uncompress();
            command = data.readObject();
            switch(command["text"])
            {
               case this.COMMAND_HELLO:
                  this.isConnected = true;
                  if(instance != null && instance.root != null)
                  {
                     (instance.root as EventDispatcher).dispatchEvent(new Event("DebuggerConnected"));
                  }
                  this.send({
                     "text":this.COMMAND_HELLO,
                     "version":this.VERSION
                  });
                  break;
               case this.COMMAND_HELLO_RESPONSE:
                  this.isConnected = true;
                  if(instance != null && instance.root != null)
                  {
                     (instance.root as EventDispatcher).dispatchEvent(new Event("DebuggerConnected"));
                  }
                  this.sendBuffer();
                  break;
               case this.COMMAND_ROOT:
                  object = this.getObject("",0);
                  if(object != null)
                  {
                     xml = XML(this.parseObject(object,"",command["functions"],1,2));
                     this.send({
                        "text":this.COMMAND_ROOT,
                        "xml":xml
                     });
                     if(this.isDisplayObject(object))
                     {
                        xml = XML(this.parseDisplayObject(object,"",command["functions"],1,2));
                        this.send({
                           "text":this.COMMAND_BASE,
                           "xml":xml
                        });
                     }
                  }
                  break;
               case this.COMMAND_GET_OBJECT:
                  object = this.getObject(command["target"],0);
                  if(object != null)
                  {
                     xml = XML(this.parseObject(object,command["target"],command["functions"],1,2));
                     this.send({
                        "text":this.COMMAND_GET_OBJECT,
                        "xml":xml
                     });
                  }
                  break;
               case this.COMMAND_GET_DISPLAYOBJECT:
                  object = this.getObject(command["target"],0);
                  if(object != null)
                  {
                     if(this.isDisplayObject(object))
                     {
                        xml = XML(this.parseDisplayObject(object,command["target"],command["functions"],1,2));
                        this.send({
                           "text":this.COMMAND_GET_DISPLAYOBJECT,
                           "xml":xml
                        });
                     }
                  }
                  break;
               case this.COMMAND_GET_PROPERTIES:
                  object = this.getObject(command["target"],0);
                  if(object != null)
                  {
                     xml = XML(this.parseObject(object,command["target"],false,1,1));
                     this.send({
                        "text":this.COMMAND_GET_PROPERTIES,
                        "xml":xml
                     });
                  }
                  break;
               case this.COMMAND_GET_FUNCTIONS:
                  object = this.getObject(command["target"],0);
                  if(object != null)
                  {
                     xml = XML(this.getFunctions(object,command["target"]));
                     this.send({
                        "text":this.COMMAND_GET_FUNCTIONS,
                        "xml":xml
                     });
                  }
                  break;
               case this.COMMAND_SET_PROPERTY:
                  object = this.getObject(command["target"],1);
                  if(object != null)
                  {
                     try
                     {
                        object[command["name"]] = command["value"];
                        this.send({
                           "text":this.COMMAND_SET_PROPERTY,
                           "value":object[command["name"]]
                        });
                     }
                     catch(error:Error)
                     {
                        send({
                           "text":COMMAND_NOTFOUND,
                           "target":command["target"]
                        });
                        break;
                     }
                  }
                  break;
               case this.COMMAND_CALL_METHOD:
                  method = this.getObject(command["target"],0);
                  if(method != null)
                  {
                     if(command["returnType"] == this.TYPE_VOID)
                     {
                        method.apply(this,command["arguments"]);
                     }
                     else
                     {
                        object = method.apply(this,command["arguments"]);
                        xml = XML(this.parseObject(object,"",false,1,4));
                        this.send({
                           "text":this.COMMAND_CALL_METHOD,
                           "id":command["id"],
                           "xml":xml
                        });
                     }
                  }
                  break;
               case this.COMMAND_SHOW_HIGHLIGHT:
                  if(this.highlight != null)
                  {
                     try
                     {
                        this.highlight.parent.removeChild(this.highlight);
                        this.highlight = null;
                     }
                     catch(error:Error)
                     {
                     }
                  }
                  object = this.getObject(command["target"],0);
                  if(this.isDisplayObject(object) && this.isDisplayObject(object["parent"]))
                  {
                     bounds = object.getBounds(object["parent"]);
                     this.highlight = new Sprite();
                     this.highlight.x = 0;
                     this.highlight.y = 0;
                     this.highlight.graphics.beginFill(0,0);
                     this.highlight.graphics.lineStyle(this.HIGHLIGHT_BORDER,this.HIGHLIGHT_COLOR);
                     this.highlight.graphics.drawRect(bounds.x,bounds.y,bounds.width,bounds.height);
                     this.highlight.graphics.endFill();
                     this.highlight.mouseChildren = false;
                     this.highlight.mouseEnabled = false;
                     try
                     {
                        object["parent"].addChild(this.highlight);
                     }
                     catch(error:Error)
                     {
                        highlight = null;
                     }
                  }
                  break;
               case this.COMMAND_HIDE_HIGHLIGHT:
                  if(this.highlight != null)
                  {
                     try
                     {
                        this.highlight.parent.removeChild(this.highlight);
                        this.highlight = null;
                     }
                     catch(error:Error)
                     {
                     }
                  }
            }
         }
      }
      
      protected function send(data:Object) : void
      {
         var item:ByteArray = null;
         var dataPackages:Array = null;
         var i:int = 0;
         var bytesAvailable:int = 0;
         var offset:int = 0;
         var total:int = 0;
         var length:int = 0;
         var tmp:ByteArray = null;
         if(this.isEnabled)
         {
            item = new ByteArray();
            item.writeObject(data);
            item.compress();
            dataPackages = new Array();
            i = 0;
            if(item.length > this.MAX_PACKAGE_BYTES)
            {
               bytesAvailable = int(item.length);
               offset = 0;
               total = Math.ceil(item.length / this.MAX_PACKAGE_BYTES);
               for(i = 0; i < total; i++)
               {
                  length = bytesAvailable;
                  if(length > this.MAX_PACKAGE_BYTES)
                  {
                     length = this.MAX_PACKAGE_BYTES;
                  }
                  tmp = new ByteArray();
                  tmp.writeBytes(item,offset,length);
                  dataPackages.push({
                     "total":total,
                     "nr":i + 1,
                     "bytes":tmp
                  });
                  bytesAvailable -= length;
                  offset += length;
               }
            }
            else
            {
               dataPackages.push({
                  "total":1,
                  "nr":1,
                  "bytes":item
               });
            }
            for(i = 0; i < dataPackages.length; i++)
            {
               try
               {
                  this.lineOut.send(this.LINE_OUT,"onReceivedData",dataPackages[i]);
               }
               catch(error:Error)
               {
                  break;
               }
            }
         }
      }
      
      protected function sendToBuffer(obj:Object) : void
      {
         this.buffer.push(obj);
         if(this.buffer.length > this.MAX_BUFFER_SIZE)
         {
            this.buffer.shift();
         }
      }
      
      protected function sendBuffer() : void
      {
         if(this.buffer.length > 0)
         {
            while(this.buffer.length != 0)
            {
               this.send(this.buffer.shift());
            }
         }
      }
      
      protected function snapshotInternal(target:DisplayObject, color:uint = 1118481) : void
      {
         var bitmapData:BitmapData = null;
         var bytes:ByteArray = null;
         var memory:uint = 0;
         var obj:Object = null;
         if(this.isEnabled)
         {
            bitmapData = new BitmapData(target.width,target.height);
            bitmapData.draw(target);
            bytes = bitmapData.getPixels(new Rectangle(0,0,target.width,target.height));
            memory = System.totalMemory;
            obj = {
               "text":this.COMMAND_SNAPSHOT,
               "date":new Date(),
               "target":String(target),
               "bytes":bytes,
               "width":target.width,
               "height":target.height,
               "color":color,
               "memory":memory
            };
            if(this.isConnected)
            {
               this.send(obj);
            }
            else
            {
               this.sendToBuffer(obj);
            }
            bitmapData.dispose();
            bytes = null;
         }
      }
      
      protected function traceInternal(target:Object, object:*, color:uint = 1118481, functions:Boolean = false, depth:int = 4) : void
      {
         var xml:XML = null;
         var memory:uint = 0;
         var obj:Object = null;
         if(this.isEnabled)
         {
            xml = XML(this.parseObject(object,"",functions,1,depth));
            memory = System.totalMemory;
            obj = {
               "text":this.COMMAND_TRACE,
               "date":new Date(),
               "target":String(target),
               "xml":xml,
               "color":color,
               "memory":memory
            };
            if(this.isConnected)
            {
               this.send(obj);
            }
            else
            {
               this.sendToBuffer(obj);
            }
         }
      }
      
      protected function clearTracesInternal() : void
      {
         var obj:Object = null;
         if(this.isEnabled)
         {
            obj = {"text":this.COMMAND_CLEAR_TRACES};
            if(this.isConnected)
            {
               this.send(obj);
            }
            else
            {
               this.sendToBuffer(obj);
            }
         }
      }
      
      protected function isDisplayObject(object:*) : Boolean
      {
         return object is DisplayObject || object is DisplayObjectContainer;
      }
      
      protected function getObject(target:String = "", parent:int = 0) : *
      {
         var splitted:Array = null;
         var i:int = 0;
         var index:Number = NaN;
         var obj:Object = null;
         var object:* = instance.root;
         if(target != "")
         {
            splitted = target.split(".");
            for(i = 0; i < splitted.length - parent; i++)
            {
               if(splitted[i] != "")
               {
                  try
                  {
                     if(splitted[i] == "children()")
                     {
                        object = object.children();
                     }
                     else if(splitted[i].indexOf("getChildAt(") == 0)
                     {
                        index = Number(splitted[i].substring(11,splitted[i].indexOf(")",11)));
                        object = DisplayObjectContainer(object).getChildAt(index);
                     }
                     else
                     {
                        object = object[splitted[i]];
                     }
                  }
                  catch(error:ReferenceError)
                  {
                     obj = {
                        "text":COMMAND_NOTFOUND,
                        "target":target
                     };
                     if(isConnected)
                     {
                        send(obj);
                     }
                     else
                     {
                        sendToBuffer(obj);
                     }
                     break;
                  }
               }
            }
         }
         return object;
      }
      
      protected function getFunctions(object:*, target:String = "") : String
      {
         var description:XML = null;
         var type:String = null;
         var childType:String = null;
         var childName:String = null;
         var childTarget:String = null;
         var methods:XMLList = null;
         var methodsArr:Array = null;
         var returnType:String = null;
         var parameters:XMLList = null;
         var args:Array = null;
         var argsString:String = null;
         var optional:Boolean = false;
         var double:Boolean = false;
         var i:int = 0;
         var n:int = 0;
         var msg:String = null;
         var obj:Object = null;
         var xml:String = "";
         xml += this.createNode("root");
         try
         {
            description = describeType(object);
            type = this.parseType(description.@name);
            childType = "";
            childName = "";
            childTarget = "";
            methods = description..method;
            methodsArr = new Array();
            optional = false;
            double = false;
            i = 0;
            n = 0;
            xml += this.createNode("node",{
               "icon":this.ICON_DEFAULT,
               "label":"(" + type + ")",
               "target":target
            });
            for(i = 0; i < methods.length(); i++)
            {
               for(n = 0; n < methodsArr.length; n++)
               {
                  if(methodsArr[n].name == methods[i].@name)
                  {
                     double = true;
                     break;
                  }
               }
               if(!double)
               {
                  methodsArr.push({
                     "name":methods[i].@name,
                     "xml":methods[i],
                     "access":this.ACCESS_METHOD
                  });
               }
            }
            methodsArr.sortOn("name");
            for(i = 0; i < methodsArr.length; i++)
            {
               childType = this.TYPE_FUNCTION;
               childName = String(methodsArr[i].xml.@name);
               childTarget = target + "." + childName;
               returnType = this.parseType(methodsArr[i].xml.@returnType);
               parameters = methodsArr[i].xml..parameter;
               args = new Array();
               argsString = "";
               optional = false;
               for(n = 0; n < parameters.length(); n++)
               {
                  if(parameters[n].@optional == "true" && !optional)
                  {
                     optional = true;
                     args.push("[");
                  }
                  args.push(this.parseType(parameters[n].@type));
               }
               if(optional)
               {
                  args.push("]");
               }
               argsString = args.join(", ");
               argsString = argsString.replace("[, ","[");
               argsString = argsString.replace(", ]","]");
               xml += this.createNode("node",{
                  "icon":this.ICON_FUNCTION,
                  "label":childName + "(" + argsString + "):" + returnType,
                  "args":argsString,
                  "name":childName,
                  "type":this.TYPE_FUNCTION,
                  "access":this.ACCESS_METHOD,
                  "returnType":returnType,
                  "target":childTarget
               });
               for(n = 0; n < parameters.length(); n++)
               {
                  xml += this.createNode("parameter",{
                     "type":this.parseType(parameters[n].@type),
                     "index":parameters[n].@index,
                     "optional":parameters[n].@optional
                  },true);
               }
               xml += this.createNode("/node");
            }
            xml += this.createNode("/node");
         }
         catch(error:Error)
         {
            msg = "";
            msg += createNode("root");
            msg += createNode("node",{
               "icon":ICON_WARNING,
               "type":TYPE_WARNING,
               "label":"Not found",
               "name":"Not found"
            },true);
            msg += createNode("/root");
            obj = {
               "text":COMMAND_NOTFOUND,
               "target":target,
               "xml":XML(msg)
            };
            if(isConnected)
            {
               send(obj);
            }
            else
            {
               sendToBuffer(obj);
            }
         }
         xml += this.createNode("/root");
         return xml;
      }
      
      protected function parseObject(object:*, target:String = "", functions:Boolean = false, currentDepth:int = 1, maxDepth:int = 4) : String
      {
         var xml:String = null;
         var isXMLString:XML = null;
         var keys:Array = null;
         var key:* = undefined;
         var properties:Array = null;
         var prop:* = undefined;
         var variables:XMLList = null;
         var accessors:XMLList = null;
         var constants:XMLList = null;
         var methods:XMLList = null;
         var variablesArr:Array = null;
         var methodsArr:Array = null;
         var double:Boolean = false;
         var permission:String = null;
         var icon:String = null;
         var returnType:String = null;
         var parameters:XMLList = null;
         var args:Array = null;
         var msg:String = null;
         var obj:Object = null;
         xml = "";
         var childType:String = "";
         var childName:String = "";
         var childTarget:String = "";
         var description:XML = new XML();
         var type:String = "";
         var base:String = "";
         var isXML:Boolean = false;
         var i:int = 0;
         var n:int = 0;
         if(maxDepth == -1 || currentDepth <= maxDepth)
         {
            if(currentDepth == 1)
            {
               xml += this.createNode("root");
            }
            try
            {
               description = describeType(object);
               type = this.parseType(description.@name);
               base = this.parseType(description.@base);
               if(functions && base == this.TYPE_FUNCTION)
               {
                  xml += this.createNode("node",{
                     "icon":this.ICON_FUNCTION,
                     "label":"(Function)",
                     "name":"",
                     "type":this.TYPE_FUNCTION,
                     "value":"",
                     "target":target,
                     "access":this.ACCESS_VARIABLE,
                     "permission":this.PERMISSION_READWRITE
                  },true);
               }
               else if(type == this.TYPE_ARRAY || type == this.TYPE_VECTOR)
               {
                  if(currentDepth == 1)
                  {
                     xml += this.createNode("node",{
                        "icon":this.ICON_ROOT,
                        "label":"(" + type + ")",
                        "target":target
                     });
                  }
                  xml += this.createNode("node",{
                     "icon":this.ICON_VARIABLE,
                     "label":"length" + " (" + this.TYPE_UINT + ") = " + object["length"],
                     "name":"length",
                     "type":this.TYPE_UINT,
                     "value":object["length"],
                     "target":target + "." + "length",
                     "access":this.ACCESS_VARIABLE,
                     "permission":this.PERMISSION_READONLY
                  },true);
                  keys = new Array();
                  for(key in object)
                  {
                     keys.push(key);
                  }
                  keys.sort();
                  for(i = 0; i < keys.length; i++)
                  {
                     childType = this.parseType(describeType(object[keys[i]]).@name);
                     childTarget = target + "." + String(keys[i]);
                     if(childType == this.TYPE_STRING || childType == this.TYPE_BOOLEAN || childType == this.TYPE_NUMBER || childType == this.TYPE_INT || childType == this.TYPE_UINT || childType == this.TYPE_FUNCTION)
                     {
                        isXML = false;
                        isXMLString = new XML();
                        if(childType == this.TYPE_STRING)
                        {
                           try
                           {
                              isXMLString = new XML(object[keys[i]]);
                              if(!isXMLString.hasSimpleContent() && isXMLString.children().length() > 0)
                              {
                                 isXML = true;
                              }
                           }
                           catch(error:TypeError)
                           {
                           }
                        }
                        try
                        {
                           if(!isXML)
                           {
                              xml += this.createNode("node",{
                                 "icon":this.ICON_VARIABLE,
                                 "label":"[" + keys[i] + "] (" + childType + ") = " + this.printObject(object[keys[i]],childType),
                                 "name":"[" + keys[i] + "]",
                                 "type":childType,
                                 "value":this.printObject(object[keys[i]],childType),
                                 "target":childTarget,
                                 "access":this.ACCESS_VARIABLE,
                                 "permission":this.PERMISSION_READWRITE
                              },true);
                           }
                           else
                           {
                              xml += this.createNode("node",{
                                 "icon":this.ICON_VARIABLE,
                                 "label":"[" + keys[i] + "] (" + childType + ")",
                                 "name":"[" + keys[i] + "]",
                                 "type":childType,
                                 "value":"",
                                 "target":childTarget,
                                 "access":this.ACCESS_VARIABLE,
                                 "permission":this.PERMISSION_READWRITE
                              },false);
                              xml += this.parseXML(isXMLString,childTarget + "." + "cildren()",currentDepth,maxDepth);
                              xml += this.createNode("/node");
                           }
                        }
                        catch(error:Error)
                        {
                        }
                     }
                     else
                     {
                        xml += this.createNode("node",{
                           "icon":this.ICON_VARIABLE,
                           "label":"[" + keys[i] + "] (" + childType + ")",
                           "name":"[" + keys[i] + "]",
                           "type":childType,
                           "value":"",
                           "target":childTarget,
                           "access":this.ACCESS_VARIABLE,
                           "permission":this.PERMISSION_READWRITE
                        });
                        try
                        {
                           xml += this.parseObject(object[keys[i]],childTarget,functions,currentDepth + 1,maxDepth);
                        }
                        catch(error:Error)
                        {
                           xml += createNode("node",{
                              "icon":ICON_WARNING,
                              "type":TYPE_WARNING,
                              "label":"Unreadable",
                              "name":"Unreadable"
                           },true);
                        }
                        xml += this.createNode("/node");
                     }
                  }
                  if(currentDepth == 1)
                  {
                     xml += this.createNode("/node");
                  }
               }
               else if(type == this.TYPE_OBJECT)
               {
                  if(currentDepth == 1)
                  {
                     xml += this.createNode("node",{
                        "icon":this.ICON_ROOT,
                        "label":"(" + type + ")",
                        "target":target
                     });
                  }
                  properties = new Array();
                  for(prop in object)
                  {
                     properties.push(prop);
                  }
                  properties.sort();
                  for(i = 0; i < properties.length; i++)
                  {
                     childType = this.parseType(describeType(object[properties[i]]).@name);
                     childTarget = target + "." + properties[i];
                     if(childType == this.TYPE_STRING || childType == this.TYPE_BOOLEAN || childType == this.TYPE_NUMBER || childType == this.TYPE_INT || childType == this.TYPE_UINT || childType == this.TYPE_FUNCTION)
                     {
                        isXML = false;
                        isXMLString = new XML();
                        if(childType == this.TYPE_STRING)
                        {
                           try
                           {
                              isXMLString = new XML(object[properties[i]]);
                              if(!isXMLString.hasSimpleContent() && isXMLString.children().length() > 0)
                              {
                                 isXML = true;
                              }
                           }
                           catch(error:TypeError)
                           {
                           }
                        }
                        try
                        {
                           if(!isXML)
                           {
                              xml += this.createNode("node",{
                                 "icon":this.ICON_VARIABLE,
                                 "label":properties[i] + " (" + childType + ") = " + this.printObject(object[properties[i]],childType),
                                 "name":properties[i],
                                 "type":childType,
                                 "value":this.printObject(object[properties[i]],childType),
                                 "target":childTarget,
                                 "access":this.ACCESS_VARIABLE,
                                 "permission":this.PERMISSION_READWRITE
                              },true);
                           }
                           else
                           {
                              xml += this.createNode("node",{
                                 "icon":this.ICON_VARIABLE,
                                 "label":properties[i] + " (" + childType + ")",
                                 "name":properties[i],
                                 "type":childType,
                                 "value":"",
                                 "target":childTarget,
                                 "access":this.ACCESS_VARIABLE,
                                 "permission":this.PERMISSION_READWRITE
                              },false);
                              xml += this.parseXML(isXMLString,childTarget + "." + "cildren()",currentDepth,maxDepth);
                              xml += this.createNode("/node");
                           }
                        }
                        catch(error:Error)
                        {
                        }
                     }
                     else
                     {
                        xml += this.createNode("node",{
                           "icon":this.ICON_VARIABLE,
                           "label":properties[i] + " (" + childType + ")",
                           "name":properties[i],
                           "type":childType,
                           "value":"",
                           "target":childTarget,
                           "access":this.ACCESS_VARIABLE,
                           "permission":this.PERMISSION_READWRITE
                        });
                        try
                        {
                           xml += this.parseObject(object[properties[i]],childTarget,functions,currentDepth + 1,maxDepth);
                        }
                        catch(error:Error)
                        {
                           xml += createNode("node",{
                              "icon":ICON_WARNING,
                              "type":TYPE_WARNING,
                              "label":"Unreadable",
                              "name":"Unreadable"
                           },true);
                        }
                        xml += this.createNode("/node");
                     }
                  }
                  if(currentDepth == 1)
                  {
                     xml += this.createNode("/node");
                  }
               }
               else if(type == this.TYPE_XML)
               {
                  if(currentDepth == 1)
                  {
                     xml += this.createNode("node",{
                        "icon":this.ICON_ROOT,
                        "label":"(" + type + ")",
                        "target":target
                     });
                  }
                  xml += this.parseXML(object,target + "." + "cildren()",currentDepth,maxDepth);
                  if(currentDepth == 1)
                  {
                     xml += this.createNode("/node");
                  }
               }
               else if(type == this.TYPE_XMLLIST)
               {
                  if(currentDepth == 1)
                  {
                     xml += this.createNode("node",{
                        "icon":this.ICON_ROOT,
                        "label":"(" + type + ")",
                        "target":target
                     });
                  }
                  xml += this.createNode("node",{
                     "icon":this.ICON_VARIABLE,
                     "label":"length" + " (" + this.TYPE_UINT + ") = " + object.length(),
                     "name":"length",
                     "type":this.TYPE_UINT,
                     "value":object.length(),
                     "target":target + "." + "length",
                     "access":this.ACCESS_VARIABLE,
                     "permission":this.PERMISSION_READONLY
                  },true);
                  for(i = 0; i < object.length(); i++)
                  {
                     xml += this.parseXML(object[i],target + "." + String(i) + ".children()",currentDepth,maxDepth);
                  }
                  if(currentDepth == 1)
                  {
                     xml += this.createNode("/node");
                  }
               }
               else if(type == this.TYPE_STRING || type == this.TYPE_BOOLEAN || type == this.TYPE_NUMBER || type == this.TYPE_INT || type == this.TYPE_UINT)
               {
                  isXML = false;
                  isXMLString = new XML();
                  if(type == this.TYPE_STRING)
                  {
                     try
                     {
                        isXMLString = new XML(object);
                        if(!isXMLString.hasSimpleContent() && isXMLString.children().length() > 0)
                        {
                           isXML = true;
                        }
                     }
                     catch(error:TypeError)
                     {
                     }
                  }
                  try
                  {
                     if(!isXML)
                     {
                        xml += this.createNode("node",{
                           "icon":this.ICON_VARIABLE,
                           "label":"(" + type + ") = " + this.printObject(object,type),
                           "name":"",
                           "type":type,
                           "value":this.printObject(object,type),
                           "target":target,
                           "access":this.ACCESS_VARIABLE,
                           "permission":this.PERMISSION_READWRITE
                        },true);
                     }
                     else
                     {
                        xml += this.createNode("node",{
                           "icon":this.ICON_VARIABLE,
                           "label":"(" + type + ")",
                           "name":"",
                           "type":type,
                           "value":"",
                           "target":target,
                           "access":this.ACCESS_VARIABLE,
                           "permission":this.PERMISSION_READWRITE
                        },false);
                        xml += this.parseXML(isXMLString,target + "." + "cildren()",currentDepth,maxDepth);
                        xml += this.createNode("/node");
                     }
                  }
                  catch(error:Error)
                  {
                  }
               }
               else
               {
                  if(currentDepth == 1)
                  {
                     xml += this.createNode("node",{
                        "icon":this.ICON_ROOT,
                        "label":"(" + type + ")",
                        "target":target
                     });
                  }
                  variables = description..variable;
                  accessors = description..accessor;
                  constants = description..constant;
                  methods = description..method;
                  variablesArr = new Array();
                  methodsArr = new Array();
                  double = false;
                  permission = "";
                  icon = "";
                  double = false;
                  for(i = 0; i < variables.length(); i++)
                  {
                     for(n = 0; n < variablesArr.length; n++)
                     {
                        if(variablesArr[n].name == variables[i].@name)
                        {
                           double = true;
                           break;
                        }
                     }
                     if(!double)
                     {
                        variablesArr.push({
                           "name":variables[i].@name,
                           "xml":variables[i],
                           "access":this.ACCESS_VARIABLE
                        });
                     }
                  }
                  double = false;
                  for(i = 0; i < accessors.length(); i++)
                  {
                     for(n = 0; n < variablesArr.length; n++)
                     {
                        if(variablesArr[n].name == accessors[i].@name)
                        {
                           double = true;
                           break;
                        }
                     }
                     if(!double)
                     {
                        variablesArr.push({
                           "name":accessors[i].@name,
                           "xml":accessors[i],
                           "access":this.ACCESS_ACCESSOR
                        });
                     }
                  }
                  double = false;
                  for(i = 0; i < constants.length(); i++)
                  {
                     for(n = 0; n < variablesArr.length; n++)
                     {
                        if(variablesArr[n].name == constants[i].@name)
                        {
                           double = true;
                           break;
                        }
                     }
                     if(!double)
                     {
                        variablesArr.push({
                           "name":constants[i].@name,
                           "xml":constants[i],
                           "access":this.ACCESS_CONSTANT
                        });
                     }
                  }
                  double = false;
                  for(i = 0; i < methods.length(); i++)
                  {
                     for(n = 0; n < methodsArr.length; n++)
                     {
                        if(methodsArr[n].name == methods[i].@name)
                        {
                           double = true;
                           break;
                        }
                     }
                     if(!double)
                     {
                        methodsArr.push({
                           "name":methods[i].@name,
                           "xml":methods[i],
                           "access":this.ACCESS_METHOD
                        });
                     }
                  }
                  variablesArr.sortOn("name");
                  methodsArr.sortOn("name");
                  for(i = 0; i < variablesArr.length; i++)
                  {
                     childType = this.parseType(variablesArr[i].xml.@type);
                     childName = String(variablesArr[i].xml.@name);
                     childTarget = target + "." + childName;
                     permission = this.PERMISSION_READWRITE;
                     icon = this.ICON_VARIABLE;
                     if(variablesArr[i].access == this.ACCESS_CONSTANT)
                     {
                        permission = this.PERMISSION_READONLY;
                        icon = this.ICON_VARIABLE_READONLY;
                     }
                     if(variablesArr[i].xml.@access == this.PERMISSION_READONLY)
                     {
                        permission = this.PERMISSION_READONLY;
                        icon = this.ICON_VARIABLE_READONLY;
                     }
                     if(variablesArr[i].xml.@access == this.PERMISSION_WRITEONLY)
                     {
                        permission = this.PERMISSION_WRITEONLY;
                        icon = this.ICON_VARIABLE_WRITEONLY;
                     }
                     if(permission != this.PERMISSION_WRITEONLY)
                     {
                        if(childType == this.TYPE_STRING || childType == this.TYPE_BOOLEAN || childType == this.TYPE_NUMBER || childType == this.TYPE_INT || childType == this.TYPE_UINT || childType == this.TYPE_FUNCTION)
                        {
                           isXML = false;
                           isXMLString = new XML();
                           if(childType == this.TYPE_STRING)
                           {
                              try
                              {
                                 isXMLString = new XML(object[childName]);
                                 if(!isXMLString.hasSimpleContent() && isXMLString.children().length() > 0)
                                 {
                                    isXML = true;
                                 }
                              }
                              catch(error:TypeError)
                              {
                              }
                           }
                           try
                           {
                              if(!isXML)
                              {
                                 xml += this.createNode("node",{
                                    "icon":icon,
                                    "label":childName + " (" + childType + ") = " + this.printObject(object[childName],childType),
                                    "name":childName,
                                    "type":childType,
                                    "value":this.printObject(object[childName],childType),
                                    "target":childTarget,
                                    "access":variablesArr[i].access,
                                    "permission":permission
                                 },true);
                              }
                              else
                              {
                                 xml += this.createNode("node",{
                                    "icon":icon,
                                    "label":childName + " (" + childType + ")",
                                    "name":childName,
                                    "type":childType,
                                    "value":"",
                                    "target":childTarget,
                                    "access":variablesArr[i].access,
                                    "permission":permission
                                 },false);
                                 xml += this.parseXML(isXMLString,childTarget + "." + "cildren()",currentDepth,maxDepth);
                                 xml += this.createNode("/node");
                              }
                           }
                           catch(error:Error)
                           {
                           }
                        }
                        else
                        {
                           xml += this.createNode("node",{
                              "icon":icon,
                              "label":childName + " (" + childType + ")",
                              "name":childName,
                              "type":childType,
                              "target":childTarget,
                              "access":variablesArr[i].access,
                              "permission":permission
                           });
                           try
                           {
                              xml += this.parseObject(object[childName],childTarget,functions,currentDepth + 1,maxDepth);
                           }
                           catch(error:Error)
                           {
                              xml += createNode("node",{
                                 "icon":ICON_WARNING,
                                 "type":TYPE_WARNING,
                                 "label":"Unreadable",
                                 "name":"Unreadable"
                              },true);
                           }
                           xml += this.createNode("/node");
                        }
                     }
                  }
                  if(functions)
                  {
                     for(i = 0; i < methodsArr.length; i++)
                     {
                        childType = this.TYPE_FUNCTION;
                        childName = String(methodsArr[i].xml.@name);
                        childTarget = target + "." + childName;
                        returnType = this.parseType(methodsArr[i].xml.@returnType);
                        parameters = methodsArr[i].xml..parameter;
                        args = new Array();
                        for(n = 0; n < parameters.length(); n++)
                        {
                           args.push(this.parseType(parameters[n].@type));
                        }
                        xml += this.createNode("node",{
                           "icon":this.ICON_FUNCTION,
                           "label":childName + "(" + args.join(", ") + "):" + returnType,
                           "args":args.join(", "),
                           "name":childName,
                           "type":this.TYPE_FUNCTION,
                           "access":variablesArr[i].access,
                           "returnType":returnType,
                           "target":childTarget
                        },true);
                     }
                  }
                  if(currentDepth == 1)
                  {
                     xml += this.createNode("/node");
                  }
               }
            }
            catch(error:Error)
            {
               msg = "";
               msg += createNode("root");
               msg += createNode("node",{
                  "icon":ICON_WARNING,
                  "type":TYPE_WARNING,
                  "label":"Not found",
                  "name":"Not found"
               },true);
               msg += createNode("/root");
               obj = {
                  "text":COMMAND_NOTFOUND,
                  "target":target,
                  "xml":XML(msg)
               };
               if(isConnected)
               {
                  send(obj);
               }
               else
               {
                  sendToBuffer(obj);
               }
            }
            if(currentDepth == 1)
            {
               xml += this.createNode("/root");
            }
         }
         return xml;
      }
      
      protected function parseDisplayObject(object:*, target:String = "", functions:Boolean = false, currentDepth:int = 1, maxDepth:int = 4) : String
      {
         var xml:String = null;
         var childs:Array = null;
         var child:DisplayObject = null;
         var ojectName:String = null;
         var msg:String = null;
         var obj:Object = null;
         xml = "";
         var childType:String = "";
         var childIcon:String = "";
         var childName:String = "";
         var childTarget:String = "";
         var childChildren:String = "";
         var i:int = 0;
         if(maxDepth == -1 || currentDepth <= maxDepth)
         {
            if(currentDepth == 1)
            {
               xml += this.createNode("root");
            }
            try
            {
               if(currentDepth == 1)
               {
                  ojectName = DisplayObject(object).name;
                  if(ojectName == null || ojectName == "null")
                  {
                     ojectName = "DisplayObject";
                  }
                  xml += this.createNode("node",{
                     "icon":this.ICON_ROOT,
                     "label":"(" + ojectName + ")",
                     "target":target
                  });
               }
               childs = new Array();
               for(i = 0; i < DisplayObjectContainer(object).numChildren; i++)
               {
                  childs.push(DisplayObjectContainer(object).getChildAt(i));
               }
               for(i = 0; i < childs.length; i++)
               {
                  child = childs[i];
                  childName = describeType(child).@name;
                  childType = this.parseType(childName);
                  childTarget = target + "." + "getChildAt(" + i + ")";
                  childIcon = child is DisplayObjectContainer ? this.ICON_ROOT : this.ICON_VARIABLE;
                  childChildren = child is DisplayObjectContainer ? String(DisplayObjectContainer(child).numChildren) : "";
                  xml += this.createNode("node",{
                     "icon":childIcon,
                     "label":child.name + " (" + childType + ") " + childChildren,
                     "name":child.name,
                     "type":childType,
                     "value":this.printObject(child,childType),
                     "target":childTarget,
                     "access":this.ACCESS_VARIABLE,
                     "permission":this.PERMISSION_READWRITE
                  });
                  try
                  {
                     xml += this.parseDisplayObject(child,childTarget,functions,currentDepth + 1,maxDepth);
                  }
                  catch(error:Error)
                  {
                     xml += createNode("node",{
                        "icon":ICON_WARNING,
                        "type":TYPE_WARNING,
                        "label":"Unreadable",
                        "name":"Unreadable"
                     },true);
                  }
                  xml += this.createNode("/node");
               }
               if(currentDepth == 1)
               {
                  xml += this.createNode("/node");
               }
            }
            catch(error:Error)
            {
               msg = "";
               msg += createNode("root");
               msg += createNode("node",{
                  "icon":ICON_WARNING,
                  "type":TYPE_WARNING,
                  "label":"Not found",
                  "name":"Not found"
               },true);
               msg += createNode("/root");
               obj = {
                  "text":COMMAND_NOTFOUND,
                  "target":target,
                  "xml":XML(msg)
               };
               if(isConnected)
               {
                  send(obj);
               }
               else
               {
                  sendToBuffer(obj);
               }
            }
            if(currentDepth == 1)
            {
               xml += this.createNode("/root");
            }
         }
         return xml;
      }
      
      protected function parseXML(node:*, target:String = "", currentDepth:int = 1, maxDepth:int = -1) : String
      {
         var childTarget:String = null;
         var xml:String = "";
         var i:int = 0;
         if(maxDepth == -1 || currentDepth <= maxDepth)
         {
            if(target.indexOf("@") != -1)
            {
               xml += this.createNode("node",{
                  "icon":this.ICON_XMLATTRIBUTE,
                  "label":node,
                  "name":"",
                  "type":this.TYPE_XMLATTRIBUTE,
                  "value":node,
                  "target":target,
                  "access":this.ACCESS_VARIABLE,
                  "permission":this.PERMISSION_READWRITE
               },true);
            }
            else if(node.name() == null)
            {
               xml += this.createNode("node",{
                  "icon":this.ICON_XMLVALUE,
                  "label":"(" + this.TYPE_XMLVALUE + ") = " + this.printObject(node,this.TYPE_XMLVALUE),
                  "name":"",
                  "type":this.TYPE_XMLVALUE,
                  "value":this.printObject(node,this.TYPE_XMLVALUE),
                  "target":target,
                  "access":this.ACCESS_VARIABLE,
                  "permission":this.PERMISSION_READWRITE
               },true);
            }
            else if(node.hasSimpleContent())
            {
               xml += this.createNode("node",{
                  "icon":this.ICON_XMLNODE,
                  "label":node.name() + " (" + this.TYPE_XMLNODE + ")",
                  "name":node.name(),
                  "type":this.TYPE_XMLNODE,
                  "value":"",
                  "target":target,
                  "access":this.ACCESS_VARIABLE,
                  "permission":this.PERMISSION_READWRITE
               });
               if(node != "")
               {
                  xml += this.createNode("node",{
                     "icon":this.ICON_XMLVALUE,
                     "label":"(" + this.TYPE_XMLVALUE + ") = " + this.printObject(node,this.TYPE_XMLVALUE),
                     "name":"",
                     "type":this.TYPE_XMLVALUE,
                     "value":this.printObject(node,this.TYPE_XMLVALUE),
                     "target":target,
                     "access":this.ACCESS_VARIABLE,
                     "permission":this.PERMISSION_READWRITE
                  },true);
               }
               for(i = 0; i < node.attributes().length(); i++)
               {
                  xml += this.createNode("node",{
                     "icon":this.ICON_XMLATTRIBUTE,
                     "label":"@" + node.attributes()[i].name() + " (" + this.TYPE_XMLATTRIBUTE + ") = " + node.attributes()[i],
                     "name":"",
                     "type":this.TYPE_XMLATTRIBUTE,
                     "value":node.attributes()[i],
                     "target":target + "." + "@" + node.attributes()[i].name(),
                     "access":this.ACCESS_VARIABLE,
                     "permission":this.PERMISSION_READWRITE
                  },true);
               }
               xml += this.createNode("/node");
            }
            else
            {
               xml += this.createNode("node",{
                  "icon":this.ICON_XMLNODE,
                  "label":node.name() + " (" + this.TYPE_XMLNODE + ")",
                  "name":node.name(),
                  "type":this.TYPE_XMLNODE,
                  "value":"",
                  "target":target,
                  "access":this.ACCESS_VARIABLE,
                  "permission":this.PERMISSION_READWRITE
               });
               for(i = 0; i < node.attributes().length(); i++)
               {
                  xml += this.createNode("node",{
                     "icon":this.ICON_XMLATTRIBUTE,
                     "label":"@" + node.attributes()[i].name() + " (" + this.TYPE_XMLATTRIBUTE + ") = " + node.attributes()[i],
                     "name":"",
                     "type":this.TYPE_XMLATTRIBUTE,
                     "value":node.attributes()[i],
                     "target":target + "." + "@" + node.attributes()[i].name(),
                     "access":this.ACCESS_VARIABLE,
                     "permission":this.PERMISSION_READWRITE
                  },true);
               }
               for(i = 0; i < node.children().length(); i++)
               {
                  childTarget = target + "." + "children()" + "." + i;
                  xml += this.parseXML(node.children()[i],childTarget,currentDepth + 1,maxDepth);
               }
               xml += this.createNode("/node");
            }
         }
         return xml;
      }
      
      protected function parseType(type:String) : String
      {
         var s:String = type;
         if(type.lastIndexOf("::") != -1)
         {
            s = type.substring(type.lastIndexOf("::") + 2,type.length);
         }
         if(s.lastIndexOf(".") != -1)
         {
            s = s.substring(0,s.lastIndexOf("."));
         }
         if(s == this.TYPE_METHOD)
         {
            s = this.TYPE_FUNCTION;
         }
         return this.htmlEscape(s);
      }
      
      protected function createNode(title:String, object:Object = null, close:Boolean = false) : String
      {
         var prop:* = undefined;
         var xml:String = "";
         xml += "<" + title;
         if(object)
         {
            for(prop in object)
            {
               xml += " " + prop + "=\"" + object[prop] + "\"";
            }
         }
         if(close)
         {
            xml += "></" + title + ">";
         }
         else
         {
            xml += ">";
         }
         return xml;
      }
      
      protected function printObject(object:*, type:String) : String
      {
         var s:String = "";
         if(type == this.TYPE_BYTEARRAY)
         {
            s = object["length"] + " bytes";
         }
         else
         {
            s = this.htmlEscape(String(object));
         }
         return s;
      }
      
      protected function enterFrameHandler(event:Event) : void
      {
         if(this.isEnabled)
         {
            ++this.monitorFrames;
         }
      }
      
      protected function monitorHandler(event:TimerEvent) : void
      {
         var memory:uint = 0;
         var now:Number = NaN;
         var delta:Number = NaN;
         var fps:uint = 0;
         var obj:Object = null;
         if(this.isEnabled)
         {
            memory = System.totalMemory;
            now = new Date().time;
            delta = now - this.monitorTime;
            fps = this.monitorFrames / delta * 1000;
            this.monitorFrames = 0;
            this.monitorTime = now;
            obj = {
               "text":this.COMMAND_MONITOR,
               "memory":memory,
               "fps":fps,
               "time":now,
               "start":this.monitorStart
            };
            if(this.isConnected)
            {
               this.send(obj);
            }
            else
            {
               this.sendToBuffer(obj);
            }
         }
      }
      
      protected function htmlEscape(s:String) : String
      {
         var xml:XML = null;
         if(s)
         {
            if(s.indexOf("&") != -1)
            {
               s = s.split("&").join("&amp;");
            }
            if(s.indexOf("<") != -1)
            {
               s = s.split("<").join("&lt;");
            }
            if(s.indexOf(">") != -1)
            {
               s = s.split(">").join("&gt;");
            }
            if(s.indexOf("\'") != -1)
            {
               s = s.split("\'").join("&apos;");
            }
            if(s.indexOf("\"") != -1)
            {
               s = s.split("\"").join("&quot;");
            }
            xml = <a>{s}</a>;
            return xml.toXMLString().replace(/(^<a>)|(<\/a>$)|(^<a\/>$)/g,"");
         }
         return "";
      }
      
      private function asyncErrorHandler(event:AsyncErrorEvent) : void
      {
         this.isConnected = false;
         if(instance != null && instance.root != null)
         {
            (instance.root as EventDispatcher).dispatchEvent(new Event("DebuggerDisconnected"));
         }
      }
      
      private function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         this.isConnected = false;
         if(instance != null && instance.root != null)
         {
            (instance.root as EventDispatcher).dispatchEvent(new Event("DebuggerDisconnected"));
         }
      }
      
      private function statusHandler(event:StatusEvent) : void
      {
         if(event.level == "error")
         {
            this.isConnected = false;
            if(instance != null && instance.root != null)
            {
               (instance.root as EventDispatcher).dispatchEvent(new Event("DebuggerDisconnected"));
            }
         }
      }
   }
}
