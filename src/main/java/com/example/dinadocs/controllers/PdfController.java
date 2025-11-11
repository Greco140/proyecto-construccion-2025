package com.example.dinadocs.controllers;

import org.apache.tomcat.util.http.fileupload.ByteArrayOutputStream;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.xhtmlrenderer.pdf.ITextRenderer;

import com.example.dinadocs.services.PdfGenerationService;
import com.example.dinadocs.models.GenerationRequest;

import org.springframework.web.bind.annotation.GetMapping;
// import org.springframework.web.bind.annotation.RequestParam;


@RestController
@RequestMapping("/api")
public class PdfController {

    private final PdfGenerationService pdfService;

    public PdfController(PdfGenerationService pdfService) {
        this.pdfService = pdfService;
    }


    @PostMapping("/generate")
    public ResponseEntity<byte[]> generateDocument(@RequestBody GenerationRequest request) {

        try {

            byte[] pdfBytes = pdfService.generatePdf(request);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDispositionFormData("attachment", "documento.pdf");

            return new ResponseEntity<>(pdfBytes, headers, HttpStatus.OK);

        } catch (IllegalArgumentException e) {
            return new ResponseEntity<>(e.getMessage().getBytes(), HttpStatus.BAD_REQUEST);
        
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }

        // codigo de hugo
        // try {
        //     // Parse HTML using jsoup
        //     Document document = Jsoup.parse(request.getHtmlContent());
        //     document.outputSettings().syntax(Document.OutputSettings.Syntax.xml);

        //     // Create PDF using Flying Saucer
        //     ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

        //     ITextRenderer renderer = new ITextRenderer();
        //     renderer.setDocumentFromString(document.html());
        //     renderer.layout();
        //     renderer.createPDF(outputStream);

        //     byte[] pdfBytes = outputStream.toByteArray();
        //     outputStream.close();

        //     // Return PDF as response
        //     HttpHeaders headers = new HttpHeaders();
        //     headers.setContentType(MediaType.APPLICATION_PDF);
        //     headers.setContentDispositionFormData("attachment", "document.pdf");
        //     headers.setContentLength(pdfBytes.length);

        //     return ResponseEntity.ok()
        //             .headers(headers)
        //             .body(pdfBytes);

        // } catch (Exception e) {
        //     throw new RuntimeException("Error converting HTML to PDF", e);
        // }
    }

    @GetMapping("/hello")
    public String helloString() {
        String message = "Hello pelonchas";
        return message;
    }
    

    // Request DTO for HTML content
    public static class HtmlRequest {
        private String htmlContent;

        public String getHtmlContent() {
            return htmlContent;
        }

        public void setHtmlContent(String htmlContent) {
            this.htmlContent = htmlContent;
        }
    }

    // Request DTO for URL
    public static class UrlRequest {
        private String url;

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }
    }
}
