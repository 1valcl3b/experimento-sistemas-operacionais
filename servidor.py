import socket
import threading

host = '0.0.0.0'
porta = 5059

def cliente(conexao, endereco):
    print(f"[+] Conexão de {endereco}")
    try:
        dados = conexao.recv(1024).decode()
        print(f"[{endereco}] Mensagem: {dados}")
        conexao.sendall("Mensagem recebida!".encode())
    except Exception as erro:
        print(f"[!] Erro com {endereco}: {erro}")
    finally:
        conexao.close()

def iniciar_servidor():
    servidor = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    servidor.bind((host, porta))
    servidor.listen()
    print(f"Servidor escutando na porta {porta}...")

    while True:
        conexao, endereco = servidor.accept()
        thread = threading.Thread(target=cliente, args=(conexao, endereco))
        thread.start()

if __name__ == "__main__":
    iniciar_servidor()
