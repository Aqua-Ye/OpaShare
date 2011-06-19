all: opa_share.exe

opa_share.exe: src/types.opa src/db.opa src/main.opa
	opa src/types.opa src/db.opa src/main.opa -o opa_share.exe

clean:
	\rm -Rf *.exe _build _tracks *.log
