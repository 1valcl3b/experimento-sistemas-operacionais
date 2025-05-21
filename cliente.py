import socket
import time
import random

host = "192.168.100.112"  #endereço do serv
porta = 5000       # porta do servidor

# Niveis de carga e número de mensagens por rodada
cargas = {
    "baixa": 2,
    "media": 5,
    "alta": 10
}

def executar_cliente():
    while True:
        nivel = random.choice(["baixa", "media", "alta"])
        quantidade = cargas[nivel]

        print(f"\nSimulando carga {nivel} ({quantidade} mensagens)")

        for i in range(quantidade):
            try:
                with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as cliente:
                    cliente.connect((host, porta))
                    mensagem = f"Mensagem {i+1} da carga {nivel}"
                    cliente.sendall(mensagem.encode())
                    resposta = cliente.recv(1024)
                    print(f"Recebido: {resposta.decode()}")
            except Exception as erro:
                print(f"Erro: {erro}")

        time.sleep(5)

if __name__ == "__main__":
    executar_cliente()

