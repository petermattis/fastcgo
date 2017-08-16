// +build go1.8,!go1.9

package fastcgo

type stack struct {
	lo uintptr
	hi uintptr
}

type gobuf struct {
	sp   uintptr
	pc   uintptr
	g    uintptr
	ctxt uintptr
	ret  uintptr
	lr   uintptr
	bp   uintptr
}

type m struct {
	g0 *g
}

type g struct {
	stack       stack
	stackguard0 uintptr
	stackguard1 uintptr

	_panic     uintptr
	_defer     uintptr
	m          *m
	stackAlloc uintptr
	sched      gobuf
}
