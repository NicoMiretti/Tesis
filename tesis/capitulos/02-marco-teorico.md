# Marco Teorico

Este capitulo presenta los conceptos fundamentales necesarios para comprender las tecnologias, practicas y decisiones que se describen en el resto de la tesis. El capitulo comienza describiendo la infraestructura tradicional (el punto de partida) para luego introducir progresivamente las tecnologias y practicas que conforman la plataforma moderna.

---

## Infraestructura tradicional

### Servidores fisicos y maquinas virtuales

Un **servidor** es una computadora diseñada para ejecutar aplicaciones y ofrecer servicios de forma continua. En el modelo tradicional, cada aplicacion se instala directamente sobre el sistema operativo del servidor. Este esquema, si bien simple, genera desperdicio de recursos: un servidor que usa solo el 10% de su capacidad sigue consumiendo energia y mantenimiento como si usara el 100%.

Las **maquinas virtuales (VMs)** surgieron como solucion a este problema. Una VM es una emulacion por software de una computadora completa que corre dentro de un servidor fisico, gestionada por un **hipervisor** (como VMware vSphere o Hyper-V). Esto permite ejecutar multiples VMs sobre un mismo servidor, mejorando la eficiencia (VMware, 2023). Sin embargo, cada VM incluye una copia completa del sistema operativo, lo que las hace pesadas (gigabytes de tamaño, minutos de arranque) y costosas en terminos de licenciamiento.

### IIS (Internet Information Services)

**IIS** es el servidor web de Microsoft, integrado en Windows Server. Es la plataforma sobre la cual se despliegan aplicaciones desarrolladas con tecnologias Microsoft como ASP.NET (Microsoft, 2024a). Un servidor web recibe solicitudes HTTP/HTTPS de los usuarios y responde con el contenido solicitado.

IIS utiliza **Application Pools** como mecanismo de aislamiento entre aplicaciones dentro del mismo servidor, y se configura a traves de una interfaz grafica (IIS Manager) o archivos XML (Microsoft, 2024b). El proceso de despliegue tipico implica copiar archivos al servidor, configurar el sitio y el Application Pool manualmente.

Si bien IIS es una tecnologia madura, presenta limitaciones al operar a escala: esta acoplado a Windows Server, el escalado requiere configuracion manual de servidores adicionales, no ofrece auto-recuperacion ante fallos entre servidores, y la configuracion tiende a divergir entre servidores con el tiempo (configuration drift).

---

## Contenedores

### El concepto

Un **contenedor** es una unidad de software que empaqueta una aplicacion junto con todas sus dependencias de manera que pueda ejecutarse de forma consistente en cualquier entorno (Docker, 2024). A diferencia de las maquinas virtuales, los contenedores no incluyen un sistema operativo completo: comparten el kernel del host, lo que los hace significativamente mas livianos (megabytes en lugar de gigabytes, segundos de arranque en lugar de minutos).

**Docker**, lanzado en 2013, fue la herramienta que popularizo los contenedores al simplificar su construccion y distribucion (Merkel, 2014). La **Open Container Initiative (OCI)**, fundada en 2015 bajo la Linux Foundation, estandarizo el formato de imagenes y runtimes para evitar la dependencia de un unico proveedor (OCI, 2015).

### Por que contenedores en lugar de IIS

La diferencia fundamental es el modelo de empaquetado y despliegue. En IIS, la aplicacion depende de la configuracion del servidor donde se instala. En contenedores, la aplicacion lleva consigo todo lo que necesita: misma imagen, mismo comportamiento en cualquier entorno. Esto resuelve problemas estructurales de consistencia, portabilidad y escalabilidad que plataformas como IIS no fueron diseñadas para manejar. Los detalles tecnicos y ejemplos concretos de esta comparacion se desarrollan en los capitulos de implementacion.

---

## Orquestacion de contenedores

### Kubernetes

Gestionar contenedores individualmente es viable con pocas aplicaciones, pero una organizacion con decenas o cientos necesita automatizar decisiones como: en que servidor correr cada contenedor, que hacer si uno falla, como escalar ante mayor demanda, y como gestionar la comunicacion entre servicios.

**Kubernetes** (K8s) es la plataforma de orquestacion de contenedores estandar de la industria, originalmente desarrollada por Google basandose en su experiencia interna con el sistema Borg (Burns et al., 2016), y donada a la **Cloud Native Computing Foundation (CNCF)** en 2015. Automatiza el scheduling, la alta disponibilidad, el escalado, el networking y las actualizaciones de aplicaciones en contenedores.

Un aspecto fundamental es su **modelo declarativo**: el usuario describe el estado deseado (por ejemplo, "se requieren 3 replicas de esta aplicacion") y Kubernetes se encarga de alcanzarlo y mantenerlo (The Kubernetes Authors, 2024). Esto contrasta con el modelo imperativo donde cada accion se ejecuta manualmente.

Los conceptos basicos de Kubernetes necesarios para esta tesis (pods, deployments, services, namespaces, configmaps, secrets, ingress) se introducen con detalle en los capitulos donde se aplican.

### Red Hat OpenShift

**Red Hat OpenShift** es una plataforma de contenedores empresarial construida sobre Kubernetes. Agrega seguridad reforzada por defecto (Security Context Constraints, RBAC), consola web integrada, construccion de imagenes desde codigo fuente, un catalogo de operadores (OperatorHub), y soporte empresarial de Red Hat (Red Hat, 2024a).

La diferencia con Kubernetes sin modificaciones es el nivel de abstraccion: OpenShift incluye todo lo necesario para operar en produccion sin que la organizacion tenga que ensamblar y mantener cada componente por su cuenta.

---

## Modelos de despliegue

Existen tres modelos principales para ubicar la infraestructura:

- **On-premises**: servidores en un data center propio. Control total pero inversion de capital alta, escalabilidad limitada y responsabilidad operativa completa.
- **Cloud publica**: infraestructura de un proveedor externo (Azure, AWS, GCP). Elasticidad y modelo de gasto operativo (OpEx), pero con riesgo de dependencia del proveedor (vendor lock-in) y costos potencialmente mayores a largo plazo.
- **Hibrido**: combina ambos, distribuyendo cargas de trabajo estrategicamente. Es el modelo adoptado en esta tesis: OpenShift on-premises como plataforma principal para las aplicaciones de la empresa, y **ARO (Azure Red Hat OpenShift)** para soluciones empaquetadas y servicios gestionados que se benefician de un entorno en la nube (por ejemplo, herramientas de gestion de identidad).

**ARO** es un servicio gestionado conjuntamente por Microsoft y Red Hat, donde ambos administran el plano de control del cluster, permitiendo que la empresa se enfoque en la configuracion del servicio sin gestionar la infraestructura subyacente (Microsoft, 2024c). Un manifiesto que funciona en OpenShift on-premises funciona igual en ARO, lo que facilita la consistencia.

---

## Conceptos fundamentales de desarrollo y operaciones

### Control de versiones y Git

**Git** es un sistema de control de versiones creado por Linus Torvalds en 2005 (Chacon y Straub, 2014) que registra los cambios sobre archivos a lo largo del tiempo, permitiendo saber quien cambio que, cuando y por que. Sus conceptos clave incluyen **repositorios**, **commits** (instantaneas del estado), **branches** (lineas de desarrollo independientes) y **Pull Requests** (mecanismo de revision de cambios).

En esta tesis, Git se utiliza no solo para codigo fuente sino tambien para versionar infraestructura (manifiestos, configuraciones), lo que constituye la base de GitOps.

### YAML

**YAML** (YAML Ain't Markup Language) es un formato de serializacion de datos diseñado para ser legible por humanos (Ben-Kiki et al., 2021). Es el formato estandar para configuraciones en Kubernetes, OpenShift, Ansible, Helm y practicamente todo el ecosistema descrito en esta tesis. Usa indentacion para definir jerarquias y soporta tipos de datos simples.

### Entornos de despliegue

En el desarrollo profesional, las aplicaciones se validan progresivamente a traves de multiples entornos: **desarrollo**, **testing/QA**, **staging** (replica de produccion) y **produccion**. La existencia de multiples entornos introduce el desafio de mantener la consistencia entre ellos, problema que los contenedores y las herramientas de gestion de configuracion ayudan a resolver.

### DevOps

**DevOps** es una cultura y conjunto de practicas que buscan unificar desarrollo (Dev) y operaciones (Ops), dos areas historicamente separadas (Kim et al., 2016). Propone responsabilidad compartida, automatizacion, colaboracion, retroalimentacion rapida y mejora continua. El proceso de modernizacion descrito en esta tesis es, en esencia, la implementacion practica de una cultura DevOps.

### Monolitos y microservicios

Un **monolito** es una aplicacion donde toda la funcionalidad esta en un unico programa que se despliega como una sola unidad. Los **microservicios** descomponen la aplicacion en servicios pequeños e independientes (Newman, 2021). Es importante aclarar que contenedores no implican microservicios: un monolito puede correr en un contenedor obteniendo beneficios de portabilidad sin necesidad de descomponerlo.

---

## Practicas de entrega de software

### Integracion y Entrega Continua (CI/CD)

**CI/CD** automatiza el ciclo de vida de entrega de software (Humble y Farley, 2010). La **Integracion Continua (CI)** consiste en integrar cambios frecuentemente, disparando compilacion y pruebas automatizadas para detectar problemas tempranamente. La **Entrega Continua (CD)** asegura que el software este siempre en estado desplegable. Un **pipeline** es la implementacion concreta: una secuencia de etapas automatizadas (construccion, pruebas, analisis, despliegue) que actuan como puertas de calidad.

### GitOps

**GitOps** es un modelo operativo que usa Git como unica fuente de verdad para la infraestructura y las aplicaciones. Fue formalizado por Weaveworks en 2017 (Weaveworks, 2017). Sus principios son: definicion declarativa, estado versionado en Git, aplicacion automatizada y reconciliacion continua (un agente detecta y corrige diferencias entre Git y el cluster).

Existen dos modelos de aplicacion: **push** (un sistema externo aplica cambios al cluster) y **pull** (un agente dentro del cluster observa Git y aplica cambios). Argo CD, la herramienta adoptada en esta tesis, opera con el modelo pull, mejorando la seguridad al no requerir acceso externo al cluster.

### Infraestructura como Codigo (IaC)

**Infraestructura como Codigo** es la practica de gestionar infraestructura a traves de archivos de definicion en lugar de procesos manuales (Morris, 2020). Esto permite reproducir entornos de forma exacta, eliminar la variabilidad manual (configuration drift) y mantener un registro auditable de todos los cambios. En el contexto de Kubernetes, se materializa en manifiestos YAML y herramientas como Helm y Kustomize.

---

## Herramientas clave

### Argo CD

**Argo CD** es una herramienta de entrega continua declarativa para Kubernetes que implementa los principios de GitOps. Es un proyecto graduado de la CNCF (Argo Project, 2024). Se instala dentro del cluster, observa repositorios Git y sincroniza el estado del cluster con lo definido en Git. Sus conceptos principales son **Application** (unidad de trabajo que vincula un repositorio Git con un destino en el cluster), **AppProject** (agrupacion con politicas de acceso) y los estados de sincronizacion y salud.

### Helm

**Helm** es un gestor de paquetes para Kubernetes que permite empaquetar aplicaciones como **charts** reutilizables (Helm Authors, 2024). Un chart contiene los manifiestos de la aplicacion como templates parametrizables, y un archivo de **values** define la configuracion por entorno. Esto permite mantener una unica definicion de la aplicacion y variar solo lo necesario entre entornos.

### Kustomize

**Kustomize** es una herramienta nativa de Kubernetes para personalizar manifiestos sin utilizar templates. Trabaja con **bases** (manifiestos originales) y **overlays** (modificaciones por entorno) aplicando parches sobre YAML valido (The Kubernetes Authors, 2024). Helm y Kustomize no son mutuamente excluyentes y Argo CD soporta ambas.

### Red Hat Developer Hub

**Red Hat Developer Hub** es la distribucion empresarial de **Backstage**, un framework de codigo abierto creado por Spotify para construir portales de desarrollo internos (Spotify, 2020). Centraliza el catalogo de servicios, ofrece **Software Templates** para crear proyectos estandarizados de forma autonoma, e integra herramientas existentes mediante plugins. En el contexto de esta tesis, se plantea su uso para facilitar el onboarding de nuevos equipos a la plataforma.

### Ansible

**Ansible** es una herramienta de automatizacion desarrollada por Red Hat (Red Hat, 2024b). Se conecta a las maquinas sin requerir agentes instalados (via SSH o WinRM), usa YAML para definir tareas (**playbooks**) y es idempotente (ejecutar multiples veces produce el mismo resultado). En el contexto de esta tesis, Ansible complementa a Argo CD automatizando tareas fuera del cluster: configuracion de infraestructura, integracion con sistemas existentes y operaciones de mantenimiento.

---

## Patrones de arquitectura

### App of Apps

El patron **App of Apps** resuelve el problema de escalar GitOps a muchas aplicaciones (Argo Project, 2024). Consiste en una Application de Argo CD "raiz" que gestiona las definiciones de otras Applications. Agregar una nueva aplicacion es tan simple como agregar un archivo YAML al repositorio. El patron tiene variantes: simple, por entorno, y jerarquico para organizaciones grandes.

### Operadores de Kubernetes

Los **Operadores** extienden Kubernetes para gestionar aplicaciones complejas (bases de datos, brokers de mensajes) de forma automatizada. Encapsulan conocimiento operativo en software, definiendo **Custom Resources** y controladores que mantienen el estado deseado (Dobies y Wood, 2020). OpenShift utiliza operadores extensivamente, tanto para sus componentes internos como para aplicaciones de terceros a traves del OperatorHub.

---

## Resumen del capitulo

| Concepto | Relevancia en la tesis |
|---|---|
| IIS / Infraestructura tradicional | Punto de partida de la modernizacion |
| Contenedores | Unidad fundamental de despliegue en la nueva plataforma |
| Kubernetes / OpenShift | Plataforma de orquestacion que reemplaza el modelo IIS |
| Modelo hibrido (on-prem + ARO) | Arquitectura de despliegue adoptada |
| Git / DevOps | Base cultural y tecnica de la transformacion |
| CI/CD / GitOps / IaC | Practicas de entrega de software adoptadas |
| Argo CD / Helm / Kustomize | Herramientas de implementacion de GitOps e IaC |
| Developer Hub / Ansible | Herramientas de onboarding y automatizacion |
| App of Apps / Operadores | Patrones para escalar la plataforma |

Los detalles tecnicos, ejemplos de configuracion y comparativas en profundidad se desarrollan en los capitulos de implementacion, donde cada concepto se aplica al caso concreto de la empresa.
