#!/usr/bin/env bash
# Genera la palabra SOLA primero (sin competencia de CPU) para que suene rápido,
# y mientras se reproduce, lanza de fondo el resto (significado + 3 ejemplos).
set -e

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORDS_FILE="$SKILL_DIR/words.json"

PIPER_BIN="$HOME/tts-env/bin/piper"
VOICE_EN="$HOME/piper-voices/en_US-lessac-high.onnx"
VOICE_ES="$HOME/piper-voices/es_MX-claude-high.onnx"

OUT_DIR="/mnt/c/Users/LENOVO"
RUN_ID="$$"
WIN_DIR="C:\\Users\\LENOVO"

# 1. Elegir palabra al azar (o la especificada como argumento)
ENTRY=$(python3 -c "
import json, random, sys
with open('$WORDS_FILE') as f:
    data = json.load(f)
target = sys.argv[1] if len(sys.argv) > 1 else None
if target:
    matches = [e for e in data if e['word'].lower() == target.lower()]
    entry = matches[0] if matches else random.choice(data)
else:
    entry = random.choice(data)
meanings = entry['meanings']
if len(meanings) > 1:
    meaning_str = ', '.join(meanings[:-1]) + ', o ' + meanings[-1]
else:
    meaning_str = meanings[0]
print(entry['word'])
print(meaning_str)
for ex in entry['examples'][:3]:
    print(ex)
" "$1")

mapfile -t LINES <<< "$ENTRY"
WORD="${LINES[0]}"
MEANINGS="${LINES[1]}"
EX1="${LINES[2]}"
EX2="${LINES[3]}"
EX3="${LINES[4]}"

# 2. Generar SOLO la palabra primero, sin competencia de CPU (rápido)
echo "$WORD." | "$PIPER_BIN" --model "$VOICE_EN" --output_file "$OUT_DIR/parte1_$RUN_ID.wav"

# 3. Apenas está lista, lanzar de fondo el resto (significado + 3 ejemplos)
#    mientras suena la palabra, estos ya se están generando en paralelo
echo "Significa: $MEANINGS." | "$PIPER_BIN" --model "$VOICE_ES" --output_file "$OUT_DIR/parte2_$RUN_ID.wav" &
PID2=$!
echo "$WORD is: $EX1" | "$PIPER_BIN" --model "$VOICE_EN" --output_file "$OUT_DIR/ej1_$RUN_ID.wav" &
PID3=$!
echo "$WORD is: $EX2" | "$PIPER_BIN" --model "$VOICE_EN" --output_file "$OUT_DIR/ej2_$RUN_ID.wav" &
PID4=$!
echo "$WORD is: $EX3" | "$PIPER_BIN" --model "$VOICE_EN" --output_file "$OUT_DIR/ej3_$RUN_ID.wav" &
PID5=$!

# 4. Mostrar + reproducir la palabra YA (mientras el resto sigue generando de fondo)
echo "📘 $WORD"
powershell.exe -Command "(New-Object Media.SoundPlayer '$WIN_DIR\parte1_$RUN_ID.wav').PlaySync()"
sleep 0

# 5. Mostrar + reproducir cada uno apenas SU generación termina
wait $PID2
echo "🔤 Significa: $MEANINGS"
powershell.exe -Command "(New-Object Media.SoundPlayer '$WIN_DIR\parte2_$RUN_ID.wav').PlaySync()"
sleep 0

wait $PID3
echo "1️⃣ $EX1"
powershell.exe -Command "(New-Object Media.SoundPlayer '$WIN_DIR\ej1_$RUN_ID.wav').PlaySync()"
sleep 0

wait $PID4
echo "2️⃣ $EX2"
powershell.exe -Command "(New-Object Media.SoundPlayer '$WIN_DIR\ej2_$RUN_ID.wav').PlaySync()"
sleep 0

wait $PID5
echo "3️⃣ $EX3"
powershell.exe -Command "(New-Object Media.SoundPlayer '$WIN_DIR\ej3_$RUN_ID.wav').PlaySync()"

# 6. Limpiar los .wav de esta corrida (ya no se necesitan)
rm -f "$OUT_DIR"/*_$RUN_ID.wav