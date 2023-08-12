package main

import (
	"fmt"
	"log"
	"net"
	"strings"
	"time"
)

func main() {
	udpServer, err := net.ListenPacket("udp", ":10157")
	if err != nil {
		log.Fatal(err)
	}
	defer udpServer.Close()

	for {
		buf := make([]byte, 4096)
		n, addr, err := udpServer.ReadFrom(buf)
		trimmed := strings.Trim(string(buf), "\n")
		log.Printf("Message: (%d) %s\n", n, trimmed)
		if err != nil {
			log.Printf("Failed with %v.\n", err)
			continue
		}
		go responde(udpServer, addr, trimmed)
	}

}

func responde(udpServer net.PacketConn, addr net.Addr, message string) {
	time := time.Now().Format(time.ANSIC)
	res := fmt.Sprintf("Time: %v. Message: %d bytes", time, len(message))

	udpServer.WriteTo([]byte(res), addr)
}
