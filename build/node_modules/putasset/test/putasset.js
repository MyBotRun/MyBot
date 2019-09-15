'use strict';

const tryToCatch = require('try-to-catch');
const tryTo = require('try-to-tape');
const test = tryTo(require('tape'));
const putasset = require('..');

const empty = () => {};

const owner = 'coderaiser';
const repo = 'putasset';
const tag = 'v1.0.0';

test('arguments: token', async (t) => {
    const [e] = await tryToCatch(putasset, 123, {owner, repo, tag});
    
    t.equal(e.message, 'token must to be a string!', 'should throw when token not string');
    t.end();
});

test('arguments: owner', async (t) => {
    const [e] = await tryToCatch(putasset, '', {repo}, empty);
    
    t.equal(e.message, 'owner must to be a string!', 'should throw when token not string');
    t.end();
});

test('arguments: repo', async (t) => {
    const [e] = await tryToCatch(putasset, '', {owner}, empty);
    
    t.equal(e.message, 'repo must to be a string!', 'should throw when repo not string');
    t.end();
});

test('arguments: tag', async (t) => {
    const [e] = await tryToCatch(putasset, '', {owner, repo}, empty);
    
    t.equal(e.message, 'tag must to be a string!', 'should throw when tag not string');
    t.end();
});

test('arguments: filename', async (t) => {
    const [e] = await tryToCatch(putasset, '', {owner, repo, tag}, empty);
    
    t.equal(e.message, 'filename must to be a string!', 'should throw when filename not string');
    t.end();
});

