import socket
import threading

host = '0.0.0.0'
porta = 5059

def cliente(con, end):  # Função para atender cliente
    print(f"Conexão de {end}")
    msg = con.recv(1024).decode()
    print(f"Mensagem de {end}: {msg}")
    con.sendall("Mensagem recebida!".encode())
    con.close()

def servidor():  # Função para iniciar o SERV
    serv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    serv.bind((host, porta))
    serv.listen()
    print(f"Servidor ouvindo na porta {porta}...")

    while True:
        con, end = serv.accept()
        t = threading.Thread(target=cliente, args=(con, end))
        t.start()

servidor()
