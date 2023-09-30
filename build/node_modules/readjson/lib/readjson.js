'use strict';

var fs = require('fs');
var tryCatch = require('try-catch');

module.exports = function(name, callback) {
    check(name);
    checkCB(callback);
    
    fs.readFile(name, 'utf8', function(error, data) {
        var result;
        var json;
        
        if (!error) {
            result = tryCatch(JSON.parse, data);
            error = result[0];
            json = result[1];
        }
        
        callback(error, json);
    });
};

module.exports.sync = sync;

function sync(name) {
    check(name);
    
    var data = fs.readFileSync(name, 'utf8');
    var json = JSON.parse(data);
    
    return json;
}

module.exports.sync.try = function(name) {
    check(name);
    
    var result = tryCatch(sync, name);
    var data = result[1];
    
    return data;
};

function check(name) {
    if (typeof name !== 'string')
        throw Error('name should be string!');
}

function checkCB(callback) {
    if (typeof callback !== 'function')
        throw Error('callback should be function!');
}

