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
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
/**
 * This simple class contains all of the logic to create and listen to events
 * associated with a custom context menu.
 *
 * @category   Core
 * @package    com.forwardfour.waveAudio
 * @since      v0.1 Dev
 */
	public class Menu {
	/**
	 * Indicate to whom this application is licensed
	 * 
	 * @var        String
	 */
		public var licensee:String;
		
	/**
	 * CONSTRUCTOR METHOD
	 *
	 * Don't do anything, since this class is expected to have a return type, and constructor
	 * methods cannot have a return type.
	 *
	 * @return     void
	 * @since      v0.1 Dev
	 */
		public function Menu():void {
		//Don't do anything!
		}
		
	/**
	 * Create the context menu items and seperators
	 *
	 * @return     ContextMenu      menu         Return a modified version of the ContextMenu class to apply to the stage
	 * @since      v0.1 Dev
	 */
		public function build():ContextMenu {
		//Create a reference to the existing context menu
			var menu:ContextMenu = new ContextMenu();
			
		//Show the licensee
			var who = this.licensee == null || this.licensee == "" ? "this website" : this.licensee;
			var licensee:ContextMenuItem = new ContextMenuItem("Licensed to " + who);
			licensee.enabled = false;
				
		//Provide a link to the developer
			var developer:ContextMenuItem = new ContextMenuItem("Developed by ForwardFour Innovations");
			developer.enabled = false;
			
		//Hide the existing elements and push on the new ones
			menu.hideBuiltInItems();
			menu.customItems.push(licensee, developer);
			
		//Apply these menu items to the stage
			return menu;
		}
	}
}
