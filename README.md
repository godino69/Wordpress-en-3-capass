# Despliegue de CMS WordPress en Alta Disponibilidad en AWS


## Arquitectura del Proyecto

### Diseño de Capas
- **Capa 1:** Balanceador de carga público con Apache.
- **Capa 2:** Servidores backend (2 servidores Apache) y un servidor NFS para recursos compartidos.
- **Capa 3:** Servidor de base de datos (MySQL/MariaDB).

### Características
- Acceso público solo al balanceador de carga.
- Comunicación segura entre capas utilizando grupos de seguridad de AWS.
- Configuración HTTPS con un dominio público.
- Personalización de WordPress para incluir el nombre del alumno.

---


![image](https://github.com/user-attachments/assets/2c67e3ab-6e55-49ea-9f79-5fb535e07569)
