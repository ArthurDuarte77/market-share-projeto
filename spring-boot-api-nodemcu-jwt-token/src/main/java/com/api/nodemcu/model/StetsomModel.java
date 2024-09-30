package com.api.nodemcu.model;

import java.math.BigDecimal;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.TimeZone;


@Entity
@Data
@Table(name = "stetsom")
public class StetsomModel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    private String seller;
    private String product;
    private String brand;
    private boolean free_shipping;
    private int quantity;
    
    @Column(precision = 10, scale = 2)
    private BigDecimal unit_price;
    
    @Column(precision = 10, scale = 2)
    private BigDecimal total;
    
    private String model;
    
    private Date date;

    @PrePersist
    protected void prePersist() {
        if (this.date == null) {
            TimeZone.setDefault(TimeZone.getTimeZone("America/Sao_Paulo"));
            date = new Date(System.currentTimeMillis());
        }
    }
}