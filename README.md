# Snowball Tools

Tools that facilitate Snowball stemmers developing https://snowballstem.org

## Instruction stemmer creation

https://github.com/snowballstem/snowball/blob/master/CONTRIBUTING.rst

## Tools

The path to Snowball must be passed everywhere, e.g. `../snowball` if it is in the sibling directory.

### utf_to_sbl

Script that replaces Latin chars with Unicode letters that facilitate reading the Snowball file.
The script produces a readable `sbl` file, that allows printing it out for human reading and exploring algorithm, for ex.:

```sh
$ bin/sbl_to_utf ../snowball/algorithms/greek.sbl
```

```sh
  //...
  define step7 as (
    [substring] among (
      '{e}{s}{t}{e}{r}' '{e}{s}{t}{a}{t}' '{o}{t}{e}{r}' '{o}{t}{a}{t}' '{u}{t}{e}{r}' '{u}{t}{a}{t}' '{oo}{t}{e}{r}' '{oo}{t}{a}{t}' (delete)
    )
  ) //...

# =>

  //...
  define step7 as (
    [substring] among (
      'εστερ' 'εστατ' 'οτερ' 'οτατ' 'υτερ' 'υτατ' 'ωτερ' 'ωτατ' (delete)
    )
  ) //...
```

### sbl_to_utf

Developing a new stemmer it is convenient to write letters in UTF, like `ш` instead of transcription `{sh}` that is mandatory for `.sbl`, so to do the opposite conversion it needs to run:

```sh
bin/utf_to_sbl ./algorithms/ukrainian/ukrainian.sbl.utf > ../snowball/algorithms/ukrainian.sbl && cd ../snowball && make && cd -
```

This complex command translates `utf` script to `sbl` and build it in the `snowball` folder, and came back to the previous directory:

```sh
# ./algorithms/ukrainian/ukrainian.sbl.utf

  //...
  define step7 as (
    [substring] among (
      'εστερ' 'εστατ' 'οτερ' 'οτατ' 'υτερ' 'υτατ' 'ωτερ' 'ωτατ' (delete)
    )
  ) //...
```
=>
```sh
# ../snowball/algorithms/ukrainian.sbl
  //...
  define step7 as (
    [substring] among (
      '{e}{s}{t}{e}{r}' '{e}{s}{t}{a}{t}' '{o}{t}{e}{r}' '{o}{t}{a}{t}' '{u}{t}{e}{r}' '{u}{t}{a}{t}' '{oo}{t}{e}{r}' '{oo}{t}{a}{t}' (delete)
    )
  ) //...
```

Also it is possible to show `utf` version (but in less readable format) by this command:

```sh
./snowball -utf8 algorithms/russian.sbl -o tmp -syntax

#=>

define step7
  (
    [
    substring
    ]
    among
      literal 'εστερ'
      literal 'εστατ'
      literal 'οτερ'
      literal 'οτατ'
      literal 'υτερ'
      literal 'υτατ'
      literal 'ωτερ'
      literal 'ωτατ'
      (
        delete
```

### Runing local tests

For checking the correctness of the stemmer you can add some language tests, for ex.:
```sh
ruby ./algorithms/ukrainian/ukrainian_test.rb ../snowball

603 test(s) passed successfully!
```
