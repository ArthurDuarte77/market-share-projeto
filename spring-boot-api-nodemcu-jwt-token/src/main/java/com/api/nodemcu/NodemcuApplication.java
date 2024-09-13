package com.api.nodemcu;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.net.http.HttpClient;

@SpringBootApplication
public class NodemcuApplication {

	public static void main(String[] args) {
		SpringApplication.run(NodemcuApplication.class, args);
	}

}