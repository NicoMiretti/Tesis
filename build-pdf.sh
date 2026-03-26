#!/bin/bash
# build-pdf.sh - Genera el PDF de la tesis combinando todos los capitulos
#
# Requisitos:
#   sudo apt-get install pandoc texlive-latex-recommended texlive-latex-extra \
#     texlive-fonts-recommended texlive-lang-spanish
#
# Uso:
#   ./build-pdf.sh              # Genera tesis/output/tesis.pdf
#   ./build-pdf.sh --word       # Genera tesis/output/tesis.docx (Word)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CAPITULOS_DIR="$SCRIPT_DIR/tesis/capitulos"
OUTPUT_DIR="$SCRIPT_DIR/tesis/output"
METADATA="$SCRIPT_DIR/tesis/metadata.yaml"

# Crear directorio de salida
mkdir -p "$OUTPUT_DIR"

# Verificar que pandoc este instalado
if ! command -v pandoc &> /dev/null; then
    echo "ERROR: pandoc no esta instalado."
    echo "Instalar con:"
    echo "  sudo apt-get install pandoc texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-lang-spanish"
    exit 1
fi

# Buscar capitulos ordenados
ARCHIVOS=$(find "$CAPITULOS_DIR" -name "*.md" ! -name "README.md" | sort)

if [ -z "$ARCHIVOS" ]; then
    echo "ERROR: No se encontraron capitulos en $CAPITULOS_DIR"
    exit 1
fi

echo "Capitulos encontrados:"
for f in $ARCHIVOS; do
    echo "  - $(basename "$f")"
done

if [ "$1" = "--word" ]; then
    OUTPUT="$OUTPUT_DIR/tesis.docx"
    echo ""
    echo "Generando Word: $OUTPUT"
    pandoc "$METADATA" $ARCHIVOS \
        -o "$OUTPUT" \
        --toc \
        --number-sections \
        --reference-doc="$SCRIPT_DIR/tesis/reference.docx" 2>/dev/null \
        || pandoc "$METADATA" $ARCHIVOS \
            -o "$OUTPUT" \
            --toc \
            --number-sections
else
    OUTPUT="$OUTPUT_DIR/tesis.pdf"
    echo ""
    echo "Generando PDF: $OUTPUT"
    pandoc "$METADATA" $ARCHIVOS \
        -o "$OUTPUT" \
        --pdf-engine=pdflatex \
        --toc \
        --number-sections \
        -V colorlinks=true \
        -V linkcolor=blue \
        -V urlcolor=blue
fi

echo "Listo: $OUTPUT"
