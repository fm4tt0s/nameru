# nameru
 create random IDs or LOTR names - how cool is a jolly-sauron? it started as a silly need to differentiate some application cnfigs on a dashboard; I was not happy to see crazy uuidgens on the screen. so they were 'tolkienized'.

# remarks
 not much original. shameless based on d[docker names-genarator package](https://github.com/docker/docker-ce/blob/master/components/engine/pkg/namesgenerator/names-generator.go) - but with bilbo :)

# usage
```
$ ./names-generator.sh 

Generate random IDs or names built of an adjective + a LOTR character name :)

Usage:
  ./names-generator.sh [-t type] [-m id_model]

Where type in:
  name    : generate a random LOTR name
  id      : generate a random ID

When generating IDs you can specify id_model, as of:
      [8|16|32 as bytes] [l|u|c as case]
      * l = lower / u = upper / c = camel

Example
  Generate a 8bytes lower case id
  ./names-generator.sh -t id -m 8l

  Valid values for id_model are:
      8l|8u|8c    : 8 bytes ID, lower(l) / upper(u) / canel(c) case
      16l|16u|16c : 8 bytes ID, lower(l) / upper(u) / canel(c) case
      32l|32u|32c : 8 bytes ID, lower(l) / upper(u) / canel(c) case

  * if id_model is omitted 16c (16 bytes/camel case) will be used
  ```

# examples #1
```
$ ./names-generator.sh -t name
lazy-legolas
```

# example #2
```
$ ./names-generator.sh -t id -m 32c
m0S4TuPnrbYGQyPQwc6lH0RugtXdjsED
```
