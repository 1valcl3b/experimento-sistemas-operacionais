import socket

host = '0.0.0.0'  # Aceita conexões de qualquer IP
porta = 5000      # Porta para escutar

# Cria o socket TCP
soquete_servidor = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
soquete_servidor.bind((host, porta))
soquete_servidor.listen()

print(f"Servidor escutando na porta {porta}...")

while True:
    conexao, endereco = soquete_servidor.accept()
    print(f"Conexão recebida do {endereco}")
    dados_recebidos = conexao.recv(1024).decode()
    print(f"Mesagem recebida: {dados_recebidos}")
    conexao.sendall("Mensagem recebida!".encode())
    conexao.close()

