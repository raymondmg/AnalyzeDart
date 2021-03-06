/*
  This file is part of Daxe.

  Daxe is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Daxe is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Daxe.  If not, see <http://www.gnu.org/licenses/>.
*/

/**
 * Daxe - Dart XML Editor
 * The goal of this project is to replace the Jaxe Java applet in WebJaxe, but Daxe
 * could be used to edit XML documents online in any other application.
 * 
 * The URL must have the file and config parameters with the path to the XML file and Jaxe config file.
 * It can also have a save parameter with the path to a server script to save the document.
 */
library daxe;

import 'dart:async';
import 'dart:collection';

import 'dart:html' as h;


import 'package:meta/meta.dart';
//import 'package:js/js.dart' as js;

import 'xmldom/xmldom.dart' as x;
import 'strings.dart';

import 'interface_schema.dart';
import 'wxs/wxs.dart' show DaxeWXS, WXSException;
import 'nodes/nodes.dart';


part 'attribute_dialog.dart';
part 'cursor.dart';
part 'daxe_document.dart';
part 'daxe_exception.dart';
part 'config.dart';
part 'daxe_node.dart';
part 'daxe_attr.dart';
//part 'file_open_dialog.dart';
part 'find_dialog.dart';
part 'help_dialog.dart';
part 'insert_panel.dart';
part 'locale.dart';
part 'menu.dart';
part 'menubar.dart';
part 'menu_item.dart';
part 'node_factory.dart';
part 'position.dart';
part 'source_window.dart';
part 'tag.dart';
part 'undoable_edit.dart';
part 'validation_dialog.dart';
part 'web_page.dart';


typedef void ActionFunction();

/// The current web page
WebPage page;
/// The current XML document
DaxeDocument doc;
Map<String,ActionFunction> customFunctions = new Map<String,ActionFunction>();
var applicationVersion = "Version 1.0";
void main() {
  NodeFactory.addCoreDisplayTypes();
  var initData = null;

  Strings.load().then((bool b) {
    doc = new DaxeDocument();
    page = new WebPage();
    
    // check parameters for a config and file to open
    String file = null;
    String config = null;
    String xsd = null;
    String saveURL = null;
    String textAreaId = null;
    String rootNum = null;
    h.Location location = h.window.location;
    String search = location.search;
    if (search.startsWith('?'))
      search = search.substring(1);
    List<String> parameters = search.split('&');
    for (String param in parameters) {
      List<String> lparam = param.split('=');
      if (lparam.length != 2)
        continue;
      if (lparam[0] == 'config')
        config = lparam[1];
      else if (lparam[0] == 'file')
        file = Uri.decodeComponent(lparam[1]);
      else if (lparam[0] == 'save')
        saveURL = lparam[1];
      else if (lparam[0] == 'textareaid')
        textAreaId = lparam[1];
      else if (lparam[0] == 'root')
        rootNum = lparam[1];
      else if (lparam[0] == 'xsd')
        xsd = lparam[1];
    }
    if (saveURL != null)
      doc.saveURL = saveURL;
    if (xsd != null)
      doc.schemaPath = xsd;
    if (rootNum != null)
      doc.rootNum = rootNum;
    if (config != null && file != null && textAreaId == null)
      page.openDocument(file, config);
    else if (config != null && textAreaId != null && file == null){
      doc.rootNum = rootNum;
      page.openDocumentFromPost(config);
      //page.newDocument(config);
      doc.textAreaId = textAreaId;

      }
    else
      h.window.alert(Strings.get('daxe.missing_config'));
  });
}

/**
 * Adds a custom display type. Two constructors are required to define the display type:
 * 
 * * one to create a new node, with the element reference in the schema as a parameter;
 *   [Config] methods can be used via doc.cfg to obtain useful information with the reference.
 * * another one to create a new Daxe node based on a DOM [x.Node];
 *   it takes the future [DaxeNode] parent as a 2nd parameter.
 */
void addDisplayType(String displayType, ConstructorFromRef cref, ConstructorFromNode cnode) {
  NodeFactory.addDisplayType(displayType, cref, cnode);
}

/**
 * Adds a custom function which can be called by name with a menu defined in the configuration file.
 */
void addCustomFunction(String functionName, ActionFunction fct) {
  customFunctions[functionName] = fct;
}


