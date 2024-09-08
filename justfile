version := `date +%Y.%m.%d`

clean:
    rm -rf ./releases/ ./fonts/RecMonoChielo/ ./fonts/RecMonoChieloNerdFont/

build-recursive:
    test -e venv || python3 -m venv venv
    . venv/bin/activate; \
    pip install -U pip; \
    pip install -r requirements.txt -U; \
    python3 scripts/instantiate-code-fonts.py

build-nerd-font: build-recursive
    mkdir -p ./fonts/RecMonoChieloNerdFont/
    docker pull nerdfonts/patcher
    docker run -it --rm \
        -u "$(id -u)":"$(id -g)" \
        -v ./fonts/RecMonoChielo/:/in:Z \
        -v ./fonts/RecMonoChieloNerdFont/:/out:Z \
        nerdfonts/patcher -c

rebuild: clean build-recursive build-nerd-font

archive target:
    mkdir -p ./releases
    cd "./fonts/{{ target }}"; \
    tar --owner=0 --group=0 --numeric-owner -czvf \
    "../../releases/{{ target }}.{{ version }}.tgz" *

archive-all:
    @just archive RecMonoChielo
    @just archive RecMonoChieloNerdFont

publish: archive-all
    gh release create "v{{ version }}" --latest \
        "./releases/RecMonoChielo.{{ version }}.tgz" \
        "./releases/RecMonoChieloNerdFont.{{ version }}.tgz"
