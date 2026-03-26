# Ejemplos Tecnicos

Codigo, manifiestos y configuraciones reales (sanitizados) que ilustran el antes y el despues.

## Estructura

### `antes/`
Ejemplos de como se hacian las cosas antes de OpenShift:
- Scripts de deploy manuales.
- Configuraciones de IIS.
- El script `.py` que se usaba para crear recursos.
- Pipelines legacy.

### `despues/`
Ejemplos de como se hacen ahora con la plataforma moderna:
- Manifiestos de Kubernetes/OpenShift (Helm charts, Kustomize).
- Configuracion de Argo CD (Application, AppProject, App of Apps).
- Pipelines modernos (Tekton, GitHub Actions, etc.).
- Templates de Developer Hub.
- Playbooks de Ansible.

> IMPORTANTE: Sanitizar todo antes de subir. Remover IPs, dominios internos, credenciales, nombres de clientes.
