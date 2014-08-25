package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"sync"
)

const Zero = int('0')

type Message struct {
	Value int
	X, Y  int
}

type ByCoordinates []Message

func (p ByCoordinates) Len() int      { return len(p) }
func (p ByCoordinates) Swap(i, j int) { p[i], p[j] = p[j], p[i] }
func (p ByCoordinates) Less(i, j int) bool {
	return p[i].X < p[j].X || p[i].X == p[j].X && p[i].Y < p[j].Y
}

var (
	filename string
	n, m     int
	wg       sync.WaitGroup
	data     []byte
	in       = make(chan Message, 10000)
	out      = make(chan Message, 10000)
	done     = make(chan bool, 10)
	ans      []Message
)

func is_digit(x int) (int, bool) {
	switch x {
	case 0x7B6F:
		return 0, true
	case 0x6497:
		return 1, true
	case 0x73E7:
		return 2, true
	case 0x73CF:
		return 3, true
	case 0x5BC9:
		return 4, true
	case 0x79CF:
		return 5, true
	case 0x79EF:
		return 6, true
	case 0x72D2:
		return 7, true
	case 0x7BEF:
		return 8, true
	case 0x7BCF:
		return 9, true
	default:
		return -1, false
	}
}

func listen(ch chan Message) {
	digit := 0
	for {
		select {
		case a := <-ch:
			digit = (digit<<3 | a.Value) & 0x7FFF //0b111111111111111
			if ans, ok := is_digit(digit); ok {
				out <- Message{ans, a.X, a.Y}
				<-done
			}
			wg.Done()
		}
	}
}

func CreateColumns() []chan Message {
	var col []chan Message
	for j := 0; j < m; j++ {
		col = append(col, make(chan Message, 10))
		go listen(col[j])
	}
	return col
}

func MakeAns() {
	for {
		select {
		case a := <-out:
			ans = append(ans, a)
			done <- true
		}
	}
}

func init() {
	var err error
	if len(os.Args) != 4 {
		fmt.Printf("usage: %s <filename> <rows> <columns>\n", os.Args[0])
		os.Exit(0)
	}
	filename = os.Args[1]
	n, err = strconv.Atoi(os.Args[2])
	if err != nil {
		fmt.Printf("%s is not number!\n", os.Args[2])
		os.Exit(0)
	}
	m, err = strconv.Atoi(os.Args[3])
	if err != nil {
		fmt.Printf("%s is not number!\n", os.Args[3])
		os.Exit(0)
	}
}

func main() {
	f, err := os.Open(filename)
	if err != nil {
		fmt.Println(err.Error())
		return
	}

	wg.Add(n * m)
	cols := CreateColumns()
	go MakeAns()

	scanner := bufio.NewScanner(f)
	i := 0
	for scanner.Scan() {
		data := scanner.Bytes()
		hash := 0
		for j := 0; j < m; j++ {
			hash = ((hash << 1) | (int(data[j]) - Zero)) & 0x7
			cols[j] <- Message{hash, i, j}
		}
		i++
	}

	wg.Wait()
	sort.Sort(ByCoordinates(ans))

	for _, a := range ans {
		fmt.Printf("Digit %d on (%d, %d)\n", a.Value, a.X, a.Y)
	}
}
