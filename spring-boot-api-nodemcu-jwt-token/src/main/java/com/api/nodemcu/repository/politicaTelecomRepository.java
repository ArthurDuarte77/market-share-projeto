package com.api.nodemcu.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import com.api.nodemcu.model.politicaTelecomModel;

public interface politicaTelecomRepository extends JpaRepository<politicaTelecomModel , Integer>{
    
    @Override
    List<politicaTelecomModel> findAll();

    @Override
    <S extends politicaTelecomModel> S save(S entity);

    @Modifying
    @Query("DELETE FROM politicaTelecomModel")
    void deleteAll();
    
}
