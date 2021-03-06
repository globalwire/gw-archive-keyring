# Maintainer notes

## Adding a new team member key

```
make rings/team.gpg
gpg --no-default-keyring \
    --keyring rings/team.gpg \
    --no-auto-check-trustdb \
    --import $KEYFILE
jetring-gen \
    rings/team.gpg~ \
    rings/team.gpg \
    "add kim (ID: 65C26E471F45B123)"
jetring-accept team/ add-65C26E471F45B123 
gpg --output team/index.asc \
    --armor \
    --detach-sign \
    --sign team/index
```

## Adding a new archive key

```
make rings/gw-archive-keyring.gpg
gpg --no-default-keyring \
    --keyring rings/gw-archive-keyring.gpg \
    --no-auto-check-trustdb \
    --import $KEYFILE
jetring-gen \
    rings/gw-archive-keyring.gpg~ \
    rings/gw-archive-keyring.gpg \
    "add gw signing key 2022"
mv add-3A141F1FDB6F0D3E add-gw-signing-key-2022
jetring-accept keys/ add-gw-signing-key-2022
gpg --output keys/index.asc \
    --armor \
    --detach-sign \
    --sign keys/index
```

Note that the filenames used for the changeset filenames must never
be subsets of another changeset filename, or the keyring build will
over-eagerly remove them and then fail.

## Removing an archive key

* Remove `keys/add-$foo`
* Remove the relevant entry from `keys/index`

```
gpg --output keys/index.asc \
    --armor \
    --detach-sign \
    --sign keys/index
```

Confirm that the result was as expected by:

```
make clean
make rings/gw-archive-keyring.gpg
```

and checking the contents of the keyring

## Pre-build

```
gpg --armor --detach-sign rings/gw-archive-keyring.gpg
```
