/**
 * LICENSE
 * 
 * By viewing, using, or actively developing this application in any way, you are
 * henceforth bound the license agreement, and all of its changes, set forth by
 * ForwardFour Innovations. The license can be found, in its entirety, at this 
 * address: http://forwardfour.com/license. 
 *
 * @category   Core
 * @package    com.forwardfour.waveAudio
 * @copyright  Copyright (c) 2011 and Onwards, ForwardFour Innovations
 * @license    http://forwardfour.com/license    [Proprietary/Closed Source]
 */

package com.forwardfour.waveAudio {
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.display.Stage;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.net.URLRequest;
	import flash.filters.GlowFilter;
	import com.greensock.*;
	import com.greensock.plugins.*;
	
/**
 * This class is the preloader class for "main.swf". The "preloader" indicator is controlled by
 * a timer, whose progress will be resembled by glowing dots of increasing brightness which
 * will fill up a  horizontal region of the screen, until the percentage reaches 100.
 *
 * @category   Core
 * @package    com.forwardfour.waveAudio
 * @since      v0.1 Dev
 */

	public class TimerMain extends EventDispatcher {
	/*
	Configuration
	----------------------------------------------
	*/
	
	/**
	 * The source file which will be loaded
	 * 
	 * @var        String
	 */
		public var source:String;
		
	/**
	 * The amount of time the artifical loader will display on screen, in milliseconds
	 * 
	 * @var        int
	 */
		public var time:int; //In milliseconds
		
	/**
	 * The hexadecimal color which will set the color of the dots
	 * 
	 * @var        uint
	 */
	 	public var dotColor:uint = 0xFFFFFF; //White
		
	/**
	 * The hexadecimal color which will set the glow of the bright dots
	 * 
	 * @var        uint
	 */
	 	public var dotGlow:uint = 0xFFFFFF; //White
		
	/**
	 * The time in milliseconds a dot has to fade on completely
	 * 
	 * @var        int
	 */
	 	public var fadeOnTime:int = 1; //In milliseconds
		
	/**
	 * The time in milliseconds a dot has to fade to black
	 * 
	 * @var        int
	 */
	 	public var fadeOffTime:int = 1000; //In milliseconds
		
	/**
	 * The distance of the preloader bar from the top of the application
	 * 
	 * @var        int
	 */
	 	public var paddingTop:int;       //Use either "paddingTop"
		
	/**
	 * The distance of the preloader bar from the left side of the application
	 * 
	 * @var        int
	 */
	 	public var paddingLeft:int = 0;
		
	/**
	 * The distance of the preloader bar from the bottom of the application
	 * 
	 * @var        int
	 */
	 	public var paddingBottom:int;       // ... or "paddingBottom". If both are used, "paddingBottom" is ignored.
		
	/**
	 * The distance of the preloader bar from the right side of the application
	 * 
	 * @var        int
	 */
	 	public var paddingRight:int = 0;
		
	/**
	 * Show the percentage loaded as numbers following the brightest dots
	 * 
	 * @var        Boolean
	 */
	 	public var showPercent:Boolean = true;
		
	/**
	 * The hexadecimal color which will set the color of the percentage text
	 * 
	 * @var        uint
	 */
	 	public var textColor:uint = 0x808080; //Grey
		
	/**
	 * Whether the text is "above" or "below" the brightest dot
	 * 
	 * @var        String
	 */
	 	public var textLocation:String = "above"; //Either "above" or "below"
		
	/*
	System tracking
	----------------------------------------------
	*/
	
	//Event listener constants
	/**
	 * An event that is fired whenever a new whole percent number has been reached
	 * 
	 * @var        String
	 * @static
	 */
		public static const PERCENT_REACHED:String = "percentReached";
	
	/**
	 * An event that is fired whenever the targeted file has been loaded
	 * 
	 * @var        String
	 * @static
	 */
		public static const LOAD_COMPLETE:String = "loadComplete";
		
	/**
	 * An event that is fired whenever the targeted file could not be loaded
	 * 
	 * @var        String
	 * @static
	 */
		public static const LOAD_FAILED:String = "loadFailed";
		
	/**
	 * An event that is fired whenever the timer is completed
	 * 
	 * @var        String
	 * @static
	 */
		public static const TIMER_COMPLETE:String = "timerComplete";
		
	/**
	 * An event that is fired whenever all operations are complete
	 * 
	 * @var        String
	 * @static
	 */
		public static const ALL_COMPLETE:String = "operationsComplete";
		
	//Private tracking variables
	/**
	 * A reference to the stage
	 * 
	 * @var        Stage
	 */
		private var parentStage:Stage;
		
	/**
	 * A reference to the file loader
	 * 
	 * @var        Loader
	 */
		private var SWFLoader:Loader;
		
	/**
	 * A reference to the loaded file
	 * 
	 * @var        MovieClip
	 */
		private var loadedSWF:MovieClip;
		
	/**
	 * The timer containing for the artifical preloader
	 * 
	 * @var        Timer
	 */
		private var timer:Timer;
		
	/**
	 * A reference to the percent loaded text
	 * 
	 * @var        TextField
	 */
	 	private var percentText:TextField;
		
	/**
	 * The style class assoicated with the "percentText" text field
	 * 
	 * @var        TextFormat
	 */
	 	private var textFormat:TextFormat;
		
	/**
	 * Track the "y-axis" location of the row of dots
	 * 
	 * @var        int
	 */
	 	private var y:int;
		
	/**
	 * A reference to the percentage that the timer has finished
	 * 
	 * @var        Number
	 */
		private var percentage:Number = 0;
		
	/**
	 * Track when both the timer and file loading operations have completed
	 * 
	 * @var        Array
	 */
		private var completed:Array = new Array();
		
		
	/*
	File loader initialization
	----------------------------------------------
	*/
	
	/**
	 * CONSTRUCTOR METHOD
	 *
	 * Obtain a reference to the stage, and fill the completed tracking arra with values
	 * 
	 * @param      Stage            parentStage  Obtain a reference to the stage in which to place the preloader
	 * @return     void
	 * @since      v0.1 Dev
	 */
		public function TimerMain(parentStage:Stage):void {
		//Globalize the reference to the stage
			this.parentStage = parentStage;
			
		//Fill the completed tracking arra with values
			this.completed["file"] = 0;
			this.completed["timer"] = 0;
		}
		
	/**
	 * Load the targeted file, start the timer, calculate the y-axis placement of the row
	 * of dots, and setup and place the percent loaded text in its proper location
	 * 
	 * @throws     Error
	 * @return     void
	 * @since      v0.1 Dev
	 */
		public function load():void {
		//Ensure that only the "paddingTop" or the "paddingBottom" has been set	for the "y" direction
			try {
				var paddingBottom = String(this.paddingBottom);
				var paddingTop = String(this.paddingTop);
				
				if (paddingBottom != "" && paddingTop != "") {
					throw new Error("Setting the y coordinate to the paddingTop value...");
				} else if (paddingBottom != "") {
					this.y = this.paddingTop;
				} else if (paddingTop != "") {
					this.y = this.paddingBottom;
				} else {
					this.y = this.parentStage.stageHeight;
				}
		// ... otherwise ignore the "paddingTop"
			} catch(e:Error) {
				this.y = this.paddingTop;
			}
			
		//Setup and place the percent text in its proper location
			if (this.showPercent) {
			//Text field styles
				this.textFormat = new TextFormat();
				this.textFormat.color = this.textColor;
				this.textFormat.size = 24;
				this.textFormat.font = "Arial";
				
			//Text field creation and options
				this.percentText = new TextField();
				this.percentText.selectable = false;
				this.percentText.text = "0";
				this.percentText.setTextFormat(this.textFormat);
								
			//Add the text field to the stage
				this.parentStage.addChild(this.percentText);
			
				this.percentText.x = this.paddingLeft;
				this.percentText.y = this.textLocation == "below" ? this.y + 5 : this.y - 35;
			}
			
		//Check to see if all of the required variables have been set
			try {
				if (this.source == "" || this.source == null) {
					throw new Error("The TimerMain class is missing a required variable");
			//Then load the requested file
				} else {
				//Start the timer
					this.timer = new Timer(this.time / 100, 100);
					this.timer.addEventListener(TimerEvent.TIMER, trackProgress);
					this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
					this.timer.start();
					
				//Start the loading process
					this.SWFLoader = new Loader();
					this.SWFLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
					this.SWFLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
					
				//This will throw an error if the file does not abide to cross-domain policies
					this.SWFLoader.load(new URLRequest(this.source));
				}
		//Handle this error
			} catch(e:Error) {
			//Show the alert message
				var errorText:TextField = new TextField();
				errorText.text = e.message;
				errorText.x = 100;
				errorText.y = 100;
				errorText.width = 300;
				errorText.textColor = 0xFF0000; //Red
				
				this.parentStage.addChild(errorText);
			}
		}
	
	/*
	Timer progress listeners
	----------------------------------------------
	*/
	
	/**
	 * Track the timer progress with a visual progress bar, represented by dots
	 * 
	 * @param      TimerEvent       e            An object containing information regarding the targeted object's loading progress
	 * @return     void
	 * @since      v0.1 Dev
	 */
		private function trackProgress(e:TimerEvent):void {
		//Log the current percentage that the timer has reached
			this.percentage++;
		
		//Build the next dot for the current percentage
			this.dotConfig(this.percentage);
			
		//Dispatch an event that a new percentage has been reached
			dispatchEvent(new Event(TimerMain.PERCENT_REACHED));
		}
		
	/**
	 * The load complete event dispatcher, which also adds the invisible SWF to the stage
	 * 
	 * @param      Event            e            An object containing information regarding the targeted object's loading progress
	 * @return     void
	 * @since      v0.1 Dev
	 */
		private function loadComplete(e:Event):void {
		//Dispatch the event listener
			dispatchEvent(new Event(TimerMain.LOAD_COMPLETE));
			
		//Update the event logger, to ready the class to fire the "ALL_COMPLETE" event
			this.completed["file"] = 1;
			this.completed["timer"] == 1 ? this.allComplete() : false;
			
		//Add the SWF to the stage
			this.loadedSWF = new MovieClip();
			this.loadedSWF.alpha = 0;
			this.loadedSWF.addChild(e.currentTarget.content);
			this.parentStage.addChild(this.loadedSWF);
		}
		
	/**
	 * The load failed event dispatcher
	 * 
	 * @param      IOErrorEvent     e            An object containing information regarding the targeted object's loading failed operation
	 * @return     void
	 * @since      v0.1 Dev
	 */
		private function loadError(e:IOErrorEvent):void {
		//Dispatch the event listener
			dispatchEvent(new Event(TimerMain.LOAD_FAILED));
		}
		
	/**
	 * The timer complete event dispatcher
	 * 
	 * @param      TimerEvent       e            An object containing information regarding the timer's completion status
	 * @return     void
	 * @since      v0.1 Dev
	 */
		private function timerComplete(e:TimerEvent):void {
		//Dispatch the event listener
			dispatchEvent(new Event(TimerMain.TIMER_COMPLETE));
			
		//Update the event logger, to ready the class to fire the "ALL_COMPLETE" event
			this.completed["timer"] = 1;
			this.completed["file"] == 1 ? this.allComplete() : false;
		}
		
	/**
	 * The all processes complete event dispatcher, which also begin the transitioning
	 * process for fading the loaded SWF into view
	 * 
	 * @return     void
	 * @since      v0.1 Dev
	 */
		private function allComplete():void {
		//Dispatch the event listener
			dispatchEvent(new Event(TimerMain.ALL_COMPLETE));
			
		//Clean up old, processor intensive tasks
			this.cleanUp();
			
		//Transition the loaded content to the stage, after waiting 2 seconds
			var transition:Timer = new Timer(2000, 1);
			transition.addEventListener(TimerEvent.TIMER, addSWF);
			transition.start();
		}
		
	/**
	 * Transition the loaded content into view
	 * 
	 * @param      TimerEvent       e            An object containing information regarding the timer's completion status
	 * @return     void
	 * @since      v0.1 Dev
	 */
		
		private function addSWF(e:TimerEvent):void {
		//Remove an event listener
			e.target.removeEventListener(TimerEvent.TIMER, addSWF);
			e.target.stop();
			
		//Transition the SWF into view
			this.parentStage.setChildIndex(this.loadedSWF, this.parentStage.numChildren - 1);
			TweenLite.to(this.loadedSWF, 1, {
						 	alpha : 1
						 });
		}
		
	/*
	Visual effects initialization
	----------------------------------------------
	*/
	
	/**
	 * Gather the data from the load status and configuration to place a newly created dot
	 * 
	 * @param      int              percentage   An object containing information regarding the targeted object's loading failed operation
	 * @return     void
	 * @since      v0.1 Dev
	 */
		private function dotConfig(percentage:int):void {
		//Calculate the even spacing between the dots
			var xSpacing = (this.parentStage.stageWidth - (this.paddingLeft + this.paddingRight)) / 100;
			var x = this.paddingLeft + (percentage * xSpacing);
			
			this.buildDots(x, percentage);
		}
	
	/**
	 * Build the dots and update the percentage text according the configuration and load
	 * status parameters
	 * 
	 * @param      x                int          An interger marking where to place the dot in an x direction
	 * @param      percentage       int          An interger indicating the current percentage of the load operation
	 * @return     void
	 * @since      v0.1 Dev
	 */
		private function buildDots(x:int, percentage:int):void {			
		//Create a dot, add a glow to is, place it inside of a MovieClip
			var dot = new Shape();
			dot.graphics.beginFill(this.dotColor);
			dot.graphics.drawCircle(0, 0, 2);
			dot.graphics.endFill();
			
			var glow:GlowFilter = new GlowFilter(this.dotGlow);
			dot.filters = new Array(glow);
			
			var container:MovieClip = new MovieClip();
			container.addChild(dot);
			
		//Add the child MovieClip to the stage
			container.x = x;
			container.y = this.y;
			container.alpha = 0;
			this.parentStage.addChild(container);
			
		//Update the position of the percentage text
			if (this.showPercent) {
			//Adjust the position for the number of characters in the percent indicator
				var textX:int;
				
				if (percentage <= 9) {
					textX = x - 7;
				} else if (percentage >= 10 && percentage <= 99) {
					textX = x - 23;
				} else if (percentage == 100) {
					textX = x - 37;
				}
				
				var fadeOn:TweenLite = new TweenLite(this.percentText, 0.5, {
					x : textX
				});
				
				this.percentText.text = percentage.toString();
				this.percentText.setTextFormat(this.textFormat);
			}
			
		//Begin the transitioning
			this.fadeOn(container);
		}
		
	/**
	 * Fade a dot to full brightness
	 * 
	 * @param      dot              MovieClip    A reference to the MovieClip containing the current dot
	 * @return     void
	 * @since      v0.1 Dev
	 */
		private function fadeOn(dot:MovieClip):void {
			var fadeOn:TweenLite = new TweenLite(dot, this.fadeOnTime / 1000, {
				alpha : 1,
				onComplete : fadeOff,
				onCompleteParams : new Array(dot)
			});
		}
		
	/**
	 * Fade a dot to black
	 * 
	 * @param      dot              MovieClip    A reference to the MovieClip containing the current dot
	 * @return     void
	 * @since      v0.1 Dev
	 */
		private function fadeOff(dot:MovieClip):void {
			TweenPlugin.activate([TintPlugin]);
			
			var fadeOn:TweenLite = TweenLite.to(dot, this.fadeOffTime / 1000, {
				tint : 0x000000
			});
		}	
		
	/*
	Finalizing
	----------------------------------------------
	*/
	
	/**
	 * A clean-up method to remove event listeners and prepare unnecessary information for garbage collection
	 * 
	 * @return     void
	 * @since      v0.1 Dev
	 */
		private function cleanUp():void {
		//Clear event listeners
			this.timer.removeEventListener(TimerEvent.TIMER, trackProgress);
			this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			this.SWFLoader.removeEventListener(Event.COMPLETE, loadComplete);
			this.SWFLoader.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			
			this.timer = null;
			this.SWFLoader = null;
		}
	}
}