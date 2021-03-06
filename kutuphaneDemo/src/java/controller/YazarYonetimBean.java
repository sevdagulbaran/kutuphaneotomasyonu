/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSF/JSFManagedBean.java to edit this template
 */
package controller;

import entity.Kullanici;
import entity.Yazar;
import jakarta.inject.Named;
import jakarta.enterprise.context.Dependent;
import jakarta.enterprise.context.RequestScoped;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Null;
import jakarta.validation.constraints.Size;

/**
 *
 * @author 90553
 */
@Named(value = "yazarYonetimBean")
@RequestScoped
public class YazarYonetimBean {
    


    @NotNull(message = "Yazar ismi bos olmaz.")
    private String ad;

    @NotNull(message = "Yazar ismi bos olmaz.")
    private String soyad;
    
     public YazarYonetimBean() {
    }


    public String getAd() {
        return ad;
    }

    public void setAd(String ad) {
        this.ad = ad;
    }

    public String getSoyad() {
        return soyad;
    }

    public void setSoyad(String soyad) {
        this.soyad = soyad;
    }
}