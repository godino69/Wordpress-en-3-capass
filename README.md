# Despliegue de CMS WordPress en Alta Disponibilidad en AWS

## **Índice**

1. [Arquitectura del Proyecto](#arquitectura-del-proyecto)
   - [Diseño de Capas](#diseño-de-capas)
   - [Características](#características)
2. [Grupos de Seguridad](#grupos-de-seguridad)
   - [Balanceador](#balanceador)
   - [NFS](#nfs)
   - [Servidores Web](#servidores-web)
   - [MYSQL](#mysql)
3. [VPC](#vpc)
4. [Configuración HTTPS con Certbot](#configuración-https-con-certbot)
   - [Requisitos Previos](#requisitos-previos)
   - [Pasos para Configurar Certbot](#pasos-para-configurar-certbot)

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

### Grupos de seguridad
**Balanceador**
Este seria nuestro grupo de seguridad del balanceador donde tendriamos permitido el SSH, HTTP y HTTPS.
![image](https://github.com/user-attachments/assets/70a1298e-c4e6-495c-906c-5826cd8f39b4)

**NFS**
Este seria nuestro grupo de seguridad del NFS donde tendriamos permitido el SSH y NFS.
![image](https://github.com/user-attachments/assets/10086673-3392-47ad-bf86-ea5f7879b152)

**Servidores Web**
Este seria nuestro grupo de seguridad del NFS donde tendriamos permitido el SSH, NFS, HTTP y NFS.
![image](https://github.com/user-attachments/assets/76613a26-e687-45ad-82c9-e0e0efee8975)

**MYSQL**
Este seria nuestro grupo de seguridad del NFS donde tendriamos permitido el SSH y NFS.
![image](https://github.com/user-attachments/assets/f5d63713-80f0-4824-a243-c622f46cff54)

### VPC
Esta seria la configuracion de nuestra VPC donde tendriamos 3 subredes, una para cada capa. La subred de la capa 2 y 3 irian conectadas a nuestra tabla de enrutamiento privada y la subred de la capa 1 a la pública.
Esas tablas re enrutamiento irian a su vez conectadas a la puerta de enlace a internet
![image](https://github.com/user-attachments/assets/a10ee4b2-56d5-4bfa-a2b3-f5d8fadd5369)

### **Configuración HTTPS con Certbot**

Para habilitar un sitio web seguro mediante HTTPS, utilizaremos **Certbot**, una herramienta automatizada que gestiona la obtención y renovación de certificados SSL de **Let's Encrypt**.

#### **Requisitos Previos**
1. Tener un dominio público configurado que apunte a la IP elástica asociada al balanceador de carga.
2. Instalar Certbot en el servidor del balanceador de carga.

#### **Pasos para Configurar Certbot**

1. **Instalar Certbot y sus dependencias:**
   En el servidor del balanceador, instala Certbot con los siguientes comandos:
   ```bash
   sudo apt update
   sudo apt install certbot python3-certbot-apache -y
   
2. **Obtener el certificado SSL:**
    Configura Certbot para el dominio:
   ```bash
   certbot certonly --apache -d wordpressgodi.zapto.org --email agodinoc01@iesalbarregas.es --agree-tos --non-interactive --redirect
   
