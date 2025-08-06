import socket
import threading

host = "192.168.100.111"
porta = 5059

quantidade = 50
nivel = "alta" #Apenas para visualziar o NIVEL da CARGA

def mandar_mensagem(num):
    try:
        cliente = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        cliente.connect((host, porta))
        msg = f"{num} da carga {nivel}"
        cliente.send(msg.encode())
        resposta = cliente.recv(1024).decode()  
        print(f"[{num}] Resposta: {resposta}")
        cliente.close()
    except:
        print(f"[{num}] Deu erro")

def main():
    print(f"Enviando {quantidade} mensagens ({nivel})")
    threads = []
    for i in range(quantidade):
        t = threading.Thread(target=mandar_mensagem, args=(i+1,))
        threads.append(t)
        t.start()

    for t in 
        t.join()
	
    print("Pronto")

main()
