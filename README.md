# MiSTerFPGA Scripts by Fred Oliveira

## English

Small utility scripts for MiSTer FPGA. Copy the scripts you want to use to:

```bash
/media/fat/Scripts
```

Then run them from the MiSTer Scripts menu or from the terminal.

| Script | Purpose |
| --- | --- |
| `vsync_check.sh` | Shows the current `vsync_adjust` value from `/media/fat/MiSTer.ini`. |
| `vsync0.sh` | Sets `vsync_adjust=0` in `/media/fat/MiSTer.ini` and creates a backup first. |
| `vsync1.sh` | Sets `vsync_adjust=1` in `/media/fat/MiSTer.ini` and creates a backup first. |
| `vsync2.sh` | Sets `vsync_adjust=2` in `/media/fat/MiSTer.ini` and creates a backup first. |
| `poweroff_countdown.sh` | Powers off MiSTer safely after a countdown. Any controller button cancels it. |
| `copyMainOriginal.sh` | Copies `/media/fat/!mainBKP/Original/MiSTer` to `/media/fat/MiSTer`, then forces a reboot. |
| `copyMainRetroArch.sh` | Copies `/media/fat/!mainBKP/RetroArchiviements/MiSTer` to `/media/fat/MiSTer`, then forces a reboot. |
| `restore_update_senhor.sh` | Downloads a fresh `update_senhor.sh` from GitHub and replaces `/media/fat/Scripts/update_senhor.sh`. |
| `update_senhor_Fix.sh` | Patches the local `update_senhor.sh` internet check function and creates a backup. |
| `checkInternetCorrect.sh` | Reference backup of the corrected `check_internet()` function. Not meant to be run directly. |

`update_senhor.sh` is intentionally not documented here because it is not meant to be published in this repository.

## Portugues do Brasil

Scripts utilitarios pequenos para MiSTer FPGA. Copie os scripts que quiser usar para:

```bash
/media/fat/Scripts
```

Depois execute pelo menu de Scripts do MiSTer ou pelo terminal.

| Script | Funcao |
| --- | --- |
| `vsync_check.sh` | Mostra o valor atual de `vsync_adjust` em `/media/fat/MiSTer.ini`. |
| `vsync0.sh` | Define `vsync_adjust=0` em `/media/fat/MiSTer.ini` e cria um backup antes. |
| `vsync1.sh` | Define `vsync_adjust=1` em `/media/fat/MiSTer.ini` e cria um backup antes. |
| `vsync2.sh` | Define `vsync_adjust=2` em `/media/fat/MiSTer.ini` e cria um backup antes. |
| `poweroff_countdown.sh` | Desliga o MiSTer com seguranca apos uma contagem regressiva. Qualquer botao do controle cancela. |
| `copyMainOriginal.sh` | Copia `/media/fat/!mainBKP/Original/MiSTer` para `/media/fat/MiSTer` e depois forca o reboot. |
| `copyMainRetroArch.sh` | Copia `/media/fat/!mainBKP/RetroArchiviements/MiSTer` para `/media/fat/MiSTer` e depois forca o reboot. |
| `restore_update_senhor.sh` | Baixa um `update_senhor.sh` novo do GitHub e substitui `/media/fat/Scripts/update_senhor.sh`. |
| `update_senhor_Fix.sh` | Corrige a funcao de verificacao de internet do `update_senhor.sh` local e cria um backup. |
| `checkInternetCorrect.sh` | Backup de referencia da funcao `check_internet()` corrigida. Nao foi feito para executar diretamente. |

O `update_senhor.sh` foi ignorado de proposito nesta documentacao porque nao sera publicado neste repositorio.

## License

MIT
