/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.aep.ea.responsivetodo.data;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author S001350
 */
@Entity
@Table(name = "TODO_TASKS")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TodoTasks.findAll", query = "SELECT t FROM TodoTasks t")
})
public class TodoTasks implements Serializable {
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 1)
    @Column(name = "PRIORITY")
    private String priority;
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "TASKID")
    private Integer taskid;
    
    @Basic(optional = false)
    @NotNull
    @Column(name = "DONE")
    private Boolean done;
    
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 2048)
    @Column(name = "TASK")
    private String task;
    
    @Basic(optional = false)
    @NotNull
    @Column(name = "DUEBY")
    @Temporal(TemporalType.DATE)
    private Date dueby;

    public TodoTasks() {
    }

    public TodoTasks(Integer taskid) {
        this.taskid = taskid;
    }

    public TodoTasks(Integer taskid, Boolean done, String task, Date dueby) {
        this.taskid = taskid;
        this.done = done;
        this.task = task;
        this.dueby = dueby;
    }

    public Integer getTaskid() {
        return taskid;
    }

    public void setTaskid(Integer taskid) {
        this.taskid = taskid;
    }

    public Boolean getDone() {
        return done;
    }

    public void setDone(Boolean done) {
        this.done = done;
    }

    public String getTask() {
        return task;
    }

    public void setTask(String task) {
        this.task = task;
    }

    public Date getDueby() {
        return dueby;
    }

    public void setDueby(Date dueby) {
        this.dueby = dueby;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (taskid != null ? taskid.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TodoTasks)) {
            return false;
        }
        TodoTasks other = (TodoTasks) object;
        if ((this.taskid == null && other.taskid != null) || (this.taskid != null && !this.taskid.equals(other.taskid))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.aep.ea.responsivetodo.data.TodoTasks[ taskid=" + taskid + " ]";
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }
    
}
