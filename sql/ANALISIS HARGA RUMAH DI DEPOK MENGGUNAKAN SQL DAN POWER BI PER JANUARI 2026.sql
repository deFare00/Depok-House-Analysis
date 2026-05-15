/* ANALISIS HARGA RUMAH DI DEPOK MENGGUNAKAN SQL DAN POWER BI PER JANUARI 2026 */

CREATE DATABASE depok_house_analysis;
USE depok_house_analysis;
DESCRIBE cleaned_final_rumah;
select * from cleaned_final_rumah;

/* Analisis 1 - Statistik Dasar
Tampilkan:
1. Rata-rata Harga = 1.039.065.592,91
2. Harga Tertinggi = 2.140.000.000
3. Harga Terendah = 1.030.000
4. Total Listing Rumah = 16267
*/

SELECT
	avg(harga) as rata_rata_harga,
    max(harga) as harga_tertinggi,
    min(harga) as harga_terendah,
    count(*) as total_listing
FROM cleaned_final_rumah;

/* Analisis 2 - 5 Lokasi Termahal
Tujuan = Mengetahui area premium di Depok
1. Pangkalan Jati = 1.597.864.583
2. Cinere = 1.465.800.114
3. Gandul = 1.457.449.583
4. Cibubur = 1.299.471.921
5. Harjamukti = 1.270.747.410
*/

SELECT lokasi, avg(harga) AS rata_rata_harga
FROM cleaned_final_rumah GROUP BY lokasi ORDER BY rata_rata_harga DESC LIMIT 5;

/* Analisis 3 - Harga per Meter Persegi
Tujuan = Menentukan area dengan harga m2 tertinggi
Formula = Harga per m2 = Harga/Luas Bangunan
1. Tapos = 15.814.136
2. Pangkalan Jati = 15.018.405
3. Cinere = 14.184.448
4. Kukusan = 13.722.307
5. Kelapa Dua = 13.485.711
*/

SELECT lokasi, ROUND(AVG(harga/`Luas Bangunan`), 2) AS harga_per_meter from cleaned_final_rumah
GROUP BY lokasi ORDER BY harga_per_meter DESC LIMIT 5;

/* Analisis 4 - Pengaruh Jumlah Kamar
Hitung rata-rata harga berdasarkan jumlah kamar tidur
KT 1 = 794.680.322
KT 2 = 729.845.232
KT 3 = 1.147.947.897
KT 4 = 1.436.441.723
KT 5 = 1.480.626.345
*/

SELECT `Kamar Tidur`, AVG(harga) AS rata_rata_harga FROM cleaned_final_rumah where `Kamar Tidur` <= 5 GROUP BY `Kamar Tidur` ORDER BY `Kamar Tidur` ASC;

/* Analisis 5 - Segmentasi Rumah
<500 Juta = Murah == 2081
500 Juta - 1.5M = Menengah == 11181
> 1.5M = Mewah == 3005
*/

SELECT
    CASE
        WHEN harga < 500000000 THEN 'Murah'
        WHEN harga BETWEEN 500000000 AND 1500000000 THEN 'Menengah'
        ELSE 'Mewah'
    END AS kategori_rumah,
    
    COUNT(*) AS jumlah_rumah
FROM cleaned_final_rumah
GROUP BY kategori_rumah;

/* Analisis 6 - Rumah Paling Efisien
Cari
1. Rumah dengan harga termurah
2. Tetapi luas bangunan besar

Output
1. Cipayung Harga 385.000.000 dengan LB 660 Harga/m = 583.333
2. Cipayung Harga 395.000.000 dengan LB 484 Harga/m = 816.116
3. Depok 1 Harga 100.000.000 dengan LB 120 Harga/m = 833.333
4. Cilodong Harga 109.000.000 dengan LB 120 Harga/m = 908.333
5. Cilodong Harga 115.000.000 dengan LB 120 Harga/m = 958.333
*/

SELECT
    lokasi,
    harga,
    `Luas Bangunan`,
    `Luas Tanah`,
    `Kamar Tidur`,
    `Kamar Mandi`,
    garasi,
    ROUND(
        harga / CAST(`Luas Bangunan` AS DECIMAL(10,2)),
        0
    ) AS harga_per_meter
FROM cleaned_final_rumah WHERE `Luas Bangunan` BETWEEN 50 AND 1000 AND harga BETWEEN 100000000 AND 10000000000 ORDER BY harga_per_meter ASC LIMIT 5;

/*Analisis 7 - Lokasi dengan Rumah Terbanyak
Cari area dengan listing terbanyak */

SELECT
    lokasi,
    COUNT(*) AS total_listing
FROM cleaned_final_rumah
GROUP BY lokasi
ORDER BY total_listing DESC LIMIT 10;

/* Analisis 8 - Korelasi Sederhana
Melihat hubungan luas bangunan dengan harga */

SELECT
    lokasi,
    AVG(harga) AS rata_harga,
    AVG(`Luas Bangunan`) AS rata_luas
FROM cleaned_final_rumah WHERE `Luas Bangunan` BETWEEN 50 AND 1000 AND harga BETWEEN 100000000 AND 10000000000 GROUP BY lokasi;

/* Analisis 9 - Rumah dengan Harga Tertinggi */
SELECT * FROM cleaned_final_rumah order by harga DESC LIMIT 10;

/* Analisis 10 - Rumah dengan Harga Terendah */
SELECT * FROM cleaned_final_rumah WHERE harga > 100000000 order by harga ASC LIMIT 10;

/* Analisis 11 - Rata-rata Harga Berdasarkan Garasi */
SELECT
    garasi,

    ROUND(
        AVG(harga),
        0
    ) AS rata_rata_harga

FROM cleaned_final_rumah

WHERE
    harga BETWEEN 100000000 AND 10000000000
    AND `Luas Bangunan` BETWEEN 50 AND 1000

GROUP BY garasi

ORDER BY garasi ASC;

/* Data Clean */
SELECT *
FROM cleaned_final_rumah
WHERE
    harga BETWEEN 100000000 AND 10000000000
    AND `Luas Bangunan` BETWEEN 50 AND 1000;
    

select count(*) from cleaned_final_rumah;