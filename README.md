# Tesis de Ingenieria Informatica

## Modernizacion de Infraestructura: De IIS On-Premises a OpenShift con GitOps

### Autor
Nicolas Miretti

---

## Idea General

Esta tesis documenta el proceso de modernizacion tecnologica de una empresa, transitando desde una infraestructura tradicional basada en **IIS on-premises** con herramientas de CI/CD obsoletas, hacia un modelo cloud-native basado en **Red Hat OpenShift** con practicas de **GitOps**.

## Contexto Inicial (El "Antes")

- Aplicaciones desplegadas sobre **IIS (Internet Information Services)** en servidores on-premises.
- Procesos de deploy manuales o con herramientas de CI/CD desactualizadas.
- Sin estandarizacion en la forma de desplegar y operar aplicaciones.
- Conocimiento concentrado en pocas personas.

## El Viaje de Modernizacion (Evolucion)

El proceso no fue lineal ni instantaneo. Paso por varias etapas que reflejan la madurez del equipo y la plataforma:

### Etapa 1 - Primeros pasos con OpenShift
- Llegada de OpenShift al entorno.
- Todo se creaba con **comandos manuales** (`oc create`, `oc apply`, etc.).
- Curva de aprendizaje alta, sin automatizacion.

### Etapa 2 - Automatizacion con scripts
- Desarrollo de un **script en Python** para estandarizar la creacion de recursos.
- Primer intento de reducir el trabajo manual y los errores humanos.
- Limitaciones: dificil de mantener, sin versionado real de la infra.

### Etapa 3 - Pipelines de CI/CD
- Implementacion de **pipelines** para build y deploy.
- Primeros pasos hacia la automatizacion real del ciclo de vida.
- Mejora en la trazabilidad y repetibilidad de los despliegues.

### Etapa 4 - GitOps y App of Apps
- Adopcion de **Argo CD** como motor de GitOps.
- Patron **App of Apps** para gestionar multiples aplicaciones de forma declarativa.
- **Infraestructura como codigo**: todo lo que se despliega esta versionado en Git.
- Buenas practicas: revisiones por PR, ambientes separados, sincronizacion automatica.

### Etapa 5 - Plataforma completa (objetivo)
- **Red Hat Developer Hub** como portal de desarrollo interno.
- **Ansible** para automatizacion de tareas operativas y de plataforma.
- Onboarding de nuevos equipos a la plataforma de forma autonoma.
- Estandarizacion completa del ciclo de vida de las aplicaciones.

## Stack Tecnologico

| Componente | Tecnologia |
|---|---|
| Plataforma de contenedores | Red Hat OpenShift |
| GitOps / Continuous Delivery | Argo CD |
| Portal de desarrollo | Red Hat Developer Hub |
| Automatizacion operativa | Ansible |
| Infraestructura como codigo | Helm / Kustomize + Git |
| CI/CD anterior | Herramientas legacy (a detallar) |
| Hosting anterior | IIS on-premises |

## Enfoque de la Tesis

- **Narrativa evolutiva**: el eje central es mostrar como la infraestructura y los procesos fueron madurando etapa por etapa.
- **Antes vs Despues**: cada capitulo o seccion puede contrastar el estado previo con el estado logrado.
- **Leciones aprendidas**: documentar los problemas encontrados, decisiones tomadas y por que.
- **Impacto organizacional**: como afecto a los equipos de desarrollo, operaciones y al negocio.

## Estructura Tentativa

1. **Introduccion** - Contexto de la empresa y motivacion.
2. **Marco Teorico** - Contenedores, Kubernetes, OpenShift, GitOps, IaC.
3. **Situacion Inicial** - Arquitectura legacy, problemas, limitaciones.
4. **Proceso de Modernizacion** - Las etapas descriptas arriba con detalle tecnico.
5. **Arquitectura Final** - Descripcion de la plataforma objetivo.
6. **Resultados y Metricas** - Comparacion antes/despues, mejoras obtenidas.
7. **Conclusiones y Trabajo Futuro** - Reflexiones y proximos pasos.

## Estructura del Repositorio

```
Tesis/
├── README.md              # Este archivo
├── CONTEXT.md             # Contexto para IAs que trabajen con el repo
├── docs/
│   ├── internas/          # Documentacion de la empresa (sanitizada)
│   ├── externas/          # Documentacion publica de tecnologias
│   └── diagramas/         # Arquitectura, flujos, capturas
├── fuentes/               # Material bibliografico (libros, papers, articulos)
├── tesis/
│   ├── capitulos/         # Cada capitulo en .md separado
│   └── assets/            # Imagenes y recursos del documento
└── ejemplos/
    ├── antes/             # Scripts, configs IIS, herramientas legacy
    └── despues/           # Helm, ArgoCD, Ansible, pipelines modernos
```

---

> Este documento es un punto de partida. Se ira refinando a medida que avance el desarrollo de la tesis.
