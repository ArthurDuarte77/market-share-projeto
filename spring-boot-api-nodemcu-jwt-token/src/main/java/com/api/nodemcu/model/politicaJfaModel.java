package com.api.nodemcu.model;

import java.math.BigDecimal;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.TimeZone;



@Entity
@Data
@Table(name = "politica_jfa")
public class politicaJfaModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String image;

    private String model;

    private String seller;

    private String title;

    @Column(precision = 10, scale = 2)
    private BigDecimal price;

    @Column(precision = 10, scale = 2)
    private BigDecimal predicted_price;

    private String listing_type;

    private String link;
}
