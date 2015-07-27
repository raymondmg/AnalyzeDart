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

part of nodes;

/**
 * Image file. The image is displayed in the text if it is found,
 * otherwise an error message is displayed instead of the image.
 * Jaxe display type: 'fichier' (file).
 * 
 * * parameter: `srcAtt`: the name of the attribute giving the file path
 */
class DNFile extends DaxeNode {
  Tag _b1, _b2;
  
  h.ImageElement _img; // TODO: support non-image files
  String _srcAtt;
  
  DNFile.fromRef(x.Element elementRef) : super.fromRef(elementRef) {
    _srcAtt = doc.cfg.elementParameterValue(ref, 'srcAtt', 'data-toattr-src');
    _b1 = new Tag(this, Tag.START, false);
    _b2 = new Tag(this, Tag.END, false);
  }
  
  DNFile.fromNode(x.Node node, DaxeNode parent) : super.fromNode(node, parent) {
    _srcAtt = doc.cfg.elementParameterValue(ref, 'srcAtt', 'data-toattr-src');
    _b1 = new Tag(this, Tag.START, false);
    _b2 = new Tag(this, Tag.END, false);
  }
  
//  @override
//  h.Element html() {
//    assert(doc.filePath != null);
//    _img = new h.ImageElement();
//    _img.attributes['id'] = "$id";
//    _img.attributes['class'] = 'dn';
//    String folder = '';
//    String xmlFilePath = doc.filePath;
//    int ind = xmlFilePath.lastIndexOf('/');
//    if (ind != -1)
//      folder = xmlFilePath.substring(0, ind + 1);
//    String src = "$folder${getAttribute(_srcAtt)}";
//    _img.attributes['src'] = src;
//    _img.attributes['alt'] = getAttribute(_srcAtt);
//    _img.onLoad.listen((h.Event event) => imageLoaded());
//    _img.onClick.listen((h.MouseEvent event) => attributeDialog());
//    return(_img);
//  }
  
  @override
  h.Element html() {
    h.DivElement div = new h.DivElement();
    div.id = "$id";
    div.classes.add('dn');
    div.classes.add('dt_block');
    div.classes.add('$localName');

    div.append(_b1.html());
    h.DivElement contents = new h.DivElement();
    contents.classes.add('indent');
    
    _img = new h.ImageElement();
    String src = getAttribute(_srcAtt);
    copyAttrFromXml(_img);
    writeSrc(_img, src);

    //_img.attributes['alt'] = getAttribute(_srcAtt);
    _img.onLoad.listen((h.Event event) => imageLoaded());
    _img.onClick.listen((h.MouseEvent event) => attributeDialog());

      contents.append(_img);

      contents.appendText('\n');
    //this kind of conditional HTML makes it hard to optimize display updates:
    //we have to override updateHTMLAfterChildrenChange
    // also, it seems that in IE this adds a BR instead of a text node !
    //setStyle(contents);
    div.append(contents);
    //div.append(_b2.html());

    
    

    
    return(div);

  }
  
  void writeSrc(h.ImageElement img, [String umbNodeId = '1064'] ){
    if(umbNodeId == '')
      umbNodeId = "1064";
    var apiUrl = "/Umbraco/Api/DtAwas/GetImageSrcForDtDaxe?id=" + umbNodeId + "&crop=" + getAttribute("data-img-crop");
    void onDataLoaded(String responseText){
      Map data = JSON.decode(responseText);
      // Map upload = JSON.decode(data["Properties"]["upload"]);
      img.attributes['src'] = data.toString();
    }
    var request = h.HttpRequest.getString(apiUrl).then(onDataLoaded);
  }
  
  void imageLoaded() {
    // fix the width
    if (_img.naturalWidth > 500) {
      _img.width = 500;
    }
    
    // fix cursor position if it is after the image
    if (page.getSelectionStart() != null &&
        page.getSelectionStart() > new Position(this, 0))
      page.cursor.updateCaretPosition(false);
  }
  
  @override
  Position firstCursorPositionInside() {
    return(null);
  }
  
  @override
  Position lastCursorPositionInside() {
    return(null);
  }
}
