import serial
import time

BAUD_RATE = 9600
BASYS3_PORT = "/dev/ttyUSB1"

def send_bytes(data: bytes):
    ser.write(data)
    ser.flush()

def send_string(s: str):
    ser.write(s.encode('utf-8'))
    ser.flush()

def read_line():
    """Reads until newline (\n). Returns bytes or b'' on timeout."""
    return ser.readline()

def read_bytes(n):
    """Read exactly n bytes (or fewer on timeout)."""
    return ser.read(n)

if __name__ == "__main__":

    # Open serial port
    ser = serial.Serial(
        port=BASYS3_PORT,
        baudrate=BAUD_RATE,
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        timeout=1)

    time.sleep(2)  # Allow UART to start up

    print("Sending data to FPGA...")
    send_string("Hello FPGA!\n")


    print("Waiting for FPGA response...")

    # Example 1: Expecting text
    resp = read_line()
    print("FPGA says (line):", resp)

    ser.close()
