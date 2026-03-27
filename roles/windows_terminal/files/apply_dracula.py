#!/usr/bin/env python3
"""
Apply the Dracula colour scheme to Windows Terminal settings.json.
Sets `colorScheme` on every profile whose name or source contains
"ubuntu" (case-insensitive). Does not touch `schemes[]` — Windows
Terminal manages that array itself and will strip foreign entries.

Exits 0 and prints "changed" if the file was modified, "ok" if already correct.
"""
import json
import shutil
import sys
from pathlib import Path


def strip_jsonc(text):
    """Strip // and /* */ comments, ignoring content inside strings."""
    result = []
    i = 0
    in_string = False
    while i < len(text):
        c = text[i]
        if in_string:
            result.append(c)
            if c == '\\' and i + 1 < len(text):   # escape sequence
                i += 1
                result.append(text[i])
            elif c == '"':
                in_string = False
        elif c == '"':
            in_string = True
            result.append(c)
        elif c == '/' and i + 1 < len(text) and text[i + 1] == '/':
            while i < len(text) and text[i] != '\n':  # skip to EOL
                i += 1
            continue
        elif c == '/' and i + 1 < len(text) and text[i + 1] == '*':
            i += 2
            while i < len(text) - 1 and not (text[i] == '*' and text[i + 1] == '/'):
                i += 1
            i += 2  # skip closing */
            continue
        else:
            result.append(c)
        i += 1
    return ''.join(result)


def is_ubuntu_profile(profile):
    name = profile.get('name', '').lower()
    source = profile.get('source', '').lower()
    return 'ubuntu' in name or 'ubuntu' in source


def main():
    path = Path(sys.argv[1])

    raw = path.read_text(encoding='utf-8-sig')  # strip BOM if present
    raw = raw.replace('\r\n', '\n').replace('\r', '\n')
    settings = json.JSONDecoder(strict=False).decode(strip_jsonc(raw))

    changed = False

    # Apply to Ubuntu profiles
    for profile in settings.get('profiles', {}).get('list', []):
        if is_ubuntu_profile(profile) and profile.get('colorScheme') != 'Dracula':
            profile['colorScheme'] = 'Dracula'
            changed = True

    if changed:
        shutil.copy2(path, path.with_suffix('.json.bak'))
        path.write_text(
            json.dumps(settings, indent=4, ensure_ascii=False),
            encoding='utf-8',
        )
        print("changed")
    else:
        print("ok")


if __name__ == '__main__':
    main()
