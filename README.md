# fastcgo

Fast (but unsafe) Cgo calls via an assembly trampoline. Inspired by
[rustgo](https://blog.filippo.io/rustgo/). The `UnsafeCall*` function
takes a pointer to a Cgo function and a number of arguments and
executes the function on the "system stack" of the thread the current
Goroutine is running on. Usage looks like:

```
package hello

// #include <stdint.h>
// #include <stdio.h>
// void hello(uint64_t arg) {
//   printf("Hello, C: %lld\n", arg)
// }
import "C"

import (
	"github.com/petermattis/fastcgo"
)

func Hello(arg uint64) {
	fastcgo.UnsafeCall4(C.hello, arg, 0, 0, 0)
}
```

The upshot is significantly faster transitions into C/C++:

```
~/go/src/github.com/petermattis/fastcgo master go test -run=- -bench=. ./bench/
...
BenchmarkGO-8        	2000000000	         1.90 ns/op
BenchmarkCGO-8       	30000000	        60.1  ns/op
BenchmarkFastCGO-8   	300000000	         4.63 ns/op
...
```

*WARNING*: No attempt is made to play nice with the Go scheduler or
GC. The goroutine executing a fastcgo call will never be interrupted
and will delay the starting or completion of GC until it finishes.
