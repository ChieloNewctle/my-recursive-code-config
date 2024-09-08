version := `date +%Y.%m.%d`

archive target:
    mkdir -p ./releases
    cd "./fonts/{{ target }}" ;\
    tar --owner=0 --group=0 --numeric-owner -czvf \
    "../../releases/{{ target }}.{{ version }}.tgz" *

archive-all:
    @just archive RecMonoChielo
    @just archive RecMonoChieloNerdFont
