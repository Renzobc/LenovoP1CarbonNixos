with import <nixpkgs> {};
  mkShell {
    buildInputs = [
      glibcLocales
      bashInteractive # Some recipes expect /bin/bash
    ];

    shellHook = ''
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
      export LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive
    '';
  }
