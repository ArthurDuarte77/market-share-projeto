package com.api.nodemcu.controllers;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.api.nodemcu.model.TarampsModel;
import com.api.nodemcu.repository.TarampsRepository;
@RestController
@RequestMapping("/api/v1/taramps")
public class TarampsController {

    @Autowired
    private TarampsRepository tarampsRepository;

    @GetMapping
    public ResponseEntity<List<TarampsModel>> listarTodos() {
        List<TarampsModel> jfas = tarampsRepository.findAll();
        return ResponseEntity.ok(jfas);
    }

    @PostMapping()
    public ResponseEntity<TarampsModel> criarRegistro(@RequestBody TarampsModel novoRegistro) {
        TarampsModel registroSalvo = tarampsRepository.save(novoRegistro);
        return ResponseEntity.ok(registroSalvo);
    }

    @GetMapping("/por-data")
    public ResponseEntity<List<TarampsModel>> buscarPorData(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date data) {
        List<TarampsModel> jfa = tarampsRepository.findByDate(data);
        if (jfa != null) {
            return ResponseEntity.ok(jfa);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/por-vendedor")
    public ResponseEntity<List<TarampsModel>> buscarPorVendedor(@RequestParam String vendedor) {
        List<TarampsModel> jfas = tarampsRepository.findBySeller(vendedor);
        return ResponseEntity.ok(jfas);
    }

    @GetMapping("/por-produto")
    public ResponseEntity<List<TarampsModel>> buscarPorProduto(@RequestParam String produto) {
        List<TarampsModel> jfas = tarampsRepository.findByProduct(produto);
        return ResponseEntity.ok(jfas);
    }

    @GetMapping("/por-intervalo-data")
    public ResponseEntity<List<TarampsModel>> buscarPorIntervaloDeDatas(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date dataInicio,
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date dataFim) {
        List<TarampsModel> jfas = tarampsRepository.findByDateRange(dataInicio, dataFim);
        return ResponseEntity.ok(jfas);
    }

    @GetMapping("/get-by-date-range-grouped-by-model")
    public ResponseEntity<List<Map<String, Object>>> getByDateRangeGroupedByModel(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date dataInicio,
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date dataFim) {
        List<Object[]> jfas = tarampsRepository.findByDateRangeGroupedByModel(dataInicio, dataFim);
        List<Map<String, Object>> resultado = new ArrayList<>();
        
        for (Object[] obj : jfas) {
            String familia = obj[0].toString();
            if (!familia.equals("OUTROS")) {
                Map<String, Object> item = new HashMap<>();
                item.put("familia", familia);
                item.put("quantidade", ((Number)obj[1]).intValue());
                item.put("valor", ((Number)obj[2]).doubleValue());
                resultado.add(item);
            }
        }
        
        return ResponseEntity.ok(resultado);
    }

    @GetMapping("/market-share")
    public ResponseEntity<List<Map<String, Object>>> marketShare(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date dataInicio,
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date dataFim) {
        List<Object[]> jfas = tarampsRepository.findByDateRangeGroupedByModel(dataInicio, dataFim);
        
        Map<String, Map<String, Object>> resultado = new HashMap<>();
        resultado.put("FONTES", new HashMap<String, Object>() {{
            put("familia", "FONTE");
            put("quantidade", 0);
            put("valor", 0.0);
        }});
        resultado.put("CONTROLE", new HashMap<String, Object>() {{
            put("familia", "CONTROLE");
            put("quantidade", 0);
            put("valor", 0.0);
        }});
        
        for (Object[] obj : jfas) {
            String familia = obj[0].toString();
            if (familia.contains("FONTE")) {
                familia = "FONTES";
            } else if (familia.contains("CONTROLE")) {
                familia = "CONTROLE";
            } else {
                continue; // Pula para a próxima iteração se não for FONTE nem CONTROLE
            }

            resultado.computeIfAbsent(familia, k -> new HashMap<String, Object>() {
                {
                    put("familia", k);
                    put("quantidade", 0);
                    put("valor", 0.0);
                }
            });

            Map<String, Object> item = resultado.get(familia);
            item.put("quantidade", (int) item.get("quantidade") + ((Number) obj[1]).intValue());
            item.put("valor", (double) item.get("valor") + ((Number) obj[2]).doubleValue());
        }
        return ResponseEntity.ok(new ArrayList<>(resultado.values()));
    }

    @GetMapping("/comparar-quantidades")
    public ResponseEntity<List<Object[]>> compararQuantidades(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date data1,
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date data2) {
        List<Object[]> resultado = tarampsRepository.compararQuantidadesPorModelo(data1, data2);
        System.out.println(resultado);
        return ResponseEntity.ok(resultado);
    }
    
    @GetMapping("/quantidades-por-intervalo")
    public ResponseEntity<List<Map<String, Object>>> findQuantitiesByDateRange(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date dataInicio,
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date dataFim) {
        List<Object[]> resultado = tarampsRepository.findQuantitiesByDateRangeFonte(dataInicio, dataFim);
        List<Map<String, Object>> response = new ArrayList<>();
        
        for (Object[] obj : resultado) {
            String familia = obj[0].toString();
            if (!familia.equals("OUTROS")) {
            Map<String, Object> item = new HashMap<>();
            item.put("date", obj[0].toString());
            item.put("quantity", ((Number)obj[1]).intValue());
            response.add(item);
            }
        }
        
        return ResponseEntity.ok(response);
    }

}
