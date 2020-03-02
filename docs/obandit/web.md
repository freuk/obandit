#Obandit

##CLI Interface

Obandit-0.3.4 ships with a helper binary.

For now this binary only runs bandit strategies on csv files:



```bash
obandit --help
```

```
NAME
       obandit - Obandit commandline tool.

SYNOPSIS
       obandit COMMAND ...

COMMANDS
       csv Apply the bandit algorithm on a csv file.

COMMON OPTIONS
       These options are common to all commands.

       --help[=FMT] (default=auto)
           Show this help in format FMT. The value FMT must be one of `auto',
           `pager', `groff' or `plain'. With `auto', the format is `pager` or
           `plain' whenever the TERM env var is `dumb' or undefined.

       --version
           Show version information.

MORE HELP
       Use `obandit COMMAND --help' for help on a single command.
```


```bash
obandit csv --help
```

```
NAME
       obandit-csv - Apply the bandit algorithm on a csv file.

SYNOPSIS
       obandit csv [OPTION]... IN OUT K RATE BANDIT

DESCRIPTION
       Apply the bandit algorithm on a csv file.

COMMON OPTIONS
       These options are common to all commands.

       --help[=FMT] (default=auto)
           Show this help in format FMT. The value FMT must be one of `auto',
           `pager', `groff' or `plain'. With `auto', the format is `pager` or
           `plain' whenever the TERM env var is `dumb' or undefined.

       --version
           Show version information.

       BANDIT (required)
           Bandit type.

       IN (required)
           Input csv.

       K (required)
           Arm count.

       OUT (required)
           Output csv.

       RATE (required)
           Rate.

MORE HELP
       Use `obandit COMMAND --help' for help on a single command.
```
