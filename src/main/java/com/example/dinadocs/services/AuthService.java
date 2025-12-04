package com.example.dinadocs.services;

import com.example.dinadocs.models.Role;
import com.example.dinadocs.models.User;
import com.example.dinadocs.repositories.UserRepository;
import com.example.dinadocs.security.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


import java.util.HashMap;
import java.util.Map;

/**
 * Servicio de autenticación y autorización de usuarios.
 * Gestiona el registro, login, logout y validación de tokens JWT.
 * 
 * @author DynaDocs Team
 * @version 1.0
 * @since 2025-12-03
 * @see JwtUtils
 * @see TokenBlacklistService
 */
@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private JwtUtils jwtUtils;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private TokenBlacklistService tokenBlacklistService;

    /**
     * Registra un nuevo usuario en el sistema.
     * Si no se especifica un rol, asigna USUARIO por defecto.
     * 
     * @param user El usuario a registrar con sus datos básicos.
     * @return El usuario registrado con contraseña encriptada.
     * @throws RuntimeException Si el email ya está registrado.
     */
    public User register(User user) {
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            throw new RuntimeException("El usuario ya existe");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        if (user.getRole() == null) user.setRole(Role.USUARIO);
        return userRepository.save(user);
    }

    /**
     * Autentica a un usuario y genera un token JWT.
     * 
     * @param email Email del usuario.
     * @param password Contraseña en texto plano.
     * @return Mapa con el token JWT y el rol del usuario.
     * @throws RuntimeException Si el usuario no existe o la contraseña es incorrecta.
     */
    public Map<String, Object> login(String email, String password) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        if (passwordEncoder.matches(password, user.getPassword())) {
            String token = jwtUtils.generateToken(email);
            Map<String, Object> response = new HashMap<>();
            response.put("token", token);
            response.put("role", user.getRole());
            return response;
        } else {
            throw new RuntimeException("Contraseña incorrecta");
        }
    }

    /**
     * Invalida un token JWT agregándolo a la lista negra.
     * 
     * @param token El token JWT a invalidar (con o sin prefijo "Bearer ").
     * @return Mensaje de confirmación.
     */
    public String logout(String token) {
        String jwt = token.replace("Bearer ", "");
        tokenBlacklistService.invalidateToken(jwt);
        return "Sesión cerrada correctamente";
    }

    /**
     * Verifica si un token JWT es válido (no está en la lista negra).
     * 
     * @param token El token JWT a verificar (con o sin prefijo "Bearer ").
     * @return true si el token es válido, false si está invalidado.
     */
    public boolean isTokenValid(String token) {
        String jwt = token.replace("Bearer ", "");
        return !tokenBlacklistService.isTokenInvalidated(jwt);
    }

}