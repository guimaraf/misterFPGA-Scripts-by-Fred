# 🕹️ MiSTerFPGA — Scripts by Fred Oliveira
Scripts utilitários para gerenciamento avançado do MiSTer FPGA  
Inclui ferramentas para configuração rápida de vsync_adjust e um script seguro de desligamento com contagem regressiva.

## 📦 Conteúdo do Repositório
Script: vsync_check.sh -> Exibe o valor atual de vsync_adjust

Script: vsync0.sh -> Define vsync_adjust=0

Script: vsync1.sh -> Define vsync_adjust=1

Script: vsync2.sh -> Define vsync_adjust=2

Script: poweroff_countdown_sh -> Desliga o MiSTer com contagem regressiva segura

# Parte 1 — Scripts de VSync Adjust
O parâmetro controla como o MiSTer FPGA sincroniza o sinal de vídeo com a tela.

Valores:
0 - Sem ajuste de VSync

1 - Ajuste parcial

2 - Ajuste completo (recomendado)

Instalação:
Copiar scripts para /media/fat/Scripts

Uso:
./vsync_check.sh

./vsync0.sh

./vsync1.sh

./vsync2.sh

Backup automático em /media/fat/iniBkp

# Parte 2 — poweroff_countdown_sh
Script de desligamento seguro com contagem regressiva.

Instalação:

Copiar para /media/fat/Scripts

Uso:

poweroff_countdown_sh [SEGUNDOS]

Funciona realizando:
1. Contagem regressiva
2. sync
3. Mensagem final
4. Desligamento

Licença MIT

Autor: Fred Oliveira