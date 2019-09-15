# readjson [![License][LicenseIMGURL]][LicenseURL] [![NPM version][NPMIMGURL]][NPMURL] [![Dependency Status][DependencyStatusIMGURL]][DependencyStatusURL] [![Build Status][BuildStatusIMGURL]][BuildStatusURL] [![Coverage Status][CoverageIMGURL]][CoverageURL]

Read file and parse it as json.

## Install

```
npm i readjson --save
```
## How to use?

```js
var readjson = require('readjson');

readjson('./package.json', function(error, json) {
    if (error)
        console.error(error.message);
    else
        console.log([
            json.name, json.version
        ].join(' '));
});

try {
    readjson.sync('./package.json');
} catch(error) {
    console.log(error.message);
}

readjson.sync.try('./package.json');
```

## License

MIT

[NPMIMGURL]:                https://img.shields.io/npm/v/readjson.svg?style=flat
[BuildStatusIMGURL]:        https://img.shields.io/travis/coderaiser/node-readjson/master.svg?style=flat
[DependencyStatusIMGURL]:   https://img.shields.io/gemnasium/coderaiser/node-readjson.svg?style=flat
[LicenseIMGURL]:            https://img.shields.io/badge/license-MIT-317BF9.svg?style=flat
[CoverageIMGURL]:           https://coveralls.io/repos/coderaiser/node-readjson/badge.svg?branch=master&service=github
[NPMURL]:                   https://npmjs.org/package/readjson "npm"
[BuildStatusURL]:           https://travis-ci.org/coderaiser/node-readjson  "Build Status"
[DependencyStatusURL]:      https://gemnasium.com/coderaiser/node-readjson "Dependency Status"
[LicenseURL]:               https://tldrlegal.com/license/mit-license "MIT License"
[CoverageURL]:              https://coveralls.io/github/coderaiser/node-readjson?branch=master
