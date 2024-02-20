import {OpenAPIHono} from '@hono/zod-openapi'
import {serve} from "@hono/node-server";
import {swaggerUI} from "@hono/swagger-ui";
import routes from "routes/route";
import schemas from "schemas/schema";
import {tags} from '~/tags';
import {servers} from "~/servers";

const app = new OpenAPIHono()

app.route("/", routes)
app.route("/", schemas)

// Middleware to serve the Swagger-UI at /api-doc
app.use('/api-doc', swaggerUI({url: '/doc-json'}))

// The OpenAPI documentation will be available at /doc
app.doc('/doc-json', {
    openapi: '3.0.0',
    info: {
        title: "apps/backend/rest-api",
        description: "Backend Representation of GoldNest",
        version: "1.0.0"
    },
    servers: servers,
    tags: tags,
})


const PORT = parseInt(process.env.PORT || "") || 3000
serve({
    fetch: app.fetch,
    port: PORT
}, () => console.log(`🌐Server is running on port ${PORT}`))