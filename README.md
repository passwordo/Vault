![Logo](Assets/Logo.png)

[![Build Status](https://travis-ci.org/passlock/Vault.svg?branch=Vault1)](https://travis-ci.org/passlock/Vault)
[![LICENSE](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![swift](https://img.shields.io/badge/swift-5-brightgreen.svg)](https://swift.org)

`Vault` - key management core of Passlock.

## Features

- [x] `Master Key` can be of arbitrary length
- [x] Designed with `Migration` in mind
- [x] `Recovery Key` by design
- [x] Different `Serialization` types

## Installation
#### CocoaPods
```ruby
pod 'Crypto', :git => 'https://github.com/passlock/Crypto.git'
pod 'Vault1', :git => 'https://github.com/passlock/Vault.git'
```

## Usage
#### Create
```swift
let password: String = ...
let databaseEncryptionKey: Bytes = ...


let created = Vault1.create(password: password, master: databaseEncryptionKey, serializer: ProtobufSerializer.self)
```

#### Open
```swift
let openedWithPassword = try Vault1.open(password: password, serialized: created.serialized, serializer: ProtobufSerializer.self)
let openedWithIntermediate = try Vault1.open(intermediate: created.vault.intermediate, serialized: created.serialized, serializer: ProtobufSerializer.self)
```

#### Change
```swift
let changedWithPassword = try Vault1.change(old: password, new: "newPassword", serialized: created.serialized, serializer: ProtobufSerializer.self)
let changedWithIntermediate = try Vault1.change(intermediate: created.vault.intermediate, new: "newPassword", serialized: created.serialized, serializer: ProtobufSerializer.self)
```

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
If you believe you have identified a security vulnerability with `Vault`, please report it as soon as possible via email to `security@passlock.io` and don't post it to a public issue tracker.
