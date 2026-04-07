# CONTEXT.md - Guia de Contexto y Reglas

> Este archivo sirve como punto de entrada para cualquier IA o persona que necesite entender este repositorio. OpenCode lo carga automaticamente como instrucciones.

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

## Reglas de Escritura

### Fuentes y Bibliografia
- Todo dato tecnico, definicion o afirmacion que no sea conocimiento general debe tener una fuente verificable.
- Registrar cada fuente usada en `fuentes/referencias.md` en formato APA 7ma edicion.
- Al buscar informacion para escribir, anotar la URL o referencia bibliografica inmediatamente.
- Preferir fuentes oficiales (documentacion de Red Hat, CNCF, Microsoft) sobre blogs o articulos de terceros.

### Veracidad
- No inventar datos tecnicos, estadisticas ni afirmaciones.
- Si falta informacion, marcar con `[PENDIENTE: descripcion de lo que falta]` en el texto.
- Si un dato no puede verificarse, indicarlo explicitamente.

### Sanitizacion
- Nunca usar IPs reales, dominios internos, credenciales, nombres de clientes ni datos que identifiquen la empresa.
- En ejemplos de codigo y configuracion, usar valores ficticios obvios (ejemplo: `mi-app.ejemplo.com`, `10.0.0.x`).

### Tono y Estilo
- Tercera persona, español formal academico.
- Tecnico pero accesible: el lector puede no ser experto en infraestructura.
- Sin jerga innecesaria, sin humor, sin emojis.
- Oraciones claras y directas. Evitar parrafos de mas de 5-6 lineas.

### Consistencia Terminologica
- Usar siempre los mismos terminos en español. Terminos tecnicos en ingles solo cuando no hay traduccion estandar aceptada.
- Ejemplos: usar "contenedor" (no alternar con "container"), "despliegue" (no "deploy" salvo en contexto de comandos), "cluster" (no "cluster" sin acento en texto corrido).
- Mantener un glosario implicito: si se define un termino de una manera, usarlo igual en todo el documento.

### Implementaciones No Completadas
- Si algo todavia no esta implementado en la empresa (ej: Helm charts), escribir en futuro o condicional.
- No afirmar que algo existe o funciona si no esta confirmado por el autor.
- Distinguir claramente entre "lo que se hizo", "lo que se esta haciendo" y "lo que se planea hacer".

### Secciones Incompletas
- Usar `[TODO: descripcion]` para secciones que necesitan mas desarrollo o input del autor.
- Esto permite buscar rapidamente que falta con un grep de `[TODO`.

### Formato y Generacion
- Formato APA 7ma edicion (configurado en `tesis/metadata.yaml`).
- Cada capitulo en un archivo `.md` separado en `tesis/capitulos/`, nombrado con prefijo numerico (`01-`, `02-`, etc.).
- La numeracion de secciones es automatica (Pandoc `numbersections`). No agregar numeros manuales en los headers.
- No usar caracteres unicode especiales en bloques de codigo (usar `|--` en lugar de `├──` para arboles de directorio).
- Despues de cambios significativos, regenerar el PDF con `./build-pdf.sh` y subirlo a Git.

## Comandos Utiles

```bash
./build-pdf.sh          # Genera tesis/output/tesis.pdf
./build-pdf.sh --word   # Genera tesis/output/tesis.docx
```

## Estructura del Repositorio
```
tesis/capitulos/   - Capitulos en .md (el contenido principal)
tesis/output/      - PDF generado
docs/internas/     - Documentacion de la empresa (sanitizada)
docs/externas/     - Documentacion publica de tecnologias
docs/diagramas/    - Diagramas y capturas
fuentes/           - Material bibliografico y referencias.md
ejemplos/antes/    - Como se hacia antes (IIS, scripts)
ejemplos/despues/  - Como se hace ahora (Helm, ArgoCD, Ansible)
```

## Instrucciones para IA

1. **Lee este archivo primero** para entender el contexto y las reglas.
2. **Revisa `tesis/capitulos/`** para ver el estado actual del documento.
3. **Consulta `docs/`** para documentacion de soporte.
4. **Mira `ejemplos/`** para entender los aspectos tecnicos con codigo real.

## Estado Actual

- [x] Estructura del repo creada
- [x] Idea general definida (README.md)
- [x] Capitulo 1 (Introduccion) - borrador
- [x] Capitulo 2 (Marco Teorico) - borrador
- [ ] Capitulo 3 (Situacion Inicial) - pendiente
- [ ] Capitulo 4 (Proceso de Modernizacion) - pendiente
- [ ] Capitulo 5 (Arquitectura Actual) - pendiente
- [ ] Capitulo 6 (Resultados) - pendiente
- [ ] Capitulo 7 (Conclusiones) - pendiente
- [ ] Documentacion interna: pendiente de carga
- [ ] Ejemplos tecnicos: pendientes de carga
