/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.aep.ea.responsivetodo.data;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;

/**
 *
 * @author S001350
 */
@XmlType(name="priority")
@XmlEnum
public enum Priority {
    @XmlEnumValue(value="0")
    HIGH("0"), 
    @XmlEnumValue(value="1")
    MEDIUM("1"), 
    @XmlEnumValue(value="2")
    LOW("2");
    
    private final String value;
    
    Priority(String value) { 
        this.value = value;
    }
}
