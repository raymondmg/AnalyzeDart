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
 * Text area. Nodes inside are indented.
 * Jaxe display type: 'layout' (layout).
 * 
 * * parameter: `titreAtt`: an attribute that can be used as a title
 * * parameter: `style`: as in DNStyle
 */
class DNLayout extends DaxeNode {
  Tag _b1, _b2;
  
  DNLayout.fromRef(x.Element elementRef) : super.fromRef(elementRef) {
    _b1 = new Tag(this, Tag.START, false, false);
    _b2 = new Tag(this, Tag.END, false, false);
  }
  
  DNLayout.fromNode(x.Node node, DaxeNode parent) : super.fromNode(node, parent) {
    _b1 = new Tag(this, Tag.START, false, false);
    _b2 = new Tag(this, Tag.END, false, false);
    
    fixLineBreaks();
  }
  
  @override
  h.Element html() {
    h.DivElement div = new h.DivElement();
    div.id = "$id";
    div.classes.add('dn');
    //div.classes.add('$localName');
    //addDivClasses(div);  
    div.classes.add('dt_layout');
    copyAttrFromXml(div);
    if (!valid)
      div.classes.add('invalid');
    div.append(_b1.html());
    h.DivElement contents = new h.DivElement();
    contents.classes.add('indent');
    DaxeNode dn = firstChild;
    while (dn != null) {
      contents.append(dn.html());
      dn = dn.nextSibling;
    }
    if (lastChild == null || lastChild.nodeType == DaxeNode.TEXT_NODE)
      contents.appendText('\n');
    //this kind of conditional HTML makes it hard to optimize display updates:
    //we have to override updateHTMLAfterChildrenChange
    // also, it seems that in IE this adds a BR instead of a text node !
    setStyle(contents);
    div.append(contents);
    //div.append(_b2.html());
    return(div);
  }
  
  
  void addDivClasses(h.DivElement div){ // Obsolete
    div.classes.add('dt_layout');
    DaxeNode _dn = this;
    List<String> classAttributes = doc.cfg.getElementParameters(_dn.ref)['dtClass'];
    if (classAttributes != null) {
      for (String attr in classAttributes) {
        String value = _dn.getAttribute(attr);
        if (value != null && value != '') {
          if(attr == "class"){
            div.classes.add('$value');
          }else if(attr=="xs" || attr=="sm" || attr=="md" || attr=="lg" ){
            if(value == "hidden")
                div.classes.add('hidden'+'-'+'$attr');
            else
              div.classes.add('col-'+'$attr'+'-'+'$value');
          }
        }
      }
    }
  }
  
  @override
  void updateHTMLAfterChildrenChange(List<DaxeNode> changed) {
    super.updateHTMLAfterChildrenChange(changed);
    h.DivElement contents = getHTMLContentsNode();
    if (contents.nodes.length > 0) {
      h.Node hn = contents.nodes.first;
      while (hn != null) {
        h.Node next = hn.nextNode;
        if (hn is h.Text || hn is h.BRElement)
          hn.remove();
        hn = next;
      }
    }
    if (lastChild == null || lastChild.nodeType == DaxeNode.TEXT_NODE)
      contents.appendText('\n');
  }
  
  @override
  void updateAttributes() {
    h.Element old = getHTMLNode().nodes[0];
    _b1 = new Tag(this, Tag.START, false, false);
    old.replaceWith(_b1.html());
    h.Element div = getHTMLNode();
    div.classes.clear();
    div.classes.add('dn');
    div.classes.add('dt_layout');
    //div.classes.add('$localName');
    //addDivClasses(div);
    copyAttrFromXml(div);
    if (!valid)
      div.classes.add('invalid');
    
  }
  
  @override
  h.Element getHTMLContentsNode() {
    return(getHTMLNode().nodes[1]);
  }
  
  @override
  bool newlineAfter() {
    return(true);
  }
  
  @override
  bool newlineInside() {
    return(true);
  }
}
