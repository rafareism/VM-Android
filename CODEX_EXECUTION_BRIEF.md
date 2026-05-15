# CODEX_EXECUTION_BRIEF — Vectras VM Android

## Missão

Atuar neste repositório como agente de implementação, validação e fechamento operacional da Vectra.

Objetivo central:

> transformar a Vectra de fork técnico avançado em projeto com prova operacional verificável: build, APK, smoke runtime, benchmark e artefatos auditáveis.

Este arquivo é o primeiro documento que o Codex deve ler antes de propor ou aplicar mudanças.

---

## Repositório alvo

- Repositório: `wojcikiewicz17/Vectras-VM-Android`
- Branch padrão operacional: `master`
- Upstream de comparação: `xoureldeen/Vectras-VM-Android`
- Estado declarado atual: `BETA_BLOCKED`
- Status principal: engenharia avançada, produto ainda pendente de prova operacional completa.

---

## Diagnóstico sintético

A Vectra atual está mais forte que o upstream em governança técnica, CI, política ABI, documentação auditável e core nativo RMR.

O upstream está mais forte em produto público, distribuição, clareza para usuário final, releases, bootstraps QEMU e prova prática de uso.

Portanto, a prioridade não é criar mais conceitos.

A prioridade é fechar evidência executável:

1. build canônico;
2. APK debug gerado;
3. relatório de device smoke;
4. benchmark host/native;
5. artefatos de CI;
6. documentação atualizada com status real.

---

## Fontes canônicas internas

Antes de editar, ler:

- `README.md`
- `PROJECT_STATE.md`
- `reports/CANONICAL_BUILD_STATUS.md`
- `VECTRA_CORE.md`
- `engine/rmr/README.md`
- `BUILDING.md`
- `docs/AI_BUILD_RELEASE_INDEX.md`
- `docs/ci/workflow-matrix.md`
- `.github/workflows/pipeline-orchestrator.yml`
- `.github/workflows/android-ci.yml`
- `.github/workflows/host-ci.yml`
- `build.gradle`
- `settings.gradle`

---

## Estado real conhecido

### Pontos positivos

- O projeto tem estrutura Android herdada do upstream.
- Há módulos principais preservados:
  - `:app`
  - `:terminal-emulator`
  - `:terminal-view`
  - `:shell-loader`
  - `:shell-loader:stub`
- Há política ABI estruturada:
  - `arm64-only`
  - `arm32-arm64`
  - `internal-4abi`
  - `internal-5abi`
- Há validações Gradle para SDK, NDK, CMake, JVM, API e ABI.
- Há core RMR em `engine/rmr` com contrato low-level.
- Há relatórios em `reports/`.
- Há equivalência RMR fallback já registrada em `reports/rmr_equivalence.md`.

### Bloqueios atuais

- `PROJECT_STATE.md` declara `BETA_BLOCKED`.
- `reports/vectra_grade_benchmarks.md` indica `APK: not_found` e `Runtime device: pending`.
- `reports/device_runtime_smoke.md` indica `ADB missing`, `Install: pending`, `Launch: pending` e `DEVICE_PENDING`.
- `reports/CANONICAL_BUILD_STATUS.md` aponta última validação oficial anterior, mas não valida necessariamente o commit corrente.

---

## Regras obrigatórias

1. Não alterar arquitetura ampla sem necessidade.
2. Não quebrar compatibilidade com o fluxo upstream de VM/QEMU.
3. Não remover módulos herdados do upstream.
4. Não mexer em assinatura release sem secrets oficiais.
5. Não declarar performance sem benchmark real.
6. Não mascarar erro com fallback silencioso.
7. Não tratar relatório pendente como sucesso.
8. Não promover código de `bug/core` para `engine/rmr` em bloco.
9. Preservar ABI pública dos headers em `engine/rmr/include`.
10. Toda alteração deve ter motivo, risco e validação.

---

## Ordem de execução recomendada

### Fase 1 — Auditoria mínima sem alteração

Executar inspeção:

```bash
git status --short
find . -maxdepth 2 -type f | sort | sed 's#^./##' | head -200
./tools/gradle_with_jdk21.sh --version
```

Verificar arquivos centrais:

```bash
test -f README.md
test -f PROJECT_STATE.md
test -f reports/CANONICAL_BUILD_STATUS.md
test -f build.gradle
test -f settings.gradle
test -f app/build.gradle
test -d engine/rmr
```

### Fase 2 — Validação de setup

Executar, quando ambiente permitir:

```bash
./tools/gradle_with_jdk21.sh verifyGradleRuntimeJvm --stacktrace
./tools/gradle_with_jdk21.sh verifyMinApiAbiCompatibility --stacktrace
./tools/gradle_with_jdk21.sh verifyArm64ToolchainCompatibility --stacktrace
```

Se houver Android SDK disponível:

```bash
./tools/gradle_with_jdk21.sh verifyAndroidSdkPackages --stacktrace
```

### Fase 3 — Build APK debug

Com SDK/NDK configurado:

```bash
./tools/gradle_with_jdk21.sh clean :app:assembleDebug --stacktrace
```

Critério:

- se gerar APK, registrar caminho, tamanho e sha256;
- se falhar, registrar erro real e arquivo responsável;
- não trocar erro por sucesso parcial.

### Fase 4 — Smoke runtime em device/emulador

Se `adb` e device estiverem disponíveis:

```bash
adb devices
adb install -r app/build/outputs/apk/debug/*.apk
adb shell monkey -p com.vectras.vm 1
adb shell pidof com.vectras.vm || true
```

Tentar coletar log interno se aplicável:

```bash
adb exec-out run-as com.vectras.vm ls files || true
adb exec-out run-as com.vectras.vm cat files/vectra_core.log > build/reports/vectra_core.log || true
```

Critério:

- se `adb` não existir, status correto é `DEVICE_PENDING`, não falha de arquitetura;
- se APK não existir, status correto é `APK_NOT_FOUND`;
- se instalar e abrir, registrar `DEVICE_SMOKE_PASS`.

### Fase 5 — RMR/native checks

Executar quando disponível:

```bash
make -C engine/rmr all || make all
make run-sector-selftest || true
make run-sector-snapshot-42 || true
make run-core-bench-smoke || true
```

Também verificar scripts existentes:

```bash
bash scripts/native/test.sh || true
bash scripts/native/benchmark.sh || true
```

Não transformar `|| true` em sucesso. Usar apenas para coletar diagnóstico e registrar status real.

---

## Artefatos esperados

Gerar ou atualizar, conforme resultado real:

- `reports/CANONICAL_BUILD_STATUS.md`
- `reports/device_runtime_smoke.md`
- `reports/vectra_grade_benchmarks.md`
- `reports/rmr_equivalence.md`, se houver nova validação
- `build/reports/vectra-artifact-manifest.json`
- `build/reports/vectra-build-summary.md`

Formato mínimo do manifest:

```json
{
  "timestamp_utc": "...",
  "commit": "...",
  "apk": {
    "status": "FOUND|NOT_FOUND|BUILD_FAILED",
    "path": "...",
    "sha256": "...",
    "size_bytes": 0
  },
  "device_smoke": {
    "status": "PASS|FAIL|PENDING|ADB_MISSING|APK_NOT_FOUND",
    "model": "...",
    "abi": "...",
    "sdk": "..."
  },
  "benchmarks": {
    "status": "MEASURED|PENDING|FAILED",
    "items": []
  }
}
```

---

## Status vocabulary obrigatório

Usar sempre estes estados:

- `MEASURED`: executado e medido.
- `DOCUMENTED`: apenas documentado/inspecionado.
- `PENDING`: faltou ambiente, device ou artifact.
- `BLOCKED`: existe erro real impedindo avanço.
- `FAILED`: teste executou e falhou.
- `PASS`: teste executou e passou.

Não usar linguagem ambígua como “parece funcionando” sem comando e evidência.

---

## Comparação com upstream

Upstream provável:

- `xoureldeen/Vectras-VM-Android`

O upstream é referência para:

- fluxo de produto;
- bootstraps QEMU;
- compatibilidade de dispositivo;
- distribuição pública;
- experiência de usuário.

A fork atual deve preservar o que o upstream tem de funcional e adicionar valor sem quebrar:

- RMR;
- CI canônico;
- política ABI;
- benchmark;
- determinismo;
- documentação auditável.

---

## Prioridades de implementação

### Prioridade 1

Fazer o APK debug aparecer como artifact verificável.

### Prioridade 2

Atualizar `reports/device_runtime_smoke.md` com status real do ambiente.

### Prioridade 3

Gerar benchmark host/native mínimo e publicar JSON/Markdown.

### Prioridade 4

Garantir que CI não fique verde quando artifact obrigatório estiver ausente.

### Prioridade 5

Só depois integrar mais profundamente com Termux RAFCODEΦ, Arme ou linuxkernel.

---

## Restrições de escopo

Não fazer agora:

- reescrever QEMU;
- trocar framework Android;
- redesenhar UI;
- adicionar nova DSL;
- misturar Termux RAFCODEΦ diretamente no app;
- mexer em release signing sem secrets;
- declarar ISO/certificação;
- prometer ganho de NEON/ASM sem benchmark.

---

## Critério de pronto desta rodada

A rodada está pronta quando houver:

1. build debug tentado;
2. resultado real registrado;
3. APK encontrado ou falha explícita registrada;
4. device smoke executado ou pendência explícita registrada;
5. benchmark host/native executado ou pendência explícita registrada;
6. artifacts publicados em CI quando possível;
7. `reports/` coerente com o que realmente aconteceu.

---

## Saída esperada do Codex

Ao final, responder com:

```text
F DE RESOLVIDO
- arquivos alterados
- comandos executados
- artifacts gerados

F DE GAP
- falhas reais
- pendências de ambiente
- riscos técnicos

F DE NEXT
1. próximo passo seguro
2. próximo passo de benchmark
3. próximo passo de produto
```

---

## Princípio operacional

Menor patch útil > grande reescrita.

Evidência executada > documentação bonita.

Fallback explícito > sucesso falso.

Produto rodando > arquitetura prometida.
