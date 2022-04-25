/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import entity.Kategori;
import entity.Kitap;
import entity.Yazar;
import util.DBConnection;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Sevda
 */
public class KitapDAO extends DBConnection {

    private KategoriDAO kategoriDao;

    public void create(Kitap kitap) {
        try {
            Statement st = this.getConnection().createStatement();

            String query = "insert into kitaplar(kategori_id,ad,sayfaSayisi,kitapKapagi)values('" + kitap.getKategori().getKategori_id() + "','" + kitap.getAd() + "','" + kitap.getSayfaSayisi() + "','" + kitap.getKitapKapagi() + "')";
            st.executeUpdate(query);

            ResultSet rs = st.executeQuery("select max(id) as mid from kitap");
            rs.next();

            int kitap_id = rs.getInt("mid");

            for (Yazar yazar : kitap.getYazarlar()) {
                query = "insert into yazarlar_kitaplar (yazar_id,kitap_id) values (" + yazar.getYazar_id() + " , " + kitap_id + ")";
                st.executeUpdate(query);
            }

        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void update(Kitap kitap) {
        try {
            Statement st = this.getConnection().createStatement();

            String query = "update kitaplar set kategori_id='" + kitap.getKategori().getKategori_id() + "',ad='" + kitap.getAd() + "',sayfasayisi='" + kitap.getSayfaSayisi() + "',kitapKapagi='" + kitap.getKitapKapagi() + "' where kitap_id=" + kitap.getKitap_id();
            st.executeUpdate(query);

            st.executeUpdate("delete from yazarlar_kitaplar where kitap_id=" + kitap.getKitap_id());

            for (Yazar yazar : kitap.getYazarlar()) {
                query = "insert into yazarlar_kitaplar (yazar_id,kitap_id) values (" + yazar.getYazar_id() + " , " + kitap.getKitap_id() + ")";
                st.executeUpdate(query);
            }

        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }

    public void delete(Kitap kitap) {
        try {
            Statement st = this.getConnection().createStatement();

            String query = "delete from kitaplar where kitap_id=" + kitap.getKitap_id();
            st.executeUpdate(query);

            st.executeUpdate("delete from yazarlar_kitaplar where kitap_id=" + kitap.getKitap_id());

        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }

    public List<Kitap> getList() {
        List<Kitap> kitapList = new ArrayList<>();

        try {
            Statement st = this.getConnection().createStatement();

            String query = "Select * from kitaplar";
            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {

                Kategori k = this.getKategoriDao().findById(rs.getInt("kategori_id"));
                kitapList.add(new Kitap(rs.getInt("kitap_id"), rs.getString("ad"), rs.getInt("sayfaSayisi"), k, rs.getString("kitapKapagi"),this.getKitapYazar(rs.getInt("id"))));
            }

        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        return kitapList;
    }

    public List<Yazar> getKitapYazar(int kitap_id) {
        List<Yazar> yazarList = new ArrayList<>();

        try {
            Statement st = this.getConnection().createStatement();

            String query = "Select * from yazarlar where id in (select yazar_id from yazarlar_kitaplar where kitap_id=" + kitap_id + ")";
            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {
                yazarList.add(new Yazar(rs.getInt("yazar_id"), rs.getString("ad"), rs.getString("soyad")));
            }

        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        return yazarList;
    }

    public Kitap findById(int id) {
        Kitap c = null;
        try {
            Statement st = this.getConnection().createStatement();
            String query = "select * from kitaplar where kitap_id=" + id;

            ResultSet rs = st.executeQuery(query);
            while (rs.next()) {

                Kategori k = this.getKategoriDao().findById(rs.getInt("kategori_id"));

                c = new Kitap(rs.getInt("kitap_id"), rs.getString("ad"), rs.getInt("sayfaSayisi"), k, rs.getString("kitapKapagi"),this.getKitapYazar(rs.getInt("id")));
            }

        } catch (Exception e) {
            System.out.println("kitap findbyId"+e.getMessage());
        }
        return c;
    }

    public KategoriDAO getKategoriDao() {
        if (kategoriDao == null) {
            this.kategoriDao = new KategoriDAO();
        }
        return kategoriDao;
    }

    public void setKategoriDao(KategoriDAO kategoriDao) {
        this.kategoriDao = kategoriDao;
    }

}
