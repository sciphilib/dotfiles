#!/usr/bin/env python3
"""Explicit, pinned package install. No downloads during Emacs startup."""
import pathlib
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile

ROOT = pathlib.Path(__file__).resolve().parent.parent
SPECS = [('emacs-compat/compat', '31.1.0.0'), ('minad/vertico', '1.7'),
         ('minad/cape', '2.9'), ('minad/consult', '3.10'), ('oantolin/embark', '1.2'),
         ('jrblevin/markdown-mode', 'v2.8')]
emacs = sys.argv[1] if len(sys.argv) > 1 else 'emacs'
with tempfile.TemporaryDirectory(prefix='emacs-packages-') as tmp:
    tmp = pathlib.Path(tmp)
    archives = []
    for repo, tag in SPECS:
        name = repo.split('/')[1]
        source = tmp / name
        subprocess.run(['git', 'clone', '--depth', '1', '--branch', tag,
                        'https://github.com/' + repo + '.git', str(source)], check=True)
        packages = [name, 'embark-consult'] if name == 'embark' else [name]
        for package in packages:
            text = (source / (package + '.el')).read_text()
            version = re.search(r'^;; Version: (.+)$', text, re.M)[1].strip()
            requires = re.search(r'^;; Package-Requires: (.+)$', text, re.M)[1].strip()
            dest = tmp / (package + '-' + version)
            dest.mkdir()
            files = ([source / 'embark-consult.el'] if package == 'embark-consult'
                     else [f for f in source.glob('*.el') if f.name != 'embark-consult.el'])
            if package == 'embark':
                files = [f for f in files if f.name.startswith('embark')]
            if package == 'vertico':
                files += list((source / 'extensions').glob('*.el'))
            for file in files:
                if not file.name.endswith('-tests.el'):
                    shutil.copy(file, dest / file.name)
            for pattern in ('COPYING*', 'LICENSE*'):
                for file in source.glob(pattern):
                    shutil.copy(file, dest / file.name)
            (dest / (package + '-pkg.el')).write_text(
                f';;; -*- lexical-binding: t; -*-\n(define-package "{package}" "{version}" "Pinned package" \'{requires})\n')
            archive = dest.with_suffix('.tar') if '.' not in dest.name else tmp / (dest.name + '.tar')
            with tarfile.open(archive, 'w') as tar:
                tar.add(dest, arcname=dest.name)
            archives.append(str(archive))
    # Use package.el to generate autoloads and compile, resolving only local pinned deps.
    expr = '''(progn (require 'package)
      (setq user-emacs-directory %s package-user-dir (expand-file-name "elpa" user-emacs-directory))
      (package-initialize)
      (dolist (archive command-line-args-left) (package-install-file archive))
      (setq command-line-args-left nil))''' % ('"' + str(ROOT) + '/"')
    subprocess.run([emacs, '-Q', '--batch', '--eval', expr, *archives], check=True)
