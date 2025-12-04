package com.example.dinadocs.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;
import java.security.Key;
import java.util.Date;

/**
 * Utilidad para la generación y validación de tokens JWT (JSON Web Tokens).
 * Implementa la lógica de firma y verificación usando el algoritmo HS256.
 * 
 * <p>Características:
 * <ul>
 *   <li>Tokens con firma HMAC-SHA256</li>
 *   <li>Duración de 24 horas por defecto</li>
 *   <li>Generación basada en el email del usuario</li>
 * </ul>
 * 
 * @author DynaDocs Team
 * @version 1.0
 * @since 2025-12-03
 */
@Component
public class JwtUtils {

    /** Clave secreta para firmar los tokens JWT. Debe ser suficientemente larga y compleja. */
    private static final String SECRET = "EstaEsUnaClaveSuperSecretaQueNadiePuedeAdivinar123456";
    
    /** Tiempo de expiración del token en milisegundos (24 horas). */
    private static final long EXPIRATION_TIME = 86400000; 

    /** Clave criptográfica generada a partir del secreto. */
    private final Key key = Keys.hmacShaKeyFor(SECRET.getBytes());

    /**
     * Genera un nuevo token JWT para el usuario especificado.
     * 
     * @param username Email del usuario para el cual se genera el token.
     * @return Token JWT firmado como String.
     */
    public String generateToken(String username) {
        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * Valida un token JWT y extrae el nombre de usuario (email).
     * 
     * @param token El token JWT a validar.
     * @return El email del usuario si el token es válido, null si es inválido o ha expirado.
     */
    public String validateTokenAndGetUsername(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody()
                    .getSubject();
        } catch (JwtException e) {
            return null;
        }
    }
}