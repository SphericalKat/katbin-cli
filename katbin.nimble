# Package

version       = "0.1.0"
author        = "Amogh Lele"
description   = "A CLI for katbin"
license       = "MIT"
srcDir        = "src"
bin           = @["katbin"]


# Dependencies

requires "nim >= 1.6.6"

task release, "Release task":
    echo "Building katbin in release mode"
    exec "mkdir -p out"
    exec "nim c --opt:size -d:ssl -d:release -d:danger --gc:arc --outdir:out src/katbin.nim"
    exec "strip -u -r ./out/katbin"