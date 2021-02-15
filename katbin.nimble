# Package

version       = "0.1.0"
author        = "SphericalKat"
description   = "CLI for katb.in"
license       = "MIT"
srcDir        = "src"
bin           = @["katbin"]


# Dependencies

requires "nim >= 1.4.2", "cligen", "regex"
