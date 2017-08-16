package bench

// #include <stdint.h>
// #include <stdio.h>
//
// void noop() {
// }
// void hello(uint64_t arg) {
//   printf("Hello, C: %lld\n", arg);
// }
import "C"

import (
	"fmt"

	"github.com/petermattis/fastcgo"
)

var global bool

func noopGo() {
	if global {
		fmt.Println("noopGo")
	}
}

func noopCgo() {
	C.noop()
}

func noop() {
	fastcgo.UnsafeCall0(C.noop)
}

func hello(arg uint64) {
	fastcgo.UnsafeCall4(C.hello, arg, 0, 0, 0)
}
