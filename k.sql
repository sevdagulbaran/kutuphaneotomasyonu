PGDMP         4                z            StajTakipSistemi    13.4    13.4 5               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            	           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            
           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    33113    StajTakipSistemi    DATABASE     o   CREATE DATABASE "StajTakipSistemi" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Turkish_Turkey.1254';
 "   DROP DATABASE "StajTakipSistemi";
                postgres    false            �            1255    33328    get_defter(integer, integer)    FUNCTION     $  CREATE FUNCTION public.get_defter(no1 integer, no2 integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
   defter_sayisi integer;
begin
   select count(*) 
   into defter_sayisi
   from stajdefteri
   where stajdefteri_id between no1 and no2;
   
   return defter_sayisi;
end;
$$;
 ;   DROP FUNCTION public.get_defter(no1 integer, no2 integer);
       public          postgres    false            �            1255    33319    get_mulakat(date, date)    FUNCTION     "  CREATE FUNCTION public.get_mulakat(trh1 date, trh2 date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
   mulakat_sayisi integer;
begin
   select count(*) 
   into mulakat_sayisi
   from mulakat
   where mulakat_tarihi between trh1 and trh2;
   
   return mulakat_sayisi;
end;
$$;
 8   DROP FUNCTION public.get_mulakat(trh1 date, trh2 date);
       public          postgres    false            �            1255    33246    soyad_degistir()    FUNCTION     !  CREATE FUNCTION public.soyad_degistir() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW.ogrenci_soyad <> OLD.ogrenci_soyad THEN
		INSERT INTO ogrenci_degisen(ogrenci_no,ogrenci_soyad,changed_on)
		VALUES(OLD.ogrenci_no,OLD.ogrenci_soyad,now());
	END IF;
	RETURN NEW;
END;
$$;
 '   DROP FUNCTION public.soyad_degistir();
       public          postgres    false            �            1259    33124 	   departman    TABLE     �   CREATE TABLE public.departman (
    departman_id integer NOT NULL,
    departman_adi character varying(50),
    departman_lokasyon character varying(50),
    calisan_sayisi integer,
    telefon character varying
);
    DROP TABLE public.departman;
       public         heap    postgres    false            �            1259    33299    departman_iletisim    TABLE     �   CREATE TABLE public.departman_iletisim (
    departman_iletisim_id integer NOT NULL,
    departman_id integer,
    telefon character varying(15),
    email character varying(100)
);
 &   DROP TABLE public.departman_iletisim;
       public         heap    postgres    false            �            1259    33297 ,   departman_iletisim_departman_iletisim_id_seq    SEQUENCE       ALTER TABLE public.departman_iletisim ALTER COLUMN departman_iletisim_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.departman_iletisim_departman_iletisim_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    213            �            1259    33212    mulakat    TABLE     �   CREATE TABLE public.mulakat (
    ogrenci_no integer,
    ogrenci_ad character varying(30),
    ogrenci_soyad character varying(30),
    mulakat_yeri character varying(50),
    mulakat_tarihi date,
    mulakat_saati time without time zone
);
    DROP TABLE public.mulakat;
       public         heap    postgres    false            �            1259    33174    ogrenci    TABLE     ~  CREATE TABLE public.ogrenci (
    ogrenci_no integer NOT NULL,
    ogrenci_ad character varying(30),
    ogrenci_soyad character varying(30),
    ogrenci_bolum character varying(30),
    "ogrenci_sınıf" integer,
    ogrenci_telefon character varying(11),
    ogrenci_mail character varying(30),
    ogrenci_sehir character varying(20),
    ogrenci_adres character varying(100)
);
    DROP TABLE public.ogrenci;
       public         heap    postgres    false            �            1259    33251    ogrenci_degisen    TABLE     �   CREATE TABLE public.ogrenci_degisen (
    id integer NOT NULL,
    ogrenci_no integer NOT NULL,
    ogrenci_soyad character varying(40) NOT NULL,
    changed_on timestamp(6) without time zone NOT NULL
);
 #   DROP TABLE public.ogrenci_degisen;
       public         heap    postgres    false            �            1259    33249    ogrenci_degisen_id_seq    SEQUENCE     �   ALTER TABLE public.ogrenci_degisen ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ogrenci_degisen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    211            �            1259    33228    stajbasvurusu    TABLE     �   CREATE TABLE public.stajbasvurusu (
    ogrenci_no integer,
    sirket_id integer,
    ogrenci_ad character varying(30),
    ogrenci_soyad character varying(30),
    ogrenci_mail character varying(30),
    ogrenci_telefon character varying(11)
);
 !   DROP TABLE public.stajbasvurusu;
       public         heap    postgres    false            �            1259    33329    ogrenci_staj    VIEW     �  CREATE VIEW public.ogrenci_staj AS
 SELECT o.ogrenci_no AS id,
    (((o.ogrenci_ad)::text || ' '::text) || (o.ogrenci_soyad)::text) AS name,
    o.ogrenci_bolum,
    o."ogrenci_sınıf",
    o.ogrenci_telefon,
    stajbasvurusu.sirket_id,
        CASE
            WHEN (o."ogrenci_sınıf" = 3) THEN 'üçüncü sınıf'::text
            ELSE ''::text
        END AS "sınıf",
    stajbasvurusu.sirket_id AS sid
   FROM (public.ogrenci o
     JOIN public.stajbasvurusu USING (ogrenci_mail));
    DROP VIEW public.ogrenci_staj;
       public          postgres    false    209    204    204    209    204    204    204    204    204            �            1259    33134    ogretmen    TABLE     �  CREATE TABLE public.ogretmen (
    ogretmen_id integer NOT NULL,
    ogretmen_ad character varying(30),
    ogretmen_soyad character varying(30),
    ogretmen_bolum character varying(50),
    ogretmen_unvan character varying(20),
    ogretmen_mail character varying(30),
    ogretmen_telefon character varying(11),
    ogretmen_sehir character varying(20),
    ogretmen_adres character varying(100)
);
    DROP TABLE public.ogretmen;
       public         heap    postgres    false            �            1259    33220    ogretmenyorum    TABLE     �   CREATE TABLE public.ogretmenyorum (
    ogrenci_no integer,
    ogrenci_ad character varying(30),
    ogrenci_soyad character varying(30),
    stajdefteri_degerlendirme character varying(100)
);
 !   DROP TABLE public.ogretmenyorum;
       public         heap    postgres    false            �            1259    33119    okul    TABLE     �   CREATE TABLE public.okul (
    okul_id integer NOT NULL,
    okul_adi character varying(50),
    okul_sehir character varying(20),
    okul_adres character varying(100),
    okul_telefon character varying(11),
    okul_mail character varying(30)
);
    DROP TABLE public.okul;
       public         heap    postgres    false            �            1259    33114    sirket    TABLE     1  CREATE TABLE public.sirket (
    sirket_id integer NOT NULL,
    sirket_isim character varying(30),
    sirket_sehir character varying(20),
    sirket_adres character varying(100),
    sirket_sahibi character varying(50),
    sirket_telefon character varying(11),
    sirket_mail character varying(30)
);
    DROP TABLE public.sirket;
       public         heap    postgres    false            �            1259    33204    sirketyorumu    TABLE     �   CREATE TABLE public.sirketyorumu (
    ogrenci_no integer,
    ogrenci_ad character varying(30),
    ogrenci_soyad character varying(30),
    ogrenci_degerlendirme character varying(100),
    sirket_isim character varying
);
     DROP TABLE public.sirketyorumu;
       public         heap    postgres    false            �            1259    33179    stajdefteri    TABLE     �   CREATE TABLE public.stajdefteri (
    stajdefteri_id integer NOT NULL,
    stajbitis_tarihi date,
    stajbaslama_tarihi date,
    ogrenci_no integer,
    ogretmen_id integer
);
    DROP TABLE public.stajdefteri;
       public         heap    postgres    false            �            1259    33367    yorum    VIEW     �  CREATE VIEW public.yorum AS
 SELECT s.sirket_id AS id,
    s.sirket_isim AS name,
    s.sirket_adres,
    s.sirket_sehir,
    s.sirket_mail,
    sirketyorumu.ogrenci_degerlendirme,
        CASE
            WHEN ((s.sirket_sehir)::text = 'İstanbul'::text) THEN 'istanbulda bulunan şirketler'::text
            ELSE ''::text
        END AS list,
    sirketyorumu.ogrenci_no AS oid
   FROM (public.sirket s
     JOIN public.sirketyorumu USING (sirket_isim));
    DROP VIEW public.yorum;
       public          postgres    false    206    206    200    200    200    200    200    206            �          0    33124 	   departman 
   TABLE DATA           m   COPY public.departman (departman_id, departman_adi, departman_lokasyon, calisan_sayisi, telefon) FROM stdin;
    public          postgres    false    202   �J                 0    33299    departman_iletisim 
   TABLE DATA           a   COPY public.departman_iletisim (departman_iletisim_id, departman_id, telefon, email) FROM stdin;
    public          postgres    false    213   {K       �          0    33212    mulakat 
   TABLE DATA           u   COPY public.mulakat (ogrenci_no, ogrenci_ad, ogrenci_soyad, mulakat_yeri, mulakat_tarihi, mulakat_saati) FROM stdin;
    public          postgres    false    207   �K       �          0    33174    ogrenci 
   TABLE DATA           �   COPY public.ogrenci (ogrenci_no, ogrenci_ad, ogrenci_soyad, ogrenci_bolum, "ogrenci_sınıf", ogrenci_telefon, ogrenci_mail, ogrenci_sehir, ogrenci_adres) FROM stdin;
    public          postgres    false    204   xL                 0    33251    ogrenci_degisen 
   TABLE DATA           T   COPY public.ogrenci_degisen (id, ogrenci_no, ogrenci_soyad, changed_on) FROM stdin;
    public          postgres    false    211   N       �          0    33134    ogretmen 
   TABLE DATA           �   COPY public.ogretmen (ogretmen_id, ogretmen_ad, ogretmen_soyad, ogretmen_bolum, ogretmen_unvan, ogretmen_mail, ogretmen_telefon, ogretmen_sehir, ogretmen_adres) FROM stdin;
    public          postgres    false    203   \N                  0    33220    ogretmenyorum 
   TABLE DATA           i   COPY public.ogretmenyorum (ogrenci_no, ogrenci_ad, ogrenci_soyad, stajdefteri_degerlendirme) FROM stdin;
    public          postgres    false    208   �O       �          0    33119    okul 
   TABLE DATA           b   COPY public.okul (okul_id, okul_adi, okul_sehir, okul_adres, okul_telefon, okul_mail) FROM stdin;
    public          postgres    false    201   Q       �          0    33114    sirket 
   TABLE DATA           �   COPY public.sirket (sirket_id, sirket_isim, sirket_sehir, sirket_adres, sirket_sahibi, sirket_telefon, sirket_mail) FROM stdin;
    public          postgres    false    200    R       �          0    33204    sirketyorumu 
   TABLE DATA           q   COPY public.sirketyorumu (ogrenci_no, ogrenci_ad, ogrenci_soyad, ogrenci_degerlendirme, sirket_isim) FROM stdin;
    public          postgres    false    206   T                 0    33228    stajbasvurusu 
   TABLE DATA           x   COPY public.stajbasvurusu (ogrenci_no, sirket_id, ogrenci_ad, ogrenci_soyad, ogrenci_mail, ogrenci_telefon) FROM stdin;
    public          postgres    false    209   NU       �          0    33179    stajdefteri 
   TABLE DATA           t   COPY public.stajdefteri (stajdefteri_id, stajbitis_tarihi, stajbaslama_tarihi, ogrenci_no, ogretmen_id) FROM stdin;
    public          postgres    false    205   2V                  0    0 ,   departman_iletisim_departman_iletisim_id_seq    SEQUENCE SET     Z   SELECT pg_catalog.setval('public.departman_iletisim_departman_iletisim_id_seq', 1, true);
          public          postgres    false    212                       0    0    ogrenci_degisen_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.ogrenci_degisen_id_seq', 1, true);
          public          postgres    false    210            j           2606    33303 *   departman_iletisim departman_iletisim_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.departman_iletisim
    ADD CONSTRAINT departman_iletisim_pkey PRIMARY KEY (departman_iletisim_id);
 T   ALTER TABLE ONLY public.departman_iletisim DROP CONSTRAINT departman_iletisim_pkey;
       public            postgres    false    213            b           2606    33128    departman departman_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.departman
    ADD CONSTRAINT departman_pkey PRIMARY KEY (departman_id);
 B   ALTER TABLE ONLY public.departman DROP CONSTRAINT departman_pkey;
       public            postgres    false    202            f           2606    33178    ogrenci ogrenci_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.ogrenci
    ADD CONSTRAINT ogrenci_pkey PRIMARY KEY (ogrenci_no);
 >   ALTER TABLE ONLY public.ogrenci DROP CONSTRAINT ogrenci_pkey;
       public            postgres    false    204            d           2606    33138    ogretmen ogretmen_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.ogretmen
    ADD CONSTRAINT ogretmen_pkey PRIMARY KEY (ogretmen_id);
 @   ALTER TABLE ONLY public.ogretmen DROP CONSTRAINT ogretmen_pkey;
       public            postgres    false    203            `           2606    33123    okul okul_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.okul
    ADD CONSTRAINT okul_pkey PRIMARY KEY (okul_id);
 8   ALTER TABLE ONLY public.okul DROP CONSTRAINT okul_pkey;
       public            postgres    false    201            ^           2606    33118    sirket sirket_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.sirket
    ADD CONSTRAINT sirket_pkey PRIMARY KEY (sirket_id);
 <   ALTER TABLE ONLY public.sirket DROP CONSTRAINT sirket_pkey;
       public            postgres    false    200            h           2606    33183    stajdefteri stajdefteri_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.stajdefteri
    ADD CONSTRAINT stajdefteri_pkey PRIMARY KEY (stajdefteri_id);
 F   ALTER TABLE ONLY public.stajdefteri DROP CONSTRAINT stajdefteri_pkey;
       public            postgres    false    205            s           2620    33247    ogrenci ogrenci_soyad_degisim    TRIGGER     |   CREATE TRIGGER ogrenci_soyad_degisim BEFORE UPDATE ON public.ogrenci FOR EACH ROW EXECUTE FUNCTION public.soyad_degistir();
 6   DROP TRIGGER ogrenci_soyad_degisim ON public.ogrenci;
       public          postgres    false    216    204            r           2606    33304    departman_iletisim fk_departman    FK CONSTRAINT     �   ALTER TABLE ONLY public.departman_iletisim
    ADD CONSTRAINT fk_departman FOREIGN KEY (departman_id) REFERENCES public.departman(departman_id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.departman_iletisim DROP CONSTRAINT fk_departman;
       public          postgres    false    213    202    2914            n           2606    33215    mulakat mulakat_ogrenci_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mulakat
    ADD CONSTRAINT mulakat_ogrenci_no_fkey FOREIGN KEY (ogrenci_no) REFERENCES public.ogrenci(ogrenci_no);
 I   ALTER TABLE ONLY public.mulakat DROP CONSTRAINT mulakat_ogrenci_no_fkey;
       public          postgres    false    2918    207    204            o           2606    33223 +   ogretmenyorum ogretmenyorum_ogrenci_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ogretmenyorum
    ADD CONSTRAINT ogretmenyorum_ogrenci_no_fkey FOREIGN KEY (ogrenci_no) REFERENCES public.ogrenci(ogrenci_no);
 U   ALTER TABLE ONLY public.ogretmenyorum DROP CONSTRAINT ogretmenyorum_ogrenci_no_fkey;
       public          postgres    false    208    2918    204            m           2606    33207 )   sirketyorumu sirketyorumu_ogrenci_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.sirketyorumu
    ADD CONSTRAINT sirketyorumu_ogrenci_no_fkey FOREIGN KEY (ogrenci_no) REFERENCES public.ogrenci(ogrenci_no);
 S   ALTER TABLE ONLY public.sirketyorumu DROP CONSTRAINT sirketyorumu_ogrenci_no_fkey;
       public          postgres    false    204    206    2918            p           2606    33231 +   stajbasvurusu stajbasvurusu_ogrenci_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.stajbasvurusu
    ADD CONSTRAINT stajbasvurusu_ogrenci_no_fkey FOREIGN KEY (ogrenci_no) REFERENCES public.ogrenci(ogrenci_no);
 U   ALTER TABLE ONLY public.stajbasvurusu DROP CONSTRAINT stajbasvurusu_ogrenci_no_fkey;
       public          postgres    false    209    204    2918            q           2606    33236 *   stajbasvurusu stajbasvurusu_sirket_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.stajbasvurusu
    ADD CONSTRAINT stajbasvurusu_sirket_id_fkey FOREIGN KEY (sirket_id) REFERENCES public.sirket(sirket_id);
 T   ALTER TABLE ONLY public.stajbasvurusu DROP CONSTRAINT stajbasvurusu_sirket_id_fkey;
       public          postgres    false    2910    200    209            k           2606    33184 '   stajdefteri stajdefteri_ogrenci_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.stajdefteri
    ADD CONSTRAINT stajdefteri_ogrenci_no_fkey FOREIGN KEY (ogrenci_no) REFERENCES public.ogrenci(ogrenci_no);
 Q   ALTER TABLE ONLY public.stajdefteri DROP CONSTRAINT stajdefteri_ogrenci_no_fkey;
       public          postgres    false    205    204    2918            l           2606    33189 (   stajdefteri stajdefteri_ogretmen_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.stajdefteri
    ADD CONSTRAINT stajdefteri_ogretmen_id_fkey FOREIGN KEY (ogretmen_id) REFERENCES public.ogretmen(ogretmen_id);
 R   ALTER TABLE ONLY public.stajdefteri DROP CONSTRAINT stajdefteri_ogretmen_id_fkey;
       public          postgres    false    203    2916    205            �   �   x��1
1D��)$��O��&e��t�j�&H���-�b�A<�؋���i�1�aؾK]�9�#,yk�5����Lb�H��I7�ЗwiS���3�)1Y�����:�����C����|�ݵ���D>	�2!���Q*Ys;c~л'w            x������ � �      �   �   x��н�0���2�NI�H�H@���";(�l@KIK��+�>HW?z��"�����V�|� �4G4�V�F��ޒ��Y]�{�	rx�1�/��L���daڼT󠮎h�(��N2��z�	��^��#$���3���%�?bp�S�i��U�c�]��!�!kk���8���s֮�%^�X�{d&Zg���[��      �   �  x�m��n�0���S�j�)Q��4n�NgI��Z��P� �@� ���^:y��^��&p�.A��wߏ,�/�<\��u��`�KWZ���rQd��D��G�hQ�ŏ�¹�Ѵ_�V�W������~�&^�zߖ��eY�ʐ��Ƣ�k��Ny2J�D�\�x�f���m����{%��I�����~��;��U:��
���A��IE�$��X{¹@3�5U��Gr�jlq����T�p�;��giP�2�2���K�&�4{��mE'���}�!�9��h�>by!�S�u�m�VX��:(�/C究���K��0.`;u�@�h�����׍i�ݛ+"���u�w�u�̣����W���FU3$����<��ZN K�k|c�����"��?�|ɐ         5   x�3�4426�q�s�4202�54�5�T04�20�26�346656����� ��V      �   z  x�U�;N�@���)r"ٱ��
Q"��@�D3����ai�A
����%��{1k0
�>f���8�zuOp�����V�׶f�Qm��w��`�|2=U)Xw/Oh�z�8���ȳ4������6���������q����n.6�aAV�p^6��<l�Q�{�(�1,�+�`�+�F`epE�%��8`�KWZ������;�x��{z1�Y>Jb	}�42B��b�O�D�k���!-l}��(][���ve=7�&�B���`W��nKЩDO�x�)��9���Ph��p��*������<az�Z��h�]PQ����2��9�*�*i���kMn���oBq/���(�Y���*�i<��8�n�Q}�B�h            x�e�=N�@F��)���A�@CD3�3�O�zɾ 7�uI�&���b���������Tm�r���V��u�}��kM��t�r5���پ����A2O�*�Y��:u|'u���] �.#H�o������e?D��O��\���!_��r�(@����!k�FXOXw�7�l��M2��Fj͆�Z��V<���!2��\�Έ``�Ɗ��,&�ŝ$���I��5��#W��G�L�'tZ��Y�3Q�|�PW�ע�A+	�V�
�(� $�$I>_ݝ�      �   �   x�e�AN�0EדS��`;)�hQ�!�l���VWr�J�Y�r�a�]̽p���������#SX�ޒ���胲�v�ְ*�����d=��!F�p~����"�X(x��|��}�l$d
�"WF�g��qT6O�7d7���O�β��Z�L�����DO��@�� d	V�эrX�/U��
7|�r8�n8�L�U��9>�n��8�����@�l�<�Q;2�}yf����j��9L�L���m�ŘdD�_�}��(����      �   �  x�m����0���)���IBz"˶T��+A+U�e������6H�AzZ�WX.=qK�^ul�Л������$�\ZT$S$߹%�(%��p�\.��o��%�O#J�rj�[���"����:'͋u�V;I�u	K^(Q@��Ğ+��V��Xn볭�]�.�rd�+#`R�.J�$7�B8�	���P=�Wd��e+���P��|֒	���ki�o��8�(������;o�Xf���32�Ϟ�#���0J)M)����h���d�g�����~��p焂)7���#cms�!z�$	!�n�D�/���϶���_�{�yɝ�l�c�II4�]2��(�W;\�N��Kɽ6J����;�	��ޱ*�!S��SɄ�|1,�'�7<� w�`�A��p	c�ts,w���dR�/�������3�cto���N�-�;���M�+�ĥ�տ����6�0�$�d�t�=*p+����^�/C"�_      �   ,  x�u�;N�@���)���N�H:@C�f�c�����F�/�h]�vC�n��bm#��V��f���w<��َJMv�	�n�}w�!��� ���5�5��m��5�{smM�ˈ G�J�rM[�1l��|�A������=iI���D����,nFk�d���c��7�jx&�C�	�TÕ�=r��XLؖKl[(ԗ��ă7#dg��z�"N�ԏ`����^�W�0�SC��k~�=!�׾���]�u�P�S����K'�u���g�V��a�3~�X��a��G���(�O��4         �   x�M�=N1����D{��vD
�K�h�h,pP�v6
J�{n�6%u.��^8��܌�I��!m����O���#�Iܽ�M��.�;�Ɗg+��4�O9����+�+��]�=�cY���ئ�bq�a���_�Z���_�"��X�M��^R����
am� �@��?��K�E�?b�����\���p<�e�*�t�`3����kbQ/3��/f�W�      �   e   x�E��0C�x* �K�����ۓe?g��)K����G�夎��\L6!]���P�	�4�(��r}�#���7�_!�pPW%<F;�f;��s��� ���".     