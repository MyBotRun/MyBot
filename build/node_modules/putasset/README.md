# Putasset [![License][LicenseIMGURL]][LicenseURL] [![NPM version][NPMIMGURL]][NPMURL] [![Dependency Status][DependencyStatusIMGURL]][DependencyStatusURL] [![Build Status][BuildStatusIMGURL]][BuildStatusURL]

Upload asset to release on github.

## Install

```
npm i putasset -g
```
## How to use?

### Global

```
$ putasset
Usage: putasset [options]
Options:
  -h, --help      : display this help and exit,
  -v, --version   : output version information and exit,
  -r, --repo      : name of repository,
  -o, --owner     : owner of repository,
  -t, --tag       : tag of repository (shoul exist!),
  -f, --filename  : path to asset
  -tn, --token    : github token <https://github.com/settings/tokens/new>
  -l, --loud      : output filename, owner, repo and tag before upload

$ putasset -tn "token from url" \
-r putasset -o coderaiser -t v1.0.0 \
-f "release.zip"
```
To set token environment variable `PUTASSET_TOKEN` could be used.

### Local

```
npm i putasset --save
```

Data will be read before execution in next order (left is more important):

`command line -> ~/.putasset.json`

### Example

```js
const putasset = require('putasset'),
const token = 'token from https://github.com/settings/applications';

putasset(token, {
    owner: 'coderaiser',
    repo: 'putasset',
    tag: 'v1.0.0',
    filename: 'realease.zip'
}).catch((error) => {
    console.error(error.message);
});
```

## Related

- [grizzly](https://github.com/coderaiser/node-grizzly "Grizzly") - Create release on github with help of node.

## License

MIT

[NPMIMGURL]:                https://img.shields.io/npm/v/putasset.svg?style=flat
[BuildStatusIMGURL]:        https://img.shields.io/travis/coderaiser/node-putasset/master.svg?style=flat
[DependencyStatusIMGURL]:   https://img.shields.io/david/coderaiser/node-putasset.svg?style=flat
[LicenseIMGURL]:            https://img.shields.io/badge/license-MIT-317BF9.svg?style=flat
[NPMURL]:                   https://npmjs.org/package/putasset "npm"
[BuildStatusURL]:           https://travis-ci.org/coderaiser/node-putasset  "Build Status"
[DependencyStatusURL]:      https://david-dm.org/coderaiser/node-putasset "Dependency Status"
[LicenseURL]:               https://tldrlegal.com/license/mit-license "MIT License"

