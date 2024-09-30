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

import com.api.nodemcu.model.politicaJfaModel;
import com.api.nodemcu.repository.politicaJfaRepository;

@RestController
@RequestMapping("/api/v1/politica-jfa")
public class politicaJfaController {

    @Autowired
    private politicaJfaRepository politicaJfaRepository;

    @GetMapping
    public ResponseEntity<List<politicaJfaModel>> listarTodos() {
        List<politicaJfaModel> jfas = politicaJfaRepository.findAll();
        return ResponseEntity.ok(jfas);
    }

    @PostMapping()
    public ResponseEntity<politicaJfaModel> criarRegistro(@RequestBody politicaJfaModel novoRegistro) {
        politicaJfaModel registroSalvo = politicaJfaRepository.save(novoRegistro);
        return ResponseEntity.ok(registroSalvo);
    }

    @DeleteMapping("/deletar-todos")
    public ResponseEntity<Void> deletarTodos() {
        politicaJfaRepository.deleteAll();
        return ResponseEntity.ok().build();
    }
}
