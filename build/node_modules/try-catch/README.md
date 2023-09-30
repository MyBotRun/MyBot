# TryCatch

`Try-catch` wrapper.

## Example

```js
const tryCatch = require('tryCatch');
const {parse} = JSON;
const [error, result] = tryCatch(parse, 'hello');

if (error)
    console.error(error.message);

```

## License

MIT

