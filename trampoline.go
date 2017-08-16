package main

import (
	"fmt"
	"testing"
	_ "unsafe"
)

//go:cgo_import_static hello
//go:cgo_import_dynamic hello

//go:linkname hello hello
var hello byte

func trampoline(fn *byte, arg0, arg1, arg2, arg3 uintptr)

func main() {
	fmt.Printf("BenchmarkFastCGO\t%v\n", testing.Benchmark(func(b *testing.B) {
		for i := 0; i < b.N; i++ {
			trampoline(&hello, 42, 0, 0, 0)
		}
	}))
}
