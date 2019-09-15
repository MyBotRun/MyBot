# Checkup

Check arguments and if they wrong throw exeption.

## Install

```
npm i chukup --save
```

## How to use?

```js
var check   = require('checkup');

function someFn(arg1, arg2, arg3) {
    check({
        arg1: arg1,
        arg2, arg2
        arg3: arg3
    });
}

function showName(name, callback) {
    check(arguments, ['name'])
    .check(arguments, ['callback'])
    .type('name', name, 'string')
    .type('callback', callback, 'function');

    console.log('every thing is ok:', name);
}

function callCallback(callback) {
    check([callback], ['callback'])
    .type('callback', callback, 'function');
    
    callback();
}

```

## License

MIT
