# Implantación de Elastic en entorno Docker Swarm

Este proyecto contiene los archivos de configuración e instrucciones necesarias para implantar un cluster de Elasticsearch en un entorno de Docker Swarm.

## Requisitos

Para poder realizar la implantación, se requiere: 
- estar conectado por `ssh` al nodo manager del swarm de docker
- tener acceso a este repositorio, tanto a nivel de conexión como de permisos
- tener permisos de ejecución para el comando `docker`
- tener un archivo `.p12` con los certificados que elastic usará para las comunicaciones internodos. Si es necesario generar este archivo, se pude consultar la documentación de elastic para [generar el certificado](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-basic-setup.html#generate-certificates)

## Instalación (para 3 nodos)

1. Desde el nodo manager, clonar este repositorio y acceder al directorio `ElasticSearch/TEST/compose/` creado:

    ```sh
   git clone https://devops.valenciaport.com/APV/Area%20Infraestructura%20TI/_git/ElasticSearch
    ```
   ```sh
    cd ElasticSearch/TEST/compose/
    ```

2. Crear un secret para almacenar el certificado:

   ```sh
    docker secret create elastic-certificates.p12 /RUTA_AL_CERTIFICADO/elastic-certificates.p12
    ```

3. Comprobar la configuración de los volúmenes dentro del archivo `docker-compose.yml`. Esta configuración se puede externalizar, creando los volúmenes de forma manual.


4. Desplegar el cluster (en este caso el nombre del cluster es `elastic`) y esperar un par de minutos a que los nodos hagan el bootstrap

   ```sh
    docker stack deploy -c ./docker-compose.yml elastic
    ```
    Se puede consultar el estado de los nodos con los siguientes commandos

    ```sh
    docker stack ps --no-trunc elastic
    docker service ls
    docker service logs --follow SERVICE_NAME
    ```

5. Establecer el password para los usuarios elatic y kibana_system, para ello tendremos que ejecutar un comando dentro de cualquiera de los nodos:
   - Connectarse a uno de los nodos
   ```sh
    docker exec -it $(docker container ls | grep elastic_node_1 | awk '{print $1}') bash
   ```
   - Establecer la contraseña para los dos usuarios
   ```sh 
   ./bin/elasticsearch-reset-password -b -i -u elastic
   (insertar el password que se quiera usar y confirmarlo)
   
    ./bin/elasticsearch-reset-password -b -i -u kibana_system
    (insertar el password que se quiera usar y confirmarlo)
    ```
6. Añadir el password introducido para el usuario `kibana_system` en el archivo `kibana.env`
   ```properties
   ELASTICSEARCH_PASSWORD=EL_PASSWORD_INTRODUCIDO_PARA_EL_USUARIO_KIBANA_SYSTEM
   ```
7. Commentar la última línea del archivo `common.env` que solo es necesaria la primera vez que arranca el cluster:
   ```properties
   # cluster.initial_master_nodes=elastic_node_1,elastic_node_2,elastic_node_3
   ```
   
8. Reiniciar el cluster
   ```sh
    docker stack rm elastic
    docker stack deploy -c ./docker-compose.yml elastic
    ```