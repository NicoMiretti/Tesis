# Capitulo 2 - Marco Teorico

Este capitulo presenta los conceptos fundamentales necesarios para comprender las tecnologias, practicas y decisiones que se describen en el resto de la tesis. El objetivo no es ser una referencia exhaustiva de cada herramienta, sino brindar al lector una base solida para entender el proceso de modernizacion y las razones detras de cada eleccion tecnologica.

---

## 2.1 Contenedores y orquestacion

### 2.1.1 El problema que resuelven los contenedores

Historicamente, desplegar una aplicacion implicaba instalarla directamente sobre un sistema operativo, ya sea en un servidor fisico o en una maquina virtual. Este modelo genera una serie de problemas conocidos:

- **Dependencias conflictivas**: dos aplicaciones en el mismo servidor pueden requerir versiones diferentes de una misma libreria o framework.
- **"En mi maquina funciona"**: las diferencias entre el entorno de desarrollo y el de produccion provocan errores dificiles de reproducir.
- **Despliegues fragiles**: instalar o actualizar una aplicacion puede afectar a otras que comparten el mismo sistema operativo.
- **Dificultad para escalar**: replicar un entorno completo para escalar horizontalmente es lento y costoso.

Los contenedores surgen como respuesta a estos problemas. Un contenedor es una unidad de software que **empaqueta el codigo de una aplicacion junto con todas sus dependencias** (librerias, runtime, configuracion) de manera que pueda ejecutarse de forma consistente en cualquier entorno.

### 2.1.2 Contenedores: Docker y el estandar OCI

**Docker**, lanzado en 2013, fue la herramienta que popularizo el concepto de contenedores. Antes de Docker, tecnologias como LXC (Linux Containers) ya existian, pero Docker simplifico drasticamente la experiencia del desarrollador al introducir:

- **Dockerfile**: un archivo de texto que describe paso a paso como construir una imagen de contenedor.
- **Imagenes**: paquetes inmutables que contienen todo lo necesario para ejecutar una aplicacion. Se construyen en capas, lo que permite reutilizar componentes comunes.
- **Registros de imagenes**: repositorios centralizados (como Docker Hub o registros privados) donde se almacenan y distribuyen las imagenes.
- **Docker Engine**: el motor que ejecuta los contenedores en un host.

A diferencia de las maquinas virtuales, los contenedores **no incluyen un sistema operativo completo**. Comparten el kernel del sistema operativo host y solo empaquetan lo necesario a nivel de aplicacion. Esto los hace significativamente mas livianos y rapidos de iniciar.

Con el crecimiento del ecosistema, surgio la necesidad de estandarizar el formato de contenedores. La **Open Container Initiative (OCI)**, fundada en 2015 bajo la Linux Foundation, definio dos especificaciones clave:

- **Image Spec**: como se construye y estructura una imagen de contenedor.
- **Runtime Spec**: como se ejecuta un contenedor.

Esto garantiza que las imagenes construidas con cualquier herramienta compatible con OCI puedan ejecutarse en cualquier runtime compatible, eliminando la dependencia exclusiva de Docker.

### 2.1.3 Kubernetes

Cuando una organizacion tiene unas pocas aplicaciones, gestionar contenedores manualmente es viable. Pero cuando se tienen decenas o cientos de aplicaciones, cada una con multiples replicas, diferentes necesidades de red, almacenamiento y configuracion, se necesita una herramienta que **orqueste** todo eso de forma automatizada.

**Kubernetes** (frecuentemente abreviado como K8s) es una plataforma de orquestacion de contenedores de codigo abierto, originalmente desarrollada por Google y donada a la **Cloud Native Computing Foundation (CNCF)** en 2015. Nacio de la experiencia interna de Google con sistemas como Borg y Omega, que gestionaban millones de contenedores en sus data centers.

Kubernetes resuelve los siguientes problemas:

- **Scheduling**: decide en que nodo (servidor) del cluster se ejecuta cada contenedor, en funcion de los recursos disponibles.
- **Alta disponibilidad**: si un contenedor o un nodo falla, Kubernetes automaticamente reprograma las cargas de trabajo en nodos sanos.
- **Escalado**: permite escalar aplicaciones horizontal o verticalmente, de forma manual o automatica en base a metricas.
- **Networking**: proporciona un modelo de red donde cada pod (la unidad minima de despliegue) tiene su propia IP y los servicios se descubren automaticamente.
- **Gestion de configuracion y secretos**: permite inyectar configuraciones y credenciales en los contenedores sin incluirlas en la imagen.
- **Rolling updates y rollbacks**: permite actualizar aplicaciones de forma progresiva y revertir cambios si algo falla.

#### Conceptos fundamentales de Kubernetes

Para comprender el resto de esta tesis, es necesario conocer los siguientes conceptos basicos:

- **Cluster**: conjunto de nodos (servidores) que ejecutan cargas de trabajo containerizadas, gestionados por Kubernetes.
- **Nodo**: una maquina (fisica o virtual) dentro del cluster. Existen nodos **master** (que ejecutan el plano de control) y nodos **worker** (que ejecutan las aplicaciones).
- **Pod**: la unidad minima de despliegue en Kubernetes. Un pod puede contener uno o mas contenedores que comparten red y almacenamiento.
- **Deployment**: recurso que define el estado deseado de una aplicacion (cuantas replicas, que imagen usar, etc.) y se encarga de mantenerlo.
- **Service**: abstraccion que expone un conjunto de pods como un servicio de red estable, independientemente de que los pods individuales se creen o destruyan.
- **Namespace**: mecanismo de aislamiento logico dentro de un cluster. Permite separar recursos por equipo, proyecto o entorno.
- **ConfigMap y Secret**: recursos para almacenar configuracion y datos sensibles respectivamente, que se inyectan en los pods.
- **Ingress / Route**: mecanismos para exponer servicios al exterior del cluster mediante reglas de enrutamiento HTTP/HTTPS.

#### Modelo declarativo

Un aspecto fundamental de Kubernetes es su **modelo declarativo**. En lugar de dar instrucciones paso a paso ("crea un contenedor, conectalo a esta red, exponelo en este puerto"), el usuario **declara el estado deseado** en un archivo YAML o JSON, y Kubernetes se encarga de alcanzar y mantener ese estado.

Por ejemplo, un Deployment que declara "quiero 3 replicas de mi aplicacion" hara que Kubernetes:
- Cree 3 pods si no existen.
- Recree un pod si uno se cae.
- Reduzca a 3 si por algun motivo hay mas.

Este modelo declarativo es la base sobre la que se construyen practicas como GitOps e infraestructura como codigo, que se describen mas adelante en este capitulo.

### 2.1.4 Red Hat OpenShift

**Red Hat OpenShift** es una plataforma de contenedores empresarial construida sobre Kubernetes. Si Kubernetes es el motor, OpenShift es el vehiculo completo: agrega todo lo necesario para que una organizacion pueda operar contenedores en produccion de forma segura y eficiente.

OpenShift toma Kubernetes como base y le añade:

- **Seguridad reforzada por defecto**: los contenedores corren con permisos restringidos (Security Context Constraints - SCC), lo que reduce la superficie de ataque. Por defecto, los contenedores no pueden ejecutarse como root.
- **Plano de control gestionado**: OpenShift facilita la instalacion, actualizacion y operacion del cluster con herramientas como el OpenShift Installer y el operador de cluster (Cluster Version Operator).
- **Consola web integrada**: una interfaz grafica que permite a desarrolladores y operadores gestionar recursos, ver logs, monitorear metricas y administrar el cluster.
- **Builds integrados (Source-to-Image)**: capacidad de construir imagenes de contenedores directamente desde el codigo fuente, sin necesidad de escribir un Dockerfile.
- **Routes**: extension de Kubernetes que simplifica la exposicion de aplicaciones al exterior con soporte nativo de TLS.
- **OperatorHub**: catalogo integrado de operadores (componentes que automatizan la gestion del ciclo de vida de aplicaciones complejas dentro del cluster).
- **Ecosistema Red Hat**: integracion con productos como Red Hat Developer Hub, Ansible Automation Platform, Advanced Cluster Security, entre otros.
- **Soporte empresarial**: respaldo de Red Hat con soporte tecnico, actualizaciones de seguridad, ciclos de vida definidos y certificacion de compatibilidad.

#### OpenShift vs Kubernetes vanilla

Es comun preguntarse por que usar OpenShift en lugar de Kubernetes directamente. La diferencia principal es el **nivel de abstraccion y soporte**:

| Aspecto | Kubernetes vanilla | Red Hat OpenShift |
|---|---|---|
| Instalacion | Manual, multiples opciones | Instalador integrado |
| Seguridad | Configurable, responsabilidad del usuario | Hardened por defecto (SCC, RBAC) |
| Consola web | Dashboard basico (opcional) | Consola completa integrada |
| Networking | Requiere instalar un CNI plugin | SDN integrado (OVN-Kubernetes) |
| Builds | No incluido | Source-to-Image, Buildah |
| Soporte | Comunidad | Red Hat (SLA empresarial) |
| Actualizaciones | Manuales | Over-the-air (OTA) gestionadas |

Para una empresa que necesita operar en produccion con garantias de soporte, seguridad y estabilidad, OpenShift reduce significativamente la complejidad operativa comparado con administrar Kubernetes por cuenta propia.

---

## 2.2 Modelos de despliegue de infraestructura

La decision sobre **donde** ejecutar la infraestructura es tan importante como la decision de **que** tecnologias usar. Existen tres modelos principales, cada uno con sus ventajas, desventajas y casos de uso.

### 2.2.1 On-premises

El modelo **on-premises** (o "en las instalaciones") significa que la infraestructura se ejecuta en servidores fisicos ubicados en un data center propio o contratado por la organizacion. La empresa es responsable de todo: hardware, red, almacenamiento, sistema operativo, actualizaciones, seguridad fisica y logica.

**Ventajas:**
- **Control total**: la organizacion tiene control completo sobre el hardware, la red y los datos.
- **Cumplimiento normativo**: en industrias reguladas (banca, salud, gobierno), mantener los datos on-premises puede ser un requisito legal o regulatorio.
- **Latencia predecible**: las aplicaciones que necesitan comunicarse con sistemas internos tienen latencia minima.
- **Sin dependencia de proveedores cloud**: no hay riesgo de cambios de precios o condiciones por parte de un proveedor externo.

**Desventajas:**
- **Inversion de capital (CapEx)**: requiere comprar y mantener hardware, lo que implica una inversion inicial significativa.
- **Escalabilidad limitada**: escalar implica comprar mas hardware, lo que lleva semanas o meses.
- **Responsabilidad operativa**: el equipo de TI debe gestionar todo el stack, desde el hardware hasta la plataforma.
- **Riesgo de obsolescencia**: el hardware se deprecia y requiere renovacion periodica.

### 2.2.2 Cloud publica

En el modelo de **cloud publica**, la infraestructura se ejecuta en servidores de un proveedor externo (como Microsoft Azure, Amazon Web Services o Google Cloud Platform). El proveedor gestiona el hardware, la red y, en muchos casos, parte del software base.

**Ventajas:**
- **Elasticidad**: se pueden aprovisionar o liberar recursos en minutos.
- **Modelo de costos operativo (OpEx)**: se paga por lo que se usa, sin inversion inicial en hardware.
- **Servicios gestionados**: el proveedor ofrece servicios como bases de datos, colas de mensajes, balanceadores, etc., reduciendo la carga operativa.
- **Alcance global**: permite desplegar aplicaciones en multiples regiones geograficas.

**Desventajas:**
- **Dependencia del proveedor (vendor lock-in)**: migrar de un proveedor a otro puede ser complejo y costoso.
- **Costos a largo plazo**: el modelo OpEx puede resultar mas caro que on-premises para cargas de trabajo estables y predecibles.
- **Cumplimiento normativo**: para algunas industrias, alojar datos en infraestructura de terceros puede ser problematico.
- **Latencia variable**: la comunicacion con sistemas internos on-premises introduce latencia adicional.

### 2.2.3 Modelo hibrido

El modelo **hibrido** combina infraestructura on-premises con servicios en la nube publica. No es simplemente tener ambos entornos por separado, sino **integrarlos** de forma que las cargas de trabajo puedan distribuirse estrategicamente entre ambos.

Este es el modelo adoptado en el caso de estudio de esta tesis: **OpenShift on-premises** para las cargas de trabajo principales, y **ARO (Azure Red Hat OpenShift)** para workloads especificos en la nube.

**Ventajas:**
- **Flexibilidad**: permite elegir donde ejecutar cada carga de trabajo segun sus requisitos (regulatorios, de rendimiento, de costos).
- **Migracion progresiva**: no requiere un "big bang" donde todo se mueve a la nube de golpe. Permite una transicion gradual.
- **Optimizacion de costos**: las cargas estables corren on-premises (donde el costo es predecible), mientras que las cargas variables o de burst aprovechan la elasticidad del cloud.
- **Redundancia**: tener infraestructura en dos ubicaciones distintas mejora la resiliencia ante fallas.

**Desventajas:**
- **Complejidad operativa**: mantener dos entornos requiere herramientas y procesos que funcionen de forma consistente en ambos.
- **Networking**: la conectividad entre on-premises y cloud agrega complejidad (VPNs, ExpressRoute, latencia).
- **Consistencia**: asegurar que las politicas de seguridad, monitoreo y despliegue sean las mismas en ambos entornos es un desafio constante.

#### ARO - Azure Red Hat OpenShift

**ARO (Azure Red Hat OpenShift)** es un servicio gestionado de OpenShift que corre sobre la infraestructura de Microsoft Azure. Es operado conjuntamente por Microsoft y Red Hat.

La diferencia clave con un OpenShift on-premises es que en ARO:
- El **plano de control** (masters) es gestionado por Microsoft y Red Hat.
- El **hardware** y la **red subyacente** son de Azure.
- El usuario se enfoca en desplegar y operar sus aplicaciones, no en administrar el cluster.
- Las **actualizaciones** del cluster son coordinadas por el servicio.

ARO permite que una empresa que ya usa OpenShift on-premises extienda su plataforma a la nube sin cambiar sus herramientas, manifiestos ni procesos de trabajo. Un manifiesto de Kubernetes que funciona en OpenShift on-premises deberia funcionar igual en ARO, lo que facilita la consistencia en un modelo hibrido.

---

## 2.3 Practicas de entrega de software

Mas alla de la infraestructura, la forma en que el software se construye, prueba y despliega es igualmente critica. En esta seccion se describen las practicas que la empresa fue adoptando progresivamente.

### 2.3.1 Integracion Continua y Entrega Continua (CI/CD)

**CI/CD** es un conjunto de practicas que buscan automatizar y acelerar el ciclo de vida de la entrega de software.

**Integracion Continua (CI - Continuous Integration)** consiste en que los desarrolladores integren sus cambios de codigo en un repositorio compartido de forma frecuente (idealmente varias veces al dia). Cada integracion dispara un proceso automatizado que:

1. Compila el codigo.
2. Ejecuta pruebas automatizadas (unitarias, de integracion).
3. Genera artefactos (binarios, imagenes de contenedores).
4. Reporta el resultado al equipo.

El objetivo es **detectar problemas tempranamente**. Si un cambio rompe algo, se detecta en minutos, no semanas despues.

**Entrega Continua (CD - Continuous Delivery)** extiende la CI asegurando que el software este **siempre en un estado desplegable**. Cada cambio que pasa las pruebas automatizadas puede ser desplegado a produccion en cualquier momento, aunque la decision final de desplegar puede ser manual.

**Despliegue Continuo (CD - Continuous Deployment)** va un paso mas alla: cada cambio que pasa las pruebas se despliega **automaticamente** a produccion sin intervencion humana. Este nivel requiere un alto grado de confianza en las pruebas automatizadas.

#### Pipelines

Un **pipeline** es la implementacion concreta de CI/CD: una secuencia de etapas automatizadas que se ejecutan en orden. Un pipeline tipico incluye:

```
Codigo → Build → Test → Analisis → Imagen → Deploy (staging) → Deploy (produccion)
```

Los pipelines pueden implementarse con diversas herramientas: Jenkins, Tekton, GitHub Actions, GitLab CI, Azure DevOps Pipelines, entre otras. La eleccion de la herramienta depende del contexto tecnologico de la organizacion.

### 2.3.2 GitOps

**GitOps** es un modelo operativo que usa **Git como unica fuente de verdad** para la infraestructura y la configuracion de las aplicaciones. Fue formalizado por Weaveworks en 2017, aunque los principios que lo sustentan existian antes.

Los principios fundamentales de GitOps son:

1. **Declarativo**: toda la infraestructura y configuracion se define de forma declarativa (YAML, Helm charts, Kustomize, etc.), no con scripts imperativos.
2. **Versionado en Git**: el estado deseado de todo el sistema se almacena en un repositorio Git. Git actua como registro de auditoria, fuente de verdad y mecanismo de colaboracion.
3. **Automatizado**: los cambios aprobados en Git se aplican automaticamente al entorno objetivo. No se realizan cambios manuales directamente en el cluster.
4. **Reconciliacion continua**: un agente observa constantemente si el estado real del cluster coincide con el estado deseado en Git. Si hay diferencias (drift), las corrige automaticamente.

#### Por que Git como fuente de verdad

Git no fue elegido arbitrariamente. Tiene propiedades que lo hacen ideal para gestionar infraestructura:

- **Historial completo**: cada cambio queda registrado con autor, fecha y mensaje. Esto constituye un log de auditoria natural.
- **Branching y merging**: permite trabajar en cambios de forma aislada y revisarlos antes de aplicarlos (Pull Requests / Merge Requests).
- **Revertibilidad**: si un cambio causa problemas, revertir a un estado anterior es tan simple como un `git revert`.
- **Colaboracion**: multiples personas pueden proponer, revisar y aprobar cambios de forma controlada.

#### Push vs Pull model

Existen dos modelos para aplicar los cambios desde Git al cluster:

- **Push model**: un sistema externo (pipeline, CI/CD) se conecta al cluster y aplica los cambios. Requiere que el sistema externo tenga credenciales de acceso al cluster.
- **Pull model**: un agente **dentro** del cluster observa el repositorio Git y aplica los cambios cuando detecta diferencias. No requiere acceso externo al cluster.

**Argo CD**, la herramienta adoptada en el caso de estudio, opera con el **pull model**, lo que mejora la seguridad ya que el cluster no necesita exponer credenciales de escritura al exterior.

### 2.3.3 Infraestructura como Codigo (IaC)

**Infraestructura como Codigo (Infrastructure as Code - IaC)** es la practica de gestionar y aprovisionar infraestructura a traves de archivos de definicion legibles por maquinas, en lugar de procesos manuales o herramientas interactivas.

La idea central es: **si la infraestructura se define en codigo, se puede versionar, revisar, testear y reproducir como cualquier otro software**.

Beneficios clave de IaC:

- **Reproducibilidad**: un entorno se puede recrear exactamente a partir de su definicion en codigo.
- **Consistencia**: se elimina la variabilidad introducida por procedimientos manuales ("configuration drift").
- **Auditabilidad**: los cambios quedan registrados en el historial del repositorio.
- **Velocidad**: provisionar un nuevo entorno pasa de horas o dias a minutos.
- **Documentacion viva**: el codigo es la documentacion. Si quieres saber que hay desplegado, miras el repositorio.

En el contexto de Kubernetes y OpenShift, IaC se materializa en los **manifiestos** (archivos YAML) que definen los recursos del cluster, y en herramientas como **Helm** y **Kustomize** que permiten gestionarlos de forma escalable.

---

## 2.4 Herramientas clave

### 2.4.1 Argo CD

**Argo CD** es una herramienta de entrega continua declarativa para Kubernetes que implementa los principios de GitOps. Es un proyecto graduado de la CNCF (Cloud Native Computing Foundation) y se ha convertido en el estandar de facto para GitOps en ecosistemas Kubernetes.

#### Como funciona

Argo CD se instala como un conjunto de componentes dentro del cluster de Kubernetes/OpenShift. Su funcionamiento se basa en el concepto de **Application**:

1. Se define una **Application** en Argo CD que apunta a:
   - Un **repositorio Git** que contiene los manifiestos.
   - Un **path** dentro del repositorio.
   - Un **cluster y namespace** de destino.
2. Argo CD **observa** continuamente el repositorio Git.
3. Cuando detecta una diferencia entre lo que dice Git y lo que esta en el cluster, marca la aplicacion como **OutOfSync**.
4. Dependiendo de la configuracion, puede **sincronizar automaticamente** o esperar aprobacion manual.
5. Si alguien modifica un recurso directamente en el cluster (sin pasar por Git), Argo CD detecta el **drift** y puede revertirlo.

#### Conceptos principales

- **Application**: recurso que representa una aplicacion gestionada por Argo CD. Define la fuente (repo Git), el destino (cluster/namespace) y la politica de sincronizacion.
- **AppProject**: agrupacion logica de Applications que permite definir politicas de acceso (que repos se pueden usar, a que clusters se puede desplegar, que recursos se permiten).
- **Sync**: accion de aplicar los cambios de Git al cluster.
- **Health Status**: Argo CD evalua si los recursos desplegados estan funcionando correctamente (Healthy, Degraded, Progressing, etc.).
- **Sync Status**: indica si el estado del cluster coincide con Git (Synced vs OutOfSync).

#### Interfaz y usabilidad

Argo CD provee:
- **Interfaz web**: permite ver el estado de todas las aplicaciones, su arbol de recursos, logs, eventos y diferencias entre el estado deseado y el real.
- **CLI**: herramienta de linea de comandos para gestionar aplicaciones.
- **API REST y gRPC**: para integracion con otras herramientas y automatizacion.

### 2.4.2 Helm

**Helm** es un gestor de paquetes para Kubernetes, frecuentemente descrito como "el apt/yum de Kubernetes". Permite empaquetar, distribuir y gestionar aplicaciones de Kubernetes como unidades reutilizables llamadas **charts**.

#### El problema que resuelve

Desplegar una aplicacion en Kubernetes tipicamente requiere multiples archivos YAML: un Deployment, un Service, un ConfigMap, un Ingress, etc. Cuando se tienen multiples entornos (desarrollo, staging, produccion) o multiples aplicaciones con configuraciones similares, gestionar estos archivos manualmente se vuelve repetitivo y propenso a errores.

Helm resuelve esto con:

- **Charts**: paquetes que contienen todos los manifiestos necesarios para desplegar una aplicacion, con la capacidad de parametrizarlos.
- **Templates**: los manifiestos dentro de un chart usan el lenguaje de templates de Go, lo que permite generar YAML dinamicamente en funcion de valores de entrada.
- **Values**: archivo (`values.yaml`) que define los parametros de configuracion de un chart. Cada entorno puede tener su propio archivo de values.
- **Releases**: cada instalacion de un chart en un cluster es un "release" con nombre, version y configuracion especifica.

#### Estructura de un Helm chart

```
mi-aplicacion/
├── Chart.yaml          # Metadatos del chart (nombre, version, descripcion)
├── values.yaml         # Valores por defecto
├── templates/          # Manifiestos con templates
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   └── ingress.yaml
└── charts/             # Dependencias (sub-charts)
```

#### Ejemplo conceptual

En lugar de tener un Deployment hardcodeado con 3 replicas y una imagen especifica:

```yaml
# Sin Helm - hardcodeado
replicas: 3
image: mi-app:1.2.3
```

Con Helm, se parametriza:

```yaml
# Con Helm - template
replicas: {{ .Values.replicas }}
image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
```

Y los valores se definen por entorno:

```yaml
# values-produccion.yaml
replicas: 3
image:
  repository: mi-app
  tag: 1.2.3

# values-desarrollo.yaml
replicas: 1
image:
  repository: mi-app
  tag: latest
```

Esto permite mantener una unica definicion de la aplicacion y variar solo lo que cambia entre entornos.

### 2.4.3 Kustomize

**Kustomize** es una herramienta nativa de Kubernetes para personalizar manifiestos YAML **sin usar templates**. A diferencia de Helm, Kustomize trabaja directamente sobre manifiestos YAML validos y los modifica mediante parches y superposiciones.

#### Enfoque: bases y overlays

El modelo de Kustomize se basa en dos conceptos:

- **Base**: los manifiestos originales de la aplicacion, tal como estan.
- **Overlays**: modificaciones especificas para un entorno o caso de uso, que se aplican sobre la base.

```
mi-aplicacion/
├── base/
│   ├── kustomization.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── overlays/
│   ├── desarrollo/
│   │   └── kustomization.yaml    # Modifica replicas=1
│   └── produccion/
│       └── kustomization.yaml    # Modifica replicas=3, agrega recursos
```

#### Helm vs Kustomize

Ambas herramientas resuelven el problema de gestionar manifiestos para multiples entornos, pero con filosofias diferentes:

| Aspecto | Helm | Kustomize |
|---|---|---|
| Enfoque | Templates parametrizados | Parches sobre YAML valido |
| Complejidad | Mayor (lenguaje de templates Go) | Menor (YAML puro) |
| Curva de aprendizaje | Media-alta | Baja |
| Ecosistema | Amplio catalogo de charts publicos | Integrado en kubectl |
| Caso de uso ideal | Paquetes reutilizables, distribucion | Personalizacion por entorno |

En la practica, **Helm y Kustomize no son mutuamente excluyentes**. Muchas organizaciones usan Helm para empaquetar aplicaciones y Kustomize para personalizar los manifiestos resultantes por entorno. Argo CD soporta ambas herramientas de forma nativa.

### 2.4.4 Red Hat Developer Hub

**Red Hat Developer Hub** es la distribucion empresarial de **Backstage**, un framework de codigo abierto creado por Spotify para construir portales de desarrollo internos (Internal Developer Portals - IDP).

#### El problema que resuelve

A medida que una organizacion crece en equipos y servicios, surgen problemas de descubrimiento y autonomia:

- "¿Donde esta la documentacion de este servicio?"
- "¿Como creo un nuevo proyecto que cumpla con los estandares?"
- "¿Quien es el dueño de este componente?"
- "¿Que version esta desplegada en produccion?"

Developer Hub centraliza esta informacion en un **portal unico** que sirve como punto de entrada para los desarrolladores.

#### Capacidades principales

- **Catalogo de software**: registro centralizado de todos los servicios, librerias y componentes de la organizacion, con informacion de ownership, documentacion y estado.
- **Software Templates**: plantillas que permiten a los desarrolladores crear nuevos proyectos con la estructura, pipelines, manifiestos y configuraciones estandar, sin necesidad de conocer todos los detalles de la plataforma.
- **Plugins**: arquitectura extensible que permite integrar herramientas existentes (Argo CD, Kubernetes, Git, CI/CD, monitoreo, etc.) en una unica interfaz.
- **TechDocs**: documentacion tecnica integrada, generada a partir de archivos Markdown en los repositorios de codigo.

#### Rol en la modernizacion

En el contexto de esta tesis, Developer Hub tiene un rol especifico: **facilitar el onboarding de nuevos equipos a la plataforma OpenShift**. En lugar de que cada equipo tenga que aprender desde cero como crear namespaces, configurar pipelines, definir manifiestos y conectar con Argo CD, un Software Template puede automatizar todo eso con unos pocos clicks.

Esto transforma el proceso de onboarding de "hablar con el equipo de plataforma y esperar dias" a "usar el portal y tener todo listo en minutos".

### 2.4.5 Ansible

**Ansible** es una herramienta de automatizacion de TI desarrollada por Red Hat. Se utiliza para gestionar configuraciones, desplegar aplicaciones, orquestar tareas complejas y aprovisionar infraestructura.

#### Caracteristicas principales

- **Sin agentes (agentless)**: Ansible no requiere instalar software en los nodos que gestiona. Se conecta via SSH (Linux) o WinRM (Windows) y ejecuta las tareas.
- **Lenguaje declarativo (YAML)**: las tareas se definen en archivos YAML llamados **playbooks**, que describen el estado deseado de un sistema.
- **Idempotencia**: ejecutar un playbook multiples veces produce el mismo resultado. Si el sistema ya esta en el estado deseado, Ansible no hace cambios.
- **Inventarios**: listas de hosts agrupados que definen sobre que maquinas se ejecutan las tareas.
- **Roles y Collections**: mecanismos de empaquetado y reutilizacion de automatizaciones.

#### Ejemplo de playbook

```yaml
- name: Configurar servidor web
  hosts: webservers
  tasks:
    - name: Instalar nginx
      package:
        name: nginx
        state: present

    - name: Iniciar servicio nginx
      service:
        name: nginx
        state: started
        enabled: true
```

#### Ansible en el contexto de OpenShift

En el caso de estudio, Ansible se utiliza para:

- **Automatizacion de tareas de plataforma**: configuracion de clusters, gestion de usuarios, aplicacion de politicas.
- **Aprovisionamiento de infraestructura**: creacion de recursos que no son propios de Kubernetes (VMs, configuraciones de red, integraciones externas).
- **Operaciones repetitivas**: tareas de mantenimiento, actualizaciones, backups que se ejecutan de forma programada.

Ansible complementa a las herramientas de GitOps (Argo CD) cubriendo el espacio de automatizacion **fuera** del cluster de Kubernetes, donde las herramientas cloud-native no llegan.

---

## 2.5 Patrones de arquitectura

### 2.5.1 Patron App of Apps

El patron **App of Apps** es un patron de gestion declarativa de aplicaciones en Argo CD. Resuelve el problema de escalar GitOps cuando se tienen muchas aplicaciones.

#### El problema

Cuando una organizacion tiene pocas aplicaciones, crear un recurso Application de Argo CD para cada una es manejable. Pero cuando se tienen decenas o cientos de aplicaciones, gestionarlas individualmente se vuelve inviable:

- ¿Quien crea las Applications?
- ¿Donde se definen?
- ¿Como se asegura la consistencia?
- ¿Como se agregan nuevas aplicaciones sin intervencion manual?

#### La solucion

El patron App of Apps consiste en crear una **Application "raiz"** que, en lugar de apuntar a los manifiestos de una aplicacion, apunta a un directorio que contiene **definiciones de otras Applications**. Es decir, una Application que gestiona Applications.

```
repo-de-apps/
├── apps/                          # La app raiz apunta aca
│   ├── app-frontend.yaml          # Application de Argo CD
│   ├── app-backend.yaml           # Application de Argo CD
│   ├── app-api.yaml               # Application de Argo CD
│   └── app-monitoring.yaml        # Application de Argo CD
```

Cuando Argo CD sincroniza la app raiz, crea (o actualiza) todas las Applications hijas. Cada Application hija a su vez apunta al repositorio Git correspondiente con los manifiestos de su aplicacion.

#### Beneficios

- **Gestion centralizada**: todas las aplicaciones se definen en un unico lugar.
- **Automatizacion**: agregar una nueva aplicacion es tan simple como agregar un archivo YAML al directorio y hacer un commit.
- **Consistencia**: las politicas (sync policy, project, destino) se pueden estandarizar.
- **Escalabilidad**: funciona igual con 5 aplicaciones que con 500.
- **Auditabilidad**: el historial de Git muestra cuando se agrego, modifico o elimino cada aplicacion.

#### Variantes

El patron tiene variantes segun la complejidad de la organizacion:

- **App of Apps simple**: una app raiz que gestiona todas las apps.
- **App of Apps por entorno**: una app raiz por entorno (desarrollo, staging, produccion), cada una apuntando a un directorio o branch diferente.
- **App of Apps jerarquico**: una app raiz que gestiona apps intermedias, que a su vez gestionan las apps finales. Util para organizaciones con multiples equipos y clusters.

### 2.5.2 Operadores de Kubernetes

Los **Operadores** son un patron de Kubernetes que extiende la plataforma para gestionar aplicaciones complejas de forma automatizada. Encapsulan conocimiento operativo (que normalmente estaria en la cabeza de un administrador) en software.

Un operador tipicamente:

1. Define un **Custom Resource (CR)**: un nuevo tipo de recurso en Kubernetes que representa la aplicacion o servicio.
2. Implementa un **controller**: un programa que observa los CRs y toma acciones para alcanzar el estado deseado.
3. Automatiza operaciones: instalacion, actualizacion, backup, recuperacion ante fallos, escalado, etc.

Por ejemplo, un operador de base de datos podria:
- Crear automaticamente un cluster de PostgreSQL cuando el usuario define un CR `PostgresCluster`.
- Gestionar replicas, failover y backups sin intervencion manual.
- Actualizarse a nuevas versiones de forma controlada.

OpenShift hace uso extensivo de operadores, tanto para sus propios componentes internos como para aplicaciones de terceros a traves del **OperatorHub**.

---

## 2.6 Resumen del capitulo

Los conceptos presentados en este capitulo forman la base teorica sobre la que se construye el proceso de modernizacion descrito en esta tesis:

| Concepto | Relevancia en la tesis |
|---|---|
| Contenedores | Unidad fundamental de despliegue en la nueva plataforma |
| Kubernetes / OpenShift | Plataforma de orquestacion que reemplaza a IIS |
| Modelo hibrido | Arquitectura adoptada: on-prem + ARO |
| CI/CD | Automatizacion del ciclo de build y deploy |
| GitOps | Modelo operativo basado en Git como fuente de verdad |
| Infraestructura como codigo | Definicion declarativa de toda la plataforma |
| Argo CD | Herramienta que implementa GitOps |
| Helm / Kustomize | Gestion de manifiestos para multiples entornos |
| Developer Hub | Portal para onboarding de equipos |
| Ansible | Automatizacion de tareas fuera de Kubernetes |
| App of Apps | Patron para escalar GitOps a muchas aplicaciones |

En los capitulos siguientes, se vera como estos conceptos se fueron adoptando progresivamente en la organizacion, desde los primeros pasos con comandos manuales hasta la plataforma actual.
