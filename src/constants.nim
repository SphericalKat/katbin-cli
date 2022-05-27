let helpText* = """
katbin
Amogh Lele 'sphericalkat' <amolele@gmail.com>
a command line interface for katb.in

USAGE:
    katbin <BODY>

ARGS:
    <BODY>

OPTIONS:
    -h, --help       Print help information"""

let missingArgs* = """error: The following required arguments were not provided:
    <BODY>

USAGE:
    katbin <BODY>

For more information try --help"""

let unexpectedArg* = """
error: Found an argument which wasn't expected, or isn't valid in this context


USAGE:
    katbin <BODY>

For more information try --help
"""
