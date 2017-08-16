RUNTIME_H = runtime_$(shell go env GOARCH).h

fastcgo: fastcgo.a libhello.a  
	go tool link -o fastcgo -extld clang -buildmode exe -buildid b01dca11ab1e -linkmode external -v -extldflags='libhello.a' fastcgo.a

libhello.a: hello.cc
	gcc -o hello.o -c hello.cc
	ar -r libhello.a hello.o

$(RUNTIME_H): runtime.go
	go tool compile -asmhdr $@ $^

fastcgo.a: trampoline.go runtime.go trampoline.o
	go tool compile -o fastcgo.a -p main -buildid b01dca11ab1e -pack trampoline.go runtime.go
	go tool pack r fastcgo.a trampoline.o

trampoline.o: trampoline.s $(RUNTIME_H)
	go tool asm -I "$(shell go env GOROOT)/pkg/include" -D GOOS_darwin -D GOARCH_amd64 -o trampoline.o trampoline.s
