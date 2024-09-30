package com.api.nodemcu.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import com.api.nodemcu.model.politicaJfaModel;

public interface  politicaJfaRepository extends JpaRepository<politicaJfaModel , Integer>{
    @Override
    List<politicaJfaModel> findAll();

    @Override
    <S extends politicaJfaModel> S save(S entity);

    @Modifying
    @Query("DELETE FROM politicaJfaModel")
    void deleteAll();
    
}
