package com.example.echoeks;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.net.URI;
import java.net.URISyntaxException;

@SpringBootApplication
@RestController
public class EchoEksApplication {

    @Value( "${SVC_LOCATION}" )
    private String svc_location;

    @Value( "${MESSAGE}" )
    private String message;
    final RestTemplate restTemplate;

    public EchoEksApplication(RestTemplateBuilder restTemplate) {
        this.restTemplate = restTemplate.build();
    }

    public static void main(String[] args) {
        SpringApplication.run(EchoEksApplication.class, args);
    }

    @GetMapping(value = "/")
    public String hello() {
        System.out.println("called!!" + svc_location + message);
        URI url = null;
        try {
            url = new URI(svc_location);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        String greetings;
        try {
            greetings = restTemplate.getForEntity(url, String.class).getBody();
        } catch (Exception e) {
            e.printStackTrace();
            return "Greetings from something wrong";
        }
        return message + "Greetings from the destination: " + greetings;
    }
}
