This is a codex sandbox with Go lang installed as well as other tools.

# Creating the container for the first time use

First create the docker image:

```
docker build --no-cache -t codex-dev-agent .
```

# Link to your bin directory

Second link the command `codex-go-box` to your bin directory:

```
ln -s `pwd`/codex-go-box ~/.local/bin
```

# Start using the sandbox

Now you can start using it, inside any project folder just run:

```
codex-dev-agent
```

This will create a codex sandboxed environment that can only access the current 
folder. Gives it full access to the folder using `--danger-full-access`

# To upgrade go version, codex or openspec

To upgrade you need to build the docker image again, running npm inside the
container will not work and will give you permission errors

