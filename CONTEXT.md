# CONTEXT.md - Guia de Contexto para IA

> Este archivo sirve como punto de entrada para cualquier IA o persona que necesite entender este repositorio rapidamente.

## Que es este repositorio

Repositorio de trabajo para la **tesis de Ingenieria Informatica** de Nicolas Miretti. Contiene la documentacion, fuentes, ejemplos y borradores de capitulos.

## Tema de la Tesis

**Modernizacion de infraestructura: de IIS on-premises a OpenShift con GitOps.**

Se documenta el proceso real de transformacion tecnologica de una empresa, desde una infraestructura legacy basada en IIS con deploys manuales, hacia una plataforma basada en OpenShift (on-premises y ARO en Azure), Argo CD, GitOps e infraestructura como codigo. No es una migracion a cloud puro, sino un modelo hibrido.

## Enfoque Principal

El eje narrativo es la **evolucion progresiva** del proceso. No fue un cambio instantaneo, sino una transicion por etapas:

1. **Comandos manuales** - Todo se creaba a mano con `oc` CLI al llegar OpenShift.
2. **Script Python** - Se automatizo parcialmente con un `.py` custom.
3. **Pipelines** - Se implementaron pipelines de CI/CD.
4. **GitOps + App of Apps** - Argo CD, infraestructura declarativa, patron App of Apps.
5. **Plataforma completa** - Developer Hub, Ansible, onboarding de equipos, buenas practicas.

Cada etapa se contrasta con un "antes vs despues".

## Stack Tecnologico

- **Antes**: IIS, Windows Server, deploys manuales, herramientas CI/CD legacy.
- **Despues**: Red Hat OpenShift (on-prem) + ARO (Azure), Argo CD, Helm/Kustomize, Red Hat Developer Hub, Ansible.

## Estructura del Repositorio

```
Tesis/
├── README.md              # Vision general de la tesis
├── CONTEXT.md             # ESTE ARCHIVO - Contexto para IA
├── .gitignore             # Archivos ignorados
│
├── docs/                  # Documentacion de referencia
│   ├── internas/          # Docs de la empresa (sanitizadas)
│   ├── externas/          # Docs publicas de tecnologias
│   └── diagramas/         # Arquitectura, flujos, capturas
│
├── fuentes/               # Material bibliografico
│   ├── libros/
│   ├── papers/
│   └── articulos/
│
├── tesis/                 # El documento de la tesis
│   ├── capitulos/         # Cada capitulo en .md separado
│   └── assets/            # Imagenes y recursos del documento
│
└── ejemplos/              # Codigo y configuraciones reales
    ├── antes/             # Como se hacia antes (scripts, configs IIS)
    └── despues/           # Como se hace ahora (Helm, ArgoCD, Ansible)
```

## Instrucciones para IA

Si sos una IA trabajando con este repo:

1. **Lee este archivo primero** para entender el contexto.
2. **Lee el README.md** para la vision general de la tesis.
3. **Revisa `tesis/capitulos/`** para ver el estado actual del documento.
4. **Consulta `docs/`** para documentacion de soporte.
5. **Mira `ejemplos/`** para entender los aspectos tecnicos con codigo real.
6. **No inventes datos tecnicos** - si no hay info suficiente, indica que falta.
7. **Mantene el tono tecnico pero accesible** - es una tesis academica, no un manual.
8. **Sanitizacion**: nunca generar IPs reales, dominios internos ni credenciales en ejemplos.

## Estado Actual

- [ ] Estructura del repo creada
- [ ] Idea general definida (README.md)
- [ ] Capitulos: pendientes de desarrollo
- [ ] Documentacion interna: pendiente de carga
- [ ] Ejemplos tecnicos: pendientes de carga
