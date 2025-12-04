package com.example.dinadocs.controllers;

import com.example.dinadocs.models.User;
import com.example.dinadocs.services.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * Controlador REST para endpoints de autenticación y autorización.
 * Maneja el registro de usuarios, login y logout del sistema.
 * 
 * <p>Endpoints disponibles:
 * <ul>
 *   <li>POST /api/auth/register - Registro de nuevos usuarios</li>
 *   <li>POST /api/auth/login - Autenticación y obtención de token</li>
 *   <li>POST /api/auth/logout - Invalidación de token</li>
 * </ul>
 * 
 * @author DynaDocs Team
 * @version 1.0
 * @since 2025-12-03
 * @see AuthService
 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthService authService;
    
    /**
     * Endpoint para registrar un nuevo usuario.
     * 
     * @param user Datos del usuario a registrar.
     * @return Mensaje de confirmación del registro.
     */
    @PostMapping("/register")
    public String register(@RequestBody User user) {
        authService.register(user);
        return "Usuario registrado con éxito";
    }

    /**
     * Endpoint para autenticar un usuario y obtener un token JWT.
     * 
     * @param request Mapa con las credenciales (email y password).
     * @return Mapa con el token JWT y el rol del usuario.
     * @throws RuntimeException Si las credenciales son inválidas.
     */
    @PostMapping("/login")
    public Map<String, Object> authenticateUser(@RequestBody Map<String, String> request) {
        try {
            return authService.login(request.get("email"), request.get("password"));
        } catch (Exception e) {
            throw new RuntimeException("Error de autenticación: " + e.getMessage());
        }
    }

    /**
     * Endpoint para cerrar sesión e invalidar el token JWT.
     * 
     * @param token Token JWT a invalidar (header Authorization).
     * @return ResponseEntity con mensaje de confirmación o error.
     */
    @PostMapping("/logout")
    public ResponseEntity<String> logout(@RequestHeader("Authorization") String token) {
        String jwt = token.replace("Bearer ", "");

        if (!authService.isTokenValid(jwt)) {
            return ResponseEntity.status(400).body("Token inválido o ya cerrado");
        }

        authService.logout(jwt);
        
        return ResponseEntity.ok("Sesión cerrada correctamente");
    }
}