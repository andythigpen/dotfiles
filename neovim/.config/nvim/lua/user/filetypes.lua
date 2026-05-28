vim.filetype.add({
    filename = {
        ['Jenkinsfile'] = 'groovy',
        ['.env'] = 'sh',
        ['.env.local'] = 'sh',
    },
    extension = {
        hurl = 'hurl',
    },
})
