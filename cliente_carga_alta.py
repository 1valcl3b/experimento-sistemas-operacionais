import socket
import time

host = "192.168.100.112"  #IP do serv
porta = 5000
qtd = 10  #Carga ALTA

def cliente():
    print(f"\nCliente com carga ALTA ({qtd} mensagens)")

    for i in range(qtd):
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as cliente:
                cliente.connect((host, porta))
                mensagem = f"Mensagem {i+1} da carga ALTA"
                cliente.sendall(mensagem.encode())
                resposta = cliente.recv(1024)
                print(f"Recebido: {resposta.decode()}")
        except Exception as erro:
            print(f"Erro: {erro}")

        time.sleep(1)

if __name__ == "__main__":
    cliente()

