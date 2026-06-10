This is a codex sandbox with Go lang installed as well as other tools.

First create the docker image:

```
docker build -t codex-dev-agent .
```

Second link the command `codex-go-box` to your bin directory:

```
ln -s `pwd`/codex-go-box ~/.local/bin
```

Now you can start using it, inside any project folder just run:

```
codex-dev-agent
```

This will create a codex sandboxed environment that can only access the current 
folder. Gives it full access to the folder using `--danger-full-access`

