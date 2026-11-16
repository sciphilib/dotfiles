# Dictionaries

`russian.txt`: 146269 unique UTF-8 words from Alexander I. Lebedev's
Hunspell dictionary, distributed by wooorm/dictionaries:
https://github.com/wooorm/dictionaries/tree/main/dictionaries/ru

Exact source Git blob: `e5cfd3614c2303be12da481198b5d914e592da9c`.
Transformation: decode UTF-8, remove the first (count) line, strip `/...`
flags, sort and deduplicate words. Affixes are not expanded.
License is preserved in `russian-LICENSE.txt`.

English on macOS: `/usr/share/dict/words` (system dictionary), instead of
Ubuntu's `/usr/share/dict/american-english`. Override
`my-text-dictionary-files` for another dictionary.
