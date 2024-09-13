package com.api.nodemcu.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.api.nodemcu.model.JfaModel;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface JfaRepository extends JpaRepository<JfaModel, Integer> {

    @Override
    List<JfaModel> findAll();

    @Override
    <S extends JfaModel> S save(S entity);

    List<JfaModel> findByDate(Date date);

    @Query("SELECT j FROM JfaModel j WHERE j.seller = :seller")
    List<JfaModel> findBySeller(@Param("seller") String seller);

    @Query("SELECT j FROM JfaModel j WHERE j.product = :product")
    List<JfaModel> findByProduct(@Param("product") String product);

    @Query("SELECT j FROM JfaModel j WHERE j.date BETWEEN :startDate AND :endDate")
    List<JfaModel> findByDateRange(@Param("startDate") Date startDate, @Param("endDate") Date endDate);
}
