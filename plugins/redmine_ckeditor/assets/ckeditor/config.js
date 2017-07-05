/**
 * @license Copyright (c) 2003-2016, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function (config) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.extraPlugins = 'dialogui,dialog,button,toolbar,notification,clipboard,lineutils,widget,codesnippet';

	/* Filebrowser routes */
	// The location of an external file browser, that should be launched when "Browse Server" button is pressed.
	config.filebrowserBrowseUrl = "/rich/files";

	// The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
	config.filebrowserFlashBrowseUrl = "/rich/files";

	// The location of a script that handles file uploads in the Flash dialog.
	config.filebrowserFlashUploadUrl = "/rich/files";

	// The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
	config.filebrowserImageBrowseLinkUrl = "/rich/files";

	// The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
	config.filebrowserImageBrowseUrl = "/rich/files";

	// The location of a script that handles file uploads in the Image dialog.
	config.filebrowserImageUploadUrl = "/rich/files";

	// The location of a script that handles file uploads.
	config.filebrowserUploadUrl = "/rich/files";
};