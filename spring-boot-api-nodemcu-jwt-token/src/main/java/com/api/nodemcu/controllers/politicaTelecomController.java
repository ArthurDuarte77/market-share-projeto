package com.api.nodemcu.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.api.nodemcu.model.politicaTelecomModel;
import com.api.nodemcu.repository.politicaTelecomRepository;

@RestController
@RequestMapping("/api/v1/politica-telecom")
public class politicaTelecomController {

    @Autowired
    private politicaTelecomRepository politicaTelecomRepository;

    @GetMapping
    public ResponseEntity<List<politicaTelecomModel>> listarTodos() {
        List<politicaTelecomModel> jfas = politicaTelecomRepository.findAll();
        return ResponseEntity.ok(jfas);
    }

    @PostMapping()
    public ResponseEntity<politicaTelecomModel> criarRegistro(@RequestBody politicaTelecomModel novoRegistro) {
        politicaTelecomModel registroSalvo = politicaTelecomRepository.save(novoRegistro);
        return ResponseEntity.ok(registroSalvo);
    }

    @DeleteMapping("/deletar-todos")
    public ResponseEntity<Void> deletarTodos() {
        politicaTelecomRepository.deleteAll();
        return ResponseEntity.ok().build();
    }
}
