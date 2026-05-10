# Release Dual Track CI (signed + unsigned)

Workflow: `.github/workflows/release-dual-track.yml`

## Objetivo
- Compilar release **unsigned** para validação interna em `armeabi-v7a` + `arm64-v8a`.
- Compilar release **signed oficial** para distribuição em `armeabi-v7a` + `arm64-v8a`.
- Reutilizar o contrato único em `.github/workflows/android-ci.yml`.

## Execução
Acione `release-dual-track` via `workflow_dispatch`.

Inputs:
- `official_release=true`: executa também trilha assinada oficial.
- `run_native_checks=true`: executa matriz CMake/NDK.
- `log_level`: `lifecycle|info|debug`.

## Contratos de assinatura
A trilha signed depende dos secrets:
- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

Se `official_release=true` e os secrets não estiverem válidos, o job signed falha por contrato (sem fallback inseguro).

## Artefatos
Cada lane publica artefatos via `android-ci.yml`:
- `android-artifacts-*`
- `android-logs-*`
- `android-reports-*`
- `apk-report-*`
- `native-matrix-*` (quando habilitado)
