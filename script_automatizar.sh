#!/bin/bash

CLIENT_SCRIPTS=("cliente_carga_baixa.py" "cliente_carga_media.py" "cliente_carga_alta.py")
CARGAS=("baixa" "media" "alta")

REPETICOES=10

RESULTADOS_DIR="resultados"
mkdir -p "$RESULTADOS_DIR"

coletar_metricas() {
    PID=$(pgrep -f servidor.py)
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

    echo "PID do servidor: $PID"

    pidstat -u -p $PID 1 1 > "$RESULTADOS_DIR/cpu_${CARGA}_${i}_${TIMESTAMP}.txt"

    cat /proc/$PID/status | grep ctxt > "$RESULTADOS_DIR/context_${CARGA}_${i}_${TIMESTAMP}.txt"
    
    iostat -dx 1 1 > "$RESULTADOS_DIR/io_${CARGA}_${i}_${TIMESTAMP}.txt"
}

for idx in "${!CLIENT_SCRIPTS[@]}"; do
    SCRIPT=${CLIENT_SCRIPTS[$idx]}
    CARGA=${CARGAS[$idx]}
    echo -e "\n============== Iniciando testes de CARGA: $CARGA ==============\n"

    for ((i=1; i<=REPETICOES; i++)); do
        echo -e "\n[$CARGA] Execução $i de $REPETICOES\n"

        python3 "$SCRIPT" &
        sleep 5
        coletar_metricas 
        wait

        echo "[OK] Métricas salvas para execução $i ($CARGA)"
        sleep 3
    done
done

echo -e "\n=== Fim do experimento ===\n"
