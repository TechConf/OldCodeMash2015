/*
  This file contains functions used by the PredicateEditorTag 
  (wl:predicate-editor). These functions are needed on predicate editing 
  pages that have multiple items that can be added such as a list of users.
    
  Copyright (c) 2003,2013, Oracle and/or its affiliates. All rights reserved.
*/

var pe_delimiter = ",";
// simple trim function
function trimstr(str)
{
    //Match spaces at beginning and end of text and replace
    //with null strings
     return str.replace(/^\s+/,'').replace(/\s+$/,'');
}

function pe_addToList(elementName, formObj) {
  var textElemName = elementName + "_add";
  var value = formObj.elements[textElemName].value;
  if(trimstr(value).length==0) {
    formObj.elements[textElemName].value = '';
    return;
  }
  var newOpt = new Option(value,value);
  var selectElementName = elementName + "_select";
  var length = formObj.elements[selectElementName].options.length;
  formObj.elements[selectElementName].options[length] = newOpt;
  //add to our hidden field
  var hiddenValue = formObj.elements[elementName].value;
  if (hiddenValue == '') {
    hiddenValue = value;
  } else {
    hiddenValue = hiddenValue + pe_delimiter + value;
  }
  formObj.elements[elementName].value = hiddenValue;
  formObj.elements[textElemName].value = '';
}

function pe_removeFromList(elementName, formObj) {
  var selectElementName = elementName + "_select";
  var selectElem = formObj.elements[selectElementName]
  var selectInd = selectElem.selectedIndex;
  //cant remove anything they havent selected
  if (selectInd == -1) return;
  
  var newVal = '';
  var len = selectElem.options.length;
  for (var i=len-1; i >= 0; i--) {
    var option = selectElem.options[i];
    if (option.selected) {
      selectElem.remove(i);
    } else {
      if (newVal.length == 0) {
        newVal = option.value;
      } else {
        newVal = option.value + pe_delimiter + newVal;
      }
    } 
  }
  
  formObj.elements[elementName].value=newVal;
}
