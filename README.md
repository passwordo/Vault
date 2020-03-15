![Logo](Assets/Logo.png)

`Vault` - key management core of Passlock.

## Features

- [x] `Master Key` can be of arbitrary length
- [x] Designed with `Migration` in mind
- [x] `Recovery Key` by design
- [x] Different `Serialization` types

### Master Key
`Master Key` - is an arbitrary length piece of Data, note that depending on your case it may be needed to `pad` that data.

### Migration / Upgrade
Designed with `Migration` in mind, current branch is `Vault1` intentionaly as for now it use `20` CPU, and `32MB` of RAM. The idea is, if we need to modify `CPU` or `RAM`, we'll create another branch with this parameters.

### Recovery Key / Intermediate Key
`Intermediate Key` is used as a `Spare Key`, you are responsable to keep it safe. The idea is to not share with someone else your `Master Password` but some random characters. If you don't want to use `Recovery Key` you can safely ignore it.

### Serialization
- [x] `Protobuf`, default
- [x] `JSON`
- [x] Support custom serialization

## Contribute
If you believe you have identified a security vulnerability with `Vault`, you should report it as soon as possible via email to `security@passlock.io`. Please do not post it to a public issue tracker.
