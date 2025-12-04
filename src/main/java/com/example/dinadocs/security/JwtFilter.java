package com.example.dinadocs.security;

import com.example.dinadocs.models.User;
import com.example.dinadocs.repositories.UserRepository;
import com.example.dinadocs.services.TokenBlacklistService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import java.io.IOException;
import java.util.ArrayList;

/**
 * Filtro de autenticación JWT que intercepta todas las peticiones HTTP.
 * Valida tokens JWT y establece el contexto de seguridad de Spring Security.
 * 
 * <p>Proceso de validación:
 * <ol>
 *   <li>Extrae el token del header Authorization</li>
 *   <li>Verifica que no esté en la lista negra</li>
 *   <li>Valida la firma y extrae el usuario</li>
 *   <li>Establece la autenticación en el SecurityContext</li>
 * </ol>
 * 
 * @author DynaDocs Team
 * @version 1.0
 * @since 2025-12-03
 * @see OncePerRequestFilter
 * @see JwtUtils
 */
@Component
public class JwtFilter extends OncePerRequestFilter {

    private final JwtUtils jwtUtils;
    private final TokenBlacklistService tokenBlacklistService;
    private final UserRepository userRepository;

    /**
     * Constructor para inyección de dependencias.
     * 
     * @param jwtUtils Utilidad para validar tokens JWT.
     * @param tokenBlacklistService Servicio para verificar tokens invalidados.
     * @param userRepository Repositorio para buscar usuarios.
     */
    public JwtFilter(JwtUtils jwtUtils, TokenBlacklistService tokenBlacklistService, UserRepository userRepository) {
        this.jwtUtils = jwtUtils;
        this.tokenBlacklistService = tokenBlacklistService;
        this.userRepository = userRepository;
    }

    /**
     * Filtra cada petición HTTP para validar el token JWT.
     * Si el token es válido, establece la autenticación en el contexto de seguridad.
     * 
     * @param request La petición HTTP entrante.
     * @param response La respuesta HTTP.
     * @param filterChain La cadena de filtros.
     * @throws ServletException Si ocurre un error en el servlet.
     * @throws IOException Si ocurre un error de I/O.
     */
    @Override
    protected void doFilterInternal(HttpServletRequest request, 
                                    HttpServletResponse response, 
                                    FilterChain filterChain) throws ServletException, IOException {
        String authHeader = request.getHeader("Authorization");

        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);

            // Verificar si el token está invalidado
            if (tokenBlacklistService.isTokenInvalidated(token)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("Token inválido o expirado");
                return;
            }

            try {
                String username = jwtUtils.validateTokenAndGetUsername(token);

                if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                    User user = userRepository.findByEmail(username).orElse(null);
                    if (user != null) {
                        UsernamePasswordAuthenticationToken authToken = 
                            new UsernamePasswordAuthenticationToken(user, null, new ArrayList<>());
                        SecurityContextHolder.getContext().setAuthentication(authToken);
                        System.out.println("Usuario autenticado establecido en el contexto: " + user.getEmail());
                    } else {
                        System.out.println("Usuario no encontrado en la base de datos: " + username);
                    }
                }
            } catch (Exception e) {
                System.err.println("Error al validar el token: " + e.getMessage());
            }
        } else {
            System.out.println("Solicitud sin encabezado de autorización");
        }

        filterChain.doFilter(request, response);
    }

    /**
     * Determina si este filtro debe omitirse para ciertas rutas.
     * Las rutas públicas como /login y /register no requieren autenticación.
     * 
     * @param request La petición HTTP.
     * @return true si el filtro debe omitirse, false en caso contrario.
     */
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getServletPath();
        return path.equals("/login") || path.equals("/register");
    }
}