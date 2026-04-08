# CONTEXT.md - Guia de Contexto para IA

> Este archivo sirve como punto de entrada y conjunto de reglas para cualquier IA que trabaje con este repositorio. **Leer este archivo completo antes de hacer cualquier otra cosa.**

---

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
|-- README.md              # Vision general de la tesis
|-- CONTEXT.md             # ESTE ARCHIVO - Contexto y reglas para IA
|-- build-pdf.sh           # Script para generar PDF/Word con Pandoc
|-- .gitignore
|
|-- docs/                  # Documentacion de referencia
|   |-- internas/          # Docs de la empresa (sanitizadas)
|   |-- externas/          # Docs publicas de tecnologias
|   |-- diagramas/         # Arquitectura, flujos, capturas
|
|-- fuentes/               # Material bibliografico
|   |-- libros/
|   |-- papers/
|   |-- articulos/
|   |-- referencias.md     # Registro de todas las fuentes citadas (APA 7ma)
|
|-- tesis/                 # El documento de la tesis
|   |-- metadata.yaml      # Config de Pandoc (APA, fuente, margenes)
|   |-- capitulos/         # Cada capitulo en .md separado
|   |-- assets/            # Imagenes y recursos del documento
|   |-- output/            # PDF generado (tesis.pdf)
|
|-- ejemplos/              # Codigo y configuraciones reales (sanitizados)
    |-- antes/             # Como se hacia antes (scripts, configs IIS)
    |-- despues/           # Como se hace ahora (Helm, ArgoCD, Ansible)
```

---

## REGLAS DE ESCRITURA (OBLIGATORIAS)

Estas reglas aplican siempre que se escriba o modifique contenido de la tesis. Son de cumplimiento obligatorio.

### 1. Fuentes y bibliografia

- **Todo dato tecnico, definicion o afirmacion que no sea conocimiento general debe tener una fuente citada.**
- Registrar cada fuente utilizada en `fuentes/referencias.md` en formato **APA 7ma edicion**.
- Si se busca informacion en internet para escribir un parrafo, registrar la fuente inmediatamente.
- Preferir fuentes oficiales (documentacion de Red Hat, CNCF, Kubernetes, etc.) sobre blogs o articulos de opinion.
- Incluir: autor, año, titulo, URL y fecha de acceso para fuentes web.

### 2. No inventar datos

- **Si no hay informacion suficiente, NO inventar.** Marcar con `[PENDIENTE: descripcion de lo que falta]`.
- No asumir datos de la empresa (cantidades de servidores, aplicaciones, equipos, fechas, metricas, etc.).
- **Preguntar a Nicolas** antes de escribir cualquier dato especifico de la empresa. El es quien conoce la empresa, sus procesos y su historia. No adivinar.

### 3. Secciones que requieren input del autor

- Hay parrafos y secciones que **solo Nicolas puede redactar** porque requieren conocimiento directo de la empresa, decisiones internas o experiencias especificas.
- Cuando una seccion necesite el criterio o conocimiento del autor, marcarla con `[REQUIERE INPUT DEL AUTOR: descripcion de lo que se necesita]`.
- No marcar todo: solo lo **sumamente necesario** que requiera el criterio de Nicolas. Lo que pueda escribirse con informacion publica o tecnica general, escribirlo directamente.
- Ejemplos de lo que SI requiere input del autor:
  - Datos especificos de la empresa (cantidad de apps, estructura de equipos, decisiones politicas).
  - Motivaciones internas para elegir una tecnologia sobre otra.
  - Problemas concretos que ocurrieron durante la implementacion.
  - Metricas o resultados reales.
- Ejemplos de lo que NO requiere input del autor:
  - Definiciones de tecnologias (Kubernetes, ArgoCD, etc.).
  - Comparativas tecnicas basadas en documentacion publica.
  - Buenas practicas de la industria.

### 4. Sanitizacion

- **Nunca** incluir IPs reales, dominios internos, credenciales, nombres de clientes, nombres de productos internos ni datos que identifiquen la empresa.
- En ejemplos de codigo o configuracion, usar valores ficticios evidentes (ej: `app.ejemplo.com`, `10.0.0.x`, `mi-aplicacion`).
- Si Nicolas provee datos reales, sanitizarlos antes de escribir.

### 5. Tono y estilo

- **Tercera persona**, español formal academico.
- Tecnico pero accesible: el lector puede no ser experto en infraestructura.
- Sin jerga innecesaria, sin humor, sin emojis.
- Evitar frases grandilocuentes o de marketing ("revolucionario", "game-changer", etc.).
- Ser directo y preciso.

### 6. Consistencia terminologica

- Usar siempre los mismos terminos a lo largo de toda la tesis. No alternar.
- Terminos tecnicos en ingles solo cuando no hay traduccion estandar aceptada.
- Glosario de terminos a mantener:
  - "contenedor" (no "container")
  - "despliegue" (no "deploy" en el texto corrido, salvo en contexto tecnico/comandos)
  - "orquestacion" (no "orchestration")
  - "infraestructura como codigo" (no "IaC" sin haberlo definido antes)
  - Nombres propios en ingles: Kubernetes, OpenShift, Argo CD, Helm, Ansible, Developer Hub (no traducir)

### 7. Secciones incompletas

- Usar `[TODO: descripcion]` para secciones que necesitan mas desarrollo pero no requieren input del autor.
- Usar `[PENDIENTE: descripcion]` para datos que faltan verificar.
- Usar `[REQUIERE INPUT DEL AUTOR: descripcion]` para lo que solo Nicolas puede aportar.

### 8. No asumir implementaciones

- Si algo **todavia no esta implementado** en la empresa (ej: Helm, Developer Hub), escribir en futuro o condicional ("se plantea implementar", "el objetivo es").
- **No afirmar que algo existe o funciona** si no esta confirmado por Nicolas.
- Preguntar ante la duda.

### 9. Formato y generacion

- Normas **APA 7ma edicion** (configurado en `tesis/metadata.yaml`).
- Cada capitulo en archivo separado en `tesis/capitulos/` con prefijo numerico (`01-`, `02-`, etc.).
- No poner numeracion manual en los headers (Pandoc la genera automaticamente con `numbersections`).
- Despues de cambios significativos en capitulos, regenerar el PDF con `./build-pdf.sh` y subir a Git.
- No usar caracteres Unicode especiales en bloques de codigo (|-- en lugar de las flechitas de arbol).

### 10. Git

- Commits descriptivos en español que reflejen el cambio realizado.
- No commitear archivos sensibles (.env, credenciales, etc.).
- Subir el PDF generado a `tesis/output/` para facil acceso desde GitHub.

---

## Instrucciones para IA

Si sos una IA trabajando con este repo:

1. **Lee este archivo completo primero.** Las reglas de escritura son obligatorias.
2. **Lee el README.md** para la vision general de la tesis.
3. **Revisa `tesis/capitulos/`** para ver el estado actual del documento.
4. **Consulta `fuentes/referencias.md`** para las fuentes ya registradas.
5. **Consulta `docs/`** para documentacion de soporte.
6. **Mira `ejemplos/`** para entender los aspectos tecnicos con codigo real.
7. **Cuando no sepas algo de la empresa, PREGUNTA.** No inventes. Nicolas es la fuente de verdad para datos internos.
8. **Registra cada fuente que uses** en `fuentes/referencias.md`.
9. **Regenera el PDF** despues de modificar capitulos y subilo a Git.

---

## Estado Actual

- [x] Estructura del repo creada
- [x] Idea general definida (README.md)
- [x] CONTEXT.md con reglas de escritura
- [x] Capitulo 1 - Introduccion (borrador)
- [x] Capitulo 2 - Marco Teorico (borrador conciso)
- [ ] Capitulo 3 - Situacion Inicial
- [ ] Capitulo 4 - Proceso de Modernizacion
- [ ] Capitulo 5 - Arquitectura Actual
- [ ] Capitulo 6 - Resultados y Analisis
- [ ] Capitulo 7 - Conclusiones
- [ ] Documentacion interna: pendiente de carga
- [ ] Ejemplos tecnicos: pendientes de carga
- [ ] fuentes/referencias.md: pendiente de creacion
