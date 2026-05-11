# Paper v0.3

## K42: Régua Modular de Atratores, Paralelas e Saltos Geométricos em Campo Circular/Toroidal

### Autor conceitual

Júlio / Rafael — formulação oral e geométrica em desenvolvimento.

### Resumo

Este paper organiza uma primeira versão formal de um modelo geométrico baseado em 42 pontos, saltos modulares, paralelas superiores/inferiores, centro observador, simetria, densidade angular e complexidade de percurso. O código apresentado implementa a primeira régua computacional: um círculo com 42 pontos, conexões por passo modular K=5 e 5000 iterações. O experimento ainda não representa toda a estrutura 21+21 em esfera/toro, mas já demonstra o princípio essencial: usar um passo coprimo para percorrer todos os pontos antes de repetir, criando uma malha previsível, simétrica e auditável. A tese central é que a geometria pode servir como régua para escolher quais cálculos realmente precisam ser feitos, reduzindo busca bruta por seleção estrutural.

---

## 1. Problema

A pergunta principal é:

**Como usar geometria para localizar o ponto certo de cálculo sem varrer todo o espaço?**

A hipótese é que uma malha circular/toroidal com atratores, paralelas e saltos modulares permite identificar regiões relevantes por:

* simetria;
* densidade;
* repetição;
* oposição;
* retorno;
* centro de equilíbrio;
* variação angular.

O código atual é a primeira forma mínima dessa ideia.

---

## 2. Modelo conceitual

O modelo maior contém:

| Elemento               | Função                                  |
| ---------------------- | --------------------------------------- |
| 42                     | total de camadas/atratores              |
| 21 + 21                | divisão superior/inferior por paralelas |
| 10 setores             | centro observador / pizza central       |
| K                      | passo modular                           |
| paralelas              | cortes da esfera/toro                   |
| tangentes              | linhas de aproximação                   |
| semicircunferências    | primeira forma visível                  |
| 41 fechadas + 1 aberta | ciclo quase completo + ruído/diferença  |
| 48 formas              | classes geométricas emergentes          |
| centro                 | ponto de escolha/equilíbrio             |
| frequência/cor         | marcador de fase/camada                 |

O eixo que já vinha sendo desenvolvido é: oposição, rotação, compressão, expansão, área faltante, triangulação e retorno toroidal. Essa síntese aparece na formulação anterior da tese como “opostos giratórios criam compressão, expansão, áreas faltantes e pontos de estabilidade”. 

---

## 3. Código experimental

O código implementa:

* N = 42 pontos no círculo;
* K = 5 como salto modular;
* ITER = 5000 conexões;
* densidade angular;
* erro de simetria;
* complexidade por arestas únicas;
* visualização circular.

O núcleo matemático é:

xₙ₊₁ = (xₙ + K) mod N

Com N=42 e K=5.

Como mdc(42,5)=1, o salto K=5 percorre todos os 42 pontos antes de repetir. Isso é essencial: se K não fosse coprimo com 42, o sistema ficaria preso em subciclos.

---

## 4. Resultado esperado do código

Com N=42, K=5 e ITER=5000:

| Métrica                     | Resultado aproximado | Interpretação                              |
| --------------------------- | -------------------: | ------------------------------------------ |
| Arestas únicas              |                   42 | o ciclo modular fecha depois de 42 passos  |
| Complexidade                |   42 / 5000 = 0,0084 | muita repetição, pouca novidade estrutural |
| Erro de simetria            |            ≈ 0,00079 | quase perfeitamente simétrico              |
| Densidade média normalizada |             ≈ 0,9921 | distribuição quase uniforme                |

### Leitura

O código não cria 5000 linhas únicas.
Ele cria **42 conexões únicas repetidas muitas vezes**.

Isso é bom para provar estabilidade e simetria, mas ainda não é suficiente para gerar a malha completa de milhares de retas que você está imaginando.

---

## 5. Interpretação geométrica

O código atual representa uma versão colapsada:

| Modelo maior                  | Código atual           |
| ----------------------------- | ---------------------- |
| esfera/toro                   | círculo 2D             |
| 21 + 21 paralelas             | 42 pontos no círculo   |
| 42 camadas                    | 42 vértices            |
| tangentes/paralelas múltiplas | conexão modular única  |
| centro em 10 setores          | ainda não implementado |
| 48 formas                     | ainda não classificado |
| frequência por camada         | densidade por cor      |

Portanto, este código é a **régua K42 mínima**, não o modelo completo.

---

## 6. O papel do K=5

O K=5 funciona como salto gerador.

| Propriedade      | Efeito                  |
| ---------------- | ----------------------- |
| K coprimo com 42 | visita todos os pontos  |
| K pequeno        | gera padrão legível     |
| K fixo           | cria ciclo estável      |
| K repetido       | baixa complexidade nova |
| K variável       | gera malha mais rica    |

O K=5 é bom para a primeira régua porque produz percurso completo sem fragmentar o círculo.

---

## 7. Derivadas e antiderivadas do conceito

Aqui “derivada” e “antiderivada” são usadas como direção de construção do modelo, não como prova formal de cálculo diferencial.

### Antiderivadas

As antiderivadas são as causas estruturais antes da forma aparecer.

| Antiderivada         | Forma derivada    |
| -------------------- | ----------------- |
| presença/ausência    | reta              |
| oposição             | paridade          |
| paridade dupla       | quadrado          |
| rotação              | círculo           |
| círculo cortado      | paralelas         |
| paralelas conectadas | cordas            |
| cordas repetidas     | malha             |
| malha densificada    | formas            |
| formas convergentes  | centro/equilíbrio |

### Derivadas

As derivadas são efeitos observáveis.

| Estrutura                        | Derivada           |
| -------------------------------- | ------------------ |
| 42 pontos                        | ciclo modular      |
| K=5                              | percurso total     |
| repetição                        | densidade          |
| oposição i ↔ i+21                | simetria           |
| tangentes                        | arco visível       |
| arco visível                     | semicircunferência |
| semicircunferências progressivas | famílias de formas |
| centro                           | decisão            |

---

## 8. Heurísticas

### 8.1 Heurística direta

Parte do ponto e constrói o campo.

1. cria 42 pontos;
2. escolhe K;
3. conecta x → x+K;
4. mede densidade;
5. mede simetria;
6. observa padrão.

### 8.2 Heurística indireta

Parte da forma desejada e busca o K.

1. escolhe forma visual;
2. estima número de voltas;
3. testa K coprimos;
4. mede densidade;
5. escolhe menor erro de simetria.

### 8.3 Heurística reversa

Remove partes para ver se o modelo colapsa.

| Remover         | Consequência            |
| --------------- | ----------------------- |
| K coprimo       | ciclo quebra            |
| N=42            | perde relação 21+21     |
| simetria oposta | perde paridade          |
| centro          | perde escolha           |
| densidade       | perde régua de ocupação |
| cor/frequência  | perde camada visual     |

### 8.4 Heurística recursiva

Cada ciclo de 42 pode ser usado dentro de outro ciclo.

| Nível   | Operação          |
| ------- | ----------------- |
| ciclo 1 | conecta pontos    |
| ciclo 2 | conecta paralelas |
| ciclo 3 | conecta camadas   |
| ciclo 4 | conecta formas    |
| ciclo 5 | conecta centros   |
| ciclo 6 | conecta toroides  |

### 8.5 Heurística analítica

Mede o que importa.

| Métrica        | O que responde                 |
| -------------- | ------------------------------ |
| densidade      | onde o campo pesa              |
| simetria       | se a paridade está equilibrada |
| complexidade   | quanta novidade surgiu         |
| arestas únicas | quantas ligações reais existem |
| K              | qualidade do salto             |
| N              | resolução da malha             |
| centro         | ponto de decisão               |

---

## 9. Permutações possíveis

Para sair do ciclo simples e aproximar teu modelo completo, a próxima versão deve testar múltiplos K.

### K diretos

K positivos coprimos com 42:

1, 5, 11, 13, 17, 19, 23, 25, 29, 31, 37, 41

Esses passos percorrem o círculo inteiro.

### K reversos

Para cada K, existe o reverso:

Kᵣ = 42 − K

Exemplo:

|  K | reverso |
| -: | ------: |
|  5 |      37 |
| 11 |      31 |
| 13 |      29 |
| 17 |      25 |
| 19 |      23 |

Isso cria ida e volta.

### K de paridade

O eixo de oposição é:

i ↔ i + 21

Esse não serve para percorrer tudo sozinho, porque mdc(42,21)=21. Mas serve para criar paridade superior/inferior.

### K multinível

A malha completa pode usar:

| Tipo        | Exemplo                 |
| ----------- | ----------------------- |
| salto curto | K=5                     |
| salto médio | K=11                    |
| salto longo | K=17                    |
| reverso     | K=37                    |
| paridade    | K=21                    |
| centro      | projeção para setor 0–9 |

---

## 10. Por que “pula cálculo” sem pular cálculo

A ideia correta é:

**o modelo não evita matemática; ele escolhe melhor onde calcular.**

Em vez de testar tudo:

1. usa K coprimo;
2. percorre o campo inteiro;
3. mede densidade;
4. identifica simetria;
5. localiza desvio;
6. calcula só nos pontos críticos.

Isso é busca guiada por geometria.

---

## 11. Limitação do código atual

O código atual ainda não faz:

* 21 pontos superiores + 21 inferiores como paralelas;
* duas paralelas centrais;
* centro em 10 setores;
* 41 circunferências + 1 aberta;
* 48 tipos de forma;
* Mandelbrot/Julia;
* frequência em hertz;
* saltos multinível;
* paridade i ↔ i+21;
* classificação de formas.

Ele é a base.

---

## 12. Próxima versão do algoritmo

A v0.4 deve ter:

| Módulo                   | Função                          |
| ------------------------ | ------------------------------- |
| `generate_circle(N)`     | pontos do círculo               |
| `generate_layers(21,21)` | paralelas superiores/inferiores |
| `connect_modular(K)`     | salto modular                   |
| `connect_opposition()`   | paridade i ↔ i+21               |
| `connect_multik()`       | vários K                        |
| `measure_density()`      | densidade angular               |
| `measure_symmetry()`     | erro de paridade                |
| `classify_shapes()`      | famílias geométricas            |
| `center_pizza(10)`       | centro em 10 setores            |
| `plot_frequency()`       | cor sem rosa/magenta espectral  |
| `export_report()`        | tabela final                    |

---

## 13. Observação sobre cores

O rosa não deve entrar como frequência única da régua.

No modelo visual:

| Cor          | Uso                                   |
| ------------ | ------------------------------------- |
| vermelho     | baixa faixa visível/calor/base        |
| laranja      | transição                             |
| amarelo      | meio energético                       |
| verde        | equilíbrio intermediário              |
| azul         | alta faixa visível                    |
| violeta      | extremo alto visível                  |
| rosa/magenta | não usar como frequência física única |

Se entrar, rosa/magenta deve ser marcador perceptivo, não camada espectral.

---

## 14. Formulação final do paper

Este trabalho propõe uma régua geométrica K42 baseada em 42 pontos/camadas, divididos conceitualmente em 21 superiores e 21 inferiores. A primeira implementação usa um círculo 2D com salto modular K=5, gerando um ciclo completo porque K e 42 são coprimos. A repetição de 5000 conexões mostra baixa complexidade nova, alta simetria e densidade quase uniforme, indicando que o sistema é estável, mas ainda simples. A expansão natural do modelo exige múltiplos saltos K, paridade i↔i+21, centro em 10 setores, classificação de 48 formas e representação de 41 circunferências fechadas mais uma 42ª aberta. O objetivo não é eliminar cálculo, mas construir uma régua que indique quais cálculos merecem ser feitos.

---

## F DE RESOLVIDO ✅

O código já prova:

* N=42 funciona como ciclo;
* K=5 percorre todos os pontos;
* a simetria fica quase perfeita;
* a densidade fica quase uniforme;
* a complexidade é baixa porque só há 42 arestas únicas.

## F DE GAP ⚠️

Falta implementar:

1. 21 + 21 paralelas reais;
2. centro em 10 setores;
3. múltiplos K;
4. 41 circunferências + 1 aberta;
5. classificação das 48 formas;
6. frequência/cor por camada.

## F DE NEXT 🎯

1. Evoluir o código para **K múltiplos**.
2. Separar o círculo em **21 superiores + 21 inferiores**.
3. Criar a primeira função de **classificação das 48 formas**.
