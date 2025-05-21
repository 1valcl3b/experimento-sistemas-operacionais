#!/bin/bash

# Arquivo de saída
OUTPUT_FILE="resultados_experimento.csv"

# Cabeçalho do arquivo CSV
echo "Repeticao,CPU_Usage,Trocas_Contexto_Voluntarias,Trocas_Contexto_Involuntarias,Leitura_KBps,Escrita_KBps" > $OUTPUT_FILE

# Número de repetições do experimento
NUM_REPETICOES=10

# Identificar o PID do servidor
PID=$(pgrep -f servidor.py)

if [ -z "$PID" ]; then
    echo "Erro: O servidor não está rodando!"
    exit 1
fi

echo "Iniciando experimento... Coletando métricas para o processo $PID"

for i in $(seq 1 $NUM_REPETICOES); do
    echo "Rodada $i..."

    # Captura o uso da CPU do servidor (ignora a 1ª linha do pidstat)
    CPU_USAGE=$(pidstat -p $PID 1 1 | awk 'NR==4 {print $8}') 

    # Captura as trocas de contexto voluntárias e involuntárias
    VOLUNTARIAS=$(grep voluntary_ctxt_switches /proc/$PID/status | awk '{print $2}')
    INVOLUNTARIAS=$(grep nonvoluntary_ctxt_switches /proc/$PID/status | awk '{print $2}')
    
    # Captura estatísticas de I/O (leitura/escrita)
    IO_STATS=$(iostat -d -k 1 1 | awk '/sda/ {print $3","$4}')

    # Verifica se os dados foram capturados corretamente
    if [ -z "$CPU_USAGE" ] || [ -z "$VOLUNTARIAS" ] || [ -z "$INVOLUNTARIAS" ] || [ -z "$IO_STATS" ]; then
        echo "Erro ao capturar dados na repetição $i. Pulando..."
        continue
    fi

    # Salva os dados no arquivo CSV
    echo "$i,$CPU_USAGE,$VOLUNTARIAS,$INVOLUNTARIAS,$IO_STATS" >> $OUTPUT_FILE
    sleep 5  # Aguarda 5 segundos entre as repetições
done

echo "Experimento finalizado. Resultados salvos em $OUTPUT_FILE"
