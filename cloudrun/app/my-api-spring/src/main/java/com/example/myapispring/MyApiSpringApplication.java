package com.example.myapispring;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.InetAddress;

@RestController
@SpringBootApplication
public class MyApiSpringApplication {

    public static void main(String[] args) {
        SpringApplication.run(MyApiSpringApplication.class, args);
    }

    @GetMapping(value = "/")
    public String greetings() throws Exception {
        InetAddress ia = InetAddress.getLocalHost();
        String ip = ia.getHostAddress();
        return "Hello! I'm running on cloud run";
    }
}
