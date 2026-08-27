---
name: english-vocab
description: Activar cada vez que el usuario escriba un mensaje en inglés (o mezcle inglés con español). Ejecuta play_vocab.sh, que elige una palabra al azar de words.json y la muestra en pantalla Y la reproduce en voz alta al mismo tiempo (inglés + traducción en español + tres oraciones de ejemplo).
---

# English Vocab Booster (audio + texto)

## Cuándo activarse
- El usuario escribe una oración o frase en inglés dentro del chat (aunque sea corta).
- No se activa si el mensaje es 100% código, comandos de terminal, o texto técnico sin intención comunicativa (ej: "npm install").

## Qué hacer
Ejecutar el script de esta misma carpeta:

```bash
bash play_vocab.sh
```

El script imprime cada parte (palabra, significado, cada oración) justo antes de reproducir su audio correspondiente. Muestra ese output tal cual en tu respuesta al usuario — no lo resumas ni lo reformules, y no agregues comentario extra encima. La idea es que se lea y se escuche al mismo tiempo, sincronizado.

## Orden (texto + audio en paralelo, ya resuelto por el script)
1. 📘 palabra (texto) + audio en inglés (en_US-lessac-high)
2. Pausa 1 seg
3. 🔤 "Significa: ..." (texto) + audio en español (es_MX-claude-high)
4. Pausa 1 seg
5. 1️⃣ oración 1 (texto) + audio en inglés
6. Pausa 1 seg
7. 2️⃣ oración 2 (texto) + audio en inglés
8. Pausa 1 seg
9. 3️⃣ oración 3 (texto) + audio en inglés

## Notas
- No repitas la misma palabra dos veces seguidas si puedes evitarlo.
- Si el usuario dice "otra por favor" o similar, vuelve a correr `bash play_vocab.sh`.
- Requiere: entorno virtual `~/tts-env` con piper-tts instalado, modelos `en_US-lessac-high` y `es_MX-claude-high` en `~/piper-voices/`, y en `~/.codex/config.toml` (si se usa desde Codex): `writable_roots = ["/mnt/c/Users/LENOVO"]` y `network_access = true` bajo `[sandbox_workspace_write]`.