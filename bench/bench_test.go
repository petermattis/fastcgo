package bench

import (
	"testing"
)

func TestFastCGO(t *testing.T) {
	hello(42)
}

func BenchmarkGO(b *testing.B) {
	for i := 0; i < b.N; i++ {
		noopGo()
	}
}

func BenchmarkCGO(b *testing.B) {
	for i := 0; i < b.N; i++ {
		noopCgo()
	}
}

func BenchmarkFastCGO(b *testing.B) {
	for i := 0; i < b.N; i++ {
		noop()
	}
}
