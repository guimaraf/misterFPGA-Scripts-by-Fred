# misterFPGA-Scripts-by-Fred
🕹️ Scripts de Gerenciamento do vsync_adjust para MiSTer FPGA

Este repositório contém um conjunto de scripts simples e seguros para
verificar e alterar o valor de vsync_adjust no arquivo MiSTer.ini.

Eles foram criados para facilitar a vida de quem quer testar rapidamente
os diferentes modos de sincronização do MiSTer, sem precisar editar o
arquivo manualmente.

📁 Arquivos incluídos

  Script           Função
  ---------------- --------------------------------------
  vsync_check.sh   Mostra o valor atual de vsync_adjust
  vsync0.sh        Define vsync_adjust=0
  vsync1.sh        Define vsync_adjust=1
  vsync2.sh        Define vsync_adjust=2

Todos os scripts fazem backup automático do arquivo MiSTer.ini antes de
aplicar qualquer alteração.

📌 O que é vsync_adjust?

O parâmetro vsync_adjust controla como o MiSTer FPGA ajusta a
sincronização vertical do vídeo.

  Valor   Descrição
  ------- -------------------------------------------------------------
  0       Sem ajuste de VSync (menor compatibilidade, menor latência)
  1       Ajuste parcial (boa compatibilidade com TVs modernas)
  2       Ajuste completo (modo mais recomendado)

🔧 Instalação

1.  Baixe ou clone este repositório no seu cartão SD.
2.  Copie todos os scripts para:

/media/fat/Scripts

3.  No MiSTer, abra o menu Scripts e execute o arquivo desejado.

▶️ Como usar

Verificar o valor atual

./vsync_check.sh

Definir vsync_adjust=0

./vsync0.sh

Definir vsync_adjust=1

./vsync1.sh

Definir vsync_adjust=2

./vsync2.sh

🛡️ Backup automático

Diretório: /media/fat/iniBkp

Arquivo: /media/fat/iniBkp/backupMister.ini

❗ Observações importantes

-   Reinicie o MiSTer após alterar o valor.
-   Os scripts não criam a linha caso ela não exista.
-   OSDutils é opcional.

poweroff_countdown_sh
=====================
Desligamento seguro do MiSTer FPGA com contagem regressiva automática.

1. Descrição Geral
------------------
Este script realiza o desligamento seguro do MiSTer FPGA após uma contagem regressiva configurável.
Ele sincroniza os dados no cartão SD antes de desligar, evitando corrupção de arquivos
e exibindo uma mensagem final confirmando que já é seguro cortar a alimentação.

2. Principais Recursos
----------------------
- Contagem regressiva configurável (padrão: 10 segundos)
- Sem interação do usuário, sem cancelamento
- Ideal para uso apenas com gamepad
- Executa "sync" antes do desligamento
- Usa automaticamente o comando disponível: poweroff, shutdown ou busybox poweroff
- Exibe mensagem final confirmando segurança para desligar
- Simples, leve e confiável

3. Instalação
-------------
Coloque o arquivo na pasta:
/media/fat/Scripts

O script aparecerá automaticamente no menu:
System → Scripts

4. Uso
------
Execução via menu ou pelo terminal:
poweroff_countdown_sh [SEGUNDOS]

Exemplos:
poweroff_countdown_sh
(desliga em 10 segundos)

poweroff_countdown_sh 5
(desliga em 5 segundos)

5. Funcionamento
----------------
1. Exibe o aviso de contagem regressiva
2. Conta o tempo (sem permitir cancelamento)
3. Executa "sync" para garantir flush no SD
4. Exibe mensagem informando que já é seguro desligar
5. Chama o comando de desligamento disponível

A tela pode permanecer estática após a sincronização.
Isso é normal: o cartão SD já foi preparado e os comandos estão desabilitados.

6. Código-Fonte
----------------
(cole seu script aqui)

7. Licença
---------
Licença MIT.
Livre para uso, modificação e distribuição.