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
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.GradientType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Matrix;
	import com.greensock.*;
	
/**
 * This class creates a small tooltip whenever a trigger object is hovered over.
 *
 * @category   Core
 * @package    com.forwardfour.waveAudio
 * @since      v0.1 Dev
 */
	public class Tooltip {
	/**
	 * The width of the tooltip
	 * 
	 * @var        int
	 */
		public var width:int;
		
	/**
	 * The height of the tooltip
	 * 
	 * @var        int
	 */
		public var height:int;
		
	/**
	 * The title of the tooltip
	 * 
	 * @var        String
	 */
		public var title:String;
		
	/**
	 * The content of the tooltip
	 * 
	 * @var        String
	 */
		public var content:String;
		
	/**
	 * Whether or not the tooltip should have a gradient
	 * 
	 * @var        Boolean
	 */
		public var gradient:Boolean = false;
		
	/**
	 * Whether or not to display a border around the tooltip
	 * 
	 * @var        Boolean
	 */
		public var border:Boolean = true;
		
	/**
	 * The color of the border around the tooltip
	 * 
	 * @var        uint
	 */
		public var borderColor:uint = 0x000000; //Black
		
	/**
	 * The amount of roundness, in pixels, for the corners of the tooltip
	 * 
	 * @var        uint
	 */
		public var borderRadius:int = 10;
		
	/**
	 * The color (a string) or color range (an array) the tip should display
	 * 
	 * @var        *
	 */
		public var color:* = new Array(0x000000, 0xCCCCCC); //Black then grey
		
	/**
	 * The alpha (a string) or alpha range (an array) the tip should display
	 * 
	 * @var        *
	 */
		public var alpha:* = new Array(1, 0.3);
		
	/**
	 * The ratios governing where the range of colors should converge
	 * 
	 * @var        Array
	 */
		public var ratio:Array = new Array(0, 255);
		
	//Private tracking variables
	/**
	 * A reference to the object which triggered the mouseover
	 * 
	 * @var        MovieClip
	 */
		private var trigger:MovieClip;
		
	/**
	 * A reference to the stage
	 * 
	 * @var        Stage
	 */
		private var parentStage:Stage;
		
	/**
	 * A reference to the tooltip's box
	 * 
	 * @var        Shape
	 */
		private var tip:Shape;
		
	/**
	 * A reference to the tooltip's pointer
	 * 
	 * @var        Shape
	 */
		private var pointer:Shape;
		
	/**
	 * A reference to the tooltip's title TextField
	 * 
	 * @var        TextField
	 */
		private var titleText:TextField;
		
	/**
	 * A reference to the tooltip's content TextField
	 * 
	 * @var        TextField
	 */
		private var contentText:TextField;
		
	/**
	 * The y-axis anchor position of the tooltip
	 * 
	 * @var        int
	 */
		private var y:int;
		
	/**
	 * CONSTRUCTOR METHOD
	 *
	 * Obtain a reference to the stage
	 * 
	 * @param      MovieClip        trigger      Obtain a reference to the object which triggered the mouseover
	 * @param      Stage            parentStage  Obtain a reference to the stage in which to place the preloader
	 * @return     void
	 * @since      v0.1 Dev
	 */
		public function Tooltip(trigger:MovieClip, parentStage:Stage) {
			this.trigger = trigger;			
			this.parentStage = parentStage;
		}
		
	/**
	 * Build the tooltip according to the given configuration
	 * 
	 * @throws     Error
	 * @return     void
	 * @since      v0.1 Dev
	 */
		public function build() {
		//Calculate the coordinates
			var x:int = (this.trigger.x + (this.trigger.width / 2)) - (this.width / 2);
			
		//Subtract 6px to accomidate for the tip pointer, and another 25 to allow transitioning room
			this.y = this.trigger.y - this.height - 6 - 25;
			
		//Create the tip box
			this.tip = new Shape();			
			
			if (this.gradient) {
				try {
				//The values passed into beginGradientFill() must be an array, so check first
					if (this.color is Array) {
						var colors:Array = this.color;
					} else {
						throw new Error("The given colors must be in an array format");
					}
					
					if (this.alpha is Array) {
						var alphas:Array = this.alpha;
					} else {
						throw new Error("The given alphas must be in an array format");
					}
					
					if (this.ratio is Array) {
						var ratios:Array = this.ratio;
					} else {
						throw new Error("The given ratios must be in an array format");
					} 
					
				//The above arrays must also have the same number of values
					if (this.color.length == this.alpha.length && this.alpha.length == this.ratio.length) {
						var matrix:Matrix = new Matrix();
						matrix.createGradientBox(this.width, this.height, (90 * Math.PI) / 180, x, y);
						
						tip.graphics.beginGradientFill(GradientType.LINEAR, color, alphas, ratios, matrix);
					} else {
						throw new Error("The given colors, alphas, and ratio arrays must have the same length");
					}
				} catch (e:Error) {
					this.tip.graphics.beginFill(this.color is Array ? this.color[0] : this.color,
										   		this.alpha is Array ? this.alpha[0] : this.alpha);
				}
			} else {
				this.tip.graphics.beginFill(this.color is Array ? this.color[0] : this.color,
									  		this.alpha is Array ? this.alpha[0] : this.alpha);
			}
			
			this.tip.graphics.lineStyle(1, this.borderColor);
			this.tip.graphics.drawRoundRect(x, this.y, this.width, this.height, this.borderRadius);
			this.tip.graphics.endFill();
			this.tip.alpha = 0;
			this.parentStage.addChild(this.tip);
			
		//Create the title
			var titleStyle:TextFormat = new TextFormat();
			titleStyle.align = "center";
			titleStyle.color = 0xFFFFFF;
			titleStyle.font = "Arial";
			titleStyle.size = 24;
			
			this.titleText = new TextField();
			this.titleText.alpha = 0;
			this.titleText.height = 0;
			this.titleText.htmlText = this.title;
			this.titleText.selectable = false;
			this.titleText.width = 0;
			this.titleText.x = x;
			this.titleText.y = this.y;
			this.parentStage.addChild(this.titleText);
			this.titleText.setTextFormat(titleStyle);
			
		//Create the content
			var contentStyle:TextFormat = new TextFormat();
			contentStyle.align = "left";
			contentStyle.color = 0xFFFFFF;
			contentStyle.font = "Arial";
			contentStyle.size = 14;
			
			this.contentText = new TextField();
			this.contentText.alpha = 0;
			this.contentText.height = 0;
			this.contentText.htmlText = this.content;
			this.contentText.multiline = true;
			this.contentText.selectable = false;
			this.contentText.width = 0;
			this.contentText.wordWrap = true;
			this.contentText.x = x + 10; //Add 10px padding
			this.contentText.y = this.y;
			this.parentStage.addChild(this.contentText);
			this.contentText.setTextFormat(contentStyle);
			
		//Create the tip pointer		
			var pointerX:int = x + (this.width / 2);
			this.pointer = new Shape();
			
			if (this.gradient) {
				this.pointer.graphics.beginFill(this.color is Array ? this.color[this.color.length - 1] : this.color,
										   		this.alpha is Array ? this.alpha[this.alpha.length - 1] : this.alpha);
			} else {
				this.pointer.graphics.beginFill(this.color is Array ? this.color[0] : this.color,
										   		this.alpha is Array ? this.alpha[0] : this.alpha);
			}
			
			this.pointer.graphics.lineStyle(1, this.borderColor);
			this.pointer.graphics.moveTo(pointerX - 6, this.y + this.height);
			this.pointer.graphics.lineTo(pointerX + 6, this.y + this.height);
			this.pointer.graphics.lineTo(pointerX, this.y + this.height + 6);
			this.pointer.graphics.lineTo(pointerX - 6, this.y + this.height);
			this.pointer.graphics.endFill();
			this.pointer.alpha = 0;
			this.parentStage.addChild(this.pointer);
		}
		
	/**
	 * Transition the tooltip into of view
	 * 
	 * @return     void
	 * @since      v0.1 Dev
	 */
	 	public function transitionIn():void {
		//Revert the objects back to their original size
			this.tip.height = this.height + 1;
			this.tip.width = this.width + 1;
			
			this.titleText.height = 30;
			this.titleText.width = this.width;
			
			this.contentText.height = this.height - 30 - 10;
			this.contentText.width = this.width - 20;
			
		//Ensure the tip is the top layer
			this.parentStage.setChildIndex(this.tip, this.parentStage.numChildren - 1);
			this.parentStage.setChildIndex(this.pointer, this.parentStage.numChildren - 1);
			this.parentStage.setChildIndex(this.titleText, this.parentStage.numChildren - 1);
			this.parentStage.setChildIndex(this.contentText, this.parentStage.numChildren - 1);
			
		//Transition the object into view
			TweenLite.to(this.tip, 0.5, {
						 	y : 25,
							alpha : 1
						});
			
			TweenLite.to(this.pointer, 0.5, {
						 	y : 25,
							alpha : 1
						});
			
			TweenLite.to(this.titleText, 0.5, {
						 	y : this.y + 30,
							alpha : 1
						});
			
			TweenLite.to(this.contentText, 0.5, {
						 	y : this.y + 60,
							alpha : 1
						});
		}
		
	/**
	 * Transition the tooltip out of view
	 * 
	 * @return     void
	 * @since      v0.1 Dev
	 */
	 	public function transitionOut():void {
			TweenLite.to(this.tip, 0.5, {
						 	y : -25,
							alpha : 0
						});
			
			TweenLite.to(this.pointer, 0.5, {
						 	y : -25,
							alpha : 0
						});
			
			TweenLite.to(this.titleText, 0.5, {
						 	y : this.y - 25,
							alpha : 0
						});
			
			TweenLite.to(this.contentText, 0.5, {
						 	y : this.y,
							alpha : 0,
							onComplete : resize
						});
		}
		
	/**
	 * Resize the tooltip and its contents down to a really small size, to keep
	 * it out of the way
	 * 
	 * @return     void
	 * @since      v0.1 Dev
	 */
	 	private function resize():void {
			this.tip.height = 0;
			this.tip.width = 0;
			
			this.titleText.height = 0;
			this.titleText.width = 0;
			
			this.contentText.height = 0;
			this.contentText.width = 0;
		}
	}
}