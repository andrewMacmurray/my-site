const fetch = require("node-fetch");
var fs = require("fs").promises;
var path = require("path");

const SPACE_ID = process.env.SPACE_ID
const ACCESS_TOKEN = process.env.ACCESS_TOKEN

const ENDPOINTS = [
    `https://cdn.contentful.com/spaces/${SPACE_ID}/environments/master/entries?access_token=${ACCESS_TOKEN}`
];

ENDPOINTS.forEach(endpoint => createFilesFrom(endpoint));

function createFilesFrom(endpoint) {
    const CONTENT_PATH = "content/blog";

    fetch(endpoint)
        .then(response => response.json())
        .then(response => {
            const data = response

            if (!response) {
                throw new Error("No data response.");
            }

            toPosts(data).forEach(post => {
                const url = slugify(post.title)

                createFile(`${CONTENT_PATH}/${url}.md`, post);
            });
        });
}

function slugify(title) {
    return title.toLowerCase().split(" ").join("-")
}

function toPosts(response) {
    return response.items.map(item => ({body: item.fields.body, title: item.fields.title, date: item.sys.createdAt}))
}

function createFile(filePath, content) {
    fs.mkdir(path.dirname(filePath), {recursive: true}).then(() =>
        fs.writeFile(filePath, `---\n${JSON.stringify({
            type: "blog",
            title: content.title,
            author: "Andrew MacMurray",
            image: "images/article-covers/mountains.jpg",
            draft: false,
            description: "Something about the post",
            published: content.date
        }, null, 2)}\n---\n${content.body}`)
    );
}