import argparse

parser = argparse.ArgumentParser(
    prog="Argparsers example"
    description="A program to help you understand argument parsing with turtles"
)


# Since version 0.3.0 of cc.py doens't receive args 
# we need to request them in the program by running:
# | args = input()
# | result = parser.parse_args(args.split())
def parse(parser):
    args = input()
    return parser.parse_args(args.split())

# A simple argument 
def simple_argument(parser):
    parser.add_argument("arg1")
    return parse(parser)
# > test 
# {arg1: "test"}

# Flags ignore the "-" so "-x" will store to key "x" (same with "--x")
# Flags can read in three ways:
#   1. > "-fooVALUE" -> {foo: "VALUE"}
#   2. > "-foo=VALUE" -> {foo: "VALUE"}
#   3. > "-foo VALUE" -> {foo: "VALUE"}

# A flag #
def a_flag(parser):
    parser.add_argument("-use_file", "store_true") # tells parser to store True
    return parse(parser)
# > -use_file
# {use_file: True}

# Multiple flags #
def multiple_flags(parser):
    parser.add_argument("-use_file", "store_true") # tells parser to store True
    parser.add_argument("-file_name") # tells parser to store True
    return parse(parser)
# > -use_file -file_name=TEST
# {use_file: True, file_name: "TEST"}

result = ""

# Defining argument type #
def integer_arg():
    parser.add_argument('--foo', type=int)
    return parse(parser)
# > --foo 123
# {foo: 123}

# > --foo abc
# Argparsers example: error: argument --foo: invalid int value: 'abc'

# Aliasing #
def alias():
    parser.add_argument('--full_name -f', type=int)
    return parse(parser)
# > -f=123
# {full_name: 123}

# Spliting the parser #
def split_a_or_b():
    sub = parser._subparsers(required=True)
    setg = sub.add_parser("set")
    setg.add_argument("x")
    setg.add_argument("y")
    setg.add_argument("z")

    sub.add_parser("list")
    return parse(parser)
# > set 1 2 3
# {x:1, y:2, z:3}

# > set 1
# Argparsers example: error: the following arguments are required: y, z


## TODO Add actions example ##

# Since we can auto run code just from matching valid commands

# Meaning we could create "set({x,y,z})" and call it 
# for that subparser of split_a_or_b

## TODO ##


###################
# Testing grounds #
###################

# Comment and uncomment lines to test each example (in a computer/turtle ...)
#! Uncommenting multiple of these examples is undefined behaviour... take care

# result = simple_argument()
# result = a_flag()
# result = multiple_flags()
# result = split_a_or_b()

print(result)