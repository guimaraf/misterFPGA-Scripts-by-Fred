# MiSTerFPGA Scripts by Fred Oliveira

Scripts utilitarios para uso no MiSTer FPGA, com foco em duas tarefas do dia a dia:

- ajustar rapidamente o parametro `vsync_adjust` no `MiSTer.ini`
- desligar o sistema com seguranca usando contagem regressiva e cancelamento por controle

O objetivo deste repositorio e concentrar scripts simples, diretos e praticos para facilitar o uso do MiSTer sem precisar editar arquivos manualmente toda vez.

## Visao Geral

Este repositorio contem 5 scripts:

| Script | Funcao |
| --- | --- |
| `vsync_check.sh` | Mostra o valor atual de `vsync_adjust` |
| `vsync0.sh` | Define `vsync_adjust=0` |
| `vsync1.sh` | Define `vsync_adjust=1` |
| `vsync2.sh` | Define `vsync_adjust=2` |
| `poweroff_countdown.sh` | Faz desligamento seguro com contagem regressiva |

## Estrutura dos Scripts

### 1. Scripts de VSync

Os scripts `vsync0.sh`, `vsync1.sh` e `vsync2.sh` alteram diretamente o arquivo:

```bash
/media/fat/MiSTer.ini
```

Antes de alterar o valor, cada script cria um backup em:

```bash
/media/fat/iniBkp/backupMister.ini
```

Depois disso, o script substitui o valor atual de `vsync_adjust` e informa que o sistema deve ser reiniciado para aplicar a mudanca.

#### Valores disponiveis

- `0`: sem ajuste de VSync
- `1`: ajuste intermediario
- `2`: ajuste completo

#### Scripts disponiveis

```bash
./vsync_check.sh
./vsync0.sh
./vsync1.sh
./vsync2.sh
```

#### Observacoes importantes

- Os scripts assumem que o arquivo `/media/fat/MiSTer.ini` existe.
- Os scripts de escrita assumem que ja existe uma linha `vsync_adjust=` no `MiSTer.ini`.
- O backup e sobrescrito no mesmo caminho a cada execucao.
- O `vsync_check.sh` exibe o valor no terminal e, se existir, tambem usa `OSDutils` em `/media/fat/Scripts/OSDutils`.

### 2. Script de Desligamento Seguro

O script `poweroff_countdown.sh` realiza um desligamento seguro do MiSTer com contagem regressiva visivel na tela.

Uso:

```bash
./poweroff_countdown.sh [SEGUNDOS]
```

Se nenhum valor for informado, o padrao e `10` segundos.

#### O que o script faz

1. Inicia uma contagem regressiva no terminal.
2. Exibe mensagens em fonte grande para facilitar a leitura.
3. Permite cancelar o desligamento ao apertar qualquer botao do controle.
4. Executa `sync` antes do desligamento.
5. Chama `poweroff`, `shutdown -h now` ou `busybox poweroff`, dependendo do que estiver disponivel.

#### Detalhes de funcionamento

- O monitoramento do controle usa `/dev/input/js0`.
- O cancelamento tambem pode acontecer por entrada lida no terminal.
- O script tenta restaurar o estado original do terminal ao encerrar.
- A fonte grande usada e `solar24x32.psfu.gz`, quando disponivel no sistema.

## Instalacao

Copie os scripts para:

```bash
/media/fat/Scripts
```

Depois, execute pelo menu de scripts do MiSTer ou pelo terminal, conforme sua rotina.

## Exemplo de Uso

Verificar o valor atual:

```bash
./vsync_check.sh
```

Definir `vsync_adjust=2`:

```bash
./vsync2.sh
```

Desligar com 15 segundos de contagem:

```bash
./poweroff_countdown.sh 15
```

## Resumo Rapido

- configuracao rapida de `vsync_adjust`
- backup automatico do `MiSTer.ini` antes de alterar o VSync
- leitura do valor atual com `vsync_check.sh`
- desligamento seguro com cancelamento por controle

## Autor

Fred Oliveira

## Licenca

MIT
