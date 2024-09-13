package com.api.nodemcu.controllers;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.api.nodemcu.model.JfaModel;
import com.api.nodemcu.repository.JfaRepository;


@RestController
@RequestMapping("/api/v1/jfa")
public class JfaController {


    @Autowired
    private JfaRepository jfaRepository;

    @GetMapping
    public ResponseEntity<List<JfaModel>> listarTodos() {
        List<JfaModel> jfas = jfaRepository.findAll();
        return ResponseEntity.ok(jfas);
    }

    @PostMapping()
    public ResponseEntity<JfaModel> criarRegistro(@RequestBody JfaModel novoRegistro) {
        JfaModel registroSalvo = jfaRepository.save(novoRegistro);
        return ResponseEntity.ok(registroSalvo);
    }

    @GetMapping("/por-data")
    public ResponseEntity<List<JfaModel>> buscarPorData(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date data) {
        List<JfaModel> jfa = jfaRepository.findByDate(data);
        if (jfa != null) {
            return ResponseEntity.ok(jfa);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/por-vendedor")
    public ResponseEntity<List<JfaModel>> buscarPorVendedor(@RequestParam String vendedor) {
        List<JfaModel> jfas = jfaRepository.findBySeller(vendedor);
        return ResponseEntity.ok(jfas);
    }

    @GetMapping("/por-produto")
    public ResponseEntity<List<JfaModel>> buscarPorProduto(@RequestParam String produto) {
        List<JfaModel> jfas = jfaRepository.findByProduct(produto);
        return ResponseEntity.ok(jfas);
    }

    @GetMapping("/por-intervalo-data")
    public ResponseEntity<List<JfaModel>> buscarPorIntervaloDeDatas(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date dataInicio,
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date dataFim) {
        List<JfaModel> jfas = jfaRepository.findByDateRange(dataInicio, dataFim);
        return ResponseEntity.ok(jfas);
    }


}
