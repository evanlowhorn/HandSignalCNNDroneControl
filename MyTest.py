#Derived from script linked in TELLO SDK [4]
#Adapted to perform autonomously by Evan Lowhorn

#socket required for wifi comms
#threading required for multithreading
#time required for time-stamping events
import socket
import threading
import time

#Initialize send and recieve UDP ports
host = ''
port = 9000
localAddress = (host, port)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

tello_address = ('192.168.10.1', 8889)

sock.bind(localAddress)

start_time = time.time()

#Initialize ok variable as false
okreceived = False

#Secondary main function executed with multithreading
def recv():
    while True:
        #Try attempts to perform an action
        #If a pre-defined exception occurs the except will execute
        try:
            #Define data recieved from drone
            data, server = sock.recvfrom(1518)
            #Decode message
            recvmsg = data.decode(encoding="utf-8")
            #Print the message along with timestamp
            print(recvmsg + " received %s" % (time.time() - start_time))
            #Declare ok as global to pass between threads
            #Set ok to true if there was no error message
            if 'error' not in recvmsg:
                global okreceived
                okreceived = True
            #Close comms and exit thread if error recieved
            else:
                print("Error Received")
                sock.close()
                exit()

        except Exception:
            print('\nConnection Error. Exiting . . .\n')
            break

#Define and start the additional thread
receiveThread = threading.Thread(target=recv)
receiveThread.start()

#Pre-defined command array
#Refer to TELLO SDK [4] or Appendix A for command definitions
commands = ["command", "battery?", "takeoff", "up 40", "right 30", "flip l", "flip r", "land", "end"]
commandIndex = 0

while True:
    try:
        #Define message
        msg = commands[commandIndex]
        
        #If at last command terminate
        if msg == "end":
            sock.close()
            break
        #Encode message, send message, and print message with timestamp
        msg = msg.encode(encoding="utf-8")
        sent = sock.sendto(msg, tello_address)
        print(msg + " sent %s" % (time.time() - start_time))
        #Define ok as global again
        #Do nothing until receiving thread changes ok to True
        global okreceived
        while not okreceived:
            pass
        #Set ok back to False so the above loop will execute
        okreceived = False

    except KeyboardInterrupt:
        print('\n . . . \n')
        sock.close()
        break
        
    #Increment to continue iteration
    commandIndex += 1
print("done")
