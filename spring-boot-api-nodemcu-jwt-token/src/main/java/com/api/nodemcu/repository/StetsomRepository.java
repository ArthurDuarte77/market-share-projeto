package com.api.nodemcu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.api.nodemcu.model.StetsomModel;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface StetsomRepository extends JpaRepository<StetsomModel, Integer> {

    @Override
    List<StetsomModel> findAll();

    @Override
    <S extends StetsomModel> S save(S entity);

    List<StetsomModel> findByDate(Date date);

    @Query("SELECT j FROM StetsomModel j WHERE j.seller = :seller")
    List<StetsomModel> findBySeller(@Param("seller") String seller);

    @Query("SELECT j FROM StetsomModel j WHERE j.product = :product")
    List<StetsomModel> findByProduct(@Param("product") String product);

    @Query("SELECT j FROM StetsomModel j WHERE j.date BETWEEN :startDate AND :endDate")
    List<StetsomModel> findByDateRange(@Param("startDate") Date startDate, @Param("endDate") Date endDate);

    @Query(value = "SELECT model, SUM(quantity), SUM(total) AS total_quantidade FROM stetsom WHERE date BETWEEN :startDate AND :endDate GROUP BY model", nativeQuery = true)
    List<Object[]> findByDateRangeGroupedByModel(@Param("startDate") Date startDate, @Param("endDate") Date endDate);

    @Query(value = "SELECT t1.model, t1.total_quantidade AS quantidade_dia1, t2.total_quantidade AS quantidade_dia2, (t2.total_quantidade - t1.total_quantidade) AS diferenca FROM (SELECT model, SUM(quantity) AS total_quantidade FROM stetsom WHERE date = :data1 GROUP BY model) AS t1 LEFT JOIN (SELECT model, SUM(quantity) AS total_quantidade FROM stetsom WHERE date = :data2 GROUP BY model) AS t2 ON t1.model = t2.model ORDER BY diferenca DESC;", nativeQuery = true)
    List<Object[]> compararQuantidadesPorModelo(@Param("data1") Date data1, @Param("data2") Date data2);
    
    @Query(value = "SELECT DATE(date) AS dia, SUM(quantity) AS total_quantidade FROM stetsom WHERE date BETWEEN :data1 AND :data2 AND model LIKE '%FONTE%' GROUP BY DATE(date) ORDER BY dia;", nativeQuery = true)
    List<Object[]> findQuantitiesByDateRangeFonte(@Param("data1") Date data1, @Param("data2") Date data2);
    
    @Query(value = "SELECT DATE(date) AS dia, SUM(quantity) AS total_quantidade FROM stetsom WHERE date BETWEEN :data1 AND :data2 AND model LIKE '%CONTROLE%' GROUP BY DATE(date) ORDER BY dia;", nativeQuery = true)
    List<Object[]> findQuantitiesByDateRangeControle(@Param("data1") Date data1, @Param("data2") Date data2);
}
