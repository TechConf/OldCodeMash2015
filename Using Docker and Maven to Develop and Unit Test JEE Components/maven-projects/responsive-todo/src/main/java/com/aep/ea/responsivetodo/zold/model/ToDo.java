/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.aep.ea.responsivetodo.zold.model;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;

/**
 *
 * @author S001350
 */
@XmlRootElement(name = "ToDoItem")
@XmlType(propOrder = {"taskId", "done", "priority", "task", "dueBy"})
public class ToDo {

    int taskId;
    private boolean done;
    private Priority priority;
    private String task;
    private String dueBy;

    public ToDo() {
    }

    public ToDo(int taskId, boolean done, Priority priority, String task, String dueBy) {
        this.taskId = taskId;
        this.done = done;
        this.priority = priority;
        this.task = task;
        this.dueBy = dueBy;
    }

    @XmlElement()
    public int getTaskId() {
        return taskId;
    }

    @XmlElement()
    @XmlSchemaType(name = "boolean")
    public boolean isDone() {
        return done;
    }

    @XmlElement(name = "priority")
    public Priority getPriority() {
        return priority;
    }

    @XmlElement(name = "task")
    public String getTask() {
        return task;
    }

    @XmlElement(name = "dueBy")
    public String getDueBy() {
        return dueBy;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public void setDone(boolean done) {
        this.done = done;
    }

    public void setPriority(Priority priority) {
        this.priority = priority;
    }

    public void setTask(String task) {
        this.task = task;
    }

    public void setDueBy(String dueBy) {
        this.dueBy = dueBy;
    }
}
