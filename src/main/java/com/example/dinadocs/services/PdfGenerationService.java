package com.example.dinadocs.services;

import java.util.Map;
import org.springframework.stereotype.Service;
import com.example.dinadocs.models.GenerationRequest; 


import java.io.ByteArrayOutputStream;
import org.jsoup.nodes.Document;
import org.jsoup.Jsoup;
import org.xhtmlrenderer.pdf.ITextRenderer;

// TODO: Documentar con JavaDoc

@Service
public class PdfGenerationService {
   
    public byte[] generatePdf(GenerationRequest request) {
        
        validateData(request);

        String templateType = request.getTemplateType();
        String htmlTemplate = loadTemplateByType(templateType);

        Map<String, Object> data = request.getData();

        String htmlFusionado = fuse(htmlTemplate, data);

        byte[] pdfBytes = convertHtmlToPdf(htmlFusionado);
        
        return pdfBytes;
    }

    private void validateData(GenerationRequest request) {
        Map<String, Object> data = request.getData();

        if (data == null || data.isEmpty()) {
            throw new IllegalArgumentException("Los datos (data) para la generación del documento no pueden estar vacíos.");
        }
        if (request.getTemplateType() == null || request.getTemplateType().trim().isEmpty()) {
            throw new IllegalArgumentException("El tipo de plantilla (templateType) no puede estar vacío.");
        }
    }

    // Metodo temporal para probar plantillas 
    // pero todas las plantillas deben provenir 
    // de la base de datos en un futuro
    //
    // TODO: Implementar carga de plantillas desde BD
    // (ya se, Mala practica poner el "TODO" XD)

    private String loadTemplateByType(String templateType) {
        
        if ("Factura".equalsIgnoreCase(templateType)) {
            return "<html>"
                 + "<body>"
                 + "<h1>Factura Nro: {{numero_factura}}</h1>"
                 + "<p>Cliente: <strong>{{nombre_cliente}}</strong></p>"
                 + "<p>Monto Total: <strong>${{monto_total}}</strong></p>"
                 + "</body>"
                 + "</html>";
        }
        
        if ("Certificado".equalsIgnoreCase(templateType)) {
            return "<html>"
                 + "<body style='text-align: center; border: 1px solid black; padding: 20px;'>"
                 + "<h1>Certificado de Finalización</h1>"
                 + "<p>Otorgado a: <h2>{{nombre_galardonado}}</h2></p>"
                 + "<p>Por completar el curso: <strong>{{nombre_curso}}</strong></p>"
                 + "</body>"
                 + "</html>";
        }

        throw new IllegalArgumentException("El templateType '" + templateType + "' no es válido o no existe.");
    }

    private String fuse(String htmlTemplate, Map<String, Object> data) {
        String fusedHtml = htmlTemplate;

        for (Map.Entry<String, Object> entry : data.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue() != null ? entry.getValue().toString() : "";
            String placeholder = "{{" + key + "}}";
            
            fusedHtml = fusedHtml.replace(placeholder, value);
        }
        
        fusedHtml = fusedHtml.replaceAll("\\{\\{.*?\\}\\}", "[DATO NO PROPORCIONADO]");

        return fusedHtml;
    }

    private byte[] convertHtmlToPdf(String htmlContent) {
        try {
            Document document = Jsoup.parse(htmlContent);
            document.outputSettings().syntax(Document.OutputSettings.Syntax.xml);

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

            ITextRenderer renderer = new ITextRenderer();
            
            renderer.setDocumentFromString(document.html());
            
            renderer.layout();
            renderer.createPDF(outputStream);

            byte[] pdfBytes = outputStream.toByteArray();
            
            outputStream.close();

            return pdfBytes;

        } catch (Exception e) {
            throw new RuntimeException("Error interno al convertir HTML a PDF: " + e.getMessage(), e);
        }
    }
}
