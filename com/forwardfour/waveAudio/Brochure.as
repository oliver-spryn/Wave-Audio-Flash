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
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;

/**
 * This class creates an inviting layout to advertise and link to company brochures.
 * A thumbnail is created and displayed on the left side of a large title, small 
 * description, and clear download link
 *
 * @category   Core
 * @package    com.forwardfour.waveAudio
 * @since      v0.1 Dev
 */
	public class Brochure {
	/**
	 * The class containing the thumbnail
	 * 
	 * @var        MovieClip
	 */
		public var thumbnail:MovieClip;
		
	/**
	 * The title of the brochure
	 * 
	 * @var        String
	 */
		public var title:String;
		
	/**
	 * The description of the brochure
	 * 
	 * @var        String
	 */
		public var description:String;
		
	/**
	 * The URL of the download link
	 * 
	 * @var        String
	 */
		public var downloadURL:String;
		
	/**
	 * The x-axis location of the brochure
	 * 
	 * @var        int
	 */
		public var x:String;
		
	/**
	 * The y-axis location of the brochure
	 * 
	 * @var        int
	 */
		public var y:String;
		
	//Private tracking variables
	/**
	 * A reference to the MovieClip in which to place the brochure
	 * 
	 * @var        MovieClip
	 */
		private var parentStage:Stage;
		
	/**
	 * A reference to the MovieClip which contains all of the other objects
	 * 
	 * @var        MovieClip
	 */
		private var container:MovieClip;
		
	/**
	 * CONSTRUCTOR METHOD
	 *
	 * Obtain a reference to the MovieClip in which to place the brochure
	 * 
	 * @param      MovieClip        parentStage  Obtain a reference to the movieclip in which to place the preloader
	 * @return     void
	 * @since      v0.1 Dev
	 */
		public function Brochure(parentStage:Stage) {
			this.parentStage = parentStage;
		}
		
	/**
	 * Build the brochure link
	 * 
	 * @return     void
	 * @since      v0.1 Dev
	 */
		public function build():void {
		//Create the containing MovieClip
			this.container = new MovieClip();
			this.container.height = 162;
			this.container.width = 220;
			this.container.x = 0;
			this.container.y = 0;
			
		//Import the thumbnail
			this.thumbnail.height = 162;
			this.thumbnail.width = 125;
			this.thumbnail.x = 0;
			this.thumbnail.y = 0;
			this.container.addChild(this.thumbnail);
			
		//Add a title
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.bold = true;
			titleFormat.color = 0xFFFFFF;
			titleFormat.font = "Arial";
			titleFormat.size = 14;
			
			var title:TextField = new TextField();
			title.text = "null-o wall-o";
			title.x = 135;
			title.y = 15;
			title.setTextFormat(titleFormat);
			this.container.addChild(title);
			
		//Add the description
			var descriptionFormat:TextFormat = new TextFormat();
			descriptionFormat.color = 0xFFFFFF;
			descriptionFormat.font = "Arial";
			descriptionFormat.size = 12;
			
			var description:TextField = new TextField();
			description.text = "null-o wall-o";
			description.x = 135;
			description.y = 30;
			description.setTextFormat(descriptionFormat);
			this.container.addChild(description);
			
		//Add the containing MovieClip to the stage
			this.parentStage.addChild(this.container);
		}
	}
}