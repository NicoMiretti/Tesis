# Introduccion

## Contexto

En los ultimos años, las organizaciones de tecnologia han enfrentado una presion creciente por acelerar la entrega de software, mejorar la confiabilidad de sus sistemas y reducir los costos operativos asociados a infraestructuras tradicionales (Forsgren et al., 2018). Lo que antes era aceptable, como servidores configurados manualmente, despliegues coordinados por correo electronico y procesos que dependian del conocimiento de unas pocas personas, hoy representa un riesgo operativo y una barrera para la competitividad.

La empresa objeto de este trabajo no es ajena a esta realidad. Durante años, su infraestructura de aplicaciones se sustento sobre **Internet Information Services (IIS)** corriendo en servidores **Windows Server on-premises**, con procesos de despliegue en su mayoria manuales y herramientas de integracion y entrega continua que fueron quedando obsoletas. Este modelo, si bien funcional en su momento, presentaba limitaciones cada vez mas evidentes: tiempos de despliegue prolongados, falta de estandarizacion entre equipos, dificultad para escalar, y una fuerte dependencia de conocimiento no documentado.

[REQUIERE INPUT DEL AUTOR: Descripcion breve de la empresa (rubro, tamaño aproximado, cantidad de equipos de desarrollo) sin datos que la identifiquen directamente.]

Frente a este escenario, la organizacion inicio un proceso de modernizacion que busca transformar la forma en que se construye, despliega y opera el software. No se trato de un cambio instantaneo ni de una migracion completa a la nube publica, sino de una **transicion progresiva** hacia un modelo hibrido basado en **Red Hat OpenShift** (tanto on-premises como en Azure a traves de **ARO - Azure Red Hat OpenShift**), incorporando practicas de **GitOps**, **infraestructura como codigo** y herramientas modernas de automatizacion.

## Problema

[REQUIERE INPUT DEL AUTOR: Confirmar o ajustar la siguiente lista de problemas. Son los que se asumen en base a las conversaciones iniciales, pero solo Nicolas puede validar cuales aplican y si falta alguno.]

El modelo de infraestructura tradicional de la empresa presentaba una serie de problemas que impactaban tanto en la operacion diaria como en la capacidad de evolucion tecnologica:

- **Despliegues manuales y propensos a error**: los despliegues en IIS requerian intervenciones manuales, lo que incrementaba el riesgo de errores humanos y hacia que cada puesta en produccion fuera un evento de alto estres.
- **Falta de estandarizacion**: cada equipo o aplicacion podia tener un proceso de despliegue diferente, dificultando la operacion, el soporte y la incorporacion de nuevos miembros.
- **Herramientas de CI/CD obsoletas**: las herramientas existentes no se adaptaban a las necesidades actuales ni permitian implementar practicas modernas de entrega continua. [REQUIERE INPUT DEL AUTOR: Indicar que herramientas de CI/CD se usaban antes, si se pueden mencionar.]
- **Conocimiento concentrado**: los procedimientos dependian del conocimiento de pocas personas, generando cuellos de botella y riesgo ante rotacion de personal.
- **Escalabilidad limitada**: escalar aplicaciones o incorporar nuevos equipos a la plataforma era un proceso lento y costoso.
- **Sin versionado de la infraestructura**: no existia un registro claro de que estaba desplegado, en que version, ni como reproducir un entorno.

Estos problemas no eran exclusivos del area de aplicaciones web. La empresa tambien operaba herramientas como **Control-M** para scheduling de procesos batch, **aplicaciones Java legacy** y **procesos de RPA (Robotic Process Automation)**, todos en proceso de evaluacion o modernizacion. Sin embargo, el alcance de esta tesis se centra en el eje principal de la transformacion: **la plataforma de contenedores y el modelo de entrega de software**.

## Objetivos

### Objetivo general

Documentar y analizar el proceso de modernizacion de la infraestructura de entrega de software de una empresa, desde un modelo basado en IIS on-premises con despliegues manuales, hacia una plataforma basada en Red Hat OpenShift con practicas de GitOps, infraestructura como codigo y automatizacion.

### Objetivos especificos

1. Describir la situacion inicial de la infraestructura y los procesos de la empresa, identificando sus limitaciones.
2. Presentar los conceptos teoricos necesarios para comprender las tecnologias y practicas adoptadas.
3. Documentar la evolucion del proceso de modernizacion a traves de sus distintas etapas, desde los primeros comandos manuales hasta la implementacion de GitOps con Argo CD.
4. Analizar las decisiones tecnicas tomadas en cada etapa y sus justificaciones.
5. Evaluar los resultados obtenidos, comparando el estado anterior con el actual en terminos de eficiencia, estandarizacion y autonomia de los equipos.

## Alcance

La presente tesis cubre los siguientes aspectos:

**Dentro del alcance:**

- El proceso de adopcion de Red Hat OpenShift como plataforma de contenedores (on-premises y ARO).
- La evolucion de los procesos de despliegue: desde comandos manuales, pasando por scripts, pipelines, hasta GitOps con Argo CD.
- La implementacion de infraestructura como codigo con Helm y Kustomize. [PENDIENTE: Helm no esta completamente implementado al momento de escritura; se documenta el objetivo y el avance.]
- La adopcion del patron App of Apps para la gestion declarativa de aplicaciones.
- La incorporacion planificada de herramientas complementarias: Red Hat Developer Hub y Ansible.
- El impacto organizacional del cambio en los equipos de desarrollo y operaciones.

**Fuera del alcance:**

- La modernizacion de herramientas de scheduling (Control-M).
- La migracion de aplicaciones Java legacy.
- Los procesos de RPA.
- Detalles de la arquitectura interna de las aplicaciones (microservicios, codigo fuente, etc.).
- Aspectos comerciales o financieros de la transformacion.

## Metodologia

El enfoque de esta tesis es **descriptivo y basado en la experiencia directa** del autor como parte del equipo que llevo adelante la modernizacion. Se documenta el proceso tal como ocurrio, con sus aciertos, errores y decisiones iterativas.

La metodologia incluye:

- **Observacion participante**: el autor fue parte activa del proceso de transformacion.
- **Documentacion retrospectiva**: se reconstruyen las etapas del proceso a partir de documentacion interna, registros de configuracion y memoria del equipo.
- **Comparacion antes/despues**: cada etapa se contrasta con el estado previo para evidenciar las mejoras o los desafios introducidos.
- **Ejemplos tecnicos reales**: se incluyen configuraciones, manifiestos y capturas (sanitizados) para ilustrar los conceptos con casos concretos.

## Estructura del documento

El presente documento se organiza de la siguiente manera:

- **Capitulo 1 - Introduccion** (este capitulo): presenta el contexto, el problema, los objetivos y el alcance.
- **Capitulo 2 - Marco Teorico**: introduce los conceptos fundamentales necesarios para comprender las tecnologias y practicas adoptadas.
- **Capitulo 3 - Situacion Inicial**: describe en detalle la arquitectura y los procesos de la empresa antes de la modernizacion.
- **Capitulo 4 - Proceso de Modernizacion**: documenta cada etapa de la transicion con detalle tecnico y decisiones tomadas.
- **Capitulo 5 - Arquitectura Actual**: presenta la plataforma resultante y su funcionamiento.
- **Capitulo 6 - Resultados y Analisis**: compara el antes y el despues, evaluando las mejoras logradas.
- **Capitulo 7 - Conclusiones y Trabajo Futuro**: reflexiones finales y lineas de trabajo pendientes.
