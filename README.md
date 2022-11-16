# Elm Game of Life

This is a simplistic implementation of the game of life in elm using sets as the
core datastructure. This results in a fairly terse description of the semantics
and avoids all concerns with boundary conditions.

## Building and installing

With elm already installed it should be as simple as

```shell
elm make src/Main.elm
```

and then opening the generated `index.html` in your browser.
