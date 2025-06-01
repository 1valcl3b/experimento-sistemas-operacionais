#!/bin/bash

SCRIPT_SERVIDOR="servidor.py"

# Nome do CSV de saída
CSV="resultados.csv"

# Número de repetições
REPETICOES=10

#cabeçalho do CSV
echo -e "repeticao\tcpu_usr\tcpu_sys\tcswch_vol\tcswch_invol\tleitura_kBps\tescrita_kBps" > "$CSV"

for i in $(seq 1 $REPETICOES); do
    echo "Iniciando repetição $i..."

    # Inicia o servidor em background
    python3 "$SCRIPT_SERVIDOR" &
    PID=$!
    sleep 1

    # Capatrar recursos da CPU
    CPU_INFO=$(pidstat -u -p $PID 1 1 | awk '/^[0-9]/ {print $4, $5}') 
    CPU_USR=$(echo "$CPU_INFO" | awk '{print $1}')
    CPU_SYS=$(echo "$CPU_INFO" | awk '{print $2}')

    # Trocas de contexto /proc
    CSWCH_VOL=$(grep voluntary_ctxt_switches /proc/$PID/status | awk '{print $2}')
    CSWCH_INV=$(grep nonvoluntary_ctxt_switches /proc/$PID/status | awk '{print $2}')

    # Captura leitura/escrita 
    DISCO=$(iostat -dx 1 1 | grep -m 1 "^sda")
    LEITURA=$(echo "$DISCO" | awk '{print $6}')   # kB_read/s
    ESCRITA=$(echo "$DISCO" | awk '{print $7}')   # kB_wrtn/s

    # Salva linha no CSV
    echo -e "$i\t$CPU_USR\t$CPU_SYS\t$CSWCH_VOL\t$CSWCH_INV\t$LEITURA\t$ESCRITA" >> "$CSV"
  
    # Encerra o servidor
    kill $PID
    wait $PID 2>/dev/null

    echo "Repetição $i feita"
    sleep 1
done


