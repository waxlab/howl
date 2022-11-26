# Howl - Markdown-like documentation generation

## Quickstart

1. Install howl:

```
    luarocks install howl
```

3. Create a `test` folder inside your project

4. Write a Lua script on the file `test/example.lua`

```
    function my_sum(a, b)
        return a+b
    end

    function my_mult(a, b)
        return a*b
    end
```

5. Add comments on your script

```
    --| # My howl test title
    --| This is a common markdown line explaining how it works
    --| spanning through multiple lines.
    --|
    --| And this is another plain text paragraph.
    --|
    --$ my_sum(a: number, b:number) : number
    --{
    function my_sum(a, b)
        return a+b
    end
    --}
    function my_mult(a, b)
        return a*b
    end
```

6. Run howl to extract help and code to your documentation.

```
    howl --from ./test --fmt wiki ./mywiki
```

You will see the `mywiki` folder be created with your documentation.


## Markdown-like

To use `howl` you need to know only how to write Markdown, Lua and the meaning
of 4 marks added after the comment start.

1. `--| ` start a comment line containing pure markdown;
2. `--$ ` start a comment indicating a code signature;
3. `--{` when fills an entire line indicates that the subsequent lines of Lua
code should be included inside the documentation.
4. `--}` when fills an entire line indicates the end of code block that should
be included in the documentation. Basically it closes the block opened by `--{`.

As example, in the resulting markdown from Howl, the example given in quickstart
becomes like this:


        # My howl test title

        This is a common markdown line explaining how it works
        spanning through multiple lines.

        And this is another plain text paragraph.

        ###### my_sum
        - `my_sum(a: number, b:number) : number`

        ```lua
        function my_sum(a, b)
            return a+b
        end
        ```

Observe how the signature is rewritten to the documentation as a title and as
a code markup. Look also how only the marked block between `--{ ` and `--} `
is include and properly marked as Lua code (to be rendered with Lua syntax).


## CLI Options

* `--from <dirname>` Indicates where the Lua and Markdown source files should
be found. You can specify many directories. Howl look for `*.lua` and `*.md`
recursively inside these directories.
* `--fmt <format>` Indicates the target format output. Currently there are only
two formats:
  - `wiki` that generates multiple markdown files, a `Home.md` and a `_Sidebar.md`
to be used in Gitea wiki.
  - `vim` that generates a single text file intended to be used as a vim help.
See the vim or neovim `:help helptags` to understand how to use the generated
vim help file.


## Project status

**Howl** became from the need to provide simple and objective way to document
Lua modules in the [wax](https://codeberg.org/waxlab/wax/wiki) project (look that
for a living example of the result).

It already accomplish the documentation generation for user needs (via Wiki)
and personal/offline needs (via Vim Help). You can annotate any Lua code since
Lua 5.1+, but the Howl executor needs at least 5.2 to make text parsing easier.

You can easily extend it adding new parsers (to read other than Lua and Markdown)
or adding new formatters (like HTML, XML, JSON etc.) Feel free to contribute
to this project.


## Contributing

You can contribute reporting or fixing bugs or sending new formatters/parsers.

In case of contributing with new formatters or parsers, provide examples and
tests and keep the simplicity of code :)
