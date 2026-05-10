<!-- DOC_ORG_SCAN: 2026-05-10 | source-scan: android-job-permissions-hardening -->

# Android CI job permissions matrix (least privilege)

Este documento define as permissões explícitas por job para os workflows Android:

- `.github/workflows/android-ci.yml` (pipeline canônica)
- `.github/workflows/android.yml` (wrapper de entrada)

Objetivo: reduzir ambiguidade, facilitar auditoria e evitar drift de privilégios por herança implícita.

## Matriz — `.github/workflows/android-ci.yml`

| Job | Papel | Publica artefatos/relatórios | permissions (job) | Justificativa mínima |
|---|---|---:|---|---|
| `resolve` | Resolve inputs/lanes e contrato ABI | Não | `contents: read` | Leitura de repositório para checkout e scripts de resolução. |
| `abi-contract-gate` | Gate obrigatório de contrato lowlevel ABI | Não | `contents: read` | Executa validação local sem escrita em API GitHub. |
| `build` | Build/test/lint/checks + geração/upload de artefatos e relatórios | Sim (`actions/upload-artifact@v4`) | `contents: read` | Necessita apenas checkout/leitura de código; upload-artifact não requer escrita de conteúdo do repo. |

## Matriz — `.github/workflows/android.yml`

| Job | Papel | Publica artefatos/relatórios | permissions (job) | Justificativa mínima |
|---|---|---:|---|---|
| `resolve-inputs` | Normaliza parâmetros de entrada para o workflow canônico | Não | `contents: read` | Apenas shell/output internos do job. |
| `android-ci` | Encaminha execução para workflow reutilizável canônico | Indireto (via workflow chamado) | `contents: read` | Delegação com privilégios mínimos explícitos no caller. |
| `compile-matrix-gate` | Encaminha gate auxiliar de matriz ABI | Indireto (via workflow chamado) | `contents: read` | Delegação com privilégio mínimo explícito. |
| `adaptive-gates` | Consolida status final (gates) | Não | `contents: read` | Somente leitura de resultados `needs.*.result`. |

## Observações de auditoria

1. Todos os jobs agora declaram `permissions` explicitamente no nível de job.
2. Jobs com `actions/upload-artifact@v4` foram mantidos com escopo mínimo (`contents: read`).
3. Gates de status (`abi-contract-gate`, `adaptive-gates`) não recebem permissões adicionais.
