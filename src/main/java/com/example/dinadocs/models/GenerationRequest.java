package com.example.dinadocs.models;

import java.util.Map;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class GenerationRequest {

    private String templateType;
    private Map<String, Object> data; 

}
