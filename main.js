const glob = require('glob')
const promisify = require('util').promisify
const fs = require('fs')


;(async function () {
    const files = await promisify(glob)('./star-wars-armada-data/data/ship-card/**/*.json')

    const ships = files.map((file) => {
        const json = require(file)
        if (!Array.isArray(json)) {
            throw new Error(`Expected array in ${file}`)
        }
        return json
    })
        .reduce((acc, cur) => acc.concat(cur), [])

    fs.writeFileSync('./star-wars-armada-data/data/ship-card.json', JSON.stringify({ ships }, null, 2))
})()
