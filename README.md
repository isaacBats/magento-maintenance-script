
# Magento Maintenance Script por FactoriaDigital
![](https://img.shields.io/github/stars/factoriadigital/magento-maintenance-script.svg) ![](https://img.shields.io/github/forks/factoriadigital/magento-maintenance-script.svg) ![](https://img.shields.io/github/tag/factoriadigital/magento-maintenance-script.svg) ![](https://img.shields.io/github/release/factoriadigital/magento-maintenance-script.svg) ![](https://img.shields.io/github/issues/factoriadigital/magento-maintenance-script.svg) 

Este script realiza un backup de los archivos encontrados en la carpeta var/log, creando un archivo comprimido del mismo. 

A su vez, realiza una limpieza de los directorios var/report, var/log y var/session eliminando los archivos con fecha superior al valor `LOG_FILES_EXPIRATION` para var/log y var/report, el cual por defecto es de 30 días; y dependiendo del valor `SESSION_FILES_EXPIRATION` para var/session, que por defecto es de 7 días.

Adicionalmente, se procede a limpiar las imágenes almacenadas en caché, por si realmente no quisiéramos flushear todo el catálogo perdiendo así tiempo de regeneración de las mismas. El tiempo se define en la variable `CACHE_IMAGES_EXPIRATION`, que por defecto es de 180 días.

También procede a la limpieza forzada de las tablas de logs de los visitantes. Los días están definidos en la variable `LOG_VISITOR_EXPIRATION_DAYS`, la cual por defecto es de 7 días.

## Método de uso

#### Múltiples Magento
Si deseas utilizar el script para múltiples Magento, debes editar la variable
```javascript
ROOT_DIR = "/home/"
```
Con la ruta absoluta desde donde tengas localizado este script y desde donde se puedan encontrar los demás directorios/cuentas de Magento. 

Por ejemplo, podríamos tener lo siguiente:

```
/home/cliente1/public_html/
/home/cliente2/public_html/
```

Por los que el script iría en `/home/magento_maintenance.sh` para que detectara cada directorio y realizara automáticamente la limpieza en ellos.

#### Un único Magento

Deberás añadir la ruta absoluta hacia el root de tu directorio Magento en la siguiente variable:
```bash
ROOT_DIR = "/home/usuario/public_html/"
```
Introducir este script dentro de ese mismo directorio y modificar las últimas líneas del script, actualmente son así:
```bash
# For multiple Magento installations
for dir in *;
do
    # If Magento is found
    if [ -f "$ROOT_DIR$dir/public_html/app/Mage.php" ]; then    
        clean "$ROOT_DIR$dir/public_html"
    fi
done

# For a single Magento installation

# If Magento is found
#if [ -f "$ROOT_DIRapp/Mage.php" ]; then    
#    clean "$ROOT_DIR"
#fi
```
Descomentaremos las líneas de abajo, las cuales validan la instalación para una única instalación de Magento y comentaremos de la misma forma las líneas superiores para dejar intacto el proceso para múltiples Magento, quedando algo así:

```bash
# For multiple Magento installations
#for dir in *;
#do
    # If Magento is found
#    if [ -f "$ROOT_DIR$dir/public_html/app/Mage.php" ]; then    
#        clean "$ROOT_DIR$dir/public_html"
#    fi
#done

# For a single Magento installation

# If Magento is found
if [ -f "$ROOT_DIRapp/Mage.php" ]; then    
    clean "$ROOT_DIR"
fi
```
#### Ejecutar el script

Otorgamos permisos de ejecución al script accediendo desde el servidor:
```bash
chmod +x magento_maintenance.sh
```
Y lanzamos el script 
```bash
./magento_maintenance.sh
```
El script comenazará a escanear los directorios y a proceder con su limpieza.

#### Opciones adicionales
```bash 
VERBOSE=true
LOG_FILES_EXPIRATION=30
SESSION_FILES_EXPIRATION=7
CACHE_IMAGES_EXPIRATION=180
LOG_VISITOR_EXPIRATION_DAYS=7
```
