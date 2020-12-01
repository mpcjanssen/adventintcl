const fs = require('fs')
const { performance } = require('perf_hooks')


const input = fs.readFileSync('input/1.txt', 'utf8')
    .split('\n')
    .filter(c => c)
    .map(c => +c)

const start = performance.now()
for(let i = 0; i < input.length; i++)
    for(let j = i; j < input.length; j++) {
        if(input[i] + input[j] === 2020)
            console.log('p1', input[i] * input[j])

        for(let k = j; k < input.length; k++)
            if(input[i] + input[j] + input[k] === 2020)
                console.log('p2', input[i] * input[j] * input[k])
            
    }

const end = performance.now()
console.log(end-start)
