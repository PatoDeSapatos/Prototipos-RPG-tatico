package com.patodesapatos.dungeons;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DungeonsApplication {

	public static void main(String[] args) {
		System.setProperty("spring.devtools.livereload.enabled", "false");
		SpringApplication.run(DungeonsApplication.class, args);
	}

}
